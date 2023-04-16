unit DB.BilderList;

interface

uses
  SysUtils, System.Classes, DB.BasisList, DB.Bilder, Firedac.Stan.Param, types.PhotoOrga,
  FireDAC.Comp.Client;

type
  TDBBilderList = class(TDBBasisList)
  private
    fConnection: TFDConnection;
    function getItem(Index: Integer): TDBBilder;
    procedure setConnection(const Value: TFDConnection);
  public
    constructor Create; override;
    destructor Destroy; override;
    property Item[Index: Integer]: TDBBilder read getItem;
    function Add: TDBBilder;
    procedure ReadDir(aDir: string);
    procedure ReadAll;
    procedure ReadAllToBilderList;
    procedure DeleteAll;
    procedure Read_DirList;
    property Connection: TFDConnection read fConnection write setConnection;
  end;

implementation

{ TDBBilderList }

uses
  fmx.Types, Objekt.PhotoOrga, Objekt.Bild, Data.DB;


constructor TDBBilderList.Create;
begin
  inherited;

end;


destructor TDBBilderList.Destroy;
begin

  inherited;
end;

function TDBBilderList.getItem(Index: Integer): TDBBilder;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TDBBilder(fList.Items(Index));
end;

procedure TDBBilderList.ReadDir(aDir: String);
var
  DBBilder: TDBBilder;
  WasOpen: Boolean;
begin
  try
    if fQuery.Transaction <> nil then
      WasOpen := fQuery.Transaction.Active;
    if (fQuery.Transaction <> nil) and (not fQuery.Transaction.Active) then
      fQuery.Transaction.StartTransaction;
    fQuery.Close;
    fQuery.Sql.Text := ' select * from bilder' +
                       ' where bi_pfad = :pfad ' +
                       ' order by bi_datum, bi_LastWriteTimeUtc desc';
    fQuery.ParamByName('pfad').AsString := aDir;
    try
      fQuery.Open;
    except
      on E: Exception do
      begin
        log.d('TDBQueueList.ReadAll: ' + E.Message);
      end;
    end;
    fList.Clear;
    while not fQuery.Eof do
    begin
      DBBilder := Add;
      DBBilder.LoadFromQuery(fQuery);
      fQuery.Next;
    end;
    fQuery.Close;
    if (fQuery.Transaction <> nil) and (not WasOpen) and (fQuery.Transaction.Active) then
      fQuery.Transaction.Rollback;
  except
    on E: Exception do
    begin
      log.d('TDBBilderList.ReadDir: ' + E.Message);
    end;
  end;
end;

procedure TDBBilderList.Read_DirList;
var
  DBBilder: TDBBilder;
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := fQuery.connection;
    try
      fQuery.Close;
      fQuery.Sql.Text := ' select bi_pfad from bilder' +
                         ' group by bi_pfad' +
                         ' order by bi_datum, bi_lastwriteTimeutc desc';
      qry.sql.Text := 'select * from bilder where bi_pfad = :pfad';
      try
        fQuery.Open;
      except
        on E: Exception do
        begin
          log.d('TDBQueueList.Read_DirList: ' + E.Message);
        end;
      end;
      fList.Clear;
      while not fQuery.Eof do
      begin
        qry.Close;
        qry.ParamByName('pfad').AsString := fQuery.FieldByName('bi_pfad').AsString;
        qry.Open;
        DBBilder := Add;
        DBBilder.LoadFromQuery(qry);
        qry.Close;
        fQuery.Next;
      end;
    except
      on E: Exception do
      begin
        log.d('TDBBilderList.Read_DirList: ' + E.Message);
      end;
    end;
  finally
    FreeAndNil(qry);
  end;
end;

procedure TDBBilderList.setConnection(const Value: TFDConnection);
begin
  fConnection := Value;
  fQuery.Connection := Value;
end;

procedure TDBBilderList.ReadAll;
var
  DBBilder: TDBBilder;
  i1: Integer;
begin
  i1 := 0;
  try
    fQuery.Close;
    fQuery.Sql.Text := ' select * from bilder order by bi_datum desc, bi_lastwriteTimeutc desc';
    try
      fQuery.Open;
    except
      on E: Exception do
      begin
        log.d('TDBQueueList.ReadAll: ' + E.Message);
      end;
    end;
    fList.Clear;
    while not fQuery.Eof do
    begin
      inc(i1);
      if i1 > 101 then
        break;
      DBBilder := Add;
      DBBilder.LoadFromQuery(fQuery);
      fQuery.Next;
    end;
  except
    on E: Exception do
    begin
      log.d('TDBBilderList.ReadDir: ' + E.Message);
    end;
  end;
end;


procedure TDBBilderList.ReadAllToBilderList;
var
  Bild: TBild;
  Stream: TStream;
begin
  fQuery.Close;
  fQuery.Sql.Text := ' select * from bilder order by bi_datum desc, bi_lastwriteTimeutc desc';
  fQuery.Open;
  while not fQuery.Eof do
  begin
    Bild := PhotoOrga.BilderList.Add(fQuery.FieldByName('bi_id').AsString);
    Bild.Pfad             := fQuery.FieldByName('bi_pfad').AsString;
    Bild.Bildname         := fQuery.FieldByName('bi_bildname').AsString;
    Bild.LastWriteTimeUtc := fQuery.FieldByName('bi_LastWriteTimeUtc').AsString;
    Bild.Datum            := fQuery.FieldByName('bi_Datum').AsString;
    Bild.Orientation      := fQuery.FieldByName('bi_Orientation').AsString;
    Bild.CameraMarke      := fQuery.FieldByName('bi_Cameramarke').AsString;
    Bild.CameraModel      := fQuery.FieldByName('bi_Cameramodel').AsString;
    Bild.Latitude         := fQuery.FieldByName('bi_Latitude').AsString;
    Bild.Longitude        := fQuery.FieldByName('bi_Longitude').AsString;
    Stream := fQuery.CreateBlobStream(fQuery.FieldByName('bi_shortimage'), bmRead);
    Bild.setStream(Stream);
    FreeAndNil(Stream);
    fQuery.Next;
  end;
  PhotoOrga.BilderList.LadeAlben;
end;

procedure TDBBilderList.DeleteAll;
begin

end;


function TDBBilderList.Add: TDBBilder;
begin
  Result := TDBBilder.Create;
  fList.AddPointer(Result);
end;


end.
