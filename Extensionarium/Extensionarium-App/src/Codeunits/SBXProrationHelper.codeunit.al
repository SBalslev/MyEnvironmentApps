codeunit 50307 "SBX Proration Helper"
{
    procedure ProrateAmount(FullAmount: Decimal; PeriodStart: Date; PeriodEnd: Date; BillStart: Date; BillEnd: Date; Method: Enum "SBX Proration Method"): Decimal
    var
        TotalDays: Integer;
        BillDays: Integer;
    begin
        if (PeriodStart = 0D) or (PeriodEnd = 0D) or (BillStart = 0D) or (BillEnd = 0D) then
            exit(FullAmount);
        if (BillEnd < BillStart) or (PeriodEnd < PeriodStart) then
            exit(0);
        if (BillStart > PeriodEnd) or (BillEnd < PeriodStart) then
            exit(0);

        // Normalize overlap
        if BillStart < PeriodStart then
            BillStart := PeriodStart;
        if BillEnd > PeriodEnd then
            BillEnd := PeriodEnd;

        case Method of
            Method::ExactDaily:
                begin
                    TotalDays := (PeriodEnd - PeriodStart) + 1;
                    BillDays := (BillEnd - BillStart) + 1;
                    if TotalDays <= 0 then
                        exit(FullAmount);
                    exit(Round(FullAmount * BillDays / TotalDays, 0.01, '='));
                end;
            Method::Commercial30:
                begin
                    // Treat every month as 30 days; determine days using 30-day convention
                    TotalDays := CalcCommercial30(PeriodStart, PeriodEnd);
                    BillDays := CalcCommercial30(BillStart, BillEnd);
                    if TotalDays <= 0 then
                        exit(FullAmount);
                    exit(Round(FullAmount * BillDays / TotalDays, 0.01, '='));
                end;
            else
                exit(FullAmount);
        end;
    end;

    local procedure CalcCommercial30(StartDate: Date; EndDate: Date): Integer
    var
        SDay: Integer;
        EDay: Integer;
        SMonth: Integer;
        EMonth: Integer;
        SYear: Integer;
        EYear: Integer;
    begin
        if EndDate < StartDate then
            exit(0);
        SDay := Date2DMY(StartDate, 1);
        SMonth := Date2DMY(StartDate, 2);
        SYear := Date2DMY(StartDate, 3);
        EDay := Date2DMY(EndDate, 1);
        EMonth := Date2DMY(EndDate, 2);
        EYear := Date2DMY(EndDate, 3);

        if SDay = 31 then SDay := 30;
        if EDay = 31 then EDay := 30;

        exit((EYear - SYear) * 360 + (EMonth - SMonth) * 30 + (EDay - SDay) + 1);
    end;
}