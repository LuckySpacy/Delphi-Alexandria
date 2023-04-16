program ThumbnailTest3;

uses
  System.StartUpCopy,
  FMX.Forms,
  Form.ThumbnailTest3 in 'Form.ThumbnailTest3.pas' {Form2},
  Objekt.ExifProperty in 'Objekt.ExifProperty.pas',
  Objekt.ExifPropertyTag in 'Objekt.ExifPropertyTag.pas',
  Objekt.ExifPropertyTagGPS in 'Objekt.ExifPropertyTagGPS.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
