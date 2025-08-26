enum 50508 "SBX Deposit Entry Type"
{
    Extensible = true;
    Caption = 'Deposit Entry Type';

    value(0; Collected) { Caption = 'Collected'; }
    value(1; Applied) { Caption = 'Applied'; }
    value(2; Refunded) { Caption = 'Refunded'; }
    value(3; Forfeited) { Caption = 'Forfeited'; }
}
