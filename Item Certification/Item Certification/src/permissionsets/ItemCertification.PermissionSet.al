namespace org.mycompany.customers.cronus.sales.item.certification;

using Microsoft.Purchases.Document;

permissionset 50102 "Item Certification"
{
    Assignable = true;
    Caption = 'Item Certification';

    Permissions =
        // Tables
        table "Furniture Certificate" = X,
        tabledata "Furniture Certificate" = RMID,
        table "Furniture Cert. Assignment" = X,
        tabledata "Furniture Cert. Assignment" = RMID,
        table "Certificate Suggestion" = X,
        tabledata "Certificate Suggestion" = RMID,

        // Table Extensions
        tabledata "Purchase Header" = RMID,

        // Codeunits
        codeunit "Furniture Certificate Mgt" = X,
        codeunit "Furniture Certificate Demo" = X,
        codeunit "Certificate Copilot Install" = X,
        codeunit "Certificate AI Generator" = X,

        // Pages
        page "Furniture Certificates" = X,
        page "Furniture Certificate Card" = X,
        page "Certificate Item Assignments" = X,
        page "Item Certificate Assignments" = X,
        page "Item Certificates" = X,
        page "Certificate Copilot" = X,
        page "Certificate Suggestions List" = X;
}
