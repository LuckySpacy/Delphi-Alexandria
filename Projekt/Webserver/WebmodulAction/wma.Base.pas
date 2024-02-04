unit wma.Base;

interface

uses
  System.SysUtils, System.Variants, System.Classes, Json.ErrorList, Web.HTTPApp,
  Objekt.AccessPermission, c.JsonError, db.TBTransaction;
type
  TwmaBase = class
  private
    fJErrorList: TJErrorList;
    fAccessPermission: TAccessPermission;
  protected
    fTrans: TTBTransaction;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    property JErrorList: TJErrorList read fJErrorList;
    procedure DoIt(aRequest: TWebRequest; aResponse: TWebResponse); virtual;
  end;

implementation

{ TwmaBase }

uses
  Datenmodul.Database, Fmx.DialogService;

constructor TwmaBase.Create;
begin
  fJErrorList := TJErrorList.Create;
  fAccessPermission := TAccessPermission.Create;
  fTrans := TTBTransaction.Create(nil);
end;

destructor TwmaBase.Destroy;
begin
  FreeAndNil(fAccessPermission);
  FreeAndNil(fJErrorList);
  FreeAndNil(fTrans);
  inherited;
end;

procedure TwmaBase.DoIt(aRequest: TWebRequest; aResponse: TWebResponse);
var
  BearerToken: string;
  ErrorStr: string;
begin
  JErrorList.Clear;
  aResponse.ContentType := 'application/json;charset=utf-8';
  //exit; // muss später wenn der Token funktioniert wieder raus.
  BearerToken := fAccessPermission.getBearerToken(aRequest.Authorization);
  ErrorStr := fAccessPermission.CheckToken(BearerToken);
  if ErrorStr > '' then
    fJErrorList.setError(ErrorStr, cJIdTokenError);
  //TDialogService.ShowMessage('ErrorStr = ' + ErrorStr);
end;

end.
