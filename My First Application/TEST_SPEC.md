# Rental Management Extension Test Specification

Version: 0.1 (Living Document)
Author: Auto-generated baseline

## 1. Purpose
Provide a complete test blueprint for the Rental Property Management Business Central extension. Defines WHAT to test, WHY (acceptance criteria mapping), and HOW at a high level. Implementation of tests will use the AL Test Framework in future iterations.

## 2. In Scope
Core domain objects and logic delivered to date:
- Tables: Property, Unit, Tenant, Lease, Service Request, Service Request Update, Rental Setup, Rental No. Series State, Rental KPI Buffer
- Enums: All status/category/priority enums
- Codeunits: Service Request Mgt, Rental No. Series Mgt (with fallback), Rental KPI Mgt
- Pages: Lists, Cards, Setup, Dashboard, API pages
- Reports: Occupancy Report, Service Request Overview
- Queries: Active Lease Count, Service Requests Basic
- Permission Set: RENTAL MGT

Out of current scope (placeholder future): Payments, Vendors, Attachments, Advanced Occupancy (unit-day), SLA compliance materialization, Job Queue scheduling.

## 3. Test Categories
1. Unit Tests (codeunit logic: transitions, calculations, validation)
2. Functional / Integration (CRUD flows, number series, lease overlap, service request lifecycle)
3. API Contract & Behavior (CRUD, filters, error handling)
4. Security & Permissions (positive/negative access based on permission set)
5. Data Integrity (constraints, non-overlap, status derivation)
6. Reporting Accuracy (dataset correctness, filter honoring)
7. KPI Calculation (values, rounding, edge cases)
8. Performance (indicative: execution time boundaries for key operations)
9. Upgrade / Stability (ID stability, no breaking rename assumptions)
10. Negative / Error Handling (invalid transitions, missing setup, missing number series)

## 4. Traceability Matrix (Acceptance Criteria Mapping)
| Acceptance Criterion | Spec Section Ref | Test IDs |
|----------------------|------------------|----------|
| CRUD entities working | Spec 16.1 | F-CRUD-PROP-01 .. F-CRUD-SR-05 |
| Occupancy report returns JSON / dataset | 16.2 | R-OCC-01..05 |
| Service request overview metrics | 16.3 | R-SR-OV-01..06 |
| Status transitions validated | 16.4 | SR-TR-01..10 |
| SLA due calculated | 16.5 | SR-SLA-01..04 |
| Closed requests closed_at set once | 16.6 | SR-CLOSE-01..03 |
| UX validations (inline, empty states etc.) | 33.7-15 | UX-VAL-01..08 |
| Overlap prevention for leases | Business Rules | L-OVR-01..05 |
| Auto lease status derivation | Lifecycle | L-STAT-01..06 |
| Number series assignments | Setup logic | NS-ASSIGN-01..06 |
| KPI refresh values | KPI design | KPI-01..08 |

## 5. Test Inventory (Abbreviated)
Format: ID | Category | Title | Level | Priority | Preconditions | Expected Outcome

### 5.1 Entity CRUD
- F-CRUD-PROP-01 | Functional | Create Property with auto number | Integration | High | Setup configured | Property record inserted, ID assigned from series
- F-CRUD-UNIT-01 | Functional | Create Unit, link to Property | Integration | High | Property exists | Unit created, Property ID validated
- F-CRUD-TEN-01 | Functional | Create Tenant | Integration | Medium | Setup | Tenant No. assigned
- F-CRUD-LEASE-01 | Functional | Create Lease Active (start <= today) | Integration | High | Unit free | Lease status Active
- F-CRUD-SR-01 | Functional | Create Service Request with priority Medium | Integration | High | Setup | SLA Due = today midnight + 72h (adjusted)

### 5.2 Lease Overlap & Status
- L-OVR-01 | Validation | Insert overlapping lease (same unit date intersection) | Unit | High | Existing active/future lease | Error raised with overlap message
- L-STAT-01 | Lifecycle | Future lease status | Unit | Medium | Start > today | Status = Future
- L-STAT-04 | Lifecycle | Expired lease after end date +1 | Integration (time travel) | Medium | Lease with past end | Status recalculated to Expired (simulate OnModify / process)

### 5.3 Service Request Workflow
- SR-TR-01 | Workflow | New -> Triaged valid | Unit | High | New SR | Status updated, update row inserted
- SR-TR-02 | Workflow | New -> Assigned invalid | Unit | High | New SR | Error invalid transition
- SR-TR-05 | Workflow | In Progress -> Completed sets Closed At | Integration | High | SR in progress | Closed At set, update logged
- SR-SLA-02 | SLA | Emergency 4h SLA | Unit | High | Priority Emergency | SLA Due At within 4 hours window (UTC logic)
- SR-CLOSE-02 | Closing | Re-close Completed SR | Unit | Medium | SR Completed | Error cannot transition from closed

### 5.4 Number Series
- NS-ASSIGN-01 | Numbering | Create property no series configured -> Error | Integration | High | Setup blank property nos | Error missing config
- NS-ASSIGN-02 | Numbering | Auto increment pattern fallback | Unit | Medium | Fallback active | Second insert increments numeric suffix

