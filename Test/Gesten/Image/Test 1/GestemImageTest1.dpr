program GestemImageTest1;

uses
  System.StartUpCopy,
  FMX.Forms,
  Form.GestemImageTest1 in 'Form.GestemImageTest1.pas' {Form3},
  Objekt.Android.Permissions in 'Objekt.Android.Permissions.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
