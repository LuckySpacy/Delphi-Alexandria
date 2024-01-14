unit Form.DatenbankEinstellung;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Objekt.IniDB;

type
  Tfrm_Datenbankeinstellung = class(TForm)
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    edt_Host: TEdit;
    edt_Datenbankpfad: TEdit;
    edt_Datenbankname: TEdit;
    cbx_Aktiv: TCheckBox;
    btn_CheckConnection: TButton;
    procedure EingabefelderExit(Sender: TObject);
    procedure btn_CheckConnectionClick(Sender: TObject);
  private
    fIniDB: TIniDB;
    fOnCheckConnection: TNotifyEvent;
  public
    procedure readIni(aIniDB: TIniDB);
    property OnCheckConnection: TNotifyEvent read fOnCheckConnection write fOnCheckConnection;
  end;

var
  frm_Datenbankeinstellung: Tfrm_Datenbankeinstellung;

implementation

{$R *.dfm}

{ Tfrm_Datenbankeinstellung }



procedure Tfrm_Datenbankeinstellung.EingabefelderExit(Sender: TObject);
begin
  fIniDB.Host := edt_Host.Text;
  fIniDB.Pfad := edt_Datenbankpfad.Text;
  fIniDB.Aktiv := cbx_Aktiv.Checked;
  fIniDB.DatenbankName := edt_Datenbankname.Text;
end;

procedure Tfrm_Datenbankeinstellung.readIni(aIniDB: TIniDB);
begin
  fIniDB := aIniDB;
  edt_Host.Text := fIniDB.Host;
  edt_Datenbankpfad.Text := fIniDB.Pfad;
  edt_Datenbankname.Text := fIniDB.DatenbankName;
  cbx_Aktiv.Checked      := fIniDB.Aktiv;
end;

procedure Tfrm_Datenbankeinstellung.btn_CheckConnectionClick(Sender: TObject);
begin
  if not cbx_Aktiv.Checked then
  begin
    ShowMessage('Bitte stelle vorher die Einstellung auf Aktiv');
    exit;
  end;
  if Assigned(fOnCheckConnection) then
    fOnCheckConnection(Self);
end;


end.
