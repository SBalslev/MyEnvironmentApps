page 50116 "SBX Lease Charge Template Card"
{
    Caption = 'Lease Charge Template';
    PageType = Card;
    SourceTable = "SBX Lease Charge Template";
    ApplicationArea = All;
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Code; Rec.Code) { ApplicationArea = All; }
                field(Description; Rec.Description) { ApplicationArea = All; }
                field("Charge Type"; Rec."Charge Type") { ApplicationArea = All; }
                field(Amount; Rec.Amount) { ApplicationArea = All; }
                field("Frequency Interval"; Rec."Frequency Interval") { ApplicationArea = All; }
                field("Frequency Type"; Rec."Frequency Type") { ApplicationArea = All; }
                field("Dimension Behavior"; Rec."Dimension Behavior") { ApplicationArea = All; }
                field(Active; Rec.Active) { ApplicationArea = All; }
                field("Requires Meter"; Rec."Requires Meter") { ApplicationArea = All; }
                field(Formula; Rec.Formula) { ApplicationArea = All; }
            }
        }
    }
}