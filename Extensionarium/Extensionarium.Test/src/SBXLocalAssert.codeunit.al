codeunit 60051 "Library Assert"
{
    Subtype = Test;
    // Local lightweight assertion helpers replacing dependency on standard test library

    procedure IsTrue(Condition: Boolean; Message: Text)
    begin
        if not Condition then
            Error('%1', Message);
    end;

    procedure IsFalse(Condition: Boolean; Message: Text)
    begin
        if Condition then
            Error('%1', Message);
    end;

    procedure AreEqual(Expected: Variant; Actual: Variant; Message: Text)
    begin
        if Format(Expected) <> Format(Actual) then
            Error('%1 (Expected: %2  Actual: %3)', Message, Expected, Actual);
    end;

    procedure AreNearlyEqual(Expected: Decimal; Actual: Decimal; Tolerance: Decimal; Message: Text)
    begin
        if Abs(Expected - Actual) > Tolerance then
            Error('%1 (Expected: %2  Actual: %3  Tolerance: %4)', Message, Expected, Actual, Tolerance);
    end;

    procedure Fail(Message: Text)
    begin
        Error('%1', Message);
    end;
}