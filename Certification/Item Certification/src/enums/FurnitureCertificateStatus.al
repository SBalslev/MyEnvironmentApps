enum 50100 "Furniture Certificate Status"
{
    Extensible = true;
    Caption = 'Furniture Certificate Status';

    value(0; Pending)
    {
        Caption = 'Pending';
    }
    value(1; Active)
    {
        Caption = 'Active';
    }
    value(2; Expired)
    {
        Caption = 'Expired';
    }
    value(3; Suspended)
    {
        Caption = 'Suspended';
    }
}
