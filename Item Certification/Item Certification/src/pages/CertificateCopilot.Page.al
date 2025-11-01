namespace org.mycompany.customers.cronus.sales.item.certification;

using Microsoft.Inventory.Item;

page 50105 "Certificate Copilot"
{
    Caption = 'Suggest Item Certificates with Copilot';
    PageType = PromptDialog;
    Extensible = false;
    IsPreview = true;
    PromptMode = Prompt;
    DataCaptionExpression = UserInstructions;

    layout
    {
        area(Prompt)
        {
            field(ItemNameField; ItemName)
            {
                ApplicationArea = All;
                Caption = 'Item Name';
                ToolTip = 'Specifies the name of the item for which certificates should be suggested.';
                Editable = false;
            }
            field(ItemDescriptionField; ItemDescription)
            {
                ApplicationArea = All;
                Caption = 'Item Description';
                ToolTip = 'Specifies the description of the item.';
                Editable = false;
            }
            field(UserInstructionsField; UserInstructions)
            {
                ApplicationArea = All;
                Caption = 'Additional Requirements';
                ShowCaption = false;
                MultiLine = true;
                InstructionalText = 'Describe any specific certificate requirements or considerations for this item...';
                ToolTip = 'Enter any specific requirements or considerations for certificate selection.';
            }
        }

        area(Content)
        {
            part(SuggestionsPart; "Certificate Suggestions List")
            {
                ApplicationArea = All;
                Caption = 'Suggested Certificates';
                Visible = SuggestionsVisible;
            }
        }
    }

    actions
    {
        area(PromptGuide)
        {
            action(SafetyCertificates)
            {
                ApplicationArea = All;
                Caption = 'Focus on safety certificates';
                ToolTip = 'Suggest certificates related to safety standards and regulations.';

                trigger OnAction()
                begin
                    UserInstructions := 'Focus on safety-related certificates and compliance with safety regulations.';
                end;
            }

            action(EnvironmentalCertificates)
            {
                ApplicationArea = All;
                Caption = 'Focus on environmental certificates';
                ToolTip = 'Suggest certificates related to environmental sustainability.';

                trigger OnAction()
                begin
                    UserInstructions := 'Focus on environmental and sustainability certificates, such as eco-friendly materials and carbon footprint.';
                end;
            }

            action(AllCertificates)
            {
                ApplicationArea = All;
                Caption = 'Suggest comprehensive certificates';
                ToolTip = 'Suggest a comprehensive set of certificates covering safety, quality, and compliance.';

                trigger OnAction()
                begin
                    UserInstructions := 'Suggest a comprehensive set of certificates covering safety, quality, environmental, and compliance aspects.';
                end;
            }
        }

        area(SystemActions)
        {
            systemaction(Generate)
            {
                Caption = 'Generate';
                ToolTip = 'Generate certificate suggestions with Copilot.';

                trigger OnAction()
                begin
                    RunGeneration();
                end;
            }

            systemaction(OK)
            {
                Caption = 'Keep it';
                ToolTip = 'Apply the selected certificate suggestions to the item.';
            }

            systemaction(Cancel)
            {
                Caption = 'Discard';
                ToolTip = 'Discard the certificate suggestions.';
            }

            systemaction(Regenerate)
            {
                Caption = 'Regenerate';
                ToolTip = 'Regenerate certificate suggestions with Copilot.';

                trigger OnAction()
                begin
                    RunGeneration();
                end;
            }
        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction = CloseAction::OK then
            ApplySelectedCertificates();
    end;

    procedure SetItemInfo(Item: Record Item)
    begin
        ItemNo := Item."No.";
        ItemName := Item.Description;
        ItemDescription := Item."Description 2";
    end;

    local procedure RunGeneration()
    var
        TempCertSuggestion: Record "Certificate Suggestion" temporary;
        AIGenerator: Codeunit "Certificate AI Generator";
        ProgressDialog: Dialog;
    begin
        if ItemNo = '' then
            Error('Item information is required to generate certificate suggestions.');

        ProgressDialog.Open('Generating certificate suggestions with Copilot...');

        ClearSuggestions();

        AIGenerator.GenerateSuggestions(ItemName, ItemDescription, UserInstructions, TempCertSuggestion);

        ProgressDialog.Close();

        if not TempCertSuggestion.IsEmpty() then begin
            TempCertificateSuggestion.Copy(TempCertSuggestion, true);
            SuggestionsVisible := true;
            CurrPage.SuggestionsPart.Page.LoadSuggestions(TempCertificateSuggestion);
        end else
            SuggestionsVisible := false;

        CurrPage.Update(false);
    end;

    local procedure ClearSuggestions()
    begin
        TempCertificateSuggestion.Reset();
        TempCertificateSuggestion.DeleteAll();
        SuggestionsVisible := false;
    end;

    local procedure ApplySelectedCertificates()
    var
        Item: Record Item;
        Certificate: Record "Furniture Certificate";
        Assignment: Record "Furniture Cert. Assignment";
        SelectedCount: Integer;
        AppliedCount: Integer;
    begin
        if not Item.Get(ItemNo) then
            Error('Item %1 not found.', ItemNo);

        CurrPage.SuggestionsPart.Page.GetSuggestions(TempCertificateSuggestion);

        TempCertificateSuggestion.SetRange(Selected, true);
        SelectedCount := TempCertificateSuggestion.Count();

        if SelectedCount = 0 then
            exit;

        if TempCertificateSuggestion.FindSet() then
            repeat
                // Check if certificate exists, if not create it
                if not Certificate.Get(TempCertificateSuggestion."Certificate Code") then begin
                    Certificate.Init();
                    Certificate.Code := TempCertificateSuggestion."Certificate Code";
                    Certificate.Description := TempCertificateSuggestion."Certificate Description";
                    Certificate."Certificate Type" := TempCertificateSuggestion."Certificate Type";
                    Certificate.Insert(true);
                end;

                // Check if assignment already exists
                if not Assignment.Get(ItemNo, TempCertificateSuggestion."Certificate Code") then begin
                    Assignment.Init();
                    Assignment."Item No." := ItemNo;
                    Assignment."Certificate Code" := TempCertificateSuggestion."Certificate Code";
                    Assignment.Insert(true);
                    AppliedCount += 1;
                end;
            until TempCertificateSuggestion.Next() = 0;

        if AppliedCount > 0 then
            Message('%1 certificate(s) have been assigned to item %2.', AppliedCount, ItemNo)
        else
            Message('All suggested certificates were already assigned to this item.');
    end;

    var
        TempCertificateSuggestion: Record "Certificate Suggestion" temporary;
        ItemNo: Code[20];
        ItemName: Text[100];
        ItemDescription: Text[100];
        UserInstructions: Text;
        SuggestionsVisible: Boolean;
}
