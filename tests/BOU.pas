unit BOU;

interface

uses
  Validators.Attributes;

type
  TPerson = class
  private
    FEmail: string;
    FLastname: string;
    FFirstname: string;
    procedure SetEmail(const Value: string);
    procedure SetFirstname(const Value: string);
    procedure SetLastname(const Value: string);
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
  end;

implementation

{ TPerson }

constructor TPerson.Create(aFirstname, aLastname, aEmail: string);
begin
  inherited Create;
  FFirstname := aFirstname;
  FLastname := aLastname;
  FEmail := aEmail;
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

end.
