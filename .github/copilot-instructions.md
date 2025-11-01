# GitHub Copilot Instructions for Business Central AL Development

This workspace contains Business Central AL extensions. When working with code in this workspace, follow these guidelines and best practices.

## Project Context

This is a Business Central AL workspace using AL-Go for GitHub workflows. The project includes:
- AL extensions with tables, pages, codeunits, and other AL objects
- Test apps for automated testing
- AL-Go workflows for CI/CD automation

## AL Language Guidelines

### File Naming Conventions

Follow these file naming patterns:

| Object Type | Pattern | Example |
|------------|---------|---------|
| Page | `<ObjectName>.Page.al` | `CustomerCard.Page.al` |
| Page Extension | `<ObjectName>.PageExt.al` | `CustomerCardExt.PageExt.al` |
| Table | `<ObjectName>.Table.al` | `FurnitureCertificate.Table.al` |
| Table Extension | `<ObjectName>.TableExt.al` | `ItemTableExt.TableExt.al` |
| Codeunit | `<ObjectName>.Codeunit.al` | `FurnitureCertificateMgt.Codeunit.al` |
| Enum | `<ObjectName>.Enum.al` | `FurnitureCertificateStatus.Enum.al` |
| Enum Extension | `<ObjectName>.EnumExt.al` | `StatusEnumExt.EnumExt.al` |
| Report | `<ObjectName>.Report.al` | `SalesReport.Report.al` |
| Query | `<ObjectName>.Query.al` | `CustomerQuery.Query.al` |
| XMLport | `<ObjectName>.Xmlport.al` | `DataExport.Xmlport.al` |
| Interface | `<ObjectName>.Interface.al` | `IProcessor.Interface.al` |
| Permission Set | `<ObjectName>.PermissionSet.al` | `AppPermissions.PermissionSet.al` |

### Object Naming

- Use PascalCase for all object names
- Prefix objects with a feature or group name (e.g., `FurnitureCertificate`, `ItemCertification`)
- Keep names descriptive and meaningful
- Avoid abbreviations unless widely understood
- Example: `codeunit 50100 "FurnitureCertificate Mgt."`

### File Structure

Always organize AL files in this order:

1. **Properties** (at the top)
2. **Object-specific constructs**:
   - Table fields
   - Page layout
   - Actions
   - Triggers
3. **Global variables** (organized as):
   - Labels
   - Other global variables
4. **Methods/Procedures** (at the bottom)

### Coding Standards

#### Formatting
- Use **lowercase** for all AL keywords (`procedure`, `begin`, `end`, `if`, `then`, `else`, etc.)
- Use **four spaces** for indentation (not tabs)
- Curly brackets `{}` must start on a new line
- Keep lines readable; avoid excessive line length
- Add blank lines between method declarations

#### Variable Naming
- Use **PascalCase** for all variables and fields
- Prefix temporary variables with `Temp` (e.g., `TempCustomer: Record Customer temporary;`)
- Include the object name in variable names (e.g., `Customer: Record Customer;`)
- Use descriptive names; avoid single-letter variables except for loop counters

#### Method Declarations
- Method names use **PascalCase**
- Add a space after semicolons when declaring multiple parameters
- Include blank lines between methods
- Example:
  ```al
  local procedure CalculateTotal(Customer: Record Customer; Amount: Decimal): Decimal
  begin
      // Implementation
  end;
  ```

#### Type Definitions
- Place a colon immediately after the variable/parameter name
- Add a single space after the colon before the type
- Example: `MyVariable: Integer;`

#### Method Calls
- Include a space after commas when passing multiple parameters
- Always use parentheses for method calls, even with no parameters
- Examples:
  ```al
  MyProcedure();
  MyProcedure(1);
  MyProcedure(1, 2);
  ```

### Code Organization Best Practices

#### Codeunit-First Approach
- **Write business logic in codeunits**, not directly in table or page triggers
- This promotes code reuse, testability, and security
- Example: Don't put complex calculations in OnValidate triggers; call a codeunit method instead

#### Defensive Programming
- **Don't trust input**: Validate all parameters and user inputs
- **Return status codes**: Return Boolean from methods to indicate success/failure
- **Handle errors gracefully**: Use try-catch patterns and provide meaningful error messages
- **Check permissions**: Use `InherentPermissions` attribute where appropriate
- **Validate type conversions**: Always check conversion success before proceeding

#### Error Handling
- Use `Error()` for unrecoverable errors that should stop execution
- Use `TestField()` for required field validation
- Provide context-specific error messages, not just system errors
- Consider implementing resilience patterns for external service calls (retry, circuit breaker)
- Return Boolean status codes from methods to help callers write robust code

