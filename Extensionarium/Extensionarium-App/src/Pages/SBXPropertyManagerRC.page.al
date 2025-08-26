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
                action(Properties) { Caption = 'Properties'; ApplicationArea = All; RunObject = page "SBX Property List"; }
                action(Units) { Caption = 'Units'; ApplicationArea = All; RunObject = page "SBX Unit List"; }
                action(Leases) { Caption = 'Leases'; ApplicationArea = All; RunObject = page "SBX Lease List"; }
                action(ServiceRequests) { Caption = 'Service Requests'; ApplicationArea = All; RunObject = page "SBX Service Request List"; }
                action(ChargeTemplates) { Caption = 'Charge Templates'; ApplicationArea = All; RunObject = page "SBX Lease Charge Template List"; }
                action(DepositLedger) { Caption = 'Deposit Ledger'; ApplicationArea = All; RunObject = page "SBX Deposit Ledger"; }
                action(Setup) { Caption = 'Extensionarium Setup'; ApplicationArea = All; RunObject = page "SBX Extensionarium Setup"; }
            }
            group(ProcessingGroup)
            {
                Caption = 'Processing';
                action(RunChargeEngine)
                { Caption = 'Run Charge Engine'; ApplicationArea = All; Image = Calculate; RunObject = codeunit "SBX Run Charge Engine"; }
                action(CreateDemoData)
                { Caption = 'Create Demo Data'; ApplicationArea = All; Image = Create; RunObject = codeunit "SBX Create Demo Data"; }
                action(RefreshCues)
                { Caption = 'Refresh KPIs'; ApplicationArea = All; Image = Refresh; RunObject = codeunit "SBX Refresh Cues"; }
            }
        }
    }
}
