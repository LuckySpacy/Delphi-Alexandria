unit Objekt.Ini;

interface

uses
  IniFiles, SysUtils, Types, Variants, Classes;

type
  TtbRootKey = (HKEY_CLASSES_ROOT_, HKEY_CURRENT_USER_, HKEY_LOCAL_MACHINE_,
                HKEY_USERS_, HKEY_PERFORMANCE_DATA_, HKEY_CURRENT_CONFIG_,
                HKEY_DYN_DATA_);

type
  TIni = class
  private
  protected
  public
    constructor Create; Virtual;
    destructor Destroy; override;
    function  ReadIni(const aFullFileName, aSection, aKey: String; aDefault: String): String;
    procedure WriteIni(const aFullFileName, aSection, aKey: String; aValue: String);
  end;

implementation

{ TIni }

constructor TIni.Create;
begin

end;

destructor TIni.Destroy;
begin

  inherited;
end;

function TIni.ReadIni(const aFullFileName, aSection, aKey: String;
  aDefault: String): String;
var
  INI: TIniFile;
begin
  INI := TIniFile.Create(aFullFileName);
  try
    Result := INI.ReadString(aSection, aKey, aDefault);
  finally
    FreeAndNil(INI);
  end;
end;

procedure TIni.WriteIni(const aFullFileName, aSection, aKey: String;
  aValue: String);
var
  INI: TIniFile;
begin
  INI := TIniFile.Create(aFullFileName);
  try
    INI.WriteString(aSection, aKey, aValue);
  finally
    FreeAndNil(INI);
  end;
end;

end.
