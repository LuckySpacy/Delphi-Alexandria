unit Form.HostEinstellung;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Form.Base, Vcl.Buttons, AdvEdit,
  Vcl.StdCtrls, Vcl.ExtCtrls, Datenmodul.Bilder, system.Net.HttpClient;

type
  Tfrm_Hosteinstellung = class(Tfrm_Base)
    pnl_Left: TPanel;
    pnl_Client: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    edt_Host: TEdit;
    edt_Port: TAdvEdit;
    pnl_Button: TPanel;
    btn_Connect: TSpeedButton;
    btn_Speichern: TSpeedButton;
    btn_Abbrechen: TSpeedButton;
    pnl_Header: TPanel;
    Shape1: TShape;
    pnl_Header_Left: TPanel;
    pnl_Header_Client: TPanel;
    Label1: TLabel;
    btn_Back: TSpeedButton;
    mem: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btn_SpeichernClick(Sender: TObject);
    procedure btn_AbbrechenClick(Sender: TObject);
    procedure btn_BackClick(Sender: TObject);
    procedure btn_ConnectClick(Sender: TObject);
  private
    procedure HTTPRequestRequestCompleted(const Sender: TObject; const AResponse: IHTTPResponse);
  public
    { Public-Deklarationen }
  end;

var
  frm_Hosteinstellung: Tfrm_Hosteinstellung;

implementation

{$R *.dfm}

uses
  Objekt.Energieverbrauch, Datenmodul.Rest;


procedure Tfrm_Hosteinstellung.FormCreate(Sender: TObject);
begin //
  inherited;
  edt_Port.Text := '';
end;

procedure Tfrm_Hosteinstellung.FormDestroy(Sender: TObject);
begin //
  inherited;

end;

procedure Tfrm_Hosteinstellung.FormShow(Sender: TObject);
begin //
  inherited;
  edt_Host.Text := Energieverberbrauch.Ini.Einstellung.Host;
  edt_Port.Value := Energieverberbrauch.Ini.Einstellung.Port;
end;


procedure Tfrm_Hosteinstellung.btn_AbbrechenClick(Sender: TObject);
begin
  BackClick(nil);
end;


procedure Tfrm_Hosteinstellung.btn_BackClick(Sender: TObject);
begin
  BackClick(nil);
end;

procedure Tfrm_Hosteinstellung.btn_ConnectClick(Sender: TObject);
begin
  dm_Rest.HTTPRequest.MethodString := 'GET';
  dm_Rest.HTTPRequest.URL := edt_Host.Text + ':' + Trim(edt_Port.Text);
  dm_Rest.HTTPRequest.OnRequestCompleted := HTTPRequestRequestCompleted;
  dm_Rest.HTTPRequest.Execute();
end;

procedure Tfrm_Hosteinstellung.btn_SpeichernClick(Sender: TObject);
begin
  Energieverberbrauch.Ini.Einstellung.Host := edt_Host.Text;
  Energieverberbrauch.Ini.Einstellung.Port := edt_Port.Value;
  BackClick(nil);
end;

procedure Tfrm_Hosteinstellung.HTTPRequestRequestCompleted(const Sender: TObject;
  const AResponse: IHTTPResponse);
begin //
  mem.Text := AResponse.ContentAsString;
end;


end.
