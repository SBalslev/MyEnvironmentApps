codeunit 50320 "SBX Run Charge Engine"
{
    Subtype = Normal;
    SingleInstance = false;

    trigger OnRun()
    var
        ChargeEngine: Codeunit "SBX Charge Engine";
        BillingDate: Date;
    begin
        BillingDate := WorkDate();
        if not Confirm('Generate charges up to %1?', false, BillingDate) then
            exit;
        ChargeEngine.GenerateChargesForDate(BillingDate);
        Message('Charge generation completed for %1.', BillingDate);
    end;
}
