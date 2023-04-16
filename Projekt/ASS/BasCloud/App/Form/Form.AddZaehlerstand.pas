unit Form.AddZaehlerstand;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, Objekt.Aufgabe,
  Objekt.Zaehler, FMX.StdCtrls, FMX.ImgList, FMX.Objects, FMX.Edit,
  FMX.Controls.Presentation, FMX.Layouts, ASSPhoto, Objekt.Datum, db.Queue;

type
   TProgressInfoEvent = procedure(aInfo: string; aIndex, aCount: Integer) of object;
   Tfrm_AddZaehlerstand = class(TForm)
    Rec_Toolbar_Background: TRectangle;
    gly_Return: TGlyph;
    gly_Save: TGlyph;
    gly_Photo: TGlyph;
    ani_waitUpload_Toolbar: TAniIndicator;
    Layout1: TLayout;
    rec_AlterZaehlerstand: TRectangle;
    lbl_LetzterZaehlerstand: TLabel;
    rec_NeuerZaehlerstand: TRectangle;
    lbl_NeuerZaehlerstand: TLabel;
    Line3: TLine;
    Label3: TLabel;
    edt_NeuerZaehlerstand: TEdit;
    CameraImage: TImage;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    fPhotoBitmap: TBitmap;
    fASSPhoto: TASSPhoto;
    fNewPhoto: Boolean;
    fOnDoUpload: TNotifyEvent;
    fOnNewAufgabe: TNotifyEvent;
    fZaehler: TZaehler;
    fAufgabe: TAufgabe;
    fOnZurueck: TNotifyEvent;
    fDatum: TDatum;
    fOnProgressInfo: TProgressInfoEvent;
    fDBQueue: TDBQueue;
    procedure SaveZaehlerstand;
    procedure btn_SaveClick(Sender: TObject);
    procedure btn_ReturnClick(Sender: TObject);
    procedure btn_PhotoClick(Sender: TObject);
    procedure AfterFinishTaken(aBitmap: TBitmap);
    procedure setSaveButton(aEnabled: Boolean);
    procedure setReturnButton(aEnabled: Boolean);
    procedure setPhotoButton(aEnabled: Boolean);
    procedure setAllButton(aEnabled: Boolean);
    procedure setAufgabe(const Value: TAufgabe);
    procedure setZaehler(const Value: TZaehler);
  public
    property OnZurueck: TNotifyEvent read fOnZurueck write fOnZurueck;
    property Aufgabe: TAufgabe read fAufgabe write setAufgabe;
    property Zaehler: TZaehler read fZaehler write setZaehler;
    procedure MakePhoto;
    procedure FormIsActivate;
    property OnDoUpload: TNotifyEvent read fOnDoUpload write fOnDoUpload;
    property OnNewAufgabe: TNotifyEvent read fOnNewAufgabe write fOnNewAufgabe;
    property OnProgressInfo: TProgressInfoEvent read fOnProgressInfo write fOnProgressInfo;
  end;

var
  frm_AddZaehlerstand: Tfrm_AddZaehlerstand;

implementation

{$R *.fmx}

{ Tfrm_AddZaehlerstand }

uses
  FMX.DialogService, DB.ZaehlerUpdate, Objekt.BasCloud, Datenmodul.Style;


procedure Tfrm_AddZaehlerstand.FormCreate(Sender: TObject);
begin //
  fASSPhoto := TASSPhoto.Create;
  fASSPhoto.CameraImage := CameraImage;
  fASSPhoto.OnAfterFinishTaken := AfterFinishTaken;
  fPhotoBitmap := nil;
  fNewPhoto := false;
  {$IFDEF Android}
    //btn_Photo.StyleLookup := 'bascloud_cameratoolbutton';
  {$ENDIF Android}

  gly_Return.HitTest := true;
  gly_return.OnClick := btn_ReturnClick;

  gly_Save.HitTest := true;
  gly_Save.OnClick := btn_SaveClick;

  gly_Photo.HitTest := true;
  gly_Photo.OnClick := btn_PhotoClick;

  rec_AlterZaehlerstand.Align := TAlignLayout.None;
  rec_NeuerZaehlerstand.Align := TAlignLayout.None;

  fDatum := TDatum.Create;

  fDBQueue := TDBQueue.Create;


end;

procedure Tfrm_AddZaehlerstand.FormDestroy(Sender: TObject);
begin
  if fPhotoBitmap <> nil then
    FreeAndNil(fPhotoBitmap);
  FreeAndNil(fDatum);
  FreeAndNil(fASSPhoto);
  FreeAndNil(fDBQueue);
