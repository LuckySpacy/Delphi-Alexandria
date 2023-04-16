unit Form.JPGInfoTest1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, Objekt.Exif;

type
  TForm2 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form2: TForm2;

implementation

{$R *.fmx}

procedure TForm2.Button1Click(Sender: TObject);
var
  Exif: TExif;
  Filename: string;
begin
  Filename := IncludeTrailingBackslash(ExtractFilePath(ParamStr(0)));
  Filename := Filename + 'Test1.jpg';
  Exif := TExif.Create;
  try
    Exif.ReadFromFile(Filename);
  finally
    FreeAndNil(Exif);
  end;

end;

end.
