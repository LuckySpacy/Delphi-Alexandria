unit Form.Daten;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  Form.Base, FMX.Controls.Presentation, FMX.ImgList, FMX.Objects, FMX.Layouts, Objekt.JZaehler,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, Objekt.JZaehlerstandList, FMX.Gestures;

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
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lvGesture(Sender: TObject; const EventInfo: TGestureEventInfo;
      var Handled: Boolean);
    procedure lvItemClickEx(const Sender: TObject; ItemIndex: Integer;
      const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
  private
    fJZaehler: TJZaehler;
    fJZaehlerstandList: TJZaehlerstandList;
    fOnAddZaehlerstand: TNotifyEvent;
    fOnStatistik: TNotifyEvent;
    procedure Back(Sender: TObject);
    procedure AddZaehlerstand(Sender: TObject);
    procedure ReadZaehlerstandZeitraum(aDatumVon, aDatumBis: TDateTime);
    procedure UpdateListView;
    procedure GetStartEndItemsIndex(const AListView: TListView; out AStartItemIndex: Integer; out AEndItemIndex: Integer);
    procedure StatistikClick(Sender: TObject);
  public
    procedure setZaehler(aJZaehler: TJZaehler);
    property OnAddZaehlerstand: TNotifyEvent read fOnAddZaehlerstand write fOnAddZaehlerstand;
    property OnStatistik: TNotifyEvent read fOnStatistik write fOnStatistik;
    procedure setActiv; override;
  end;

var
  frm_Daten: Tfrm_Daten;

implementation

{$R *.fmx}

uses
  FMX.DialogService, Objekt.Energieverbrauch, Objekt.JEnergieverbrauch, Objekt.JZaehlerList,
  DateUtils, Datenmodul.Bilder, Objekt.JZaehlerstand;

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
  fJZaehlerstandList := TJZaehlerstandList.Create;
  fJZaehler := nil;
end;

procedure Tfrm_Daten.FormDestroy(Sender: TObject);
begin //
  FreeAndNil(fJZaehlerstandList);
  inherited;
end;



procedure Tfrm_Daten.setActiv;
begin
  inherited;
  if fJZaehler = nil then
    exit;
  ReadZaehlerstandZeitraum(IncYear(now, -2), now);
  UpdateListView;
end;

procedure Tfrm_Daten.setZaehler(aJZaehler: TJZaehler);
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
  JZaehlerstand: TJZaehlerstand;
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
  JZaehlerstand: TJZaehlerstand;
begin //
  JZaehlerstand := TJZaehlerstand.Create;
  try
    JZaehlerstand.FieldByName('DATUMVON').AsDateTime := trunc(aDatumVon);
    JZaehlerstand.FieldByName('DATUMBIS').AsDateTime := trunc(aDatumBis);
    JZaehlerstand.FieldByName('ZS_ZA_ID').AsInteger := fJZaehler.FieldByName('ZA_ID').AsInteger;
    fJZaehlerstandList.JsonString := JEnergieverbrauch.ReadZaehlerstandListInZeitraum(JZaehlerstand.JsonString);
  finally
    FreeAndNil(JZaehlerstand);
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
  JZaehlerstand: TJZaehlerstand;
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
                                   JZaehlerstand := TJZaehlerstand(lv.Items[ItemIndex].TagObject);
                                   JEnergieverbrauch.DeleteZaehlerstand(JZaehlerstand.JsonString);
                                   Energieverbrauch.ZaehlerList.JsonString := JEnergieverbrauch.ReadZaehlerList;
                                   TDialogService.MessageDialog('Zählerstand wurde gelöscht', TMsgDlgType.mtInformation, [TMsgDlgBtn.mbOK], TMsgDlgBtn.mbNo, 0, nil);
                                   ReadZaehlerstandZeitraum(IncYear(now, -1), now);
                                   UpdateListView;
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

end.
