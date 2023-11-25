unit Form.QRCodeErzeugen;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Memo.Types,
  FMX.StdCtrls, FMX.ScrollBox, FMX.Memo, FMX.Controls.Presentation, FMX.Layouts,
  FMX.Objects, Objekt.QRCodeErzeugen, FMX.Edit;

type
  Tfrm_QRCodeErzeugen = class(TForm)
    Layout1: TLayout;
    lbl_QRCodeText: TLabel;
    Memo1: TMemo;
    btn_QRCodeErzeugen: TButton;
    Layout2: TLayout;
    PaintBox: TPaintBox;
    Image1: TImage;
    edt_Pixelsize: TEdit;
    lbl_Pixelsize: TLabel;
    Layout3: TLayout;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btn_QRCodeErzeugenClick(Sender: TObject);
  private
    fQRCodeErzeugen: TQRCodeErzeugen;
  public
  end;

var
  frm_QRCodeErzeugen: Tfrm_QRCodeErzeugen;

implementation

{$R *.fmx}




procedure Tfrm_QRCodeErzeugen.FormCreate(Sender: TObject);
begin  //
  fQRCodeErzeugen := TQRCodeErzeugen.Create;
  Memo1.Lines.Text := 'Hello World!';
  edt_Pixelsize.Text := '10';
  //fQRCodeErzeugen.PaintBox := PaintBox;
end;

procedure Tfrm_QRCodeErzeugen.FormDestroy(Sender: TObject);
begin  //
  FreeAndNil(fQRCodeErzeugen);
end;

procedure Tfrm_QRCodeErzeugen.btn_QRCodeErzeugenClick(Sender: TObject);
begin
  fQRCodeErzeugen.Data := Trim(Memo1.Lines.Text);
  fQRCodeErzeugen.Pixelsize := StrToInt(edt_Pixelsize.Text);
  fQRCodeErzeugen.DoIt;
  Image1.Width := fQRCodeErzeugen.Bitmap.Width;
  Image1.Height := fQRCodeErzeugen.Bitmap.Height;
  Image1.Bitmap.Assign(fQRCodeErzeugen.Bitmap);
  PaintBox.OnPaint := nil;
  {
  TThread.Synchronize(TThread.CurrentThread,
  procedure
  begin
    Memo1.Lines.Text := 'Hallo';
    Memo1.Repaint;
    Layout1.Repaint;
  end);
  }
end;






end.
