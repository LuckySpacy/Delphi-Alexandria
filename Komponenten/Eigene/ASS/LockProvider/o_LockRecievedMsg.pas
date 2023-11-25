unit o_LockRecievedMsg;

interface

uses
  classes, SysUtils;

type
  TLockRecievedMsg = class(TStringList)
  private
    fMsg: string;
    procedure setMsg(const Value: string);
  public
    constructor Create; overload;
    property Msg: string read fMsg write setMsg;
    function getItem(aIndex: Integer): string;
  end;


implementation

{ TLockRecievedMsg }

constructor TLockRecievedMsg.Create;
begin
  fMsg := '';
  Delimiter := '|';
  StrictDelimiter := true;
end;

function TLockRecievedMsg.getItem(aIndex: Integer): string;
begin
  Result := '';
  if aIndex > Count -1 then
    exit;
  Result := Strings[aIndex];
end;

procedure TLockRecievedMsg.setMsg(const Value: string);
begin
  fMsg := Value;
  DelimitedText := fMsg;
end;

end.
