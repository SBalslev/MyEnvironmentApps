permissionset 50701 SBX_LEASE_ACCOUNTING
{
    Assignable = true;
    Permissions =
        tabledata "SBX Lease" = RMID,
        tabledata "SBX Lease Amendment History" = R,
        tabledata "SBX Recurring Charge Line" = RMID,
        tabledata "SBX Lease Charge Template" = RMID,
        tabledata "SBX Deposit Ledger Entry" = RMID,
        tabledata "SBX Extensionarium Setup" = R;
}
