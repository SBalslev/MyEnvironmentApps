page 50122 "API Tenant"
{
    PageType = API;
    SourceTable = Tenant;
    APIPublisher = 'rental';
    APIGroup = 'core';
    APIVersion = 'v1.0';
    EntityName = 'tenant';
    EntitySetName = 'tenants';
    DelayedInsert = true;
    layout { area(content) { repeater(Group) { field(no; Rec."No.") { } field(firstName; Rec."First Name") { } field(lastName; Rec."Last Name") { } field(email; Rec.Email) { } field(status; Rec.Status) { } } } }
}
