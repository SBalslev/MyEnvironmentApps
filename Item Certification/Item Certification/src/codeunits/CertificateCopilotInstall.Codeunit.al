namespace org.mycompany.customers.cronus.sales.item.certification;

using System.AI;
using System.Environment;

codeunit 50102 "Certificate Copilot Install"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    begin
        RegisterCapability();
    end;

    local procedure RegisterCapability()
    var
        CopilotCapability: Codeunit "Copilot Capability";
        EnvironmentInformation: Codeunit "Environment Information";
        LearnMoreUrlTxt: Label 'https://learn.microsoft.com/dynamics365/business-central', Locked = true;
    begin
        if not EnvironmentInformation.IsSaaSInfrastructure() then
            exit;

        if not CopilotCapability.IsCapabilityRegistered(Enum::"Copilot Capability"::"Suggest Item Certificates") then
            CopilotCapability.RegisterCapability(
                Enum::"Copilot Capability"::"Suggest Item Certificates",
                Enum::"Copilot Availability"::Preview,
                Enum::"Copilot Billing Type"::"Microsoft Billed",
                LearnMoreUrlTxt);
    end;
}
