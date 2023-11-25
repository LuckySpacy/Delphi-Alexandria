unit Frame.Album;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects, FMX.Effects;

type
  Tfra_Album = class(TFrame)
    rec_Image: TRectangle;
    ShadowEffect2: TShadowEffect;
    Image: TImage;
    lbl_Name: TLabel;
    procedure ImageClick(Sender: TObject);
    procedure lbl_NameClick(Sender: TObject);
  private
    fPfad: string;
    fOnAlbumClick: TNotifyEvent;
    fId: string;
    function ErzeugeGuid: string;
  public
    property Pfad: string read fPfad write fPfad;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property OnAlbumClick: TNotifyEvent read fOnAlbumClick write fOnAlbumClick;
    property Id: string read fId;
  end;

implementation

{$R *.fmx}

{ Tfra_Album }

constructor Tfra_Album.Create(AOwner: TComponent);
begin
  inherited;
  fPfad := '';
  fId := ErzeugeGuid;
end;

destructor Tfra_Album.Destroy;
begin //

  inherited;
end;

procedure Tfra_Album.ImageClick(Sender: TObject);
begin
  if Assigned(fOnAlbumClick) then
    fOnAlbumClick(Self);
end;

procedure Tfra_Album.lbl_NameClick(Sender: TObject);
begin
  if Assigned(fOnAlbumClick) then
    fOnAlbumClick(Self);
end;

function Tfra_Album.ErzeugeGuid: string;
var
  GuId: TGUid;
begin //
  CreateGUID(GuId);
  Result := GUIDToString(GuId);
  Result := StringReplace(Result , '{', '', [rfReplaceAll]);
  Result := StringReplace(Result , '}', '', [rfReplaceAll]);
end;

end.
