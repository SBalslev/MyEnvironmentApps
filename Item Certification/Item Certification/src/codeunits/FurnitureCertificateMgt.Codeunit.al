namespace org.mycompany.customers.cronus.sales.item.certification;

codeunit 50100 "Furniture Certificate Mgt"
{
    procedure EvaluateStatus(Certificate: Record "Furniture Certificate"): Enum "Furniture Certificate Status"
    var
        Today: Date;
    begin
        Today := WorkDate();

        if Certificate.Status = Certificate.Status::Suspended then
            exit(Certificate.Status::Suspended);

        if (Certificate."Valid From" = 0D) and (Certificate."Valid To" = 0D) then
            exit(Certificate.Status::Active);

        if (Certificate."Valid From" <> 0D) and (Today < Certificate."Valid From") then
            exit(Certificate.Status::Pending);

        if (Certificate."Valid To" <> 0D) and (Today > Certificate."Valid To") then
            exit(Certificate.Status::Expired);

        exit(Certificate.Status::Active);
    end;

    procedure InitialiseAssignmentDates(var Assignment: Record "Furniture Cert. Assignment")
    var
        Certificate: Record "Furniture Certificate";
    begin
        if not Certificate.Get(Assignment."Certificate Code") then
            Error('Certificate %1 is missing.', Assignment."Certificate Code");

        if Assignment."Valid From" = 0D then
            Assignment."Valid From" := Certificate."Valid From";

        if Assignment."Valid To" = 0D then
            Assignment."Valid To" := Certificate."Valid To";
    end;

    procedure ValidateAssignment(var Assignment: Record "Furniture Cert. Assignment")
    var
        Certificate: Record "Furniture Certificate";
        OtherAssignment: Record "Furniture Cert. Assignment";
        CertificateStatus: Enum "Furniture Certificate Status";
    begin
        if not Certificate.Get(Assignment."Certificate Code") then
            Error('Certificate %1 does not exist.', Assignment."Certificate Code");

        CertificateStatus := EvaluateStatus(Certificate);
        if CertificateStatus = CertificateStatus::Expired then
            Error('Certificate %1 is expired and cannot be assigned.', Assignment."Certificate Code");

        if (Certificate."Valid From" <> 0D) and (Assignment."Valid From" <> 0D) and (Assignment."Valid From" < Certificate."Valid From") then
            Error('Assignment start date %1 cannot precede certificate start date %2.', Assignment."Valid From", Certificate."Valid From");

        if (Certificate."Valid To" <> 0D) and (Assignment."Valid To" <> 0D) and (Assignment."Valid To" > Certificate."Valid To") then
            Error('Assignment end date %1 cannot exceed certificate end date %2.', Assignment."Valid To", Certificate."Valid To");

        if (Assignment."Valid From" <> 0D) and (Assignment."Valid To" <> 0D) and (Assignment."Valid From" > Assignment."Valid To") then
            Error('Assignment end date must fall on or after the start date.');

        OtherAssignment.Reset();
        OtherAssignment.SetCurrentKey("Item No.", "Valid From");
        OtherAssignment.SetRange("Item No.", Assignment."Item No.");
        OtherAssignment.SetFilter("Certificate Code", '<>%1', Assignment."Certificate Code");

        if OtherAssignment.FindSet() then
            repeat
                ValidateNoOverlap(Assignment, OtherAssignment, Certificate."Certificate Type");
            until OtherAssignment.Next() = 0;
    end;

    local procedure ValidateNoOverlap(Assignment: Record "Furniture Cert. Assignment"; OtherAssignment: Record "Furniture Cert. Assignment"; CertificateType: Enum "Furniture Certificate Type")
    var
        OtherCertificate: Record "Furniture Certificate";
    begin
        if not OtherCertificate.Get(OtherAssignment."Certificate Code") then
            exit;

        if OtherCertificate."Certificate Type" <> CertificateType then
            exit;

        if DateRangesOverlap(Assignment."Valid From", Assignment."Valid To", OtherAssignment."Valid From", OtherAssignment."Valid To") then
            Error(
              'Item %1 already has certificate %2 of type %3 covering overlapping dates (%4 - %5).',
              Assignment."Item No.",
              OtherAssignment."Certificate Code",
              CertificateType,
              OtherAssignment."Valid From",
              OtherAssignment."Valid To");
    end;

    local procedure DateRangesOverlap(FromDateA: Date; ToDateA: Date; FromDateB: Date; ToDateB: Date): Boolean
    var
        EffectiveToDateA: Date;
        EffectiveToDateB: Date;
    begin
        EffectiveToDateA := ToDateA;
        if EffectiveToDateA = 0D then
            EffectiveToDateA := DMY2DATE(31, 12, 9999);

        EffectiveToDateB := ToDateB;
        if EffectiveToDateB = 0D then
            EffectiveToDateB := DMY2DATE(31, 12, 9999);

        if (FromDateA = 0D) and (FromDateB = 0D) then
            exit(true);

        if FromDateA = 0D then
            FromDateA := FromDateB;
        if FromDateB = 0D then
            FromDateB := FromDateA;

        exit((FromDateA <= EffectiveToDateB) and (FromDateB <= EffectiveToDateA));
    end;
}
