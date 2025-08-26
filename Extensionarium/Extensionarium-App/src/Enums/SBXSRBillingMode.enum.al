enum 50512 "SBX SR Billing Mode"
{
    Extensible = true;
    Caption = 'Service Request Billing Mode';

    value(0; Immediate) { Caption = 'Immediate'; }
    value(1; NextRentRun) { Caption = 'Next Rent Run'; }
    value(2; Configurable) { Caption = 'Configurable'; }
}
