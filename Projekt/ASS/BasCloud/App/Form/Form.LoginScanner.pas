unit Form.LoginScanner;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, Form.Base,
  ASSQRCodeScanner, Objekt.ScannerView, FMX.StdCtrls, FMX.Layouts, FMX.ImgList,
  FMX.Controls.Presentation, FMX.Objects;

type
  Tfrm_Loginscanner = class(Tfrm_Base)
    Rec_Toolbar_Background: TRectangle;
    btn_Scannen: TSpeedButton;
    gly_Return: TGlyph;
    Lay_Image: TLayout;
    Ani_Wait: TAniIndicator;
    procedure FormCreate(Sender: TObject);
  private
    fOnLoginNichtErfolgreich: TNotifyEvent;
    fOnLoginErfolgreich: TNotifyEvent;
    fOnZurueck: TNotifyEvent;
    fScanner : TASSQRCodeScanner;
    fScannerView : TScannerView;
    procedure NewBitmapSize(aHeight, aWidth: Single);
    procedure Scanned(aValue: string);
    procedure btn_ReturnClick(Sender: TObject);
  public
    property OnZurueck: TNotifyEvent read fOnZurueck write fOnZurueck;
    property OnLoginErfolgreich: TNotifyEvent read fOnLoginErfolgreich write fOnLoginErfolgreich;
    property OnLoginNichtErfolgreich: TNotifyEvent read fOnLoginNichtErfolgreich write fOnLoginNichtErfolgreich;
    procedure StartScanner;
  end;

var
  frm_Loginscanner: Tfrm_Loginscanner;

implementation

{$R *.fmx}

{ Tfrm_Loginscanner }

uses
  FMX.DialogService, Objekt.BasCloud, FMX.Media, Json.QrCodeToken, Objekt.JBasCloud, System.DateUtils,
  Json.CurrentUser, DB.GebaudeList, DB.ToDoList, DB.DeviceList, DB.ZaehlerUpdateList;

procedure Tfrm_Loginscanner.FormCreate(Sender: TObject);
begin
  inherited;
  fScanner := TASSQRCodeScanner.Create;
  fScanner.OnBitmapSize := NewBitmapSize;
  fScanner.OnScanned := Scanned;
  fScannerView := TScannerView.Create(lay_Image);
  fScannerView.LineColor := TAlphaColor($FF005686);
  fScannerView.LineColor := TAlphacolors.Blue;
  fScannerView.ScannerHeight := 400;
  fScannerView.ScannerWidth  := 300;
  Ani_Wait.Visible := false;

  gly_Return.HitTest := true;
  gly_return.OnClick := btn_ReturnClick;

end;


procedure Tfrm_LoginScanner.NewBitmapSize(aHeight, aWidth: Single);
var
  Faktor: real;
  NewWidth: single;
begin
  Faktor := aHeight / fScannerView.ScannerHeight;
  NewWidth := aWidth/Faktor;
  fScannerView.ScannerHeight := fScannerView.ScannerHeight;
  fScannerView.ScannerWidth  := NewWidth;
  fScannerView.Aktual;
end;

procedure Tfrm_LoginScanner.Scanned(aValue: string);
var
  {$IFDEF WIN32}
  List: TStringList;
 {$ENDIF WIN32}
  JQrCodeToken: TJQrCodeToken;
  Vgl: string;
  JCurrentUser: TJCurrentUser;
  DBZaehlerUpdateList: TDBZaehlerUpdateList;
  //DBGebaudeList: TDBGebaudeList;
  DBToDoList: TDBToDoList;
  //DBDeviceList: TDBDeviceList;
