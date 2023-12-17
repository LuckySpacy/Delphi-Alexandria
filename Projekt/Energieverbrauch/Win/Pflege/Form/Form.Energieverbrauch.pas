unit Form.Energieverbrauch;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Objekt.Energieverbrauch, Vcl.ComCtrls,
  Form.Main, Vcl.StdCtrls, Vcl.ExtCtrls, Form.Base, Form.HostEinstellung,
  System.Net.URLClient, System.Net.HttpClient, System.Net.HttpClientComponent;

type
  Tfrm_Energieverbrauch = class(TForm)
    pnl_Client: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    fFormVerlauf: TList;
    fFormList: TList;
    formMain: Tfrm_Main;
    formHosteinstellung: Tfrm_Hosteinstellung;
    procedure CreateForm(aForm: TForm);
    procedure ShowForm(aForm: TForm);
    procedure DoBack(Sender: TObject);
    procedure ShowHosteinstellung(Sender: TObject);
  public
  end;

var
  frm_Energieverbrauch: Tfrm_Energieverbrauch;

implementation

{$R *.dfm}

uses
  Datenmodul.Rest;



procedure Tfrm_Energieverbrauch.FormCreate(Sender: TObject);
begin //

  Energieverberbrauch := TEnergieverbrauch.Create;

  fFormVerlauf := TList.Create;
  fFormList    := TList.Create;
  formHosteinstellung := nil;

  formMain := Tfrm_Main.Create(Self);
  CreateForm(formMain);
  formMain.OnShowHostEinstellung := ShowHosteinstellung;

end;


procedure Tfrm_Energieverbrauch.FormDestroy(Sender: TObject);
begin
  FreeAndNil(fFormVerlauf);
  FreeAndNil(fFormList);
  FreeAndNil(Energieverberbrauch);
end;


procedure Tfrm_Energieverbrauch.FormShow(Sender: TObject);
begin
  ShowForm(formMain);
  if Energieverberbrauch.Ini.Einstellung.Host = '' then
    ShowHosteinstellung(nil);
end;



procedure Tfrm_Energieverbrauch.ShowForm(aForm: TForm);
var
  i1: Integer;
begin
  for i1 := 0 to fFormList.Count -1 do
    TForm(fFormList.Items[i1]).Visible := false;
  aForm.Visible := true;
  if fFormVerlauf.Count > 0 then
    fFormVerlauf.Delete(fFormVerlauf.Count-1);
  fFormVerlauf.Add(aForm);
end;

procedure Tfrm_Energieverbrauch.CreateForm(aForm: TForm);
begin
  aForm.Parent := pnl_Client;
  aForm.Align  := alClient;
  aForm.Show;
  aForm.Visible := false;
  Tfrm_Base(aForm).OnBack := doBack;
  fFormList.Add(aForm);
end;



procedure Tfrm_Energieverbrauch.DoBack(Sender: TObject);
var
  Form: TForm;
  i1: Integer;
begin
  if fFormVerlauf.Count <= 1 then
  begin
    ShowForm(formMain);
    exit;
  end;
  fFormVerlauf.Delete(fFormVerlauf.Count -1);
  Form := TForm(fFormVerlauf.Items[fFormVerlauf.Count -1]);
  for i1 := 0 to fFormList.Count -1 do
    TForm(fFormList.Items[i1]).Visible := false;
  Form.Visible := true;
end;



procedure Tfrm_Energieverbrauch.ShowHosteinstellung(Sender: TObject);
begin
  if formHosteinstellung = nil then
  begin
    formHosteinstellung := Tfrm_Hosteinstellung.Create(nil);
    CreateForm(formHosteinstellung);
  end;
  ShowForm(formHosteinstellung);
end;



end.
