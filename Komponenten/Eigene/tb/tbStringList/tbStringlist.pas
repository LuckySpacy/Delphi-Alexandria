unit tbStringlist;

interface
uses
  SysUtils, Classes;

type
  TTBStringList = class(TStringList)
  private
    FDeli: string;
  protected
  public
    procedure Cut(aValue: string);
    property Deli: string read FDeli write FDeli;
  end;

implementation

{ TTBStringList }

procedure TTBStringList.Cut(aValue: string);
var
  //i1: Integer;
  s : string;
  iPos: Integer;
begin
  Clear;
  if FDeli = '' then
    exit;
  iPos := Pos(FDeli, aValue);
  while iPos > 0 do
  begin
    s := copy(aValue, 1, iPos - 1);
    aValue := copy(aValue, iPos + Length(FDeli), Length(aValue));
    Add(s);
    iPos := Pos(FDeli, aValue);
  end;
  if aValue > '' then
    Add(aValue);
end;

end.
