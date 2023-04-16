unit DB.DeviceList;


interface

uses
  SysUtils, System.Classes, DB.BasisList, DB.Device, Firedac.Stan.Param;

type
  TDBDeviceList = class(TDBBasisList)
  private
    function getItem(Index: Integer): TDBDevice;
  public
    constructor Create; override;
    destructor Destroy; override;
    property Item[Index: Integer]: TDBDevice read getItem;
    function Add: TDBDevice;
    procedure ReadAll;
    procedure DeleteAll;
  end;


implementation

{ TDBZaehlerUpdateList }

uses
  Objekt.BasCloud, fmx.Types;


constructor TDBDeviceList.Create;
begin
  inherited;

end;


destructor TDBDeviceList.Destroy;
begin

  inherited;
end;

function TDBDeviceList.getItem(Index: Integer): TDBDevice;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TDBDevice(fList.Items[Index]);
end;


procedure TDBDeviceList.ReadAll;
var
  Device: TDBDevice;
begin
  BasCloud.Log('Start --> TDBDeviceList.ReadAll');
  try
    fQuery.Close;
    fQuery.Sql.Text := 'select * from device';
    try
      fQuery.Open;
    except
      on E: Exception do
      begin
        log.d('TDBDeviceList.ReadAll: '+ E.Message);
        BasCloud.Log('          Error: ' + E.Message);
      end;
    end;
    fList.Clear;
    while not fQuery.Eof do
    begin
      Device := Add;
      Device.LoadFromQuery(fQuery);
      fQuery.Next;
    end;
  except
    on E: Exception do
    begin
      log.d('TDBDeviceList.ReadAll: '+ E.Message);
    end;
  end;
  BasCloud.Log('Ende --> TDBDeviceList.ReadAll');
end;

function TDBDeviceList.Add: TDBDevice;
begin
  Result := TDBDevice.Create;
  fList.Add(Result);
end;

procedure TDBDeviceList.DeleteAll;
begin
  try
    fQuery.Close;
    fQuery.Sql.Text := 'delete from device';
    fQuery.ExecSQL;
  except
    on E: Exception do
    begin
      log.d('TDBDeviceList.DeleteAll: '+ E.Message);
    end;
  end;
end;


end.
