codeunit 50101 "Furniture Certificate Demo"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    begin
        EnsureUnitOfMeasure('FPCS', 'Furniture Pieces');
        SeedItems();
        SeedCertificates();
        SeedAssignments();
    end;

    local procedure EnsureUnitOfMeasure(Code: Code[10]; Description: Text[50])
    var
        UnitOfMeasure: Record "Unit of Measure";
    begin
        if UnitOfMeasure.Get(Code) then
            exit;

        UnitOfMeasure.Init();
        UnitOfMeasure.Code := Code;
        UnitOfMeasure.Description := Description;
        UnitOfMeasure.Insert(true);
    end;

    local procedure SeedItems()
    begin
        CreateItem('F-CHAIR-001', 'Forest Lounge Chair');
        CreateItem('F-TABLE-001', 'Oak Dining Table');
        CreateItem('F-SOFA-001', 'Loft Modular Sofa');
    end;

    local procedure CreateItem(ItemNo: Code[20]; Description: Text[100])
    var
        Item: Record Item;
    begin
        if Item.Get(ItemNo) then
            exit;

        Item.Init();
        Item."No." := ItemNo;
        Item.Description := Description;
        Item.Type := Item.Type::"Non-Inventory";
        Item."Base Unit of Measure" := 'FPCS';
        Item.Insert(true);
    end;

    local procedure SeedCertificates()
    begin
        CreateCertificate('CERT-FIRE-001', 'Fire Safety Upholstery', "Furniture Certificate Type"::Safety, 'EuroFire Labs', DMY2DATE(1, 1, 2024), DMY2DATE(31, 12, 2026));
        CreateCertificate('CERT-GREEN-001', 'Sustainable Wood Sourcing', "Furniture Certificate Type"::Sustainability, 'Forest Stewardship Council', DMY2DATE(1, 6, 2023), DMY2DATE(31, 5, 2026));
        CreateCertificate('CERT-FABRIC-001', 'Low VOC Fabric', "Furniture Certificate Type"::Materials, 'CleanTextile Consortium', DMY2DATE(1, 4, 2025), 0D);
    end;

    local procedure CreateCertificate(Code: Code[20]; Description: Text[100]; CertificateType: Enum "Furniture Certificate Type"; Authority: Text[100]; ValidFrom: Date; ValidTo: Date)
    var
        Certificate: Record "Furniture Certificate";
    begin
        if Certificate.Get(Code) then
            exit;

        Certificate.Init();
        Certificate."Code" := Code;
        Certificate."Description" := Description;
        Certificate."Certificate Type" := CertificateType;
        Certificate."Issuing Authority" := Authority;
        Certificate."Valid From" := ValidFrom;
        Certificate."Valid To" := ValidTo;
        Certificate.Insert(true);
    end;

    local procedure SeedAssignments()
    begin
        CreateAssignment('F-CHAIR-001', 'CERT-FIRE-001');
        CreateAssignment('F-CHAIR-001', 'CERT-GREEN-001');
        CreateAssignment('F-TABLE-001', 'CERT-GREEN-001');
        CreateAssignment('F-SOFA-001', 'CERT-FABRIC-001');
    end;

    local procedure CreateAssignment(ItemNo: Code[20]; CertificateCode: Code[20])
    var
        Assignment: Record "Furniture Cert. Assignment";
    begin
        if not ItemExists(ItemNo) then
            exit;
        if not CertificateExists(CertificateCode) then
            exit;

        Assignment.Init();
        Assignment."Item No." := ItemNo;
        Assignment."Certificate Code" := CertificateCode;
        Assignment.Insert(true);
    end;

    local procedure ItemExists(ItemNo: Code[20]): Boolean
    var
        Item: Record Item;
    begin
        Item.SetRange("No.", ItemNo);
        exit(Item.FindFirst());
    end;

    local procedure CertificateExists(Code: Code[20]): Boolean
    var
        Certificate: Record "Furniture Certificate";
    begin
        Certificate.SetRange("Code", Code);
        exit(Certificate.FindFirst());
    end;
}
