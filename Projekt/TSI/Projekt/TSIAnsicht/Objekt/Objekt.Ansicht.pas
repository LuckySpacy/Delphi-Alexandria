unit Objekt.Ansicht;

interface

uses
  SysUtils;

type
  TAnsicht = class
  private
    fAkId: Integer;
    fAktie: string;
    fWKN: string;
    fLink: string;
    fBiId: Integer;
    fSymbol: string;
    fDepot: Boolean;
    fAktiv: Boolean;
    FDatum12: TDateTime;
    fWert12: real;
    fDatum27: TDateTime;
    fWert27: real;
    fHochJahrKurs: real;
    fHochJahrDatum: TDateTime;
    fHochHJahrDatum: TDateTime;
    fHochHJahrKurs: real;
    fTiefJahrKurs: real;
    fTiefHJahrKurs: real;
    fTiefJahrDatum: TDateTime;
    fTiefHJahrDatum: TDateTime;
    fKGV: real;
    fEPS: real;
    fKGVSort: string;
    fDatum7: TDateTime;
    fWert7: real;
    fWert180: real;
    fDatum90: TDateTime;
    fDatum365: TDateTime;
    fWert90: real;
    fDatum30: TDateTime;
    fDatum60: TDateTime;
    fWert365: real;
    fWert30: real;
    fDatum14: TDateTime;
    fDatum1: TDateTime;
    fWert60: real;
    fWert14: real;
    fWert1: real;
    fDatum180: TDateTime;
    fLetzterKursDatum: TDateTime;
    fLetzterKurs: real;
  protected
  public
    constructor Create;
    destructor Destroy; override;
    property AkId: Integer read fAkId write fAkId;
    property Aktie: string read fAktie write fAktie;
    property WKN: string read fWKN write fWKN;
    property Link: string read fLink write fLink;
    property BiId: Integer read fBiId write fBiId;
    property Symbol: string read fSymbol write fSymbol;
    property Depot: Boolean read fDepot write fDepot;
    property Aktiv: Boolean read fAktiv write fAktiv;
    property Datum12: TDateTime read fDatum12 write FDatum12;
    property Wert12: real read fWert12 write fWert12;
    property Datum27: TDateTime read fDatum27 write FDatum27;
    property Wert27: real read fWert27 write fWert27;
    property HochJahrKurs: real read fHochJahrKurs write fHochJahrKurs;
    property HochJahrDatum: TDateTime read fHochJahrDatum write fHochJahrDatum;
    property HochHJahrKurs: real read fHochHJahrKurs write fHochHJahrKurs;
    property HochHJahrDatum: TDateTime read fHochHJahrDatum write fHochHJahrDatum;
    property TiefJahrKurs: real read fTiefJahrKurs write fTiefJahrKurs;
    property TiefJahrDatum: TDateTime read fTiefJahrDatum write fTiefJahrDatum;
    property TiefHJahrKurs: real read fTiefHJahrKurs write fTiefHJahrKurs;
    property TiefHJahrDatum: TDateTime read fTiefHJahrDatum write fTiefHJahrDatum;
    property EPS: real read fEPS write fEPS;
    property KGV: real read fKGV write fKGV;
    property KGVSort: string read fKGVSort write fKGVSort;
    property Datum7: TDateTime read fDatum7 write fDatum7;
    property Wert7: real read fWert7 write fWert7;
    property Datum14: TDateTime read fDatum14 write fDatum14;
    property Wert14: real read fWert14 write fWert14;
    property Datum30: TDateTime read fDatum30 write fDatum30;
    property Wert30: real read fWert30 write fWert30;
    property Datum60: TDateTime read fDatum60 write fDatum60;
    property Wert60: real read fWert60 write fWert60;
    property Datum90: TDateTime read fDatum90 write fDatum90;
    property Wert90: real read fWert90 write fWert90;
    property Datum180: TDateTime read fDatum180 write fDatum180;
    property Wert180: real read fWert180 write fWert180;
    property Datum365: TDateTime read fDatum365 write fDatum365;
    property Wert365: real read fWert365 write fWert365;
    property Datum1: TDateTime read fDatum1 write fDatum1;
    property Wert1: real read fWert1 write fWert1;
    property LetzterKurs: real read fLetzterKurs write fLetzterKurs;
    property LetzterKursDatum: TDateTime read fLetzterKursDatum write fLetzterKursDatum;
  end;

implementation

{ TAnsicht }

constructor TAnsicht.Create;
begin

end;

destructor TAnsicht.Destroy;
begin

  inherited;
end;

end.
