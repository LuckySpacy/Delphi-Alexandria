unit Form.SAFTest1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.Controls.Presentation, FMX.StdCtrls,
  Androidapi.Jni.Net, System.Messaging, FMX.Memo.Types, FMX.ScrollBox, FMX.Memo,
  Androidapi.JNI.GraphicsContentViewText, Androidapi.Helpers,
  Androidapi.JNI.Provider, Androidapi.JNI.Os, fmx.Platform.Android, Androidapi.JNI.App,
  Objekt.Android.MessageActivity, Objekt.Android.Konstanten, Androidapi.JNI.JavaTypes,
  Objekt.Android.Uri, Androidapi.JNIBridge, Objekt.ExifProperty;

type
  TForm2 = class(TForm)
    TabControl: TTabControl;
    TabItem1: TTabItem;
    btn_DateiErstellen: TButton;
    btn_OeffneDatei: TButton;
    btn_DateiZugriff: TButton;
    btn_DateiHolen: TButton;
    TabItem2: TTabItem;
    btn_DauerhafteBerechtigung: TButton;
    Memo1: TMemo;
    btn_Metadaten: TButton;
    TabItem3: TTabItem;
    TabItem4: TTabItem;
    ImageControl1: TImageControl;
    btn_BitmapOeffnen: TButton;
    btn_TextdokumentSchreiben: TButton;
    btn_TextdateiOeffnen: TButton;
    btn_DateiLoeschen: TButton;
    btn_VirtuelleDateiOeffnen: TButton;
    btn_BitmapOeffnen2: TButton;
    btn_Exif: TButton;
    procedure btn_DateiErstellenClick(Sender: TObject);
    procedure btn_OeffneDateiClick(Sender: TObject);
    procedure btn_DateiZugriffClick(Sender: TObject);
    procedure btn_DateiHolenClick(Sender: TObject);
    procedure btn_DauerhafteBerechtigungClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btn_MetadatenClick(Sender: TObject);
    procedure btn_BitmapOeffnenClick(Sender: TObject);
    procedure btn_TextdokumentSchreibenClick(Sender: TObject);
    procedure btn_TextdateiOeffnenClick(Sender: TObject);
    procedure btn_DateiLoeschenClick(Sender: TObject);
    procedure btn_VirtuelleDateiOeffnenClick(Sender: TObject);
    procedure btn_BitmapOeffnen2Click(Sender: TObject);
    procedure btn_ExifClick(Sender: TObject);
  private
    fAndroidMessageActivity: TAndroidMessageActivity;
    fAndroidUri: TAndroidUri;
    fExifProperty: TExifProperty;
   const
      c_DateiErstellen: integer = 11; // CREATE_FILE = 1
      c_PdfWaehlen: integer = 22; // PICK_PDF_FILE = 2
      c_DirectoryTreeAc: integer = 33;
      c_DateiLoeschen: integer = 44;
      c_TextWaehlen: integer = 55;
      c_BildZeigen: integer = 66;
      c_AnyFileWaehlen: integer = 77;
      c_KopiernInternExtern: integer = 88;
      c_DateiKopierenExternIntern: integer = 99;
    var
      fUri: JNet_Uri;
      fDateiKopiert: string;
      fKokIndex: JNet_Uri;
    procedure doInfo(aValue: string);
    procedure doNewUri(aNewUri: JNet_Uri);
    procedure UriError(aError: TUriError);
    procedure LadeImage(aNewUri: JNet_Uri);
  public

  end;

var
  Form2: TForm2;

implementation

{$R *.fmx}

uses
  FMX.DialogService, fmx.Surfaces, fmx.Helpers.Android;




procedure TForm2.FormCreate(Sender: TObject);
begin
  fAndroidMessageActivity := TAndroidMessageActivity.Create;
  fAndroidMessageActivity.OnActivityResultStr := doInfo;
  fAndroidMessageActivity.OnNewUri := doNewUri;
  fAndroidMessageActivity.OnImage  := LadeImage;
  fAndroidUri := TAndroidUri.Create;
  fAndroidUri.OnInfo := doInfo;
  fAndroidUri.OnError := UriError;
  fExifProperty := TExifProperty.Create;

end;



procedure TForm2.FormDestroy(Sender: TObject);
begin
  FreeAndNil(fAndroidMessageActivity);
  FreeAndNil(fAndroidUri);
  FreeAndNil(fExifProperty);
end;

procedure TForm2.FormShow(Sender: TObject);
begin
  fAndroidMessageActivity.SystemInfo(Memo1.Lines);
end;

procedure TForm2.LadeImage(aNewUri: JNet_Uri);
begin
  fAndroidUri.BildZeigen(aNewUri, ImageControl1.Bitmap);
end;

procedure TForm2.UriError(aError: TUriError);
begin
  TDialogService.ShowMessage(aError.msg);
end;

procedure TForm2.doNewUri(aNewUri: JNet_Uri);
begin
  fUri := aNewUri;
end;




procedure TForm2.btn_DateiErstellenClick(Sender: TObject);
begin
  fAndroidUri.PDFDateiErstellen(nil);
