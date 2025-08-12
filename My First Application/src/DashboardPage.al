page 50136 "Rental Dashboard"
{
    PageType = CardPart;
    SourceTable = "Rental KPI Buffer";
    ApplicationArea = All;
    layout { area(content) { repeater(KPI) { field(Code; Rec.Code) { ApplicationArea = All; } field(Description; Rec.Description) { ApplicationArea = All; } field(Value; Rec.Value) { ApplicationArea = All; } field("As Of"; Rec."As Of") { ApplicationArea = All; } } } }
    actions { area(processing) { action(Refresh) { Caption = 'Refresh KPIs'; ApplicationArea = All; trigger OnAction() var Mgt: Codeunit "Rental KPI Mgt"; begin Mgt.RefreshKPIs; CurrPage.Update(false); end; } } }
}
