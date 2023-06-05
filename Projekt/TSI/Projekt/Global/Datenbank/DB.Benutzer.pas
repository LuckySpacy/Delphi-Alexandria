unit DB.Benutzer;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery, DB.Basis, Data.db;
type
  TDBBenutzer = class(TDBBasis)
  private
    fPasswort: string;
    fMail: string;
    fNachname: string;
    fVorname: string;
    procedure setMail(const Value: string);
    procedure setNachname(const Value: string);
    procedure setPasswort(const Value: string);
    procedure setVorname(const Value: string);
  protected
    function getGeneratorName: string; override;
    function getTableName: string; override;
    function getTablePrefix: string; override;
    procedure FuelleDBFelder; override;
  public
    property Vorname: string read fVorname write setVorname;
    property Nachname: string read fNachname write setNachname;
    property Mail: string read fMail write setMail;
    property Passwort: string read fPasswort write setPasswort;
    procedure LoadByQuery(aQuery: TIBQuery); override;
    procedure SaveToDB; override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
  end;

implementation

{ TDBBenutzer }

constructor TDBBenutzer.Create(AOwner: TComponent);
begin
  inherited;
  FFeldList.Add('BE_VORNAME', ftString);
  FFeldList.Add('BE_NACHNAME', ftString);
  FFeldList.Add('BE_MAIL', ftString);
  FFeldList.Add('BE_PASSWORT', ftString);
  Init;
end;

destructor TDBBenutzer.Destroy;
begin

  inherited;
end;

function TDBBenutzer.getGeneratorName: string;
begin
  Result := 'BE_ID';
end;

function TDBBenutzer.getTableName: string;
begin
  Result := 'BENUTZER';
end;

function TDBBenutzer.getTablePrefix: string;
begin
  Result := 'BE';
end;


procedure TDBBenutzer.Init;
begin
  inherited;
  fVorname  := '';
  fNachname := '';
  fMail     := '';
  fPasswort := '';
  FuelleDBFelder;
end;


procedure TDBBenutzer.FuelleDBFelder;
begin
  fFeldList.FieldByName('BE_ID').AsInteger      := fID;
  fFeldList.FieldByName('BE_VORNAME').AsString  := fVorname;
  fFeldList.FieldByName('BE_NACHNAME').AsString := fNachname;
  fFeldList.FieldByName('BE_MAIL').AsString     := fMail;
  fFeldList.FieldByName('BE_PASSWORT').AsString := fPasswort;

  inherited;

end;

procedure TDBBenutzer.LoadByQuery(aQuery: TIBQuery);
begin
  inherited;
  if aQuery.Eof then
    exit;
  fVorname   := aQuery.FieldByName('BE_VORNAME').AsString;
  fNachname  := aQuery.FieldByName('BE_NACHNAME').AsString;
  fMail      := aQuery.FieldByName('BE_MAIL').AsString;
  fPasswort  := aQuery.FieldByName('BE_PASSWORT').AsString;
  FuelleDBFelder;
end;

procedure TDBBenutzer.SaveToDB;
begin
  inherited;

end;

procedure TDBBenutzer.setMail(const Value: string);
begin
  UpdateV(fMail, Value);
  FuelleDBFelder;
end;

procedure TDBBenutzer.setNachname(const Value: string);
begin
  UpdateV(fNachname, Value);
  FuelleDBFelder;
end;

procedure TDBBenutzer.setPasswort(const Value: string);
begin
  UpdateV(fPasswort, Value);
  FuelleDBFelder;
end;

procedure TDBBenutzer.setVorname(const Value: string);
begin
  UpdateV(fVorname, Value);
  FuelleDBFelder;
end;

end.
