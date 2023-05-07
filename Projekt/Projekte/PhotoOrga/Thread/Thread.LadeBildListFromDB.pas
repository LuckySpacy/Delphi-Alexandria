unit Thread.LadeBildListFromDB;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, DB.Basis, FMX.Graphics;


type
  TThreadLadeBildListFromDB = class
  private
    fOnEnde: TNotifyEvent;
    fStop: Boolean;
    procedure ReadDB;
    procedure Ende(Sender: TObject);
  public
    constructor Create;
    destructor Destroy; override;
    property OnEnde: TNotifyEvent read fOnEnde write fOnEnde;
    procedure Start;
    property Stop: Boolean read fStop write fStop;
  end;

implementation

{ TThreadLadeBildListFromDB }

uses
  Datenmodul.db, Objekt.PhotoOrga, Objekt.BildList, Objekt.Bild, Objekt.Alben, Objekt.Album;

constructor TThreadLadeBildListFromDB.Create;
begin

end;

destructor TThreadLadeBildListFromDB.Destroy;
begin

  inherited;
end;


procedure TThreadLadeBildListFromDB.Ende(Sender: TObject);
begin
  if Assigned(fOnEnde) then
    fOnEnde(nil);
end;

procedure TThreadLadeBildListFromDB.Start;
var
  t: TThread;
begin
  fStop := false;
  t := TThread.CreateAnonymousThread(
  procedure
  begin
    ReadDB;
  end
  );
  t.OnTerminate := Ende;
  t.Start;
end;



procedure TThreadLadeBildListFromDB.ReadDB;
var
  BildList: TBildList;
  qry: TFDQuery;
  Bild: TBild;
  Stream: TStream;
  Album: TAlbum;
begin
  qry := dm_db.FDQuery;
  qry.sql.text := ' select * from bild';
  BildList := PhotoOrga.BildList;
  qry.Open;
  while not qry.Eof do
  begin
    if fStop then
      exit;
    Bild := BildList.Add;
    Bild.Id   := qry.FieldByName('id').AsString;
    Bild.Pfad := qry.FieldByName('Pfad').AsString;
    Bild.Bildname := qry.FieldByName('Bildname').AsString;
    //Bild.LastWriteTimeUtc := qry.FieldByName('LastWriteTimeUtc').AsString;
    Bild.Orientation := qry.FieldByName('Oriantation').AsString;
    Bild.Latitude    := qry.FieldByName('Latitude').AsString;
    Bild.Longitude   := qry.FieldByName('Longitude').AsString;

    Album := PhotoOrga.Alben.getAlbumByName(Bild.Pfad);
    if Album = nil then
    begin
      Album := PhotoOrga.Alben.Add;
      Album.Albumname := Bild.Pfad;
      Album.Pfad      := Bild.Pfad;
    end;
    Album.AlbumBilder.Add(Bild);

    Stream := qry.CreateBlobStream(Qry.FieldByName('thumb'), bmRead);
    try
      Bild.LoadThumbFromStream(Stream);
    finally
      FreeAndNil(Stream);
    end;

    qry.Next;
  end;
end;


end.
