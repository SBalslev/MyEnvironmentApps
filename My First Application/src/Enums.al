enum 50100 "Property Type"
{
    Extensible = true;
    value(0; "Single Unit") { }
    value(1; "Multi Unit") { }
}

enum 50101 "Property Status"
{
    Extensible = true;
    value(0; Active) { }
    value(1; Inactive) { }
    value(2; Sold) { }
}

enum 50102 "Unit Status"
{
    Extensible = true;
    value(0; Available) { }
    value(1; Occupied) { }
    value(2; "Under Maintenance") { }
    value(3; Inactive) { }
}

enum 50103 "Tenant Status"
{
    Extensible = true;
    value(0; Active) { }
    value(1; Former) { }
    value(2; Prospect) { }
}

enum 50104 "Lease Status"
{
    Extensible = true;
    value(0; Draft) { }
    value(1; Active) { }
    value(2; Terminated) { }
    value(3; Expired) { }
    value(4; Future) { }
}

enum 50105 "Service Category"
{
    Extensible = true;
    value(0; Plumbing) { }
    value(1; Electrical) { }
    value(2; HVAC) { }
    value(3; Appliance) { }
    value(4; Structure) { }
    value(5; Pest) { }
    value(6; Cleaning) { }
    value(7; Other) { }
}

enum 50106 "Service Priority"
{
    Extensible = true;
    value(0; Low) { }
    value(1; Medium) { }
    value(2; High) { }
    value(3; Emergency) { }
}

enum 50107 "Service Status"
{
    Extensible = true;
    value(0; New) { }
    value(1; Triaged) { }
    value(2; Assigned) { }
    value(3; "In Progress") { }
    value(4; "On Hold") { }
    value(5; Completed) { }
    value(6; Cancelled) { }
}
