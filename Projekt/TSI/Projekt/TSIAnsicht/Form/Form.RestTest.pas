unit Form.RestTest;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Form.Base, Vcl.StdCtrls, Vcl.ExtCtrls,
  Communication.Base;

type
  Tfrm_RestTest = class(Tfrm_Base)
    Panel1: TPanel;
    Button1: TButton;
    Memo: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
  public
  end;

var
  frm_RestTest: Tfrm_RestTest;

implementation

{$R *.dfm}


procedure Tfrm_RestTest.FormCreate(Sender: TObject);
begin  //
  inherited;
end;

procedure Tfrm_RestTest.FormDestroy(Sender: TObject);
begin //
  inherited;

end;

procedure Tfrm_RestTest.Button1Click(Sender: TObject);
begin
  //fCommunication.Get('https://www.blaisepascalmagazine.eu');
  fCommunication.Get('http://localhost:8080/Number');
  Memo.Lines.Text := fCommunication.Content;
end;


end.
