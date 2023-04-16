program EXIFTest1;

uses
  System.StartUpCopy,
  FMX.Forms,
  Form.EXIFTest1 in 'Form.EXIFTest1.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
