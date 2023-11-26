unit Form.FilesaveUI;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Objekt.Filesaver, Vcl.ExtCtrls, Form.Main, Form.FileOption;

type
  Tfrm_Filesaver = class(TForm)
    pnl_Client: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    fFormVerlauf: TList;
    fFormList: TList;
    formMain : Tfrm_Main;
    formFileOption: Tfrm_FileOption;
    procedure CreateForm(aForm: TForm);
    procedure ShowForm(aForm: TForm);
    procedure DoBack(Sender: TObject);
  public
  end;

var
  frm_Filesaver: Tfrm_Filesaver;

implementation

{$R *.dfm}


procedure Tfrm_Filesaver.FormCreate(Sender: TObject);
begin
  Filesaver := TFilesaver.Create;
  fFormVerlauf := TList.Create;
  fFormList    := TList.Create;

  formFileOption := nil;
  formMain := Tfrm_Main.Create(Self);
  CreateForm(formMain);
end;

procedure Tfrm_Filesaver.FormDestroy(Sender: TObject);
begin
  FreeAndNil(Filesaver);
end;

procedure Tfrm_Filesaver.FormShow(Sender: TObject);
begin
  ShowForm(formMain);
end;

procedure Tfrm_Filesaver.ShowForm(aForm: TForm);
var
  i1: Integer;
begin
  for i1 := 0 to fFormList.Count -1 do
    TForm(fFormList.Items[i1]).Visible := false;
  aForm.Visible := true;
  if fFormVerlauf.Count > 0 then
    fFormVerlauf.Delete(fFormVerlauf.Count-1);
  fFormVerlauf.Add(aForm);
  Filesaver.Log.Info('Start');
end;

procedure Tfrm_Filesaver.CreateForm(aForm: TForm);
begin
begin
  aForm.Parent := pnl_Client;
  aForm.Align  := alClient;
  aForm.Show;
  aForm.Visible := false;
  aForm.BorderStyle := bsNone;
  fFormList.Add(aForm);
end;
end;

procedure Tfrm_Filesaver.DoBack(Sender: TObject);
begin

end;


end.
