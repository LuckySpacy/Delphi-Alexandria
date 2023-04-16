unit Form.EXIFTest1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Memo.Types,
  FMX.ScrollBox, FMX.Memo, FMX.Objects, System.Permissions;

type
  TForm2 = class(TForm)
    Layout1: TLayout;
    PrevButton: TButton;
    NextButton: TButton;
    Memo1: TMemo;
    Image1: TImage;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure NextButtonClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    fDir: string;
    fFilename: string;
    FFiles: TArray<string>;
    FIndex: Integer;
    {$IFDEF ANDROID}
    fOK : Boolean;
    procedure PermissionsResult(Sender: TObject; const APermissions: TClassicStringDynArray; const AGrantResults: TClassicPermissionStatusDynArray);
   {$ENDIF}
    procedure SelectedImage;
    procedure SelectedImage2;
    function GetRootPath: string;
  public
  end;

var
  Form2: TForm2;

implementation

{$R *.fmx}

{ TForm2 }

uses
  System.IOUtils, System.TypInfo, FMX.DialogService
  ,Androidapi.Helpers,
   Androidapi.JNI.JavaTypes,
   Androidapi.JNI.Os,
  DW.EXIF, DW.UIHelper;

procedure TForm2.Button1Click(Sender: TObject);
begin
  SelectedImage2;
//  Image1.Bitmap.LoadFromFile(fFileName);
end;

procedure TForm2.FormCreate(Sender: TObject);
var
  p:Tarray<string>;
  Filename: string;
  TestFile: string;
  List: TSTringList;
begin
  {$IFDEF ANDROID}
  p:=[JStringToString(TJManifest_permission.JavaClass.READ_EXTERNAL_STORAGE),
        JStringToString(TJManifest_permission.JavaClass.WRITE_EXTERNAL_STORAGE)];
   PermissionsService.RequestPermissions(p,PermissionsResult,nil);
  {$ENDIF}
  FIndex := -1;
  fDir := TPath.Combine(GetRootPath, 'Thomas');
  (*
  Filename := TPath.Combine(TPath.GetHomePath, 'IMG_20210404_134258.jpg');
  //TestFile := TPath.Combine(TPath.GetHomePath, 'WoIstDieDatei.txt');
  TestFile := TPath.Combine(TPath.GetHomePath, 'XXX.txt');
  {
  List := TStringList.Create;
  List.SaveToFile(testfile);
  FreeAndNil(List);
  if not FileExists(testfile) then
    memo1.Lines.Text := testfile + ' -->Datei exist nicht'
  else
    memo1.Lines.Text := testfile + ' --> Datei existiert';
  exit;
  }
  Filename := TPath.Combine(GetRootPath, 'Thomas');
  Filename := TPath.Combine(Filename, 'IMG_20210404_134258.jpg');
  if FileExists(Filename) then
    memo1.Lines.Text := Filename + ' --> exisistiert'
  else
    memo1.Lines.Text := Filename + ' --> exisistiert nicht';

  exit;
  FFiles := TDirectory.GetFiles(fDir, '*.jpg', TSearchOption.soTopDirectoryOnly);
  if Length(FFiles) > 0 then
  begin
    FIndex := 0;
    PrevButton.Enabled := True;
    NextButton.Enabled := True;
    SelectedImage;
  end;
  *)
  fFilename := TPath.Combine(fDir, 'IMG_20210404_134258.jpg');
  SelectedImage2;
end;



procedure TForm2.SelectedImage;
var
  LProperties: TEXIFProperties;
  LFileName: string;
begin
  LFileName := FFiles[FIndex];
  Memo1.Lines.Clear;
  Memo1.Lines.Add('Image: ' + TPath.GetFileName(LFileName));
  Image1.Bitmap.LoadFromFile(LFileName);

  if TEXIF.GetEXIF(LFileName, LProperties) then
  begin
    Memo1.Lines.Add('Camera Make: ' + LProperties.CameraMake);
    Memo1.Lines.Add('Camera Model: ' + LProperties.CameraModel);
    Memo1.Lines.Add('Date Taken: ' + LProperties.DateTaken);
    Memo1.Lines.Add(Format('GPS : %.5f, %.5f', [LProperties.Latitude, LProperties.Longitude]));
    Memo1.Lines.Add('Orientation: ' + GetEnumName(TypeInfo(TEXIFOrientation), Ord(LProperties.Orientation)));
  end
  else
    Memo1.Lines.Add('Unable to obtain EXIF data');

end;


procedure TForm2.SelectedImage2;
var
  LProperties: TEXIFProperties;
  LFileName: string;
begin
  LFileName := fFilename;
  Memo1.Lines.Clear;
  Memo1.Lines.Add('Image: ' + TPath.GetFileName(LFileName));
  Image1.Bitmap.LoadFromFile(LFileName);

  if TEXIF.GetEXIF(LFileName, LProperties) then
  begin
    Memo1.Lines.Add('Camera Make: ' + LProperties.CameraMake);
    Memo1.Lines.Add('Camera Model: ' + LProperties.CameraModel);
    Memo1.Lines.Add('Date Taken: ' + LProperties.DateTaken);
    Memo1.Lines.Add(Format('GPS : %.5f, %.5f', [LProperties.Latitude, LProperties.Longitude]));
    Memo1.Lines.Add('Orientation: ' + GetEnumName(TypeInfo(TEXIFOrientation), Ord(LProperties.Orientation)));
  end
  else
    Memo1.Lines.Add('Unable to obtain EXIF data');

end;

function TForm2.GetRootPath: string;
var
  s: string;
  iPos: Integer;
begin
  s := System.IOUtils.TPath.GetSharedMoviesPath;
  iPos := System.SysUtils.LastDelimiter(System.IOUtils.TPath.DirectorySeparatorChar, s);
  Result := copy(s, 1, iPos);
end;

procedure TForm2.NextButtonClick(Sender: TObject);
begin
  TDialogService.ShowMessage(fFileName);
 // Image1.Bitmap.LoadFromFile(fFileName);
end;


{$IFDEF ANDROID}
procedure TForm2.PermissionsResult(Sender: TObject;
  const APermissions: TClassicStringDynArray;
  const AGrantResults: TClassicPermissionStatusDynArray);
 var
  n:integer;
 begin
  if length(AGrantResults)>0 then
   for n:=0 to length(AGrantResults)-1 do
    if not (AGrantResults[n] = TPermissionStatus.Granted) then fOK:=false;
 end;
{$ENDIF}

end.
