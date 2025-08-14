page 50100 "Property List"
{
    PageType = List;
    ApplicationArea = All;
    SourceTable = Property;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("ID"; Rec."ID") { ApplicationArea = All; }
                field(Name; Rec.Name) { ApplicationArea = All; }
                field(Type; Rec.Type) { ApplicationArea = All; }
                field(City; Rec.City) { ApplicationArea = All; }
                field(Status; Rec.Status) { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ViewCard)
            {
                Caption = 'Open';
                ApplicationArea = All;
                RunObject = page "Property Card";
                RunPageLink = "ID" = field("ID");
            }
        }
    }
}

page 50101 "Property Card"
{
    PageType = Card;
    ApplicationArea = All;
    SourceTable = Property;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("ID"; Rec."ID") { ApplicationArea = All; }
                field(Name; Rec.Name) { ApplicationArea = All; }
                field(Type; Rec.Type) { ApplicationArea = All; }
                field(Address; Rec.Address) { ApplicationArea = All; }
                field(City; Rec.City) { ApplicationArea = All; }
                field("State/Region"; Rec."State/Region") { ApplicationArea = All; }
                field("Postal Code"; Rec."Postal Code") { ApplicationArea = All; }
                field(Country; Rec.Country) { ApplicationArea = All; }
                field(Status; Rec.Status) { ApplicationArea = All; }
                field("Acquisition Date"; Rec."Acquisition Date") { ApplicationArea = All; }
                field(Notes; Rec.Notes) { ApplicationArea = All; MultiLine = true; }
            }
        }
        area(factboxes)
        {
        }
    }
}
