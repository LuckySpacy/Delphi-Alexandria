program BarcodescannerTest2;

uses
  System.StartUpCopy,
  FMX.Forms,
  Form.BarcodescannerTest2 in 'Form\Form.BarcodescannerTest2.pas' {Form2},
  Objekt.ScannerView in 'Objekt\Objekt.ScannerView.pas',
  Objekt.ScannerPosition in 'Objekt\Objekt.ScannerPosition.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
