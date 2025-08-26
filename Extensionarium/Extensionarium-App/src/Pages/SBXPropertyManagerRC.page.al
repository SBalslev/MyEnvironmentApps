page 50150 "SBX Property Manager RC"
{
    PageType = RoleCenter;
    Caption = 'Property Manager';
    ApplicationArea = All;

    layout
    {
        area(rolecenter)
        {
            part(Cues; "SBX Property Mgr Cues") { ApplicationArea = All; }
        }
    }

    actions
    {
        area(Sections)
        {
            group(NavigationGroup)
            {
                Caption = 'Navigation';
                action(Properties) { Caption = 'Properties'; ApplicationArea = All; RunObject = page "SBX Property List"; ToolTip = 'Open the list of properties.'; }
                action(Units) { Caption = 'Units'; ApplicationArea = All; RunObject = page "SBX Unit List"; ToolTip = 'Open the list of units across properties.'; }
                action(Leases) { Caption = 'Leases'; ApplicationArea = All; RunObject = page "SBX Lease List"; ToolTip = 'Open the list of leases.'; }
                action(ServiceRequests) { Caption = 'Service Requests'; ApplicationArea = All; RunObject = page "SBX Service Request List"; ToolTip = 'Open the list of service requests.'; }
                action(ChargeTemplates) { Caption = 'Charge Templates'; ApplicationArea = All; RunObject = page "SBX Lease Charge Template List"; ToolTip = 'Manage lease charge templates.'; }
                action(DepositLedger) { Caption = 'Deposit Ledger'; ApplicationArea = All; RunObject = page "SBX Deposit Ledger"; ToolTip = 'View deposit ledger entries.'; }
                action(Setup) { Caption = 'Extensionarium Setup'; ApplicationArea = All; RunObject = page "SBX Extensionarium Setup"; ToolTip = 'Configure Extensionarium settings.'; }
            }
            group(ProcessingGroup)
            {
                Caption = 'Processing';
                action(RunChargeEngine)
                { Caption = 'Run Charge Engine'; ApplicationArea = All; Image = Calculate; RunObject = codeunit "SBX Run Charge Engine"; ToolTip = 'Process due recurring charges and create draft invoices.'; }
                action(CreateDemoData)
                { Caption = 'Create Demo Data'; ApplicationArea = All; Image = Create; RunObject = codeunit "SBX Create Demo Data"; ToolTip = 'Create demo properties, units, leases, and charges.'; }
                action(RefreshCues)
                { Caption = 'Refresh KPIs'; ApplicationArea = All; Image = Refresh; RunObject = codeunit "SBX Refresh Cues"; ToolTip = 'Recalculate KPI cue values.'; }
            }
        }
    }
}
