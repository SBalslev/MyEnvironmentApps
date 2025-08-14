# Rental Property Management Application Specification

## 1. Purpose & Scope
A system to manage rental properties (single- or multi‑unit), tenants, leases, rental periods/occupancy, payments, and service (maintenance) requests. It must provide:
- Central registry of properties, units, and attributes.
- Tracking of who is renting what unit and for which period (active & historical).
- Creation, assignment, progress tracking, and resolution of service requests.
- Reports: (a) Rental coverage / occupancy over a selected period; (b) Service request volume, status distribution, SLA / resolution times, and outcomes over a selected period.
- Extensible foundation for future financial, vendor, and document features.

## 2. High-Level Domain Model
Entities (core first, optional later):
1. Property
2. Unit (optional when a property has multiple rentable units; single-unit properties can have an implicit unit)
3. Tenant
4. Lease (or Tenancy Agreement)
5. Occupancy (derived from Lease + dates; may map 1:1 to Lease or support sub-period changes like temporary vacancy)
6. ServiceRequest
7. ServiceRequestUpdate (status transitions / notes / cost info)
8. Payment (rent payments) [Phase 2]
9. Vendor / Contractor [Phase 2]
10. Attachment / Document [Phase 2]

## 3. Detailed Data Model (Proposed SQL - PostgreSQL Dialect)
Naming standard: snake_case tables; primary keys as id (UUID preferred); created_at/updated_at timestamptz; soft delete via deleted_at nullable.

### 3.1 properties
- id (uuid, pk)
- code (text, unique, short human identifier)
- name (text)
- type (enum: SINGLE_UNIT | MULTI_UNIT)
- address_line1 (text)
- address_line2 (text, nullable)
- city (text)
- state_region (text)
- postal_code (text)
- country (text)
- acquisition_date (date, nullable)
- status (enum: ACTIVE | INACTIVE | SOLD)
- notes (text, nullable)
- created_at / updated_at / deleted_at
Index: (code unique), (status), (city)

### 3.2 units
- id (uuid, pk)
- property_id (uuid fk properties.id)
- unit_label (text)  -- e.g. "Apt 3B" or "Suite 2"
- bedrooms (int, nullable)
- bathrooms (numeric(3,1), nullable)
- square_feet (int, nullable)
- floor (int, nullable)
- market_rent (numeric(12,2), nullable)
- status (enum: AVAILABLE | OCCUPIED | UNDER_MAINTENANCE | INACTIVE)
- created_at / updated_at / deleted_at
Unique: (property_id, unit_label)
Index: (status), (property_id, status)

### 3.3 tenants
- id (uuid, pk)
- first_name
- last_name
- email (text, unique)
- phone (text, nullable)
- status (enum: ACTIVE | FORMER | PROSPECT)
- created_at / updated_at / deleted_at
Index: (last_name, first_name)

### 3.4 leases
Represents contractual lease; allows overlapping only if different unit.
- id (uuid, pk)
- unit_id (uuid fk units.id)
- tenant_id (uuid fk tenants.id)
- start_date (date)
- end_date (date, nullable for month-to-month ongoing)
- rent_amount (numeric(12,2))
- deposit_amount (numeric(12,2), nullable)
- status (enum: DRAFT | ACTIVE | TERMINATED | EXPIRED | FUTURE)
- termination_reason (text, nullable)
- created_at / updated_at / deleted_at
Constraint: (start_date < end_date) when end_date not null.
Index: (unit_id, status), (tenant_id, status), daterange(start_date, end_date) gist for overlap checks.

### 3.5 occupancy_periods (if separate from leases)
Optional if we need partial occupancy gaps or rent holidays.
- id (uuid, pk)
- lease_id (uuid fk leases.id)
- start_date (date)
- end_date (date, nullable)
- override_rent_amount (numeric(12,2), nullable)
- notes (text, nullable)

