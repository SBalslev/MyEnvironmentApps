report 50138 "Service Request Overview"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Service Request Metrics';
    dataset
    {
        dataitem(SR; "Service Request")
        {
            column(No; "No.") { }
            column(Status; Status) { }
            column(Category; Category) { }
            column(Priority; Priority) { }
            column(OpenDate; "Opened At") { }
            column(ClosedDate; "Closed At") { }
            column(ResolutionHours; ResolutionHours) { }
            trigger OnAfterGetRecord()
            begin
                if ("Closed At" <> 0DT) and ("Opened At" <> 0DT) then
                    ResolutionHours := ("Closed At" - "Opened At") / 3600000
                else
                    ResolutionHours := 0;
            end;

            trigger OnPreDataItem()
            begin
                if StatusFilter <> '' then
                    SetFilter(Status, StatusFilter);
                if CategoryFilter <> '' then
                    SetFilter(Category, CategoryFilter);
                if DateFrom <> 0D then
                    SetFilter("Opened At", '>=%1', CreateDateTime(DateFrom, 000000T));
                if DateTo <> 0D then
                    SetFilter("Opened At", '%1..%2', CreateDateTime(DateFrom, 000000T), CreateDateTime(DateTo, 235959T));
            end;
        }
    }
    requestpage
    {
        layout { area(content) { group(Filters) { field(StatusFilter; StatusFilter) { ApplicationArea = All; Caption = 'Status Filter (e.g. Completed|In Progress)'; } field(CategoryFilter; CategoryFilter) { ApplicationArea = All; Caption = 'Category Filter'; } field(DateFrom; DateFrom) { ApplicationArea = All; Caption = 'Opened From'; } field(DateTo; DateTo) { ApplicationArea = All; Caption = 'Opened To'; } } } }
    }
    var
        StatusFilter: Text[100];
        CategoryFilter: Text[50];
        DateFrom: Date;
        DateTo: Date;
        ResolutionHours: Decimal;
}
