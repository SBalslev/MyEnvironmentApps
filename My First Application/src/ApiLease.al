page 50123 "API Lease"
{
    PageType = API;
    SourceTable = Lease;
    APIPublisher = 'rental';
    APIGroup = 'core';
    APIVersion = 'v1.0';
    EntityName = 'lease';
    EntitySetName = 'leases';
    DelayedInsert = true;
    layout { area(content) { repeater(Group) { field(no; Rec."No.") { } field(unitNo; Rec."Unit No.") { } field(tenantNo; Rec."Tenant No.") { } field(startDate; Rec."Start Date") { } field(endDate; Rec."End Date") { } field(status; Rec.Status) { } field(rentAmount; Rec."Rent Amount") { } } } }
}
