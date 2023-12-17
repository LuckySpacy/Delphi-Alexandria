unit Objekt.Ini;

interface

uses
  IniFiles, SysUtils, Types, Variants;

type
  TIni = class
  public
    function  ReadIni(const aFullFileName, aSection, aKey: WideString; const aDefault: WideString): WideString;
    function  ReadIniToInt(const aFullFileName, aSection, aKey: WideString; const aDefault: WideString): Integer;
    function  ReadIniToDir(const aFullFileName, aSection, aKey: WideString; const aDefault: WideString): WideString;
    procedure WriteIni(const aFullFileName, aSection, aKey: WideString; const aValue: WideString);
  end;

implementation

{ TIni }

function TIni.ReadIni(const aFullFileName, aSection, aKey, aDefault: WideString): WideString;
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

function TIni.ReadIniToDir(const aFullFileName, aSection, aKey, aDefault: WideString): WideString;
var
  INI: TIniFile;
begin
  INI := TIniFile.Create(aFullFileName);
  try
    Result := INI.ReadString(aSection, aKey, aDefault);
    if Result = '' then
      exit;
    Result := IncludeTrailingPathDelimiter(Result);
  finally
    FreeAndNil(INI);
  end;
end;

function TIni.ReadIniToInt(const aFullFileName, aSection, aKey, aDefault: WideString): Integer;
var
  INI: TIniFile;
  s  : string;
begin
  INI := TIniFile.Create(aFullFileName);
  try
    s := INI.ReadString(aSection, aKey, aDefault);
    if not TryStrToInt(s, Result) then
      Result := StrToInt(aDefault);
  finally
    FreeAndNil(INI);
  end;
end;

procedure TIni.WriteIni(const aFullFileName, aSection, aKey, aValue: WideString);
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
