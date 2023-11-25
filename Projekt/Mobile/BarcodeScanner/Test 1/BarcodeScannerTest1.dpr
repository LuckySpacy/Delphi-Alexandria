program BarcodeScannerTest1;

uses
  System.StartUpCopy,
  FMX.Forms,
  Form.BarcodeScannerTest1 in 'Form.BarcodeScannerTest1.pas' {Form3},
  Objekt.ScannerView in 'Objekt\Objekt.ScannerView.pas',
  Objekt.ScannerPosition in 'Objekt\Objekt.ScannerPosition.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
