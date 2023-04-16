unit Form.Zaehlerstand;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, Objekt.Aufgabe, Objekt.Zaehler,
  FMX.Objects, FMX.StdCtrls, FMX.Controls.Presentation, FMX.TabControl,
  FMX.Layouts, FMX.ImgList, DB.Zaehler, DB.Zaehlerstandbild, DB.ZaehlerUpdate,
  System.Actions, FMX.ActnList, FMX.StdActns, FMX.MediaLibrary.Actions, dw.ShareItems;

type
  Tfrm_Zaehlerstand = class(TForm)
    Rec_Toolbar_Background: TRectangle;
    gly_Return: TGlyph;
    gly_Save: TGlyph;
    lay_Anschrift: TLayout;
    rec_Anschrift: TRectangle;
    tab_Anschrift: TTabControl;
    tab_Zaehler: TTabItem;
    lbl_Z1: TLabel;
    lbl_Z2: TLabel;
    lbl_Z3: TLabel;
    tab_ItemAnschrift: TTabItem;
    lbl_Anschrift1: TLabel;
    lbl_Anschrift2: TLabel;
    lbl_Anschrift3: TLabel;
    lbl_Anschrift4: TLabel;
    lay_button: TLayout;
    btn_Zaehler: TCornerButton;
    btn_Anschrift: TCornerButton;
    lay_LetzterZaehlerstand: TLayout;
    rect_LetzterZaehlerstand: TRectangle;
    lbl_LetzterZaehlerstand: TLabel;
    Line2: TLine;
    lbl_Datum_LetzterZaehlerstand: TLabel;
    lbl_Datumwert: TLabel;
    lbl_Zaehler_LetzterZaehlerstand: TLabel;
    lbl_Zaehlerwert: TLabel;
    Image: TImage;
    procedure btn_ZaehlerClick(Sender: TObject);
    procedure btn_AnschriftClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    fOnAddZaehlerstandOhneAufgabe: TNotifyEvent;
    fOnAddZaehlerstand: TNotifyEvent;
    fZaehler: TZaehler;
    fAufgabe: TAufgabe;
    fDBZaehler: TDBZaehler;
    fDBZaehlerstandBild: TDBZaehlerstandBild;
    fDBZaehlerUpdate: TDBZaehlerUpdate;
    fOnZurueck: TNotifyEvent;
    fShareItems: TShareItems;
    fExcluded: TShareActivities;
    procedure setAufgabe(const Value: TAufgabe);
    procedure setZaehler(const Value: TZaehler);
    function LadeZaehlerFromDB(aZaehler: TZaehler): Boolean;
    procedure CornerButtonApplyStyleLookup(Sender: TObject);
    procedure ShowZaehlerstand;
    procedure btn_ReturnClick(Sender: TObject);
    procedure btn_SaveClick(Sender: TObject);
    procedure ShareItemsShareCompletedHandler(Sender: TObject; const AActivity: TShareActivity; const AError: string);
    function getSharedFilename: string;
    procedure Share;
    { Private-Deklarationen }
  public
    property OnZurueck: TNotifyEvent read fOnZurueck write fOnZurueck;
    property OnAddZaehlerstand: TNotifyEvent read fOnAddZaehlerstand write fOnAddZaehlerstand;
    property OnAddZaehlerstandOhneAufgabe: TNotifyEvent read fOnAddZaehlerstandOhneAufgabe write fOnAddZaehlerstandOhneAufgabe;
    property Aufgabe: TAufgabe read fAufgabe write setAufgabe;
    property Zaehler: TZaehler read fZaehler write setZaehler;
    procedure Aktual;
  end;

var
  frm_Zaehlerstand: Tfrm_Zaehlerstand;

implementation

{$R *.fmx}

{ Tfrm_Zaehlerstand }

uses
  Objekt.BasCloud, Json.Readings, Objekt.JBasCloud, Objekt.Zaehlerstand,
  FMX.DialogService, fmx.TextLayout, Datenmodul.Style, DateUtils, System.Permissions,
  System.IOUtils, DW.Consts.Android, DW.Permissions.Helpers;


procedure Tfrm_Zaehlerstand.FormCreate(Sender: TObject);
var
  i1: Integer;
begin //
  fAufgabe := nil;

  fDBZaehler          := TDBZaehler.Create;
  fDBZaehlerstandBild := TDBZaehlerstandBild.Create;
  fDBZaehlerUpdate    := TDBZaehlerUpdate.Create;



  for i1 := 0 to ComponentCount -1 do
  begin
    if Components[i1] is TLabel then
      TLabel(Components[i1]).TextSettings.FontColor := BasCloud.Style.LabelColor;
    if Components[i1] is TCornerButton then
    begin
      TCornerButton(Components[i1]).OnApplyStyleLookup := CornerButtonApplyStyleLookup;
      BasCloud.Style.setCornerButtonDefaultTextColor(TCornerButton(Components[i1]));
    end;
  end;

  gly_Return.HitTest := true;
  gly_return.OnClick := btn_ReturnClick;

  gly_Save.HitTest := true;
  gly_Save.OnClick := btn_SaveClick;

  fShareItems := TShareItems.Create;
  fShareItems.OnShareCompleted := ShareItemsShareCompletedHandler;


