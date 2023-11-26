unit Form.FileOption;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Samples.Spin, AdvEdit, AdvEdBtn,
  AdvDirectoryEdit, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  Tfrm_FileOption = class(TForm)
    Panel1: TPanel;
    btn_Ok: TButton;
    btn_Cancel: TButton;
    Panel2: TPanel;
    Panel3: TPanel;
    lbl_Backupname: TLabel;
    Label1: TLabel;
    edt_von: TEdit;
    edt_Nach: TAdvDirectoryEdit;
    Label9: TLabel;
    edt_Anzahl_Ziel: TSpinEdit;
    Label3: TLabel;
    edt_Anzahl_Quell: TSpinEdit;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  frm_FileOption: Tfrm_FileOption;

implementation

{$R *.dfm}

end.