end;


procedure Tfrm_AddZaehlerstand.FormShow(Sender: TObject);
begin
  edt_NeuerZaehlerstand.SetFocus;
end;

procedure Tfrm_AddZaehlerstand.FormActivate(Sender: TObject);
begin
  edt_NeuerZaehlerstand.Enabled := true;
  setAllButton(true);
  rec_AlterZaehlerstand.Align := TAlignLayout.Top;
  rec_NeuerZaehlerstand.Align := TAlignLayout.Top;
  edt_NeuerZaehlerstand.SetFocus;
end;



procedure Tfrm_AddZaehlerstand.FormIsActivate;
begin
 edt_NeuerZaehlerstand.Text := '';
end;



procedure Tfrm_AddZaehlerstand.MakePhoto;
begin
  fASSPhoto.MakePhoto;
end;

procedure Tfrm_AddZaehlerstand.setAufgabe(const Value: TAufgabe);
begin
  log.d('Tfrm_AddZaehlerstand.setAufgabe');
  if Value = nil then
    log.d('Tfrm_AddZaehlerstand.setAufgabe --> Aufgabe ist nil')
  else
    log.d('Tfrm_AddZaehlerstand.setAufgabe --> ' + Value.Id);

  fAufgabe := Value;
  edt_NeuerZaehlerstand.SetFocus;
  if fAufgabe <> nil then
    setZaehler(fAufgabe.Zaehler);
end;

procedure Tfrm_AddZaehlerstand.setZaehler(const Value: TZaehler);
begin
  fZaehler := Value;
  if (fZaehler.Zaehlerstand <> nil) and (fZaehler.Zaehlerstand.Zaehlerstand > 0) then
    lbl_LetzterZaehlerstand.Text := 'Letzter Zählerstand: ' + FloatToStr(fZaehler.Zaehlerstand.Zaehlerstand);
end;


procedure Tfrm_AddZaehlerstand.setAllButton(aEnabled: Boolean);
begin
  setReturnButton(aEnabled);
  setPhotoButton(aEnabled);
  setSaveButton(aEnabled);
end;

procedure Tfrm_AddZaehlerstand.setPhotoButton(aEnabled: Boolean);
begin
  gly_Photo.HitTest := aEnabled;
  gly_Photo.Enabled := aEnabled;
end;

procedure Tfrm_AddZaehlerstand.setReturnButton(aEnabled: Boolean);
begin
  gly_Return.HitTest := aEnabled;
  gly_Return.Enabled := aEnabled;
end;

procedure Tfrm_AddZaehlerstand.setSaveButton(aEnabled: Boolean);
begin
  gly_Save.HitTest := aEnabled;
  gly_Save.Enabled := aEnabled;
end;


procedure Tfrm_AddZaehlerstand.AfterFinishTaken(aBitmap: TBitmap);
var
  ms: TMemoryStream;
begin
  if fPhotoBitmap <> nil then
    FreeAndNil(fPhotoBitmap);
  ms := TMemoryStream.Create;
  try
    try
      fPhotoBitmap := TBitmap.Create;
      aBitmap.SaveToStream(ms);
      ms.Position := 0;
      fPhotoBitmap.LoadFromStream(ms);
      fNewPhoto := true;
      //edt_NeuerZaehlerstand.SetFocus;
    finally
      FreeAndNil(ms);
    end;
  except
    on E: Exception do
    begin
      TDialogService.ShowMessage(E.Message);
      exit;
    end;
  end;
end;


procedure Tfrm_AddZaehlerstand.btn_PhotoClick(Sender: TObject);
begin
  MakePhoto;
end;

procedure Tfrm_AddZaehlerstand.btn_ReturnClick(Sender: TObject);
begin
  if Assigned(fOnZurueck) then
    fOnZurueck(Self);
end;

procedure Tfrm_AddZaehlerstand.btn_SaveClick(Sender: TObject);
var
  Zaehlerstand: Currency;
  s: string;
