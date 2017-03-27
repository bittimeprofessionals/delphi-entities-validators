unit Validators.Properties.Tests;

interface

uses
  DUnitX.TestFramework, Validators.Attributes, Validators.Engine, BOU;

type

  [TestFixture]
  TValidatorsPropertiesTests = class(TBaseTests)
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

    [TestCase('TestRegexPwdValidation_Pippolo1!', 'Pippolo1!')]
    [TestCase('TestRegexPwdValidation_pippolo1!', 'Pippolo!1')]
    procedure TestRegexPwdValidationOk(aPwd: string);

    [TestCase('TestRegexPwdValidation_Pilo1!', 'Pilo1!')]
    [TestCase('TestRegexPwdValidation_pippolo', 'pippolo')]
    [TestCase('TestRegexPwdValidation_Pippolo1', 'Pippolo1')]
    procedure TestRegexPwdValidationKO(aPwd: string);

    [TestCase('TestRegexEmailValidationOKt.stark@marvel.com',
      't.stark@marvel.com')
      ]
    [TestCase('TestRegexEmailValidationOKt.stark@marvel.it',
      't.stark@marvel.it')
      ]
    [TestCase('TestRegexEmailValidationOKt.stark@marvel.eu',
      't.stark@marvel.eu')]
    procedure TestEmailValidationOk(aEmail: string);
    [TestCase('TestRegexEmailValidationKOt.stark', 't.stark')]
    [TestCase('TestRegexEmailValidationKOt.stark@marvel.', 't.stark@marvel.')]
    [TestCase('TestRegexEmailValidationKOt.stark@marvel', 't.stark@marvel')]
    procedure TestEmailValidationKO(aEmail: string);

  end;

implementation

procedure TValidatorsPropertiesTests.TestEmailValidationKO(aEmail: string);
var
  lPerson: TPerson;
begin
  lPerson := TPerson.Create('Tony', 'Stark', aEmail);
  try;
    Assert.IsFalse(TValidationEngine.PropertyValidation(lPerson,
      'TestRegexEmailValidation').IsValid);
  finally
    lPerson.Free;
  end;
end;

procedure TValidatorsPropertiesTests.TestEmailValidationOk(aEmail: string);
var
  lPerson: TPerson;
begin
  lPerson := TPerson.Create('Tony', 'Stark', aEmail);
  try
    Assert.IsTrue(TValidationEngine.PropertyValidation(lPerson,
      'TestRegexEmailValidation').IsValid);
  finally
    lPerson.Free;
  end;
end;

procedure TValidatorsPropertiesTests.TestRegexPwdValidationKO(aPwd: string);
var
  lPerson: TPerson;
begin
  lPerson := TPerson.Create('Tony', 'Stark', '', aPwd);
  try
    Assert.IsFalse(TValidationEngine.PropertyValidation(lPerson,
      'TestRegexPwdValidation').IsValid);
  finally
    lPerson.Free;
  end;
end;

procedure TValidatorsPropertiesTests.TestRegexPwdValidationOk(aPwd: string);
var
  lPerson: TPerson;
begin
  lPerson := TPerson.Create('Tony', 'Stark', '', aPwd);
  try
    Assert.IsTrue(TValidationEngine.PropertyValidation(lPerson,
      'TestRegexPwdValidation').IsValid);
  finally
    lPerson.Free;
  end;
end;

procedure TValidatorsPropertiesTests.TestMaxLenthValidationKO
  (aFirstname: string);
var
  lPerson: TPerson;
  lResult: IValidationResult;
begin
  lPerson := TPerson.Create(aFirstname, '', '');
  try
    lResult := TValidationEngine.PropertyValidation(lPerson,
      'TestMaxLenthValidation');
    Assert.IsFalse(lResult.IsValid);
    Assert.AreEqual(1, Length(lResult.BrokenRules));
  finally
    lPerson.Free;
  end;
end;

procedure TValidatorsPropertiesTests.TestMaxLenthValidationOK
  (aFirstname: string);
var
  lPerson: TPerson;
begin
  lPerson := TPerson.Create(aFirstname, '', '');
  try
    Assert.IsTrue(TValidationEngine.PropertyValidation(lPerson,
      'TestMaxLenthValidation').IsValid);
  finally
    lPerson.Free;
  end;
end;

procedure TValidatorsPropertiesTests.TestMinLenthValidationKO
  (aFirstname: string);
var
  lPerson: TPerson;
begin
  lPerson := TPerson.Create(aFirstname, '', '');
  try
    Assert.IsFalse(TValidationEngine.PropertyValidation(lPerson,
      'TestMinLenthValidation').IsValid);
  finally
    lPerson.Free;
  end;
end;

procedure TValidatorsPropertiesTests.TestMinLenthValidationOK
  (aFirstname: string);
var
  lPerson: TPerson;
begin
  lPerson := TPerson.Create(aFirstname, '', '');
  try
    Assert.IsTrue(TValidationEngine.PropertyValidation(lPerson,
      'TestMinLenthValidation').IsValid);
  finally
    lPerson.Free;
  end;
end;

procedure TValidatorsPropertiesTests.TestPropertyRequired;
var
  lPerson: TPerson;
begin
  lPerson := TPerson.Create('Tony', 'Stark', 't.stark@marvel.com');
  try
    Assert.IsTrue(TValidationEngine.PropertyValidation(lPerson,
      'TValidatorsRunTimeTests').IsValid);
  finally
    lPerson.Free;
  end;
end;

initialization

TDUnitX.RegisterTestFixture(TValidatorsPropertiesTests);

end.
