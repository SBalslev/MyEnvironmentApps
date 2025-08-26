page 50102 "SBX Property Card"
{
    Caption = 'Property';
    PageType = Card;
    ApplicationArea = All;
    SourceTable = "SBX Property";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Code; Rec.Code) { ApplicationArea = All; }
                field(Name; Rec.Name) { ApplicationArea = All; }
                field(Status; Rec.Status) { ApplicationArea = All; }
                field("Portfolio/Region Code"; Rec."Portfolio/Region Code") { ApplicationArea = All; }
                field("Default Unit Area UoM"; Rec."Default Unit Area UoM") { ApplicationArea = All; }
            }
            group(Address)
            {
                field("Address 1"; Rec."Address 1") { ApplicationArea = All; }
                field("Address 2"; Rec."Address 2") { ApplicationArea = All; }
                field(City; Rec.City) { ApplicationArea = All; }
                field("Post Code"; Rec."Post Code") { ApplicationArea = All; }
                field("Country/Region Code"; Rec."Country/Region Code") { ApplicationArea = All; }
            }
        }
    }
}
