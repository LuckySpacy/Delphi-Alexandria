unit DB.Schnittstelle;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery, DB.Basis, Data.db;

type
  TDBSchnittstelle = class(TDBBasis)
  private
    fSchnittstellename: string;
    fLink: string;
  protected
    function getGeneratorName: string; override;
    function getTableName: string; override;
    function getTablePrefix: string; override;
    procedure FuelleDBFelder; override;
    procedure setSchnittstellename(const Value: string);
    procedure setLink(const Value: string); public
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure LoadByQuery(aQuery: TIBQuery); override;
    procedure SaveToDB; override;
    property Schnittstellename: string read fSchnittstellename write setSchnittstellename;
    property Link: string read fLink write setLink;
  end;

implementation

{ TDBSchnittstelle }

constructor TDBSchnittstelle.Create(AOwner: TComponent);
begin
  inherited;
  FFeldList.Add('SS_NAME', ftString);
  FFeldList.Add('SS_LINK', ftString);
  Init;
end;

destructor TDBSchnittstelle.Destroy;
begin

  inherited;
end;


procedure TDBSchnittstelle.Init;
begin
  inherited;
  fSchnittstellename:= '';
  fLink             := '';
  FuelleDBFelder;
end;

function TDBSchnittstelle.getTableName: string;
begin
  Result := 'Schnittstelle';
end;

function TDBSchnittstelle.getTablePrefix: string;
begin
  Result := 'SS';
end;

function TDBSchnittstelle.getGeneratorName: string;
begin
  Result := 'SS_ID';
end;

procedure TDBSchnittstelle.FuelleDBFelder;
begin
  fFeldList.FieldByName('SS_ID').AsInteger  := fID;
  fFeldList.FieldByName('SS_NAME').AsString := fSchnittstellename;
  fFeldList.FieldByName('SS_LINK').AsString := fLink;

  inherited;

end;


procedure TDBSchnittstelle.LoadByQuery(aQuery: TIBQuery);
begin
  inherited;
  if aQuery.Eof then
    exit;
  fSchnittstellename := aQuery.FieldByName('SS_NAME').AsString;
  fLink              := aQuery.FieldByName('SS_LINK').AsString;
  FuelleDBFelder;
end;

procedure TDBSchnittstelle.SaveToDB;
begin
  inherited;

end;

procedure TDBSchnittstelle.setLink(const Value: string);
begin
  UpdateV(fLink, Value);
  FuelleDBFelder;
end;

procedure TDBSchnittstelle.setSchnittstellename(const Value: string);
begin
  UpdateV(fSchnittstellename, Value);
  FuelleDBFelder;
end;

end.
