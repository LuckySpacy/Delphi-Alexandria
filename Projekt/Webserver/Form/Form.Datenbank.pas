unit Form.Datenbank;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Form.DatenbankEinstellung;

type
  Tfrm_Datenbank = class(TForm)
    pg: TPageControl;
    tbs_Token: TTabSheet;
    tbs_Energieverbrauch: TTabSheet;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    fFormToken: Tfrm_Datenbankeinstellung;
    fFormEnergieverbrauch: Tfrm_Datenbankeinstellung;
    procedure readIni;
    procedure CheckConnectionClick(Sender: TObject);
  public
  end;

var
  frm_Datenbank: Tfrm_Datenbank;

implementation

{$R *.dfm}

uses
  Objekt.Webservice, Datenmodul.Database, System.UITypes;


procedure Tfrm_Datenbank.FormCreate(Sender: TObject);
begin
  fFormToken := Tfrm_Datenbankeinstellung.Create(Self);
  fFormToken.Parent := tbs_Token;
  fFormToken.Align := alClient;
  fFormToken.OnCheckConnection := CheckConnectionClick;
  fFormToken.Show;
  fFormEnergieverbrauch := Tfrm_Datenbankeinstellung.Create(Self);
  fFormEnergieverbrauch.Parent := tbs_Energieverbrauch;
  fFormEnergieverbrauch.Align := alClient;
  fFormEnergieverbrauch.Show;
  fFormEnergieverbrauch.OnCheckConnection := CheckConnectionClick;
  readIni;
end;

procedure Tfrm_Datenbank.FormDestroy(Sender: TObject);
begin //

end;

procedure Tfrm_Datenbank.readIni;
begin
  fFormToken.readIni(Webservice.Ini.Datenbanken.Token);
  fFormEnergieverbrauch.readIni(Webservice.Ini.Datenbanken.Energieverbrauch);
end;

procedure Tfrm_Datenbank.CheckConnectionClick(Sender: TObject);
begin //
  if pg.ActivePage = tbs_Token then
  begin
    if dm.CheckConnetion_Token then
      MessageDlg('Die Verbindung zur Datenbank war erfolgreich', TMsgDlgType.mtInformation, [mbOk], 0);
  end;
  if pg.ActivePage = tbs_Energieverbrauch then
  begin
    if dm.CheckConnetion_Energieverbrauch then
      MessageDlg('Die Verbindung zur Datenbank war erfolgreich', TMsgDlgType.mtInformation, [mbOk], 0);
  end;
end;


end.

