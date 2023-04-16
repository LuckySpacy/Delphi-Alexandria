unit Form.OptimaWebservice;

interface

uses
  Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.AppEvnts, Vcl.StdCtrls, IdHTTPWebBrokerBridge, IdGlobal, Web.HTTPApp,
  Objekt.OptimaWebservice;

type
  Tfrm_OptimaWebservice = class(TForm)
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
  private
    FServer: TIdHTTPWebBrokerBridge;
    procedure StartServer;
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  frm_OptimaWebservice: Tfrm_OptimaWebservice;

implementation

{$R *.dfm}

uses
{$IFDEF MSWINDOWS}
  WinApi.Windows, Winapi.ShellApi,
{$ENDIF}
  System.Generics.Collections, Datenmodul.OptimaWebservice, FastMM5;


procedure Tfrm_OptimaWebservice.FormCreate(Sender: TObject);
begin
  FServer := TIdHTTPWebBrokerBridge.Create(Self);
  Ows := TOptimaWebservice.Create;
end;

procedure Tfrm_OptimaWebservice.FormDestroy(Sender: TObject);
begin
  FreeAndNil(Ows);
end;


procedure Tfrm_OptimaWebservice.ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
begin
  ButtonStart.Enabled := not FServer.Active;
  ButtonStop.Enabled := FServer.Active;
  EditPort.Enabled := not FServer.Active;
end;

procedure Tfrm_OptimaWebservice.ButtonOpenBrowserClick(Sender: TObject);
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

procedure Tfrm_OptimaWebservice.ButtonStartClick(Sender: TObject);
begin
  dm.ConnectOptima;
  StartServer;
end;

procedure Tfrm_OptimaWebservice.ButtonStopClick(Sender: TObject);
begin
  FServer.Active := False;
  FServer.Bindings.Clear;
end;


procedure Tfrm_OptimaWebservice.StartServer;
begin
  if not FServer.Active then
  begin
    FServer.Bindings.Clear;
    FServer.DefaultPort := StrToInt(EditPort.Text);
    FServer.Active := True;
  end;
end;


initialization
  {First try to share this memory manager.  This will fail if another module is already sharing its memory manager.  In
  case of the latter, try to use the memory manager shared by the other module.}
  if FastMM_ShareMemoryManager then
  begin
    {Try to load the debug support library (FastMM_FullDebugMode.dll, or FastMM_FullDebugMode64.dll under 64-bit). If
    it is available, then enter debug mode.}
    if FastMM_LoadDebugSupportLibrary then
    begin
      FastMM_EnterDebugMode;
      {In debug mode, also show the stack traces for memory leaks.}
      FastMM_MessageBoxEvents := FastMM_MessageBoxEvents + [mmetUnexpectedMemoryLeakDetail];
    end;
  end
  else
  begin
    {Another module is already sharing its memory manager, so try to use that.}
    FastMM_AttemptToUseSharedMemoryManager;
  end;

end.