begin

  JQrCodeToken := nil;
  JCurrentUser := nil;

  //TDialogService.ShowMessage('QR-Code = ' + aValue);
  {$IFDEF WIN32}
  List := TStringList.Create;
  try
    if DirectoryExists('c:\temp\') then
    begin
      List.Text := aValue;
      List.SaveToFile('c:\temp\LoginScanned.txt');
    end;
  finally
    FreeAndNil(List);
  end;
 {$ENDIF WIN32}

  vgl := copy(aValue, 1, 10);
  if vgl <> '{"expires"' then
  begin
    TDialogService.ShowMessage('QR-Code enthält keine Nutzerdaten.');
    if Assigned(fOnLoginNichtErfolgreich) then
       fOnLoginNichtErfolgreich(Self);
    exit;
  end;

  try
    JQrCodeToken := TJQrCodeToken.FromJsonString(aValue);
    JBasCloud.Token := JQrCodeToken.token;
    try
      JBasCloud.Read_Tenants;
    except
       TDialogService.ShowMessage('Except: JBasCloud.Read_Tenants');
   end;
    //JBasCloud.TokenExpire := IncYear(now, 10);
    JCurrentUser := JBasCloud.Read_CurrentUser;
    // TDialogService.ShowMessage('JBasCloud.Read_CurrentUser');
    if JBascloud.ErrorList.Count > 0 then
    begin
      TDialogService.ShowMessage('JBascloud.ErrorList.Count > 0');
      try
        Log.d('QR-Code Scannfehler');
        if JBascloud.ErrorList.TokenNichtMehrGueltig then
        begin
          TDialogService.ShowMessage('Token ist nicht mehr gültig.');
          exit;
        end;
        if JBascloud.ErrorList.InternalServerError then
        begin
          TDialogService.ShowMessage('Ungültiger QR-Code.' + sLineBreak + 'QR-Code beinhaltet kein Token.');
          exit;
        end;
        TDialogService.ShowMessage(JBascloud.ErrorList.getErrorString);
        exit;
      finally
        if Assigned(fOnLoginNichtErfolgreich) then
          fOnLoginNichtErfolgreich(Self);
      end;
    end;

    Log.d('QR-Code gefunden');

    if not SameText(BasCloud.Ini.LoginUserId, JCurrentUser.data.id) then
    begin
     // TDialogService.ShowMessage('BasCloud.Ini.LoginUserId, JCurrentUser.data.id');
      BasCloud.Ini.LoginUserId := JCurrentUser.data.id;
      //TDialogService.ShowMessage('Benutzer hat gewechselt');
      DBZaehlerUpdateList := TDBZaehlerUpdateList.Create;
      DBZaehlerUpdateList.DeleteAll;
      FreeAndNil(DBZaehlerUpdateList);
      //DBGebaudeList := TDBGebaudeList.Create;
      //DBGebaudeList.DeleteAll;
      //FreeAndNil(DBGebaudeList);
      DBToDoList := TDBToDoList.Create;
      DBToDoList.DeleteAll;
      FreeAndNil(DBToDoList);
      //DBDeviceList := TDBDeviceList.Create;
      //DBDeviceList.DeleteAll;
      //FreeAndNil(DBDeviceList);
    end;

  //  TDialogService.ShowMessage('BasCloud.getExpireDate(JQrCodeToken.expires)');
    JBasCloud.TokenExpire      := BasCloud.getExpireDate(JQrCodeToken.expires);
    BasCloud.Ini.LoginMail     := JCurrentUser.data.attributes.email;
    BasCloud.Ini.LoginToken    := JQrCodeToken.token;
    BasCloud.Ini.LoginExpires  := FormatDateTime('dd.mm.yyyy hh:nn:ss', JBasCloud.TokenExpire);
    BasCloud.Ini.LoginPasswort := '';


  finally
    if JQrCodeToken <> nil then
      FreeAndNil(JQrCodeToken);
    if JCurrentUser <> nil then
      FreeAndNil(JCurrentUser);
  end;

 // TDialogService.ShowMessage('Login Erfolgreich');

  Log.d('Assigned(fOnLoginErfolgreich)');
  if Assigned(fOnLoginErfolgreich) then
    fOnLoginErfolgreich(Self);

end;


procedure Tfrm_LoginScanner.btn_ReturnClick(Sender: TObject);
begin
  fScanner.Stop;
  if Assigned(fOnZurueck) then
    fOnZurueck(Self);
end;

procedure Tfrm_Loginscanner.StartScanner;
//var
//  List: TStringList;
begin
    {
  List := TStringList.Create;
  List.LoadFromFile('c:\Users\tbachmann.GB\AppData\Roaming\Documents\token_StefanSchaffner.txt');
  //List.LoadFromFile('c:\Users\tbachmann.GB\AppData\Roaming\Documents\token_bachmann.txt');
  Scanned(Trim(List.Text));
  FreeAndNil(List);
  exit;
  }
  fScanner.CameraImage := fScannerView.Image;
  fScanner.Start;
  fScannerView.Aktual;
end;



end.
