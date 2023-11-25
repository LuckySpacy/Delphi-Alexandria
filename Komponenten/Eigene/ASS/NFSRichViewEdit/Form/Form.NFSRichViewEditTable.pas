unit Form.NFSRichViewEditTable;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Samples.Spin,
  Vcl.ExtCtrls;

type
  Tfrm_NFSRichViewEditTable = class(TForm)
    ColorDialog: TColorDialog;
    pnl_Button: TPanel;
    btn_Ok: TButton;
    btn_Cancel: TButton;
    Label1: TLabel;
    edt_Spalten: TSpinEdit;
    Label2: TLabel;
    edt_Zeilen: TSpinEdit;
    Label3: TLabel;
    edt_Rahmendicke: TSpinEdit;
    Label4: TLabel;
    edt_Zellendicke: TSpinEdit;
    Label5: TLabel;
    cmd_TableColor: TPanel;
    Label6: TLabel;
    cmd_BorderColor: TPanel;
    Label7: TLabel;
    cmd_CellBorderColor: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure btn_CancelClick(Sender: TObject);
    procedure btn_OkClick(Sender: TObject);
    procedure PnlButtonColorMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PnlButtonColorMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
    fCancel: Boolean;
  public
    property Cancel: Boolean read fCancel;
  end;

var
  frm_NFSRichViewEditTable: Tfrm_NFSRichViewEditTable;

implementation

{$R *.dfm}

//******************************************************************************
//*** EVENTS
//******************************************************************************



procedure Tfrm_NFSRichViewEditTable.FormCreate(Sender: TObject);
begin
  fCancel := true;
end;

procedure Tfrm_NFSRichViewEditTable.PnlButtonColorMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  TPanel(Sender).BevelOuter := bvLowered;
end;

procedure Tfrm_NFSRichViewEditTable.PnlButtonColorMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  TPanel(Sender).BevelOuter := bvRaised;
  ColorDialog.Color := TPanel(Sender).Color;
  if ColorDialog.Execute then
  begin
    TPanel(Sender).Color := ColorDialog.Color;
  end;
end;

procedure Tfrm_NFSRichViewEditTable.btn_CancelClick(Sender: TObject);
begin
  close;
end;

procedure Tfrm_NFSRichViewEditTable.btn_OkClick(Sender: TObject);
begin
  fCancel := false;
  close;
end;



end.
