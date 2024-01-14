unit DB.Token;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery, DB.Basis, Data.db, DB.TBQuery,
  Objekt.FeldList, c.JsonError, db.TBTransaction, Json.ErrorList;

type
  TDBToken = class(TDBBasis)
  private
    fToken: string;
    fPassword: string;
    fModul: string;
    fUser: string;
    procedure setModul(const Value: string);
    procedure setPassword(const Value: string);
    procedure setToken(const Value: string);
    procedure setUser(const Value: string);
  protected
    function getGeneratorName: string; override;
    function getTableName: string; override;
    function getTablePrefix: string; override;
    procedure FuelleDBFelder; override;
    procedure FuelleDBFelderFromJson; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure LoadByQuery(aQuery: TTBQuery); override;
    procedure SaveToDB; override;
    property Modul: string read fModul write setModul;
    property User: string read fUser write setUser;
    property Password: string read fPassword write setPassword;
    property Token: string read fToken write setToken;
    function CheckToken(aToken: string): Boolean;
    function getToken(aUser, aPassword, aModul: string): string;
  end;


implementation

{ TDBToken }

constructor TDBToken.Create(AOwner: TComponent);
begin
  inherited;
  fFeldList.Add('TO_MODUL', ftString);
  fFeldList.Add('TO_USER', ftString);
  fFeldList.Add('TO_PASSWORD', ftString);
  fFeldList.Add('TO_TOKEN', ftString);
  Init;
end;

destructor TDBToken.Destroy;
begin

  inherited;
end;

procedure TDBToken.Init;
begin
  inherited;
  fToken    := '';
  fPassword := '';
  fModul    := '';
  fUser     := '';
  FuelleDBFelder;
end;


procedure TDBToken.FuelleDBFelder;
begin
  fFeldList.FieldByName('TO_MODUL').AsString    := fModul;
  fFeldList.FieldByName('TO_USER').AsString     := fUser;
  fFeldList.FieldByName('TO_PASSWORD').AsString := fPassword;
  fFeldList.FieldByName('TO_TOKEN').AsString    := fToken;
  inherited;
end;

procedure TDBToken.FuelleDBFelderFromJson;
begin
  inherited;
end;

function TDBToken.getGeneratorName: string;
begin
  Result := 'TO_ID';
end;

function TDBToken.getTableName: string;
begin
  Result := 'TOKEN';
end;

function TDBToken.getTablePrefix: string;
begin
  Result := 'TO';
end;



procedure TDBToken.LoadByQuery(aQuery: TTBQuery);
begin
  inherited;
  if aQuery.Eof then
    exit;
  fModul    := aQuery.FieldByName('TO_MODUL').AsString;
  fUser     := aQuery.FieldByName('TO_USER').AsString;
  fPassword := aQuery.FieldByName('TO_PASSWORD').AsString;
  fToken    := aQuery.FieldByName('TO_TOKEN').AsString;
  FuelleDBFelder;
end;

procedure TDBToken.SaveToDB;
begin
  inherited;

end;

procedure TDBToken.setModul(const Value: string);
begin
  UpdateV(fModul, Value);
  fFeldList.FieldByName('TO_MODUL').AsString := fModul;
end;

procedure TDBToken.setPassword(const Value: string);
begin
  UpdateV(fPassword, Value);
  fFeldList.FieldByName('TO_PASSWORD').AsString := fPassword;
end;

procedure TDBToken.setToken(const Value: string);
begin
  UpdateV(fToken, Value);
  fFeldList.FieldByName('TO_TOKEN').AsString := fToken;
end;

procedure TDBToken.setUser(const Value: string);
begin
  UpdateV(fUser, Value);
  fFeldList.FieldByName('TO_USER').AsString := fUser;
end;


function TDBToken.CheckToken(aToken: string): Boolean;
begin
  Result := false;
  Init;
  if not Assigned(fTrans) then
    exit;
  fQuery.Close;
  fQuery.Transaction := fTrans;
  fQuery.SQL.Text := 'select * from ' + getTableName +
                     ' where TO_DELETE != ' + QuotedStr('T') +
                     ' and TO_TOKEN = ' + QuotedStr(aToken);
  fTrans.OpenTrans;
  try
    fQuery.Open;
    Result := not fQuery.Eof;
    LoadByQuery(fQuery);
    fQuery.Close;
  finally
    fTrans.CommitTrans;
  end;
end;

function TDBToken.getToken(aUser, aPassword, aModul: string): string;
begin
  Result := '';
  Init;
  if not Assigned(fTrans) then
    exit;
  fQuery.Close;
  fQuery.Transaction := fTrans;
  fQuery.SQL.Text := 'select * from ' + getTableName +
                     ' where TO_DELETE != ' + QuotedStr('T') +
                     ' and TO_MODUL = ' + QuotedStr(aModul) +
                     ' and lower(TO_USER) = ' + QuotedStr(lowercase(aUser)) +
                     ' and TO_PASSWORD = ' + QuotedStr(aPassword);
  fTrans.OpenTrans;
  try
    fQuery.Open;
    if not fQuery.Eof then
      Result := fQuery.FieldByName('TO_TOKEN').AsString;
    LoadByQuery(fQuery);
    fQuery.Close;
  finally
    fTrans.CommitTrans;
  end;
end;


end.
