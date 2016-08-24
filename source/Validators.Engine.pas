unit Validators.Engine;

interface

uses
  System.RTTI, System.JSON;

type

  TBrokenRules = array of string;

  TBrokenRulesHelper = record helper for TBrokenRules
  private
    function asJsonArray: TJSONArray;
  end;

  IValidator<T: class> = interface
    ['{A81A5167-68BB-49D3-B2F8-BC0557FA240C}']
    function IsValid(aEntity: T): boolean;
    function BrokenRules(aEntity: T): TArray<string>;
  end;

  IValidatable<T: class> = interface
    ['{01643E54-2058-4C42-BD98-462EA78E1CAB}']
    function Validate(a: string; var aBrokenRules: array of string): boolean;
  end;

  TValidationEngine = class(TObject)
  private
    class var FRTTIContext: TRttiContext;
  public
    class constructor Create;
    class destructor Destroy;
    class function Validate(aObject: TObject; aContext: string;
      out aBrokenRules: TBrokenRules;
      const aRaiseException: boolean = false): boolean;
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

class constructor TValidationEngine.Create;
begin
  FRTTIContext := TRttiContext.Create;
end;

class destructor TValidationEngine.Destroy;
begin
  FRTTIContext.Free;
end;

class function TValidationEngine.Validate(aObject: TObject; aContext: string;
  out aBrokenRules: TBrokenRules;
  const aRaiseException: boolean = false): boolean;
var
  T: TRttiType;
  cx: TRttiContext;
  a: TCustomAttribute;
  p: TRttiProperty;
  m: TRttiMethod;
  lBrokenRules: TValue;
begin
  aBrokenRules := [];
  T := cx.GetType(aObject.ClassType);
  for p in T.GetProperties do
    for a in p.GetAttributes do
    begin
      if not(a is ValidationAttribute) then
        continue;
      if ValidationAttribute(a).Context <> aContext then
        continue;
      m := cx.GetType(a.ClassType).GetMethod('Validate');
      if m <> nil then
      begin
        lBrokenRules := TValue.From<TBrokenRules>(aBrokenRules);
        m.Invoke(a, [p.GetValue(aObject).AsString, lBrokenRules]).AsBoolean;
        lBrokenRules.TryAsType<TBrokenRules>(aBrokenRules);
      end;
    end;
  Result := Length(aBrokenRules) <= 0;
  if (not Result) and (aRaiseException) then
    raise Exception.Create(aBrokenRules.asJsonArray.ToJSON);
end;

end.
