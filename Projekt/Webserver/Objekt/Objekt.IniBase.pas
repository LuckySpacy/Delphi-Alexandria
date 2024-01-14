unit Objekt.IniBase;

interface

uses
  IniFiles, SysUtils, Types, Registry, Variants, Windows, Classes,
  Objekt.Ini, Objekt.Folderlocation, Types.Folder;

type
  TIniBase = class(TIni)
  private
    fFolderlocation: TFolderlocation;
  protected
    fSection: string;
    fPfad: string;
    fIniFullname: string;
  public
    constructor Create; override;
    destructor Destroy; override;
    property Section: string read fSection write fSection;
  end;

implementation

{ TIniBase }

constructor TIniBase.Create;
begin
  inherited;
  fFolderlocation := TFolderlocation.Create(cCSIDL_APPDATA);
  fPfad := IncludeTrailingPathDelimiter(fFolderlocation.GetShellFolder) + 'Webservice\';
  if not DirectoryExists(fPfad) then
    ForceDirectories(fPfad);
  fIniFullName := fPfad + 'Webservice.Ini';
end;

destructor TIniBase.Destroy;
begin
  FreeAndNil(fFolderlocation);
  inherited;
end;


end.
