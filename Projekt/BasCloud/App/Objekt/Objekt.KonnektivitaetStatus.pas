unit Objekt.KonnektivitaetStatus;

interface

uses
  System.SysUtils, System.Classes, Objekt.Ini, Objekt.Funktionen;

type
  TKonnektivitaetStatus = class
  private
    fWifi: Boolean;
    fMobileDaten: Boolean;
    fOffline: Boolean;
    fMerken_Wifi: Boolean;
    fMerken_Offline: Boolean;
    fMerken_MobileDaten: Boolean;
    fOnChanged: TNotifyEvent;
    procedure CheckStatus;
    procedure setMobileDaten(const Value: Boolean);
    procedure setOffline(const Value: Boolean);
    procedure setWifi(const Value: Boolean);
    function getMobileDaten: Boolean;
    function getOffline: Boolean;
    function getWifi: Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    property MobileDaten: Boolean read getMobileDaten write setMobileDaten;
    property Wifi: Boolean read getWifi write setWifi;
    property Offline: Boolean read getOffline write setOffline;
    property OnChanged: TNotifyEvent read fOnChanged write fOnChanged;
  end;

implementation

{ TKonnektivitaetStatus }


constructor TKonnektivitaetStatus.Create;
begin

end;

destructor TKonnektivitaetStatus.Destroy;
begin

  inherited;
end;


function TKonnektivitaetStatus.getMobileDaten: Boolean;
begin
  fMerken_MobileDaten := fMobileDaten;
  Result := fMobileDaten;
end;

function TKonnektivitaetStatus.getOffline: Boolean;
begin
  fMerken_Offline := fOffline;
  Result := fOffline;
end;

function TKonnektivitaetStatus.getWifi: Boolean;
begin
  fMerken_Wifi := fWifi;
  Result := fWifi;
end;

procedure TKonnektivitaetStatus.setMobileDaten(const Value: Boolean);
begin
  if Value then
  begin
    fWifi := false;
    fOffline := false;
  end;
  fMobileDaten := Value;
  CheckStatus;
end;

procedure TKonnektivitaetStatus.setOffline(const Value: Boolean);
begin
  if Value then
  begin
    fWifi := false;
    fMobileDaten := false;
  end;
  fOffline := Value;
  CheckStatus;
end;

procedure TKonnektivitaetStatus.setWifi(const Value: Boolean);
begin
  if Value then
  begin
    fOffline := false;
    fMobileDaten := false;
  end;
  fWifi := Value;
  CheckStatus;
end;

procedure TKonnektivitaetStatus.CheckStatus;
begin
  if (fMobileDaten <> fMerken_MobileDaten)
  or (fOffline <> fMerken_Offline)
  or (fWifi <> fMerken_Wifi) then
  begin
    fMerken_MobileDaten := fMobileDaten;
    fMerken_Wifi        := fWifi;
    fMerken_Offline     := fOffline;
    if Assigned(fOnChanged) then
      fOnChanged(Self);
  end;
end;


end.
