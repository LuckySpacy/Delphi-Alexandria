unit DB.Sprachen;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, NFSQuery, DB.Basis, Data.db, DB.BasisHistorie;

type
  TDBSprachen = class(TDBBasisHistorie)
  private
    fBez: string;
    fStandard: boolean;
 protected
    function getGeneratorName: string; override;
    function getTableName: string; override;
    function getTablePrefix: string; override;
    function getTableId: Integer; override;
    procedure FuelleDBFelder; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure LoadByQuery(aQuery: TNFSQuery); override;
    procedure SaveToDB; override;
    property Bez: string read fBez write fBez;
    property Standard: boolean read fStandard write fStandard;
    procedure Read_Std;

  end;

implementation

{ TDBSprachen }

constructor TDBSprachen.Create(AOwner: TComponent);
begin
  inherited;
  FFeldList.Add('SP_BEZEICHNUNG', ftString);
  FFeldList.Add('SP_STD', ftstring);
  Init;
end;

destructor TDBSprachen.Destroy;
begin

  inherited;
end;

procedure TDBSprachen.Init;
begin
  inherited;
  fBez      := '';
  fStandard := false;
  FuelleDBFelder;
end;

procedure TDBSprachen.FuelleDBFelder;
begin

  fFeldList.FieldByName('SP_BEZEICHNUNG').AsString   := fBez;
  fFeldList.FieldByName('SP_STD').AsBoolean          := fStandard;

  inherited;

end;

function TDBSprachen.getGeneratorName: string;
begin
  Result := 'SP_ID';
end;

function TDBSprachen.getTableId: Integer;
begin
  Result := 0;
end;

function TDBSprachen.getTableName: string;
begin
  Result := 'SPRACHEN';
end;

function TDBSprachen.getTablePrefix: string;
begin
  Result := 'SP';
end;



procedure TDBSprachen.LoadByQuery(aQuery: TNFSQuery);
begin
  inherited;
  if aQuery.Eof then
    exit;
  fBez      := aQuery.FieldByName('SP_BEZEICHNUNG').AsString;
  fStandard := aQuery.FieldByName('SP_STD').AsString = 'T';
  FuelleDBFelder;
end;


procedure TDBSprachen.SaveToDB;
begin
  inherited;

end;


procedure TDBSprachen.Read_Std;
begin
  Init;
  if not Assigned(fTrans) then
    exit;
  fQuery.Close;
  fQuery.Transaction := fTrans;
  fQuery.SQL.Text := ' select sp_id, sp_bezeichnung, sp_std, sp_delete, sp_update ' +
                     ' from sprachen' +
                     ' where sp_delete != "T"' +
                     ' and   sp_std = "T"';
  OpenTrans;
  try
    fQuery.Open;
    LoadByQuery(fQuery);
  finally
    CommitTrans;
  end;
end;


end.