end;

procedure Tfrm_Zaehlerstand.FormDestroy(Sender: TObject);
begin
  FreeAndNil(fDBZaehler);
  FreeAndNil(fDBZaehlerstandBild);
  FreeAndNil(fDBZaehlerUpdate);
  FreeAndNil(fShareItems);
end;

function Tfrm_Zaehlerstand.getSharedFilename: string;
begin
  Result := TPath.Combine(TPath.GetDocumentsPath, 'BAScloud.csv');
end;

procedure Tfrm_Zaehlerstand.CornerButtonApplyStyleLookup(Sender: TObject);
begin //
  BasCloud.Style.setCornerButtonDefaultStyle(TCornerButton(Sender));
end;



procedure Tfrm_Zaehlerstand.Aktual;
begin
  if fAufgabe <> nil then
    setAufgabe(fAufgabe)
  else
    setZaehler(fZaehler);
end;


procedure Tfrm_Zaehlerstand.setAufgabe(const Value: TAufgabe);
begin
  fAufgabe := Value;
  if fAufgabe = nil then
    exit;
  setZaehler(fAufgabe.Zaehler);
end;

procedure Tfrm_Zaehlerstand.setZaehler(const Value: TZaehler);
var
  ZaehlerHoehe: Single;
  TabHoeheZaehler : Single;
  TabHoeheAnschrift : Single;
  TabHoehe : Single;
begin
  if Value = nil then
  begin
    fZaehler := nil;
    exit;
  end;

  //if (fZaehler <> nil) and (fZaehler.Id = Value.Id) then
  //  exit;

  fZaehler := Value;
  if fZaehler = nil then
    exit;

  log.d('Tfrm_Zaehlerstand.setZaehlerId --> ' + fZaehler.Id);
  if fZaehler.Zaehlerstand.EingelesenErfolgreich then
    log.d('Tfrm_Zaehlerstand.setZaehlerId --> EingelesenErfolgreich')
  else
    log.d('Tfrm_Zaehlerstand.setZaehlerId --> nicht EingelesenErfolgreich');


  if fZaehler.Zaehlerstand.Image = nil then
  begin
    log.d('Tfrm_Zaehlerstand.setZaehlerId --> Kein Bild vorhanden.');
    if LadeZaehlerFromDB(fZaehler) then
      fZaehler.Zaehlerstand.EingelesenErfolgreich := true;
    if fZaehler.Zaehlerstand.EingelesenErfolgreich then
      log.d('Tfrm_Zaehlerstand.setZaehlerId --> EingelesenErfolgreich')
    else
      log.d('Tfrm_Zaehlerstand.setZaehlerId --> nicht EingelesenErfolgreich');
  end;


  if (not fZaehler.Zaehlerstand.EingelesenErfolgreich) then
  begin
    log.d('Tfrm_Zaehlerstand.setZaehler --> Zähler wird aus Datenbank gelesen');
    LadeZaehlerFromDB(fZaehler);
    {
    if fDBZaehler.Load(fZaehler) then
    begin
      log.d('Tfrm_Zaehlerstand.setZaehler --> Zähler gefunden');
      if fDBZaehlerstandBild.Load(fZaehler) then
      begin
        log.d('Tfrm_Zaehlerstand.setZaehler --> Bild wurde gelesen');
        fZaehler.Zaehlerstand.EingelesenErfolgreich := true;
      end;
    end;
    }
  end;

  if (not fZaehler.Zaehlerstand.EingelesenErfolgreich) then
  begin
    if BasCloud.CanConnectToBAScloud then
    begin
      fZaehler.ReadZaehlerstand;
      if fZaehler.Zaehlerstand.EingelesenErfolgreich then
        fZaehler.Zaehlerstand.ReadingImage;
    end;
  end;

  tab_Anschrift.ActiveTab := tab_Zaehler;

  lbl_Z1.Text := fZaehler.Gebaude.Gebaudename;

  lbl_Z2.Text := fZaehler.Beschreibung; // Außentemperatur Wand
  lbl_Z3.Text := fZaehler.aksId; //FVS45_Temp
  //lbl_Z4.Text := BasCloud.Zaehlerstand.Device.state;
  lbl_LetzterZaehlerstand.Text := 'Letzter Zählerstand (' + fZaehler.Einheit + ')';;

  TabHoeheZaehler   := lbl_Z1.Height + lbl_Z2.Height + lbl_Z3.Height + 10;
  TabHoeheAnschrift := lbl_Anschrift1.Height + lbl_Anschrift1.Position.Y + lbl_Anschrift2.Height + lbl_Anschrift3.Height + 10;

  if TabHoeheZaehler > TabHoeheAnschrift then
    TabHoehe := TabHoeheZaehler
  else
    TabHoehe := TabHoeheAnschrift;

  tab_Anschrift.Height := TabHoehe;

  ZaehlerHoehe := lay_button.Height + TabHoehe + tab_Anschrift.Margins.Top;

  lay_Anschrift.Height := ZaehlerHoehe;

  ShowZaehlerstand;

end;


