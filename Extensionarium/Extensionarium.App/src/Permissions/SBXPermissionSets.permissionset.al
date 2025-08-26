permissionset 50700 SBX_PROPERTY_MGR
{
    Assignable = true;
    Permissions =
        tabledata "SBX Property" = RMID,
        tabledata "SBX Unit" = RMID,
        tabledata "SBX Lease" = RMID,
        tabledata "SBX Lease Charge Template" = RMID,
        tabledata "SBX Recurring Charge Line" = RMID,
        tabledata "SBX Service Request" = R,
        tabledata "SBX Service Request Category" = R,
        tabledata "SBX Deposit Ledger Entry" = R,
    tabledata "SBX Extensionarium Setup" = R,
    tabledata "SBX Property Mgr Cue" = R;
}

permissionset 50701 SBX_LEASE_ACCOUNTING
{
    Assignable = true;
    Permissions =
        tabledata "SBX Lease" = RMID,
        tabledata "SBX Recurring Charge Line" = RMID,
        tabledata "SBX Lease Charge Template" = RMID,
        tabledata "SBX Deposit Ledger Entry" = RMID,
        tabledata "SBX Extensionarium Setup" = R;
}

permissionset 50702 SBX_SERVICE_DESK
{
    Assignable = true;
    Permissions =
        tabledata "SBX Service Request" = RMID,
        tabledata "SBX Service Request Category" = RMID,
        tabledata "SBX Property" = R,
        tabledata "SBX Unit" = R,
        tabledata "SBX Lease" = R;
}

permissionset 50703 SBX_VIEWER
{
    Assignable = true;
    Permissions =
        tabledata "SBX Property" = R,
        tabledata "SBX Unit" = R,
        tabledata "SBX Lease" = R,
        tabledata "SBX Lease Charge Template" = R,
        tabledata "SBX Recurring Charge Line" = R,
        tabledata "SBX Service Request" = R,
        tabledata "SBX Service Request Category" = R,
    tabledata "SBX Deposit Ledger Entry" = R,
    tabledata "SBX Property Mgr Cue" = R;
}

permissionset 50704 SBX_SETUP
{
    Assignable = false;
    Permissions =
    tabledata "SBX Extensionarium Setup" = RMID,
    tabledata "SBX Property" = RMID,
    tabledata "SBX Unit" = RMID,
    tabledata "SBX Lease" = RMID,
    tabledata "SBX Lease Charge Template" = RMID,
    tabledata "SBX Recurring Charge Line" = RMID,
    tabledata "SBX Property Mgr Cue" = RMID;
}
