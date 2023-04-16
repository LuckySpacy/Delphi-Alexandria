unit Thread.Artikel;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, FMX.Dialogs;

type
  TThreadArtikel = class
  private
    fOnArtikel: TNotifyEvent;
    procedure Ende(Sender: TObject);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Artikel(aEAN: String);
    property OnArtikel: TNotifyEvent read fOnArtikel write fOnArtikel;
  end;

implementation

{ TThreadArtikel }

uses
  Json.EAN, Json.Artikel, Json.Error, Objekt.Error, Objekt.JFPZ, Objekt.FPZ,
  Objekt.Artikel;


constructor TThreadArtikel.Create;
begin

end;

destructor TThreadArtikel.Destroy;
begin

  inherited;
end;

procedure TThreadArtikel.Ende(Sender: TObject);
begin
  if Assigned(fOnArtikel) then
    fOnArtikel(Self);
end;

procedure TThreadArtikel.Artikel(aEAN: String);
var
  t: TThread;
  s: string;
  JEAN: TJEAN;
  JArtikel: TJArtikel;
begin

  t := TThread.CreateAnonymousThread(
  procedure
  var
    Error: TError;
    ArId: Integer;
    Artikel: TArtikel;
  begin
    s := JFPZ.EAN(aEAN);
    if JFPZ.ErrorList.Count = 0 then
    begin
      try
        JArtikel := TJArtikel.FromJsonString(s);
        try
          if not TryStrToInt(JArtikel.id, ArId) then
            ArId := 0;
          if ArId > 0 then
          begin
            Artikel       := fpz.ArtikelList.Add;
            Artikel.id    := ArId;
            Artikel.Bez   := JArtikel.Bez;
            Artikel.Ean   := JArtikel.EAN;
            Artikel.Nr    := JArtikel.Nr;
            Artikel.Menge := 1;
          end
          else
          begin
            Error := JFPZ.ErrorList.Add;
            Error.Status := '-1';
            Error.Title  := 'Artikel nicht gefunden';
          end;
        finally
          FreeAndNil(JArtikel);
        end;
      except
        on E: Exception do
        begin
          Error := JFPZ.ErrorList.Add;
          Error.Title  := s;
          Error.Detail := E.Message;
        end;
      end;
    end;
  end
  );
  t.OnTerminate := Ende;
  t.Start;
end;


end.
