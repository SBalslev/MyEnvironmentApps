# Item Certification - Test Suite

This test app contains comprehensive, self-contained tests for the Item Certification extension.

## Overview

The tests are designed to be **self-contained** and **independent**:
- They create their own test data
- They don't depend on existing data in the database
- Each test method is isolated and can run independently
- Tests use simple error checking rather than external test libraries

## Test Codeunits

### 1. Furniture Cert Tests (Codeunit 50120)

Tests the core certificate functionality and status management.

**Test Methods:**
- `TestCertificateStatusActive` - Verifies certificates without dates are Active
- `TestCertificateStatusPending` - Verifies future certificates are Pending
- `TestCertificateStatusExpired` - Verifies past certificates are Expired
- `TestCertificateStatusActiveWithinRange` - Verifies current certificates are Active
- `TestCertificateStatusSuspendedStaysSuspended` - Verifies suspended status persists
- `TestCertificateInvalidDateRange` - Verifies date validation (Valid From before Valid To)
- `TestCertificateDeleteCascadesToAssignments` - Verifies cascade delete to assignments
- `TestCertificateStatusUpdatesOnInsert` - Verifies status is auto-calculated on insert
- `TestCertificateStatusUpdatesOnModify` - Verifies status is recalculated on modify

### 2. Furniture Cert Assign Tests (Codeunit 50121)

Tests the assignment of certificates to items with validation logic.

**Test Methods:**
- `TestAssignmentInitializesDatesFromCertificate` - Verifies date inheritance
- `TestAssignmentKeepsSpecifiedDates` - Verifies user-specified dates are respected
- `TestAssignmentFailsWithExpiredCertificate` - Verifies expired certificates cannot be assigned
- `TestAssignmentFailsWhenStartBeforeCertificateStart` - Verifies date boundary validation
- `TestAssignmentFailsWhenEndAfterCertificateEnd` - Verifies date boundary validation
- `TestAssignmentFailsWithInvalidDateRange` - Verifies assignment date range validation
- `TestAssignmentFailsWithOverlappingSameCertificateType` - Verifies no overlapping same-type certs
- `TestAssignmentAllowsOverlappingDifferentCertificateTypes` - Verifies different types can overlap
- `TestAssignmentAllowsNonOverlappingSameCertificateType` - Verifies sequential same-type certs
- `TestAssignmentSetsCreatedByAndCreatedAt` - Verifies audit fields are populated
- `TestAssignmentModifyUpdatesValidation` - Verifies validation on modify

## Running the Tests

### Option 1: Using VS Code AL Extension

1. Open the test workspace in VS Code
2. Press `Ctrl+Shift+P` and select "AL: Test Tool"
3. Select the test codeunit you want to run
4. Click "Run All" or select individual test methods

### Option 2: Using Test Runner

You can create a test runner codeunit to automate test execution:

```al
codeunit 50199 "Test Runner"
{
    Subtype = TestRunner;

    trigger OnRun()
    begin
        Codeunit.Run(Codeunit::"Furniture Cert Tests");
        Codeunit.Run(Codeunit::"Furniture Cert Assign Tests");
    end;
}
```

## Test Design Principles

### Self-Contained Data Creation
Each test creates its own data using helper methods:
- `CreateCertificate()` - Creates test certificates
- `CreateItem()` - Creates test items
- `CreateAssignment()` - Creates test assignments
- `GetNextTestCode()` - Generates unique codes for test records

### Simple Assertions
Tests use simple `if` statements and `Error()` calls instead of external assert libraries:

```al
if CertStatus <> Certificate.Status::Active then
    Error('Certificate without dates should be Active');
```

### Error Testing
Tests verify error conditions using `asserterror` and `GetLastErrorText()`:

```al
asserterror Assignment.Insert(true);
if StrPos(GetLastErrorText(), 'expired and cannot be assigned') = 0 then
    Error('Expected error about expired certificate');
```

### No External Dependencies
The tests don't require:
- Library Assert codeunit
- Library Random codeunit
- Existing demo data
- External test frameworks

## Test Coverage

The tests cover:
- ✅ Certificate status evaluation logic
- ✅ Date validation rules
- ✅ Cascade delete behavior
- ✅ Assignment validation rules
- ✅ Overlap detection for same certificate types
- ✅ Date inheritance from certificates to assignments
- ✅ Audit field population
- ✅ Error conditions and boundary cases

## Future Enhancements

Potential areas for additional tests:
- Page interactions using Test Pages
- Integration with Item table extensions
- Permission set validation
- Multi-certificate scenarios per item
- Edge cases with WorkDate() vs Today
- Performance tests with large datasets

## Notes

- Tests use the ID range 50120-50149 (within the test app's 50100-50149 range)
- Main app uses 50100-50149
- Tests are isolated from each other via unique code generation
- Tests don't require cleanup as they run in separate transactions
