program TabSlideTest1;

uses
  System.StartUpCopy,
  FMX.Forms,
  Form.TabSlideTest1 in 'Form.TabSlideTest1.pas' {Form3};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
