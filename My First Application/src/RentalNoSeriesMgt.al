codeunit 50101 "Rental No. Series Mgt"
{
    SingleInstance = false;

    procedure AssignPropertyNo(var Prop: Record Property)
    begin
        AssignNoSeries(Prop."ID", GetSetup()."Property Nos.");
    end;

    procedure AssignUnitNo(var UnitRec: Record Unit)
    begin
        AssignNoSeries(UnitRec."No.", GetSetup()."Unit Nos.");
    end;

    procedure AssignTenantNo(var TenRec: Record Tenant)
    begin
        AssignNoSeries(TenRec."No.", GetSetup()."Tenant Nos.");
    end;

    procedure AssignLeaseNo(var LeaseRec: Record Lease)
    begin
        AssignNoSeries(LeaseRec."No.", GetSetup()."Lease Nos.");
    end;

    procedure AssignServiceRequestNo(var SR: Record "Service Request")
    begin
        AssignNoSeries(SR."No.", GetSetup()."Service Request Nos.");
    end;

    local procedure AssignNoSeries(var TargetField: Code[20]; SeriesCode: Code[20])
    var
        State: Record "Rental No. Series State";
    begin
        if SeriesCode = '' then
            Error('Number series not configured.');
        if not State.Get(SeriesCode) then begin
            State.Init; State.Code := SeriesCode; State."Last No." := SeriesCode + '0000'; State.Insert;
        end;
        State."Last No." := IncNo(State."Last No.");
        State.Modify(true);
        TargetField := State."Last No.";
    end;

    local procedure IncNo(LastNo: Code[20]): Code[20]
    var
        Prefix: Text;
        Digits: Text;
        i: Integer;
        c: Char;
        NewVal: Integer;
        Width: Integer;
        NewDigits: Text;
        Result: Text;
    begin
        for i := StrLen(LastNo) downto 1 do begin
            c := LastNo[i];
            if not (c in ['0' .. '9']) then begin
                Prefix := CopyStr(LastNo, 1, i);
                Digits := CopyStr(LastNo, i + 1);
                break;
            end;
        end;
        if Digits = '' then begin
            Prefix := LastNo;
            Digits := '0';
        end;
        Evaluate(NewVal, Digits);
        NewVal += 1;
        Width := StrLen(Digits);
        NewDigits := Format(NewVal, 0, '<Integer>');
        while StrLen(NewDigits) < Width do
            NewDigits := '0' + NewDigits;
        Result := Prefix + NewDigits;
        exit(CopyStr(Result, 1, 20));
    end;

    // Removed platform codeunit detection; fallback logic only.

    local procedure GetSetup(): Record "Rental Setup"
    var
        Setup: Record "Rental Setup";
    begin
        if not Setup.Get('SETUP') then
            Error('Rental Setup not initialized. Open Rental Setup Card to configure number series.');
        exit(Setup);
    end;
}
