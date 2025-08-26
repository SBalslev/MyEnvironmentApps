page 50104 "SBX Lease List"
{
    Caption = 'Leases';
    PageType = List;
    ApplicationArea = All;
    SourceTable = "SBX Lease";
    UsageCategory = Lists;
    CardPageID = "SBX Lease Card";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.") { ApplicationArea = All; }
                field("Customer Name"; Rec."Customer Name") { ApplicationArea = All; }
                field("Property Code"; Rec."Property Code") { ApplicationArea = All; }
                field("Unit Code"; Rec."Unit Code") { ApplicationArea = All; }
                field(Status; Rec.Status) { ApplicationArea = All; }
                field("Start Date"; Rec."Start Date") { ApplicationArea = All; }
                field("End Date"; Rec."End Date") { ApplicationArea = All; }
                field("Base Rent Amount"; Rec."Base Rent Amount") { ApplicationArea = All; }
            }
        }
    }
}
