# Copilot Certificate Suggestion Feature

This feature uses Microsoft Copilot to suggest appropriate certificates for items based on their name, description, and user-provided requirements.

## Overview

The Certificate Suggestion feature integrates with Azure OpenAI to provide AI-powered certificate recommendations for furniture items. Users can access this feature directly from the Item Card page via a Copilot prompt action.

## Components

### 1. **Enum Extension: Certificate Copilot Capability**
- **File**: `src/enums/CertificateCopilotCapability.EnumExt.al`
- **Purpose**: Registers the "Suggest Item Certificates" capability with the Business Central Copilot framework
- Extends the `Copilot Capability` enum with a new value for certificate suggestions

### 2. **Install Codeunit: Certificate Copilot Install**
- **File**: `src/codeunits/CertificateCopilotInstall.Codeunit.al`
- **Purpose**: Registers the Copilot capability during app installation
- Registers the capability as "Preview" with "Custom Billed" billing type
- Only registers in SaaS environments

### 3. **AI Generator Codeunit: Certificate AI Generator**
- **File**: `src/codeunits/CertificateAIGenerator.Codeunit.al`
- **Purpose**: Handles communication with Azure OpenAI Service to generate certificate suggestions
- **Key Methods**:
  - `GenerateSuggestions()`: Main entry point for generating AI suggestions
  - `GetSystemPrompt()`: Defines the AI behavior and expected output format
  - `BuildUserPrompt()`: Constructs the prompt from item information and user requirements
  - `ParseResponseAndCreateSuggestions()`: Parses JSON response from AI into suggestion records

**Note**: Currently configured as a placeholder. Requires Azure OpenAI configuration:
- Azure OpenAI endpoint URL
- Deployment name
- API key

### 4. **Temporary Table: Certificate Suggestion**
- **File**: `src/tables/CertificateSuggestion.Table.al`
- **Purpose**: Holds AI-generated certificate suggestions temporarily
- **Fields**:
  - `Entry No.`: Auto-incrementing identifier
  - `Certificate Code`: Suggested certificate code
  - `Certificate Description`: Description of the certificate
  - `Certificate Type`: Type (Safety, Quality, Sustainability, Materials)
  - `Reason`: AI-generated explanation for the suggestion
  - `Selected`: Whether user wants to apply this suggestion (default: true)

### 5. **PromptDialog Page: Certificate Copilot**
- **File**: `src/pages/CertificateCopilot.Page.al`
- **Purpose**: Main Copilot UI for certificate suggestions
- **Features**:
  - Displays item name and description (read-only)
  - Input field for additional requirements
  - Prompt guide with predefined suggestions (safety, environmental, comprehensive)
  - System actions: Generate, Keep it, Discard, Regenerate
  - Displays suggestions in a ListPart
  - Automatically creates certificates and assignments when user keeps suggestions

### 6. **ListPart Page: Certificate Suggestions List**
- **File**: `src/pages/CertificateSuggestionsList.Page.al`
- **Purpose**: Displays the list of suggested certificates within the PromptDialog
- Shows: Selection checkbox, certificate code, description, type, and AI reasoning

### 7. **Page Extension: Item Card Certificate Ext**
- **File**: `src/pageextensions/ItemCardCertificateExt.PageExt.al`
- **Purpose**: Adds the Copilot prompt action to the Item Card
- **New Action**: "Suggest certificates" in the Prompting area
  - Uses Sparkle icon (standard for Copilot actions)
  - Only visible when the capability is registered
  - Opens the Certificate Copilot PromptDialog

## User Experience

1. **Launch**: User opens an Item Card and clicks the "Suggest certificates" action (sparkle icon)
2. **Input**: User sees item name and description, can add additional requirements
3. **Prompt Guides**: User can select predefined prompts or write their own
4. **Generate**: User clicks "Generate" to get AI suggestions
5. **Review**: User reviews suggestions with reasons, can deselect unwanted ones
6. **Apply**: User clicks "Keep it" to create certificates and assign them to the item

## Certificate Type Mapping

The AI suggests certificates in these categories:
- **Safety**: Safety standards and regulations
- **Quality**: Quality assurance and manufacturing standards
- **Sustainability**: Environmental sustainability and eco-friendliness
- **Materials**: Product materials and durability

These map to the existing `Furniture Certificate Type` enum values.

## Setup Required

Before this feature can be used, you need to:

1. **Azure OpenAI Access**:
   - Apply for Azure OpenAI Service access at https://aka.ms/oaiapply
   - Create an Azure OpenAI resource in Azure Portal
   - Deploy a GPT model (e.g., GPT-3.5-turbo or GPT-4)
   - Note your endpoint URL, deployment name, and API key

2. **Configuration**:
   - Update `CertificateAIGenerator.Codeunit.al`'s `GetAzureOpenAIConfiguration()` method
   - Store credentials securely in Isolated Storage or App Key Vault
   - Consider creating a setup page for administrators

3. **Testing**:
   - Test in a sandbox environment first
   - Verify certificate suggestions are relevant
   - Adjust the system prompt if needed for better results

## Future Enhancements

Potential improvements:
- Create a dedicated setup page for Azure OpenAI configuration
- Add support for using Business Central AI resources (Microsoft Billed)
- Implement caching of common suggestions
- Add feedback mechanism to improve suggestions over time
- Support for bulk certificate suggestions across multiple items
- Integration with existing certificate master data for validation

## Best Practices

- The system prompt is designed to return JSON for easy parsing
- Temperature is set to 0.3 for consistent results (adjust if needed)
- Suggestions are limited to 2-4 certificates to avoid overwhelming users
- The feature automatically creates missing certificates when applying suggestions
- All operations are done with temporary tables until user confirms

## Compliance and Responsible AI

- Feature is marked as "Preview" to signal ongoing improvements
- Users must explicitly generate and accept suggestions
- AI reasoning is displayed to users for transparency
- Only available in SaaS environments with proper Copilot licensing
- Capability can be disabled by administrators in Copilot & agent capabilities page
