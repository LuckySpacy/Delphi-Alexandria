unit Thread.UploadAufgabe;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, Objekt.JBasCloud, Objekt.BasCloud,
  FMX.Dialogs, FMX.StdCtrls, Objekt.Aufgabe, Objekt.Zaehler;

type
  TThreadUploadAufgabe = class
  private
    fOnUploadEnde: TNotifyEvent;
    fUploaded: Boolean;
    procedure UploadEnde(Sender: TObject);
  public
    constructor Create;
    destructor Destroy; override;
    procedure DoUploadAufgabe(aAufgabe: TAufgabe);
    property OnUploadEnde: TNotifyEvent read fOnUploadEnde write fOnUploadEnde;
    property Uploaded: Boolean read fUploaded;
  end;

implementation

{ TThreadUploadAufgabe }

uses
  db.ToDo;

constructor TThreadUploadAufgabe.Create;
begin

end;

destructor TThreadUploadAufgabe.Destroy;
begin

  inherited;
end;

procedure TThreadUploadAufgabe.DoUploadAufgabe(aAufgabe: TAufgabe);
var
  t: TThread;
begin
  //aAufgabe.Upload;
  //UploadEnde(Self);
  //exit;
  t := TThread.CreateAnonymousThread(
  procedure
  var
    Aufgabe : TAufgabe;
    Zaehler : TZaehler;
    ms : TMemoryStream;
    DBToDo: TDBToDo;
  begin
    Aufgabe := TAufgabe.Create;
    Zaehler := TZaehler.Create;
    try
      Aufgabe.Id := aAufgabe.Id;
      Aufgabe.Zaehler := Zaehler;
      Zaehler.Id := aAufgabe.Zaehler.Id;
      Zaehler.Zaehlerstand.Id := aAufgabe.Zaehler.Zaehlerstand.Id;
      Zaehler.Zaehlerstand.Zaehlerstand := aAufgabe.Zaehler.Zaehlerstand.Zaehlerstand;
      zaehler.Zaehlerstand.Datum        := aAufgabe.Zaehler.Zaehlerstand.Datum;

      ms := TMemoryStream.Create;
      try
        aAufgabe.Zaehler.Zaehlerstand.Image.Bitmap.SaveToStream(ms);
        ms.Position := 0;
        if zaehler.Zaehlerstand.Image = nil then
          zaehler.Zaehlerstand.CreateImage;
        if ms.Size > BasCloud.ImageMinSize then
          zaehler.Zaehlerstand.Image.Bitmap.LoadFromStream(ms);
      finally
        FreeAndNil(ms);
      end;

      Aufgabe.Upload;
      if BasCloud.Error = '' then
      begin
        DBToDo := TDBToDo.Create;
        try
          DBToDo.Delete(Aufgabe.Id);
        finally
          FreeAndNil(DBToDo);
        end;
      end;

    finally
      FreeAndNil(Aufgabe);
      FreeAndNil(Zaehler);
    end;
  end
  );
  t.OnTerminate := UploadEnde;
  t.Start;
end;

procedure TThreadUploadAufgabe.UploadEnde(Sender: TObject);
begin
  if Assigned(fOnUploadEnde) then
    fOnUploadEnde(Self);
end;


end.
