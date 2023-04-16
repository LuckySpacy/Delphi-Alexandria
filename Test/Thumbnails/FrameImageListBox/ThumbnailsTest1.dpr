program ThumbnailsTest1;

uses
  System.StartUpCopy,
  FMX.Forms,
  Form.ThumbnailsTest1 in 'Form.ThumbnailsTest1.pas' {Form2},
  FrameImageListbox in 'FrameImageListbox.pas' {Fr_ImageListbox: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
