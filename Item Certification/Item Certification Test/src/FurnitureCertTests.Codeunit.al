namespace org.mycompany.customers.cronus.sales.item.certification;

using Microsoft.Inventory.Item;

codeunit 50120 "Furniture Cert Tests"
{
    Subtype = Test;
    TestPermissions = Disabled;
    TestType = UnitTest;
    RequiredTestIsolation = Function;

    var
        TestCounter: Integer;

    [Test]
    procedure TestCertificateStatusActive()
    var
        Certificate: Record "Furniture Certificate";
        CertificateMgt: Codeunit "Furniture Certificate Mgt";
        CertStatus: Enum "Furniture Certificate Status";
    begin
        // [SCENARIO] Certificate with no dates should be Active
        // [GIVEN] A certificate with no Valid From or Valid To dates
        CreateCertificate(Certificate, 0D, 0D);

        // [WHEN] Status is evaluated
        CertStatus := CertificateMgt.EvaluateStatus(Certificate);

        // [THEN] Status should be Active
        if CertStatus <> Certificate.Status::Active then
            Error('Certificate without dates should be Active');
    end;

    [Test]
    procedure TestCertificateStatusPending()
    var
        Certificate: Record "Furniture Certificate";
        CertificateMgt: Codeunit "Furniture Certificate Mgt";
        CertStatus: Enum "Furniture Certificate Status";
    begin
        // [SCENARIO] Certificate with future Valid From date should be Pending
        // [GIVEN] A certificate with Valid From in the future
        CreateCertificate(Certificate, CalcDate('<+30D>', WorkDate()), CalcDate('<+1Y>', WorkDate()));

        // [WHEN] Status is evaluated
        CertStatus := CertificateMgt.EvaluateStatus(Certificate);

        // [THEN] Status should be Pending
        if CertStatus <> Certificate.Status::Pending then
            Error('Certificate with future start date should be Pending');
    end;

    [Test]
    procedure TestCertificateStatusExpired()
    var
        Certificate: Record "Furniture Certificate";
        CertificateMgt: Codeunit "Furniture Certificate Mgt";
        CertStatus: Enum "Furniture Certificate Status";
    begin
        // [SCENARIO] Certificate with past Valid To date should be Expired
        // [GIVEN] A certificate with Valid To in the past
        CreateCertificate(Certificate, CalcDate('<-1Y>', WorkDate()), CalcDate('<-1D>', WorkDate()));

        // [WHEN] Status is evaluated
        CertStatus := CertificateMgt.EvaluateStatus(Certificate);

        // [THEN] Status should be Expired
        if CertStatus <> Certificate.Status::Expired then
            Error('Certificate with past end date should be Expired');
    end;

    [Test]
    procedure TestCertificateStatusActiveWithinRange()
    var
        Certificate: Record "Furniture Certificate";
        CertificateMgt: Codeunit "Furniture Certificate Mgt";
        CertStatus: Enum "Furniture Certificate Status";
    begin
        // [SCENARIO] Certificate with current date within Valid From and Valid To should be Active
        // [GIVEN] A certificate with Valid From in the past and Valid To in the future
        CreateCertificate(Certificate, CalcDate('<-30D>', WorkDate()), CalcDate('<+1Y>', WorkDate()));

        // [WHEN] Status is evaluated
        CertStatus := CertificateMgt.EvaluateStatus(Certificate);

        // [THEN] Status should be Active
        if CertStatus <> Certificate.Status::Active then
            Error('Certificate within valid dates should be Active');
    end;

    [Test]
    procedure TestCertificateStatusSuspendedStaysSuspended()
    var
        Certificate: Record "Furniture Certificate";
        CertificateMgt: Codeunit "Furniture Certificate Mgt";
        CertStatus: Enum "Furniture Certificate Status";
    begin
        // [SCENARIO] Suspended certificate should remain Suspended regardless of dates
        // [GIVEN] A certificate that is manually set to Suspended
        CreateCertificate(Certificate, CalcDate('<-30D>', WorkDate()), CalcDate('<+1Y>', WorkDate()));
        Certificate.Status := Certificate.Status::Suspended;
        Certificate.Modify();

        // [WHEN] Status is evaluated
        CertStatus := CertificateMgt.EvaluateStatus(Certificate);

        // [THEN] Status should remain Suspended
        if CertStatus <> Certificate.Status::Suspended then
            Error('Suspended certificate should stay Suspended');
    end;

    [Test]
    procedure TestCertificateInvalidDateRange()
    var
        Certificate: Record "Furniture Certificate";
    begin
        // [SCENARIO] Certificate with Valid From after Valid To should fail
        // [GIVEN] A certificate being created
        Certificate.Init();
        Certificate.Code := GetNextTestCode();
        Certificate."Certificate Type" := Certificate."Certificate Type"::Safety;
        Certificate."Valid From" := CalcDate('<+1Y>', WorkDate());
        Certificate."Valid To" := WorkDate();

        // [WHEN] Trying to insert the certificate
        // [THEN] Should raise an error
        asserterror Certificate.Insert(true);
        if GetLastErrorText() <> 'Valid From must be on or before Valid To.' then
            Error('Expected error about invalid date range');
    end;

    [Test]
    procedure TestCertificateDeleteCascadesToAssignments()
    var
        Certificate: Record "Furniture Certificate";
        Assignment: Record "Furniture Cert. Assignment";
        Item: Record Item;
    begin
        // [SCENARIO] Deleting a certificate should delete all its assignments
        // [GIVEN] A certificate with an assignment to an item
        CreateCertificate(Certificate, 0D, 0D);
        CreateItem(Item);
        CreateAssignment(Assignment, Item."No.", Certificate.Code);

        // [WHEN] Certificate is deleted
        Certificate.Delete(true);

        // [THEN] Assignment should also be deleted
        Assignment.SetRange("Certificate Code", Certificate.Code);
        if not Assignment.IsEmpty() then
            Error('Assignments should be deleted when certificate is deleted');
    end;

    [Test]
    procedure TestCertificateStatusUpdatesOnInsert()
    var
        Certificate: Record "Furniture Certificate";
        CertCode: Code[20];
    begin
        // [SCENARIO] Certificate status should be automatically set on insert
        // [GIVEN] A new certificate with dates in range
        Certificate.Init();
        CertCode := GetNextTestCode();
        Certificate.Code := CertCode;
        Certificate."Certificate Type" := Certificate."Certificate Type"::Quality;
        Certificate."Valid From" := CalcDate('<-30D>', WorkDate());
        Certificate."Valid To" := CalcDate('<+1Y>', WorkDate());

        // [WHEN] Certificate is inserted
        Certificate.Insert(true);

        // [THEN] Status should be Active
        Certificate.Get(CertCode);
        if Certificate.Status <> Certificate.Status::Active then
            Error('Status should be set to Active on insert');
    end;

    [Test]
    procedure TestCertificateStatusUpdatesOnModify()
    var
        Certificate: Record "Furniture Certificate";
        CertCode: Code[20];
    begin
        // [SCENARIO] Certificate status should be automatically updated on modify
        // [GIVEN] An active certificate
        CreateCertificate(Certificate, CalcDate('<-30D>', WorkDate()), CalcDate('<+1Y>', WorkDate()));
        CertCode := Certificate.Code;
        if Certificate.Status <> Certificate.Status::Active then
            Error('Initial status should be Active');

        // [WHEN] Valid To is changed to a past date
        Certificate."Valid To" := CalcDate('<-1D>', WorkDate());
        Certificate.Modify(true);

        // [THEN] Status should be Expired
        Certificate.Get(CertCode);
        if Certificate.Status <> Certificate.Status::Expired then
            Error('Status should be updated to Expired on modify');
    end;

    local procedure CreateCertificate(var Certificate: Record "Furniture Certificate"; ValidFrom: Date; ValidTo: Date)
    begin
        Certificate.Init();
        Certificate.Code := GetNextTestCode();
        Certificate.Description := 'Test Certificate';
        Certificate."Certificate Type" := Certificate."Certificate Type"::Safety;
        Certificate."Issuing Authority" := 'Test Authority';
        Certificate."Valid From" := ValidFrom;
        Certificate."Valid To" := ValidTo;
        Certificate.Insert(true);
    end;

    local procedure CreateItem(var Item: Record Item)
    begin
        Item.Init();
        Item."No." := GetNextTestCode();
        Item.Description := 'Test Item';
        Item.Insert(true);
    end;

    local procedure CreateAssignment(var Assignment: Record "Furniture Cert. Assignment"; ItemNo: Code[20]; CertCode: Code[20])
    begin
        Assignment.Init();
        Assignment."Item No." := ItemNo;
        Assignment."Certificate Code" := CertCode;
        Assignment.Insert(true);
    end;

    local procedure GetNextTestCode(): Code[20]
    begin
        TestCounter += 1;
        exit('TEST' + Format(TestCounter));
    end;
}
