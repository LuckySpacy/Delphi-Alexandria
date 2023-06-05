unit View.Ansicht;

interface

uses
  View.Base, IBX.IBDatabase, Objekt.DBFeldList, Data.db, IBX.IBQuery;

type
  TVWAnsicht = class(TVWBasis)
  private
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure LoadByQuery(aQuery: TIBQuery); override;
  end;

implementation

{ TVWAnsicht }


constructor TVWAnsicht.Create;
begin
  inherited;
  fFeldList.Add('AK_ID', ftInteger);
  fFeldList.Add('AK_AKTIE', ftstring);
  fFeldList.Add('AK_WKN', ftstring);
  fFeldList.Add('AK_LINK', ftstring);
  fFeldList.Add('AK_BI_ID', ftInteger);
  fFeldList.Add('AK_SYMBOL', ftString);
  fFeldList.Add('AK_DEPOT', ftString);
  fFeldList.Add('AK_AKTIV', ftString);
  fFeldList.Add('TL_DATUM12', ftDate);
  fFeldList.Add('TL_WERT12', ftfloat);
  fFeldList.Add('TL_DATUM27', ftDate);
  fFeldList.Add('TL_WERT27', ftfloat);
  fFeldList.Add('HT_HOCH_JAHRKURS', ftfloat);
  fFeldList.Add('HT_HOCH_JAHRDATUM', ftDate);
  fFeldList.Add('HT_HOCH_HJAHRKURS', ftfloat);
  fFeldList.Add('HT_HOCH_HJAHRDATUM', ftDate);
  fFeldList.Add('HT_TIEF_JAHRKURS', ftfloat);
  fFeldList.Add('HT_TIEF_JAHRDATUM', ftDate);
  fFeldList.Add('HT_TIEF_HJAHRKURS', ftfloat);
  fFeldList.Add('HT_TIEF_HJAHRDATUM', ftDate);
  fFeldList.Add('HT_EPS', ftFloat);
  fFeldList.Add('HT_KGV', ftFloat);
  fFeldList.Add('HT_KGVSORT', ftString);
  fFeldList.Add('AP_DATUM7', ftDate);
  fFeldList.Add('AP_WERT7', ftFloat);
  fFeldList.Add('AP_DATUM14', ftDate);
  fFeldList.Add('AP_WERT14', ftFloat);
  fFeldList.Add('AP_DATUM30', ftDate);
  fFeldList.Add('AP_WERT30', ftFloat);
  fFeldList.Add('AP_DATUM60', ftDate);
  fFeldList.Add('AP_WERT60', ftFloat);
  fFeldList.Add('AP_DATUM90', ftDate);
  fFeldList.Add('AP_WERT90', ftFloat);
  fFeldList.Add('AP_DATUM180', ftDate);
  fFeldList.Add('AP_WERT180', ftFloat);
  fFeldList.Add('AP_DATUM365', ftDate);
  fFeldList.Add('AP_WERT365', ftFloat);
  fFeldList.Add('HT_LETZTERKURS', ftfloat);
  fFeldList.Add('HT_LETZTERKURSDATUM', ftDate);
  fFeldList.Add('AP_DATUM1', ftDate);
  fFeldList.Add('AP_WERT1', ftFloat);
end;

destructor TVWAnsicht.Destroy;
begin

  inherited;
end;

procedure TVWAnsicht.LoadByQuery(aQuery: TIBQuery);
begin
  inherited;
end;

end.
