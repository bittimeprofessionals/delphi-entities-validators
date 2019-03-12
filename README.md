# Delphi Entities Validators

Delphi Entities Validators is a microframework that provides an easy and ready-to-use interface for entities validation.

## How it works

### Simple Validation
```Delphi
type
  TPersonValidator = class(TInterfacedObject, IValidator<TPerson>)
  public
    function Validate(aEntity: TPerson): IValidationResult;
  end;
  
implementation
  
function TPersonValidator.Validate(aEntity: TPerson): IValidationResult;
var
  lIsValid: boolean;
begin
  Result := TValidationResult.Create;
  lIsValid := not(aEntity.Firstname.IsEmpty or aEntity.Lastname.IsEmpty or aEntity.Email.IsEmpty);
  if not lIsValid then
    Result.BrokenRules := ['The fields Firstname, Lastname and Email are mandatory '];
end;

...

lPersonValidator := TPersonValidator.Create;
lValidationResult := lPersonValidator.Validate(lPerson);
lValidationResult.IsValid; // returns a boolean that represents the success or failures validation
lValidationResult.BrokenRules; // returns an array of string that represents the broken rules
```

### Attributes Validation
```Delphi
TPerson = class
  private
    FLastname: string;
    FFirstname: string;
    procedure SetFirstname(const Value: string);
    procedure SetLastname(const Value: string);
  public
    [RequiredValidation('AttributesValidation', 'Firstname is required')]
    [MaxLengthValidation('AttributesValidation', 'Firstname is too long', 8)]
    [MinLengthValidation('AttributesValidation', 'Firstname is too short', 4)]
    property Firstname: string read FFirstname write SetFirstname;
    [RequiredValidation('AttributesValidation', 'Firstname is required')]
    property Lastname: string read FLastname write SetLastname;
  end;
  
...
  
lValidationResult := TValidationEngine.PropertyValidation(lPerson, 'AttributesValidation');
lValidationResult.IsValid; // returns a boolean that represents the success or failures validation
lValidationResult.BrokenRules; // returns an array of string that represents the broken rules 
```
### Using container
```Delphi
TPersonLoginValidator = class(TInterfacedObject, IValidator<TPerson>)
  public
    function Validate(aEntity: TPerson): IValidationResult;
  end;
  
  implementation
  
  function TPersonLoginValidator.Validate(aEntity: TPerson): IValidationResult;
var
  lIsValid: boolean;
begin
  Result := TValidationResult.Create;
  lIsValid := not(aEntity.Firstname.IsEmpty or aEntity.Lastname.IsEmpty or aEntity.Email.IsEmpty);
  if not lIsValid then
    Result.BrokenRules := ['The fields Firstname, Lastname and Email are mandatory '];
end;

...

TValidationEngine.ValidationContainer.RegisterValidatorFor<TPerson>('PersonLogidValidation', TPersonLoginValidator.Create);
lValidationResult := TValidationEngine.EntityValidation<TPerson>(lPerson,'PersonLoginValidation');
lValidationResult.IsValid; // returns a boolean that represents the success or failures validation
lValidationResult.BrokenRules; // returns an array of string that represents the broken rules
```
