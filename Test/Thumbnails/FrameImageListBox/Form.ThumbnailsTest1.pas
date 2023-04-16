unit Form.ThumbnailsTest1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FrameImageListbox, FMX.Objects,
  FMX.Edit;

type
  TForm2 = class(TForm)
    pnl_Listbox: TPanel;
    Panel1: TPanel;
    btn_LoadImage: TButton;
    edt_Pfad: TEdit;
    Img: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btn_LoadImageClick(Sender: TObject);
  private
    fFormListBox: TFr_ImageListbox;
  public
  end;

var
  Form2: TForm2;

implementation

{$R *.fmx}




procedure TForm2.FormCreate(Sender: TObject);
begin //
  fFormListBox := TFr_ImageListbox.Create(Self);
  fFormListBox.Parent := pnl_Listbox;
  fFormListBox.Align := TAlignLayout.Client;
  edt_Pfad.Text := 'd:\Bachmann\Daten\OneDrive\Asus-PC-2018\Bilder\Camera Original\Camera\';
end;

procedure TForm2.FormDestroy(Sender: TObject);
begin  //

end;

procedure TForm2.btn_LoadImageClick(Sender: TObject);
begin
  fFormListBox.ShowFilesInFolder(edt_Pfad.Text);
end;


end.
