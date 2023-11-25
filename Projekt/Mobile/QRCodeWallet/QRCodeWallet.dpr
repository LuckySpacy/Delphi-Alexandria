program QRCodeWallet;

uses
  System.StartUpCopy,
  FMX.Forms,
  Form.QRCodeWallet in 'Form\Form.QRCodeWallet.pas' {frm_QRCodeWallet},
  Datenmodul.dm in 'Datenmodul\Datenmodul.dm.pas' {dm: TDataModule},
  Datenmodul.Bilder in 'Datenmodul\Datenmodul.Bilder.pas' {Bilder: TDataModule},
  Frame.Main in 'Frame\Frame.Main.pas' {fra_Main: TFrame},
  Frame.Base in 'Frame\Frame.Base.pas' {fra_Base: TFrame},
  Frame.NeuBibliothek in 'Frame\Frame.NeuBibliothek.pas' {fra_AddBibliothek: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(TBilder, Bilder);
  Application.CreateForm(Tfrm_QRCodeWallet, frm_QRCodeWallet);
  Application.Run;
end.
