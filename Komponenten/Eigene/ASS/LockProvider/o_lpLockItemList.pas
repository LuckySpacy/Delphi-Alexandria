unit o_lpLockItemList;

interface

uses
  SysUtils, Classes, Contnrs, o_lpBaseList, o_lpLockItem, o_lockRecievedMsg, Objekt.LockTableList;

type
  Tlp_LockItemList = class(Tlp_BaseList)
  private
    fLockTableList: TLockTableList;
    function getLockItem(Index: Integer): Tlp_LockItem;
  public
    constructor Create; override;
    destructor Destroy; override;
    function Add: Tlp_LockItem;
    property Item[Index: Integer]: Tlp_LockItem read getLockItem;
    procedure setReceivedMsg(aRecievedMsg: string);
  end;

implementation

{ Tlp_LockItemList }


constructor Tlp_LockItemList.Create;
begin
  inherited;
  fLockTableList := TLockTableList.Create;
end;

destructor Tlp_LockItemList.Destroy;
begin
  FreeAndNil(fLockTableList);
  inherited;
end;

function Tlp_LockItemList.getLockItem(Index: Integer): Tlp_LockItem;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := Tlp_LockItem(fList[Index]);
end;

function Tlp_LockItemList.Add: Tlp_LockItem;
begin
  Result := Tlp_LockItem.Create;
  fList.Add(Result);
end;


procedure Tlp_LockItemList.setReceivedMsg(aRecievedMsg: string);
var
  sList: TStringList;
  LockReceivedMsg: TLockRecievedMsg;
  s: string;
  s2: string;
  iPosAnfang: Integer;
  iPosEnde: Integer;
  LockItem: Tlp_LockItem;
  i1: Integer;
  iTest: Integer;
begin
  fList.Clear;
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
      LockItem := Add;

      if TryStrToInt(LockReceivedMsg.getItem(0), iTest) then
        LockItem.LockId := iTest;
      LockItem.Machine := LockReceivedMsg.getItem(1);
      if TryStrToInt(LockReceivedMsg.getItem(2), iTest) then
        LockItem.TabelleKey := iTest;

      LockItem.LastUpdate := LockReceivedMsg.getItem(3);

      if TryStrToInt(LockReceivedMsg.getItem(4), iTest) then
        LockItem.DatensatzId := iTest;

      LockItem.User       := LockReceivedMsg.getItem(5);
      LockItem.Session    := LockReceivedMsg.getItem(6);
      LockItem.Hint       := LockReceivedMsg.getItem(7);

      LockItem.Tabelle    := fLockTableList.getTablename(LockItem.TabelleKey);

    end;
  finally
    FreeAndNil(sList);
    FreeAndNil(LockReceivedMsg);
  end;
end;

end.
