unit DB.Zaehler;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, DB.Basis, FMX.Graphics, Objekt.Zaehler, Objekt.Zaehlerstand;

type
  TDBZaehler = class(TDBBasis)
  private
    fId: string;
    fGbId: string;
    fDeId: string;
    fStand: string;
    fImportdatum: TDateTime;
    fDatum: TDateTime;
    fCreateDatum: TDateTime;
    fBild: TMemoryStream;
    procedure LoadFromQuery(aQry: TFDQuery);
    procedure CreateBild;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Init;
    function Insert: Boolean;
    function Patch: Boolean;
    function Read(aId: string): Boolean;
    function ReadDevice(aId: string): Boolean;
    function DeviceExist(aId: string): Boolean;
    function DeleteDevice(aId: string): Boolean;
    function Update: Boolean;
    property Id: string read fId write fId;
    property GbId: string read fGbId write fGbId;
    property DeId: string read fDeId write fDeId;
    property Stand: string read fStand write fStand;
    property Importdatum: TDateTime read fImportdatum write fImportdatum;
    property Datum: TDateTime read fDatum write fDatum;
    property CreateDatum: TDateTime read fCreateDatum write fCreateDatum;
    procedure setBild(aMs: TMemoryStream);
    procedure LoadBildIntoBitmap(aBitmap: TBitmap);
    function save(aZaehler: TZaehler): Boolean;
    function Load(aZaehler: TZaehler): Boolean;
  end;

implementation

{ TDBZaehler }

uses
  Objekt.BasCloud, FMX.DialogService, fmx.Types;


constructor TDBZaehler.Create;
begin
  inherited;
  Init;
end;


destructor TDBZaehler.Destroy;
begin

  inherited;
end;

procedure TDBZaehler.Init;
begin
  fId          := '';
  fGbId        := '';
  fDeId        := '';
  fStand       := '';
  fImportdatum := 0;
  fDatum       := 0;
  fCreatedatum := 0;
end;

function TDBZaehler.Insert: Boolean;
var
  s: string;
begin
  Result := true;
  try
    s := 'insert into zaehler (za_id, za_gb_id, za_de_id, za_importdatum, za_datum, za_bild, za_create, za_stand) values ' +
         '(:id, :gbid, :deid, :importdatum, :datum, :bild, :createdatum, :stand)';
    fQuery.SQL.Text := s;

    {
    if fBild <> nil then
    begin
      fBild.Position := 0;
      if fBild.Size > BasCloud.ImageMinSize then
        fQuery.ParamByName('bild').LoadFromStream(fBild, ftBlob)
      else
        fQuery.ParamByName('bild').AsString := '';
      fBild.Position := 0;
      //fBild.SaveToFile('c:\temp\DBTest\Insert.bmp');
    end;
    }

    fQuery.ParamByName('bild').AsString := '';
    fQuery.ParamByName('id').AsString   := fId;
    fQuery.ParamByName('gbid').AsString := fGbId;
    fQuery.ParamByName('deid').AsString := fDeId;
    fQuery.ParamByName('datum').AsDateTime := fDatum;
    fQuery.ParamByName('importdatum').AsDateTime := fImportdatum;
    fQuery.ParamByName('createdatum').AsDateTime := fCreateDatum;
    fQuery.ParamByName('stand').AsString := fStand;
    log.d('TDBZaehler.Insert: ' + fId);
    fQuery.ExecSQL;

  except
    on E: Exception do
    begin
      log.d('TDBZaehler.Insert: ' + E.Message);
      BasCloud.Error := E.Message;
      Result := false;
    end;
  end;
end;

procedure TDBZaehler.LoadFromQuery(aQry: TFDQuery);
var
  Stream: TStream;
