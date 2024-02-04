unit Form.Daten;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  Form.Base, FMX.Controls.Presentation, FMX.ImgList, FMX.Objects, FMX.Layouts,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.Gestures, Payload.ZaehlerstandReadZeitraum, Json.EnergieverbrauchZaehlerstandList,
  JSON.EnergieverbrauchZaehlerstand, JSON.EnergieverbrauchZaehler,
  FMX.DateTimeCtrls;

type
  Tfrm_Daten = class(Tfrm_Base)
    Lay_Top: TLayout;
    Rect_Hosteinstellung: TRectangle;
    gly_Return: TGlyph;
    lbl_Ueberschrift: TLabel;
    gly_Add: TGlyph;
    lv: TListView;
    GestureManager: TGestureManager;
    Gly_Statistik: TGlyph;
    Panel1: TPanel;
    Label1: TLabel;
    edt_DatumVon: TDateEdit;
    Label2: TLabel;
    edt_DatumBis: TDateEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lvGesture(Sender: TObject; const EventInfo: TGestureEventInfo;
      var Handled: Boolean);
    procedure lvItemClickEx(const Sender: TObject; ItemIndex: Integer;
      const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
    procedure edt_DatumExit(Sender: TObject);
  private
    fJZaehler: TJEnergieverbrauchZaehler;
    fJZaehlerstandList: TJEnergieverbrauchZaehlerstandList;
    fOnAddZaehlerstand: TNotifyEvent;
    fOnStatistik: TNotifyEvent;
    fPZaehlerstandReadZeitraum: TPReadZaehlerstandZeitraum;
    procedure Back(Sender: TObject);
    procedure AddZaehlerstand(Sender: TObject);
    procedure ReadZaehlerstandZeitraum(aDatumVon, aDatumBis: TDateTime);
    procedure UpdateListView;
    procedure GetStartEndItemsIndex(const AListView: TListView; out AStartItemIndex: Integer; out AEndItemIndex: Integer);
    procedure StatistikClick(Sender: TObject);
    procedure DeleteZaehlerstand(aJZaehlerstand: TJEnergieverbrauchZaehlerstand);
  public
    procedure setZaehler(aJZaehler: TJEnergieverbrauchZaehler);
    property OnAddZaehlerstand: TNotifyEvent read fOnAddZaehlerstand write fOnAddZaehlerstand;
    property OnStatistik: TNotifyEvent read fOnStatistik write fOnStatistik;
    procedure setActiv; override;
  end;

var
  frm_Daten: Tfrm_Daten;

implementation

{$R *.fmx}

uses
  FMX.DialogService, Objekt.Energieverbrauch, Objekt.JEnergieverbrauch,
  DateUtils, Datenmodul.Bilder, Payload.EnergieverbrauchZaehlerstandUpdate;

{ Tfrm_Daten }


procedure Tfrm_Daten.FormCreate(Sender: TObject);
begin //
  inherited;
  gly_Return.HitTest := true;
  gly_Return.OnClick := Back;
  gly_Add.HitTest := true;
  gly_Add.OnClick := AddZaehlerstand;
  Gly_Statistik.HitTest := true;
  Gly_Statistik.OnClick := StatistikClick;
  fJZaehlerstandList := TJEnergieverbrauchZaehlerstandList.Create;
  fJZaehler := nil;
  fPZaehlerstandReadZeitraum := TPReadZaehlerstandZeitraum.Create;
end;

procedure Tfrm_Daten.FormDestroy(Sender: TObject);
begin //
  FreeAndNil(fJZaehlerstandList);
  FreeAndNil(fPZaehlerstandReadZeitraum);
  inherited;
end;



procedure Tfrm_Daten.setActiv;
begin
  inherited;
  if fJZaehler = nil then
    exit;
  edt_DatumVon.Date := trunc(IncYear(now, -2));
  edt_DatumBis.Date := trunc(now);
  ReadZaehlerstandZeitraum(edt_DatumVon.Date, edt_Datumbis.Date);
  UpdateListView;
end;

procedure Tfrm_Daten.setZaehler(aJZaehler: TJEnergieverbrauchZaehler);
begin
  fJZaehler := aJZaehler;
  //ReadZaehlerstandZeitraum(IncYear(now, -1), now);
  //UpdateListView;
end;

procedure Tfrm_Daten.StatistikClick(Sender: TObject);
begin
  if Assigned(fOnStatistik) then
    fOnStatistik(fJZaehler);
end;

procedure Tfrm_Daten.UpdateListView;
var
  i1: Integer;
  JZaehlerstand: TJEnergieverbrauchZaehlerstand;
  Item: TListViewItem;
  ListItemImage: TListItemImage;
begin
  lv.BeginUpdate;
  try
    lv.Items.Clear;
    for i1 := 0 to fJZaehlerstandList.Count -1 do
    begin
      JZaehlerstand := fJZaehlerstandList.Item[i1];
      Item := lv.Items.Add;
      Item.Data['Datum'] := JZaehlerstand.FieldByName('ZS_DATUM').AsString;
      Item.TagObject := JZaehlerstand;
      Item.Data['Stand'] := JZaehlerstand.FieldByName('ZS_WERT').AsString;
      Item.Data['Verbrauch'] := JZaehlerstand.FieldByName('VERBRAUCH').AsString;
      Item.Data['Label_Verbrauch'] := 'Verbrauch';
      if Item.Objects.FindDrawable('Img_Delete') <> nil then
      begin
        ListItemImage := TListItemImage(Item.Objects.FindDrawable('Img_Delete'));
        ListItemImage.ImageIndex := -1;
        ListItemImage.Visible := false;
      end;
    end;
  finally
    lv.EndUpdate;
  end;
end;

procedure Tfrm_Daten.AddZaehlerstand(Sender: TObject);
begin //
  if Assigned(fOnAddZaehlerstand) then
    fOnAddZaehlerstand(fJZaehler);
end;

procedure Tfrm_Daten.Back(Sender: TObject);
begin
  DoZurueck(Self);
end;

procedure Tfrm_Daten.ReadZaehlerstandZeitraum(aDatumVon, aDatumBis: TDateTime);
var
  lJEnergieverbrauch: TJEnergieverbrauch;
begin //
  lJEnergieverbrauch := TJEnergieverbrauch.Create;
  try
    lJEnergieverbrauch.Token := Energieverbrauch.Token;
    fPZaehlerstandReadZeitraum.FieldByName('DATUMVON').AsDateTime := trunc(aDatumVon);
    fPZaehlerstandReadZeitraum.FieldByName('DATUMBIS').AsDateTime := trunc(aDatumBis);
    fPZaehlerstandReadZeitraum.FieldByName('ZS_ZA_ID').AsInteger := fJZaehler.FieldByName('ZA_ID').AsInteger;
    fJZaehlerstandList.JsonString := lJEnergieverbrauch.ReadZaehlerstandListInZeitraum(fPZaehlerstandReadZeitraum.JsonString);
  finally
    FreeAndNil(lJEnergieverbrauch);
  end;
end;


procedure Tfrm_Daten.lvGesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
var
  R: TRectF;
  I: Integer;
  LStartItemIndex, LEndItemIndex: Integer;
  LvItem: TListViewItem;
  ListItemImageDelete: TListItemImage;
begin //
  inherited;

  lvItem := nil;
  ListItemImageDelete := nil;
  GetStartEndItemsIndex(lv, LStartItemIndex, LEndItemIndex);
  for I := LStartItemIndex - 1 to LEndItemIndex do
  begin
    R := lv.GetItemRect(I);
    if (R.Bottom > EventInfo.Location.Y) and (R.Top < EventInfo.Location.Y) then
    begin
      lvItem := lv.Items[i];
       caption := lv.Items[i].Data['Verbrauch'].AsString;
      if lvItem.Objects.FindDrawable('Img_Delete') <> nil then
      begin
        ListItemImageDelete := TListItemImage(lvItem.Objects.FindDrawable('Img_Delete'));
      end;

       //ListView1.Items.Delete(I);
      break;
    end;
  end;

  if (lvItem = nil) or (ListItemImageDelete = nil) then
    exit;

  if EventInfo.GestureID = sgiLeft then
  begin
    ListItemImageDelete.ImageIndex := 6;
    ListItemImageDelete.Visible := true;
    if lvItem.Objects.FindDrawable('Label_Verbrauch') <> nil then
      lvItem.Objects.FindDrawable('Label_Verbrauch').PlaceOffset.X := -40;
    if lvItem.Objects.FindDrawable('Verbrauch') <> nil then
      lvItem.Objects.FindDrawable('Verbrauch').PlaceOffset.X := -40;
  end;

  if EventInfo.GestureID = sgiRight then
  begin
    ListItemImageDelete.ImageIndex := -1;
    ListItemImageDelete.Visible := false;
    if lvItem.Objects.FindDrawable('Label_Verbrauch') <> nil then
      lvItem.Objects.FindDrawable('Label_Verbrauch').PlaceOffset.X := 0;
    if lvItem.Objects.FindDrawable('Verbrauch') <> nil then
      lvItem.Objects.FindDrawable('Verbrauch').PlaceOffset.X := 0;
    //caption := fAktListViewItem.Data['Verbrauch'].AsString;
  end;
end;



procedure Tfrm_Daten.GetStartEndItemsIndex(const AListView: TListView; out AStartItemIndex: Integer; out AEndItemIndex: Integer);
var
  LViewportStart, LViewportEnd, LItemAbsEnd: Single;
  LItemIndex: Integer;
begin
  AStartItemIndex := -1;
  AEndItemIndex := -1;

  LViewportStart := AListView.ScrollViewPos;
  LViewportEnd := AListView.Height + LViewportStart;

  for LItemIndex := 0 to AListView.Items.Count - 1 do
  begin
    LItemAbsEnd := AListView.GetItemRect(LItemIndex).Bottom + AListView.ScrollViewPos;

    if (AStartItemIndex < 0) and (LItemAbsEnd >= LViewportStart) then
    begin
      AStartItemIndex := LItemIndex;
    end;

    if (AStartItemIndex >= 0) and (AEndItemIndex < 0) and (LItemAbsEnd >= LViewportEnd) then
    begin
      AEndItemIndex := LItemIndex;
      Break;
    end;
  end;

  if (AEndItemIndex < 0) and (AListView.Items.Count > 0) then
  begin
    AEndItemIndex := AListView.Items.Count - 1;
  end;
end;

procedure Tfrm_Daten.lvItemClickEx(const Sender: TObject; ItemIndex: Integer;
  const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
var
  s: string;
begin   //
//  fAktListViewItem := lv.Items[ItemIndex];
   if (ItemObject <> nil) and (SameText(ItemObject.Name, 'Img_Delete')) then
  begin
    s:= 'Möchten Sie wirklich den Zählerstand löschen?';
    TDialogService.MessageDialog(s, TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0,
                                procedure(const AResult: TModalResult)
                                begin
                                 if AResult = mrYes then
                                 begin
                                   DeleteZaehlerstand(TJEnergieverbrauchZaehlerstand(lv.Items[ItemIndex].TagObject));
                                   exit;
                                 end
                                 else
                                 begin
                                   exit;
                                 end;
                               end);
    exit;
  end;
end;

procedure Tfrm_Daten.DeleteZaehlerstand(aJZaehlerstand: TJEnergieverbrauchZaehlerstand);
var
  PEnergieverbrauchZaehlerstandUpdate: TPEnergieverbrauchZaehlerstandUpdate;
begin
  PEnergieverbrauchZaehlerstandUpdate := TPEnergieverbrauchZaehlerstandUpdate.Create;
  try
    PEnergieverbrauchZaehlerstandUpdate.FieldByName('ZS_ID').AsString := aJZaehlerstand.FieldByName('ZS_ID').AsString;
    JEnergieverbrauch.DeleteZaehlerstand(PEnergieverbrauchZaehlerstandUpdate.JsonString);
  finally
    FreeAndNil(PEnergieverbrauchZaehlerstandUpdate);
  end;
  //Energieverbrauch.ZaehlerList.JsonString := JEnergieverbrauch.ReadZaehlerList;
  TDialogService.MessageDialog('Zählerstand wurde gelöscht', TMsgDlgType.mtInformation, [TMsgDlgBtn.mbOK], TMsgDlgBtn.mbNo, 0, nil);
  ReadZaehlerstandZeitraum(edt_DatumVon.Date, edt_DatumBis.Date);
  UpdateListView;
end;

procedure Tfrm_Daten.edt_DatumExit(Sender: TObject);
begin
  ReadZaehlerstandZeitraum(edt_DatumVon.Date, edt_DatumBis.Date);
  UpdateListView;
end;


end.
