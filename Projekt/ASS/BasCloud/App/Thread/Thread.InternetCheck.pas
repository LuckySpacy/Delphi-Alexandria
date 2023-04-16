unit Thread.InternetCheck;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, FMX.Dialogs;

type
  TEndInternetCheckEvent=procedure(aCheck: Boolean) of object;
  TThreadInternetCheck = class
  private
    fOnEndInternetCheck: TEndInternetCheckEvent;
    fCheck: Boolean;
    procedure EndInternetCheck(Sender: TObject);
  public
    constructor Create;
    destructor Destroy; override;
    procedure InternetCheck;
    procedure InternetCheck2;
    property OnEndInternetCheck: TEndInternetCheckEvent read fOnEndInternetCheck write fOnEndInternetCheck;
  end;

implementation

{ TThreadInternetCheck }

uses
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, Objekt.BasCloud, Json.Properties,
  Objekt.JBasCloud;

constructor TThreadInternetCheck.Create;
begin

end;

destructor TThreadInternetCheck.Destroy;
begin

  inherited;
end;

procedure TThreadInternetCheck.EndInternetCheck(Sender: TObject);
begin
  if Assigned(fOnEndInternetCheck) then
    fOnEndInternetCheck(fCheck);
end;

procedure TThreadInternetCheck.InternetCheck;
var
  t: TThread;
begin
  t := TThread.CreateAnonymousThread(
  procedure
  var
    TCPClient: TIdTCPClient;
  begin
    fCheck := false;
    TCPClient := TIdTCPClient.Create(nil);
    try
      try
        TCPClient.ReadTimeout:=2000;
        TCPClient.ConnectTimeout:=2000;
        TCPClient.Port:=80;
        TCPClient.Host:='google.com';
        TCPClient.Connect;
        TCPClient.Disconnect;
        fCheck := true;
      except
        fCheck:=false;
      end;
    finally
      FreeAndNil(TCPClient);
    end;
  end
  );
  t.OnTerminate := EndInternetCheck;
  t.Start;
end;

procedure TThreadInternetCheck.InternetCheck2;
var
  t: TThread;
begin
  fCheck := false;
  //EndInternetCheck(nil);
  //exit;
  t := TThread.CreateAnonymousThread(
  procedure
  begin
    try
      fCheck := JBasCloud.CheckInternet;
    except
      fCheck:=false;
    end;
  end
  );
  t.OnTerminate := EndInternetCheck;
  t.Start;
end;

end.
