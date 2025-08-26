codeunit 50321 "SBX Create Demo Data"
{
    Subtype = Normal;
    trigger OnRun()
    var
        DemoData: Codeunit "SBX Demo Data Mgmt";
    begin
        DemoData.CreateDemoData();
    end;
}
