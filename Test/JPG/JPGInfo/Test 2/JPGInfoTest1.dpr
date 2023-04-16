program JPGInfoTest1;

uses
  System.StartUpCopy,
  FMX.Forms,
  Form.JPGInfoTest1 in 'Form.JPGInfoTest1.pas' {Form2},
  Objekt.Exif in 'Objekt.Exif.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
