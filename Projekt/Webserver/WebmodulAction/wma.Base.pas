unit wma.Base;

interface

uses
  System.SysUtils, System.Variants, System.Classes, Json.ErrorList, Web.HTTPApp,
  Objekt.AccessPermission, c.JsonError;

type
  TwmaBase = class
  private
    fJErrorList: TJErrorList;
    fAccessPermission: TAccessPermission;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    property JErrorList: TJErrorList read fJErrorList;
    procedure DoIt(aRequest: TWebRequest; aResponse: TWebResponse); virtual;
  end;

implementation

{ TwmaBase }

constructor TwmaBase.Create;
begin
  fJErrorList := TJErrorList.Create;
  fAccessPermission := TAccessPermission.Create;
end;

destructor TwmaBase.Destroy;
begin
  FreeAndNil(fAccessPermission);
  FreeAndNil(fJErrorList);
  inherited;
end;

procedure TwmaBase.DoIt(aRequest: TWebRequest; aResponse: TWebResponse);
var
  BearerToken: string;
  ErrorStr: string;
begin
  JErrorList.Clear;
  aResponse.ContentType := 'application/json;charset=utf-8';
  exit; // muss später wenn der Token funktioniert wieder raus.
  BearerToken := fAccessPermission.getBearerToken(aRequest.Authorization);
  ErrorStr := fAccessPermission.CheckToken(BearerToken);
  if ErrorStr > '' then
    fJErrorList.setError(ErrorStr, cJIdTokenError);
end;

end.
