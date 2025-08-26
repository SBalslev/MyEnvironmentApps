codeunit 50309 "SBX Setup Mgt."
{
    SingleInstance = true;

    procedure GetSetup(var Setup: Record "SBX Extensionarium Setup")
    begin
        if not Setup.Get('SETUP') then begin
            Setup.Init();
            Setup."Primary Key" := 'SETUP';
            Setup.Insert();
        end;
    end;
}
