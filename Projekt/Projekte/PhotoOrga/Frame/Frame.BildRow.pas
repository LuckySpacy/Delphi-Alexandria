unit Frame.BildRow;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  Frame.Bild, Objekt.BildList, Objekt.Bild, Objekt.Album, types.PhotoOrga;

type
  Tfra_BildRow = class(TFrame)
  private
    fFrameBildList: TList;
    fOnBildClick: TNotifyStrEvent;
    procedure ErzeugeBildRow;
    function ErzeugeFrameBild(aIndex: Integer): Tfra_Bild;
    function getFrameBild(aIndex: Integer): Tfra_Bild;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure LadeBilderRow(aAlbum: TAlbum; var aIndex: Integer);
    property OnBildClick: TNotifyStrEvent read fOnBildClick write fOnBildClick;
    procedure BildClick(aValue: string);
  end;

implementation

{$R *.fmx}

{ TFrame1 }

uses
  Objekt.PhotoOrga;


constructor Tfra_BildRow.Create(AOwner: TComponent);
begin //
  inherited;
  fFrameBildList := TList.Create;
end;

destructor Tfra_BildRow.Destroy;
begin   //
  FreeAndNil(fFrameBildList);
  inherited;
end;

procedure Tfra_BildRow.ErzeugeBildRow;
var
  frameBild: TFra_Bild;
  i1: Integer;
begin
  fFrameBildList.Clear;
  for i1 := 1 to 4 do
  begin
    ErzeugeFrameBild(i1);
  end;
end;


function Tfra_BildRow.ErzeugeFrameBild(aIndex: Integer): Tfra_Bild;
begin
  Result := TFra_Bild.Create(Self);
  Result.Name := 'Img' + aIndex.ToString;
  Result.Align := TAlignLayout.Left;
  Result.Tag := aIndex;
  Result.Parent := Self;
  Result.Width := 100;
  Result.OnBildClick := BildClick;
  fFrameBildList.Add(Result);
end;


function Tfra_BildRow.getFrameBild(aIndex: Integer): Tfra_Bild;
var
  i1: Integer;
begin
  for i1 := 0 to fFrameBildList.Count -1 do
  begin
    if Tfra_Bild(fFrameBildList.Items[i1]).Tag = aIndex then
    begin
      Result := Tfra_Bild(fFrameBildList.Items[i1]);
      exit;
    end;
  end;
  Result := ErzeugeFrameBild(aIndex);
end;

procedure Tfra_BildRow.LadeBilderRow(aAlbum: TAlbum; var aIndex: Integer);
var
  i1: Integer;
  fraBild: Tfra_Bild;
  Bild: TBild;
begin
  i1 := 0;
  while aIndex < aAlbum.AlbumBilder.count do
  begin
    inc(i1);
    if i1 > 4 then
      break;
    fraBild := getFrameBild(i1);
    Bild := TBild(aAlbum.AlbumBilder.Items[aIndex]);
    fraBild.Image.Bitmap.Assign(Bild.Thumb);
    fraBild.Bild := Bild;
    inc(aIndex);
  end;
end;


procedure Tfra_BildRow.BildClick(aValue: string);
begin
  if Assigned(fOnBildClick) then
    fOnBildClick(aValue);
end;


end.
