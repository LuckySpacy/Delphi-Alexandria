unit Thread.AktualThumbnails;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, FMX.Dialogs,
  DB.Bilder, Objekt.DatumZeit, fmx.StdCtrls

  {$IFDEF ANDROID}
  ,AndroidApi.IOUtilsEx
  ,DW.EXIF, DW.UIHelper
  {$ENDIF ANDROID}

  ;

type
  TThreadAktualThumbnails = class
  private
    fOnEnde: TNotifyEvent;
    fDBBilder: TDBBilder;
    fDatumZeit: TDatumZeit;
    fpg: TProgressBar;
    fLabelPgInfo: TLabel;
    procedure Ende(Sender: TObject);
    procedure Lade;
    procedure SearchFiles(aDir: string);
    procedure SearchDirectories(aDir: string);
    function GetRootPath: string;
    function GetWhatsAppMediaPath: string;
    procedure Shrink(aShrinkValue: Integer; var aZahl1, aZahl2: Integer);
    procedure Shrink2(aShrinkValue: Integer; var aZahl1, aZahl2: Integer);
    procedure Bitmapsize(aFullFilename: string; var aWidth, aHeight: Integer);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Start;
    property OnEnde: TNotifyEvent read fOnEnde write fOnEnde;
    procedure setProgressbar(aPG: TProgressbar);
    procedure setLabelPgInfo(aLabel: TLabel);
  end;

implementation

{ TThreadAktualThumbnails }

uses
  System.IOUtils, fmx.Objects, fmx.Graphics, Objekt.PhotoOrga, System.TypInfo;


constructor TThreadAktualThumbnails.Create;
begin
  fDBBilder  := TDBBilder.Create;
  fDBBilder.Connection := PhotoOrga.Connection;
  fDatumZeit := TDatumZeit.Create;
  fPg := nil;
  fLabelPgInfo := nil;
end;

destructor TThreadAktualThumbnails.Destroy;
begin
  FreeAndNil(fDBBilder);
  FreeAndNil(fDatumZeit);
  inherited;
end;

procedure TThreadAktualThumbnails.Ende(Sender: TObject);
begin
  if Assigned(fOnEnde) then
    fOnEnde(Self);
end;



procedure TThreadAktualThumbnails.Start;
var
  t: TThread;
begin
  t := TThread.CreateAnonymousThread(
  procedure
  begin
    Lade;
    //BasCloud.JToken := JBasCloud.Login(aEMail, aPassword);
  end
  );
  t.OnTerminate := Ende;
  t.Start;

end;

function TThreadAktualThumbnails.GetRootPath: string;
var
  s: string;
  iPos: Integer;
begin
  s := System.IOUtils.TPath.GetSharedMoviesPath;
  iPos := System.SysUtils.LastDelimiter(System.IOUtils.TPath.DirectorySeparatorChar, s);
  Result := copy(s, 1, iPos);
end;

function TThreadAktualThumbnails.GetWhatsAppMediaPath: string;
begin
  Result := getRootPath + 'WhatsApp/Media/';
end;



procedure TThreadAktualThumbnails.Lade;
var
  s: string;
begin

  s := System.IOUtils.TPath.GetCameraPath;
  SearchDirectories(s);
  //exit;
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

procedure TThreadAktualThumbnails.SearchDirectories(aDir: string);
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