### 3.6 service_requests
- id (uuid, pk)
- property_id (uuid fk properties.id)
- unit_id (uuid fk units.id nullable if property-level/common area)
- lease_id (uuid fk leases.id nullable)
- reported_by_tenant_id (uuid fk tenants.id nullable)
- category (enum: PLUMBING | ELECTRICAL | HVAC | APPLIANCE | STRUCTURE | PEST | CLEANING | OTHER)
- priority (enum: LOW | MEDIUM | HIGH | EMERGENCY)
- title (text)
- description (text)
- status (enum: NEW | TRIAGED | ASSIGNED | IN_PROGRESS | ON_HOLD | COMPLETED | CANCELLED)
- opened_at (timestamptz default now())
- closed_at (timestamptz, nullable)
- sla_due_at (timestamptz, nullable)
- estimated_cost (numeric(12,2), nullable)
- actual_cost (numeric(12,2), nullable)
- created_at / updated_at / deleted_at
Index: (status), (priority), (property_id, status), (opened_at), (closed_at)

### 3.7 service_request_updates
- id (uuid, pk)
- service_request_id (uuid fk service_requests.id)
- old_status (enum, nullable)
- new_status (enum)
- note (text, nullable)
- changed_by (text or user id placeholder)
- change_time (timestamptz default now())
Index: (service_request_id, change_time desc)

### 3.8 payments (Phase 2)
- id (uuid, pk)
- lease_id (uuid fk leases.id)
- period_start (date)
- period_end (date)
- due_date (date)
- amount_due (numeric)
- amount_paid (numeric default 0)
- paid_date (date, nullable)
- status (enum: PENDING | PARTIAL | PAID | LATE | WAIVED)

### 3.9 vendors (Phase 2)
- id, name, category, contact info, rating, active flag.

### 3.10 attachments (Phase 2)
- id, entity_type, entity_id, filename, mime_type, storage_url, uploaded_at.

## 4. Derived Metrics & Views
- Current Occupancy Rate (%): occupied_units / total_rentable_units for a date or range.
- Average Days to Resolve (service requests): avg(closed_at - opened_at) over period.
- SLA Compliance: % of requests closed before sla_due_at.
- Request Backlog: count(status NOT IN (COMPLETED, CANCELLED)).
- Turnover Rate: number of leases ended in period / average active leases.

## 5. Core Reports (Initial)
### 5.1 Rental Coverage / Occupancy Report
Inputs: date_range (start_date, end_date), property filter optional.
Outputs:
- Total units, occupied unit-days, total unit-days, occupancy %.
- Table per property: property_code, units, occupied_unit_days, occupancy_rate.
- List of vacant periods > configurable threshold.
SQL Sketch (occupancy):
```
WITH days AS (
  SELECT generate_series($1::date, $2::date, interval '1 day')::date AS d
), lease_days AS (
  SELECT l.unit_id, d.d
  FROM leases l
  JOIN days d ON d.d BETWEEN l.start_date AND coalesce(l.end_date, $2::date)
  WHERE l.status IN ('ACTIVE','FUTURE') AND l.start_date <= $2::date
), unit_day_counts AS (
  SELECT u.property_id, u.id AS unit_id,
         count(*) FILTER (WHERE ld.d IS NOT NULL) AS occupied_days,
         count(*) OVER (PARTITION BY u.id) AS total_days
  FROM (SELECT * FROM units WHERE deleted_at IS NULL) u
  CROSS JOIN days
  LEFT JOIN lease_days ld ON ld.unit_id = u.id AND ld.d = days.d
  GROUP BY u.property_id, u.id
)
SELECT p.code, count(DISTINCT unit_id) AS units,
       sum(occupied_days) AS occupied_unit_days,
       sum(total_days) AS total_unit_days,
       round( (sum(occupied_days)::numeric / nullif(sum(total_days),0)) * 100, 2) AS occupancy_pct
FROM unit_day_counts udc
JOIN properties p ON p.id = udc.property_id
GROUP BY p.code
ORDER BY p.code;
```

