unit Androidapi.IOUtilsEx;

interface


function GetExternalStorageState: string;
function isExternalStorageWritable: boolean;
function isExternalStorageReadable: boolean;
function GetExternalStorageDirectory: string;
function GetDataDirectory: string;
function GetDownloadCacheDirectory: string;
function GetRootDirectory: string;

function isExternalStorageEmulated : boolean;
function isExternalStorageRemovable : boolean;
function getStorageState(FilePath : string) : string;
function GetExternalFilesDir: string;
function GetExternalSDCardDirectory: string;

function GetSysSecondaryStorage: string;
function GetSysExternalStorage: string;

//Android 21+
//function isExternalStorageEmulated(FilePath : string) : boolean; overload;
//function isExternalStorageRemovable(FilePath : string) : boolean; overload;



implementation

uses
  System.SysUtils,
  Androidapi.Jni,
  Androidapi.JNIBridge,
  Androidapi.JNI.JavaTypes,
  Androidapi.Helpers,
  Androidapi.JNI.SystemIntf,
  Androidapi.JNI.EnvIntf;

function GetExternalFilesDir: string;
begin
  Result := JStringToString(SharedActivityContext.getExternalCacheDir.getPath);
end;

function GetSysSecondaryStorage: string;
begin
  Result := JStringToString(TJSystem.JavaClass.getenv(StringToJString('SECONDARY_STORAGE')));
end;

function GetSysExternalStorage: string;
begin
  Result := JStringToString(TJSystem.JavaClass.getenv(StringToJString('EXTERNAL_STORAGE')));
end;


function GetExternalSDCardDirectory: string;
var
  EmulStorage ,RootDir, AFile : JFile;
  FileDirs : TJavaObjectArray<JFile>;
  isMounted : JString;
  i : integer;
begin
  EmulStorage := TJEnvironment.JavaClass.getExternalStorageDirectory();
  Result := JStringToString(EmulStorage.getPath);
  AFile  := EmulStorage.getParentFile();
  repeat
    RootDir := AFile;
    AFile := AFile.getParentFile();
  until (AFile = nil) or AFile.getPath().equals(StringToJString('/'));
  if RootDir <> nil then
  begin
    FileDirs := RootDir.listFiles();
    for I := 0 to FileDirs.Length-1 do
     begin
         AFile := FileDirs[I];
         isMounted := TJEnvironment.JavaClass.getStorageState(AFile);
         if isMounted <> nil then
            if TJEnvironment.JavaClass.MEDIA_MOUNTED.equals(isMounted) then
                Exit(JStringToString(AFile.getPath()));
     end;
  end;
end;


function GetExternalStorageDirectory: string;
begin
 Result := JStringToString(TJEnvironment.JavaClass.getExternalStorageDirectory.getPath);
end;

function GetDataDirectory: string;
begin
 Result := JStringToString(TJEnvironment.JavaClass.getDataDirectory.getPath);
end;

function GetDownloadCacheDirectory: string;
begin
 Result := JStringToString(TJEnvironment.JavaClass.getDownloadCacheDirectory.getPath);
end;

function GetRootDirectory: string;
begin
    Result := JStringToString(TJEnvironment.JavaClass.getRootDirectory.getPath);
end;

function isExternalStorageEmulated : boolean;
begin
 Result :=  TJEnvironment.JavaClass.isExternalStorageEmulated;
end;

function isExternalStorageRemovable : boolean;
begin
  Result := TJEnvironment.JavaClass.isExternalStorageRemovable;
end;

function getStorageState(FilePath : string) : string;
begin
  Result := JStringToString(TJEnvironment.JavaClass.getStorageState(TJFile.JavaClass.init(StringToJString(FilePath))));
end;

//Android 21+
//function isExternalStorageEmulated(FilePath : string) : boolean; overload;
//begin
//  Result := TJEnvironment.JavaClass.isExternalStorageEmulated(TJFile.JavaClass.init(StringToJString(FilePath)));
//end;
//
//function isExternalStorageRemovable(FilePath : string) : boolean; overload;
//begin
//  Result := TJEnvironment.JavaClass.isExternalStorageRemovable(TJFile.JavaClass.init(StringToJString(FilePath)));
//end;


function getExternalStorageState: string;
begin
  Result := JStringToString(TJEnvironment.JavaClass.getExternalStorageState());
end;

function isExternalStorageWritable: boolean;
begin
  Result := TJEnvironment.JavaClass.MEDIA_MOUNTED.equals(TJEnvironment.JavaClass.getExternalStorageState());
end;

function isExternalStorageReadable: boolean;
begin
   Result := isExternalStorageWritable or
   TJEnvironment.JavaClass.MEDIA_MOUNTED_READ_ONLY.equals(TJEnvironment.JavaClass.getExternalStorageState());
end;


end.
