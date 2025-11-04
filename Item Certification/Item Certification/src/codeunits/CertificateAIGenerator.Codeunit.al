namespace org.mycompany.customers.cronus.sales.item.certification;

using System.AI;
using System.Text;
using System.Environment;

codeunit 50103 "Certificate AI Generator"
{
    procedure GenerateSuggestions(ItemName: Text[100]; ItemDescription: Text[100]; UserInstructions: Text; var CertificateSuggestion: Record "Certificate Suggestion")
    var
        AzureOpenAI: Codeunit "Azure OpenAI";
        AOAIChatCompletionParams: Codeunit "AOAI Chat Completion Params";
        AOAIChatMessages: Codeunit "AOAI Chat Messages";
        AOAIOperationResponse: Codeunit "AOAI Operation Response";
        Prompt: Text;
        ResponseText: Text;
    begin
        AzureOpenAI.SetCopilotCapability(Enum::"Copilot Capability"::"Suggest Item Certificates");

        // Set up authorization (this should be configured in setup)
        SetAuthorization(AzureOpenAI);

        // Set up parameters for generation
        SetChatParameters(AOAIChatCompletionParams);

        // Build the metaprompt (system message)
        AOAIChatMessages.SetPrimarySystemMessage(GetSystemPrompt());

        // Build the user prompt
        Prompt := BuildUserPrompt(ItemName, ItemDescription, UserInstructions);
        AOAIChatMessages.AddUserMessage(Prompt);

        // Generate the response
        AzureOpenAI.GenerateChatCompletion(AOAIChatMessages, AOAIChatCompletionParams, AOAIOperationResponse);

        if AOAIOperationResponse.IsSuccess() then begin
            ResponseText := AOAIChatMessages.GetLastMessage();
            ParseResponseAndCreateSuggestions(ResponseText, CertificateSuggestion);
        end else
            Error('Failed to generate suggestions: %1', AOAIOperationResponse.GetError());
    end;

    local procedure SetAuthorization(var AzureOpenAI: Codeunit "Azure OpenAI")
    var
        EnvironmentInformation: Codeunit "Environment Information";
        AOAIDeployments: Codeunit "AOAI Deployments";
        Endpoint: Text;
        Deployment: Text;
        ApiKey: SecretText;
    begin
        // Use Business Central AI resources in SaaS production environments
        // Use custom subscription for development/testing in non-SaaS environments
        if not EnvironmentInformation.IsSaaSInfrastructure() then begin
            // Development/testing with custom Azure OpenAI subscription
            if not GetAzureOpenAIConfiguration(Endpoint, Deployment, ApiKey) then
                Error('Azure OpenAI configuration is not set up. Please configure the connection in the setup page.');
            AzureOpenAI.SetAuthorization(Enum::"AOAI Model Type"::"Chat Completions", Endpoint, Deployment, ApiKey);
        end else
            // Production: Use Business Central managed AI resources (GPT-4.1)
            AzureOpenAI.SetManagedResourceAuthorization(
                Enum::"AOAI Model Type"::"Chat Completions",
                AOAIDeployments.GetGPT41Latest());
    end;

    local procedure GetAzureOpenAIConfiguration(var Endpoint: Text; var Deployment: Text; var ApiKey: SecretText): Boolean
    var
        EmptySecret: SecretText;
    begin
        // TODO: Implement retrieval of Azure OpenAI configuration from setup or isolated storage
        // This is only used for development/testing in non-SaaS environments
        // In SaaS production, Business Central managed AI resources are used automatically

        // Suppress warnings by initializing output parameters
        Endpoint := '';
        Deployment := '';
        ApiKey := EmptySecret;

        exit(false); // Return false for now to indicate configuration is needed
    end;

    local procedure SetChatParameters(var AOAIChatCompletionParams: Codeunit "AOAI Chat Completion Params")
    begin
        AOAIChatCompletionParams.SetMaxTokens(2000);
        AOAIChatCompletionParams.SetTemperature(0.3); // Lower temperature for more consistent results
    end;

    local procedure GetSystemPrompt(): Text
    begin
        // Read the system prompt from the resource file
        exit(NavApp.GetResourceAsText('prompts/CertificateSuggestionSystemPrompt.txt', TextEncoding::UTF8));
    end;

    local procedure BuildUserPrompt(ItemName: Text[100]; ItemDescription: Text[100]; UserInstructions: Text): Text
    var
        Prompt: TextBuilder;
        ItemNameLbl: Label 'Item Name: %1', Locked = true;
        ItemDescriptionLbl: Label 'Item Description: %1', Locked = true;
        AdditionalRequirementsLbl: Label 'Additional Requirements: %1', Locked = true;
    begin
        Prompt.AppendLine('Please suggest appropriate certificates for the following item:');
        Prompt.AppendLine('');
        Prompt.AppendLine(StrSubstNo(ItemNameLbl, ItemName));

        if ItemDescription <> '' then
            Prompt.AppendLine(StrSubstNo(ItemDescriptionLbl, ItemDescription));

        if UserInstructions <> '' then begin
            Prompt.AppendLine('');
            Prompt.AppendLine(StrSubstNo(AdditionalRequirementsLbl, UserInstructions));
        end;

        exit(Prompt.ToText());
    end;

    local procedure ParseResponseAndCreateSuggestions(ResponseText: Text; var CertificateSuggestion: Record "Certificate Suggestion")
    var
        JsonArray: JsonArray;
        JsonToken: JsonToken;
        JsonObject: JsonObject;
        i: Integer;
        EntryNo: Integer;
        CertificateCode: Text;
        Description: Text;
        CertType: Text;
        Reason: Text;
    begin
        // Ensure we start with a clean slate
        CertificateSuggestion.Reset();
        if not CertificateSuggestion.IsTemporary then
            Error('Certificate Suggestion must be a temporary record');
        CertificateSuggestion.DeleteAll();

        // Try to parse as JSON
        if not JsonArray.ReadFrom(ResponseText) then begin
            // If parsing fails, create a single suggestion with the response
            CreateFallbackSuggestion(ResponseText, CertificateSuggestion);
            exit;
        end;

        // Initialize entry number counter
        EntryNo := 1;

        // Parse each certificate suggestion from the JSON array
        for i := 0 to JsonArray.Count() - 1 do begin
            JsonArray.Get(i, JsonToken);
            if JsonToken.IsObject() then begin
                JsonObject := JsonToken.AsObject();

                // Extract values from JSON
                CertificateCode := GetJsonValue(JsonObject, 'certificateCode');
                Description := GetJsonValue(JsonObject, 'description');
                CertType := GetJsonValue(JsonObject, 'type');
                Reason := GetJsonValue(JsonObject, 'reason');

                // Create the suggestion record - set Entry No. LAST to avoid it being reset
                Clear(CertificateSuggestion);
                CertificateSuggestion."Certificate Code" := CopyStr(CertificateCode, 1, MaxStrLen(CertificateSuggestion."Certificate Code"));
                CertificateSuggestion."Certificate Description" := CopyStr(Description, 1, MaxStrLen(CertificateSuggestion."Certificate Description"));
                CertificateSuggestion."Certificate Type" := ParseCertificateType(CertType);
                CertificateSuggestion.Reason := CopyStr(Reason, 1, MaxStrLen(CertificateSuggestion.Reason));
                CertificateSuggestion.Selected := true;
                CertificateSuggestion."Entry No." := EntryNo;  // Set Entry No. last
                if not CertificateSuggestion.Insert(false) then
                    Error('Failed to insert suggestion with Entry No. %1. Current record Entry No: %2', EntryNo, CertificateSuggestion."Entry No.");
                EntryNo += 1;
            end;
        end;
    end;

    local procedure GetJsonValue(JsonObject: JsonObject; PropertyName: Text): Text
    var
        JsonToken: JsonToken;
    begin
        if JsonObject.Get(PropertyName, JsonToken) then
            exit(JsonToken.AsValue().AsText());
        exit('');
    end;

    local procedure ParseCertificateType(TypeText: Text): Enum "Furniture Certificate Type"
    begin
        case UpperCase(TypeText) of
            'SAFETY':
                exit(Enum::"Furniture Certificate Type"::Safety);
            'QUALITY':
                exit(Enum::"Furniture Certificate Type"::Quality);
            'SUSTAINABILITY', 'ENVIRONMENTAL':
                exit(Enum::"Furniture Certificate Type"::Sustainability);
            'MATERIALS', 'DURABILITY':
                exit(Enum::"Furniture Certificate Type"::Materials);
            else
                exit(Enum::"Furniture Certificate Type"::Quality); // Default
        end;
    end;

    local procedure CreateFallbackSuggestion(ResponseText: Text; var CertificateSuggestion: Record "Certificate Suggestion")
    begin
        // Create a single suggestion if JSON parsing fails
        Clear(CertificateSuggestion);
        CertificateSuggestion."Certificate Code" := 'AI-SUGGEST';
        CertificateSuggestion."Certificate Description" := 'AI Generated Suggestion';
        CertificateSuggestion."Certificate Type" := Enum::"Furniture Certificate Type"::Quality;
        CertificateSuggestion.Reason := CopyStr(ResponseText, 1, MaxStrLen(CertificateSuggestion.Reason));
        CertificateSuggestion.Selected := true;
        CertificateSuggestion."Entry No." := 1;  // Set Entry No. last
        if not CertificateSuggestion.Insert(false) then
            Error('Failed to insert fallback suggestion. Entry No: %1', CertificateSuggestion."Entry No.");
    end;
}
