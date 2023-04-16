unit DB.ZaehlerUpdate;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, DB.Basis, FMX.Graphics, Objekt.Zaehler;

type
  TDBZaehlerUpdate = class(TDBBasis)
  private
    fGBId: string;
    fDeId: string;
    fStand: string;
    fId: Integer;
    fImportDatum: TDateTime;
    fDatum: TDateTime;
    fBild: TMemoryStream;
    fToDoId: string;
    procedure CreateBild;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    property Id: Integer read fId write fId;
    property GbId: string read fGBId write fGBId;
    property DeId: string read fDeId write fDeId;
    property ToDoId: string read fToDoId write fToDoId;
    property Stand: string read fStand write fStand;
    property Datum: TDateTime read fDatum write fDatum;
    property ImportDatum: TDateTime read fImportDatum write fImportDatum;
    procedure Init;
    function Insert: Boolean;
    function Update: Boolean;
    function ZaehlerExist(aId: Integer): Boolean;
    procedure LoadFromQuery(aQry: TFDQuery);
    function Read(aId: string): Boolean;
    function ReadFromDevice(aId: string): Boolean;
    procedure ReadLastId;
    procedure setBild(aMs: TMemoryStream);
    procedure LoadBildIntoBitmap(aBitmap: TBitmap);
    function getBildStream: TMemoryStream;
    //procedure Delete(aGbId, aDeId: string);
    //procedure Delete(aDeId: string);
    procedure DeleteByAufgabe(aToDoId: string);
    procedure DeleteByZaehler(aDeId: string);
    procedure DeleteById(aId: Integer);
    function Load(aZaehler: TZaehler): Boolean;
  end;

implementation

{ TDBZaehlerUpdate }

uses
  Objekt.BasCloud, FMX.DialogService, fmx.Types;

constructor TDBZaehlerUpdate.Create;
begin
  inherited;
  fBild := nil;
  Init;
end;

destructor TDBZaehlerUpdate.Destroy;
begin

  inherited;
end;


function TDBZaehlerUpdate.getBildStream: TMemoryStream;
begin
  Result := fBild;
end;

procedure TDBZaehlerUpdate.Init;
begin
  fGBId        := '';
  fDeId        := '';
  fStand       := '';
  fId          := 0;
  fImportDatum := now;
  fToDoId      := '';
  fDatum       := 0;
  if fBild <> nil then
    FreeAndNil(fBild);
end;


function TDBZaehlerUpdate.Insert: Boolean;
var
  s: string;
begin
  Result := true;
  try
    if ZaehlerExist(fId) then
      exit;

    s := 'insert into zaehlerupdate (zu_gb_id, zu_de_id, zu_stand, zu_importdatum, zu_datum, zu_bild, zu_to_id) values ' +
         '(:gbid, :deid, :stand, :importdatum, :datum, :bild, :toid)';
    fQuery.SQL.Text := s;
    fQuery.ParamByName('gbid').AsString := fGBId;
    fQuery.ParamByName('deid').AsString := fDeId;
    fQuery.ParamByName('stand').AsString := fStand;
    fQuery.ParamByName('importdatum').AsDateTime := fImportDatum;
    fQuery.ParamByName('datum').AsDateTime := fDatum;
    fQuery.ParamByName('toid').AsString := fToDoId;
    fQuery.ParamByName('bild').AsString := '';
    fQuery.ParamByName('bild').AsString := '';
    if fBild <> nil then
    begin
      fBild.Position := 0;
      if fBild.Size > BasCloud.ImageMinSize then
        fQuery.ParamByName('bild').LoadFromStream(fBild, ftBlob);
      fBild.Position := 0;
      //fBild.SaveToFile('c:\temp\DBTest\Insert.bmp');
    end;

    fQuery.ExecSQL;
  except
    on E: Exception do
    begin
      log.d('TDBZaehlerUpdate.Insert: ' + E.Message);
      BasCloud.Error := E.Message;
    end;
  end;
end;

function TDBZaehlerUpdate.Update: Boolean;
var
  s: string;
begin
  try
    s := ' update zaehlerupdate set zu_gb_id = :gbid, zu_de_id = :deid, zu_stand = :stand, zu_importdatum = :importdatum,' +
         ' zu_datum = :datum, zu_to_id = :toid' +
         ' where zu_id = :id';

    fQuery.Sql.Text := s;
    fQuery.ParamByName('gbid').AsString          := fGBId;
    fQuery.ParamByName('deid').AsString          := fDeId;
    fQuery.ParamByName('stand').AsString         := fStand;
    fQuery.ParamByName('importdatum').AsDateTime := fImportDatum;
    fQuery.ParamByName('datum').AsDateTime       := fDatum;
    fQuery.ParamByName('id').AsInteger           := fId;
    fQuery.ParamByName('toid').AsString          := fToDoId;

    fQuery.ExecSQL;
  except
    on E: Exception do
    begin
      log.d('TDBZaehlerUpdate.Update: ' + E.Message);
      BasCloud.Error := E.Message;
    end;
  end;

  Result := true;
