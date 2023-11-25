unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ImgList, tbToolbar, ExtDlgs, tbEditFile;

type
  TForm2 = class(TForm)
    ButtonedEdit1: TButtonedEdit;
    ImageList1: TImageList;
    TbToolbar1: TTbToolbar;
    edt: TButtonedEdit;
    TBEditFile1: TTBEditFile;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ButtonedEdit1RightButtonClick(Sender: TObject);
  private
    FImageList: TImageList;
    procedure LoadIconFromRes(aResType, aResName: string; aIcon: Graphics.TIcon);
  public
    { Public-Deklarationen }
  end;

var
  Form2: TForm2;

implementation

{$R ButtonedEdit.res}
{$R *.dfm}

uses
  shlObj;


procedure TForm2.ButtonedEdit1RightButtonClick(Sender: TObject);
begin
  ShowMessage('Hurra');
end;

procedure TForm2.FormCreate(Sender: TObject);
var
  Icon: TIcon;
begin
  FImageList := TImageList.Create(nil);
  Icon := TIcon.Create;
  LoadIconFromRes('RT_RCDATA', 'Oeffnen', Icon);
  FImageList.AddIcon(Icon);
  FreeAndNil(Icon);
  edt.Images := FImageList;
  edt.RightButton.DisabledImageIndex := 0;
  edt.RightButton.HotImageIndex := 0;
  edt.RightButton.ImageIndex := 0;
  edt.RightButton.PressedImageIndex := 0;
  edt.RightButton.Visible := true;
end;

procedure TForm2.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FImageList);
end;

procedure TForm2.LoadIconFromRes(aResType, aResName: string;
  aIcon: Graphics.TIcon);
var
  Res: TResourceStream;
begin
  Res := TResourceStream.Create(Hinstance, aResname, PChar(aResType));
  try
    aIcon.LoadFromStream(Res);
  finally
    FreeAndNil(Res);
  end;
end;



end.
