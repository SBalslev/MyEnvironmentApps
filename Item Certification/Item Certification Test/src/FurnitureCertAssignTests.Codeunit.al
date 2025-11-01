namespace org.mycompany.customers.cronus.sales.item.certification;

using Microsoft.Inventory.Item;

codeunit 50121 "Furniture Cert Assign Tests"
{
    Subtype = Test;
    TestPermissions = Disabled;
    TestType = UnitTest;
    RequiredTestIsolation = Function;

    var
        TestCounter: Integer;

    [Test]
    procedure TestAssignmentInitializesDatesFromCertificate()
    var
        Certificate: Record "Furniture Certificate";
        Assignment: Record "Furniture Cert. Assignment";
        Item: Record Item;
        CertCode, ItemCode : Code[20];
    begin
        // [SCENARIO] Assignment should inherit dates from certificate if not specified
        // [GIVEN] A certificate with specific dates
        CreateCertificate(Certificate, CalcDate('<-30D>', WorkDate()), CalcDate('<+1Y>', WorkDate()));
        CertCode := Certificate.Code;
        CreateItem(Item);
        ItemCode := Item."No.";

        // [WHEN] Assignment is created without dates
        Assignment.Init();
        Assignment."Item No." := ItemCode;
        Assignment."Certificate Code" := CertCode;
        Assignment.Insert(true);

        // [THEN] Assignment dates should match certificate dates
        Assignment.Get(ItemCode, CertCode);
        if Assignment."Valid From" <> Certificate."Valid From" then
            Error('Assignment Valid From should match certificate');
        if Assignment."Valid To" <> Certificate."Valid To" then
            Error('Assignment Valid To should match certificate');
    end;

    [Test]
    procedure TestAssignmentKeepsSpecifiedDates()
    var
        Certificate: Record "Furniture Certificate";
        Assignment: Record "Furniture Cert. Assignment";
        Item: Record Item;
        SpecificFrom: Date;
        SpecificTo: Date;
        CertCode, ItemCode : Code[20];
    begin
        // [SCENARIO] Assignment should keep user-specified dates
        // [GIVEN] A certificate and specific assignment dates
        CreateCertificate(Certificate, CalcDate('<-60D>', WorkDate()), CalcDate('<+2Y>', WorkDate()));
        CertCode := Certificate.Code;
        CreateItem(Item);
        ItemCode := Item."No.";
        SpecificFrom := CalcDate('<-30D>', WorkDate());
        SpecificTo := CalcDate('<+1Y>', WorkDate());

        // [WHEN] Assignment is created with specific dates
        Assignment.Init();
        Assignment."Item No." := ItemCode;
        Assignment."Certificate Code" := CertCode;
        Assignment."Valid From" := SpecificFrom;
        Assignment."Valid To" := SpecificTo;
        Assignment.Insert(true);

        // [THEN] Assignment should keep the specified dates
        Assignment.Get(ItemCode, CertCode);
        if Assignment."Valid From" <> SpecificFrom then
            Error('Assignment should keep specified Valid From');
        if Assignment."Valid To" <> SpecificTo then
            Error('Assignment should keep specified Valid To');
    end;

    [Test]
    procedure TestAssignmentFailsWithExpiredCertificate()
    var
        Certificate: Record "Furniture Certificate";
        Assignment: Record "Furniture Cert. Assignment";
        Item: Record Item;
    begin
        // [SCENARIO] Cannot assign an expired certificate
        // [GIVEN] An expired certificate
        CreateCertificate(Certificate, CalcDate('<-1Y>', WorkDate()), CalcDate('<-1D>', WorkDate()));
        CreateItem(Item);

        // [WHEN] Trying to create assignment
        Assignment.Init();
        Assignment."Item No." := Item."No.";
        Assignment."Certificate Code" := Certificate.Code;

        // [THEN] Should raise an error
        asserterror Assignment.Insert(true);
        if StrPos(GetLastErrorText(), 'expired and cannot be assigned') = 0 then
            Error('Expected error about expired certificate');
    end;

    [Test]
    procedure TestAssignmentFailsWhenStartBeforeCertificateStart()
    var
        Certificate: Record "Furniture Certificate";
        Assignment: Record "Furniture Cert. Assignment";
        Item: Record Item;
    begin
        // [SCENARIO] Assignment start date cannot be before certificate start date
        // [GIVEN] A certificate with a specific start date
        CreateCertificate(Certificate, WorkDate(), CalcDate('<+1Y>', WorkDate()));
        CreateItem(Item);

        // [WHEN] Trying to create assignment with earlier start date
        Assignment.Init();
        Assignment."Item No." := Item."No.";
        Assignment."Certificate Code" := Certificate.Code;
        Assignment."Valid From" := CalcDate('<-30D>', WorkDate());

        // [THEN] Should raise an error
        asserterror Assignment.Insert(true);
        if StrPos(GetLastErrorText(), 'cannot precede certificate start date') = 0 then
            Error('Expected error about assignment start before certificate start');
    end;

    [Test]
    procedure TestAssignmentFailsWhenEndAfterCertificateEnd()
    var
        Certificate: Record "Furniture Certificate";
        Assignment: Record "Furniture Cert. Assignment";
        Item: Record Item;
    begin
        // [SCENARIO] Assignment end date cannot be after certificate end date
        // [GIVEN] A certificate with a specific end date
        CreateCertificate(Certificate, CalcDate('<-30D>', WorkDate()), CalcDate('<+1Y>', WorkDate()));
        CreateItem(Item);

        // [WHEN] Trying to create assignment with later end date
        Assignment.Init();
        Assignment."Item No." := Item."No.";
        Assignment."Certificate Code" := Certificate.Code;
        Assignment."Valid From" := WorkDate();
        Assignment."Valid To" := CalcDate('<+2Y>', WorkDate());

        // [THEN] Should raise an error
        asserterror Assignment.Insert(true);
        if StrPos(GetLastErrorText(), 'cannot exceed certificate end date') = 0 then
            Error('Expected error about assignment end after certificate end');
    end;

    [Test]
    procedure TestAssignmentFailsWithInvalidDateRange()
    var
        Certificate: Record "Furniture Certificate";
        Assignment: Record "Furniture Cert. Assignment";
        Item: Record Item;
    begin
        // [SCENARIO] Assignment end date must be after start date
        // [GIVEN] A certificate
        CreateCertificate(Certificate, CalcDate('<-30D>', WorkDate()), CalcDate('<+1Y>', WorkDate()));
        CreateItem(Item);

        // [WHEN] Trying to create assignment with end before start
        Assignment.Init();
        Assignment."Item No." := Item."No.";
        Assignment."Certificate Code" := Certificate.Code;
        Assignment."Valid From" := WorkDate();
        Assignment."Valid To" := CalcDate('<-30D>', WorkDate());

        // [THEN] Should raise an error
        asserterror Assignment.Insert(true);
        if StrPos(GetLastErrorText(), 'must fall on or after') = 0 then
            Error('Expected error about invalid date range');
    end;

    [Test]
    procedure TestAssignmentFailsWithOverlappingSameCertificateType()
    var
        Certificate1: Record "Furniture Certificate";
        Certificate2: Record "Furniture Certificate";
        Assignment1: Record "Furniture Cert. Assignment";
        Assignment2: Record "Furniture Cert. Assignment";
        Item: Record Item;
    begin
        // [SCENARIO] Cannot assign overlapping certificates of the same type to an item
        // [GIVEN] Two Safety certificates and an item with one already assigned
        CreateCertificate(Certificate1, CalcDate('<-30D>', WorkDate()), CalcDate('<+1Y>', WorkDate()));
        Certificate1."Certificate Type" := Certificate1."Certificate Type"::Safety;
        Certificate1.Modify();

        CreateCertificate(Certificate2, WorkDate(), CalcDate('<+6M>', WorkDate()));
        Certificate2."Certificate Type" := Certificate2."Certificate Type"::Safety;
        Certificate2.Modify();

        CreateItem(Item);

        // Create first assignment
        Assignment1.Init();
        Assignment1."Item No." := Item."No.";
        Assignment1."Certificate Code" := Certificate1.Code;
        Assignment1.Insert(true);

        // [WHEN] Trying to create overlapping assignment of same type
        Assignment2.Init();
        Assignment2."Item No." := Item."No.";
        Assignment2."Certificate Code" := Certificate2.Code;

        // [THEN] Should raise an error
        asserterror Assignment2.Insert(true);
        if StrPos(GetLastErrorText(), 'already has certificate') = 0 then
            Error('Expected error about overlapping certificates');
    end;

    [Test]
    procedure TestAssignmentAllowsOverlappingDifferentCertificateTypes()
    var
        Certificate1: Record "Furniture Certificate";
        Certificate2: Record "Furniture Certificate";
        Assignment1: Record "Furniture Cert. Assignment";
        Assignment2: Record "Furniture Cert. Assignment";
        Item: Record Item;
        ItemCode, CertCode1, CertCode2 : Code[20];
    begin
        // [SCENARIO] Can assign overlapping certificates of different types to an item
        // [GIVEN] Safety and Quality certificates
        CreateCertificate(Certificate1, CalcDate('<-30D>', WorkDate()), CalcDate('<+1Y>', WorkDate()));
        Certificate1."Certificate Type" := Certificate1."Certificate Type"::Safety;
        Certificate1.Modify();
        CertCode1 := Certificate1.Code;

        CreateCertificate(Certificate2, WorkDate(), CalcDate('<+6M>', WorkDate()));
        Certificate2."Certificate Type" := Certificate2."Certificate Type"::Quality;
        Certificate2.Modify();
        CertCode2 := Certificate2.Code;

        CreateItem(Item);
        ItemCode := Item."No.";

        // Create first assignment
        Assignment1.Init();
        Assignment1."Item No." := ItemCode;
        Assignment1."Certificate Code" := CertCode1;
        Assignment1.Insert(true);

        // [WHEN] Creating overlapping assignment of different type
        Assignment2.Init();
        Assignment2."Item No." := ItemCode;
        Assignment2."Certificate Code" := CertCode2;
        Assignment2.Insert(true);

        // [THEN] Should succeed
        Assignment2.Get(ItemCode, CertCode2);
        if Assignment2."Certificate Code" <> CertCode2 then
            Error('Second assignment should be created');
    end;

    [Test]
    procedure TestAssignmentAllowsNonOverlappingSameCertificateType()
    var
        Certificate1: Record "Furniture Certificate";
        Certificate2: Record "Furniture Certificate";
        Assignment1: Record "Furniture Cert. Assignment";
        Assignment2: Record "Furniture Cert. Assignment";
        Item: Record Item;
        ItemCode, CertCode1, CertCode2 : Code[20];
    begin
        // [SCENARIO] Can assign non-overlapping certificates of the same type to an item
        // [GIVEN] Two Safety certificates with different date ranges
        CreateCertificate(Certificate1, CalcDate('<-1Y>', WorkDate()), CalcDate('<-1M>', WorkDate()));
        Certificate1."Certificate Type" := Certificate1."Certificate Type"::Safety;
        Certificate1.Modify();
        CertCode1 := Certificate1.Code;

        CreateCertificate(Certificate2, WorkDate(), CalcDate('<+1Y>', WorkDate()));
        Certificate2."Certificate Type" := Certificate2."Certificate Type"::Safety;
        Certificate2.Modify();
        CertCode2 := Certificate2.Code;

        CreateItem(Item);
        ItemCode := Item."No.";

        // Create first assignment (past dates)
        Assignment1.Init();
        Assignment1."Item No." := ItemCode;
        Assignment1."Certificate Code" := CertCode1;
        Assignment1.Insert(true);

        // [WHEN] Creating non-overlapping assignment of same type
        Assignment2.Init();
        Assignment2."Item No." := ItemCode;
        Assignment2."Certificate Code" := CertCode2;
        Assignment2.Insert(true);

        // [THEN] Should succeed
        Assignment2.Get(ItemCode, CertCode2);
        if Assignment2."Certificate Code" <> CertCode2 then
            Error('Second assignment should be created');
    end;

    [Test]
    procedure TestAssignmentSetsCreatedByAndCreatedAt()
    var
        Certificate: Record "Furniture Certificate";
        Assignment: Record "Furniture Cert. Assignment";
        Item: Record Item;
        CertCode, ItemCode : Code[20];
    begin
        // [SCENARIO] Assignment should automatically set Created By and Created At
        // [GIVEN] A certificate and item
        CreateCertificate(Certificate, 0D, 0D);
        CertCode := Certificate.Code;
        CreateItem(Item);
        ItemCode := Item."No.";

        // [WHEN] Assignment is created
        Assignment.Init();
        Assignment."Item No." := ItemCode;
        Assignment."Certificate Code" := CertCode;
        Assignment.Insert(true);

        // [THEN] Created By and Created At should be set
        Assignment.Get(ItemCode, CertCode);
        if Assignment."Created By" = '' then
            Error('Created By should be set');
        if Assignment."Created At" = 0DT then
            Error('Created At should be set');
    end;

    [Test]
    procedure TestAssignmentModifyUpdatesValidation()
    var
        Certificate: Record "Furniture Certificate";
        Assignment: Record "Furniture Cert. Assignment";
        Item: Record Item;
        CertCode, ItemCode : Code[20];
    begin
        // [SCENARIO] Modifying assignment should revalidate constraints
        // [GIVEN] A valid assignment
        CreateCertificate(Certificate, CalcDate('<-30D>', WorkDate()), CalcDate('<+1Y>', WorkDate()));
        CertCode := Certificate.Code;
        CreateItem(Item);
        ItemCode := Item."No.";

        Assignment.Init();
        Assignment."Item No." := ItemCode;
        Assignment."Certificate Code" := CertCode;
        Assignment.Insert(true);

        // [WHEN] Trying to modify assignment with invalid dates
        Assignment.Get(ItemCode, CertCode);
        Assignment."Valid To" := CalcDate('<+2Y>', WorkDate());

        // [THEN] Should raise an error
        asserterror Assignment.Modify(true);
        if StrPos(GetLastErrorText(), 'cannot exceed certificate end date') = 0 then
            Error('Expected error about exceeding certificate end date');
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

    local procedure GetNextTestCode(): Code[20]
    begin
        TestCounter += 1;
        exit('TEST' + Format(TestCounter));
    end;
}
