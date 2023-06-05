unit View.Depotwerte;

interface

uses
  View.Base, IBX.IBDatabase, Objekt.DBFeldList, Data.db, IBX.IBQuery;

type
  TVWDepotwerte = class(TVWBasis)
  private
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure LoadByQuery(aQuery: TIBQuery); override;
  end;

implementation

{ TVWDepotwerte }

constructor TVWDepotwerte.Create;
begin
  inherited;
  fFeldList.Add('DW_ID', ftInteger);
  fFeldList.Add('DW_DP_ID', ftInteger);
  fFeldList.Add('DW_AK_ID', ftInteger);
  fFeldList.Add('AK_WKN', ftstring);
  fFeldList.Add('AK_AKTIE', ftstring);
end;

destructor TVWDepotwerte.Destroy;
begin

  inherited;
end;

procedure TVWDepotwerte.LoadByQuery(aQuery: TIBQuery);
begin
  inherited;

end;

end.