### 5.2 Service Requests Overview Report
Inputs: date_range (filter by opened_at OR closed_at), property/unit optional, category optional.
Outputs:
- Counts by status, category, priority.
- Average & median resolution time for closed requests.
- SLA compliance %.
- Top recurring categories (by count) & aging (open > X days).
Sample Aggregations:
```
SELECT
  count(*) FILTER (WHERE status = 'COMPLETED') AS completed,
  count(*) FILTER (WHERE status = 'IN_PROGRESS') AS in_progress,
  count(*) FILTER (WHERE status NOT IN ('COMPLETED','CANCELLED')) AS backlog,
  round(avg(closed_at - opened_at),2) AS avg_days_to_resolve,
  percentile_cont(0.5) WITHIN GROUP (ORDER BY (closed_at - opened_at)) AS median_days_to_resolve,
  round( (count(*) FILTER (WHERE closed_at <= sla_due_at AND status='COMPLETED')::numeric /
          nullif(count(*) FILTER (WHERE status='COMPLETED'),0)) * 100,2) AS sla_compliance_pct
FROM service_requests
WHERE opened_at >= $1 AND opened_at < $2;
```

### 5.3 (Optional) Lease Expiry Forecast
List leases ending within next N days; status=ACTIVE.

## 6. Application Layers
- API / Backend: REST or GraphQL. For initial simplicity, REST endpoints under /api.
- Persistence: PostgreSQL (extensions: uuid-ossp or gen_random_uuid(), pgcrypto if needed).
- UI: Web (React / Next.js) or low-code platform; pages enumerated below.
- Auth: Placeholder (JWT or session). Roles: ADMIN, MANAGER, MAINTENANCE, VIEWER, TENANT (future portal).

## 7. Pages / Screens (MVP)
1. Dashboard
   - KPIs: Occupancy %, Active Leases, Open Service Requests, Avg Resolution Time.
2. Properties List
   - Table: code, name, city, units, occupancy %, actions (view/edit).
3. Property Detail
   - Property info; tabs: Units, Active Leases, Service Requests, Documents (later).
4. Unit Detail
   - Unit attributes, current lease, upcoming vacancy, related service requests.
5. Tenants List & Detail
6. Leases List
   - Filters: status, date range, property, tenant.
7. Lease Create/Edit
8. Service Requests List
   - Filters: status, priority, category, property, aging buckets.
9. Service Request Detail
   - Timeline of updates; edit status; cost fields.
10. Create Service Request (modal or page)
11. Reports
    - Occupancy Report page (filter form + table + export CSV)
    - Service Requests Overview (charts: status distribution, category breakdown, SLA compliance, aging)
12. Admin Settings (enums management if dynamic, user roles) [Phase 2]

## 8. Core API Endpoint Sketch (REST)
Base: /api/v1
- GET /properties, POST /properties, GET /properties/{id}, PATCH /properties/{id}
- GET /properties/{id}/units, POST /properties/{id}/units
- GET /units/{id}, PATCH /units/{id}
- GET /tenants, POST /tenants, GET /tenants/{id}, PATCH /tenants/{id}
- GET /leases, POST /leases, GET /leases/{id}, PATCH /leases/{id}
- GET /service-requests, POST /service-requests
- GET /service-requests/{id}, PATCH /service-requests/{id}
- POST /service-requests/{id}/updates
- GET /reports/occupancy?start=&end=&property_id=
- GET /reports/service-requests?start=&end=&property_id=&group_by=

Pagination via limit & cursor; consistent error format: { "error": { "code": "...", "message": "...", "details": {...}} }.

## 9. Business Rules
- A unit can have at most one ACTIVE lease overlapping a given date.
- Lease status auto-transitions: becomes ACTIVE on start_date if not terminated; becomes EXPIRED day after end_date.
- Service request SLA: emergency default 4 hours, high 24h, medium 72h, low 120h (configurable); sla_due_at computed on creation.
- Closing a service request sets closed_at and final status must be COMPLETED or CANCELLED.
- Occupancy calculation ignores units with status INACTIVE.

