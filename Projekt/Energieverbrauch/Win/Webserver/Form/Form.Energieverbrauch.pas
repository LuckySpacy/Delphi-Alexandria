unit Form.Energieverbrauch;

interface

uses
  Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.AppEvnts, Vcl.StdCtrls, IdHTTPWebBrokerBridge, IdGlobal, Web.HTTPApp;

type
  TForm1 = class(TForm)
    ButtonStart: TButton;
    ButtonStop: TButton;
    EditPort: TEdit;
    Label1: TLabel;
    ApplicationEvents1: TApplicationEvents;
    ButtonOpenBrowser: TButton;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    edt_Host: TEdit;
    Label3: TLabel;
    edt_Datenbankpfad: TEdit;
    edt_Datenbankname: TEdit;
    Label4: TLabel;
    btn_Test: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
    procedure ButtonStartClick(Sender: TObject);
    procedure ButtonStopClick(Sender: TObject);
    procedure ButtonOpenBrowserClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btn_TestClick(Sender: TObject);
  private
    FServer: TIdHTTPWebBrokerBridge;
    procedure StartServer;
    function ConnectDB: Boolean;
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
{$IFDEF MSWINDOWS}
  WinApi.Windows, Winapi.ShellApi, Objekt.JZaehler, Objekt.JErrorList,
{$ENDIF}
  System.Generics.Collections, Objekt.Energieverbrauch, Datenmodul.Database;

procedure TForm1.ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
begin
  ButtonStart.Enabled := not FServer.Active;
  ButtonStop.Enabled := FServer.Active;
  EditPort.Enabled := not FServer.Active;
end;

procedure TForm1.btn_TestClick(Sender: TObject);
var
  JZaehler: TJZaehler;
  JErrorList: TJErrorList;
  List: TStringList;
  s: string;
begin
  List := TStringList.Create;
  JErrorList := TJErrorList.Create;
  JZaehler := TJZaehler.Create;
  try
    List.LoadFromFile('c:\Entwicklung\Delphi\Alexandria\Projekt\Energieverbrauch\Win\Webserver\bin\JErrorList.txt');
    JErrorList.JsonString := Trim(List.Text);
    Caption := JErrorList.JsonString;
    JZaehler.FieldByName('ZA_ID').AsString := '1';
    JZaehler.FieldByName('ZA_ZAEHLER').AsString := 'Gas';
    s := JZaehler.JsonString;
    if s = 'dfdsfds' then
      exit;
  finally
    FreeAndNil(JZaehler);
    FreeAndNil(List);
    FreeAndNil(JErrorList);
  end;
end;

procedure TForm1.ButtonOpenBrowserClick(Sender: TObject);
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

procedure TForm1.ButtonStartClick(Sender: TObject);
var
  Cur: TCursor;
begin
  Cur := Screen.Cursor;
  try
    Screen.Cursor := crHourGlass;
    if not ConnectDB then
      exit;
    StartServer;
  finally
    Screen.Cursor := Cur;
  end;
end;

procedure TForm1.ButtonStopClick(Sender: TObject);
begin
  FServer.Active := False;
  FServer.Bindings.Clear;
end;

function TForm1.ConnectDB: Boolean;
begin
  dm.Datenbankname := edt_Datenbankname.Text;
  dm.Host          := edt_Host.Text;
  dm.Pfad          := edt_Datenbankpfad.Text;
    Energieverbrauch.Ini.Einstellung.DB.Host := edt_Host.Text;
    Energieverbrauch.Ini.Einstellung.DB.Pfad := edt_Datenbankpfad.Text;
    Energieverbrauch.Ini.Einstellung.DB.DatenbankName := edt_Datenbankname.Text;
  Result := dm.ConnectDB;
  if Result  then
  begin
    Energieverbrauch.Ini.Einstellung.DB.Host := edt_Host.Text;
    Energieverbrauch.Ini.Einstellung.DB.Pfad := edt_Datenbankpfad.Text;
    Energieverbrauch.Ini.Einstellung.DB.DatenbankName := edt_Datenbankname.Text;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FServer := TIdHTTPWebBrokerBridge.Create(Self);
  Energieverbrauch := TEnergieverbrauch.Create;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FreeAndNil(Energieverbrauch);
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  edt_Host.Text := Energieverbrauch.Ini.Einstellung.DB.Host;
  edt_Datenbankpfad.Text := Energieverbrauch.Ini.Einstellung.DB.Pfad;
  edt_Datenbankname.Text := Energieverbrauch.Ini.Einstellung.DB.DatenbankName;
end;

procedure TForm1.StartServer;
begin
  if not FServer.Active then
  begin
    FServer.Bindings.Clear;
    FServer.DefaultPort := StrToInt(EditPort.Text);
    FServer.Active := True;
  end;
end;

end.