end;

procedure TForm2.btn_DateiHolenClick(Sender: TObject);
begin
  fAndroidUri.DateiOeffnen;
end;

procedure TForm2.btn_DateiLoeschenClick(Sender: TObject);
begin
  fAndroidUri.DeleteFile;
end;

procedure TForm2.btn_DateiZugriffClick(Sender: TObject);
begin
  fAndroidUri.VerzeichnisWaehlen(nil);
end;




procedure TForm2.btn_OeffneDateiClick(Sender: TObject);
begin
  fAndroidUri.PdfZeigen(fUri);
//  fAndroidUri.PDFOeffnen(nil);
end;


procedure TForm2.btn_TextdateiOeffnenClick(Sender: TObject);
begin
  fAndroidUri.OpenTextfile;
end;

procedure TForm2.btn_TextdokumentSchreibenClick(Sender: TObject);
begin
  fAndroidUri.WriteTextfile(fUri);
end;
procedure TForm2.btn_VirtuelleDateiOeffnenClick(Sender: TObject);
  function VirtuelleDatei(aUri: JNet_Uri): boolean; (* isVirtualFile *)
  var
    flags: integer;
    cursor: JCursor;
    s: TJavaObjectArray<JString>;
  begin
    if (not TJDocumentsContract.JavaClass.isDocumentUri(TAndroidHelper.Context, aUri)) then
    begin
      result := false;
      exit;
    end;
    s := TJavaObjectArray<JString>.Create(0);
    s[0] := TJDocumentsContract_Document.JavaClass.COLUMN_FLAGS;
    cursor := TAndroidHelper.Activity.getContentResolver.query(aUri, s, nil, nil, nil);
    flags := 0;
    if (cursor.moveToFirst) then
      flags := cursor.getInt(0);
    cursor.close;
    result := (flags and TJDocumentsContract_Document.JavaClass.FLAG_VIRTUAL_DOCUMENT) <> 0;
  end;
begin
  VirtuelleDatei(fUri);
end;

procedure TForm2.doInfo(aValue: string);
begin
  Memo1.Lines.Add(aValue);
  Memo1.GoToTextEnd;
end;

procedure TForm2.btn_BitmapOeffnen2Click(Sender: TObject);
begin
  fAndroidUri.OpenImage;
end;

procedure TForm2.btn_BitmapOeffnenClick(Sender: TObject);
begin
  fAndroidUri.AssignBitmap(fUri, ImageControl1.Bitmap);
end;


//*********************************************************************************
//***** SAF 1                                                                  ****
//*********************************************************************************


procedure TForm2.btn_DauerhafteBerechtigungClick(Sender: TObject);
var
  TakeFlags: integer;
  Intent: JIntent;
begin
  Intent := TJIntent.Create;
  TakeFlags := Intent.getFlags and
    (TJIntent.JavaClass.FLAG_GRANT_READ_URI_PERMISSION or
    TJIntent.JavaClass.FLAG_GRANT_WRITE_URI_PERMISSION);
  TAndroidHelper.Activity.getContentResolver.takePersistableUriPermission(fUri, TakeFlags);
end;

procedure TForm2.btn_ExifClick(Sender: TObject);
begin
  fExifProperty.Load(fAndroidUri.getDateiname(fUri));
end;

procedure TForm2.btn_MetadatenClick(Sender: TObject);
  procedure ImageMetaDataTexture(Uri: JNet_Uri); (* dumpImageMetaData *)
  // Gibt nur eine Zeile zurück, da die Abfrage auf ein einzelnes Dokument angewendet wird
  // Es ist nicht erforderlich, Felder zu filtern, zu sortieren oder auszuwählen
  // Weil wir alle Felder für ein Dokument wollen.
  var
    displayName, size: JString;
    sizeIndex: integer;
    cursor: JCursor;
  begin
    cursor := TAndroidHelper.Activity.getContentResolver.query(Uri, nil, nil, nil, nil, nil);
    try
      if (cursor <> nil) then
        if (cursor.moveToFirst) then
        begin
          displayName := cursor.getString(cursor.getColumnIndex(TJOpenableColumns.JavaClass.DISPLAY_NAME));
          Memo1.Lines.Add( { TAG.ToString + } 'Sichtbar Ad: ' + JStringToString(displayName));
          sizeIndex := cursor.getColumnIndex(TJOpenableColumns.JavaClass.SIZE);
          size := nil;
          if not(cursor.isNull(sizeIndex)) then
            size := cursor.getString(sizeIndex)
          else
            size := StringToJString('Unbekannt');
          Memo1.Lines.Add( { TAG.ToString + } 'Abmessungen: ' + JStringToString(size));
        end;
    finally
      cursor.close;
    end;
  end;
//var
//  Dateiname: string;
begin
  //Dateiname := fAndroidUri.getDateiname(fAndroidMessageActivity.UriCan);
  //TDialogService.ShowMessage(Dateiname);
  ImageMetaDataTexture(fUri);
end;

end.
