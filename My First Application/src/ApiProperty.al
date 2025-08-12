page 50120 "API Property"
{
    PageType = API;
    SourceTable = Property;
    APIPublisher = 'rental';
    APIGroup = 'core';
    APIVersion = 'v1.0';
    EntityName = 'property';
    EntitySetName = 'properties';
    DelayedInsert = true;
    layout { area(content) { repeater(Group) { field(id; Rec."ID") { } field(name; Rec.Name) { } field(type; Rec.Type) { } field(city; Rec.City) { } field(status; Rec.Status) { } } } }
}
