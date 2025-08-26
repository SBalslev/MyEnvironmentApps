# Extensionarium Property & Lease Management Extension

Version: 0.3.3  
Status: Living Specification (commit to source control)  
Publisher: SBalslev  
Object ID Range: 50000–99999 (per app.json)  
Naming Prefix: `SBX` (AL guideline: clear, unique prefixes)
Root Namespace: (Not set – property unsupported in current target). Continue using SBX prefix; revisit when supported.

---
## 1. Revision History
| Version | Date | Summary |
|---------|------|---------|
| 0.1 | Initial | Skeleton + Q1–Q10 questions |
| 0.2 | After Q1–Q10 decisions | Added concrete data model & workflows |
| 0.3 | After Q11–Q20 decisions | Finalized core model, naming, proration, amendment capture, dimension & billing logic, backlog |
| 0.3.1 | Added Signed fields | Added Signed Date & Signed Document (media) to Lease table |
| 0.3.2 | Namespace | Attempted to add root namespace (unsupported) |
| 0.3.3 | Namespace Removal | Removed unsupported namespace property from app.json; fallback to prefix strategy |
| 0.3.4 | Demo Data Enrichment | Added sample service request, second lease/unit data, default G/L auto-population, additional charge templates |
| 0.4.0 | Role Center & KPIs | Implemented Property Manager Role Center, cue table/part, KPI fields (Expiring Leases <30d, Open SR >7d), runner codeunits & permissions |
| 0.4.1 | Customer Name & KPI | Added Customer Name FlowFields to Lease & Service Request; removed Customer No. from cards (show name only); added Active Customers KPI |

---
## 2. Purpose & Scope
Provide end-to-end management for Properties, Units, Leases, Recurring & Ad‑hoc Charges, Service Requests, Deposits, and related billing within Microsoft Dynamics 365 Business Central, leveraging standard Customers, Sales Invoices, & Dimensions.

Non-Goals (MVP): Full facility maintenance scheduling, vendor portals, IoT sensor ingestion, complex CAM reconciliations, advanced forecasting analytics.

---
## 3. Goals & Success Criteria
- Accurate, auditable recurring rent/service billing (<= 10 min for 100K charges batch target)
- Transparent lease lifecycle with amendment history
- Streamlined service request handling with optional billing
- Strong dimension-driven reporting (Property, Portfolio/Region, Unit)
- Extensible via published integration events

KPIs (initial):
- Monthly charge generation error rate < 0.5%
- Service Request average closure time tracked
- 100% amendments captured with version metadata

---
## 4. High-Level Domain Model
Hierarchy: Property → Unit → Lease → (Recurring Charges, Amendments, Deposits, Service Requests, Meter Readings (phase 2)).  
Tenant represented by standard Customer record (no custom Tenant table).  
Unit occupancy derived from active Lease(s) (1 active lease per Unit enforced).

---
## 5. Key Decisions (Accepted)
| Topic | Decision |
|-------|----------|
| Property/Unit Granularity | Separate tables |
| Tenant Representation | Reuse Customer |
| Lease Versioning | Amendment history table w/ effective dates |
| Recurring Charge Engine | Next-run date per line |
| Meter Charges | Defer (placeholder table) |
| Service Request Depth | Medium (Category, SLA, billing link) |
| Deposit Handling | Separate Deposit Ledger table |
| Dimension Strategy | Property=GlobalDim1, Portfolio/Region=GlobalDim2, Unit as shortcut dimension, others as needed |
| Billing Frequency | Generic interval (n + period type) |
| Posting Strategy | Direct Sales Invoices per lease |
| Unit Code Uniqueness | Unique per Property (composite key) |
| Naming Prefix | `SBX` |
| Lease Numbering | Single global No. Series (future pattern option) |
| Amendment Change Capture | Hybrid: key financial columns + JSON diff |
| Proration Method | Exact daily (calendar days) + per-lease override for 30-day convention (future) |
| Dimension Population | Configurable per Charge Type |
| SR Billing Timing | Configurable global & per Category override |
| Deposit Accounting Posting | Sales Invoice lines to dedicated liability account (via posting group/item) |
| Permission Sets | Hybrid broad + atomic (e.g., POSTING) |
| Test Strategy | Broad functional coverage (lifecycle, amendments, proration, deposits, SR) |

