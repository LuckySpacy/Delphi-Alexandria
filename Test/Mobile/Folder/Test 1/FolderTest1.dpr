program FolderTest1;

uses
  System.StartUpCopy,
  FMX.Forms,
  Form.FolderTest1 in 'Form.FolderTest1.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
