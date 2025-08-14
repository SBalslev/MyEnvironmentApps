query 50110 "Active Lease Count"
{
    Caption = 'Active Lease Count per Unit';
    elements
    {
        dataitem(Lease; Lease)
        {
            DataItemTableFilter = Status = const(Active);
            column(Unit_No; "Unit No.") { }
            column(Lease_No; "No.") { }
            column(StartDate; "Start Date") { }
            column(EndDate; "End Date") { }
        }
    }
}

query 50111 "Service Requests Basic"
{
    Caption = 'Service Requests Basic Info';
    elements
    {
        dataitem(SR; "Service Request")
        {
            column(No; "No.") { }
            column(Status; Status) { }
            column(Category; Category) { }
            column(Priority; Priority) { }
            column(OpenedAt; "Opened At") { }
        }
    }
}
