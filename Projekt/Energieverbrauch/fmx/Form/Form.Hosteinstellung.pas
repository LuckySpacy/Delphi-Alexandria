unit Form.Hosteinstellung;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  Form.Base, FMX.Objects, FMX.Layouts, FMX.SVGIconImage, Datenmodul.Bilder,
  FMX.ImgList, FMX.Controls.Presentation, FMX.Edit, system.Net.HttpClient;

type
  Tfrm_Hosteinstellung = class(Tfrm_Base)
    Lay_Top: TLayout;
    Rect_Hosteinstellung: TRectangle;
    gly_Return: TGlyph;
    lbl_Ueberschrift: TLabel;
    Layout1: TLayout;
    edt_Host: TEdit;
    lbl_Host: TLabel;
    edt_Port: TEdit;
    lbl_Port: TLabel;
    btn_CheckConnection: TCornerButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btn_CheckConnectionClick(Sender: TObject);
  private
    fCheckResult: string;
    fCanReturn: Boolean;
    function CheckConnection: Boolean;
    procedure Back(Sender: TObject);
  public
    procedure HTTPRequestRequestCompleted(const Sender: TObject; const AResponse: IHTTPResponse);
    procedure setActiv; override;

  end;

var
  frm_Hosteinstellung: Tfrm_Hosteinstellung;

implementation

{$R *.fmx}

uses
  Datenmodul.Rest, FMX.DialogService, Objekt.Energieverbrauch;


procedure Tfrm_Hosteinstellung.FormCreate(Sender: TObject);
begin  //
  inherited;
  gly_Return.HitTest := true;
  gly_Return.OnClick := Back;
  fCanReturn := true;
end;

procedure Tfrm_Hosteinstellung.FormDestroy(Sender: TObject);
begin  //
  inherited;

end;



procedure Tfrm_Hosteinstellung.Back(Sender: TObject);
begin
  fCanReturn := true;
  CheckConnection;
end;

procedure Tfrm_Hosteinstellung.btn_CheckConnectionClick(Sender: TObject);
begin
  fCanReturn := false;
  CheckConnection;
end;

function Tfrm_Hosteinstellung.CheckConnection: Boolean;
begin //
  Result := true;
  dm_Rest.HTTPRequest.MethodString := 'GET';
  //dm_Rest.HTTPRequest.URL := 'http://' +edt_Host.Text + ':' + Trim(edt_Port.Text) + '/CheckConnect';
  dm_Rest.HTTPRequest.URL := edt_Host.Text + ':' + Trim(edt_Port.Text) + '/CheckConnect';
  dm_Rest.HTTPRequest.OnRequestCompleted := HTTPRequestRequestCompleted;
  dm_Rest.HTTPRequest.Execute();
end;

procedure Tfrm_Hosteinstellung.HTTPRequestRequestCompleted(
  const Sender: TObject; const AResponse: IHTTPResponse);
var
  s: string;
  iPort: Integer;
begin
  fCheckResult := AResponse.ContentAsString;
  if SameText(fCheckResult, 'Alive') then
  begin
    if not TryStrToInt(edt_Port.Text, iPort) then
    begin
      TDialogService.MessageDialog('Port ist nicht numerisch', TMsgDlgType.mtInformation, [TMsgDlgBtn.mbOK], TMsgDlgBtn.mbOK, 0, nil);
      exit;
    end;

    Energieverbrauch.HostIni.Host := edt_Host.Text;
    Energieverbrauch.HostIni.Port := iPort;
    if fCanReturn then
      DoZurueck(nil)
    else
      TDialogService.MessageDialog('Verbindung erfolgreich', TMsgDlgType.mtInformation, [TMsgDlgBtn.mbOK], TMsgDlgBtn.mbOK, 0, nil);
  end
  else
  begin
    s := 'Keine Verbindung zum Server: ' +  sLineBreak +
         fCheckResult;
    TDialogService.MessageDialog(s, TMsgDlgType.mtInformation, [TMsgDlgBtn.mbOK], TMsgDlgBtn.mbOK, 0, nil);
  end;

end;



procedure Tfrm_Hosteinstellung.setActiv;
begin
  inherited;
  edt_Host.Text := Energieverbrauch.HostIni.Host;
  edt_Port.Text := Energieverbrauch.HostIni.Port.ToString;
end;

end.