## 10. State Machines
### Service Request Status Flow
NEW -> TRIAGED -> ASSIGNED -> IN_PROGRESS -> COMPLETED
Any -> ON_HOLD -> (return to previous active state)
Any -> CANCELLED

### Lease Lifecycle
DRAFT -> ACTIVE -> (TERMINATED | EXPIRED)
ACTIVE -> TERMINATED (early) or EXPIRED (natural end)

## 11. Non-Functional Requirements
- Auditability: store status changes in service_request_updates.
- Performance: Occupancy report for 2 years range under 3 seconds with up to 10k units (optimize with precomputed materialized view later).
- Security: Role-based access; tenant role restricted to own lease & service requests.
- Observability: structured logs (json) level = info, warn, error.
- Internationalization: currency formatting configurable; time zone UTC internal.

## 12. Suggested Index & Optimization Roadmap
Phase 1: Basic indexes defined above.
Phase 2: Add materialized view monthly_occupancy(property_id, unit_id, year_month, occupied_days, total_days) refreshed nightly.

## 13. Sample Seed Data Outline
- 3 properties (1 multi-unit with 5 units, 2 single-unit).
- 6 tenants, 4 active leases, 1 future lease.
- 8 service requests across categories & statuses.

## 14. Reporting Accuracy Considerations
- Time zone normalization (store timestamptz UTC; convert on display).
- Partial day handling: occupancy counts days inclusive of start & end; ensure end_date null interpreted as open-ended.
- Cancelled leases excluded from occupancy once terminated_date reached.

## 15. Future Extensions
- Rent invoicing & arrears tracking.
- Vendor assignment to service requests.
- Document uploads (lease PDFs, photos of issues).
- Notifications (email/SMS) for SLA breaches or upcoming lease expiries.
- Tenant self-service portal.

## 16. Acceptance Criteria (MVP)
1. CRUD for Property, Unit, Tenant, Lease, Service Request via API.
2. Occupancy report returning JSON with property breakdown & overall metrics for given date range.
3. Service request overview report returning metrics (counts, avg & median resolution, SLA %).
4. Status transitions validated per state machine; improper transition blocked with 400.
5. Automatic sla_due_at computed based on priority mapping.
6. Closed service requests have closed_at populated exactly once.

## 17. File & Naming Conventions
- Backend modules under /server (future) with feature-based folders (properties, leases, service_requests, reports).
- Frontend under /web with pages mirroring feature names.
- Shared DTO / types in /shared.
- Database migration files: /migrations/2025MMDDHHMM__description.sql.

## 18. Environment & Config (Planned)
Environment variables:
- DATABASE_URL
- PORT (default 8080)
- LOG_LEVEL (info|debug|warn|error)
- JWT_SECRET (future)
- SLA_EMERGENCY_HOURS, SLA_HIGH_HOURS, SLA_MEDIUM_HOURS, SLA_LOW_HOURS (override default SLA windows)

## 19. Glossary
- Occupancy Day: A calendar day where a unit is covered by an active lease (start <= day <= end or open-ended).
- Rental Coverage: Same as occupancy rate.
- SLA: Service Level Agreement target resolution time.

## 20. Implementation Phasing (Recommendation)
Phase 1: Core schema (properties, units, tenants, leases, service_requests, service_request_updates), occupancy & service reports (runtime queries), REST API basics.
Phase 2: Payments, vendors, attachments, materialized views, authentication & roles.
Phase 3: Tenant portal, notifications, advanced analytics, performance tuning.

---
This specification serves as the authoritative context for subsequent development tasks in this repository.

