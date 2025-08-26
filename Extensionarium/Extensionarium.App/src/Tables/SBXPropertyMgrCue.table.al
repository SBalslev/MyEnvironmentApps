table 50020 "SBX Property Mgr Cue"
{
    Caption = 'Property Manager Cues';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10]) { Caption = 'Primary Key'; }
        field(10; "Active Properties"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("SBX Property" WHERE(Status = FILTER(Active)));
            Caption = 'Active Properties';
        }
        field(11; "Vacant Units"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("SBX Unit" WHERE(Status = FILTER(Vacant)));
            Caption = 'Vacant Units';
        }
        field(12; "Active Leases"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("SBX Lease" WHERE(Status = FILTER(Active)));
            Caption = 'Active Leases';
        }
        field(13; "Draft Leases"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("SBX Lease" WHERE(Status = FILTER(Draft)));
            Caption = 'Draft Leases';
        }
        field(14; "Open SR"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("SBX Service Request" WHERE(Status = FILTER(Open)));
            Caption = 'Open SR';
        }
        field(15; "In Progress SR"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("SBX Service Request" WHERE(Status = FILTER(InProgress)));
            Caption = 'In Progress SR';
        }
        field(16; "Unresolved SR"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("SBX Service Request" WHERE(Status = FILTER(Open|InProgress)));
            Caption = 'Unresolved SR';
        }
        field(30; "Last Refreshed"; DateTime) { Caption = 'Last Refreshed'; Editable = false; }
    field(40; "Expiring Leases (30d)"; Integer) { Caption = 'Leases Expiring 30d'; Editable = false; }
    field(41; "Open SR >7d"; Integer) { Caption = 'Open SR >7d'; Editable = false; }
    field(42; "Distinct Active Customers"; Integer) { Caption = 'Active Customers'; Editable = false; }
    }

    keys
    {
        key(PK; "Primary Key") { Clustered = true; }
    }
}