---
## 6. Object Allocation Strategy
| Range | Purpose |
|-------|---------|
| 50000–50049 | Tables |
| 50100–50249 | Pages (list/card/subpages/factboxes) |
| 50300–50449 | Codeunits (management, posting, utilities) |
| 50500–50549 | Enums |
| 50600–50649 | Reports/Request Pages |
| 50700–50719 | Permission Sets |
| 59000–59199 | Test Tables/Codeunits/Pages (internal) |

(Adjust if conflicts found; keep separation for clarity & maintainability.)

---
## 7. Tables (Draft Definitions)
Field lists include essential fields only; add tooltips and extended data types per AL guidelines.

### 50000 SBX Property
- Code (PK, Code[20])
- Name (Text[100])
- Address 1/2, City, Post Code, Country/Region Code
- Status (Enum SBX Property Status)
- Portfolio/Region Code (via GlobalDim2)
- Default Unit Area UoM (Code[10])
- Dimension Set ID (Integer)
- Last Modified (DateTime)

### 50001 SBX Unit
Composite Primary Key: Property Code + Unit Code.  
Secondary unique key for GUID surrogate may be added later for API simplicity.
- Property Code (Code[20])
- Unit Code (Code[20])
- Type (Enum SBX Unit Type)
- Floor (Code[10])
- Area (Decimal)
- Status (Enum SBX Unit Status)
- Out of Service Reason (Text[100])
- Dimension Set ID
- Last Modified

### 50002 SBX Lease
- No. (PK, Code[20])
- Customer No.
- Property Code, Unit Code
- Start Date, End Date
- Move-In Date, Move-Out Date
- Signed Date (Date) (date legally executed)
- Signed Document (Media) (optional scanned/photographic evidence; consider file size best practices)
- Billing Start Date
- Status (Enum SBX Lease Status)
- Billing Frequency Interval (Int), Frequency Type (Enum SBX Charge Frequency Type)
- Base Rent Amount (Decimal)
- Deposit Amount (Decimal)
- Currency Code
- Termination Notice Days (Int)
- Current Version No. (Int)
- Next Amendment Effective Date (Date)
- Last Invoiced Through Date (Date)
- Dimension Set ID
- Created DateTime, Last Modified DateTime

### 50003 SBX Lease Charge Template
- Code (PK)
- Description
- Charge Type (Enum SBX Charge Type)
- Frequency Interval, Frequency Type
- Amount (Decimal)
- Formula (Text[100]) (optional future; for now either Amount or Formula)
- Requires Meter (Boolean)
- Active (Boolean)
- Dimension Behavior (Enum SBX Dimension Behavior) (new per decision C)

### 50004 SBX Recurring Charge Line
- Entry No. (PK, Integer, AutoIncrement)
- Lease No.
- Charge Code
- Charge Type
- Amount (Decimal)
- Frequency Interval, Frequency Type (snapshot)
- Next Run Date, Last Posted Date
- Prorate First, Prorate Last (Boolean)
- Dimension Set ID
- Blocked (Boolean)

### 50005 SBX Service Request
- No. (PK)
- Property Code, Unit Code, Lease No. (optional links)
- Customer No. (optional)
- Reported By (Text[50])
- Source (Enum SR Source)
- Category Code
- Priority (Enum SR Priority)
- Status (Enum SR Status)
- Assigned User ID
- Open DateTime, Respond By DateTime, Resolved DateTime, Closed DateTime
- Billable (Boolean), Billable Amount (Decimal)
- Description (Text[250]), Resolution Notes (Text[250])
- Dimension Set ID

### 50006 SBX Deposit Ledger Entry
- Entry No. (PK)
- Lease No.
- Posting Date
- Amount (Decimal)
- Type (Enum Deposit Entry Type)
- Remaining Amount (FlowField Sum of unapplied)
- Document No., Sales Invoice No.
- User ID, Timestamp

### 50007 SBX Meter Reading (Phase 2 placeholder)
- Entry No. (PK)
- Lease No. / Unit Code
- Meter Type (Enum Meter Type)
- Reading Date
- Reading Value (Decimal)
- Previous Reading (FlowField)
- Consumption (FlowField)
- Billed (Boolean)
- Notes (Text[100])

### 50008 SBX Extensionarium Setup
Singleton pattern (Primary Key Code[10] fixed = 'SETUP').
- Property No. Series, Unit No. Series, Lease No. Series, Service Request No. Series
- Enable Meter (Boolean)
- Enable Consolidated Invoicing (Boolean)
- Unit Shortcut Dimension Code
- Automatic Charge Generation (Boolean)
- Default Charge Posting Description Pattern (Text[100])
- Default Proration Convention (Enum Proration Method) (Exact / Commercial30)
- SR Billing Mode (Enum SR Billing Mode) (Immediate / NextRent / Configurable)

