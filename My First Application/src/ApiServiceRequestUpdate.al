page 50125 "API Service Request Update"
{
    PageType = API;
    SourceTable = "Service Request Update";
    APIPublisher = 'rental';
    APIGroup = 'core';
    APIVersion = 'v1.0';
    EntityName = 'serviceRequestUpdate';
    EntitySetName = 'serviceRequestUpdates';
    DelayedInsert = true;
    layout { area(content) { repeater(Group) { field(entryNo; Rec."Entry No.") { } field(serviceRequestNo; Rec."Service Request No.") { } field(oldStatus; Rec."Old Status") { } field(newStatus; Rec."New Status") { } field(note; Rec.Note) { } field(changedBy; Rec."Changed By") { } field(changeTime; Rec."Change Time") { } } } }
}
