unit Objekt.BasCloudInternetCheck;

interface

uses
   System.SysUtils, Thread.InternetCheck;

type
  TEndInternetCheckEvent=procedure(aCheck: Boolean) of object;
  TBasCloudInternetCheck = class
  private
    fThreadInternetCheck: TThreadInternetCheck;
    fOnEndInternetCheck: TEndInternetCheckEvent;
    fIsInternetChecked: Boolean;
    fInternetOk: Boolean;
    procedure EndCheckInternet(aCheck: Boolean);
  public
    constructor Create;
    destructor Destroy; override;
    //procedure WaitForInternetCheck1;
    //procedure WaitForInternetCheck2;
    procedure InternetCheck1;
    procedure InternetCheck2;
    property OnEndInternetCheck: TEndInternetCheckEvent read fOnEndInternetCheck write fOnEndInternetCheck;
    property InternetOk: Boolean read fInternetOk;
  end;

implementation

{ TBasCloudInternetCheck }

uses
  FMX.Forms;


constructor TBasCloudInternetCheck.Create;
begin
  fThreadInternetCheck := TThreadInternetCheck.Create;
end;

destructor TBasCloudInternetCheck.Destroy;
begin
  FreeAndNil(fThreadInternetCheck);
  inherited;
end;


procedure TBasCloudInternetCheck.EndCheckInternet(aCheck: Boolean);
begin
  fIsInternetChecked := true;
  fInternetOk := aCheck;
  if Assigned(fOnEndInternetCheck) then
    fOnEndInternetCheck(aCheck);
end;

procedure TBasCloudInternetCheck.InternetCheck1;
begin
  fThreadInternetCheck.OnEndInternetCheck := EndCheckInternet;
  fThreadInternetCheck.InternetCheck;
end;

procedure TBasCloudInternetCheck.InternetCheck2;
begin
  fThreadInternetCheck.OnEndInternetCheck := EndCheckInternet;
  fThreadInternetCheck.InternetCheck2;
end;


{
procedure TBasCloudInternetCheck.WaitForInternetCheck1;
begin
  fInternetOk := false;
  fIsInternetChecked := false;
  fThreadInternetCheck.OnEndInternetCheck := EndCheckInternet;
  fThreadInternetCheck.InternetCheck;
  while not fIsInternetChecked do
    Application.ProcessMessages;
end;


procedure TBasCloudInternetCheck.WaitForInternetCheck2;
begin
  fInternetOk := false;
  fIsInternetChecked := false;
  fThreadInternetCheck.OnEndInternetCheck := EndCheckInternet;
  fThreadInternetCheck.InternetCheck2;
  while not fIsInternetChecked do
    Application.ProcessMessages;
end;
}

end.
