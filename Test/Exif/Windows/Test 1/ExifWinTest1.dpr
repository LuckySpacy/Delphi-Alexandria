program ExifWinTest1;

uses
  System.StartUpCopy,
  FMX.Forms,
  Form.ExifWinTest1 in 'Form.ExifWinTest1.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
