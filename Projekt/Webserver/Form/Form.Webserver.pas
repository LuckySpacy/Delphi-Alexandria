unit Form.Webserver;

interface

uses
  Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.AppEvnts, Vcl.StdCtrls, IdHTTPWebBrokerBridge, IdGlobal, Web.HTTPApp,
  Vcl.ExtCtrls, Form.Datenbank, Objekt.Webservice;

type
  Tfrm_Webservice = class(TForm)
    ApplicationEvents1: TApplicationEvents;
    pnl_Button: TPanel;
    pnl_Client: TPanel;
    ButtonStart: TButton;
    ButtonStop: TButton;
    Label1: TLabel;
    edt_Port: TEdit;
    ButtonOpenBrowser: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
    procedure ButtonStartClick(Sender: TObject);
    procedure ButtonStopClick(Sender: TObject);
    procedure ButtonOpenBrowserClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FServer: TIdHTTPWebBrokerBridge;
    fFormDatenbank: Tfrm_Datenbank;
    procedure StartServer;
    { Private-Deklarationen }
  public
    function CheckDatenbankverbindungen: Boolean;
  end;

var
  frm_Webservice: Tfrm_Webservice;

implementation

{$R *.dfm}

uses
{$IFDEF MSWINDOWS}
  WinApi.Windows, Winapi.ShellApi,
{$ENDIF}
  System.Generics.Collections, Datenmodul.Database, System.UITypes;

procedure Tfrm_Webservice.FormCreate(Sender: TObject);
begin
  FServer := TIdHTTPWebBrokerBridge.Create(Self);
  Webservice := TWebservice.Create;
  fFormDatenbank := Tfrm_Datenbank.Create(Self);
  fFormDatenbank.Parent := pnl_Client;
  fFormDatenbank.Align := alClient;
  fFormDatenbank.Show;
end;

procedure Tfrm_Webservice.FormDestroy(Sender: TObject);
begin
  FreeAndNil(Webservice);
end;

procedure Tfrm_Webservice.ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
begin
  ButtonStart.Enabled := not FServer.Active;
  ButtonStop.Enabled := FServer.Active;
  edt_Port.Enabled := not FServer.Active;
end;

procedure Tfrm_Webservice.ButtonOpenBrowserClick(Sender: TObject);
{$IFDEF MSWINDOWS}
var
  LURL: string;
{$ENDIF}
begin
  StartServer;
{$IFDEF MSWINDOWS}
  LURL := Format('http://localhost:%s', [edt_Port.Text]);
  ShellExecute(0,
        nil,
        PChar(LURL), nil, nil, SW_SHOWNOACTIVATE);
{$ENDIF}
end;

procedure Tfrm_Webservice.ButtonStartClick(Sender: TObject);
begin
  if not CheckDatenbankverbindungen then
    exit;
  StartServer;
end;

procedure Tfrm_Webservice.ButtonStopClick(Sender: TObject);
begin
  FServer.Active := False;
  FServer.Bindings.Clear;
end;


function Tfrm_Webservice.CheckDatenbankverbindungen: Boolean;
begin
  Result := dm.CheckConnetion_Token;
  if not Result then
  begin
    MessageDlg('Bitte Prüfe die Datenbankverbindungen oder setze sie auf Inaktiv', TMsgDlgType.mtError, [mbOk], 0);
    exit;
  end;
  Result := dm.CheckConnetion_Energieverbrauch;
  if not Result then
  begin
    MessageDlg('Bitte Prüfe die Datenbankverbindungen oder setze sie auf Inaktiv', TMsgDlgType.mtError, [mbOk], 0);
    exit;
  end;
end;

procedure Tfrm_Webservice.StartServer;
begin
  if not FServer.Active then
  begin
    FServer.Bindings.Clear;
    FServer.DefaultPort := StrToInt(edt_Port.Text);
    FServer.Active := True;
  end;
end;

end.
