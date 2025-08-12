page 50132 "Lease Card"
{
    PageType = Card;
    SourceTable = Lease;
    ApplicationArea = All;
    layout { area(content) { group(General) { field("No."; Rec."No.") { ApplicationArea = All; } field("Unit No."; Rec."Unit No.") { ApplicationArea = All; } field("Tenant No."; Rec."Tenant No.") { ApplicationArea = All; } field("Start Date"; Rec."Start Date") { ApplicationArea = All; } field("End Date"; Rec."End Date") { ApplicationArea = All; } field(Status; Rec.Status) { ApplicationArea = All; } field("Rent Amount"; Rec."Rent Amount") { ApplicationArea = All; } field("Deposit Amount"; Rec."Deposit Amount") { ApplicationArea = All; } field("Termination Reason"; Rec."Termination Reason") { ApplicationArea = All; } } } }
}
