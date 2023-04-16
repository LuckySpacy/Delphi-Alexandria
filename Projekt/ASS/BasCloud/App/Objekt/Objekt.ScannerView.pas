unit Objekt.ScannerView;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, FMX.Types, FMX.Objects, Objekt.ScannerPosition,
  FMX.Layouts, FMX.Controls;

type
  TScannerView = class(TFmxObject)
  private
    fLineList: TList;
    fImage: TImage;
    fScannerPos: TScannerPosition;
    //fRec: TRectangle;
    fScannerHeight: Single;
    fScannerWidth: Single;
    fParentObject: TComponent;
    fLineThickness: Single;
    fLineColor: TAlphaColor;
    function AddLine(aLineTyp: TLineType): TLine;
    procedure setScannerHeight(const Value: Single);
    procedure setScannerWidth(const Value: Single);
    procedure setLineThickness(const Value: Single);
    procedure setLineColor(const Value: TAlphaColor);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property ScannerHeight: Single read fScannerHeight write setScannerHeight;
    property ScannerWidth: Single read fScannerWidth write setScannerWidth;
    property LineThickness: Single read fLineThickness write setLineThickness;
    property LineColor: TAlphaColor read fLineColor write setLineColor;
    procedure Aktual;
    function Image: TImage;
  end;

implementation

{ TScanner }


constructor TScannerView.Create(AOwner: TComponent);
begin
  inherited;
  fParentObject := AOwner;
  fLineList := TList.Create;
  fScannerPos := TScannerPosition.Create;

  fLineList.Add(AddLine(TLineType.Left));
  fLineList.Add(AddLine(TLineType.Left));
  fLineList.Add(AddLine(TLineType.Left));
  fLineList.Add(AddLine(TLineType.Left));

  fLineList.Add(AddLine(TLineType.Top));
  fLineList.Add(AddLine(TLineType.Top));
  fLineList.Add(AddLine(TLineType.Top));
  fLineList.Add(AddLine(TLineType.Top));

  {
  fRec := TRectangle.Create(AOwner);
  fRec.Parent := TFMXObject(Self.Owner);
  fRec.Position.X := 20;
  fRec.Position.Y := 20;
  fRec.Visible := true;
  }

  fImage := TImage.Create(AOwner);
  fImage.Parent := TFMXObject(Self.Owner);
  fImage.Position.X := 20;
  fImage.Position.Y := 20;


  setScannerHeight(200);
  setScannerWidth(200);


end;

destructor TScannerView.Destroy;
begin
  FreeAndNil(fScannerPos);
  FreeAndNil(fLineList);
  inherited;
end;


function TScannerView.AddLine(aLineTyp: TLineType): TLine;
begin
  Result := TLine.Create(Self.Owner);
  Result.Parent := TFMXObject(Self.Owner);
  Result.LineType := aLineTyp;
  Result.Position.X := 10;
  Result.Position.Y := 10;
  Result.Width := 50;
  Result.Stroke.Thickness := 5;
  Result.Visible := false;
end;



function TScannerView.Image: TImage;
begin
  Result := fImage;
end;

procedure TScannerView.setScannerHeight(const Value: Single);
begin
  fScannerHeight := Value;
  //fRec.Height := Value;
  fImage.Height := Value;
end;

procedure TScannerView.setScannerWidth(const Value: Single);
begin
  fScannerWidth := Value;
  //fRec.Width := Value;
  fImage.Width := Value;
end;




procedure TScannerView.setLineColor(const Value: TAlphaColor);
var
  i1: Integer;
begin
  fLineColor := Value;
  for i1 := 0 to fLineList.Count -1 do
    TLine(fLineList.Items[i1]).Stroke.Color := Value;
end;

procedure TScannerView.setLineThickness(const Value: Single);
var
  i1: Integer;
begin
  fLineThickness := Value;
  for i1 := 0 to fLineList.Count -1 do
    TLine(fLineList.Items[i1]).Stroke.Thickness := Value;
  fScannerPos.LineThickness := Value;
end;

procedure TScannerView.Aktual;
var
  i1: Integer;
begin
  for i1 := 0 to fLineList.Count -1 do
    TLine(fLineList.Items[i1]).Visible := true;

  fScannerPos.ParentScannerFlaeche.Width  := TControl(fParentObject).Width;
  fScannerPos.ParentScannerFlaeche.Height := TControl(fParentObject).Height;
  fScannerPos.ScannerFlaeche.Width  := fImage.Width;
  fScannerPos.ScannerFlaeche.Height := fImage.Height;
  fScannerPos.LineWidth := TLine(fLineList.Items[0]).Width;
  fScannerPos.Execute;

  //fRec.Position.Y := fScannerPos.ScannerPos.Top;
  //fRec.Position.X := fScannerPos.ScannerPos.Left;

  fImage.Position.Y := fScannerPos.ScannerPos.Top;
  fImage.Position.X := fScannerPos.ScannerPos.Left;


  TLine(fLineList.Items[0]).Position.Y := fScannerPos.LineTopLeftVertikal.Y;
  TLine(fLineList.Items[0]).Position.X := fScannerPos.LineTopLeftVertikal.X;
  TLine(fLineList.Items[1]).Position.Y := fScannerPos.LineTopRightVertikal.Y;
  TLine(fLineList.Items[1]).Position.X := fScannerPos.LineTopRightVertikal.X;
  TLine(fLineList.Items[2]).Position.Y := fScannerPos.LineBottomLeftVertikal.Y;
  TLine(fLineList.Items[2]).Position.X := fScannerPos.LineBottomLeftVertikal.X;
  TLine(fLineList.Items[3]).Position.Y := fScannerPos.LineBottomRightVertikal.Y;
  TLine(fLineList.Items[3]).Position.X := fScannerPos.LineBottomRightVertikal.X;


  TLine(fLineList.Items[4]).Position.Y := fScannerPos.LineTopLeftHorizontal.Y;
  TLine(fLineList.Items[4]).Position.X := fScannerPos.LineTopLeftHorizontal.X;
  TLine(fLineList.Items[5]).Position.Y := fScannerPos.LineTopRightHorizontal.Y;
  TLine(fLineList.Items[5]).Position.X := fScannerPos.LineTopRightHorizontal.X;
  TLine(fLineList.Items[6]).Position.Y := fScannerPos.LineBottomLeftHorizontal.Y;
  TLine(fLineList.Items[6]).Position.X := fScannerPos.LineBottomLeftHorizontal.X;
  TLine(fLineList.Items[7]).Position.Y := fScannerPos.LineBottomRightHorizontal.Y;
  TLine(fLineList.Items[7]).Position.X := fScannerPos.LineBottomRightHorizontal.X;

end;



end.