#### Reference by Name
- Always reference AL objects by **name**, not by ID
- Example:
  ```al
  Page.RunModal(Page::"Customer Card", Customer);
  var
      Customer: Record Customer;
  ```

### Application Area and Usage Category

- Always set `ApplicationArea` property on pages, controls, actions, and fields
- Set `UsageCategory` on pages and reports to make them searchable
- Example:
  ```al
  ApplicationArea = All;
  UsageCategory = Lists;
  ```

### Events and Extensibility

- Use events to make your code extensible
- Prefer events over modifying existing code
- Document event parameters clearly
- Don't assume order of event subscriber execution

### Testing

- Write test codeunits for all business logic
- Use the `[Test]` attribute on test procedures
- Use handler functions (`[MessageHandler]`, `[ConfirmHandler]`, etc.) for UI interactions
- Test with realistic permission sets, **not SUPER**
- Organize tests in separate test apps

### Performance Considerations

- Business Central runs in a multi-tenant environment; don't assume consistent performance
- Use `SetLoadFields()` to reduce data transfer when you don't need all fields
- Avoid excessive database calls in loops
- Use temporary tables for processing large datasets
- Consider bulk operations instead of row-by-row processing

### Extension Structure

Organize your extension with clear folder structure:
```
/src
  /codeunits
  /tables
  /tableextensions
  /pages
  /pageextensions
  /enums
  /enumextensions
  /reports
  /queries
  /xmlports
  /interfaces
/test
  /src
    (same structure as /src)
/res
  (resources like images)
```

### Comments and Documentation

- Add XML comments to public procedures
- Document parameters, return values, and procedure purpose
- Use `//` for single-line comments
- Keep comments up-to-date with code changes

### Do Not Use

- `OnBeforeCompanyOpen` and `OnAfterCompanyOpen` triggers (performance impact)
- Direct insertion into `Profile` table (use Profile objects instead)
- Trailing whitespaces in action names (breaks Copilot integration)
- Wildcard symbols (`%`, `&`) in field names (breaks Excel export)

### App.json Configuration

Ensure `app.json` has correct settings:
- Set `target` to `"Cloud"` for cloud deployment
- Include all required dependencies
- Set appropriate `platform` and `application` versions
- Define `idRanges` appropriately
- Enable `NoImplicitWith` feature

### Security and Permissions

- Design with least-privilege principle
- Use `InherentPermissions` and `InherentEntitlements` attributes
- Test with realistic user permissions, not SUPER
- Be cautious with `RecordRef` access in event subscribers

## Agentic Coding Principles

When generating code for this workspace, apply these principles:

### 1. Context Awareness
- Understand the existing project structure before making changes
- Check for existing patterns and follow them
- Look for similar implementations in the codebase
- Respect the established naming conventions

### 2. Completeness
- Generate complete implementations, not just snippets
- Include all necessary properties (ApplicationArea, UsageCategory, etc.)
- Add appropriate error handling
- Include XML documentation comments

### 3. Testability
- Write code that can be easily tested
- Separate business logic into testable units
- Avoid tight coupling to UI elements

### 4. Maintainability
- Use clear, descriptive names
- Keep methods focused and small
- Add comments for complex logic
- Follow the single responsibility principle

### 5. Consistency
- Match the coding style of existing files
- Use the same patterns for similar functionality
- Maintain consistent indentation and formatting

## Common Patterns

### Table Pattern
```al
table 50100 "My Table"
{
    Caption = 'My Table';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}
```

### Page Pattern
```al
page 50100 "My Page"
{
    PageType = Card;
    SourceTable = "My Table";
    ApplicationArea = All;
    UsageCategory = Documents;
    Caption = 'My Page';

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(MyAction)
            {
                ApplicationArea = All;
                Caption = 'My Action';
                ToolTip = 'Executes my action.';
                Image = Action;

                trigger OnAction()
                begin
                    Message('Action executed');
                end;
            }
        }
    }
}
```

### Codeunit Pattern
```al
codeunit 50100 "My Management"
{
    procedure ProcessRecord(var MyRecord: Record "My Table"): Boolean
    var
        ErrorOccurred: Boolean;
    begin
        // Validate input
        MyRecord.TestField("Code");

        // Process
        ErrorOccurred := false;

        // Return status
        exit(not ErrorOccurred);
    end;

    local procedure InternalHelper()
    begin
        // Internal implementation
    end;
}
```

## Additional Resources

- AL Guidelines: https://alguidelines.dev/
- Business Central Documentation: https://learn.microsoft.com/dynamics365/business-central/
- AL Language Reference: https://learn.microsoft.com/dynamics365/business-central/dev-itpro/developer/

---

**Remember**: Always write clean, maintainable, and testable code that follows Business Central best practices and promotes extensibility.
