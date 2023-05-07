unit Objekt.Alben;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, Objekt.Album, Frame.Album;

type
  TAlben = class
  private
    fList: TList;
    function getAlbum(Index: Integer): TAlbum;
  protected
  public
    constructor Create;
    destructor Destroy; override;
    function getAlbumByName(aAlbumname: string): TAlbum;
    function Add: TAlbum;
    property Item[Index: Integer]: TAlbum read getAlbum;
    function Count: Integer;
  end;

implementation

{ TAlben }


function TAlben.Count: Integer;
begin
  Result := fList.Count;
end;

constructor TAlben.Create;
begin
  fList := TList.Create;
end;

destructor TAlben.Destroy;
begin
  FreeAndNil(fList);
  inherited;
end;

function TAlben.getAlbum(Index: Integer): TAlbum;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TAlbum(fList.Items[Index]);
end;

function TAlben.getAlbumByName(aAlbumname: string): TAlbum;
var
  i1: Integer;
begin
  Result := nil;
  for i1 := 0 to fList.Count -1 do
  begin
    if SameText(aAlbumname, TAlbum(fList.Items[i1]).Albumname) then
    begin
      Result := TAlbum(fList.Items[i1]);
      exit;
    end;
  end;

end;


function TAlben.Add: TAlbum;
begin
  Result := TAlbum.Create;
  fList.Add(Result);
end;


end.
