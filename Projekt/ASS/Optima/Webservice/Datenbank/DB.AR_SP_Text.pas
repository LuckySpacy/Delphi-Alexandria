unit DB.AR_SP_Text;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, NFSQuery, DB.Basis, Data.db, DB.BasisHistorie;

type
  TDBAR_SP_Text = class(TDBBasisHistorie)
  private
    fBez: string;
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
    procedure Read_Artikel(SpId, ArId: Integer);
  end;

implementation

{ TDBAR_SP_Text }

constructor TDBAR_SP_Text.Create(AOwner: TComponent);
begin
  inherited;
  FFeldList.Add('AR_SP_BEZEICHNUNG', ftString);
  Init;
end;

destructor TDBAR_SP_Text.Destroy;
begin

  inherited;
end;

procedure TDBAR_SP_Text.Init;
begin
  inherited;
  fBez      := '';
  FuelleDBFelder;
end;


procedure TDBAR_SP_Text.FuelleDBFelder;
begin
  fFeldList.FieldByName('AR_SP_BEZEICHNUNG').AsString   := fBez;
  inherited;
end;

function TDBAR_SP_Text.getGeneratorName: string;
begin
  Result := 'AR_SP_ID';
end;

function TDBAR_SP_Text.getTableId: Integer;
begin
  Result := 0;
end;

function TDBAR_SP_Text.getTableName: string;
begin
  Result := 'AR_SP_TEXT';
end;

function TDBAR_SP_Text.getTablePrefix: string;
begin
  Result := 'AR_SP';
end;


procedure TDBAR_SP_Text.LoadByQuery(aQuery: TNFSQuery);
begin
  inherited;
  if aQuery.Eof then
    exit;
  fBez      := aQuery.FieldByName('AR_SP_BEZEICHNUNG').AsString;
  FuelleDBFelder;
end;


procedure TDBAR_SP_Text.SaveToDB;
begin
  inherited;

end;


procedure TDBAR_SP_Text.Read_Artikel(SpId, ArId: Integer);
begin
  Init;
  if not Assigned(fTrans) then
    exit;
  fQuery.Close;
  fQuery.Transaction := fTrans;
  fQuery.SQL.Text := ' select ar_sp_id, ar_sp_bezeichnung, ar_sp_delete, ar_sp_update ' +
                     ' from ar_sp_text' +
                     ' where ar_sp_delete != "T"' +
                     ' and   ar_sp_ar_id = ' + IntToStr(ArId) +
                     ' and   ar_sp_sp_id = ' + IntToStr(SpId);
  OpenTrans;
  try
    fQuery.Open;
    LoadByQuery(fQuery);
  finally
    CommitTrans;
  end;
end;


end.
