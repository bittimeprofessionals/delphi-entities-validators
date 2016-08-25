unit Validators.Attributes.Tests;

interface

uses
  DUnitX.TestFramework, Validators.Attributes, Validators.Engine, BOU;

type

  [TestFixture]
  TValidatorsAttributesTests = class(TBaseTests)
  private
    FBrokenRules: TBrokenRules;
  public
    [TestCase('TestPropertyRequired', '')]
    procedure TestPropertyRequired;
    [TestCase('TestMaxLenthValidationOKtony', 'tony')]
    [TestCase('TestMaxLenthValidationOKstark', 'stark')]
    [TestCase('TestMaxLenthValidationOKironman1', 'ironman1')]
    procedure TestMaxLenthValidationOK(aFirstname: string);
    [TestCase('TestMaxLenthValidationKOironman11', 'ironman11')]
    [TestCase('TestMaxLenthValidationKOironmanrocks', 'ironmanrocks')]
    procedure TestMaxLenthValidationKO(aFirstname: string);
    [TestCase('TestMinLenthValidationOKtony', 'tony')]
    [TestCase('TestMinLenthValidationOKstark', 'stark')]
    procedure TestMinLenthValidationOK(aFirstname: string);
    [TestCase('TestMinLenthValidationKOtony', 'ton')]
    [TestCase('TestMinLenthValidationKOstark', 'st')]
    procedure TestMinLenthValidationKO(aFirstname: string);
    [TestCase('TestRegexEmailValidationOKt.stark@marvel.com',
      't.stark@marvel.com')
      ]
    [TestCase('TestRegexEmailValidationOKt.stark@marvel.it',
      't.stark@marvel.it')
      ]
    [TestCase('TestRegexEmailValidationOKt.stark@marvel.eu',
      't.stark@marvel.eu')]
    procedure TestRegexEmailValidationOk(aEmail: string);
    [TestCase('TestRegexEmailValidationKOt.stark', 't.stark')]
    [TestCase('TestRegexEmailValidationKOt.stark@marvel.', 't.stark@marvel.')]
    [TestCase('TestRegexEmailValidationKOt.stark@marvel', 't.stark@marvel')]
    procedure TestRegexEmailValidationKO(aEmail: string);
  end;

implementation

procedure TValidatorsAttributesTests.TestRegexEmailValidationKO(aEmail: string);
var
  lPerson: TPerson;
begin
  lPerson := TPerson.Create('Tony', 'Stark', aEmail);
  try
    TValidationEngine.PropertyValidation(lPerson, 'TestRegexEmailValidation',
      FBoolValidator);
    Assert.IsFalse(FBoolValidator);
  finally
    lPerson.Free;
  end;
end;

procedure TValidatorsAttributesTests.TestRegexEmailValidationOk(aEmail: string);
var
  lPerson: TPerson;
begin
  lPerson := TPerson.Create('Tony', 'Stark', aEmail);
  try
    TValidationEngine.PropertyValidation(lPerson, 'TestRegexEmailValidation',
      FBoolValidator);
    Assert.IsTrue(FBoolValidator);
  finally
    lPerson.Free;
  end;
end;

procedure TValidatorsAttributesTests.TestMaxLenthValidationKO
  (aFirstname: string);
var
  lPerson: TPerson;
begin
  lPerson := TPerson.Create(aFirstname, '', '');
  try
    FBrokenRules := TValidationEngine.PropertyValidation(lPerson,
      'TestMaxLenthValidation', FBoolValidator);
    Assert.IsFalse(FBoolValidator);
    Assert.AreEqual(1, Length(FBrokenRules));
  finally
    lPerson.Free;
  end;
end;

procedure TValidatorsAttributesTests.TestMaxLenthValidationOK
  (aFirstname: string);
var
  lPerson: TPerson;
begin
  lPerson := TPerson.Create(aFirstname, '', '');
  try
    TValidationEngine.PropertyValidation(lPerson, 'TestMaxLenthValidation',
      FBoolValidator);
    Assert.IsTrue(FBoolValidator);
  finally
    lPerson.Free;
  end;
end;

procedure TValidatorsAttributesTests.TestMinLenthValidationKO
  (aFirstname: string);
var
  lPerson: TPerson;
begin
  lPerson := TPerson.Create(aFirstname, '', '');
  try
    TValidationEngine.PropertyValidation(lPerson, 'TestMinLenthValidation',
      FBoolValidator);
    Assert.IsFalse(FBoolValidator);
  finally
    lPerson.Free;
  end;
end;

procedure TValidatorsAttributesTests.TestMinLenthValidationOK
  (aFirstname: string);
var
  lPerson: TPerson;
begin
  lPerson := TPerson.Create(aFirstname, '', '');
  try
    TValidationEngine.PropertyValidation(lPerson, 'TestMinLenthValidation',
      FBoolValidator);
    Assert.IsTrue(FBoolValidator);
  finally
    lPerson.Free;
  end;
end;

procedure TValidatorsAttributesTests.TestPropertyRequired;
var
  lPerson: TPerson;
begin
  lPerson := TPerson.Create('Tony', 'Stark', 't.stark@marvel.com');
  try
    TValidationEngine.PropertyValidation(lPerson, 'TValidatorsRunTimeTests',
      FBoolValidator);
    Assert.IsTrue(FBoolValidator);
  finally
    lPerson.Free;
  end;
end;

initialization

TDUnitX.RegisterTestFixture(TValidatorsAttributesTests);

end.
