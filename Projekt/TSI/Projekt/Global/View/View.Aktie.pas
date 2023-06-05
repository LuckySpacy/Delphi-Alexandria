unit View.Aktie;

interface

uses
  View.Base, IBX.IBDatabase, Objekt.DBFeldList, Data.db, IBX.IBQuery;

type
  TVWAktie = class(TVWBasis)
  private
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure LoadByQuery(aQuery: TIBQuery); override;
    //procedure ReadAll;
  end;

implementation

{ TVWAktie }


constructor TVWAktie.Create;
begin
  inherited;
  fFeldList.Add('AS_ID', ftInteger);
  fFeldList.Add('AS_AK_ID', ftInteger);
  fFeldList.Add('AS_SS_ID', ftInteger);
  fFeldList.Add('AS_PARAM1', ftstring);
  fFeldList.Add('AK_ID', ftInteger);
  fFeldList.Add('AK_AKTIE', ftstring);
  fFeldList.Add('AK_WKN', ftstring);
  fFeldList.Add('AK_LINK', ftstring);
  fFeldList.Add('AK_BI_ID', ftInteger);
  fFeldList.Add('AK_SYMBOL', ftString);
  fFeldList.Add('AK_DEPOT', ftString);
  fFeldList.Add('AK_AKTIV', ftString);
end;

destructor TVWAktie.Destroy;
begin

  inherited;
end;

procedure TVWAktie.LoadByQuery(aQuery: TIBQuery);
begin
  inherited;
end;


{
procedure TVWAktie.ReadAll;
begin
  if fquery.Transaction = nil then
    exit;
  fQuery.Sql.Text := ' select * from aktie ' +
                     ' join akst on as_ak_id = ak_id ' +
                     ' order by aktie.AK_AKTIE';
  OpenTrans;
  fFeldList.Clear;
  fQuery.Open;
  while not fQuery.Eof do
  begin
    ffeldlist.Add
    fQuery.Next;
  end;
end;
}
end.
