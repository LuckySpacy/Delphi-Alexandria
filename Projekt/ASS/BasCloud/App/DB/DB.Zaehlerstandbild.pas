unit DB.Zaehlerstandbild;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, DB.Basis, FMX.Graphics, Objekt.Zaehler, Objekt.Zaehlerstand;

type
  TDBZaehlerstandbild = class(TDBBasis)
  private
    fId: string;
    fDeId: string;
    fBild: TMemoryStream;
    procedure LoadFromQuery(aQry: TFDQuery);
    procedure CreateBild;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Init;
    function Insert: Boolean;
    function Read(aId: string): Boolean;
    function DeleteDevice(aZaehler: TZaehler): Boolean;
    property Id: string read fId write fId;
    property DeId: string read fDeId write fDeId;
    procedure setBild(aMs: TMemoryStream);
    procedure LoadBildIntoBitmap(aBitmap: TBitmap);
    function save(aZaehler: TZaehler): Boolean;
    function Load(aZaehler: TZaehler): Boolean;
    function LoadFromDevice(aZaehler: TZaehler): Boolean;
    function getBildSize: Integer;
  end;


implementation

{ TDBZaehlerstandbild }

uses
  Objekt.BasCloud, system.UITypes, fmx.Types;

constructor TDBZaehlerstandbild.Create;
begin
  inherited;
  fBild := nil;
end;

destructor TDBZaehlerstandbild.Destroy;
begin
  if fBild <> nil then
    FreeAndNil(fBild);
  inherited;
end;



function TDBZaehlerstandbild.getBildSize: Integer;
begin
  Result := 0;
  if fBild = nil then
    exit;
  if fBild.Size <= BasCloud.ImageMinSize then
    exit;
  Result := fBild.Size;
end;

procedure TDBZaehlerstandbild.Init;
begin
  fId   := '';
  fDeId := '';
  if fBild <> nil then
    FreeAndNil(fBild);
end;


procedure TDBZaehlerstandbild.LoadFromQuery(aQry: TFDQuery);
var
  Stream: TStream;
begin
  try
    init;

    CreateBild;
    Stream := aQry.CreateBlobStream(aQry.FieldByName('zb_bild'), bmRead);
    try
      Stream.Position := 0;
      if Stream.Size > BasCloud.ImageMinSize then
        fBild.LoadFromStream(Stream);
      fBild.Position := 0;
    finally
      FreeAndNil(Stream);
    end;

    fId   := aQry.FieldByName('zb_za_id').AsString; // <-- Reading Id
    fDeId := aQry.FieldByName('zb_de_id').AsString; // <-- Zähler Id
  except
    on E: Exception do
    begin
      log.d('TDBZaehlerstandbild.LoadFromQuery: ' + e.Message);
    end;
  end;

end;


function TDBZaehlerstandbild.DeleteDevice(aZaehler: TZaehler): Boolean;
var
{$IFDEF WIN32}
  List: TStringList;
{$ENDIF WIN32}
  s: string;
