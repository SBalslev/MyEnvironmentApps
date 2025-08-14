page 50107 "Rental Setup Card"
{
    PageType = Card;
    ApplicationArea = All;
    SourceTable = "Rental Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Property Nos."; Rec."Property Nos.") { ApplicationArea = All; }
                field("Unit Nos."; Rec."Unit Nos.") { ApplicationArea = All; }
                field("Tenant Nos."; Rec."Tenant Nos.") { ApplicationArea = All; }
                field("Lease Nos."; Rec."Lease Nos.") { ApplicationArea = All; }
                field("Service Request Nos."; Rec."Service Request Nos.") { ApplicationArea = All; }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Rec.Get('SETUP') then begin
            Rec.Init;
            Rec."Primary Key" := 'SETUP';
            Rec.Insert;
            Commit();
        end;
    end;
}
