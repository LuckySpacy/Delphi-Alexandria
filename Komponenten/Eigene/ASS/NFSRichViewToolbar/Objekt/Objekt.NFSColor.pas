unit Objekt.NFSColor;

interface

uses
  SysUtils, Classes, Graphics;

type
  TNFSColorObj = class
  private
    fColorList: TStringList;
    procedure LoadColorList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Init;
    function ColorToStr(aColor: TColor): string;
  //published
  end;

implementation

{ TNFSColorObj }


constructor TNFSColorObj.Create;
begin
  fColorList := TStringList.Create;
  Init;
end;

destructor TNFSColorObj.Destroy;
begin
  FreeAndNil(fColorList);
  inherited;
end;

procedure TNFSColorObj.Init;
begin
  LoadColorList;
end;

procedure TNFSColorObj.LoadColorList;
begin
  fColorList.Clear;
  fColorList.Add('clAqua=Aquamarin');
  fColorList.Add('clBlack=Schwarz');
  fColorList.Add('clBlue=Blau');
  fColorList.Add('clCream=Creme');
  fColorList.Add('clDkGray=Dunkelgrau');
  fColorList.Add('clFuchsia=Magenta');
  fColorList.Add('clGray=Grau');
  fColorList.Add('clGreen=Gr�n');
  fColorList.Add('clLime=Limonengr�n');
  fColorList.Add('clLtGrau=Hellgrau');
  fColorList.Add('clMaroon=Braun');
  fColorList.Add('clMedGray=Mittelgrau');
  fColorList.Add('clMoneyGreen=Mintgr�n');
  fColorList.Add('clMedGray=Mittelgrau');
  fColorList.Add('clMoneyGreen=Mintgr�n');
  fColorList.Add('clNavy=Marineblau');
  fColorList.Add('clOlive=Olivgr�n');
  fColorList.Add('clPurple=Purpur');
  fColorList.Add('clRed=Rot');
  fColorList.Add('clSilver=Silber');
  fColorList.Add('clSkyBlue=Himmelblau');
  fColorList.Add('clTeal=Gr�nblau');
  fColorList.Add('clWhite=Wei�');
  fColorList.Add('clYellow=Gelb');
end;

function TNFSColorObj.ColorToStr(aColor: TColor): string;
begin
  Result := ColorToString(aColor);
  Result := fColorList.Values[Result];
  if Result = '' then
    Result := ColorToString(aColor);
end;

end.
