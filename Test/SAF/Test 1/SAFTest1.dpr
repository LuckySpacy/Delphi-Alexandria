program SAFTest1;

uses
  System.StartUpCopy,
  FMX.Forms,
  Form.SAFTest1 in 'Form.SAFTest1.pas' {Form2},
  Objekt.Android.MessageActivity in 'Objekt\Android\Objekt.Android.MessageActivity.pas',
  Objekt.Android.Uri in 'Objekt\Android\Objekt.Android.Uri.pas',
  Objekt.Android.Konstanten in 'Objekt\Android\Objekt.Android.Konstanten.pas',
  Objekt.ExifPropertyTagGPS in '..\..\Thumbnails\Skalieren\Test 3\Objekt.ExifPropertyTagGPS.pas',
  Objekt.ExifProperty in '..\..\Thumbnails\Skalieren\Test 3\Objekt.ExifProperty.pas',
  Objekt.ExifPropertyTag in '..\..\Thumbnails\Skalieren\Test 3\Objekt.ExifPropertyTag.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
