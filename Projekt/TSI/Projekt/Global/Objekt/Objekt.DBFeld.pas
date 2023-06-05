unit Objekt.DBFeld;

interface

uses
  SysUtils, Classes, variants, Data.DB;

type
  TDBFeld = class(TComponent)
  private
    fValue: string;
    fChanged: Boolean;
    fFeldName: string;
    fNewInit: Boolean;
    fAlwaysTrim: Boolean;
    fDataType: TFieldType;
    fDatum: TDateTime;
    function getAsString: string;
    procedure setAsString(const Value: string);
    function getInteger: Integer;
    procedure setInteger(const Value: Integer);
    function getAsBoolean: Boolean;
    procedure setAsBoolean(const Value: Boolean);
    function getAsDateTime: TDateTime;
    procedure setAsDateTime(const Value: TDateTime);
    function getAsFloat: Extended;
    procedure setAsFloat(const Value: Extended);
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure InitValue;
    property AsFloat: Extended read getAsFloat write setAsFloat;
    property AsString: string read getAsString write setAsString;
    property AsInteger: Integer read getInteger write setInteger;
    property Changed: Boolean read FChanged write fChanged;
    property Feldname: string read FFeldName write fFeldName;
    property AsBoolean: Boolean read getAsBoolean write setAsBoolean;
    property AsDateTime: TDateTime read getAsDateTime write setAsDateTime;
    property AlwaysTrim: Boolean read fAlwaysTrim write fAlwaysTrim;
    property DataType: TFieldType read fDataType write fDataType;
    function AsFirebirdDateTimeStr: string;
    function AsFirebirdDateStr: string;
    function AsFirebirdFloatStr: string;
  end;

implementation

{ TDBFeld }

constructor TDBFeld.Create(AOwner: TComponent);
begin
  inherited;
  InitValue;
end;

destructor TDBFeld.Destroy;
begin

  inherited;
end;

procedure TDBFeld.InitValue;
begin
  FChanged := false;
  FValue := '';
  FNewInit := true;
  fAlwaysTrim := false;
  fDatum := 0;
end;


function TDBFeld.getAsBoolean: Boolean;
begin
  Result := FValue = 'T';
end;

function TDBFeld.getAsDateTime: TDateTime;
begin
  Result := fDatum;
  if (fDatum = 0) and (fValue > '') then
  begin
    if not TryStrToDateTime(FValue, Result) then
      Result := 0;
  end;
end;

function TDBFeld.getAsFloat: Extended;
begin
  if not TryStrToFloat(FValue, Result) then
    Result := 0;
end;

function TDBFeld.AsFirebirdDateTimeStr: string;
var
  Datum: TDateTime;
begin
  Datum := getAsDateTime;
  Result := FormatDateTime('yyyy-mm-dd hh:nn:ss', Datum);
end;

function TDBFeld.AsFirebirdDateStr: string;
var
  Datum: TDateTime;
begin
  Datum := getAsDateTime;
  Result := FormatDateTime('yyyy-mm-dd', Datum);
end;


function TDBFeld.AsFirebirdFloatStr: string;
begin
  Result := getAsString;
  Result := StringReplace(Result, '.', '', [rfReplaceAll]);
  Result := StringReplace(Result, ',', '.', [rfReplaceAll]);
end;




function TDBFeld.getAsString: string;
begin
  Result := FValue;
  if fAlwaysTrim then
    Result := Trim(FValue);
end;

function TDBFeld.getInteger: Integer;
begin
  if not TryStrToInt(FValue, Result) then
    Result := 0;
end;


procedure TDBFeld.setAsBoolean(const Value: Boolean);
begin
  if Value then
    setAsString('T')
  else
    setAsString('F');
end;

procedure TDBFeld.setAsDateTime(const Value: TDateTime);
begin
  setAsString(DateTimeToStr(Value));
  fDatum := Value;
  //setAsString(FormatDateTime('yyyy-mm-dd hh:nn:ss', Value));
end;

procedure TDBFeld.setAsFloat(const Value: Extended);
begin
  setAsString(FloatToStr(Value));
end;

procedure TDBFeld.setAsString(const Value: string);
begin
  if (not FNewInit) and (Value <> fValue) then
    FChanged := true;

  fValue := Value;
  if fAlwaysTrim then
    FValue := Trim(Value);
  FNewInit := false;
end;

procedure TDBFeld.setInteger(const Value: Integer);
begin
  setAsString(IntToStr(Value));
end;

end.
