unit Form.JWT;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls, Objekt.JsonWebToken;

type
  Tfrm_JWT = class(TForm)
    pg: TPageControl;
    tbs_TokenCreate: TTabSheet;
    tbs_TokenRead: TTabSheet;
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    edt_Issuer: TEdit;
    Label2: TLabel;
    edt_Key: TEdit;
    Label3: TLabel;
    cbo_Algorithm: TComboBox;
    Label4: TLabel;
    Panel3: TPanel;
    edt_IssueDate: TDateTimePicker;
    edt_IssueTime: TDateTimePicker;
    Label5: TLabel;
    Panel4: TPanel;
    edt_ExpireDate: TDateTimePicker;
    edt_ExpireTime: TDateTimePicker;
    Label6: TLabel;
    mem_Token: TMemo;
    Panel5: TPanel;
    btn_TokenCreate: TButton;
    edt_Subject: TEdit;
    Label7: TLabel;
    Panel6: TPanel;
    Label8: TLabel;
    Label9: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Panel7: TPanel;
    edt_Aussteller_Lesen: TEdit;
    edt_Schluessel_Lesen: TEdit;
    mem_Token_Lesen: TMemo;
    Panel10: TPanel;
    btn_TokenLesen: TButton;
    edt_Thema_Lesen: TEdit;
    edt_Ausstelldatum_Lesen: TEdit;
    edt_Ablaufdatum_Lesen: TEdit;
    btn_VerifyToken: TButton;
    edt_Algorithm_Lesen: TEdit;
    Label10: TLabel;
    lbl_Verifiziert: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btn_TokenCreateClick(Sender: TObject);
    procedure btn_VerifyTokenClick(Sender: TObject);
    procedure btn_TokenLesenClick(Sender: TObject);
  private
    fJWT: TJsonWebToken;
    function getDateTime(aDate, aTime: TDateTime): TDateTime;
  public
  end;

var
  frm_JWT: Tfrm_JWT;

implementation

{$R *.dfm}

uses
  DateUtils;




procedure Tfrm_JWT.FormCreate(Sender: TObject);
begin  //
  mem_Token.Clear;
  cbo_Algorithm.ItemIndex := 0;
  edt_Issuer.Text := 'Thomas Bachmann';
  edt_IssueDate.Date := trunc(now);
  edt_IssueTime.Time := 0;
  edt_ExpireDate.Date := trunc(IncDay(now));
  edt_ExpireTime.Time := 0;
  edt_Subject.Text := 'BAScloud';
  fJWT := TJsonWebToken.create;
  mem_Token_Lesen.Clear;
  edt_Aussteller_Lesen.Text := '';
  edt_Schluessel_Lesen.Text := '';
  edt_Thema_Lesen.Text      := '';
  edt_Ausstelldatum_Lesen.Text := '';
  edt_Ablaufdatum_Lesen.Text   := '';
  edt_Algorithm_Lesen.Text := '';
  lbl_Verifiziert.Caption := '';
end;

procedure Tfrm_JWT.FormDestroy(Sender: TObject);
begin  //
  FreeAndNil(fJWT);
end;

function Tfrm_JWT.getDateTime(aDate, aTime: TDateTime): TDateTime;
var
  wJahr: Word;
  wMonat: Word;
  wTag: Word;
  wStunde: Word;
  wMinute: Word;
  wSekunde: Word;
  wMilli: Word;
  wJahr_Save: Word;
  wMonat_Save: Word;
  wTag_Save: Word;
begin
  DecodeDateTime(aDate, wJahr_Save, wMonat_Save, wTag_Save, wStunde, wMinute, wSekunde, wMilli);
  DecodeDateTime(aTime, wJahr, wMonat, wTag, wStunde, wMinute, wSekunde, wMilli);
  Result := EncodeDateTime(wJahr_Save, wMonat_Save, wTag_Save, wStunde, wMinute, wSekunde, wMilli);
end;

procedure Tfrm_JWT.btn_TokenCreateClick(Sender: TObject);
begin
  fJWT.Thema        := edt_Subject.Text;
  fJWT.Algorithm    := cbo_Algorithm.ItemIndex;
  fJWT.Aussteller   := edt_Issuer.Text;
  fJWT.Austelldatum := getDateTime(edt_IssueDate.DateTime, edt_IssueTime.DateTime);
  fJWT.Ablaufdatum  := getDateTime(edt_ExpireDate.DateTime, edt_ExpireTime.DateTime);
  fJWT.Schluessel   := edt_Key.Text;
  mem_Token.Text := fJWT.BuildToken;
end;


procedure Tfrm_JWT.btn_TokenLesenClick(Sender: TObject);
begin
  if not fJWT.TokenInfo(Trim(mem_Token_Lesen.Text), edt_Schluessel_Lesen.Text) then
  begin
    ShowMessage(fJWT.LastError);
    exit;
  end;
  edt_Aussteller_Lesen.Text    := fJWT.Aussteller;
  edt_Thema_Lesen.Text         := fJWT.Thema;
  edt_Ausstelldatum_Lesen.Text := DateTimeToStr(fJWT.Austelldatum);
  edt_Ablaufdatum_Lesen.Text   := DateTimeToStr(fJWT.Ablaufdatum);
  edt_Algorithm_Lesen.Text     := FJWT.AlgorithmStr;
  if fJWT.Abgelaufen then
    edt_Ablaufdatum_Lesen.Font.Color := clRed
  else
    edt_Ablaufdatum_Lesen.Font.Color := clBlack;
  if fJWT.Verified then
  begin
    lbl_Verifiziert.Caption := 'Token konnte verifiziert werden';
    lbl_Verifiziert.Font.Color := clBlue;
  end
  else
  begin
    lbl_Verifiziert.Caption := 'Token konnte nicht verifiziert werden';
    lbl_Verifiziert.Font.Color := clRed;
  end;
end;

procedure Tfrm_JWT.btn_VerifyTokenClick(Sender: TObject);
begin
  {
  if fJWT.VerifyToken(Trim(mem_Token.Text), edt_Key.Text) then
  begin
    lbl_Verifiziert.Caption := 'Token konnte verifiziert werden';
    lbl_Verifiziert.Font.Color := clBlue;
  end
  else
  begin
    lbl_Verifiziert.Caption := 'Token konnte nicht verifiziert werden';
    lbl_Verifiziert.Font.Color := clRed;
  end;
  }

  if fJWT.VerifyToken(Trim(mem_Token.Text), edt_Key.Text) then
    ShowMessage('Token ist gültig')
  else
    ShowMessage('Token ist ungültig');

end;



end.
