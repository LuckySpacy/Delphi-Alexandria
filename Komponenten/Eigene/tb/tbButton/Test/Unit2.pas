unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, tbButton, ImgList, ExtCtrls, StdCtrls;

type
  TForm2 = class(TForm)
    TBButton1: TTBButton;
    ImageList1: TImageList;
    Panel1: TPanel;
    TBButton2: TTBButton;
    Button1: TButton;
    procedure TBButton1Click(Sender: TObject);
    procedure TBButton1RClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.TBButton1Click(Sender: TObject);
begin
  ShowMessage('Click');
end;

procedure TForm2.TBButton1RClick(Sender: TObject);
begin
  ShowMessage('RechtsClick');
end;

end.
