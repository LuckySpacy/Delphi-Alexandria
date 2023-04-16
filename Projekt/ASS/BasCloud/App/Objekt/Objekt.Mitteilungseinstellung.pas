unit Objekt.Mitteilungseinstellung;

interface

uses
  System.SysUtils, System.Classes, Objekt.Ini, Objekt.Funktionen;

type
  TIniMitteilungseinstellung = class
  private
    fIni: TIni;
    fIniPath: string;
    fIniFilename: string;
    fFunktion: TFunktionen;
    function getAlleZaehlerstaendewurdengeladen: Boolean;
    function getDatenInAppAktualisiert: Boolean;
    procedure setAlleZaehlerstaendewurdengeladen(const Value: Boolean);
    procedure setDatenInAppAktualisiert(const Value: Boolean);
    function getDatenWurdenAktualisiert: Boolean;
    procedure setDatenWurdenAktualisiert(const Value: Boolean);
    function getNeueAufgaben: Boolean;
    procedure setNeueAufgaben(const Value: Boolean);
    function getZaehlerstaendeAktualisiert: Boolean;
    procedure setZaehlerstaendeAktualisiert(const Value: Boolean);
    function getZaehlerWurdeHochgeladen: Boolean;
    procedure setZaehlerWurdeHochgeladen(const Value: Boolean);
  public
    constructor Create;
    destructor Destroy; override;
    property DatenInAppAktualisiert: Boolean read getDatenInAppAktualisiert write setDatenInAppAktualisiert;
    property AlleZaehlerstaendewurdengeladen: Boolean read getAlleZaehlerstaendewurdengeladen write setAlleZaehlerstaendewurdengeladen;
    property DatenWurdenAktualisiert: Boolean read getDatenWurdenAktualisiert write setDatenWurdenAktualisiert;
    property NeueAufgaben: Boolean read getNeueAufgaben write setNeueAufgaben;
    property ZaehlerstaendeAktualisiert: Boolean read getZaehlerstaendeAktualisiert write setZaehlerstaendeAktualisiert;
    property ZaehlerWurdeHochgeladen: Boolean read getZaehlerWurdeHochgeladen write setZaehlerWurdeHochgeladen;
    property Ini: TIni read fIni write fIni;
    property IniPath: string read fIniPath write fIniPath;
    property IniFilename: string read fIniFilename write fIniFilename;
  end;

implementation

{ TIniMitteilungseinstellung }

constructor TIniMitteilungseinstellung.Create;
begin
  fFunktion := TFunktionen.Create;
end;

destructor TIniMitteilungseinstellung.Destroy;
begin
  FreeAndNil(fFunktion);
  inherited;
end;

function TIniMitteilungseinstellung.getAlleZaehlerstaendewurdengeladen: Boolean;
begin
  Result := fIni.ReadIni(fIniFilename, 'Mitteilungseinstellung', 'AlleZaehlerstaendewurdengeladen', '0') = '1';
end;

function TIniMitteilungseinstellung.getDatenInAppAktualisiert: Boolean;
begin
  Result := fIni.ReadIni(fIniFilename, 'Mitteilungseinstellung', 'DatenInAppAktualisiert', '0') = '1';
end;

function TIniMitteilungseinstellung.getDatenWurdenAktualisiert: Boolean;
begin
  Result := fIni.ReadIni(fIniFilename, 'Mitteilungseinstellung', 'DatenWurdenAktualisiert', '0') = '1';
end;

function TIniMitteilungseinstellung.getNeueAufgaben: Boolean;
begin
  if Trim(fIni.ReadIni(fIniFilename, 'Mitteilungseinstellung', 'NeueAufgaben', '')) = '' then
  begin
    Result := true;
    exit;
  end;
  Result := fIni.ReadIni(fIniFilename, 'Mitteilungseinstellung', 'NeueAufgaben', '0') = '1';
end;

function TIniMitteilungseinstellung.getZaehlerstaendeAktualisiert: Boolean;
begin
  if Trim(fIni.ReadIni(fIniFilename, 'Mitteilungseinstellung', 'ZaehlerstaendeAktualisiert', '')) = '' then
  begin
    Result := true;
    exit;
  end;
  Result := fIni.ReadIni(fIniFilename, 'Mitteilungseinstellung', 'ZaehlerstaendeAktualisiert', '0') = '1';
end;

function TIniMitteilungseinstellung.getZaehlerWurdeHochgeladen: Boolean;
begin
  if Trim(fIni.ReadIni(fIniFilename, 'Mitteilungseinstellung', 'ZaehlerWurdeHochgeladen', '')) = '' then
  begin
    Result := true;
    exit;
  end;
  Result := fIni.ReadIni(fIniFilename, 'Mitteilungseinstellung', 'ZaehlerWurdeHochgeladen', '0') = '1';
end;

procedure TIniMitteilungseinstellung.setAlleZaehlerstaendewurdengeladen(const Value: Boolean);
begin
  fIni.WriteIni(fIniFilename, 'Mitteilungseinstellung', 'AlleZaehlerstaendewurdengeladen',  fFunktion.BoolToStr(Value));
end;

procedure TIniMitteilungseinstellung.setDatenInAppAktualisiert(const Value: Boolean);
begin
  fIni.WriteIni(fIniFilename, 'Mitteilungseinstellung', 'DatenInAppAktualisiert',  fFunktion.BoolToStr(Value));
end;

procedure TIniMitteilungseinstellung.setDatenWurdenAktualisiert(const Value: Boolean);
begin
  fIni.WriteIni(fIniFilename, 'Mitteilungseinstellung', 'DatenWurdenAktualisiert',  fFunktion.BoolToStr(Value));
end;

procedure TIniMitteilungseinstellung.setNeueAufgaben(const Value: Boolean);
begin
  fIni.WriteIni(fIniFilename, 'Mitteilungseinstellung', 'NeueAufgaben',  fFunktion.BoolToStr(Value));
end;

procedure TIniMitteilungseinstellung.setZaehlerstaendeAktualisiert(
  const Value: Boolean);
begin
  fIni.WriteIni(fIniFilename, 'Mitteilungseinstellung', 'ZaehlerstaendeAktualisiert',  fFunktion.BoolToStr(Value));
end;

procedure TIniMitteilungseinstellung.setZaehlerWurdeHochgeladen(const Value: Boolean);
begin
  fIni.WriteIni(fIniFilename, 'Mitteilungseinstellung', 'ZaehlerWurdeHochgeladen',  fFunktion.BoolToStr(Value));
end;

end.
