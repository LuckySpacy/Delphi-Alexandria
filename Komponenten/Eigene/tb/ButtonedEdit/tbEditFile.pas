unit tbEditFile;

interface

uses
  SysUtils, Classes, Controls, StdCtrls, ExtCtrls, Dialogs, ExtDlgs, Graphics;

type
  TTBEditFile = class(TButtonedEdit)
  private
    FUseTextFile: Boolean;
    FOpenDialog : TOpenDialog;
    FImageList: TImageList;
    FFolderText: string;
    FFolderDefaultDir: string;
    procedure LoadIconFromRes(aResType, aResName: string; aIcon: Graphics.TIcon);
    procedure RightButtonClick(Sender: TObject);
    function OpenFolder(Caption, DefPath: string): string;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property UseTextFile: Boolean read FUseTextFile write FUseTextFile;
    property OpenDialog: TOpenDialog read FOpenDialog write FOpenDialog;
    property FolderText: string read FFolderText write FFolderText;
    property FolderDefaultDir: string read FFolderDefaultDir write FFolderDefaultDir;
  end;

procedure Register;

implementation

{$R EditFile.res}

uses
  ShlObj, Windows;



procedure Register;
begin
  RegisterComponents('Samples', [TTBEditFile]);
end;

{ TTBEditFile }

constructor TTBEditFile.Create(AOwner: TComponent);
var
  Icon: TIcon;
begin
  inherited;
  FFoldertext  := 'Verzeichnis wählen';
  FFolderDefaultDir := 'c:\';
  FUseTextFile := false;
  FOpenDialog  := TOpenDialog.Create(Self);
  FOpenDialog.Name := 'OpenDialog';
  FImageList := TImageList.Create(Self);
  Icon := TIcon.Create;
  LoadIconFromRes('RT_RCDATA', 'Oeffnen', Icon);
  FImageList.AddIcon(Icon);
  FreeAndNil(Icon);
  Images := FImageList;
  RightButton.DisabledImageIndex := 0;
  RightButton.HotImageIndex := 0;
  RightButton.ImageIndex := 0;
  RightButton.PressedImageIndex := 0;
  RightButton.Visible := true;
  OnRightButtonClick := RightButtonClick;
end;

destructor TTBEditFile.Destroy;
begin
  FreeAndNil(FImageList);
  FreeAndNil(FOpenDialog);
  inherited;
end;


procedure TTBEditFile.LoadIconFromRes(aResType, aResName: string;
  aIcon: Graphics.TIcon);
var
  Res: TResourceStream;
begin
  Res := TResourceStream.Create(Hinstance, aResname, PChar(aResType));
  try
    aIcon.LoadFromStream(Res);
  finally
    FreeAndNil(Res);
  end;
end;

procedure TTBEditFile.RightButtonClick(Sender: TObject);
var
  Path: string;
begin
  if FUseTextFile then
  begin
    if FOpenDialog.Execute then
      Text := FOpenDialog.FileName;
    exit;
  end;

  Path := OpenFolder(FFolderText, FFolderDefaultDir);
  if Path > '' then
  begin
    Text := Path;
  end;

end;


// Erweiterte Verzeichnis-Öffnen-Dialog-Funktion
// Caption: Optionaler Subtitel
// DefPath: Vorauswahl des Verzeichnises
// Result: Verzeichnis als String
function TTBEditFile.OpenFolder(Caption, DefPath: string): string;
var
  bi: TBrowseInfo;
  lpBuffer: PChar;
  pidlPrograms, pidlBrowse: PItemIDList;

  function BrowseCallbackProc(hwnd: HWND; uMsg: UINT; lParam: Cardinal;
    lpData: Cardinal): Integer; stdcall;
  var
    PathName: array[0..MAX_PATH] of Char;
  begin
    case uMsg of
      BFFM_INITIALIZED:
        SendMessage(Hwnd, BFFM_SETSELECTION, Ord(True), Integer(lpData));
      BFFM_SELCHANGED:
        begin
          SHGetPathFromIDList(PItemIDList(lParam), @PathName);
          SendMessage(hwnd, BFFM_SETSTATUSTEXT, 0, Longint(PChar(@PathName)));
        end;
    end;
    Result := 0;
  end;

begin
  Result := '';
  if (not SUCCEEDED(SHGetSpecialFolderLocation(GetActiveWindow, CSIDL_DRIVES,
    pidlPrograms))) then exit;

  GetMem(lpBuffer, MAX_PATH);

  FillChar(BI, SizeOf(BrowseInfo), 0);
  bi.hwndOwner := GetActiveWindow;
  bi.pidlRoot := pidlPrograms;
  bi.pszDisplayName := lpBuffer;
  bi.lpszTitle := PChar(Caption);
  bi.ulFlags := BIF_RETURNONLYFSDIRS or BIF_STATUSTEXT;
  bi.lpfn := @BrowseCallbackProc;
  bi.lParam := Integer(PChar(DefPath));

  pidlBrowse := SHBrowseForFolder(bi);
  if (pidlBrowse <> nil) then
    if SHGetPathFromIDList(pidlBrowse, lpBuffer) then
      Result := String(lpBuffer);

  if (lpBuffer <> nil) then FreeMem(lpBuffer);
end;



end.
