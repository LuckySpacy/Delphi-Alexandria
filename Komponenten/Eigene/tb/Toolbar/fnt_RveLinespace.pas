unit fnt_RveLinespace;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Spin;

type
  Tfrm_RveLinespace = class(TForm)
    pnl_Button: TPanel;
    btn_Cancel: TButton;
    btn_Ok: TButton;
    Label1: TLabel;
    Label2: TLabel;
    edt_Vor: TSpinEdit;
    edt_Nach: TSpinEdit;
    procedure btn_CancelClick(Sender: TObject);
    procedure btn_OkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FCancel: Boolean;
  public
    property Cancel: Boolean read FCancel;
  end;

var
  frm_RveLinespace: Tfrm_RveLinespace;

implementation

{$R *.dfm}

procedure Tfrm_RveLinespace.FormCreate(Sender: TObject);
begin
  FCancel := true;
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
