// Welcome to your new AL extension.
// Remember that object names and IDs should be unique across all extensions.
// AL snippets start with t*, like tpageext - give them a try and happy coding!

pageextension 50130 CustomerListExt extends "Customer List"
{
    layout
    {
        addlast(Content)
        {
            field("E-Mail"; Rec."E-Mail")
            {
                ApplicationArea = All;
                trigger OnValidate()
                var
                    MailMgt: Codeunit "Mail Management";
                    EmailTxt: Text;
                begin
                    EmailTxt := Rec."E-Mail";
                    if EmailTxt = '' then
                        exit;

                    // Will raise an error itself if invalid (if available in this version)
                    MailMgt.CheckValidEmailAddress(EmailTxt);
                end;
            }
        }
    }
}

