namespace org.mycompany.customers.cronus.sales.item.certification;

using Microsoft.Inventory.Item;
using Microsoft.Foundation.UOM;

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
        // European Certificates
        CreateCertificate('CERT-FIRE-001', 'Fire Safety Upholstery', "Furniture Certificate Type"::Safety, 'EuroFire Labs', DMY2DATE(1, 1, 2024), DMY2DATE(31, 12, 2026));
        CreateCertificate('CERT-GREEN-001', 'Sustainable Wood Sourcing', "Furniture Certificate Type"::Sustainability, 'Forest Stewardship Council', DMY2DATE(1, 6, 2023), DMY2DATE(31, 5, 2026));
        CreateCertificate('CERT-FABRIC-001', 'Low VOC Fabric', "Furniture Certificate Type"::Materials, 'CleanTextile Consortium', DMY2DATE(1, 4, 2025), 0D);
        CreateCertificate('EU-EN1728-2024', 'EN 1728 Seating Strength', "Furniture Certificate Type"::Safety, 'TÜV Rheinland', DMY2DATE(15, 3, 2024), DMY2DATE(14, 3, 2027));
        CreateCertificate('EU-REACH-2024', 'REACH Compliance', "Furniture Certificate Type"::Materials, 'European Chemicals Agency', DMY2DATE(1, 1, 2024), DMY2DATE(31, 12, 2025));
        CreateCertificate('EU-FSC-C001', 'FSC Chain of Custody', "Furniture Certificate Type"::Sustainability, 'FSC Europe', DMY2DATE(10, 5, 2023), DMY2DATE(9, 5, 2028));
        CreateCertificate('EU-PEFC-2024', 'PEFC Sustainable Forest', "Furniture Certificate Type"::Sustainability, 'PEFC Council', DMY2DATE(1, 2, 2024), DMY2DATE(31, 1, 2029));

        // US Certificates
        CreateCertificate('US-CARB-PH2', 'CARB Phase 2 Formaldehyde', "Furniture Certificate Type"::Materials, 'California Air Resources Board', DMY2DATE(1, 7, 2023), DMY2DATE(30, 6, 2026));
        CreateCertificate('US-BIFMA-X7', 'BIFMA X7.1 Sustainability', "Furniture Certificate Type"::Sustainability, 'BIFMA International', DMY2DATE(15, 8, 2024), DMY2DATE(14, 8, 2027));
        CreateCertificate('US-CAL133', 'California TB 133 Fire', "Furniture Certificate Type"::Safety, 'Bureau of Home Furnishings', DMY2DATE(1, 1, 2024), DMY2DATE(31, 12, 2026));
        CreateCertificate('US-GREENGUARD', 'GREENGUARD Gold', "Furniture Certificate Type"::Materials, 'UL Environment', DMY2DATE(20, 4, 2024), DMY2DATE(19, 4, 2026));
        CreateCertificate('US-SCS-FSC', 'SCS FSC Certified', "Furniture Certificate Type"::Sustainability, 'Scientific Certification Systems', DMY2DATE(1, 9, 2023), DMY2DATE(31, 8, 2028));

        // Asian Certificates
        CreateCertificate('CN-GB28007', 'GB 28007 Fire Resistance', "Furniture Certificate Type"::Safety, 'China Quality Certification Centre', DMY2DATE(1, 3, 2024), DMY2DATE(28, 2, 2027));
        CreateCertificate('CN-CQC-ENV', 'CQC Environmental Label', "Furniture Certificate Type"::Sustainability, 'China Quality Certification Centre', DMY2DATE(15, 6, 2024), DMY2DATE(14, 6, 2027));
        CreateCertificate('JP-F4STAR', 'F☆☆☆☆ Low Formaldehyde', "Furniture Certificate Type"::Materials, 'Japan Housing & Wood Tech Center', DMY2DATE(1, 4, 2024), DMY2DATE(31, 3, 2027));
        CreateCertificate('JP-SG-MARK', 'SG Safety Mark', "Furniture Certificate Type"::Safety, 'Product Safety Association', DMY2DATE(10, 2, 2024), DMY2DATE(9, 2, 2026));
        CreateCertificate('SG-SGBC', 'Singapore Green Label', "Furniture Certificate Type"::Sustainability, 'Singapore Green Building Council', DMY2DATE(1, 5, 2024), DMY2DATE(30, 4, 2027));
        CreateCertificate('IN-BIS-14598', 'BIS IS 14598 Safety', "Furniture Certificate Type"::Safety, 'Bureau of Indian Standards', DMY2DATE(15, 1, 2024), DMY2DATE(14, 1, 2027));
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

        // Check if assignment already exists
        Assignment.SetRange("Item No.", ItemNo);
        Assignment.SetRange("Certificate Code", CertificateCode);
        if not Assignment.IsEmpty() then
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
        exit(not Item.IsEmpty());
    end;

    local procedure CertificateExists(Code: Code[20]): Boolean
    var
        Certificate: Record "Furniture Certificate";
    begin
        Certificate.SetRange("Code", Code);
        exit(not Certificate.IsEmpty());
    end;
}
