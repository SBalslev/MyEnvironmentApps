pageextension 50101 "Item List Certificate Ext" extends "Item List"
{
    actions
    {
        addlast(Navigation)
        {
            action(ViewCertificates)
            {
                ApplicationArea = All;
                Caption = 'View Certificates';
                Image = List;

                trigger OnAction()
                var
                    AssignmentRec: Record "Furniture Cert. Assignment";
                begin
                    AssignmentRec.SetRange("Item No.", Rec."No.");
                    PAGE.RunModal(PAGE::"Item Certificates", AssignmentRec);
                end;
            }
        }
    }
}
