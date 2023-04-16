program PhotoOrga_alt;

uses
  {$IFDEF WIN32}
  FastMM5 in '..\..\Komponenten\FastMM5\FastMM5.pas',
  {$ENDIF }
  System.StartUpCopy,
  FMX.Forms,
  Form.PhotoOrga in 'Form\Form.PhotoOrga.pas' {frm_PhotoOrga},
  Form.Alben in 'Form\Form.Alben.pas' {frm_Alben},
  Frame.Album in 'Frame\Frame.Album.pas' {fra_Album: TFrame},
  Form.Bilder in 'Form\Form.Bilder.pas' {frm_Bilder},
  Form.Base in 'Form\Form.Base.pas' {frm_Base},
  Datenmodul.Bilder in 'Datenmodul\Datenmodul.Bilder.pas' {dm_Bilder: TDataModule},
  Frame.ImageListBox in 'Frame\Frame.ImageListBox.pas' {fra_ImageListBox: TFrame},
  Datenmodul.db in 'Datenmodul\Datenmodul.db.pas' {dm_db: TDataModule},
  DB.Basis in 'DB\DB.Basis.pas',
  DB.Basislist in 'DB\DB.Basislist.pas',
  Objekt.ObjektList in 'Objekt\Objekt.ObjektList.pas',
  DB.Bilder in 'DB\DB.Bilder.pas',
  Thread.Timer in 'Thread\Thread.Timer.pas',
  Objekt.Aufgaben in 'Objekt\Objekt.Aufgaben.pas',
  Thread.AktualThumbnails in 'Thread\Thread.AktualThumbnails.pas',
  Objekt.PhotoOrga in 'Objekt\Objekt.PhotoOrga.pas',
  DB.BilderList in 'DB\DB.BilderList.pas',
  Form.Bilder2 in 'Form\Form.Bilder2.pas' {frm_Bilder2},
  types.PhotoOrga in 'types\types.PhotoOrga.pas',
  Form.Bild in 'Form\Form.Bild.pas' {frm_Bild},
  Objekt.DatumZeit in 'Objekt\Objekt.DatumZeit.pas',
  Objekt.Queue in 'Objekt\Objekt.Queue.pas',
  Objekt.QueueList in 'Objekt\Objekt.QueueList.pas',
  Objekt.Bild in 'Objekt\Objekt.Bild.pas',
  Objekt.BildList in 'Objekt\Objekt.BildList.pas',
  Objekt.BilderList in 'Objekt\Objekt.BilderList.pas',
  Objekt.AlbenPfad in 'Objekt\Objekt.AlbenPfad.pas',
  Objekt.AlbenPfadList in 'Objekt\Objekt.AlbenPfadList.pas',
  Thread.AktualBildObjekt in 'Thread\Thread.AktualBildObjekt.pas',
  Form.Splash in 'Form\Form.Splash.pas' {frm_Splash},
  Frame.Bild in 'Frame\Frame.Bild.pas' {fra_Bild: TFrame},
  Form.Bilder3 in 'Form\Form.Bilder3.pas' {frm_Bilder3},
  Objekt.fraBildList in 'Objekt\Objekt.fraBildList.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tdm_db, dm_db);
  Application.CreateForm(Tdm_Bilder, dm_Bilder);
  Application.CreateForm(Tfrm_PhotoOrga, frm_PhotoOrga);
  Application.Run;
end.
