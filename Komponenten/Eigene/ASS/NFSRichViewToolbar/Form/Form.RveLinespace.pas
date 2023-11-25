unit Form.RveLinespace;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Samples.Spin,
  Vcl.ExtCtrls;

type
  Tfrm_RveLinespace = class(TForm)
    pnl_Button: TPanel;
    btn_Cancel: TButton;
    btn_Ok: TButton;
    Label1: TLabel;
    edt_Vor: TSpinEdit;
    Label2: TLabel;
    edt_Nach: TSpinEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btn_CancelClick(Sender: TObject);
    procedure btn_OkClick(Sender: TObject);
  private
    fCancel: Boolean;
  public
    property Cancel: Boolean read fCancel;
  end;

var
  frm_RveLinespace: Tfrm_RveLinespace;

implementation

{$R *.dfm}



procedure Tfrm_RveLinespace.FormCreate(Sender: TObject);
begin
  fCancel := true;
end;

procedure Tfrm_RveLinespace.FormShow(Sender: TObject);
begin
  edt_Vor.SetFocus;
end;

procedure Tfrm_RveLinespace.btn_CancelClick(Sender: TObject);
begin
  close;
end;

procedure Tfrm_RveLinespace.btn_OkClick(Sender: TObject);
begin
  if edt_Vor.Value < 0 then
    edt_Vor.Value := 0;
  if edt_Nach.Value < 0 then
    edt_Nach.Value := 0;
  FCancel := false;
  close;
end;



end.
