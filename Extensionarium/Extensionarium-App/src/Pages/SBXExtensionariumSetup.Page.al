page 50100 "SBX Extensionarium Setup"
{
    Caption = 'Extensionarium Setup';
    PageType = Card;
    SourceTable = "SBX Extensionarium Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Property No. Series"; Rec."Property No. Series") { ApplicationArea = All; }
                field("Unit No. Series"; Rec."Unit No. Series") { ApplicationArea = All; }
                field("Lease No. Series"; Rec."Lease No. Series") { ApplicationArea = All; }
                field("Service Req. No. Series"; Rec."Service Req. No. Series") { ApplicationArea = All; }
                field("Enable Meter"; Rec."Enable Meter") { ApplicationArea = All; }
                field("Enable Consolidated Invoicing"; Rec."Enable Consolidated Invoicing") { ApplicationArea = All; }
                field("Unit Shortcut Dimension Code"; Rec."Unit Shortcut Dimension Code") { ApplicationArea = All; }
                field("Automatic Charge Generation"; Rec."Automatic Charge Generation") { ApplicationArea = All; }
                field("Default Charge Desc Pattern"; Rec."Default Charge Desc Pattern") { ApplicationArea = All; }
                field("Default Proration Method"; Rec."Default Proration Method") { ApplicationArea = All; }
                field("SR Billing Mode"; Rec."SR Billing Mode") { ApplicationArea = All; }
                field("Rent G/L Account"; Rec."Rent G/L Account") { ApplicationArea = All; }
                field("Charge G/L Account"; Rec."Charge G/L Account") { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(CreateDemoData)
            {
                Caption = 'Create Demo Data';
                Image = Create;
                ApplicationArea = All;
                ToolTip = 'Create a small set of demo records (Property, Units, Lease, Charge Template and Recurring Charge Line).';
                trigger OnAction()
                var
                    DemoData: Codeunit "SBX Demo Data Mgmt";
                begin
                    if not Confirm('This will create demo property, units, lease and recurring charge if they do not already exist. Continue?') then
                        exit;
                    DemoData.CreateDemoData();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Rec.Get('SETUP') then begin
            Rec.Init();
            Rec."Primary Key" := 'SETUP';
            Rec.Insert();
        end;
    end;
}