end;

procedure TDBZaehlerUpdate.CreateBild;
begin
  if fBild <> nil then
    FreeAndNil(fBild);
  fBild := TMemoryStream.Create;
end;

procedure TDBZaehlerUpdate.LoadBildIntoBitmap(aBitmap: TBitmap);
begin
  fBild.Position := 0;
  try
    if fBild.Size > BasCloud.ImageMinSize then
      aBitmap.LoadFromStream(fBild);
  except
    on E: Exception do
    begin
      log.d('TDBZaehlerUpdate.LoadBildIntoBitmap: ' + E.Message);
    end;
  end;
  fBild.Position := 0;
end;

procedure TDBZaehlerUpdate.LoadFromQuery(aQry: TFDQuery);
var
  Stream: TStream;
begin
  try
    fId          := aQry.FieldByName('zu_id').AsInteger;
    fGbId        := Trim(aQry.FieldByName('zu_gb_id').AsString);
    fDeId        := Trim(aQry.FieldByName('zu_de_id').AsString);
    fStand       := Trim(aQry.FieldByName('zu_stand').AsString);
    fImportDatum := aQry.FieldByName('zu_importdatum').AsDateTime;
    fDatum       := aQry.FieldByName('zu_datum').AsDateTime;
    fToDoId      := Trim(aQry.FieldByName('zu_to_id').AsString);

    CreateBild;
    Stream := aQry.CreateBlobStream(aQry.FieldByName('zu_bild'), bmRead);
    Stream.Position := 0;
    if Stream.Size > BasCloud.ImageMinSize then
      fBild.LoadFromStream(Stream);
    fBild.Position := 0;
    //fBild.SaveToFile('c:\temp\DBTest\Load.bmp');
    FreeAndNil(Stream);
  except
    on E: Exception do
    begin
      log.d('TDBZaehlerUpdate.LoadFromQuery: ' + E.Message);
    end;
  end;
end;

function TDBZaehlerUpdate.Read(aId: string): Boolean;
var
  s: string;
begin
  Result := false;
  try
    s := 'select * from zaehlerupdate where zu_id = :id';
    fQuery.Close;
    fQuery.SQL.Text := s;
    fQuery.ParamByName('id').AsString := aId;
    fQuery.Open;
    Init;
    if not fQuery.Eof then
    begin
      LoadFromQuery(fQuery);
      Result := true;
    end;
  except
    on E: Exception do
    begin
      log.d('TDBZaehlerUpdate.Read: ' + E.Message);
    end;
  end;
end;

function TDBZaehlerUpdate.ReadFromDevice(aId: string): Boolean;
var
  s: string;
begin
   //BasCloud.Log('Start --> ReadFromDevice');
  Result := false;
  try
    s := 'select * from zaehlerupdate where zu_de_id = :id';
    fQuery.Close;
    fQuery.SQL.Text := s;
    fQuery.ParamByName('id').AsString := aId;
    try
      fQuery.Open;
    except
      on E: Exception do
      begin
        log.d('TDBZaehlerUpdate.ReadFromDevice: ' + E.Message);
        BasCloud.Log('Error: ' + E.Message);
      end;
    end;
    Init;
    if not fQuery.Eof then
    begin
      LoadFromQuery(fQuery);
      Result := true;
    end;
  except
    on E: Exception do
    begin
      log.d('TDBZaehlerUpdate.ReadFromDevice: ' + E.Message);
    end;
  end;
  //BasCloud.Log('Ende --> ReadFromDevice');
end;

procedure TDBZaehlerUpdate.ReadLastId;
var
  s: string;
begin
  try
    s := 'select * from zaehlerupdate order by zu_id desc';
    fQuery.Close;
    fQuery.SQL.Text := s;
    fQuery.Open;
    Init;
    if not fQuery.Eof then
      LoadFromQuery(fQuery);
  except
    on E: Exception do
    begin
      log.d('TDBZaehlerUpdate.ReadLastId: ' + E.Message);
    end;
  end;
end;


procedure TDBZaehlerUpdate.setBild(aMs: TMemoryStream);
begin
  try
    CreateBild;
    fBild.Position := 0;
    if aMs.Size > BasCloud.ImageMinSize then
      fBild.LoadFromStream(aMs);
    fBild.Position := 0;
  except
    on E: Exception do
    begin
      log.d('TDBZaehlerUpdate.setBild: ' + E.Message);
    end;
  end;
