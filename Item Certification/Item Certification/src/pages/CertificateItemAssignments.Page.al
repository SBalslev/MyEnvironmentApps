namespace org.mycompany.customers.cronus.sales.item.certification;

page 50102 "Certificate Item Assignments"
{
    PageType = ListPart;
    ApplicationArea = Basic, Suite;
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
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the item number assigned to this certificate.';
                }
                field(ItemDescription; Rec."Item Description")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the description of the item.';
                }
                field(ValidFrom; Rec."Valid From")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the date from which the certificate assignment is valid.';
                }
                field(ValidTo; Rec."Valid To")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the date until which the certificate assignment is valid.';
                }
                field(Status; Rec."Assignment Status")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the status of the certificate assignment.';
                }
            }
        }
    }
}
