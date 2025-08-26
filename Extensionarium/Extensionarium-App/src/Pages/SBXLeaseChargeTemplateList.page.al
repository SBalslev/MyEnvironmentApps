page 50107 "SBX Lease Charge Template List"
{
    Caption = 'Lease Charge Templates';
    PageType = List;
    SourceTable = "SBX Lease Charge Template";
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageID = "SBX Lease Charge Template Card";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code) { ApplicationArea = All; }
                field(Description; Rec.Description) { ApplicationArea = All; }
                field("Charge Type"; Rec."Charge Type") { ApplicationArea = All; }
                field(Amount; Rec.Amount) { ApplicationArea = All; }
                field("Frequency Interval"; Rec."Frequency Interval") { ApplicationArea = All; }
                field("Frequency Type"; Rec."Frequency Type") { ApplicationArea = All; }
                field(Active; Rec.Active) { ApplicationArea = All; }
            }
        }
    }
}
