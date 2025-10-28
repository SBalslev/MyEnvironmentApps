page 50102 "Certificate Item Assignments"
{
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "Furniture Cert. Assignment";
    Caption = 'Items with Certificate';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(ItemNo; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field(ValidFrom; Rec."Valid From")
                {
                    ApplicationArea = All;
                }
                field(ValidTo; Rec."Valid To")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec."Assignment Status")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
