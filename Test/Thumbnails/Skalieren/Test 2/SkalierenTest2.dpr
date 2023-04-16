program SkalierenTest2;

uses
  System.StartUpCopy,
  FMX.Forms,
  Form.SkalierenTest2 in 'Form.SkalierenTest2.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
