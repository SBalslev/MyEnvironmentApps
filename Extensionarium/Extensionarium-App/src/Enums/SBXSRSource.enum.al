enum 50507 "SBX SR Source"
{
    Extensible = true;
    Caption = 'Service Request Source';

    value(0; Internal) { Caption = 'Internal'; }
    value(1; TenantPortal) { Caption = 'Tenant Portal'; }
    value(2; Email) { Caption = 'Email'; }
    value(3; Phone) { Caption = 'Phone'; }
    value(4; Other) { Caption = 'Other'; }
}
