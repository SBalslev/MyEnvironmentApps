// Renamed from SBXServiceRequestCategoryList.page.al to satisfy AA0215
page 50110 "SBX SR Category List"
{
    Caption = 'Service Request Categories';
    PageType = List;
    SourceTable = "SBX Service Request Category";
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageID = "SBX SR Category Card";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code) { ApplicationArea = All; ToolTip = 'Unique code identifying the category.'; }
                field(Description; Rec.Description) { ApplicationArea = All; ToolTip = 'Description of the category.'; }
                field("Default Priority"; Rec."Default Priority") { ApplicationArea = All; ToolTip = 'Default priority applied to new requests of this category.'; }
                field("Default Billable"; Rec."Default Billable") { ApplicationArea = All; ToolTip = 'Specifies whether requests of this category are billable by default.'; }
                field("Billing Mode Override"; Rec."Billing Mode Override") { ApplicationArea = All; ToolTip = 'Override billing mode for this category.'; }
            }
        }
    }
}
