# Rental Property Management (Business Central Extension)

## Overview
Extension delivers core rental property, units, tenants, leases, service request tracking, workflow, KPIs, API exposure, and basic reports.

## Objects Summary
- Tables: Property (50100), Unit (50101), Tenant (50102), Lease (50103), Service Request (50104), Service Request Update (50105), Rental Setup (50106), Rental No. Series State (50108), Rental KPI Buffer (50134)
- Enums: Property/Unit/Tenant/Lease statuses, Service Category/Priority/Status
- Codeunits: Service Request Mgt (50100), Rental No. Series Mgt (50101), Rental KPI Mgt (50135)
- Pages (List/Card/API/Dashboard): Property List/Card, Units, Tenants, Leases, Service Requests (+ updates), Setup, API pages, Dashboard (50136)
- Reports: Occupancy Report (50137), Service Request Overview (50138)
- Queries: Active Lease Count (50110), Service Requests Basic (50111)
- Permission Set: RENTAL MGT (50100)

## Setup Steps
1. Publish & install extension in sandbox.
2. Open "Rental Setup Card" and assign number series codes (create in standard No. Series if available; else fallback incremental series will add numeric suffixes but you must still enter a base code like PROP, UNIT, TEN). 
3. Assign permission set RENTAL MGT to users.
4. Use Property List to create properties; Units to allocate units; Tenants; Leases; Service Requests.
5. Open Rental Dashboard and press Refresh KPIs.

## API Usage
ODataV4 / API endpoints after publishing (version v1.0):
- /api/rental/core/v1.0/properties
- /api/rental/core/v1.0/units
- /api/rental/core/v1.0/tenants
- /api/rental/core/v1.0/leases
- /api/rental/core/v1.0/serviceRequests
- /api/rental/core/v1.0/serviceRequestUpdates

## Workflows
- Service Request status transitions enforced via Service Request Mgt codeunit (actions on list page).
- Lease insertion validates overlapping leases for same unit.
- SLA due auto set on service request insert.
- KPIs refreshed manually (later schedule via job queue).

## Reports
- Occupancy Report: lists units (basic). Future enhancement: occupancy % computation.
- Service Request Overview: status/category snapshot. Add filters in future iteration.

## Next Enhancements (Backlog)
- Improve occupancy calculation (unit-days) & add % to report.
- Add job queue codeunit to auto-refresh KPIs nightly.
- Add cost aggregation and SLA compliance metrics.
- Add attachments & vendor management.
- Extend API filtering & pagination.

## Development Notes
ID Range used 50100-50149 (keep within). Add new objects starting at 50139 upward.

## Testing Suggestions
- Create number series base codes (PROP, UNIT, TEN, LEASE, SR) and verify auto numbering.
- Create overlapping lease attempt -> expect error.
- Create service request then progress through actions to Completed; verify update log entries created.

## License
Internal use sample; customize as needed.
