unit BOU;

interface

uses
  DUnitX.TestFramework, Validators.Attributes, Validators.Engine;

type

  TBaseTests = class(TObject)
  protected
    FBrokenRules: TBrokenRules;
    FBoolValidator: boolean;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
  end;

  [EntityValidation('PersonLoginValidation', '')]
  TPerson = class
  private
    FEmail: string;
    FLastname: string;
    FFirstname: string;
    FAddress: string;
    procedure SetEmail(const Value: string);
    procedure SetFirstname(const Value: string);
    procedure SetLastname(const Value: string);
    procedure SetAddress(const Value: string);
  public
    constructor Create(aFirstname, aLastname, aEmail: string);
    [RequiredValidation('TestRequiredValidation', 'Firstname is required')]
    [MaxLengthValidation('TestMaxLenthValidation', 'Firstname is too long', 8)]
    [MinLengthValidation('TestMinLenthValidation', 'Firstname is too short', 4)]
    property Firstname: string read FFirstname write SetFirstname;
    [RequiredValidation('TestRequiredValidation', 'Firstname is required')]
    property Lastname: string read FLastname write SetLastname;
    [RequiredValidation('TestRequiredValidation', 'Firstname is required')]
    [RegexValidation('TestRegexEmailValidation', 'Email wrong',
      '^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      ]
    property Email: string read FEmail write SetEmail;
    property Address: string read FAddress write SetAddress;
  end;

  TPersonLoginValidator = class(TInterfacedObject, IValidator<TPerson>)
  public
    function Validate(aEntity: TPerson; out aIsValid: boolean): TBrokenRules;
  end;

implementation

uses
  System.SysUtils;

{ TPerson }

constructor TPerson.Create(aFirstname, aLastname, aEmail: string);
begin
  inherited Create;
  FFirstname := aFirstname;
  FLastname := aLastname;
  FEmail := aEmail;
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

{ TPersonLoginValidator<TPerson> }

function TPersonLoginValidator.Validate(aEntity: TPerson; out aIsValid: boolean)
  : TBrokenRules;
begin
  aIsValid := not(aEntity.Firstname.IsEmpty or aEntity.Lastname.IsEmpty or
    aEntity.Email.IsEmpty);
  if not aIsValid then
    Result := ['The fields Firstname, Lastname and Email are mandatory '];
end;

{ TBaseTests }

procedure TBaseTests.Setup;
begin
  FBrokenRules := [];
  FBoolValidator := false;
end;

procedure TBaseTests.TearDown;
begin

end;

end.
