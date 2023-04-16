unit Objekt.ScannerPosition;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, FMX.Types;

type
  TFlaeche = class
  public
    Width: Single;
    Height: Single;
  End;

type
  TScannerPos = class
    Top: Single;
    Left: Single;
    Right: Single;
    Bottom: Single;
  end;

type
  TLinePos = class
    X: Single;
    Y: Single;
  end;


type
  TScannerPosition = class
  private
    fParentScannerFlaeche: TFlaeche;
    fScannerFlaeche: TFlaeche;
    fScannerPos: TScannerPos;
    fLineWidth: Single;
    fLineTopLeftHorizontalPos: TLinePos;
    fLineTopLeftVertikalPos: TLinePos;
    fLineTopRightHorizontalPos: TLinePos;
    fLineTopRightVertikalPos: TLinePos;
    fLineBottomLeftHorizontalPos: TLinePos;
    fLineBottomLeftVertikalPos: TLinePos;
    fLineBottomRightHorizontalPos: TLinePos;
    fLineBottomRightVertikalPos: TLinePos;
    fLineThickness: Single;
  public
    constructor Create;
    destructor Destroy; override;
    property ParentScannerFlaeche: TFlaeche read fParentScannerFlaeche write fParentScannerFlaeche;
    property ScannerFlaeche: TFlaeche read fScannerFlaeche write fScannerFlaeche;
    property ScannerPos :TScannerPos read fScannerPos write fScannerPos;
    property LineWidth:Single read fLineWidth write fLineWidth;
    property LineThickness:Single read fLineThickness write fLineThickness;
    property LineTopLeftHorizontal: TLinePos read fLineTopLeftHorizontalPos;
    property LineTopLeftVertikal: TLinePos read fLineTopLeftVertikalPos;
    property LineTopRightHorizontal: TLinePos read fLineTopRightHorizontalPos;
    property LineTopRightVertikal: TLinePos read fLineTopRightVertikalPos;
    property LineBottomLeftHorizontal: TLinePos read fLineBottomLeftHorizontalPos;
    property LineBottomLeftVertikal: TLinePos read fLineBottomLeftVertikalPos;
    property LineBottomRightHorizontal: TLinePos read fLineBottomRightHorizontalPos;
    property LineBottomRightVertikal: TLinePos read fLineBottomRightVertikalPos;
    procedure Execute;
  end;



implementation

{ TScannerPosition }

constructor TScannerPosition.Create;
begin
  fParentScannerFlaeche := TFlaeche.Create;
  fScannerFlaeche := TFlaeche.Create;
  fScannerPos := TScannerPos.Create;
  fLineTopLeftHorizontalPos := TLinePos.Create;
  fLineTopLeftVertikalPos   := TLinePos.Create;
  fLineTopRightHorizontalPos := TLinePos.Create;
  fLineTopRightVertikalPos   := TLinePos.Create;
  fLineBottomLeftHorizontalPos := TLinePos.Create;
  fLineBottomLeftVertikalPos   := TLinePos.Create;
  fLineBottomRightHorizontalPos := TLinePos.Create;
  fLineBottomRightVertikalPos   := TLinePos.Create;

  fLineWidth := 50;
  fLineThickness := 5;
end;

destructor TScannerPosition.Destroy;
begin
  FreeAndNil(fParentScannerFlaeche);
  FreeAndNil(fScannerFlaeche);
  FreeAndNil(fScannerPos);
  FreeAndNil(fLineTopLeftHorizontalPos);
  FreeAndNil(fLineTopLeftVertikalPos);
  FreeAndNil(fLineTopRightHorizontalPos);
  FreeAndNil(fLineTopRightVertikalPos);
  FreeAndNil(fLineBottomLeftHorizontalPos);
  FreeAndNil(fLineBottomLeftVertikalPos);
  FreeAndNil(fLineBottomRightHorizontalPos);
  FreeAndNil(fLineBottomRightVertikalPos);
  inherited;
end;

procedure TScannerPosition.Execute;
var
  ParentHochHalbe: Single;
  ParentBreitHalbe: Single;
  ScannerHochHalbe: Single;
  ScannerBreitHalbe: Single;
begin
  ParentHochHalbe  := trunc(fParentScannerFlaeche.Height/2);
  ParentBreitHalbe := trunc(fParentScannerFlaeche.Width/2);
  ScannerHochHalbe  := trunc(fScannerFlaeche.Height/2);
  ScannerBreitHalbe := trunc(fScannerFlaeche.Width/2);
  fScannerPos.Top  := ParentHochHalbe - ScannerHochHalbe;
  fScannerPos.Left := ParentBreitHalbe - ScannerBreitHalbe;
  fScannerPos.Right := fScannerPos.Left + fScannerFlaeche.Width;
  fScannerPos.Bottom := fScannerPos.Top + fScannerFlaeche.Height;

  fLineTopLeftHorizontalPos.X := fScannerPos.Left - fLineThickness;
  fLineTopLeftHorizontalPos.Y := fScannerPos.Top - fLineThickness;

  fLineTopLeftVertikalPos.Y := fLineTopLeftHorizontalPos.Y;
  fLineTopLeftVertikalPos.X := fScannerPos.Left - fLineThickness;

  fLineTopRightHorizontalPos.X := fScannerPos.Right - fLineWidth + fLineThickness;
  fLineTopRightHorizontalPos.Y :=  fLineTopLeftHorizontalPos.Y;

  fLineTopRightVertikalPos.Y := fLineTopRightHorizontalPos.Y ;
  fLineTopRightVertikalPos.X := fScannerPos.Right + fLineThickness;


  fLineBottomLeftHorizontalPos.X := fScannerPos.Left - fLineThickness;
  fLineBottomLeftHorizontalPos.Y := fScannerPos.Bottom + fLineThickness;

  fLineBottomLeftVertikalPos.Y := fScannerPos.Bottom - fLineWidth + fLineThickness;
  fLineBottomLeftVertikalPos.X := fScannerPos.Left - fLineThickness;


  fLineBottomRightHorizontalPos.X := fScannerPos.Right - fLineWidth + fLineThickness;
  fLineBottomRightHorizontalPos.Y := fLineBottomLeftHorizontalPos.Y;

  fLineBottomRightVertikalPos.Y := fScannerPos.Bottom - fLineWidth + fLineThickness;
  fLineBottomRightVertikalPos.X := fLineTopRightVertikalPos.X;



end;



end.
