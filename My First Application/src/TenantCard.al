page 50131 "Tenant Card"
{
    PageType = Card;
    SourceTable = Tenant;
    ApplicationArea = All;
    layout { area(content) { group(General) { field("No."; Rec."No.") { ApplicationArea = All; } field("First Name"; Rec."First Name") { ApplicationArea = All; } field("Last Name"; Rec."Last Name") { ApplicationArea = All; } field(Email; Rec.Email) { ApplicationArea = All; } field(Phone; Rec.Phone) { ApplicationArea = All; } field(Status; Rec.Status) { ApplicationArea = All; } } } }
}
