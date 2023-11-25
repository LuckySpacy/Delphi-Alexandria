unit fntRveTableEditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Spin;

type
  Tfrm_RveTableEditor = class(TForm)
    pnl_Button: TPanel;
    cmd_Ok: TButton;
    cmd_Cancel: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    cmd_CellBorderColor: TPanel;
    cmd_BorderColor: TPanel;
    cmd_TableColor: TPanel;
    edt_Zellendicke: TSpinEdit;
    edt_Rahmendicke: TSpinEdit;
    edt_Zeilen: TSpinEdit;
    edt_Spalten: TSpinEdit;
    ColorDialog: TColorDialog;
    procedure FormCreate(Sender: TObject);
    procedure cmd_OkClick(Sender: TObject);
    procedure cmd_CancelClick(Sender: TObject);
    procedure PnlButtonColorMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PnlButtonColorMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
    FCancel: Boolean;
  public
    property Cancel: Boolean read FCancel;
  end;

var
  frm_RveTableEditor: Tfrm_RveTableEditor;

implementation

{$R *.dfm}

{ Tfrm_RveTableEditor }

procedure Tfrm_RveTableEditor.cmd_CancelClick(Sender: TObject);
begin
  close;
end;

procedure Tfrm_RveTableEditor.cmd_OkClick(Sender: TObject);
begin
  FCancel := false;
  close;
end;

procedure Tfrm_RveTableEditor.FormCreate(Sender: TObject);
begin
  FCancel := true;
end;


//--- Panel
procedure Tfrm_RveTableEditor.PnlButtonColorMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  TPanel(Sender).BevelOuter := bvLowered;
end;

procedure Tfrm_RveTableEditor.PnlButtonColorMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
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



end.
