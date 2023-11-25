unit o_lpUserlist;

interface

uses
  SysUtils, Classes, Contnrs, o_lpBaseList, o_lpUser, o_lockRecievedMsg;

type
  Tlp_UserList = class(Tlp_BaseList)
  private
    function getUser(Index: Integer): Tlp_User;
  public
    constructor Create; override;
    destructor Destroy; override;
    function Add: Tlp_User;
    property Item[Index: Integer]: Tlp_User read getUser;
    procedure setReceivedMsg(aRecievedMsg: string);
  end;

implementation

{ Tlp_UserList }


constructor Tlp_UserList.Create;
begin
  inherited;

end;

destructor Tlp_UserList.Destroy;
begin

  inherited;
end;

function Tlp_UserList.getUser(Index: Integer): Tlp_User;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := Tlp_User(fList[Index]);
end;


procedure Tlp_UserList.setReceivedMsg(aRecievedMsg: string);
var
  sList: TStringList;
  LockReceivedMsg: TLockRecievedMsg;
  s: string;
  s2: string;
  iPosAnfang: Integer;
  iPosEnde: Integer;
  User: Tlp_User;
  i1: Integer;
begin
  LockReceivedMsg := TLockRecievedMsg.Create;
  sList := TStringList.Create;
  try
    s := aRecievedMsg;
    iPosAnfang := Pos('(', s);
    while iPosAnfang > 0 do
    begin
      iPosEnde := Pos(')', s);
      if iPosEnde > 0 then
      begin
        delete(s, 1, iPosAnfang);
        iPosEnde := Pos(')', s);
        s2 := copy(s, 1, iPosEnde-1);
        sList.Add(s2);
        Delete(s, 1, iPosEnde);
      end;
      iPosAnfang := Pos('(', s);
    end;
    for i1 := 0 to sList.Count -1 do
    begin
      LockReceivedMsg.Msg := sList.Strings[i1];
      User := Add;
      User.User    := LockReceivedMsg.getItem(0);
      User.Session := LockReceivedMsg.getItem(1);
      User.Machine := LockReceivedMsg.getItem(2);
      User.Mandant := LockReceivedMsg.getItem(3);
      User.Mandantname := LockReceivedMsg.getItem(4);
      User.LastUpdate := LockReceivedMsg.getItem(5);
      User.Connected  := LockReceivedMsg.getItem(6);
      User.AppType := LockReceivedMsg.getItem(7);
      User.Alive   := LockReceivedMsg.getItem(8);
      User.Zeitpunkt_der_letzten_Aktivitaet := LockReceivedMsg.getItem(9);
    end;
  finally
    FreeAndNil(sList);
    FreeAndNil(LockReceivedMsg);
  end;
end;

function Tlp_UserList.Add: Tlp_User;
begin
  Result := Tlp_User.Create;
  fList.Add(Result);
end;


end.
