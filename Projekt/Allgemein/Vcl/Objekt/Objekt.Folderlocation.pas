unit Objekt.Folderlocation;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, shlobj, ActiveX;


type
  TFolderlocation = class
  private
    fCSIDL: Integer;
    function PathFromIDList(Pidl: PItemIdList): WideString;
  public
    constructor Create(CSIDL: Integer);
    destructor Destroy; override;
    property CSIDL: Integer read fCSIDL write fCSIDL;
    function GetShellFolder: WideString;
    function GetFolder(aCSIDL: Integer): string;
  end;

implementation

{ TFolderlocation }

function SHGetFolderLocation(hwndOwnder: THandle; nFolder: Integer; hToken: THandle; dwReserved: DWORD; ppidl:
  PItemIdList): HRESULT; stdcall; external 'shell32.dll' name 'SHGetFolderLocation';
function SHGetPathFromIDListW(Pidl: PItemIDList; pszPath: PWideChar): BOOL; stdcall; external 'shell32.dll'
name 'SHGetPathFromIDListW';

resourcestring
  rsE_GetPathFromIDList = 'Ordner kann nicht ermittelt werden';
  rsE_S_FALSE = 'Ordner existiert nicht';
  rsE_InvalidArgument = 'Argument ungültig';

constructor TFolderlocation.Create(CSIDL: Integer);
begin
  fCSIDL := CSIDL;
end;

destructor TFolderlocation.Destroy;
begin

  inherited;
end;


function TFolderlocation.GetFolder(aCSIDL: Integer): string;
var
  Folder : TFolderlocation;
begin
  Folder := TFolderlocation.Create(aCSIDL);
  try
    try
      Result := Folder.GetShellFolder;
    except
      Result := 'Invalid';
      raise;
    end;
  finally
    FreeAndNil(Folder);
  end;
end;

function TFolderlocation.GetShellFolder: WideString;
var
  ppidl: PItemIdList;
begin
  try
    case SHGetFolderLocation(0, fCSIDL, 0, 0, @ppidl) of
      S_OK: Result := trim(PathFromIDList(ppidl));
      S_FALSE: raise Exception.Create(rsE_S_FALSE);
      E_INVALIDARG: raise Exception.Create(rsE_InvalidArgument);
    end;
  finally
    CoTaskMemFree(ppidl);
  end;
end;

function TFolderlocation.PathFromIDList(Pidl: PItemIdList): WideString;
const
  NTFS_MAX_PATH = 32767;
var
  Path: PWideChar;
begin
  GetMem(Path, (NTFS_MAX_PATH + 1) * 2);
  try
    if not SHGetPathFromIDListW(Pidl, Path) then
    begin
      FreeMem(Path);
      raise Exception.Create(rsE_GetPathFromIDList);
    end;
    Result := WideString(Path);
  finally
    FreeMem(Path);
  end;
end;


end.
