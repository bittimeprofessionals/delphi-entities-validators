unit Validators.Engine;

interface

uses
  System.RTTI, System.JSON, System.Generics.Collections;

type

  TBrokenRules = array of string;

  TBrokenRulesHelper = record helper for TBrokenRules
  private
    function asJsonArray: TJSONArray;
  end;

  IValidator<T> = interface
    ['{A81A5167-68BB-49D3-B2F8-BC0557FA240C}']
    function Validate(aEntity: T; out aIsValid: boolean): TBrokenRules;
  end;

  IValidatable<T> = interface
    ['{01643E54-2058-4C42-BD98-462EA78E1CAB}']
    function Validate(aValidator: IValidator<T>;
      out aBrokenRules: TBrokenRules): boolean;
  end;

  // IValidatorContainer = interface
  // ['{DCC0B831-822B-4159-B132-10587E8BFDFB}']
  // procedure RegisterValidatorFor(aEntity: TObject; aContext: string);
  // function GetValidatorFor<T>(aEntity: T; aContext: string): IValidator<T>;
  // end;

  TBaseValidatorContainer = class(TObject)
  private
    FRegistry: TDictionary<TClass, TDictionary<string, IInterface>>;
  public
    constructor Create;
    destructor Destroy; override;
    procedure RegisterValidatorFor<T: class>(aEntity: T; aContext: string;
      aValidator: IValidator<T>);
    function GetValidatorFor<T: class>(aEntity: T; aContext: string)
      : IValidator<T>;
  end;

  TValidationEngine = class(TObject)
  private
    class var FRTTIContext: TRttiContext;
    class var FValidationContainer: TBaseValidatorContainer;
  protected
    class procedure CheckIsValid(aBrokenRules: TBrokenRules;
      out aIsValid: boolean; aRaiseException: boolean = false);
  public
    class constructor Create;
    class destructor Destroy;
    class function Validate<T: class>(aObject: T; aContext: string;
      out aIsValid: boolean; const aRaiseException: boolean = false)
      : TBrokenRules;
    class function PropertyValidation(aObject: TObject; aContext: string;
      out aIsValid: boolean; const aRaiseException: boolean = false)
      : TBrokenRules;
    class function EntityValidation<T: class>(aObject: T; aContext: string;
      out aIsValid: boolean; const aRaiseException: boolean = false)
      : TBrokenRules;
    class property ValidationContainer: TBaseValidatorContainer
      read FValidationContainer;
  end;

implementation

uses
  Validators.Attributes, System.SysUtils;

{ TBrokenRulesHelper }

function TBrokenRulesHelper.asJsonArray: TJSONArray;
var
  I: Integer;
begin
  Result := TJSONArray.Create;
  for I := Low(self) to High(self) do
    Result.Add(self[I]);
end;

{ TRunTimeValidator }

class procedure TValidationEngine.CheckIsValid(aBrokenRules: TBrokenRules;
  out aIsValid: boolean; aRaiseException: boolean);
begin
  aIsValid := Length(aBrokenRules) <= 0;
  if (not aIsValid) and (aRaiseException) then
    raise Exception.Create(aBrokenRules.asJsonArray.ToJSON);
end;

class constructor TValidationEngine.Create;
begin
  FRTTIContext := TRttiContext.Create;
  FValidationContainer := TBaseValidatorContainer.Create;
end;

class destructor TValidationEngine.Destroy;
begin
  FRTTIContext.Free;
  FValidationContainer.Free;
end;

class function TValidationEngine.EntityValidation<T>(aObject: T;
  aContext: string; out aIsValid: boolean; const aRaiseException: boolean)
  : TBrokenRules;
var
  rt: TRttiType;
  a: TCustomAttribute;
  lValidator: IValidator<T>;
begin
  rt := FRTTIContext.GetType(aObject.ClassType);
  for a in rt.GetAttributes do
  begin
    if not(a is EntityValidationAttribute) then
      continue;
    lValidator := FValidationContainer.GetValidatorFor<T>(aObject, aContext);
    Result := Result + lValidator.Validate(aObject, aIsValid);
  end;
  CheckIsValid(Result, aIsValid, aRaiseException);
end;

class function TValidationEngine.PropertyValidation(aObject: TObject;
  aContext: string; out aIsValid: boolean; const aRaiseException: boolean)
  : TBrokenRules;
var
  rt: TRttiType;
  a: TCustomAttribute;
  p: TRttiProperty;
  m: TRttiMethod;
begin
  rt := FRTTIContext.GetType(aObject.ClassType);
  for p in rt.GetProperties do
    for a in p.GetAttributes do
    begin
      if not(a is ValidationAttribute) then
        continue;
      if ValidationAttribute(a).Context <> aContext then
        continue;
      m := FRTTIContext.GetType(a.ClassType).GetMethod('Validate');
      if m = nil then
        continue;
      Result := Result + m.Invoke(a, [p.GetValue(aObject).AsString, aIsValid])
        .AsType<TBrokenRules>;
    end;
  CheckIsValid(Result, aIsValid, aRaiseException);
end;

class function TValidationEngine.Validate<T>(aObject: T; aContext: string;
  out aIsValid: boolean; const aRaiseException: boolean = false): TBrokenRules;
var
  rt: TRttiType;
  cx: TRttiContext;
  a: TCustomAttribute;
  p: TRttiProperty;
  m: TRttiMethod;
  lValidator: IValidator<T>;
begin
  Result := Result + EntityValidation<T>(aObject, aContext, aIsValid,
    aRaiseException);
  Result := Result + PropertyValidation(aObject, aContext, aIsValid,
    aRaiseException);
  CheckIsValid(Result, aIsValid, aRaiseException);
end;

{ TBaseValidatorContainer }

constructor TBaseValidatorContainer.Create;
begin
  FRegistry := TDictionary < TClass, TDictionary < string, IInterface >>.Create;
end;

destructor TBaseValidatorContainer.Destroy;
var
  lVal: TDictionary<string, IInterface>;
begin
  for lVal in FRegistry.Values do
    lVal.Free;
  FRegistry.Free;
  inherited;
end;

function TBaseValidatorContainer.GetValidatorFor<T>(aEntity: T;
  aContext: string): IValidator<T>;
begin
  Result := FRegistry[aEntity.ClassType][aContext] as IValidator<T>;
end;

procedure TBaseValidatorContainer.RegisterValidatorFor<T>(aEntity: T;
  aContext: string; aValidator: IValidator<T>);
var
  lDictionary: TDictionary<string, IInterface>;
begin
  if not FRegistry.TryGetValue(aEntity.ClassType, lDictionary) then
    lDictionary := TDictionary<string, IInterface>.Create();
  lDictionary.AddOrSetValue(aContext, aValidator);
  FRegistry.AddOrSetValue(aEntity.ClassType, lDictionary);
end;

end.
