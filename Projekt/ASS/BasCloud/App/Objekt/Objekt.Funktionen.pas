unit Objekt.Funktionen;

interface

uses
  System.SysUtils;

type
  TFunktionen = class
  private
  public
    constructor Create;
    destructor Destroy; override;
    function BooltoStr(aValue: Boolean): string;
    function StrToBool(aValue: string): Boolean;
  end;


implementation

{ TFunktionen }


constructor TFunktionen.Create;
begin

end;

destructor TFunktionen.Destroy;
begin

  inherited;
end;


function TFunktionen.StrToBool(aValue: string): Boolean;
begin
  Result := aValue = '1';
end;

function TFunktionen.BooltoStr(aValue: Boolean): string;
begin
  if aValue then
    Result := '1'
  else
    Result := '0';
end;


end.