### 50009 SBX Lease Amendment History
- Entry No. (PK)
- Lease No.
- Version No.
- Effective Start Date, Effective End Date
- Base Rent Amount, Billing Interval, Billing Frequency Type, Deposit Amount (key tracked fields)
- Change Diff JSON (BigText) (other changed field values)
- User ID, Timestamp

### 50011 SBX Service Request Category
- Code (PK)
- Description
- Default Priority
- Default Billable (Boolean)
- Billing Mode Override (Enum SR Billing Mode) (optional)

(Additional reference tables may be introduced as requirements emerge.)

---
## 8. Enums (Initial List)
- SBX Property Status: {Active, Inactive}
- SBX Unit Status: {Vacant, Occupied, Reserved, OutOfService}
- SBX Lease Status: {Draft, Active, Suspended, Terminated}
- SBX Charge Frequency Type: {Day, Week, Month, Quarter, Year}
- SBX Charge Type: {BaseRent, Service, Meter, Deposit, Other}
- SBX SR Status: {Open, InProgress, Resolved, Closed}
- SBX SR Priority: {Low, Normal, High, Critical}
- SBX SR Source: {Internal, TenantPortal, Email, Phone, Other}
- SBX Deposit Entry Type: {Collected, Applied, Refunded, Forfeited}
- SBX Meter Type: {Electric, Water, Gas, Other}
- SBX Dimension Behavior: {PropertyOnly, PropertyAndUnit, None}
- SBX Proration Method: {ExactDaily, Commercial30}
- SBX SR Billing Mode: {Immediate, NextRentRun, Configurable}

(All defined as enums to allow future extension; avoid Options per guidelines.)

---
## 9. Pages (Overview)
| Object | Type | Purpose |
|--------|------|---------|
| Property List/Card | List/Card | Manage properties |
| Unit List/Card | List/Card | Manage units + FactBox occupancy |
| Lease List/Card | List/Card | Manage leases; subpages: Charges, History, Deposits |
| Lease Amendment History | ListPart | Embedded history |
| Recurring Charge Lines | ListPart | Lease subpage |
| Recurring Charge Worksheet | Worksheet | Batch preview for due charges |
| Lease Charge Template List/Card | List/Card | Charge templates |
| Service Request List/Card | List/Card | Manage service requests |
| Service Request Category List/Card | List/Card | Maintain categories |
| Deposit Ledger Entries | ListPart | FactBox on Lease & dedicated list |
| Meter Reading Journal/List | Journal/List | (Phase 2) variable billing |
| Extensionarium Setup | Card | Configuration |
| FactBoxes: Lease Summary, Financial Snapshot, Unit Availability | FactBox | Context insight |
| Reports: Rent Roll, Occupancy, Open Service Requests, Lease Expiry | Report | Analytics |

Implemented Role Center (Property Manager) with cues (Active Properties, Active Leases, Active Customers (distinct), Open Service Requests, Pending Charge Lines) plus KPIs: Leases Expiring <30 days, Open Service Requests >7 days old.

---
## 10. Codeunits (Planned)
| ID (range) | Name (tentative) | Responsibility |
|------------|------------------|----------------|
| 50300 | SBX Lease Mgt. | Create/Activate/Terminate lease, validations |
| 50301 | SBX Lease Amendment | Apply amendments, record history |
| 50302 | SBX Charge Engine | Generate charge lines → Sales Invoices |
| 50303 | SBX Proration Helper | Proration calculations (ExactDaily & Commercial30) |
| 50304 | SBX Service Request Mgt. | Status transitions, SLA timestamps |
| 50305 | SBX Deposit Mgt. | Ledger entries, application/refund logic |
| 50306 | SBX Dimension Helper | Dimension propagation per charge type |
| 50307 | SBX Posting Events | Publish integration events around posting |
| 50308 | SBX No. Series Helper | Centralized number assignment |
| 50309 | SBX Setup Mgt. | Access to Setup singleton |
| 50311 | SBX Demo Data Mgmt | Create demo dataset (idempotent) |
| 50320 | SBX Run Charge Engine | Wrapper (UI action) to prompt & execute charge generation |
| 50321 | SBX Create Demo Data | Wrapper (UI action) to invoke demo data creation |
| 50322 | SBX Refresh Cues | Refresh KPI timestamps / counts (lightweight) |
| 50320+ | Future (Meter, Consolidation) | Phase 2 |

