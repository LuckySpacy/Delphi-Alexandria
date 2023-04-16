unit Form.FolderTest1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Memo.Types, FMX.ScrollBox, FMX.Memo,
  {$IFDEF ANDROID}
  AndroidApi.Helpers, AndroidApi.Jni.Os, System.Permissions;
  {$ENDIF ANDROID}
  {$IFNDEF ANDROID}
  System.Permissions;
  {$ENDIF ANDROID}

type
  TForm2 = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Memo1: TMemo;
    Button2: TButton;
    btn_Dokumentlist: TButton;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure btn_DokumentlistClick(Sender: TObject);
    function GetRootPath: string;
  private
    procedure PfadeLesen;
    procedure DirErzeugen;
    procedure SchreibeSDCard(aPath, aFilename, aText: string);
    procedure TryCreateDir(APath: String);
  public
    { Public-Deklarationen }
  end;

var
  Form2: TForm2;

implementation

{$R *.fmx}

uses
  Dw.Consts.Android,
  System.IOUtils,
  DW.Permissions.Helpers,
  {$IFDEF ANDROID}
  AndroidApi.IOUtilsEx,
  {$ENDIF}
  fmx.DialogService;



procedure TForm2.FormCreate(Sender: TObject);
begin  //
{$IFDEF ANDROID}
{$ENDIF}
end;

procedure TForm2.FormDestroy(Sender: TObject);
begin  //

end;



procedure TForm2.btn_DokumentlistClick(Sender: TObject);
var
  i1: Integer;
  DirList: TStringDynArray;
  DirPath: string;
  s: string;
  d: TDateTime;
begin
  Memo1.Lines.Clear;
 // DirPath := TPath.GetSharedDocumentsPath;
  //DirPath := GetSysExternalStorage;
  // DirPath := '/storage/emulated/0';
  Label1.Text := GetSysExternalStorage;
  //exit;
//  DirPath := '/storage/9C33-6BBD';
//  DirPath := '/sdcard';
{
  SchreibeSDCard(DirPath + '/Hurra', 'Hurra.txt', 'Das ist ein Text');
  Memo1.Lines.Add('Pfad');
  Memo1.Lines.Add(DirPath);
  Memo1.Lines.Add(' ');
 }
  DirPath := '/storage/9C33-6BBD/DCIM/Camera';
  //DirPath := GetSysExternalStorage + '/DCIM/Camera';
//  DirPath := '/storage/9C33-6BBD' + '/DCIM/Camera';
  //Label1.Text := TPath.DirectorySeparatorChar;
  DirPath := GetRootPath + 'WhatsApp/Media/WhatsApp Images';
  //Memo1.Lines.Add(DirPath);
  //DirPath := TPath.GetHomePath + '/Android/media/com.whatsapp/WhatsApp/Media/WhatsApp Images';
  Label1.Text := DirPath;
  DirList := TDirectory.GetFiles(DirPath);


  if Length(DirList) = 0 then
  begin
    Memo1.Lines.Add('Keine Daten gefunden');
    //exit;
  end
  else
  begin
    for s in dirList do
    begin
      d := 0;
      if TFile.Exists(s) then
        d := TFile.GetLastWriteTimeUtc(s);
      Memo1.Lines.Add(s + ' ' + FormatDateTime('dd.mm.yyyy hh:nn:ss', d));
    end;
  end;

  exit;
  DirList := TDirectory.GetDirectories(DirPath);

  if Length(DirList) = 0 then
  begin
    Memo1.Lines.Add('Keine Verzeichnisse gefunden');
    exit;
  end;

  Memo1.Lines.Add('Verzeichnisse:');
  for s in dirList do
  begin
    d := TDirectory.GetCreationTimeUtc(s);
    Memo1.Lines.Add(s + ' ' + FormatDateTime('dd.mm.yyyy hh:nn:ss', d));
  end;


end;

function TForm2.GetRootPath: string;
var
  s: string;
  iPos: Integer;
begin
  s := TPath.GetSharedMoviesPath;
  iPos := LastDelimiter(TPath.DirectorySeparatorChar, s);
  //Result := IntToStr(iPos);
  Result := copy(s, 1, iPos);
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
  PermissionsService.RequestPermissions([cPermissionReadExternalStorage, cPermissionWriteExternalStorage],
    procedure(const APermissions: TPermissionArray; const AGrantResults: TPermissionStatusArray)
    begin
      if AGrantResults.AreAllGranted then
        PfadeLesen;
    end
  );
