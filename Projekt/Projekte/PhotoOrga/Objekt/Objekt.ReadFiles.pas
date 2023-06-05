unit Objekt.ReadFiles;

interface


uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, FMX.Dialogs,
  fmx.StdCtrls, Types.PhotoOrga

  {$IFDEF ANDROID}
  ,AndroidApi.IOUtilsEx
  ,DW.EXIF, DW.UIHelper
  {$ENDIF ANDROID}

  ;

type
  TReadFiles = class
  private
    fOnProgressMaxValue: TNotifyIntEvent;
    fOnProgress: TProgressEvent;
    fStop: Boolean;
    procedure SearchFiles(aDir: string);
    procedure SearchDirectories(aDir: string);
    function GetRootPath: string;
    function GetWhatsAppMediaPath: string;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Start;
    property OnProgressMaxValue: TNotifyIntEvent read fOnProgressMaxValue write fOnProgressMaxValue;
    property OnProgress: TProgressEvent read fOnProgress write fOnProgress;
    property Stop: Boolean read fStop write fStop;
  end;

implementation

{ TReadFiles }

uses
  System.IOUtils, fmx.Objects, fmx.Graphics, Objekt.PhotoOrga, System.TypInfo;

constructor TReadFiles.Create;
begin

end;

destructor TReadFiles.Destroy;
begin

  inherited;
end;




procedure TReadFiles.Start;
var
  s: string;
begin

  fStop := false;
  s := System.IOUtils.TPath.GetCameraPath;
  SearchDirectories(s);
  if fStop then
    exit;
  //exit;

 // s := 'd:\Bachmann\Daten\OneDrive\Asus-PC-2018\Bilder\Camera\';
 // SearchDirectories(s);

  s := System.IOUtils.TPath.GetSharedCameraPath;
  SearchDirectories(s);


  {$IFDEF ANDROID}

  S := System.IOUtils.TPath.GetPicturesPath;
  SearchDirectories(s);

  S := System.IOUtils.TPath.GetSharedPicturesPath;
  SearchDirectories(s);
  s := GetWhatsAppMediaPath;
  SearchDirectories(s);
  s := '/storage/9C33-6BBD/DCIM';
  SearchDirectories(s);



  {$ENDIF ANDROID}

end;


 (*
procedure TReadFiles.SearchFiles(aDir: string);
  procedure SearchSubDir(aDir: string);
  var
    i1: Integer;
    dirList: TStringDynArray;
  begin
    dirList := TDirectory.GetDirectories(aDir);
    for i1 := 0 to Length(dirList) -1 do
    begin
      if fStop  then
        exit;
      SearchFiles(dirList[i1]);
      SearchSubDir(dirList[i1]);
    end;
  end;
begin
  SearchFiles(aDir);
  SearchSubDir(aDir);
end;
*)


procedure TReadFiles.SearchFiles(aDir: string);
var
  i1: Integer;
  Filename: string;
  Files: TStringDynArray;
  Ext: string;
  Bitmap: TBitmap;
  Stream: TMemoryStream;
  iHeight: Integer;
  iWidth: Integer;
  DateiDatum: TDateTime;
  sWidth: string;
  sHeight: string;
  s: string;
  {$IFDEF ANDROID}
  LProperties: TEXIFProperties;
  {$ENDIF ANDROID}
begin
  Files := TDirectory.GetFiles(aDir);

  for i1 := 0 to Length(Files) -1 do
  begin
    Filename := Files[i1];
    s := ExtractFileName(Filename);
    Ext := ExtractFileExt(Filename);
    if SameText('.jpg', Ext) then
    begin
      if Assigned(fOnProgress) then
        fOnProgress(i1+1, Filename);
    end;
  end;
end;



procedure TReadFiles.SearchDirectories(aDir: string);
  procedure SearchSubDir(aDir: string);
  var
    i1: Integer;
    dirList: TStringDynArray;
  begin
    dirList := TDirectory.GetDirectories(aDir);
    for i1 := 0 to Length(dirList) -1 do
    begin
      SearchFiles(dirList[i1]);
      SearchSubDir(dirList[i1]);
    end;
  end;
begin
  SearchFiles(aDir);
  SearchSubDir(aDir);
end;

(*
procedure TReadFiles.SearchDirectories(aDir: string);
var
  i1: Integer;
  Filename: string;
  Files: TStringDynArray;
  Ext: string;
  {$IFDEF ANDROID}
  LProperties: TEXIFProperties;
  {$ENDIF ANDROID}
begin
  Files := TDirectory.GetFiles(aDir);

  if Assigned(fOnProgressMaxValue) then
    fOnProgressMaxValue(Length(Files));

  for i1 := 0 to Length(Files) -1 do
  begin
    if fStop  then
      exit;
    Filename := Files[i1];
    Ext := ExtractFileExt(Filename);
    if SameText('.jpg', Ext) then
    begin
      if Assigned(fOnProgress) then
        fOnProgress(i1+1, Filename);
    end;
  end;

end;
*)

function TReadFiles.GetRootPath: string;
var
  s: string;
  iPos: Integer;
begin
  s := System.IOUtils.TPath.GetSharedMoviesPath;
  iPos := System.SysUtils.LastDelimiter(System.IOUtils.TPath.DirectorySeparatorChar, s);
  Result := copy(s, 1, iPos);
end;

function TReadFiles.GetWhatsAppMediaPath: string;
begin
  Result := getRootPath + 'WhatsApp/Media/';
end;


end.