(Separation of concerns: minimal logic in table triggers; use codeunits.)

---
## 11. Events (Publishers Planned)
- OnBeforeLeaseActivate(var LeaseRec, var IsHandled)
- OnAfterLeaseActivate(LeaseRec)
- OnBeforeGenerateRecurringCharge(var ChargeLine, PeriodStart, PeriodEnd, var IsHandled)
- OnAfterGenerateRecurringCharge(ChargeLine, SalesLine)
- OnBeforeServiceRequestStatusChange(var SRRec, NewStatus, var IsHandled)
- OnAfterServiceRequestClosed(SRRec)
- OnAfterDepositEntryCreated(DepositEntryRec)

Design: Integration events (not business events initially) per AL guidelines; descriptive naming; avoid breaking changes.

---
## 12. Workflows (Detailed)
### 12.1 Lease Lifecycle
1. Draft → user enters details.
2. Activate: validation (unit vacant, dates valid, base rent > 0); create initial recurring charge lines from templates; set Unit status Occupied.
3. Amend: open Amendment dialog → capture changed values + JSON diff; update lease fields; increment version.
4. Terminate: ensure notice period (Start Date + Notice ≤ Today). Final charges (prorated) generated; deposit applied/refunded; set status Terminated; Unit status Vacant.

### 12.2 Recurring Charge Generation
- Filter Recurring Charge Line where NextRunDate <= WorkDate AND NOT Blocked.
- Determine charge period (previous LastPostedDate+1 → interval end).
- Prorate if first/last flag & partial occupancy.
- Create/append Sales Invoice for Lease (one per lease per batch run). Description pattern from Setup.
- Apply dimension behavior per Charge Type.
- Update LastPostedDate & compute NextRunDate.

### 12.3 Service Request
- New → Open; Respond By = Open + Priority SLA (from Category/Setup).
- Assignment sets InProgress (capture timestamp).
- Resolve sets Resolved (capture resolution notes).
- Close sets Closed; if Billable produce invoice line (timing based on Billing Mode rules).

### 12.4 Deposits
- Collection: Add Deposit Ledger Entry (Collected); optional invoice line (Charge Type Deposit) posts to liability account.
- Application: Entry (Applied) reduces Remaining; may offset final invoice lines.
- Refund/Forfeit: Ledger entry + posting line.

### 12.5 Meter Reading (Phase 2)
- Enter readings; batch variable charge generation merges with charge engine.

---
## 13. Dimension Propagation
Configured at Template (SBX Dimension Behavior).  
Logic:
- PropertyOnly → Set Property dimension; omit Unit.
- PropertyAndUnit → Both Property & Unit dimensions set.
- None → Skip, but still capture Property/Unit fields on lines if required.
Unit dimension stored using configured Shortcut Dim code from Setup. Validation to ensure mapping exists.

---
## 14. Proration
Default at Setup (ExactDaily). Lease can override (future) or per charge line flags.  
ExactDaily: Amount * (BillableDays / TotalDaysInPeriod).  
Commercial30: Amount * (BillableDays / 30).  
Round using standard currency rounding (AL guideline: rely on Currency code/LCY rounding; avoid manual double rounding).

---
## 15. Amendment History (Hybrid)
- Key financial and frequency fields stored as discrete columns in history (~report friendly).
- Additional changed fields serialized as JSON diff (FieldName→OldValue/NewValue).  
- Utility function to expand JSON into temporary table for audit reports.

---
## 16. Posting Strategy
One Sales Invoice per Lease per charge run.  
Potential future enhancement: consolidation by Customer & Period (feature flag).  
Posting lines reference Lease No. & (optionally) Service Request No. for traceability.

---
## 17. Error Handling & Validation Patterns
- Use TryFunctions in management codeunits for external automation; return error text via out parameter rather than generic errors where appropriate.
- Validation sequence: Input (Page) → Management Codeunit (context) → Table modifications.
- Avoid business logic inside page actions (guideline: separation & testability).

---
## 18. Performance Considerations
- Batch process: chunk leases (e.g., 500 at a time) to limit transaction locks.
- Use `SetCurrentKey` & `SetLoadFields` for recurring charge scans.
- FlowFields for aggregation only where needed (Remaining Deposit). Prefetch related dimensions to reduce lookups.

