page 50124 "API Service Request"
{
    PageType = API;
    SourceTable = "Service Request";
    APIPublisher = 'rental';
    APIGroup = 'core';
    APIVersion = 'v1.0';
    EntityName = 'serviceRequest';
    EntitySetName = 'serviceRequests';
    DelayedInsert = true;
    layout { area(content) { repeater(Group) { field(no; Rec."No.") { } field(propertyId; Rec."Property ID") { } field(unitNo; Rec."Unit No.") { } field(leaseNo; Rec."Lease No.") { } field(tenantNo; Rec."Tenant No.") { } field(category; Rec.Category) { } field(priority; Rec.Priority) { } field(status; Rec.Status) { } field(openedAt; Rec."Opened At") { } field(slaDueAt; Rec."SLA Due At") { } } } }
}