begin
  Result := true;

  {$IFDEF WIN32}
  if DirectoryExists('c:\temp\BAScloud\') then
  begin
    List := TStringList.Create;
    if FileExists('c:\temp\BAScloud\TDBZaehlerstandbild_DeleteDevice.txt') then
      List.LoadFromFile('c:\temp\BAScloud\TDBZaehlerstandbild_DeleteDevice.txt');
    List.Add(DateTimeToStr(now) + ' - ' + aZaehler.Id + ' - ' + FloatToStr(aZaehler.Zaehlerstand.Zaehlerstand));
    List.SaveToFile('c:\temp\BAScloud\TDBZaehlerstandbild_DeleteDevice.txt');
    FreeAndNil(List);
  end;
  {$ENDIF WIN32}
  s := 'delete from zaehlerstandbild where zb_de_id = :id'; // <-- Alle Zählerstandsbilder zum Zähler löschen
  fQuery.SQL.Text := s;
  fQuery.ParamByName('id').AsString := aZaehler.Id;
  try
    fQuery.ExecSQL;
  except
    on E: Exception do
    begin
      log.d('TDBZaehlerstandbild.DeleteDevice: ' + e.Message);
      BasCloud.Error := E.Message;
      Result := false;
    end;
  end;
end;


function TDBZaehlerstandbild.LoadFromDevice(aZaehler: TZaehler): Boolean;
begin
  fQuery.Close;
  fQuery.SQL.Text := 'select * from zaehlerstandbild where zb_de_id = ' + QuotedStr(aZaehler.Id);
  fQuery.Open;
  Result := not fQuery.Eof;
  if Result then
    LoadFromQuery(fQuery)
  else
    Init;
  fQuery.Close;
end;



procedure TDBZaehlerstandbild.LoadBildIntoBitmap(aBitmap: TBitmap);
begin
  aBitmap.Clear(TAlphaColors.White);
  fBild.Position := 0;
  try
    if fBild.Size > BasCloud.ImageMinSize then
      aBitmap.LoadFromStream(fBild);
  except
    on E: Exception do
    begin
      log.d('TDBZaehlerstandbild.LoadBildIntoBitmap: ' + e.Message);
      BasCloud.Error := E.Message;
    end;
  end;
  fBild.Position := 0;
end;






function TDBZaehlerstandbild.Read(aId: string): Boolean;
var
  s: string;
begin
  Result := false;
  try
    s := 'select * from zaehlerstandbild where zb_za_id = :id';
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
      log.d('TDBZaehlerstandbild.Read: ' + e.Message);
      BasCloud.Error := E.Message;
    end;
  end;
end;


procedure TDBZaehlerstandbild.setBild(aMs: TMemoryStream);
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
      log.d('TDBZaehlerstandbild.setBild: ' + e.Message);
      BasCloud.Error := E.Message;
    end;
  end;
end;


procedure TDBZaehlerstandbild.CreateBild;
begin
  if fBild <> nil then
    FreeAndNil(fBild);
  fBild := TMemoryStream.Create;
end;



function TDBZaehlerstandbild.Insert: Boolean;
var
  s: string;
  {$IFDEF WIN32}
    List : TStringList;
  {$ENDIF WIN32}
begin
  Result := true;
  try
    //if fBild = nil then
    //  exit; // Kein Bild, kein Insert

    {$IFDEF DEBUGMODE}
    if Trim(fId) = '' then
    begin
      TDialogService.ShowMessage('TDBZaehlerstandbild.Insert --> Id ist leer');
    end;
    {$ENDIF DEBUGMODE}


    s := 'INSERT or REPLACE into zaehlerstandbild (zb_za_id, zb_de_id, zb_bild) values ' +
         '(:id, :deid, :bild)';
    fQuery.SQL.Text := s;

    fBild.Position := 0;
    if fBild.Size > BasCloud.ImageMinSize then
      fQuery.ParamByName('bild').LoadFromStream(fBild, ftBlob)
    else
      fQuery.ParamByName('bild').AsString := '';
    fBild.Position := 0;

    fQuery.ParamByName('id').AsString   := fId;
    fQuery.ParamByName('deid').AsString := fDeId;
    fQuery.ExecSQL;

    {$IFDEF WIN32}
    if DirectoryExists('c:\temp\BAScloud\') then
    begin
      List := TStringList.Create;
      if FileExists('c:\temp\BAScloud\TDBZaehlerstandbild.Insert.txt') then
        List.LoadFromFile('c:\temp\BAScloud\TDBZaehlerstandbild.Insert.txt');
      List.Add(DateTimeToStr(now) + ' - ' + fId + ' / ' + fDeId);
      List.SaveToFile('c:\temp\BAScloud\TDBZaehlerstandbild.Insert.txt');
      FreeAndNil(List);
    end;
    {$ENDIF WIN32}

  except
    on E: Exception do
    begin
      log.d('TDBZaehlerstandbild.Insert: ' + e.Message);
      //BasCloud.Error := 'TDBZaehlerstandbild.Insert: ' + E.Message;
      //Result := false;
    end;
  end;
end;

function TDBZaehlerstandbild.save(aZaehler: TZaehler): Boolean;
var
  ms: TMemoryStream;
begin
  Result := false;
  try
    if aZaehler = nil then
      exit;
    if aZaehler.Zaehlerstand = nil then
      exit;
    if aZaehler.Zaehlerstand.Image = nil then
      exit;
    DeleteDevice(aZaehler);

    init;
    ms := TMemoryStream.Create;
    try
      //log.d('Vorher -> aZaehler.Zaehlerstand.Image.Bitmap.SaveToStream(ms)');
      try
        aZaehler.Zaehlerstand.Image.Bitmap.SaveToStream(ms);
      except
        exit;
      end;
      //log.d('Nachher -> aZaehler.Zaehlerstand.Image.Bitmap.SaveToStream(ms)');
      //log.d('Vorher -> setBild');
      setBild(ms);
      //log.d('Nachher -> setBild');
    finally
      FreeAndNil(ms);
    end;
    fDeId := aZaehler.Id;
    fId := aZaehler.Zaehlerstand.Id;
    Result := Insert;
  except
    on E: Exception do
    begin
      log.d('TDBZaehlerstandbild.save: ' + e.Message);
      BasCloud.Error := E.Message;
      Result := false;
    end;
  end;
end;

function TDBZaehlerstandbild.Load(aZaehler: TZaehler): Boolean;
begin
  Result := false;
  try
    if (aZaehler = nil) or (aZaehler.Id = '') or (aZaehler.Zaehlerstand.Id = '') then
      exit;

    log.d('TDBZaehlerstandbild.Load -> ' + aZaehler.Zaehlerstand.id);
    Read(aZaehler.Zaehlerstand.id);

    if fId <> aZaehler.Zaehlerstand.Id then
    begin
      log.d('Bild nicht gefunden');
      exit;
    end;

    if fBild = nil then
    begin
      log.d('Es gibt kein Bild');
      exit;
    end;

    aZaehler.Zaehlerstand.LoadBitmapFromStream(fBild);

    log.d('Bild wurde eingelesen');
    Result := true;
  except
    on E: Exception do
    begin
      log.d('TDBZaehlerstandbild.Load: ' + e.Message);
      BasCloud.Error := E.Message;
      Result := false;
    end;
  end;


end;


end.