end;


function TDBZaehlerUpdate.ZaehlerExist(aId: Integer): Boolean;
var
  s: string;
begin
  Result := false;
  try
    s := 'select zu_id from zaehlerupdate where zu_id = :id';
    fQuery.Close;
    fQuery.SQL.Text := s;
    fQuery.ParamByName('id').AsInteger := aId;
    fQuery.Open;
    Result := not fQuery.Eof;
    fQuery.Close;
  except
    on E: Exception do
    begin
      log.d('TDBZaehlerUpdate.ZaehlerExist: ' + E.Message);
    end;
  end;
end;


{
procedure TDBZaehlerUpdate.Delete(aGbId, aDeId: string);
begin
  fQuery.SQL.Text := 'delete from zaehlerupdate where zu_gb_id = :gbid and zu_de_id = :deid';
  fQuery.ParamByName('gbid').AsString := aGbId;
  fQuery.ParamByName('deid').AsString := aDeId;
  try
    fQuery.ExecSQL;
  except
    on E: Exception do
    begin
      //TDialogService.ShowMessage('TDBZaehlerUpdate.Delete --> ' + E.Message);
      BasCloud.Log('TDBZaehlerUpdate.Delete --> ' + E.Message);
    end;
  end;
end;
}

{
procedure TDBZaehlerUpdate.Delete(aDeId: string);
begin
  fQuery.SQL.Text := 'delete from zaehlerupdate where zu_de_id = :deid';
  fQuery.ParamByName('deid').AsString := aDeId;
  try
    fQuery.ExecSQL;
  except
    on E: Exception do
    begin
      //TDialogService.ShowMessage('TDBZaehlerUpdate.Delete --> ' + E.Message);
      //BasCloud.Log('TDBZaehlerUpdate.Delete --> ' + E.Message);
    end;
  end;
end;
}

procedure TDBZaehlerUpdate.DeleteByAufgabe(aToDoId: string);
begin
  log.d('TDBZaehlerUpdate.DeleteByAufgabe(aToDoId: string)');
  fQuery.SQL.Text := 'delete from zaehlerupdate where zu_to_id = :ToDoId';
  fQuery.ParamByName('ToDoId').AsString := aToDoId;
  try
    fQuery.ExecSQL;
  except
    on E: Exception do
    begin
      log.d('TDBZaehlerUpdate.DeleteByAufgabe: ' + E.Message);
      BasCloud.Error := e.Message;
    end;
  end;
end;

procedure TDBZaehlerUpdate.DeleteByZaehler(aDeId: string);
begin
  log.d('TDBZaehlerUpdate.DeleteByZaehler(aDeId: string);');
  fQuery.SQL.Text := 'delete from zaehlerupdate where zu_de_id = :DeId';
  fQuery.ParamByName('DeId').AsString := aDeId;
  try
    fQuery.ExecSQL;
  except
    on E: Exception do
    begin
      log.d('TDBZaehlerUpdate.DeleteByZaehler: ' + E.Message);
      BasCloud.Error := e.Message;
    end;
  end;
end;

procedure TDBZaehlerUpdate.DeleteById(aId: Integer);
begin
  log.d('TDBZaehlerUpdate.DeleteById(aDeId: string);');
  fQuery.SQL.Text := 'delete from zaehlerupdate where zu_id = :Id';
  fQuery.ParamByName('Id').AsInteger := aId;
  try
    fQuery.ExecSQL;
  except
    on E: Exception do
    begin
      log.d('TDBZaehlerUpdate.DeleteById: ' + E.Message);
      BasCloud.Error := e.Message;
    end;
  end;
end;


function TDBZaehlerUpdate.Load(aZaehler: TZaehler): Boolean;
var
  Zaehlerstand: Extended;
begin
  Result := false;
  try
    if (aZaehler = nil) or (aZaehler.Id = '') then
      exit;

    ReadFromDevice(aZaehler.id);

    if fDeId <> aZaehler.Id then
      exit;

    if not TryStrToFloat(fStand, Zaehlerstand) then
      exit;

    aZaehler.Zaehlerstand.Zaehlerstand := Zaehlerstand;
    aZaehler.Zaehlerstand.Datum := fDatum;

    if fBild = nil then
      exit;

    aZaehler.Zaehlerstand.LoadBitmapFromStream(fBild);

    Result := true;
  except
    on E: Exception do
    begin
      log.d('TDBZaehlerUpdate.Load: ' + E.Message);
      BasCloud.Error := e.Message;
    end;
  end;

end;



end.
