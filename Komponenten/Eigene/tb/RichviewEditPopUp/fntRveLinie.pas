unit fntRveLinie;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Spin;

type
  Tfrm_RveLinie = class(TForm)
    pnl_Button: TPanel;
    btn_Ok: TButton;
    btn_Cancel: TButton;
    Label1: TLabel;
    edt_Width: TSpinEdit;
    Label2: TLabel;
    cob_Linienart: TComboBox;
    Label3: TLabel;
    btn_Color: TPanel;
    ColorDialog: TColorDialog;
    procedure FormCreate(Sender: TObject);
    procedure btn_CancelClick(Sender: TObject);
    procedure btn_OkClick(Sender: TObject);
    procedure btn_ColorMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btn_ColorMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    FCancel: Boolean;
  public
    property Cancel: Boolean read FCancel;
  end;

var
  frm_RveLinie: Tfrm_RveLinie;

implementation

{$R *.dfm}



procedure Tfrm_RveLinie.FormCreate(Sender: TObject);
begin
  FCancel := true;
end;


procedure Tfrm_RveLinie.btn_CancelClick(Sender: TObject);
begin
  close;
end;


procedure Tfrm_RveLinie.btn_ColorMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  TPanel(Sender).BevelOuter := bvLowered;
end;

procedure Tfrm_RveLinie.btn_ColorMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  SaveFormStyle: TFormStyle;
begin
  SaveFormStyle := FormStyle;
  try
    FormStyle := fsNormal;
    TPanel(Sender).BevelOuter := bvRaised;
    ColorDialog.Color := TPanel(Sender).Color;
    if ColorDialog.Execute then
    begin
      TPanel(Sender).Color := ColorDialog.Color;
    end;
  finally
    FormStyle := SaveFormStyle;
  end;
end;

procedure Tfrm_RveLinie.btn_OkClick(Sender: TObject);
begin
  FCancel := false;
  close;
end;


end.