## 21. UX Principles & Design Goals
Guiding principles to ensure a user-friendly experience:
- Clarity: Present only the fields and actions relevant to the current task; progressive disclosure for advanced data.
- Consistency: Uniform layout (title, primary actions top-right, tabs below header, content area with consistent spacing).
- Feedback: Every user action yields immediate visual feedback (loading spinners, optimistic updates where safe).
- Accessibility: WCAG 2.1 AA target (semantic HTML, keyboard navigation, color contrast, ARIA for dynamic regions).
- Efficiency: Common workflows executable within 3 clicks from dashboard (e.g., Create Service Request, Renew Lease).
- Resilience: Draft autosave for long forms (lease creation, service request) every 10 seconds or on blur.
- Transparency: Show status histories (leases, service requests) in timeline format with relative + absolute timestamps.

## 22. Navigation & Information Architecture
- Global Top Bar: App logo/title, global search (property/unit/tenant/service req), quick create dropdown, user menu.
- Left Sidebar (collapsible): Dashboard, Properties, Units, Tenants, Leases, Service Requests, Reports, Settings (phase 2).
- Breadcrumbs: e.g., Properties > P-ACME-001 > Units > Apt 3B.
- Tabs on detail pages: For Property (Overview | Units | Leases | Service Requests | Documents*), for Service Request (Overview | Timeline | Costs | Attachments*).
- Responsive: Sidebar collapses to icon rail < 1200px, slide-out menu < 768px.

## 23. Key User Flows (Happy Path + Edge Cases)
### 23.1 Create & Assign Service Request
1. From Dashboard quick create -> Service Request modal.
2. User selects Property first (autocomplete), then Unit filtered by property.
3. Priority default MEDIUM; SLA due preview updates when priority changes.
4. On submit, modal closes, toast "Service request SR-2025-001 created" with link.
5. Detail page shows status NEW with prominent Next Action button "Triage".
6. Edge: If duplicate (same unit + same category + open in last 7 days) show inline warning with link to existing.

### 23.2 Lease Creation
1. Start from Unit Detail (faster pre-selection) or Leases List.
2. Form validates overlapping by calling availability endpoint after start/end entered; inline warning appears with conflict list.
3. On save (DRAFT), user can Activate immediately (button) or leave as draft.
4. Activating triggers recalculation of occupancy caches (future optimization hook).

### 23.3 Occupancy Report Generation
1. Navigate Reports > Occupancy.
2. Date range preset: This Month, Last Month, Last 90 Days, Custom.
3. User clicks Generate; show skeleton rows (shimmer) until data returns.
4. Provide Export (CSV) and Copy Summary; export respects current filters.

### 23.4 Service Request Completion
1. Technician updates status to IN_PROGRESS (adds note + optional cost estimate).
2. On completion form requires resolution note + actual cost; if cost > estimate > threshold (e.g., 10%) warn confirmation.
3. Closed badge with resolution time chip (e.g., "Resolved in 1d 4h (Met SLA)").

## 24. Forms & Validation Standards
- Real-time validation on blur and submit; errors listed at top if multiple.
- Required fields marked with * and aria-required; avoid placeholder-only labels (always persistent label above field).
- Date pickers with keyboard support (arrow navigation) & manual entry; enforce ISO date on backend.
- Monetary fields: localized formatting on blur; internal value numeric.
- Auto-format phone numbers (country configurable later).
- Inline dropdown search for long lists (>12 options).
- Prevent accidental loss: confirm dialog if navigating away with dirty form.

## 25. Empty, Loading & Error States
- Empty Lists: Provide contextual action ("No service requests yet" + button Create Service Request).
- Loading: Use skeleton placeholders for tables/cards (3–5 rows) rather than generic spinners.
- Partial Failure: If a panel fails (e.g., timeline) show inline retry without blocking rest of page.
- Global Error Boundary: Friendly message + support reference code (UUID) logged server-side.

## 26. Accessibility & Internationalization Enhancements
- Keyboard shortcuts: g p (go properties), g r (reports), / (focus global search), c s (create service request).
- Focus management: On modal open focus first input; on close return focus to triggering element.
- Announce status changes via ARIA live region (e.g., "Service Request status updated to In Progress").
- Color contrast: Minimum 4.5:1; do not rely on color alone for priority (add icon/label).
- Timezones: Display in user local with tooltip showing UTC; allow profile preference override.
- Translatable strings central file (phase 2); avoid concatenated dynamic string fragments.

