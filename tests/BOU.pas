unit BOU;

interface

uses
  DUnitX.TestFramework, Validators.Attributes, Validators.Engine;

type

  TBaseTests = class(TObject)
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
  end;

  TPerson = class
  private
    FEmail: string;
    FLastname: string;
    FFirstname: string;
    FAddress: string;
    FPwd: string;
    procedure SetEmail(const Value: string);
    procedure SetFirstname(const Value: string);
    procedure SetLastname(const Value: string);
    procedure SetAddress(const Value: string);
    procedure SetPwd(const Value: string);
  public
    constructor Create(aFirstname, aLastname, aEmail: string; aPwd: string = '');
    [RequiredValidation('TestRequiredValidation', 'Firstname is required')]
    [MaxLengthValidation('TestMaxLenthValidation', 'Firstname is too long', 8)]
    [MinLengthValidation('TestMinLenthValidation', 'Firstname is too short', 4)]
    property Firstname: string read FFirstname write SetFirstname;
    [RequiredValidation('TestRequiredValidation', 'Firstname is required')]
    property Lastname: string read FLastname write SetLastname;
    [RequiredValidation('TestRequiredValidation', 'Firstname is required')]
    [EmailValidation('TestRegexEmailValidation', 'Email wrong')]
    property Email: string read FEmail write SetEmail;
    property Address: string read FAddress write SetAddress;
    [RegexValidation('TestRegexPwdValidation', 'Password not valid',
      '^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[$@$!%*?&])[A-Za-z\d$@$!%*?&]{8,}')]
    property Pwd: string read FPwd write SetPwd;
  end;

  TPersonLoginValidator = class(TInterfacedObject, IValidator<TPerson>)
  public
    function Validate(aEntity: TPerson): IValidationResult;
  end;

implementation

uses
  System.SysUtils;

{ TPerson }

constructor TPerson.Create(aFirstname, aLastname, aEmail, aPwd: string);
begin
  inherited Create;
  FFirstname := aFirstname;
  FLastname := aLastname;
  FEmail := aEmail;
  FPwd := aPwd;
end;

procedure TPerson.SetAddress(const Value: string);
begin
  FAddress := Value;
end;

procedure TPerson.SetEmail(const Value: string);
begin
  FEmail := Value;
end;

procedure TPerson.SetFirstname(const Value: string);
begin
  FFirstname := Value;
end;

procedure TPerson.SetLastname(const Value: string);
begin
  FLastname := Value;
end;

procedure TPerson.SetPwd(const Value: string);
begin
  FPwd := Value;
end;

{ TPersonLoginValidator<TPerson> }

function TPersonLoginValidator.Validate(aEntity: TPerson): IValidationResult;
var
  lIsValid: boolean;
begin
  Result := TValidationResult.Create;
  lIsValid := not(aEntity.Firstname.IsEmpty or aEntity.Lastname.IsEmpty or
    aEntity.Email.IsEmpty);
  if not lIsValid then
    Result.BrokenRules :=
      ['The fields Firstname, Lastname and Email are mandatory '];
end;

{ TBaseTests }

procedure TBaseTests.Setup;
begin
end;

procedure TBaseTests.TearDown;
begin

end;

end.