function Tfrm_Zaehlerstand.LadeZaehlerFromDB(aZaehler: TZaehler): Boolean;
begin
  Result := false;
  if fDBZaehlerUpdate.Load(aZaehler) then
  begin
    Result := true;
    exit;
  end;

  if not fDBZaehler.Load(aZaehler) then
    exit;


  Result := fDBZaehlerstandBild.Load(fZaehler);

end;


procedure Tfrm_Zaehlerstand.ShareItemsShareCompletedHandler(Sender: TObject;
  const AActivity: TShareActivity; const AError: string);
begin

end;

procedure Tfrm_Zaehlerstand.ShowZaehlerstand;
{$IFDEF WIN32}
var
  List: TStringList;
{$ENDIF WIN32}
begin
  gly_Save.HitTest := true;
  gly_Save.Enabled := true;

  if fZaehler.Zaehlerstand = nil then
  begin
    TDialogService.ShowMessage('Zählerstand ist nil');
    exit;
  end;

  if fZaehler.Zaehlerstand.EingelesenErfolgreich then
  begin
    log.d('EingelesenErfolgreich');
    lbl_Zaehlerwert.Text := FloatToStr(fZaehler.Zaehlerstand.Zaehlerstand);
    //lbl_Datumwert.Text   := FormatDateTime('dd.mm.yyyy hh:nn:ss', fZaehler.Zaehlerstand.Datum);
    lbl_Datumwert.Text   := FormatDateTime('dd.mm.yyyy hh:nn:ss', TTimeZone.Local.ToLocalTime(fZaehler.Zaehlerstand.Datum));
    lbl_Datumwert.Visible := fZaehler.Zaehlerstand.Datum > 0;
  end
  else
  begin
    lbl_Zaehlerwert.Text := 'Keine Daten';
    lbl_Datumwert.Visible := false;
  end;


  lbl_Anschrift1.Text := fZaehler.Gebaude.Gebaudename;
  lbl_Anschrift2.Text := fZaehler.Gebaude.Strasse;
  lbl_Anschrift3.Text := Trim(fZaehler.Gebaude.Plz + ' ' + fZaehler.Gebaude.Ort);
  lbl_Anschrift4.Text := '';

  if fZaehler.Zaehlerstand.Image <> nil then
    Image.Bitmap.Assign(fZaehler.Zaehlerstand.Image.Bitmap)
  else
    Image.Bitmap.Clear(TalphaColors.White);

    {$IFDEF WIN32}
    List := TStringList.Create;
    List.Text := fZaehler.Id;
    List.SaveToFile('c:\temp\BAScloud\ZaehlerNichtEingelesen.txt');
    FreeAndNil(List);
    {$ENDIF WIN32}


  if (not fZaehler.Zaehlerstand.Eingelesen) and (not fZaehler.Zaehlerstand.EingelesenErfolgreich) then
  begin
    {$IFDEF WIN32}
    List := TStringList.Create;
    List.Text := fZaehler.Id;
    List.SaveToFile('c:\temp\BAScloud\ZaehlerNichtEingelesen.txt');
    FreeAndNil(List);
    {$ENDIF WIN32}

    log.d('(not fZaehler.Zaehlerstand.Eingelesen) and (not fZaehler.Zaehlerstand.EingelesenErfolgreich)');
    gly_Save.HitTest := false;
    gly_Save.Enabled := false;
  end;

end;


procedure Tfrm_Zaehlerstand.btn_ReturnClick(Sender: TObject);
begin
  if Assigned(fOnZurueck) then
    fOnZurueck(Self);
end;


procedure Tfrm_Zaehlerstand.btn_SaveClick(Sender: TObject);
begin
  if (fAufgabe <> nil) and (Assigned(fOnAddZaehlerstand)) then
  begin
    fOnAddZaehlerstand(fAufgabe);
    exit;
  end;
  if (fZaehler <> nil) and (Assigned(fOnAddZaehlerstandOhneAufgabe)) then
  begin
    fOnAddZaehlerstandOhneAufgabe(fZaehler);
    exit;
  end;
end;

procedure Tfrm_Zaehlerstand.btn_ZaehlerClick(Sender: TObject);
begin
  tab_Anschrift.ActiveTab := tab_Zaehler;
end;


procedure Tfrm_Zaehlerstand.Button1Click(Sender: TObject);
begin
  //SaveToFile;
  //exit;
  PermissionsService.RequestPermissions([cPermissionReadExternalStorage, cPermissionWriteExternalStorage],
    procedure(const APermissions: TPermissionArray; const AGrantResults: TPermissionStatusArray)
    begin
      if AGrantResults.AreAllGranted then
        Share;
    end
  );
end;

procedure Tfrm_Zaehlerstand.Share;
begin
  if not FileExists(getSharedFilename) then
    ShowMessage('Datei existiert nicht');
  FShareItems.AddFile(getSharedFilename);
  //FShareItems.Share(Button1, FExcluded);
end;



procedure Tfrm_Zaehlerstand.btn_AnschriftClick(Sender: TObject);
begin
  tab_Anschrift.ActiveTab := tab_ItemAnschrift;
end;





end.