### 5.5 KPI
- KPI-01 | KPI | Refresh sets Occupancy% with active units | Integration | Medium | Units & leases exist | Value > 0 and <= 100
- KPI-03 | KPI | No active leases -> Occupancy 0 | Unit | Low | No leases | KPI value 0
- KPI-05 | KPI | Avg resolution hours computed | Integration | Medium | Completed SR with known duration | Hours matches expected rounding

### 5.6 Reports
- R-OCC-01 | Report | Occupancy Report excludes inactive units | Integration | Medium | Mixed statuses | Only non-inactive rows
- R-SR-OV-02 | Report | Service Request Overview includes closed dates | Integration | Medium | Completed SR | Closed date visible

### 5.7 Permissions
- SEC-PERM-01 | Security | User w/out RENTAL MGT cannot insert Lease | Security | High | Test user no perm | Permission error
- SEC-PERM-03 | Security | User with RENTAL MGT full CRUD | Security | High | Test user assigned | CRUD succeeds

### 5.8 API
- API-PROP-GET-01 | API | GET properties returns list | API | High | At least 1 property | 200 + JSON array
- API-SR-POST-01 | API | POST serviceRequests creates record & SLA | API | High | Proper payload | 201, SLA Due At populated
- API-LEASE-OVERLAP-01 | API | POST overlapping lease -> 400 style error | API | High | Existing lease | Error

### 5.9 Negative Cases
- NEG-SR-STATUS-01 | Negative | Completed -> In Progress invalid | Unit | High | Completed SR | Error
- NEG-LEASE-ENDDATE-01 | Negative | End date before start | Unit | Medium | Invalid dates | Reject (future enhancement if not yet enforced)

### 5.10 Performance (Baseline Targets)
- PERF-KPI-01 | Performance | RefreshKPIs completes < 2s with 500 leases | Perf | Medium | Seed data | Duration recorded
- PERF-API-SR-LIST-01 | Performance | GET serviceRequests < 1s for 500 open SRs | Perf | Medium | Seed many SRs | Duration

## 6. Detailed Example Test Case Template
Example: SR-TR-01 New -> Triaged
- Pre: Service Request with Status=New
- Steps: Call UpdateStatus(NewStatus=Triaged, Note='Triaging')
- Assert: Status=Triaged; Service Request Update entry created with Old=New, New=Triaged; Closed At unchanged.
- Edge: Re-running transition should error.

## 7. Test Data Strategy
Seed script / test codeunit to create deterministic data sets:
- Series seeds: PROP0000, UNIT0000, TEN0000, LEASE0000, SR0000
- Properties: 2 (multi + single)
- Units: 5 across properties
- Tenants: 4
- Leases: Active, Future, Expired scenario
- Service Requests: Mix of priorities + one completed with known 8h span

## 8. Automation Architecture
- AL Test App (separate test extension) referencing main extension.
- Folders: /test/src/** (future), codeunits: 90000-90049 range.
- Base Test Codeunit: TestInitialize to create setup + number series.
- Utility Codeunit: Factory methods (CreateProperty, CreateUnit, CreateLease, CreateServiceRequest).
- Assert Module: Use standard Library Assert (if base installed) or custom simple assertions.

## 9. Mocking & Isolation
- SLA calculations: direct (no external dependency).
- Number series fallback: test deterministic by setting base code then creating sequential records.
- Time dependent tests: Use WorkDate override or wrap date/time access in helper (future refactor) for deterministic tests.

## 10. Non-Functional Test Guidelines
- Performance: Use Chrono Management (if available) or manual timing with NOW before/after; only indicative.
- Security: Execute with two different user contexts (or simulate permission removal using AL test library patterns).

## 11. Risk & Gap Analysis
| Area | Current Risk | Planned Mitigation |
|------|--------------|--------------------|
| Lease Expiry automation | Manual recalculation only | Future job queue test cases |
| SLA compliance metrics | Not implemented | Add when KPI extended |
| Overlap logic edge (open-ended leases) | Large future-dated end might pass | Add test with null end + future start |
| Time zone sensitivity | Using CurrentDateTime directly | Introduce abstraction for time in tests |

## 12. Prioritization (High First)
1. Lease overlap & status
2. Service request transitions + SLA
3. Number series correctness
4. KPI calculations
5. Permissions / security
6. API CRUD + errors
7. Reports dataset completeness

## 13. Coverage Goals
- Functional acceptance criteria: 100% (mandatory)
- Codeunit public procedures: >= 90% invocation
- Error branches in transitions: >= 90%
- Negative tests at least one per invalid path

## 14. Future Expansion Placeholders
- Payment posting tests (rent arrears scenario)
- Vendor assignment workflow tests
- Occupancy unit-day calculation (materialized view) tests
- SLA breach notification (job queue) tests

## 15. Implementation Checklist (When Implementing)
- [ ] Create test app manifest (id range separate)
- [ ] Add dependency on main app
- [ ] Seed factory codeunit
- [ ] Implement high-priority tests (sections 12/13)
- [ ] Integrate into pipeline (AL-Go / GitHub Actions) with artifact publishing
- [ ] Track coverage metrics (if tool support present)

---
This document will evolve alongside future features. Update test IDs and mapping when new acceptance criteria are added.
