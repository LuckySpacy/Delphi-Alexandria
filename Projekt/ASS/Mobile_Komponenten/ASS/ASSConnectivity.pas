unit ASSConnectivity;

interface

uses
  System.SysUtils
  {$IF DEFINED(IOS) OR DEFINED(ANDROID)}
   , DW.Connectivity
  {$ENDIF}
  ;


type
  TASSConnectivity = class
  private
  {$IF DEFINED(IOS) OR DEFINED(ANDROID)}
    fConnectivity: TConnectivity;
  {$ENDIF}
  public
    function WifiInternetConnection: Boolean;
    function ConnectedToInternet: Boolean;
    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TASSConnectivity }


constructor TASSConnectivity.Create;
begin
  {$IF DEFINED(IOS) OR DEFINED(ANDROID)}
  FConnectivity := TConnectivity.Create;
  {$ENDIF}
end;

destructor TASSConnectivity.Destroy;
begin
  {$IF DEFINED(IOS) OR DEFINED(ANDROID)}
  FreeAndNil(fConnectivity);
  {$ENDIF}
  inherited;
end;


function TASSConnectivity.ConnectedToInternet: Boolean;
begin
  {$IF DEFINED(WIN32) OR DEFINED(WIN64)}
   Result := true;
  {$ENDIF}
  {$IF DEFINED(IOS) OR DEFINED(ANDROID)}
  Result := FConnectivity.IsConnectedToInternet;
  {$ENDIF}
end;


function TASSConnectivity.WifiInternetConnection: Boolean;
begin
  {$IF DEFINED(WIN32) OR DEFINED(WIN64)}
  Result := true;
  {$ENDIF}
  {$IF DEFINED(IOS) OR DEFINED(ANDROID)}
  Result := FConnectivity.IsWifiInternetConnection;
  {$ENDIF}
end;

end.
