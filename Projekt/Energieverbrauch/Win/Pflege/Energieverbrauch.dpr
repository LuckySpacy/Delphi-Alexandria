program Energieverbrauch;

uses
  FastMM4 in '..\..\..\Log4d\FastMM\FastMM4.pas',
  FastMM4Messages in '..\..\..\Log4d\FastMM\Translations\German\by Thomas Speck\FastMM4Messages.pas',
  Log4D in '..\..\..\Log4d\Log4D.pas',
  Vcl.Forms,
  Form.Energieverbrauch in 'Form\Form.Energieverbrauch.pas' {frm_Energieverbrauch},
  Form.Base in 'Form\Form.Base.pas' {frm_Base},
  Objekt.Logger in 'Objekt\Objekt.Logger.pas',
  Objekt.IniBase in 'Objekt\Objekt.IniBase.pas',
  Objekt.Ini in '..\..\..\Allgemein\Vcl\Objekt\Objekt.Ini.pas',
  Types.Folder in '..\..\..\Allgemein\Vcl\Types\Types.Folder.pas',
  Objekt.Folderlocation in '..\..\..\Allgemein\Vcl\Objekt\Objekt.Folderlocation.pas',
  Objekt.IniEinstellung in 'Objekt\Objekt.IniEinstellung.pas',
  Objekt.IniEnergieverbrauch in 'Objekt\Objekt.IniEnergieverbrauch.pas',
  Form.Main in 'Form\Form.Main.pas' {frm_Main},
  Objekt.Energieverbrauch in 'Objekt\Objekt.Energieverbrauch.pas',
  Form.HostEinstellung in 'Form\Form.HostEinstellung.pas' {frm_Hosteinstellung},
  Datenmodul.Bilder in 'Datenmodul\Datenmodul.Bilder.pas' {dm_Bilder: TDataModule},
  Datenmodul.Rest in 'Datenmodul\Datenmodul.Rest.pas' {dm_Rest: TDataModule};

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tfrm_Energieverbrauch, frm_Energieverbrauch);
  Application.CreateForm(Tdm_Bilder, dm_Bilder);
  Application.CreateForm(Tdm_Rest, dm_Rest);
  Application.Run;
end.
