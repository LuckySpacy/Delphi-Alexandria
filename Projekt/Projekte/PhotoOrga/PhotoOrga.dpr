program PhotoOrga;

uses
  {$IFDEF MSWINDOWS}
  FastMM5 in '..\..\Komponenten\FastMM5\FastMM5.pas',
  {$ENDIF MSWINDOWS}
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
  Datenmodul.db in 'Datenmodul\Datenmodul.db.pas' {dm_db: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tdm_db, dm_db);
  Application.CreateForm(Tfrm_PhotoOrga, frm_PhotoOrga);
  Application.Run;
end.
