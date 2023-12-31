unit Form.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  Form.Base, FMX.Controls.Presentation, FMX.ImgList, FMX.Objects, FMX.Layouts,
  FMX.MultiView, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, FMX.Gestures, Thread.Timer,
  Data.Bind.Components, Data.Bind.ObjectScope, FMX.SVGIconImage;

type
  Tfrm_Main = class(Tfrm_Base)
    Lay_Top: TLayout;
    Rect_Hosteinstellung: TRectangle;
    gly_Menu: TGlyph;
    lbl_Ueberschrift: TLabel;
    MultiView: TMultiView;
    Lay_HostEinstellung: TLayout;
    Label1: TLabel;
    Gly_Host: TGlyph;
    Lay_Zaehleranlegen: TLayout;
    Label2: TLabel;
    Glyph1: TGlyph;
    lv: TListView;
    SVGIconImage1: TSVGIconImage;
    lay_ZaehlerBearb: TLayout;
    lbl_ZaehlerBearb: TLabel;
    Glyph2: TGlyph;
    procedure Lay_HostEinstellungClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lvItemClickEx(const Sender: TObject; ItemIndex: Integer;
      const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
    procedure lvGesture(Sender: TObject; const EventInfo: TGestureEventInfo;
      var Handled: Boolean);
    procedure lvMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure lvMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure lvUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lvResized(Sender: TObject);
  private
    fOnHostEinstellung: TNotifyEvent;
    fOnZaehlerModify: TNotifyEvent;
    fOnZaehlerClick: TNotifyEvent;
    fPressedItem: TListviewItem;
    fTimer: TThreadTimer;
    fBearbModus: Boolean;
    procedure MenuClick(Sender: TObject);
    procedure ZaehlerAddClick(Sender: TObject);
    procedure UpdateListView;
    procedure TapAndHold(Sender: TObject);
    procedure setBearbModus(const Value: Boolean);
    procedure ZaehlerBearbeiten(Sender: TObject);
    procedure setZaehlerItemWidth(aTextObjectAppearance: TTextObjectAppearance);
  public
    property OnHostEinstellung: TNotifyEvent read fOnHostEinstellung write fOnHostEinstellung;
    property OnZaehlerModify: TNotifyEvent read fOnZaehlerModify write fOnZaehlerModify;
    procedure DoUpdateListView;
    property OnZaehlerClick: TNotifyEvent read fOnZaehlerClick write fOnZaehlerClick;
    property BearbModus: Boolean read fBearbModus write setBearbModus;
    procedure Reload;
  end;

var
  frm_Main: Tfrm_Main;

implementation

{$R *.fmx}

uses
  FMX.DialogService, Objekt.Energieverbrauch, Objekt.JEnergieverbrauch, Objekt.JZaehlerList, Objekt.JZaehler,
  DateUtils, Datenmodul.Bilder;


procedure Tfrm_Main.FormCreate(Sender: TObject);
begin  //
  inherited;
  Lay_HostEinstellung.HitTest := true;
  MultiView.Width := 250;
  MultiView.Mode := TMultiViewMode.Drawer;
  gly_Menu.HitTest := true;
  gly_Menu.OnClick := MenuClick;
  Lay_Zaehleranlegen.HitTest := true;
  Lay_Zaehleranlegen.OnClick := ZaehlerAddClick;
  lay_ZaehlerBearb.HitTest := true;
  lay_ZaehlerBearb.OnClick := ZaehlerBearbeiten;
  fTimer := TThreadTimer.Create;
  fTimer.OnTimer := TapAndHold;
  fBearbModus := false;
end;

procedure Tfrm_Main.FormDestroy(Sender: TObject);
begin  //
  FreeAndNil(fTimer);
  inherited;
end;

procedure Tfrm_Main.Lay_HostEinstellungClick(Sender: TObject);
begin
  MultiView.HideMaster;
  if Assigned(fOnHostEinstellung) then
    fOnHostEinstellung(Self);
end;





procedure Tfrm_Main.MenuClick(Sender: TObject);
begin //
  MultiView.ShowMaster;
end;



procedure Tfrm_Main.Reload;
begin
  DoUpdateListView;
end;

procedure Tfrm_Main.setBearbModus(const Value: Boolean);
begin
  fBearbModus := Value;
  if fBearbModus then
    lbl_ZaehlerBearb.Text := 'Modus beenden'
  else
    lbl_ZaehlerBearb.Text := 'Zähler bearbeiten';
  MultiView.HideMaster;
  DoUpdateListView;
end;

procedure Tfrm_Main.ZaehlerAddClick(Sender: TObject);
begin
  MultiView.HideMaster;
  if Assigned(fOnZaehlerModify) then
    fOnZaehlerModify(nil);
end;




procedure Tfrm_Main.ZaehlerBearbeiten(Sender: TObject);
begin
  BearbModus := not BearbModus;
end;

procedure Tfrm_Main.DoUpdateListView;
begin
  UpdateListView;
end;


procedure Tfrm_Main.UpdateListView;
var
  i1: Integer;
  JZaehlerList: TJZaehlerList;
  Item: TListViewItem;
  iWidth: single;
begin
  iWidth := lv.Width - 25;  // links/rechtes Margin
  iWidth := iWidth - 32;
  iWidth := iWidth - 32;
  lv.BeginUpdate;
  try
    lv.Items.Clear;
    JZaehlerList := Energieverbrauch.ZaehlerList;
    for i1 := 0 to JZaehlerList.Count -1 do
    begin
      Item := lv.Items.Add;
      Item.Data['Zaehler'] := JZaehlerList.Item[i1].FieldByName('ZA_ZAEHLER').AsString;
      Item.TagObject := JZaehlerList.Item[i1];
      if lv.Items[i1].Objects.FindDrawable('Zaehler') <> nil then
      begin
        lv.Items[i1].Objects.FindDrawable('Zaehler').Width := iWidth;
      end;

      //setZaehlerItemWidth(TTextObjectAppearance(Item));
      //TTextObjectAppearance(Item).Width := lv.Width - 25 - 64;
    end;
  finally
    lv.EndUpdate;
  end;
end;


procedure Tfrm_Main.lvGesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
begin    //
  case EventInfo.GestureID of
    sgiLeftDown :
      begin
        //if NextTabAction.Enabled then
        Handled := True;
      end;
  end;
end;

procedure Tfrm_Main.lvItemClickEx(const Sender: TObject; ItemIndex: Integer;
  const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
var
  s: string;
  JZaehler: TJZaehler;
begin //



  if ItemObject = nil then
    exit;




  caption := ItemObject.Name;

  if SameText(ItemObject.Name, 'Img_ZaehlerDelete') and (lv.Items[ItemIndex].TagObject <> nil) then
  begin
    s:= 'Möchten Sie wirklich den Zähler löschen?';
    TDialogService.MessageDialog(s, TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0,
                                procedure(const AResult: TModalResult)
                                begin
                                 if AResult = mrYes then
                                 begin
                                   JZaehler := TJZaehler(lv.Items[ItemIndex].TagObject);
                                   JEnergieverbrauch.DeleteZaehler(JZaehler.JsonString);
                                   Energieverbrauch.ZaehlerList.JsonString := JEnergieverbrauch.ReadZaehlerList;
                                   TDialogService.MessageDialog('Zähler wurde gelöscht', TMsgDlgType.mtInformation, [TMsgDlgBtn.mbOK], TMsgDlgBtn.mbNo, 0, nil);
                                   DoUpdateListView;
                                   exit;
                                 end
                                 else
                                 begin
                                   exit;
                                 end;
                               end);
    exit;
  end;


  if SameText(ItemObject.Name, 'Img_ZaehlerBearb') then
  begin
    if Assigned(fOnZaehlerModify) then
      fOnZaehlerModify(lv.Items[ItemIndex].TagObject);
    exit;
  end;




  fPressedItem := lv.Items[ItemIndex];

  if Assigned(fOnZaehlerClick) then
  begin
    //TDialogService.ShowMessage('ZaehlerClick');
    fOnZaehlerClick(lv.Items[ItemIndex].TagObject);
  end;

end;



procedure Tfrm_Main.lvMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  //fPressedItem := lv.ItemByPoint(x,y);
  //fPressedItem := lv.objectat
  fTimer.Start;
end;

procedure Tfrm_Main.lvMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
var
  ElapsedTime: Double;
begin
  // lv.ItemByPoint(X, Y);
  fTimer.Stop;
//  ElapsedTime := MilliSecondsBetween(now, fStartTime);
//  if ElapsedTime > 1000 then
//    caption := 'Long Press';
end;

procedure Tfrm_Main.lvResized(Sender: TObject);
var
  i1: Integer;
begin
  exit;
  for i1 := 0 to lv.Items.Count -1 do
  begin
    if lv.Items[i1].Objects.FindDrawable('ZA_ZAEHLER') <> nil then
    begin
      setZaehlerItemWidth(TTextObjectAppearance(lv.Items[i1]));
    end;
  end;
end;


procedure Tfrm_Main.setZaehlerItemWidth(aTextObjectAppearance: TTextObjectAppearance);
var
  iWidth: single;
begin
  iWidth := lv.Width - 25;  // links/rechtes Margin
  iWidth := lv.Width - 32;
  iWidth := lv.Width - 32;
  aTextObjectAppearance.Width := iWidth;
end;

procedure Tfrm_Main.lvUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
var
  ListItemImage: TListItemImage;
begin
  if AItem = nil then
    exit;
  if AItem.Objects.FindDrawable('Img_ZaehlerDelete') <> nil then
  begin
    ListItemImage := TListItemImage(AItem.Objects.FindDrawable('Img_ZaehlerDelete'));
    ListItemImage.ImageIndex := 3;
    ListItemImage.Visible := fBearbModus;
  end;
  if AItem.Objects.FindDrawable('Img_ZaehlerBearb') <> nil then
  begin
    ListItemImage := TListItemImage(AItem.Objects.FindDrawable('Img_ZaehlerBearb'));
    ListItemImage.ImageIndex := 2;
    ListItemImage.Visible := fBearbModus;
  end;

end;

procedure Tfrm_Main.TapAndHold(Sender: TObject);
begin
  caption := 'Hurra';
end;


end.
