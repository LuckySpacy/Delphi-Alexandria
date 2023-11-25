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
    procedure btn_EinstellungClick(Sender: TObject);
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

end.