---
## 19. Security & Permissions
Implemented Permission Sets (IDs 50700+):
- SBX_PROPERTY_MGR: Full maintenance & modification rights on core domain tables, modify rights on cue table, execute charge/demo/refresh wrapper & engine codeunits.
- SBX_LEASE_ACCOUNTING: Focus on lease & billing objects plus charge engine execution.
- SBX_SERVICE_DESK: CRUD on service requests & categories with read access to related property/unit/lease.
- SBX_VIEWER: Read-only across domain tables including cues.
- SBX_SETUP (non-assignable): Elevated modify on setup & domain tables + execute demo/charge codeunits.

Recent additions:
- Execute (X) permissions for wrapper codeunits (Run Charge Engine, Create Demo Data, Refresh Cues) and underlying Charge Engine & Demo Data Mgmt where needed.
- Elevated cue table permission (RMID) for roles needing KPI refresh (Property Manager, Setup) to update Last Refreshed.

Guideline: Maintain least privilege; avoid embedding permission logic in AL code; rely on permission evaluation layer.

---
## 20. Testing Strategy
Scope (Phase 1):
- Lease Creation & Activation
- Amendment (version increment, history record)
- Charge Generation (monthly & quarterly scenario, proration)
- Deposit Collection & Application
- Service Request Lifecycle & Billing (Immediate vs NextRentRun)
- Dimension propagation (template behaviors)
Test Tools: AL test codeunits (range 59000+). Use GIVEN/WHEN/THEN naming pattern.
Phase 2: Performance simulation (bulk charge generation), Meter variable billing.

---
## 21. Backlog & Phasing
### Phase 0 – Scaffolding
- Create enums, core tables (Property, Unit, Lease, Setup, Charge Template, Recurring Charge Line, SR Category, Service Request, Deposit Ledger, Amendment History)
- Basic pages (lists/cards) without heavy logic
- Setup page & No. Series integration

### Phase 1 – Core Lease & Charges
- Lease management codeunits & activation logic
- Charge Engine with proration (ExactDaily) & base rent
- Sales Invoice generation (manual post) + dimension propagation
- Amendment history hybrid implementation
- Service Request medium model & billing (configurable timing)
- Deposit ledger & posting integration
- Permission sets (broad + atomic)
- Initial automated tests

### Phase 2 – Enhancements (Updated)
- Meter readings & variable charges
- Consolidated invoice (optional feature flag)
- 30-day proration override per lease
- Email notifications/events
- Performance test suite

### Phase 3 – Analytics & Extensibility
- Additional reports (Turnover, SLA performance)
- API pages for portal integrations
- Additional integration events

---
## 22. Risks & Mitigations
| Risk | Mitigation |
|------|------------|
| Large volume charge generation time | Chunking + key optimization |
| Dimension slot conflicts | Validation in Setup; provide error if misaligned |
| Amendment diff complexity | Hybrid model + JSON parse utility |
| Invoice line explosion (many small charges) | Option to consolidate future; description patterns for grouping |

---
## 23. Open Items (Future)
- Consolidated invoice design
- Lease overlapping reservations (future reservation table?)
- Multi-currency frequency changes mid-lease
- Portfolio level reporting optimization

---
## 24. AL Coding Guideline Highlights (Applied Intent)
- Prefix all objects with `SBX` (naming convention)
- Enums over Options (extensibility)
- Avoid `WITH`; `NoImplicitWith` already set
- Event-driven extensibility (Integration events) – no breaking signature changes
- Separate data (tables) & process (codeunits) for SRP
- Tooltips & captions for all user-facing fields (usability & accessibility)
- Avoid business logic in page triggers (testability)
- Use Clear variable naming; avoid Hungarian notation
- Keep public codeunit procedures minimal & stable; internal helpers local

---
## 25. Next Steps (Implementation Readiness)
1. Confirm spec freeze for Phase 0 scope.
2. Generate AL object stubs (tables/enums/pages) with placeholders.
3. Implement Setup, No. Series, basic validations.
4. Add automated tests for lease activation & simple charge generation.

Addendum (Post 0.4.0): Extend tests to cover demo data idempotency, KPI refresh, and charge engine wrapper execution.

(Respond in repository updates or comments for any adjustments before scaffolding begins.)

---
## 26. Glossary
| Term | Definition |
|------|------------|
| Lease Version | Current effective structural state of a Lease after amendments |
| Amendment History | Record capturing previous versions and changed fields |
| Proration | Proportional calculation of charge for partial period |
| Charge Template | Reusable definition of recurring or service charges applied to leases |
| Charge Line | Instance on a Lease tracking next-run schedule |
| Deposit Ledger | Audit trail of deposit movements |

---
End of SPEC v0.3
