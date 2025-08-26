enum 50505 "SBX SR Status"
{
    Extensible = true;
    Caption = 'Service Request Status';

    value(0; Open) { Caption = 'Open'; }
    value(1; InProgress) { Caption = 'In Progress'; }
    value(2; Resolved) { Caption = 'Resolved'; }
    value(3; Closed) { Caption = 'Closed'; }
}