end;



procedure TForm2.PfadeLesen;
begin

  Memo1.Lines.Clear;

  {$IFDEF ANDROID64}
  Memo1.Lines.Add('GetSysSecondaryStorage:');
  Memo1.Lines.Add(GetSysSecondaryStorage);
  Memo1.Lines.Add(' ');


  Memo1.Lines.Add('GetSysExternalStorage:');
  Memo1.Lines.Add(GetSysExternalStorage);
  Memo1.Lines.Add(' ');

      {
  Memo1.Lines.Add('GetExternalSDCardDirectory:');
  Memo1.Lines.Add(GetExternalSDCardDirectory);
  Memo1.Lines.Add(' ');
       }

  Memo1.Lines.Add('GetExternalStorageDirectory:');
  Memo1.Lines.Add(GetExternalStorageDirectory);
  Memo1.Lines.Add(' ');
  {$ENDIF ANDROID64}


  Memo1.Lines.Add('GetCameraPath:');
  Memo1.Lines.Add(TPath.GetCameraPath);
  Memo1.Lines.Add(' ');

  Memo1.Lines.Add('GetLibraryPath:');
  Memo1.Lines.Add(TPath.GetLibraryPath);
  Memo1.Lines.Add(' ');

  Memo1.Lines.Add('GetPublicPath:');
  Memo1.Lines.Add(TPath.GetPublicPath);
  Memo1.Lines.Add(' ');

  Memo1.Lines.Add('GetHomePath:');
  Memo1.Lines.Add(TPath.GetHomePath);
  Memo1.Lines.Add(' ');


  Memo1.Lines.Add('GetSharedDocumentsPath:');
  Memo1.Lines.Add(TPath.GetSharedDocumentsPath);
  Memo1.Lines.Add(' ');
  Memo1.Lines.Add('GetSharedPicturesPath:');
  Memo1.Lines.Add(TPath.GetSharedPicturesPath);
  Memo1.Lines.Add(' ');
  Memo1.Lines.Add('GetSharedCameraPath:');
  Memo1.Lines.Add(TPath.GetSharedCameraPath);
  Memo1.Lines.Add(' ');
  Memo1.Lines.Add('GetSharedMusicPath:');
  Memo1.Lines.Add(TPath.GetSharedMusicPath);
  Memo1.Lines.Add(' ');

  DirErzeugen;
 // TryCreateDir('storage/9C33-6BBD');


end;



procedure TForm2.Button2Click(Sender: TObject);
var
  dirList: TStringDynArray;
  i1: Integer;
begin
//  dirList := TDirectory.GetDirectories(GetExternalStorageDirectory);
  Memo1.Lines.Clear;
  memo1.Lines.Add('/storage/sdcard0');
  dirList := TDirectory.GetDirectories('/storage/sdcard0');
  for i1 := 0 to Length(dirList) -1 do
  begin
    Memo1.Lines.Add(dirlist[i1]);
  end;
  memo1.Lines.Add('/storage/sdcard1');
  dirList := TDirectory.GetDirectories('/storage/sdcard1');
  for i1 := 0 to Length(dirList) -1 do
  begin
    Memo1.Lines.Add(dirlist[i1]);
  end;

end;

procedure TForm2.DirErzeugen;
var
  pfad : string;
begin
  {$IFDEF ANDROID}
  Pfad := GetSysExternalStorage;
  {$ENDIF}
  Pfad := TPath.Combine(Pfad, 'Thomas');
  ShowMessage(Pfad);
  TDirectory.CreateDirectory(Pfad);
end;



procedure TForm2.TryCreateDir(APath: String);
var
  s: String;
begin
  s := APath + '/bla';
  TDirectory.CreateDirectory(s);
  if TDirectory.Exists(s) then
    ShowMessage('OK')
  else
    ShowMessage(s + ' konnte nicht erstellt werden!');
end;


procedure TForm2.SchreibeSDCard(aPath, aFilename, aText: string);
var
  List: TStringList;
  FullFilename: string;
begin
  if not TDirectory.Exists(aPath) then
    TDirectory.CreateDirectory(aPath);
  List := TStringList.Create;
  try
    List.Add(aText);
    FullFilename := TPath.Combine(aPath, aFilename);
    List.SaveToFile(FullFilename);
  finally
    FreeAndNil(List);
  end;
end;


end.
