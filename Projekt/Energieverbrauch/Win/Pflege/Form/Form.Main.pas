unit Form.Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Form.Base, Vcl.StdCtrls, datenmodul.Bilder,
  Vcl.Buttons, Vcl.ExtCtrls, Vcl.Imaging.pngimage, AdvToolBtn, SVGIconImage,
  Vcl.ComCtrls, Vcl.ToolWin;

type
  Tfrm_Main = class(Tfrm_Base)
    ToolBar1: TToolBar;
    btn_Einstellung: TToolButton;
    ListView1: TListView;
    Panel1: TPanel;
    procedure btn_EinstellungClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    fOnShowHostEinstellung: TNotifyEvent;
  public
    property OnShowHostEinstellung: TNotifyEvent read fOnShowHostEinstellung write fOnShowHostEinstellung;
  end;

var
  frm_Main: Tfrm_Main;

implementation

{$R *.dfm}

procedure Tfrm_Main.btn_EinstellungClick(Sender: TObject);
begin
  if Assigned(fOnShowHostEinstellung) then
    fOnShowHostEinstellung(Self);
end;

procedure Tfrm_Main.FormShow(Sender: TObject);
var
  i1: Integer;
  Item: TListItem;
begin
  inherited;

  for i1 := 1 to 10 do
  begin
    Item := ListView1.Items.Add;
    Item.Caption := 'Zeile ' + i1.ToString;
    Item.SubItems.Add('Spalte 1');
    Item.SubItems.Add('Spalte 2');
    Item.SubItems.Add('Spalte 3');
  end;

end;

end.
