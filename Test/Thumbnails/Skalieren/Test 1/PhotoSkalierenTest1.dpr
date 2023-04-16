program PhotoSkalierenTest1;

uses
  System.StartUpCopy,
  FMX.Forms,
  Form.PhotoSkalierenTest1 in 'Form.PhotoSkalierenTest1.pas' {frm_PhotoSkalieren},
  Form.Image in 'Form.Image.pas' {frm_Image},
  Objekt.PhotoShrink in 'Objekt.PhotoShrink.pas',
  Form.ListView in 'Form.ListView.pas' {frm_Listview};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tfrm_PhotoSkalieren, frm_PhotoSkalieren);
  Application.CreateForm(Tfrm_Listview, frm_Listview);
  Application.Run;
end.
