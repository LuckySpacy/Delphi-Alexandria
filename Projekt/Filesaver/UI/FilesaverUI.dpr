program FilesaverUI;

uses
  Vcl.Forms,
  Form.FilesaveUI in 'Form\Form.FilesaveUI.pas' {frm_Filesaver},
  Form.Main in 'Form\Form.Main.pas' {frm_Main},
  Objekt.IniBase in '..\Allgemein\Objekt\Objekt.IniBase.pas',
  Objekt.Ini in '..\..\Allgemein\Vcl\Objekt\Objekt.Ini.pas',
  Objekt.Folderlocation in '..\..\Allgemein\Vcl\Objekt\Objekt.Folderlocation.pas',
  Objekt.Allg in '..\..\Allgemein\Vcl\Objekt\Objekt.Allg.pas',
  Objekt.ObjektList in '..\..\Allgemein\Vcl\Objekt\Objekt.ObjektList.pas',
  Objekt.Basislist in '..\..\Allgemein\Vcl\Objekt\Objekt.Basislist.pas',
  Types.Folder in '..\..\Allgemein\Vcl\Types\Types.Folder.pas',
  Objekt.Logger in '..\Allgemein\Objekt\Objekt.Logger.pas',
  Log4D in '..\..\..\Komponenten\Log4d\Log4D.pas',
  Objekt.IniEinstellung in '..\Allgemein\Objekt\Objekt.IniEinstellung.pas',
  Objekt.Filesaver in '..\Allgemein\Objekt\Objekt.Filesaver.pas',
  Form.FileOption in 'Form\Form.FileOption.pas' {frm_FileOption};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tfrm_Filesaver, frm_Filesaver);
  Application.Run;
end.