begin
  if (aQry.FieldByName('za_bild').AsString = '') then
  begin
    if fBild <> nil then
      FreeAndNil(fBild);
  end;

  CreateBild;
  Stream := aQry.CreateBlobStream(aQry.FieldByName('za_bild'), bmRead);
  Stream.Position := 0;
  if Stream.Size > BasCloud.ImageMinSize then
    fBild.LoadFromStream(Stream);
  fBild.Position := 0;
  FreeAndNil(Stream);

  fId          := aQry.FieldByName('za_id').AsString;
  fGbId        := aQry.FieldByName('za_gb_id').AsString;
  fDeId        := aQry.FieldByName('za_de_id').AsString;
  fStand       := aQry.FieldByName('za_stand').AsString;
  fImportDatum := aQry.FieldByName('za_importdatum').AsDateTime;
  fDatum       := aQry.FieldByName('za_datum').AsDateTime;
  fCreateDatum := aQry.FieldByName('za_create').AsDateTime;
end;



function TDBZaehler.Patch: Boolean;
var
  s: string;
begin
  Result := false;
  try
    s := ' update zaehler set za_gb_id = :gbid, za_de_id = :deid, za_stand = :stand, za_importdatum = :importdatum,' +
         ' za_datum = :datum, za_bild = :bild, za_create = :createdatum' +
         ' where za_id = :id';


    fQuery.Sql.Text := s;

    if fBild <> nil then
    begin
      fBild.Position := 0;
      if fBild.Size > BasCloud.ImageMinSize then
        fQuery.ParamByName('bild').LoadFromStream(fBild, ftBlob);
      fBild.Position := 0;
    end;

    fQuery.ParamByName('id').AsString   := fId;
    fQuery.ParamByName('gbid').AsString := fGbId;
    fQuery.ParamByName('deid').AsString := fDeId;
    fQuery.ParamByName('stand').AsString := fStand;
    fQuery.ParamByName('datum').AsDateTime := fDatum;
    fQuery.ParamByName('importdatum').AsDateTime := fImportdatum;
    fQuery.ParamByName('createdatum').AsDateTime := fCreateDatum;

    fQuery.ExecSQL;
  except
    on E: Exception do
    begin
      log.d('TDBZaehler.Patch: ' + E.Message);
      BasCloud.Error := E.Message;
      exit;
    end;
  end;

  Result := true;
end;

function TDBZaehler.Read(aId: string): Boolean;
var
  s: string;
begin
  Result := false;
  try
    s := 'select * from zaehler where za_id = :id';
    fQuery.SQL.Text := s;
    fQuery.ParamByName('id').AsString := aId;
    fQuery.Open;
    Result := not fQuery.Eof;
    if Result then
      LoadFromQuery(fQuery)
    else
      Init;
    fQuery.Close;
  except
    on E: Exception do
    begin
      log.d('TDBZaehler.Read: ' + E.Message);
      BasCloud.Error := E.Message;
      exit;
    end;
  end;
end;

function TDBZaehler.ReadDevice(aId: string): Boolean;
var
  s: string;
begin
  Result := false;
  try
    s := 'select * from zaehler where za_de_id = :id order by za_datum desc';
    fQuery.SQL.Text := s;
    fQuery.ParamByName('id').AsString := aId;
    fQuery.Open;
    Result := not fQuery.Eof;
    if Result then
      LoadFromQuery(fQuery)
    else
      Init;
    fQuery.Close;
  except
    on E: Exception do
    begin
      log.d('TDBZaehler.ReadDevice: ' + E.Message);
      BasCloud.Error := E.Message;
      exit;
    end;
  end;
end;

function TDBZaehler.DeleteDevice(aId: string): Boolean;
var
  s: string;
begin
  Result := true;
  try
    //if aId = '399e351f-5279-4c1a-942e-a6b80f21bc5a' then
    //  log.d('Delete: ' + aId);
    s := 'delete from zaehler where za_de_id = :id';
    fQuery.SQL.Text := s;
    fQuery.ParamByName('id').AsString := aId;
    try
      fQuery.ExecSQL;
    except
      on E: Exception do
      begin
        log.d('TDBZaehler.DeleteDevice: ' + E.Message);
        BasCloud.Error := E.Message;
        Result := false;
      end;
    end;
  except
    on E: Exception do
    begin
      log.d('TDBZaehler.DeleteDevice: ' + E.Message);
      BasCloud.Error := E.Message;
      exit;
    end;
  end;
