unit Validators.Custom.Tests;

interface

uses
  DUnitX.TestFramework, BOU;

type

  [TestFixture]
  TEntityValidationTests = class(TBaseTests)
  public
    [TestCase('TestPersonLoginValidationOK', '')]
    procedure TestPersonLoginValidationOK();
    [TestCase('TestPersonLoginValidationKO', '')]
    procedure TestPersonLoginValidationKO();
  end;

implementation

uses
  Validators.Engine;

procedure TEntityValidationTests.TestPersonLoginValidationKO;
var
  lPerson: TPerson;
  lValidationResult: IValidationResult;
begin
  lPerson := TPerson.Create('Tony', 'Stark', '');
  try
    TValidationEngine.ValidationContainer.RegisterValidatorFor<TPerson>
      ('PersonLoginValidation', TPersonLoginValidator.Create);
    lValidationResult := TValidationEngine.EntityValidation<TPerson>(lPerson,
      'PersonLoginValidation');
    Assert.IsFalse(lValidationResult.IsValid);
  finally
    lPerson.Free;
  end;
end;

procedure TEntityValidationTests.TestPersonLoginValidationOK;
var
  lPerson: TPerson;
  lValidationResult: IValidationResult;
begin
  lPerson := TPerson.Create('Tony', 'Stark', 't.stark@marvel.com');
  try
    TValidationEngine.ValidationContainer.RegisterValidatorFor<TPerson>
      ('PersonLoginValidation', TPersonLoginValidator.Create);
    lValidationResult := TValidationEngine.EntityValidation<TPerson>(lPerson,
      'PersonLoginValidation');
    Assert.IsTrue(lValidationResult.IsValid);
  finally
    lPerson.Free;
  end;
end;

initialization

TDUnitX.RegisterTestFixture(TEntityValidationTests);

end.
