enum 50504 "SBX Charge Type"
{
    Extensible = true;
    Caption = 'Charge Type';

    value(0; BaseRent) { Caption = 'Base Rent'; }
    value(1; Service) { Caption = 'Service'; }
    value(2; Meter) { Caption = 'Meter'; }
    value(3; Deposit) { Caption = 'Deposit'; }
    value(4; Other) { Caption = 'Other'; }
}
