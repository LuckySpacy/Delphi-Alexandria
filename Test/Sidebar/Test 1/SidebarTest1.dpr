program SidebarTest1;

uses
  System.StartUpCopy,
  FMX.Forms,
  Form.SidebarTest1 in 'Form.SidebarTest1.pas' {frm_SidebarTest1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tfrm_SidebarTest1, frm_SidebarTest1);
  Application.Run;
end.
