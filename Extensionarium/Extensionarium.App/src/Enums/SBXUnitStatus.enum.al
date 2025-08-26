enum 50501 "SBX Unit Status"
{
    Extensible = true;
    Caption = 'Unit Status';

    value(0; Vacant) { Caption = 'Vacant'; }
    value(1; Occupied) { Caption = 'Occupied'; }
    value(2; Reserved) { Caption = 'Reserved'; }
    value(3; OutOfService) { Caption = 'Out of Service'; }
}
