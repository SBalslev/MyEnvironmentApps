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
                field(Code; Rec.Code) { ApplicationArea = All; ToolTip = 'Unique code of the property.'; }
                field(Name; Rec.Name) { ApplicationArea = All; ToolTip = 'Descriptive name of the property.'; }
                field(Status; Rec.Status) { ApplicationArea = All; ToolTip = 'Operational status of this property.'; }
                field("Portfolio/Region Code"; Rec."Portfolio/Region Code") { ApplicationArea = All; ToolTip = 'Portfolio/region grouping code.'; }
                field("Default Unit Area UoM"; Rec."Default Unit Area UoM") { ApplicationArea = All; ToolTip = 'Default unit of measure for unit area (e.g. SQFT).'; }
            }
            group(Address)
            {
                field("Address 1"; Rec."Address 1") { ApplicationArea = All; ToolTip = 'Primary address line.'; }
                field("Address 2"; Rec."Address 2") { ApplicationArea = All; ToolTip = 'Secondary address line.'; }
                field(City; Rec.City) { ApplicationArea = All; ToolTip = 'City where the property is located.'; }
                field("Post Code"; Rec."Post Code") { ApplicationArea = All; ToolTip = 'Postal code.'; }
                field("Country/Region Code"; Rec."Country/Region Code") { ApplicationArea = All; ToolTip = 'Country/Region code.'; }
            }
        }
    }
}
