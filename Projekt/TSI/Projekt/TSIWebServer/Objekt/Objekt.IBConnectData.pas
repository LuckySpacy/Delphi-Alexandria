unit Objekt.IBConnectData;

interface

type
  TIBConnectData = class
  private
    fPasswort: string;
    fPort: Integer;
    fDatenbankpfad: string;
    fDatenbankname: string;
    fHost: string;
    fUsername: string;
  public
    property Host: string read fHost write fHost;
    property Port: Integer read fPort write fPort;
    property Datenbankname: string read fDatenbankname write fDatenbankname;
    property Datenbankpfad: string read fDatenbankpfad write fDatenbankpfad;
    property Username: string read fUsername write fUsername;
    property Passwort: string read fPasswort write fPasswort;
    constructor create;
    destructor Destroy; override;
  end;

implementation

{ TIBConnectData }

constructor TIBConnectData.create;
begin
  fPasswort      := 'masterkey';
  fPort          := 3050;
  fDatenbankpfad := '';
  fDatenbankname := '';
  fHost          := '';
  fUsername      := 'sysdba';
end;

destructor TIBConnectData.Destroy;
begin

  inherited;
end;

end.
