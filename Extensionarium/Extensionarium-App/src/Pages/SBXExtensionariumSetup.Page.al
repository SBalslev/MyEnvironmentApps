page 50100 "SBX Extensionarium Setup"
{
    Caption = 'Extensionarium Setup';
    PageType = Card;
    SourceTable = "SBX Extensionarium Setup";
    UsageCategory = Administration;
    ApplicationArea = All; // Added for AW0006 searchability

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Property No. Series"; Rec."Property No. Series") { ApplicationArea = All; ToolTip = 'No. Series used when creating properties.'; }
                field("Unit No. Series"; Rec."Unit No. Series") { ApplicationArea = All; ToolTip = 'No. Series used when creating units.'; }
                field("Lease No. Series"; Rec."Lease No. Series") { ApplicationArea = All; ToolTip = 'No. Series used when creating leases.'; }
                field("Service Req. No. Series"; Rec."Service Req. No. Series") { ApplicationArea = All; ToolTip = 'No. Series used for service requests.'; }
                field("Enable Meter"; Rec."Enable Meter") { ApplicationArea = All; ToolTip = 'Specifies if metering-related features are enabled.'; }
                field("Enable Consolidated Invoicing"; Rec."Enable Consolidated Invoicing") { ApplicationArea = All; ToolTip = 'If enabled, multiple lease charges can be combined on one invoice.'; }
                field("Unit Shortcut Dimension Code"; Rec."Unit Shortcut Dimension Code") { ApplicationArea = All; ToolTip = 'Shortcut dimension code used for units.'; }
                field("Automatic Charge Generation"; Rec."Automatic Charge Generation") { ApplicationArea = All; ToolTip = 'Automatically generate recurring charges per schedule.'; }
                field("Default Charge Desc Pattern"; Rec."Default Charge Desc Pattern") { ApplicationArea = All; ToolTip = 'Pattern used to auto-build charge descriptions.'; }
                field("Default Proration Method"; Rec."Default Proration Method") { ApplicationArea = All; ToolTip = 'Default method for prorating partial periods.'; }
                field("SR Billing Mode"; Rec."SR Billing Mode") { ApplicationArea = All; ToolTip = 'Default billing mode for service requests.'; }
                field("Rent G/L Account"; Rec."Rent G/L Account") { ApplicationArea = All; ToolTip = 'Default G/L account used for base rent charges.'; }
                field("Charge G/L Account"; Rec."Charge G/L Account") { ApplicationArea = All; ToolTip = 'Default G/L account used for other charges.'; }
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
