unit Form.Bilder;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, Form.Base,
  FMX.ImgList, FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls,
  Datenmodul.Bilder, Frame.ImageListBox, FMX.Layouts, DB.Bilder, DB.BilderList,
  types.PhotoOrga;

type
  Tfrm_Bilder = class(Tfrm_Base)
    Rec_Toolbar_Background: TRectangle;
    gly_Back: TGlyph;
    lay_ImageListBox: TLayout;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    fImageListBox: Tfra_ImageListBox;
    fDBBilderList: TDBBilderList;
    fOnBildClick: TBildClickEvent;
    fBildList: TList;
  public
    procedure LadeBilder(aDir: string; AMask: string = '*.*');
    procedure setActiv; override;
    property OnBildClick: TBildClickEvent read fOnBildClick write fOnBildClick;
  end;

var
  frm_Bilder: Tfrm_Bilder;

implementation

{$R *.fmx}

uses
  Objekt.PhotoOrga;



procedure Tfrm_Bilder.FormCreate(Sender: TObject);
begin  //
  gly_Back.HitTest := true;
  gly_Back.OnClick := GoBack;
  fImageListBox := Tfra_ImageListBox.Create(Self);
  fImageListBox.Parent := lay_ImageListBox;
  fImageListBox.Align := TAlignLayout.Client;
  fDBBilderList := TDBBilderList.Create;
  fDBBilderList.Connection := PhotoOrga.Connection;
end;

procedure Tfrm_Bilder.FormDestroy(Sender: TObject);
begin //
  FreeAndNil(fDBBilderList);
end;


procedure Tfrm_Bilder.LadeBilder(aDir, AMask: string);
begin //
  fImageListBox.ShowFilesInFolder2(aDir);
//  fDBBilderList.ReadDir(aDir);
end;

(*
procedure Tfrm_Bilder.LadeBilder(aDir, AMask: string);
var
  DBBilder: TDBBilder;
  TI: TBitmap;
  Stream: TMemoryStream;
begin
  fImageListBox.ShowFilesInFolder(aDir, aMask);
  DBBilder := TDBBilder.Create;
  TI := TBitmap.create;
  Stream := TMemoryStream.Create;
  try
    DBBilder.Pfad := 'D:\Bachmann\Daten\OneDrive\Bilder\';
    DBBilder.Bildname := 'IMG_20211106_121234.jpg';

    TI.LoadThumbnailFromFile(DBBilder.Pfad + DBBilder.Bildname, 100, 100);
    //TI.LoadFromFile(DBBilder.Pfad + DBBilder.Bildname);
    //TI.CreateThumbnail(round (50), Round (50));
    TI.SaveToStream(Stream);
    DBBilder.setShortImage(Stream);
    DBBilder.Insert;

  finally
    FreeAndNil(DBBilder);
    FreeAndNil(Stream);
    FreeAndNil(TI);
  end;

end;
*)

procedure Tfrm_Bilder.setActiv;
begin //
  inherited;

end;

end.
