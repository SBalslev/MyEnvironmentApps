codeunit 50306 "SBX Dimension Helper"
{
    procedure ApplyDimensionsFromLease(var TargetDimSetID: Integer; LeaseNo: Code[20]; DimBehavior: Enum "SBX Dimension Behavior")
    var
        Lease: Record "SBX Lease";
        Property: Record "SBX Property";
        Unit: Record "SBX Unit";
        DimMgt: Codeunit DimensionManagement;
        DimBuf: Record "Dimension Set Entry" temporary;
        SourceDimBuf: Record "Dimension Set Entry" temporary;
        NewDimSetID: Integer;
    begin
        if not Lease.Get(LeaseNo) then
            exit;

        // Start from Lease dimension set if present
        if Lease."Dimension Set ID" <> 0 then
            LoadDimSetIntoBuf(Lease."Dimension Set ID", SourceDimBuf);

        case DimBehavior of
            DimBehavior::None:
                begin
                    // do nothing extra
                end;
            DimBehavior::PropertyOnly, DimBehavior::PropertyAndUnit:
                begin
                    if Property.Get(Lease."Property Code") then
                        if Property."Dimension Set ID" <> 0 then
                            MergeDimSetEntries(Property."Dimension Set ID", SourceDimBuf);
                    if (DimBehavior = DimBehavior::PropertyAndUnit) and (Lease."Unit Code" <> '') then
                        if Unit.Get(Lease."Property Code", Lease."Unit Code") then
                            if Unit."Dimension Set ID" <> 0 then
                                MergeDimSetEntries(Unit."Dimension Set ID", SourceDimBuf);
                end;
        end;

        // Copy merged entries into DimBuf
        if SourceDimBuf.FindSet() then
            repeat
                DimBuf := SourceDimBuf;
                DimBuf.Insert();
            until SourceDimBuf.Next() = 0;

        if not DimBuf.IsEmpty() then begin
            NewDimSetID := DimMgt.GetDimensionSetID(DimBuf);
            if TargetDimSetID <> NewDimSetID then
                TargetDimSetID := NewDimSetID;
        end;
    end;

    local procedure MergeDimSetEntries(AppendDimSetID: Integer; var TargetBuf: Record "Dimension Set Entry" temporary)
    var
        TempBuf: Record "Dimension Set Entry" temporary;
    begin
        if AppendDimSetID = 0 then
            exit;
        TempBuf.DeleteAll();
        LoadDimSetIntoBuf(AppendDimSetID, TempBuf);
        if TempBuf.FindSet() then
            repeat
                if not ExistsInBuf(TargetBuf, TempBuf."Dimension Code", TempBuf."Dimension Value Code") then
                    InsertIntoBuf(TargetBuf, TempBuf."Dimension Code", TempBuf."Dimension Value Code");
            until TempBuf.Next() = 0;
    end;

    local procedure LoadDimSetIntoBuf(DimSetID: Integer; var Buf: Record "Dimension Set Entry" temporary)
    var
        DimSetEntry: Record "Dimension Set Entry";
    begin
        if DimSetID = 0 then
            exit;
        DimSetEntry.SetRange("Dimension Set ID", DimSetID);
        if DimSetEntry.FindSet() then
            repeat
                InsertIntoBuf(Buf, DimSetEntry."Dimension Code", DimSetEntry."Dimension Value Code");
            until DimSetEntry.Next() = 0;
    end;

    local procedure ExistsInBuf(var Buf: Record "Dimension Set Entry" temporary; DimCode: Code[20]; DimValueCode: Code[20]): Boolean
    begin
        if Buf.FindFirst() then begin
            if Buf.Get(Buf."Dimension Set ID", DimCode, DimValueCode) then; // attempt direct (will fail because key differs) - fallback loop
        end;
        exit(FindInBuf(Buf, DimCode, DimValueCode));
    end;

    local procedure FindInBuf(var Buf: Record "Dimension Set Entry" temporary; DimCode: Code[20]; DimValueCode: Code[20]): Boolean
    var
        Tmp: Record "Dimension Set Entry" temporary;
    begin
        if Buf.FindSet() then
            repeat
                if (Buf."Dimension Code" = DimCode) and (Buf."Dimension Value Code" = DimValueCode) then
                    exit(true);
            until Buf.Next() = 0;
        exit(false);
    end;

    local procedure InsertIntoBuf(var Buf: Record "Dimension Set Entry" temporary; DimCode: Code[20]; DimValueCode: Code[20])
    begin
        if FindInBuf(Buf, DimCode, DimValueCode) then
            exit;
        Buf.Init();
        Buf."Dimension Code" := DimCode;
        Buf."Dimension Value Code" := DimValueCode;
        Buf.Insert();
    end;
}