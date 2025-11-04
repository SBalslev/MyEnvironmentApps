namespace org.mycompany.customers.cronus.sales.item.certification;

permissionset 50100 GeneratedPermission
{
    Assignable = true;
    Permissions =
        // Tables
        tabledata "Furniture Certificate" = RIMD,
        tabledata "Furniture Cert. Assignment" = RIMD,
        tabledata "Certificate Suggestion" = RIMD,
        table "Furniture Certificate" = X,
        table "Furniture Cert. Assignment" = X,
        table "Certificate Suggestion" = X,

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
