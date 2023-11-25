unit Objekt.Album;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types;

type
  TAlbum = class
  private
    fId: string;
    fAlbumname: string;
    fAlbumBilder: TList;
    fPfad: string;
  protected
  public
    constructor Create;
    destructor Destroy; override;
    property Albumname: string read fAlbumname write fAlbumname;
    property Pfad: string read fPfad write fPfad;
    property Id: string read fId write fId;
    property AlbumBilder: TList read fAlbumBilder write fAlbumBilder;
    function Count: Integer;
  end;

implementation

{ TAlbum }

function TAlbum.Count: Integer;
begin
  Result :=  fAlbumBilder.Count;
end;

constructor TAlbum.Create;
begin
  fAlbumBilder := TList.Create;
  fId := '';
  fAlbumname := '';
  fPfad := '';
end;

destructor TAlbum.Destroy;
begin
  FreeAndNil(fAlbumBilder);
  inherited;
end;

end.
