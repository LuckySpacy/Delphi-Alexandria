unit Form.Aufgabe;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.Edit, FMX.ImgList, FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.ListView, FMX.Layouts, Objekt.Aufgabe, DB.ZaehlerUpdateList, DB.Queue,
  FMX.Ani, dw.ShareItems;

type
  Tfrm_Aufgabe = class(TForm)
    Lay_Client: TLayout;
    lv: TListView;
    Img_Upload: TImage;
    ani_ZaehlerUpload: TAniIndicator;
    Img_Clipboard: TImage;
    Img_Clipboard_Ok: TImage;
    Ani_Wait: TAniIndicator;
    img_InUpload: TImage;
    lbl_Status: TLabel;
    Rec_Toolbar_Background: TRectangle;
    ani_waitUpload_Toolbar: TAniIndicator;
    gly_Return: TGlyph;
    gly_Refresh: TGlyph;
    gly_Upload: TGlyph;
    gly_Scanner: TGlyph;
    gly_SearchFilter: TGlyph;
    edt_Suche: TEdit;
    img_wait: TImage;
    WaitAnimation: TFloatAnimation;
    gly_Share: TGlyph;
    procedure FormCreate(Sender: TObject);
    procedure lvItemClickEx(const Sender: TObject; ItemIndex: Integer;
      const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
    procedure lvUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure FormDestroy(Sender: TObject);
    procedure edt_SucheExit(Sender: TObject);
    procedure edt_SucheKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure img_waitClick(Sender: TObject);
    procedure WaitAnimationFinish(Sender: TObject);
    procedure lvPullRefresh(Sender: TObject);
  private
    fOnRefreshAufgabenliste: TNotifyEvent;
    fOnScannerClick: TNotifyEvent;
    fOnAufgabeClick: TNotifyEvent;
    fOnZurueck: TNotifyEvent;
    fLastViewItem: TListViewItem;
    fDBZaehlerUpdateList: TDBZaehlerUpdateList;
    fDBQueue: TDBQueue;
    fWaitEnabled: Boolean;
    fShareItems: TShareItems;
    fExcluded: TShareActivities;
    procedure btn_ReturnClick(Sender: TObject);
    procedure btn_ScannerClick(Sender: TObject);
    procedure btn_SearchFilterClick(Sender: TObject);
    procedure btn_RefreshClick(Sender: TObject);
    procedure btn_ShareClick(Sender: TObject);
    procedure UpdateListView;
    procedure ShareAufgabenliste;
    procedure SetButtonShare(aValue: Boolean);
    function GetTextHeight(const D: TListItemText; const Width: single; const Text: string): Integer;
    procedure ShareItemsShareCompletedHandler(Sender: TObject; const AActivity: TShareActivity; const AError: string);
    function getSharedFilename: string;
    { Private-Deklarationen }
  public
    property OnZurueck: TNotifyEvent read fOnZurueck write fOnZurueck;
    property OnRefreshAufgabenliste: TNotifyEvent read fOnRefreshAufgabenliste write fOnRefreshAufgabenliste;
    property OnAufgabeClick: TNotifyEvent read fOnAufgabeClick write fOnAufgabeClick;
    property OnScannerClick: TNotifyEvent read fOnScannerClick write fOnScannerClick;
    //procedure LadeListe;
    procedure FormIsActivate;
    procedure UploadZaehlerstaendeEndUpload(Sender: TObject);
    procedure UploadZaehlerstaendeBegin(Sender: TObject);
    procedure UploadAufgaben;
    procedure DoUpdateListView;
    procedure EndRefresh;
  end;

var
  frm_Aufgabe: Tfrm_Aufgabe;

implementation

{$R *.fmx}

{ Tfrm_Aufgabe }

uses
  FMX.DialogService, Objekt.BasCloud, Objekt.Gebaude, Datenmodul.Style, fmx.TextLayout,
  Objekt.Zaehler, System.DateUtils, System.Permissions, System.IOUtils
 // {$IF DEFINED(IOS) OR DEFINED(ANDROID)}
  ,DW.Consts.Android, DW.Permissions.Helpers
//  {$ENDIF}
  ;

procedure Tfrm_Aufgabe.WaitAnimationFinish(Sender: TObject);
begin
  WaitAnimation.Enabled := false;
  if fWaitEnabled then
    WaitAnimation.Enabled := true;
end;

procedure Tfrm_Aufgabe.FormCreate(Sender: TObject);
var
  i1: Integer;
begin
  for i1 := 0 to ComponentCount -1 do
  begin
    if Components[i1] is TLabel then
      TLabel(Components[i1]).TextSettings.FontColor := BasCloud.Style.LabelColor;
  end;


  // Exclude all but the following - Note: applicable to iOS ONLY - uncomment the next line to test
  // FExcluded := TShareItems.AllShareActivities - [TShareActivity.Message, TShareActivity.Mail, TShareActivity.CopyToPasteboard];
  fShareItems := TShareItems.Create;
  fShareItems.OnShareCompleted := ShareItemsShareCompletedHandler;


  gly_Return.HitTest := true;
  gly_return.OnClick := btn_ReturnClick;

  gly_Return.HitTest := true;
  gly_return.OnClick := btn_ReturnClick;

  gly_Scanner.HitTest := true;
  gly_Scanner.OnClick := btn_ScannerClick;

  gly_Refresh.HitTest := true;
  gly_Refresh.OnClick := btn_RefreshClick;

  gly_SearchFilter.HitTest := true;
  gly_SearchFilter.OnClick := btn_SearchFilterClick;

  gly_Share.HitTest := true;
  gly_Share.OnClick := btn_ShareClick;


  edt_Suche.Visible := false;

  fLastViewItem := nil;

  lbl_Status.Visible := false;

  fDBZaehlerUpdateList := TDBZaehlerUpdateList.Create;

  gly_Upload.Visible := false;
  gly_Upload.HitTest := true;
  gly_Upload.Images := nil;

  img_wait.Position.Y := gly_Upload.Position.Y + 3;
  img_wait.Position.X := gly_Upload.Position.X;
  img_wait.Visible := false;
  fWaitEnabled := false;



  //fGifPlayer := TGifPlayer.Create(Self);
  //FGifPlayer.Image := img_wait;


{$IFDEF MSWINDOWS}
  //FGifPlayer.LoadFromFile('c:\Entwicklung\Delphi\Alexandria\Projekte\Mobile\BasCloud\App\Bilder\Gif\Rolling-1s-55px.gif');
{$ENDIF}

  //FGifPlayer.Play;

  fDBQueue := TDBQueue.Create;

end;

procedure Tfrm_Aufgabe.FormDestroy(Sender: TObject);
begin
  FreeAndNil(fDBZaehlerUpdateList);
  FreeAndNil(fDBQueue);
end;

procedure Tfrm_Aufgabe.DoUpdateListView;
begin
  BasCloud.AufgabeList.ListViewSortStr;
  UpdateListView;
end;



procedure Tfrm_Aufgabe.edt_SucheExit(Sender: TObject);
begin
  edt_Suche.Visible := false;
end;

procedure Tfrm_Aufgabe.edt_SucheKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  UpdateListView;
end;

procedure Tfrm_Aufgabe.FormIsActivate;
begin
  try
    log.d('Tfrm_Aufgabe.FormIsActivate (Start)');
    if BasCloud.AufgabenListViewAktualisieren then
    begin
      DoUpdateListView;
      BasCloud.AufgabenListViewAktualisieren := false;
    end;
    log.d('Tfrm_Aufgabe.FormIsActivate (Ende)');
  except
    on E: Exception do
    begin
      log.d('Tfrm_Aufgabe.FormIsActivate Error: ' + e.Message);
    end;
  end;
end;

{
procedure Tfrm_Aufgabe.LadeListe;
var
  i1: Integer;
  Aufgabe: TAufgabe;
begin
  BasCloud.AufgabeList.ListViewSortStr;
  fDBZaehlerUpdateList.ReadAll;

  for i1 := 0 to fDBZaehlerUpdateList.Count -1 do
  begin
    Aufgabe := BasCloud.AufgabeList.getById(fDBZaehlerUpdateList.Item[i1].ToDoId);
    if Aufgabe = nil then
    begin
      Aufgabe := BasCloud.AufgabeList.getByZuId(fDBZaehlerUpdateList.Item[i1].Id);
      if Aufgabe = nil then
      begin
        log.d('Aufgabe ist nil');
        continue;
      end;
    end;
    Aufgabe.WaitForUpload := true;
    log.d('Aufgabe.WaitForUpload = true');
    Aufgabe.Zaehler.Zaehlerstand.Zaehlerstand := StrToFloat(fDBZaehlerUpdateList.Item[i1].Stand);
    Aufgabe.Zaehler.Zaehlerstand.Datum        := fDBZaehlerUpdateList.Item[i1].Datum;
    Aufgabe.Zaehler.Zaehlerstand.LoadBitmapFromStream(fDBZaehlerUpdateList.Item[i1].getBildStream);
  end;

  UpdateListView;
end;
}


procedure Tfrm_Aufgabe.UploadAufgaben;
begin

end;

procedure Tfrm_Aufgabe.UploadZaehlerstaendeBegin(Sender: TObject);
begin

end;

procedure Tfrm_Aufgabe.UploadZaehlerstaendeEndUpload(Sender: TObject);
begin

end;


//*****************************************************************************
//** ListView
//*****************************************************************************
procedure Tfrm_Aufgabe.UpdateListView;

  procedure setItemDataColor(aItem: TListViewItem; aData: string; aColor: TAlphaColor);
  var
    lt: TListItemText;
  begin
    lt := TListItemText(aItem.Objects.FindDrawable(aData));
    if lt = nil then
      exit;
    lt.TextColor := aColor;
  end;

var
  i1: Integer;
  Aufgabe: TAufgabe;
  Gebaude: TGebaude;
  Item: TListViewItem;
  SuchText: string;
  SuchString: string;
  iPos: Integer;
  Adresse: string;
begin
  lv.BeginUpdate;
  try
    try
      SuchText := LowerCase(Trim(edt_Suche.Text));

      if SuchText = '' then
        gly_SearchFilter.ImageIndex := 11
      else
        gly_SearchFilter.ImageIndex := 12;

      lv.Items.Clear;
      for i1 := 0 to BasCloud.AufgabeList.Count -1 do
      begin
        Aufgabe := BasCloud.AufgabeList.Item[i1];

        if not Aufgabe.Anzeigen then
          continue;

        if Aufgabe.Zaehler = nil then
          continue;
        if Aufgabe.Zaehler.Gebaude = nil then
          continue;

        Gebaude := Aufgabe.Zaehler.Gebaude;
        if (SuchText > '') then
        begin
          SuchString := LowerCase(Aufgabe.Zaehler.Beschreibung) + LowerCase(Aufgabe.Zaehler.aksId) +
                        LowerCase(Gebaude.Strasse) + LowerCase(Gebaude.Plz) + LowerCase( Gebaude.Ort);
          iPos := Pos(SuchText, SuchString);
          if  (iPos <= 0) then
            continue;
        end;


        Item := lv.Items.Add;
        Adresse := Trim(Gebaude.Strasse);
        if (Adresse > '') and ((Trim(Gebaude.Plz)> '') or (Trim(Gebaude.Ort) > '')) then
          Adresse := Adresse + ', ';
        Adresse := Adresse + Trim(Trim(Gebaude.Plz) + ' ' + Trim(Gebaude.Ort));

        if Adresse = '' then
          Adresse := Gebaude.Gebaudename;

        Item.Data['Adresse'] := Adresse;
        Item.Data['Zaehler'] := Aufgabe.Zaehler.Beschreibung;
        Item.Data['Aks']     := Aufgabe.Zaehler.aksId;
        //Item.Data['Datum']   := FormatDateTime('dd.mm.yyyy hh:nn', Aufgabe.Datum);
        Item.Data['Datum']   := FormatDateTime('dd.mm.yyyy', Aufgabe.Datum);

        Item.Data['AdHoc']   := '';
        if Aufgabe.AdHoc then
        begin
          Item.Data['AdHoc']   := 'Ad hoc ';
          setItemDataColor(Item, 'AdHoc', TAlphaColors.Red);
        end;


        Item.TagObject := Aufgabe;

        if trunc(Aufgabe.Datum) <= trunc(now) then
          setItemDataColor(Item, 'Datum', TAlphaColors.Red)


      end;

      for i1 := 0 to lv.Items.Count -1 do
      begin
        if lv.items[i1].TagObject = nil then
          continue;
        lvUpdateObjects(lv, lv.items[i1]);
      end;
    except
      on E: Exception do
      begin
        log.d('Error in Tfrm_Aufgabe.UpdateListView: ' + e.Message);
      end;
    end;

  finally
    lv.EndUpdate;
  end;
end;


procedure Tfrm_Aufgabe.lvItemClickEx(const Sender: TObject; ItemIndex: Integer;
  const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
begin
  try
    fLastViewItem := lv.Items[ItemIndex];
    if Assigned(fOnAufgabeClick) then
      fOnAufgabeClick(TAufgabe(lv.Items[ItemIndex].TagObject));
  except
    on E: Exception do
    begin
      log.d('Error in Tfrm_Aufgabe.lvItemClickEx: ' + e.Message);
    end;
  end;
end;

procedure Tfrm_Aufgabe.lvPullRefresh(Sender: TObject);
begin
  //TDialogService.ShowMessage('lvPullRefresh');
end;

procedure Tfrm_Aufgabe.lvUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
var
  ListItemImage: TListItemImage;
  ItemText: TListItemText;
  DynItemText: TListItemText;
  Text: string;
  Aufgabe: TAufgabe;
  AvailableWidth: Single;
  TextHeight: Integer;
  DynItemHeight: Integer;
begin
  try
    if AItem = nil then
      exit;
    if Sender = nil then
      exit;
    Aufgabe := nil;
    if AItem.TagObject <> nil then
      Aufgabe := TAufgabe(AItem.TagObject);

    AvailableWidth := TListView(Sender).Width - TListView(Sender).ItemSpaces.Left - TListView(Sender).ItemSpaces.Right;

    if (AItem.Objects.FindDrawable('Img_Upload') <> nil) then
    begin
      ListItemImage := TListItemImage(AItem.Objects.FindDrawable('Img_Upload'));
      ListItemImage.Bitmap := Img_ClipBoard.Bitmap;
      ListItemImage.TagString := '';

      if (Aufgabe <> nil) and (Aufgabe.WaitForUpload) and (ListItemImage <> nil) then
      begin
        ListItemImage.Bitmap := Img_Upload.Bitmap;
        ListItemImage.TagString := 'Upload';
      end;

      if (Aufgabe <> nil) and (Aufgabe.InUpload) and (ListItemImage <> nil) then
      begin
        ListItemImage.Bitmap := img_InUpload.Bitmap;
        ListItemImage.TagString := '';
      end;

      if (Aufgabe <> nil) and (Aufgabe.Uploaded) and (ListItemImage <> nil) then
      begin
        ListItemImage.Bitmap := Img_Clipboard_Ok.Bitmap;
        ListItemImage.TagString := '';
      end;

    end;

    DynItemText := TListItemText(aItem.View.FindDrawable('Zaehler'));
    Text := DynItemText.Text;
    TextHeight := GetTextHeight(DynItemText, AvailableWidth, Text);
    DynItemHeight := round(DynItemText.PlaceOffset.Y + TextHeight);
    AItem.Height := DynItemHeight;

    DynItemText.Height := TextHeight;
    DynItemText.Width := AvailableWidth;

    ItemText := TListItemText(aItem.View.FindDrawable('Aks'));
    ItemText.PlaceOffset.Y := DynItemHeight - DynItemText.Font.Size + 10;

    AItem.Height := Round(ItemText.PlaceOffset.Y + ItemText.Height) + 5;
  except
    on E: Exception do
    begin
      log.d('Tfrm_Aufgabe.lvUpdateObjects Error: ' + E.Message);
    end;
  end;

end;

procedure Tfrm_Aufgabe.SetButtonShare(aValue: Boolean);
begin
  gly_Share.Visible := aValue;
  gly_Share.HitTest := aValue;
  if aValue then
    gly_Share.ImageIndex := 13
  else
    gly_Share.ImageIndex := -1;
end;

procedure Tfrm_Aufgabe.ShareAufgabenliste;
var
  i1: Integer;
  List: TStringList;
  s: string;
  Aufgabe: TAufgabe;
  Gebaude: TGebaude;
  Zaehler: TZaehler;
  Datum: string;
begin
  List := TStringList.Create;
  try
    List.Duplicates := dupIgnore;
    List.Sorted := true;
    s := 'Adresse;Aks;Beschreibung;Einheit;Zählerdatum;Zählerstand';
    List.Add(s);
    for i1 := 0 to BasCloud.AufgabeList.Count -1 do
    begin
      Aufgabe := BasCloud.AufgabeList.Item[i1];
      Zaehler := Aufgabe.Zaehler;
      Gebaude := Zaehler.Gebaude;
      Datum := FormatDateTime('dd.mm.yyyy hh:nn:ss', TTimeZone.Local.ToLocalTime(Zaehler.Zaehlerstand.Datum));
      s:= Trim(Gebaude.Gebaudename + ' ' + Gebaude.Strasse + ' ' + Gebaude.Plz + ' ' + Gebaude.Ort) + ';' +
          Zaehler.AksId + ';' + Zaehler.Beschreibung + ';' + Zaehler.Einheit + ';' +
          Datum + ';' + FloatToStr(Zaehler.Zaehlerstand.Zaehlerstand);
      List.Add(s);
    end;
    List.SaveToFile(getSharedFilename);
    FShareItems.AddFile(getSharedFilename);
    FShareItems.Share(gly_Share, fExcluded);
  finally
    FreeAndNil(List);
  end;
end;

procedure Tfrm_Aufgabe.ShareItemsShareCompletedHandler(Sender: TObject;
  const AActivity: TShareActivity; const AError: string);
begin
  // If AActivity is TShareActivity.None, then the user cancelled - except for Android because it does not tell you :-/
  {
  if AActivity = TShareActivity.None then
    ShowMessage('Share cancelled')
  else
    ShowMessage('Share completed');
    }
end;

function Tfrm_Aufgabe.getSharedFilename: string;
begin
  //Result := TPath.Combine(TPath.GetSharedDocumentsPath, 'BAScloud.csv');
  Result := TPath.Combine(TPath.GetDocumentsPath, 'BAScloud.csv');
  ShowMessage(Result);
end;



function Tfrm_Aufgabe.GetTextHeight(const D: TListItemText; const Width: single; const Text: string): Integer;
var
  Layout: TTextLayout;
begin
  // Create a TTextLayout to measure text dimensions
  Result := 0;
  try
    Layout := TTextLayoutManager.DefaultTextLayout.Create;
    try
      Layout.BeginUpdate;
      try
        // Initialize layout parameters with those of the drawable
        Layout.Font.Assign(D.Font);
        Layout.VerticalAlign := D.TextVertAlign;
        Layout.HorizontalAlign := D.TextAlign;
        Layout.WordWrap := D.WordWrap;
        Layout.Trimming := D.Trimming;
        Layout.MaxSize := TPointF.Create(Width, TTextLayout.MaxLayoutSize.Y);
        Layout.Text := Text;
      finally
        Layout.EndUpdate;
      end;
      // Get layout height
      Result := Round(Layout.Height);
      // Add one em to the height
      Layout.Text := 'm';
      Result := Result + Round(Layout.Height);
    finally
      Layout.Free;
    end;
  except
    on E: Exception do
    begin
      log.d('Tfrm_Aufgabe.GetTextHeight Error: ' + E.Message);
    end;
  end;
end;

procedure Tfrm_Aufgabe.img_waitClick(Sender: TObject);
begin
  //FloatAnimation1.Enabled := true;
end;

procedure Tfrm_Aufgabe.EndRefresh;
begin
  log.d('Tfrm_Aufgabe.EndRefresh (Start)');
  try
    fWaitEnabled := false;
    img_wait.Visible := false;
    ani_waitUpload_Toolbar.Visible := false;
    ani_waitUpload_Toolbar.Enabled := false;
    ani_waitUpload_Toolbar.Repaint;
    Rec_Toolbar_Background.Repaint;
    Invalidate;
    gly_Refresh.Enabled := true;
    SetButtonShare(true);
  except
    on E: Exception do
    begin
      log.d('Error: ' + E.Message);
    end;
  end;
  log.d('Tfrm_Aufgabe.EndRefresh (Ende)');

end;


//*****************************************************************************
//** Buttons
//*****************************************************************************
procedure Tfrm_Aufgabe.btn_RefreshClick(Sender: TObject);
begin
  log.d('Tfrm_Aufgabe.btn_RefreshClick (Start)');
  DoUpdateListView;
  fDBQueue.InsertProcess_ManuelRefresh;
  //ani_waitUpload_Toolbar.Visible := true;
  //ani_waitUpload_Toolbar.Enabled := true;
  SetButtonShare(false);
  fWaitEnabled := true;
  img_wait.Visible := true;
  WaitAnimation.Enabled := true;
  gly_Refresh.Enabled := false;
  BasCloud.CheckTimer;
  log.d('Tfrm_Aufgabe.btn_RefreshClick (Ende)');
end;

procedure Tfrm_Aufgabe.btn_ReturnClick(Sender: TObject);
begin
  if Assigned(fOnZurueck) then
    fOnZurueck(Self);
end;

procedure Tfrm_Aufgabe.btn_ScannerClick(Sender: TObject);
begin
  if Assigned(OnScannerClick) then
    OnScannerClick(Self);
end;

procedure Tfrm_Aufgabe.btn_SearchFilterClick(Sender: TObject);
begin
  edt_Suche.Visible := not edt_Suche.Visible;
  if edt_Suche.Visible then
    edt_Suche.SetFocus;
end;

procedure Tfrm_Aufgabe.btn_ShareClick(Sender: TObject);
begin
  PermissionsService.RequestPermissions([cPermissionReadExternalStorage, cPermissionWriteExternalStorage],
    procedure(const APermissions: TPermissionArray; const AGrantResults: TPermissionStatusArray)
    begin
      if AGrantResults.AreAllGranted then
        ShareAufgabenliste;
    end
  );
end;

end.
