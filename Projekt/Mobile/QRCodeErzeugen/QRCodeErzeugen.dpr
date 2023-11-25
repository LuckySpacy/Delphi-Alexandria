program QRCodeErzeugen;

uses
  System.StartUpCopy,
  FMX.Forms,
  Form.QRCodeErzeugen in 'Form\Form.QRCodeErzeugen.pas' {frm_QRCodeErzeugen},
  Objekt.QRCodeErzeugen in 'Objekt\Objekt.QRCodeErzeugen.pas',
  DelphiZXIngQRCode in 'ZXing\DelphiZXIngQRCode.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tfrm_QRCodeErzeugen, frm_QRCodeErzeugen);
  Application.Run;
end.