## 27. Performance / Perceived Performance
- API pagination defaults: 25 rows; allow 25/50/100.
- Debounced search (300ms) for global search & filters.
- Optimistic UI: Status update on service request shows immediately; rollback if server rejects.
- Cache recent report parameters in local storage for fast re-run.
- Lazy load heavy charts when scrolled into view.

## 28. Data Visualization Guidelines
- Occupancy: Use horizontal bar per property + overall gauge style badge.
- Service Requests: Stacked bar by priority over time; donut for category distribution; line for average resolution days trend.
- Color Palette: Priority (Emergency #B00020, High #D32F2F, Medium #F57C00, Low #0288D1) ensuring color-blind safe (provide pattern or icon overlay for Emergency/High).

## 29. Search, Filter, Sort & Bulk Actions
- Global Search multi-entity: results grouped (Properties, Units, Tenants, Requests) with keyboard navigation.
- List Filters persist in URL query params; shareable links.
- Bulk actions (phase 2): Close multiple resolved requests, export selected leases.
- Sort indicators (ascending/descending) with single-click toggle; multi-sort (shift+click) optional phase 2.

## 30. Notifications & Activity Timeline
- In-app notifications bell: new service request assigned, lease expiring (30 days), SLA breach approaching (2 hours left).
- Timeline entries standardized: [Icon] [Actor] [Action] [Entity/Status] [Relative time] (absolute tooltip).
- Support filter timeline by type (Status Change, Note, Cost Update).

## 31. Security & Privacy UX
- Role-based UI hiding (not just disabling) features user cannot access.
- Confirm dialogs for destructive actions (Delete Property, Cancel Service Request) with summary of impact.
- PII masking option for former tenants (show initials only) after configurable retention period.

## 32. Onboarding & Help
- First-login guided tour (optional skip) highlighting Dashboard KPIs, Quick Create, Reports.
- Contextual help icons linking to documentation anchors (# section IDs in docs site).
- Inline glossary tooltips on hover for Occupancy, SLA, etc.

## 33. Revised & Expanded Acceptance Criteria (UX Additions)
7. All forms display inline validation errors and prevent submission with descriptive messages.
8. Service request status update appears in UI within 250ms (optimistic) barring network failure.
9. Occupancy report generation provides loading skeleton state; no layout shift after load.
10. Keyboard navigation (tab order) reaches all interactive elements; focus outline visible.
11. Empty states for each primary list (properties, units, leases, service requests, reports) include at least one primary call-to-action.
12. Color contrast tests pass automated tooling (axe-core) for core pages.
13. Global search returns results across entities in < 1.5s for dataset up to 50k combined records (assuming indexed queries).
14. Timeline shows newest 20 events with lazy load; each event includes actor, timestamp, and action summary.
15. URL-based filters reproducible (copy/paste URL rehydrates filter state).

## 34. Open Questions / Decision Log (To Maintain)
- Should occupancy treat future leases starting >30 days out as reserved units? (Default: No.)
- SLA breach notifications: email vs in-app only first phase? (Default: In-app only.)
- Payment integration timeline? (Pending product prioritization.)
- Attachment storage: local vs cloud object store? (Evaluate in Phase 2.)

## 35. Implementation Notes for Developers (UX Integration)
- Provide global event bus (e.g., simple pub/sub) for toast notifications and timeline refresh triggers.
- Central hooks (React example): useFormValidation(schema), useEntitySearch(entityType), useOptimisticMutation(key,...).
- Error boundary component logs via central logger before user-facing fallback.
- Theming system tokens (spacing, colors, typography) defined early to avoid hard-coded styles.

---
UX enhancements appended; this document now includes user experience design guidance alongside functional specification.
