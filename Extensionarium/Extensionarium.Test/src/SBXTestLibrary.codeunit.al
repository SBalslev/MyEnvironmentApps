codeunit 60000 "SBX Test Library"
{
    Subtype = Test;

    procedure EnsureCustomer(CustomerNo: Code[20]; Name: Text[100])
    var
        Cust: Record Customer;
    begin
        if Cust.Get(CustomerNo) then
            exit;
        Cust.Init();
        Cust.Validate("No.", CustomerNo);
        Cust.Validate(Name, Name);
        Cust.Insert(true);
    end;

    procedure EnsureGLAccount(GLNo: Code[20]; Name: Text[100])
    var
        GL: Record "G/L Account";
    begin
        if GL.Get(GLNo) then
            exit;
        GL.Init();
        GL.Validate("No.", GLNo);
        GL.Validate(Name, Name);
        GL.Insert(true);
    end;

    procedure EnsureProperty(PropertyCode: Code[20]; Name: Text[100])
    var
        Prop: Record "SBX Property";
    begin
        if Prop.Get(PropertyCode) then
            exit;
        Prop.Init();
        Prop.Validate(Code, PropertyCode);
        Prop.Validate(Name, Name);
        Prop.Insert(true);
    end;

    procedure EnsureUnit(PropertyCode: Code[20]; UnitCode: Code[20])
    var
        Unit: Record "SBX Unit";
    begin
        if Unit.Get(PropertyCode, UnitCode) then
            exit;
        Unit.Init();
        Unit.Validate("Property Code", PropertyCode);
        Unit.Validate("Unit Code", UnitCode);
        Unit.Insert(true);
    end;

    procedure EnsureSetup(DefaultProration: Enum "SBX Proration Method")
    var
        Setup: Record "SBX Extensionarium Setup";
    begin
        if not Setup.Get() then begin
            Setup.Init();
            Setup.Insert();
        end;
        Setup.Validate("Default Proration Method", DefaultProration);
        Setup.Modify(true);
    end;

    procedure CreateLease(var Lease: Record "SBX Lease"; CustomerNo: Code[20]; PropertyCode: Code[20]; UnitCode: Code[20]; StartDate: Date; EndDate: Date; BaseRent: Decimal)
    begin
        Lease.Init();
        Lease.Validate("Customer No.", CustomerNo);
        Lease.Validate("Property Code", PropertyCode);
        Lease.Validate("Unit Code", UnitCode);
        Lease.Validate("Start Date", StartDate);
        Lease.Validate("End Date", EndDate);
        Lease.Validate("Base Rent Amount", BaseRent);
        Lease.Insert(true);
    end;
}