end;


function TDBZaehler.DeviceExist(aId: string): Boolean;
var
  s: string;
begin
  Result := false;
  try
    s := 'select za_id from zaehler where za_de_id = :id';
    fQuery.SQL.Text := s;
    fQuery.ParamByName('id').AsString := aId;
    fQuery.Open;
    Result := not fQuery.Eof;
    fQuery.Close;
  except
    on E: Exception do
    begin
      log.d('TDBZaehler.DeviceExist: ' + E.Message);
      BasCloud.Error := E.Message;
      exit;
    end;
  end;
end;


procedure TDBZaehler.setBild(aMs: TMemoryStream);
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
      log.d('TDBZaehler.setBild: ' + E.Message);
      BasCloud.Error := E.Message;
      exit;
    end;
  end;
end;

function TDBZaehler.Update: Boolean;
begin
  Result := true;
end;

procedure TDBZaehler.CreateBild;
begin
  if fBild <> nil then
    FreeAndNil(fBild);
  fBild := TMemoryStream.Create;
end;


procedure TDBZaehler.LoadBildIntoBitmap(aBitmap: TBitmap);
begin
  fBild.Position := 0;
  try
    if fBild.Size > BasCloud.ImageMinSize then
      aBitmap.LoadFromStream(fBild);
  except
    on E: Exception do
    begin
      log.d('TDBZaehler.LoadBildIntoBitmap: ' + E.Message);
      exit;
    end;
  end;
  fBild.Position := 0;
end;


function TDBZaehler.save(aZaehler: TZaehler): Boolean;
var
  //ms: TMemoryStream;
  Zaehlerstand: TZaehlerstand;
  GebaudeId: string;
  doPatch: Boolean;
begin
  Result := false;
  try
    if aZaehler = nil then
      exit;

    Zaehlerstand := aZaehler.Zaehlerstand;
    if Zaehlerstand = nil then
      exit;

    if (Zaehlerstand.Id = '') then
      exit;

    doPatch   := false;
    GebaudeId := '';
    if aZaehler.Gebaude <> nil then
      GebaudeId := aZaehler.Gebaude.Id;

    //DeleteDevice(aZaehler.Id); // <-- Alle Zählerstände zum Zähler löschen

    Init;
    if GebaudeId = '' then
    begin
      Read(Zaehlerstand.Id);
      doPatch := fId > '';
    end;

    {
    if Zaehlerstand.Image <> nil then
    begin
      ms := TMemoryStream.Create;
      try
        Zaehlerstand.SaveImageToStream(ms);
        ms.Position := 0;
        setBild(ms);
      finally
        FreeAndNil(ms);
      end;
    end;
    }

    fId          := Zaehlerstand.Id;
    fGbId        := GebaudeId;
    fdeId        := aZaehler.Id;
    fStand       := FloatToStr(Zaehlerstand.Zaehlerstand);
    fDatum       := Zaehlerstand.Datum;
    fCreateDatum := now;

    if doPatch then
      Result :=Patch
    else
      Result := Insert;


    Zaehlerstand.ClearImage;  // <-- Um nicht den Speicher des Smartphones zu überladen

  except
    on E: Exception do
    begin
      log.d('TDBZaehler.save: ' + E.Message);
      exit;
    end;
  end;

end;


function TDBZaehler.Load(aZaehler: TZaehler): Boolean;
var
  Zaehlerstand: Extended;
begin
  Result := false;
  try
    if (aZaehler = nil) or (aZaehler.Id = '') then
      exit;

    ReadDevice(aZaehler.id);

    if fDeId <> aZaehler.Id then
      exit;

    if not TryStrToFloat(fStand, Zaehlerstand) then
      exit;

    aZaehler.Zaehlerstand.Id := fId;
    aZaehler.Zaehlerstand.Zaehlerstand := Zaehlerstand;
    aZaehler.Zaehlerstand.Datum := fDatum;

    Result := true;
  except
    on E: Exception do
    begin
      log.d('TDBZaehler.Load: ' + E.Message);
      exit;
    end;
  end;

end;




end.