begin
  if not TryStrToCurr(edt_NeuerZaehlerstand.Text, Zaehlerstand) then
  begin
    TDialogService.ShowMessage('Zählerstand ist nicht numerisch');
    exit;
  end;

  {$IFDEF IOS}
    if not fNewPhoto then
    begin
      TDialogService.ShowMessage('Bitte vorher ein Bild vom Zählerstand hinzufügen.');
      exit;
    end;
  {$ENDIF IOS}

  {$IFDEF ANDROID}
    if not fNewPhoto then
    begin
      TDialogService.ShowMessage('Bitte vorher ein Bild vom Zählerstand hinzufügen.');
      exit;
    end;
  {$ENDIF ANDROID}

  if fZaehler.Zaehlerstand.Zaehlerstand > Zaehlerstand then
  begin
    s := 'Letzter Zählerstand war größer "' +
         FloatToStr(fZaehler.Zaehlerstand.Zaehlerstand) + '"' + sLineBreak +
         'Ist die Eingabe ' + '"' + FloatToStr(Zaehlerstand) +'" korrekt?';

    TDialogService.MessageDialog(s, TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0,
                                 procedure(const AResult: TModalResult)
                                 begin
                                   if AResult = mrYes then
                                     SaveZaehlerstand;
                                 end);

    exit;
  end;

  SaveZaehlerstand;

end;

procedure Tfrm_AddZaehlerstand.SaveZaehlerstand;
var
  ms: TMemoryStream;
  Zaehlerstand: Currency;
begin
  TryStrToCurr(edt_NeuerZaehlerstand.Text, Zaehlerstand);

  {$IFDEF WIN32}
    if FileExists('c:\temp\bild3.jpg') then
    begin
      ms := TMemoryStream.Create;
      ms.LoadFromFile('c:\temp\bild3.jpg');
      ms.Position := 0;
      if fPhotoBitmap <> nil then
        FreeAndNil(fPhotoBitmap);
      fPhotoBitmap := TBitmap.Create;
      fPhotoBitmap.LoadFromStream(ms);
      FreeAndNil(ms);
    end;
  {$ENDIF WIN32}


  fZaehler.Zaehlerstand.Zaehlerstand := Zaehlerstand;
  //fZaehler.Zaehlerstand.Datum := now;
  fZaehler.Zaehlerstand.Datum := fDatum.getUTCDateTime;


  try
    ms := TMemoryStream.Create;
    try
      fPhotoBitmap.SaveToStream(ms);
      ms.Position := 0;
      fZaehler.Zaehlerstand.LoadBitmapFromStream(ms);
    finally
      FreeAndNil(ms);
    end;
  except
    on E: Exception do
    begin
      TDialogService.ShowMessage(E.Message);
      exit;
    end;
  end;


  if fAufgabe <> nil then
  begin
    if fAufgabe.DarfAufgabeErledigtWerden then
    begin
      fAufgabe.InsertInZaehlerUpdate;
      fAufgabe.WaitForUpload := true;
      BasCloud.AufgabenListViewAktualisieren := true;
    end
    else
    begin
      fZaehler.InsertInZaehlerUpdate('');
      fAufgabe := BasCloud.AufgabeList.Add_AdHoc(fZaehler.getLastZuId);
      Aufgabe.ZaehlerId := fZaehler.Id;
      Aufgabe.Datum  := trunc(now);
      Aufgabe.Notiz  := 'Ad hoc';
      Aufgabe.Status := 'Ad hoc';
      Aufgabe.Anzeigen := true;
      Aufgabe.AdHoc := true;
      Aufgabe.Zaehler := fZaehler;
      Aufgabe.WaitForUpload := true;
      BasCloud.AufgabenListViewAktualisieren := true;
    end;
  end
  else
  begin
    log.d('Tfrm_AddZaehlerstand.SaveZaehlerstand -> Aufgabe ist nil');
    fZaehler.InsertInZaehlerUpdate('');
    fOnProgressInfo('Tfrm_AddZaehlerstand.SaveZaehlerstand (Ad hoc)', 0,0);
    fAufgabe := BasCloud.AufgabeList.Add_AdHoc(fZaehler.getLastZuId);
    Aufgabe.ZaehlerId := fZaehler.Id;
    Aufgabe.Datum  := trunc(now);
    Aufgabe.Notiz  := 'Ad hoc';
    Aufgabe.Status := 'Ad hoc';
    Aufgabe.Anzeigen := true;
    Aufgabe.AdHoc := true;
    Aufgabe.WaitForUpload := true;
    Aufgabe.Zaehler := fZaehler;
    BasCloud.AufgabenListViewAktualisieren := true;
    if Assigned(fOnNewAufgabe) then
      fOnNewAufgabe(Aufgabe);
  end;

  fDBQueue.InsertProcess_UploadZaehlerstand;
  if Assigned(fOnZurueck) then
    fOnZurueck(Self);

end;


end.
