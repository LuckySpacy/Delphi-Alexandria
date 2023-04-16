unit Objekt.IBDIniList;

interface

uses
  System.SysUtils, System.Classes, Objekt.Basislist, Objekt.IBDIni;

type
  TIBDIniList = class(TBasisList)
  private
    fIniPfad: string;
    function getItem(Index: Integer): TIBDIni;
  public
    constructor Create; override;
    destructor Destroy; override;
    property Item[Index: Integer]: TIBDIni read getItem;
    function Add(aName: string): TIBDIni;
    function getByName(aName: string): TIBDIni;
    property IniPfad: string read fIniPfad write fIniPfad;
  end;

implementation

{ TIBDIniList }


constructor TIBDIniList.Create;
begin
  inherited;

end;

destructor TIBDIniList.Destroy;
begin

  inherited;
end;

function TIBDIniList.getItem(Index: Integer): TIBDIni;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TIBDIni(fList.Items[Index]);
end;

function TIBDIniList.Add(aName: string): TIBDIni;
begin
  Result := getByName(aName);
  if Result <> nil then
    exit;
  Result := TIBDIni.Create;
  Result.IniPfad := fIniPfad;
  Result.Name := aName;
  fList.Add(Result);
end;


function TIBDIniList.getByName(aName: string): TIBDIni;
var
  i1: Integer;
begin
  Result := nil;
  if aName = '' then
    exit;
  for i1 := 0 to fList.Count -1 do
  if SameText(aName, TIBDIni(fList.Items[i1]).name) then
  begin
    Result := TIBDIni(fList.Items[i1]);
    exit;
  end;
end;


end.
