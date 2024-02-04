unit wma.CheckConnect;

interface

uses
  System.SysUtils, System.Variants, System.Classes, wma.Base, Web.HTTPApp,
  c.JsonError, db.TBTransaction;

type
  TwmaCheckConnect = class(TwmaBase)
  private
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure DoIt(aRequest: TWebRequest; aResponse: TWebResponse); override;
  end;

implementation

{ TwmaCheckConnect }

uses
  Json.CheckResult;

constructor TwmaCheckConnect.Create;
begin
  inherited;

end;

destructor TwmaCheckConnect.Destroy;
begin

  inherited;
end;

procedure TwmaCheckConnect.DoIt(aRequest: TWebRequest; aResponse: TWebResponse);
var
  JCheckResult: TJCheckResult;
begin
  inherited;
  JCheckResult := TJCheckResult.Create;
  try
    JCheckResult.FieldByName('OK').AsString := 'true';
    aResponse.Content := JCheckResult.JsonString;
    //aResponse.Content := '{"OK":"true"}';
  finally
    FreeAndNil(JCheckResult);
  end;
end;


end.
