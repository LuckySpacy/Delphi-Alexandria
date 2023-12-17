unit Form.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  Form.Base, FMX.Controls.Presentation, FMX.ImgList, FMX.Objects, FMX.Layouts,
  FMX.MultiView, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView;

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
    procedure Lay_HostEinstellungClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lvItemClickEx(const Sender: TObject; ItemIndex: Integer;
      const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
  private
    fOnHostEinstellung: TNotifyEvent;
    fOnZaehlerModify: TNotifyEvent;
    fOnZaehlerClick: TNotifyEvent;
    procedure MenuClick(Sender: TObject);
    procedure ZaehlerAddClick(Sender: TObject);
    procedure UpdateListView;
  public
    property OnHostEinstellung: TNotifyEvent read fOnHostEinstellung write fOnHostEinstellung;
    property OnZaehlerModify: TNotifyEvent read fOnZaehlerModify write fOnZaehlerModify;
    procedure DoUpdateListView;
    property OnZaehlerClick: TNotifyEvent read fOnZaehlerClick write fOnZaehlerClick;
  end;

var
  frm_Main: Tfrm_Main;

implementation

{$R *.fmx}

uses
  FMX.DialogService, Objekt.Energieverbrauch, Objekt.JEnergieverbrauch, Objekt.JZaehlerList, Objekt.JZaehler;


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
end;

procedure Tfrm_Main.FormDestroy(Sender: TObject);
begin  //
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


procedure Tfrm_Main.ZaehlerAddClick(Sender: TObject);
begin
  MultiView.HideMaster;
  if Assigned(fOnZaehlerModify) then
    fOnZaehlerModify(Self);
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
begin
  lv.BeginUpdate;
  try
    lv.Items.Clear;
    JZaehlerList := Energieverbrauch.ZaehlerList;
    for i1 := 0 to JZaehlerList.Count -1 do
    begin
      Item := lv.Items.Add;
      Item.Data['Zaehler'] := JZaehlerList.Item[i1].FieldByName('ZA_ZAEHLER').AsString;
      Item.TagObject := JZaehlerList.Item[i1];
    end;
  finally
    lv.EndUpdate;
  end;
end;


procedure Tfrm_Main.lvItemClickEx(const Sender: TObject; ItemIndex: Integer;
  const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
begin //

  if Assigned(fOnZaehlerClick) then
    fOnZaehlerClick(lv.Items[ItemIndex].TagObject);

end;



end.