procedure TThreadAktualThumbnails.SearchFiles(aDir: string);
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
  fDBBilder.Connection := PhotoOrga.Connection;
  Files := TDirectory.GetFiles(aDir);

  if fLabelPgInfo <> nil then
  begin
    TThread.Synchronize(TThread.CurrentThread,
    procedure
    begin
      fpg.Max := Length(Files);
      fpg.Value := 0;
      fLabelPgInfo.Text := aDir;
    end);
  end;

  for i1 := 0 to Length(Files) -1 do
  begin
    Filename := Files[i1];

    s := ExtractFileName(Filename);
    if SameText('IMG_20181220_133848.jpg', s) then
    begin
      if fpg <> nil then
        fpg.Value := i1+1;
    end;


    if fLabelPgInfo <> nil then
    begin
      TThread.Synchronize(TThread.CurrentThread,
      procedure
      begin
        fpg.Value := i1+1;
        fLabelPgInfo.Text := IntToStr(i1) + '_' + Filename;
      end);
    end;

   // if i1 < 540 then
   //   continue;

    //if not SameText('IMG_20181220_133848.jpg', ExtractFileName(Filename)) then
    //  exit;

    Ext := ExtractFileExt(Filename);
    if SameText('.jpg', Ext) then
    begin
      if not fDBBilder.Read_Bild(aDir, ExtractFileName(Filename)) then
      begin
        //Bitmapsize(Filename, iWidth, iHeight);
        //Shrink(100, iWidth, iHeight);
        Stream := TMemoryStream.Create;
        Bitmap := TBitmap.Create;
        try
          DateiDatum := 0;
          if TFile.Exists(Filename) then
            DateiDatum := TFile.GetLastWriteTimeUtc(Filename);
          Bitmap.LoadThumbnailFromFile(Filename, 100, 100, false);
          //Bitmap.Height := iHeight;
          //Bitmap.Width  := iWidth;

          //Bitmap.LoadThumbnailFromFile(Filename, iWidth, iHeight, false);
          fDBBilder.Init;
          fDBBilder.Pfad := aDir;
          fDBBilder.Bildname := ExtractFileName(Filename);

          if fDBBilder.Orientation = 'Rotate270' then
            Bitmap.Rotate(-270);
          if fDBBilder.Orientation = 'Rotate180' then
            Bitmap.Rotate(180);

          Bitmap.SaveToStream(Stream);
          sWidth  := IntToStr(Bitmap.Width);
          sHeight := IntToStr(Bitmap.Height);
          //Bitmap.SaveToFile('d:\Temp\Bilder\' + sWidth + 'x' + sHeight + '_' + fDBBilder.Bildname);
          fDBBilder.setShortImage(Stream);
          fDBBilder.LastWriteTimeUtc := fDatumZeit.DatumZuString(DateiDatum);
          {$IFDEF ANDROID}
          if TEXIF.GetEXIF(Filename, LProperties) then
          begin
            fDBBilder.CameraMarke := LProperties.CameraMake;
            fDBBilder.CameraModel := LProperties.CameraModel;
            fDBBilder.Datum       := StringReplace(LProperties.DateTaken, ':', '-', [rfReplaceAll]);
            fDBBilder.Latitude    := LProperties.Longitude.ToString;
            fDBBilder.Longitude   := LProperties.Latitude.ToString;
            fDBBilder.Orientation := GetEnumName(TypeInfo(TEXIFOrientation), Ord(LProperties.Orientation));
          end;
          {$ENDIF ANDROID}
          fDBBilder.Insert;
        finally
          FreeAndNil(Bitmap);
          FreeAndNil(Stream);
        end;
      end;
    end;
  end;
end;


procedure TThreadAktualThumbnails.setLabelPgInfo(aLabel: TLabel);
begin
  fLabelPgInfo := aLabel;
end;

procedure TThreadAktualThumbnails.setProgressbar(aPG: TProgressbar);
begin
  fpg := aPG;
end;

procedure TThreadAktualThumbnails.Bitmapsize(aFullFilename: string; var aWidth, aHeight: Integer);
var
  Bitmap: TBitmap;
begin
  aWidth := 0;
  aHeight := 0;
  Bitmap := TBitmap.Create;
  try
    if TFile.Exists(aFullFilename) then
    begin
      Bitmap.LoadFromFile(aFullFilename);
      aWidth  := Bitmap.Width;
      aHeight := Bitmap.Height;
    end;
  finally
    FreeAndNil(Bitmap);
  end;
end;


procedure TThreadAktualThumbnails.Shrink(aShrinkValue: Integer; var aZahl1, aZahl2: Integer);
var
  Faktor: real;
begin
  if (aZahl1 < aShrinkValue) and (aZahl2 < aShrinkvalue) then
    exit;

 if (aZahl1 = aZahl2) then
 begin
   aZahl1 := aShrinkValue;
   aZahl2 := aShrinkValue;
   exit;
 end;

  if (aZahl1 > aZahl2) and (aZahl1 >= aShrinkValue) then
  begin
    Faktor  := aZahl1 / aShrinkValue;
    aZahl1  := aShrinkValue;
    aZahl2  := trunc(aZahl2 / Faktor);
  end;

  if (aZahl2 >= aZahl1) and (aZahl2 >= aShrinkValue) then
  begin
    Faktor  := aZahl2 / aShrinkValue;
    aZahl2  := aShrinkValue;
    aZahl1  := trunc(aZahl1 / Faktor);
  end;


end;

procedure TThreadAktualThumbnails.Shrink2(aShrinkValue: Integer; var aZahl1, aZahl2: Integer);
var
  Faktor: real;
begin
  if (aZahl1 < aShrinkValue) and (aZahl2 < aShrinkvalue) then
    exit;

 if (aZahl1 = aZahl2) then
 begin
   aZahl1 := aShrinkValue;
   aZahl2 := aShrinkValue;
   exit;
 end;

  if (aZahl1 > aZahl2) and (aZahl1 >= aShrinkValue) then
  begin
    Faktor  := aZahl2 / aShrinkValue;
    aZahl2  := aShrinkValue;
    aZahl1  := trunc(aZahl1 / Faktor);
  end;

  if (aZahl2 >= aZahl1) and (aZahl2 >= aShrinkValue) then
  begin
    Faktor  := aZahl1 / aShrinkValue;
    aZahl1  := aShrinkValue;
    aZahl2  := trunc(aZahl2 / Faktor);
  end;


end;




end.
