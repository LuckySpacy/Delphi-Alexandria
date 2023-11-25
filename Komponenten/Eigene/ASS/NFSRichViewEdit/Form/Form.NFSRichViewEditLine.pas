unit Form.NFSRichViewEditLine;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Samples.Spin,
  Vcl.ExtCtrls;

type
  Tfrm_NFSRichViewEditLine = class(TForm)
    ColorDialog: TColorDialog;
    pnl_Button: TPanel;
    btn_Ok: TButton;
    btn_Cancel: TButton;
    Label1: TLabel;
    edt_Width: TSpinEdit;
    Label2: TLabel;
    cob_Linienart: TComboBox;
    Label3: TLabel;
    btn_Color: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure btn_CancelClick(Sender: TObject);
    procedure btn_OkClick(Sender: TObject);
    procedure btn_ColorMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btn_ColorMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    fCancel: Boolean;
  public
    property Cancel: Boolean read fCancel;
  end;

var
  frm_NFSRichViewEditLine: Tfrm_NFSRichViewEditLine;

implementation

{$R *.dfm}

//******************************************************************************
//*** EVENTS
//******************************************************************************



procedure Tfrm_NFSRichViewEditLine.FormCreate(Sender: TObject);
begin
  fCancel := true;
end;

procedure Tfrm_NFSRichViewEditLine.btn_CancelClick(Sender: TObject);
begin
  close;
end;

procedure Tfrm_NFSRichViewEditLine.btn_OkClick(Sender: TObject);
begin
  fCancel := false;
  close;
end;



procedure Tfrm_NFSRichViewEditLine.btn_ColorMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  TPanel(Sender).BevelOuter := bvLowered;
end;

procedure Tfrm_NFSRichViewEditLine.btn_ColorMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  TPanel(Sender).BevelOuter := bvRaised;
  ColorDialog.Color := TPanel(Sender).Color;
  if ColorDialog.Execute then
  begin
    TPanel(Sender).Color := ColorDialog.Color;
  end;
end;

end.
