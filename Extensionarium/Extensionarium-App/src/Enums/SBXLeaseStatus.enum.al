enum 50502 "SBX Lease Status"
{
    Extensible = true;
    Caption = 'Lease Status';

    value(0; Draft) { Caption = 'Draft'; }
    value(1; Active) { Caption = 'Active'; }
    value(2; Suspended) { Caption = 'Suspended'; }
    value(3; Terminated) { Caption = 'Terminated'; }
}
