codeunit 50308 "SBX No. Series Helper"
{
    SingleInstance = true;

    procedure GetNextPropertyNo(): Code[20]
    var
        Setup: Record "SBX Extensionarium Setup";
        NoSeries: Codeunit "No. Series";
    begin
        Setup.Get('SETUP');
        if Setup."Property No. Series" = '' then
            exit('');
        exit(NoSeries.GetNextNo(Setup."Property No. Series", WorkDate(), true));
    end;

    procedure GetNextUnitNo(): Code[20]
    var
        Setup: Record "SBX Extensionarium Setup";
        NoSeries: Codeunit "No. Series";
    begin
        Setup.Get('SETUP');
        if Setup."Unit No. Series" = '' then
            exit('');
        exit(NoSeries.GetNextNo(Setup."Unit No. Series", WorkDate(), true));
    end;

    procedure GetNextLeaseNo(): Code[20]
    var
        Setup: Record "SBX Extensionarium Setup";
        NoSeries: Codeunit "No. Series";
    begin
        Setup.Get('SETUP');
        if Setup."Lease No. Series" = '' then
            exit('');
        exit(NoSeries.GetNextNo(Setup."Lease No. Series", WorkDate(), true));
    end;

    procedure GetNextServiceRequestNo(): Code[20]
    var
        Setup: Record "SBX Extensionarium Setup";
        NoSeries: Codeunit "No. Series";
    begin
        Setup.Get('SETUP');
        if Setup."Service Req. No. Series" = '' then
            exit('');
        exit(NoSeries.GetNextNo(Setup."Service Req. No. Series", WorkDate(), true));
    end;
}