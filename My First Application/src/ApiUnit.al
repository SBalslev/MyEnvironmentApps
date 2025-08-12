page 50121 "API Unit"
{
    PageType = API;
    SourceTable = Unit;
    APIPublisher = 'rental';
    APIGroup = 'core';
    APIVersion = 'v1.0';
    EntityName = 'unit';
    EntitySetName = 'units';
    DelayedInsert = true;
    layout { area(content) { repeater(Group) { field(no; Rec."No.") { } field(propertyId; Rec."Property ID") { } field(label; Rec."Unit Label") { } field(status; Rec.Status) { } field(marketRent; Rec."Market Rent") { } } } }
}
