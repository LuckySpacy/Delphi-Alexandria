unit Form.TSIWebserver;

interface

uses
  Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.AppEvnts, Vcl.StdCtrls, IdHTTPWebBrokerBridge, IdGlobal, Web.HTTPApp,
  Objekt.TSIWebServer;

type
  Tfrm_TSIWebserver = class(TForm)
    ButtonStart: TButton;
    ButtonStop: TButton;
    EditPort: TEdit;
    Label1: TLabel;
    ApplicationEvents1: TApplicationEvents;
    ButtonOpenBrowser: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
    procedure ButtonStartClick(Sender: TObject);
    procedure ButtonStopClick(Sender: TObject);
    procedure ButtonOpenBrowserClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FServer: TIdHTTPWebBrokerBridge;
    procedure StartServer;
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  frm_TSIWebserver: Tfrm_TSIWebserver;

implementation

{$R *.dfm}

uses
{$IFDEF MSWINDOWS}
  WinApi.Windows, Winapi.ShellApi,
{$ENDIF}
  System.Generics.Collections, Datamodul.Database;



procedure Tfrm_TSIWebserver.FormCreate(Sender: TObject);
begin
  FServer := TIdHTTPWebBrokerBridge.Create(Self);
  TSIWebserver := TTSIWebServer.Create;
  {
  TSIWebserver.TSI.Host := 'localhost';
  TSIWebserver.TSI.Datenbankpfad := 'd:\MeineProgramme\VServerStrato\Datenbank\';
  TSIWebserver.TSI.Datenbankname := 'TSI2.fdb';
  TSIWebserver.TSI.Username := 'sysdba';
  TSIWebserver.TSI.Passwort := 'masterkey';

  TSIWebserver.Kurse.Host := 'localhost';
  TSIWebserver.Kurse.Datenbankpfad := 'd:\MeineProgramme\VServerStrato\Datenbank\';
  TSIWebserver.Kurse.Username := 'sysdba';
  TSIWebserver.Kurse.Passwort := 'masterkey';
  TSIWebserver.Kurse.Datenbankname := 'TSIKurse.fdb';
  }

end;

procedure Tfrm_TSIWebserver.FormDestroy(Sender: TObject);
begin
  FreeAndNil(TSIWebserver);
end;

procedure Tfrm_TSIWebserver.FormShow(Sender: TObject);
begin
  caption := TSIWebserver.TSI.host;

  dm.TSIConnectData.Host := TSIWebServer.TSI.Host;
  dm.TSIConnectData.Datenbankname := TSIWebServer.TSI.Datenbankname;
  dm.TSIConnectData.Datenbankpfad := TSIWebServer.TSI.Datenbankpfad;

  dm.KurseConnectData.Host := TSIWebServer.Kurse.Host;
  dm.KurseConnectData.Datenbankname := TSIWebServer.Kurse.Datenbankname;
  dm.KurseConnectData.Datenbankpfad := TSIWebServer.Kurse.Datenbankpfad;

  dm.ConnectTSI;
  dm.ConnectKurse;

end;

procedure Tfrm_TSIWebserver.ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
begin
  ButtonStart.Enabled := not FServer.Active;
  ButtonStop.Enabled := FServer.Active;
  EditPort.Enabled := not FServer.Active;
end;

procedure Tfrm_TSIWebserver.ButtonOpenBrowserClick(Sender: TObject);
{$IFDEF MSWINDOWS}
var
  LURL: string;
{$ENDIF}
begin
  StartServer;
{$IFDEF MSWINDOWS}
  LURL := Format('http://localhost:%s', [EditPort.Text]);
  ShellExecute(0,
        nil,
        PChar(LURL), nil, nil, SW_SHOWNOACTIVATE);
{$ENDIF}
end;

procedure Tfrm_TSIWebserver.ButtonStartClick(Sender: TObject);
begin
  StartServer;
end;

procedure Tfrm_TSIWebserver.ButtonStopClick(Sender: TObject);
begin
  FServer.Active := False;
  FServer.Bindings.Clear;
end;



procedure Tfrm_TSIWebserver.StartServer;
begin
  if not FServer.Active then
  begin
    FServer.Bindings.Clear;
    FServer.DefaultPort := StrToInt(EditPort.Text);
    FServer.Active := True;
  end;
end;

end.
