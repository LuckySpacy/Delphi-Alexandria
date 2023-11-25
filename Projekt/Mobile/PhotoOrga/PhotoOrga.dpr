program PhotoOrga;

uses
  {$IFDEF MSWINDOWS}
  {$ENDIF MSWINDOWS}
  {$IFDEF ANDROID}
  Objekt.Android.ExifProperty in 'Objekt\Android\Objekt.Android.ExifProperty.pas',
  {$ENDIF ANDROID}
  System.StartUpCopy,
  FMX.Forms,
  Form.PhotoOrga in 'Form\Form.PhotoOrga.pas' {frm_PhotoOrga},
  Objekt.PhotoOrga in 'Objekt\Objekt.PhotoOrga.pas',
  Objekt.ObjektList in 'Objekt\Objekt.ObjektList.pas',
  types.PhotoOrga in 'types\types.PhotoOrga.pas',
  Objekt.Queue in 'Objekt\Objekt.Queue.pas',
  Objekt.QueueList in 'Objekt\Objekt.QueueList.pas',
  Thread.Timer in 'Thread\Thread.Timer.pas',
  Objekt.Aufgaben in 'Objekt\Objekt.Aufgaben.pas',
  Datenmodul.db in 'Datenmodul\Datenmodul.db.pas' {dm_db: TDataModule},
  DB.Basis in 'DB\DB.Basis.pas',
  DB.Basislist in 'DB\DB.Basislist.pas',
  Objekt.Bild in 'Objekt\Objekt.Bild.pas',
  Objekt.BildList in 'Objekt\Objekt.BildList.pas',
  Thread.LadeBildListFromDB in 'Thread\Thread.LadeBildListFromDB.pas',
  Objekt.ReadFiles in 'Objekt\Objekt.ReadFiles.pas',
  Objekt.ReadFilesToDB in 'Objekt\Objekt.ReadFilesToDB.pas',
  Objekt.DatumZeit in 'Objekt\Objekt.DatumZeit.pas',
  Objekt.ExifPropertyTag in 'Objekt\Objekt.ExifPropertyTag.pas',
  Objekt.ExifPropertyTagGPS in 'Objekt\Objekt.ExifPropertyTagGPS.pas',
  Thread.ReadFiles in 'Thread\Thread.ReadFiles.pas',
  Objekt.Alben in 'Objekt\Objekt.Alben.pas',
  Objekt.Album in 'Objekt\Objekt.Album.pas',
  Frame.Album in 'Frame\Frame.Album.pas' {fra_Album: TFrame},
  Form.Base in 'Form\Form.Base.pas' {frm_Base},
  Form.Alben in 'Form\Form.Alben.pas' {frm_Alben},
  Form.Bilder in 'Form\Form.Bilder.pas' {frm_Bilder},
  Form.Bild in 'Form\Form.Bild.pas' {frm_Bild},
  Datenmodul.Bilder in 'Datenmodul\Datenmodul.Bilder.pas' {dm_Bilder: TDataModule},
  Frame.Bild in 'Frame\Frame.Bild.pas' {fra_Bild: TFrame},
  Frame.BildRow in 'Frame\Frame.BildRow.pas' {fra_BildRow: TFrame},
  Form.Fortschritt in 'Form\Form.Fortschritt.pas' {frm_Fortschritt};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tdm_db, dm_db);
  Application.CreateForm(Tdm_Bilder, dm_Bilder);
  Application.CreateForm(Tfrm_PhotoOrga, frm_PhotoOrga);
  Application.Run;
end.
