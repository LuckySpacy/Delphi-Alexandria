unit Objekt.EnergieverbrauchCalc;

interface

uses
  System.SysUtils, System.Variants, System.Classes, db.TBTransaction;

type
  TEnergieverbrauchCalc = class
  private
    fTrans: TTBTransaction;
  public
    constructor Create(aTrans: TTBTransaction);
    destructor Destroy; override;
    procedure CalcVerbrauch(aZaId: Integer; aDatum: TDateTime);
    procedure CalcVerbrauchMonate(aZaId: Integer; aJahr: Integer);
    procedure VerbrauchKomplettNeuBerechnen(aZaId: Integer);
  end;

implementation

{ TEnergieverbrauchCalc }

uses
  DB.EnergieverbrauchVerbrauch, DB.EnergieverbrauchZaehlerstand, DB.EnergieverbrauchZaehlerstandList,
  DateUtils, DB.EnergieverbrauchVerbrauchList, DB.EnergieverbrauchVerbrauchMonat;


constructor TEnergieverbrauchCalc.Create(aTrans: TTBTransaction);
begin
  fTrans := aTrans;
end;

destructor TEnergieverbrauchCalc.Destroy;
begin

  inherited;
end;

procedure TEnergieverbrauchCalc.CalcVerbrauch(aZaId: Integer; aDatum: TDateTime);
type
  REndpunkt = record
    Datum: TDateTime;
    Wert: Extended;
  end;
var
  DBVerbrauch: TDBEnergieverbrauchVerbrauch;
  DBZaehlerstand: TDBEnergieverbrauchZaehlerstand;
  LetzterEndpunkt: REndpunkt;
  NaechsterEndpunkt: REndpunkt;
  BasisEndpunkt: REndpunkt;
  Tage: Integer;
  VerbrauchGesamt: Currency;
  VerbrauchProTag: Currency;
  Enddatum: TDateTime;
  Startdatum: TDateTime;
  Datum: TDateTime;
begin
  DBZaehlerstand := TDBEnergieverbrauchZaehlerstand.Create(nil);
  DBVerbrauch    := TDBEnergieverbrauchVerbrauch.Create(nil);
  try
    DBZaehlerstand.Trans := fTrans;
    DBVerbrauch.Trans    := fTrans;
    BasisEndpunkt.Datum     := trunc(aDatum);
    LetzterEndpunkt.Datum   := DBZaehlerstand.getLetzterEndpunkt(aZaId, aDatum);
    NaechsterEndpunkt.Datum := DBZaehlerstand.getNaechsterEndpunkt(aZaId, aDatum);
    LetzterEndpunkt.Wert    := DBZaehlerstand.getEndpunktWert(aZaId, LetzterEndpunkt.Datum);
    NaechsterEndpunkt.Wert  := DBZaehlerstand.getEndpunktWert(aZaId, NaechsterEndpunkt.Datum);
    BasisEndpunkt.Wert      := DBZaehlerstand.getEndpunktWert(aZaId, BasisEndpunkt.Datum);

    if NaechsterEndpunkt.Datum < StrToDate('01.01.1900') then // Es gibt kein nächster Endpunkt
      NaechsterEndpunkt.Datum := BasisEndpunkt.Datum;


    DBVerbrauch.DeleteBereich(aZaId, LetzterEndpunkt.Datum, NaechsterEndpunkt.Datum);

    if LetzterEndpunkt.Datum < StrToDate('01.01.1900') then
      exit; // Wenn es noch keine früheren Endpunkt gibt, dann habe ich noch kein Verbrauch. Verbrauch kann erst zwischen zwei Endpunkten ermittelt werden.

    Tage := DaysBetween(LetzterEndpunkt.Datum, BasisEndpunkt.Datum);
    VerbrauchGesamt := BasisEndpunkt.Wert - LetzterEndpunkt.Wert;
    VerbrauchProTag := VerbrauchGesamt / Tage;

    if VerbrauchProTag < 0 then
      VerbrauchProTag := DBVerbrauch.getLetzterVerbrauch(aZaId, LetzterEndpunkt.Datum);

    EndDatum   := BasisEndpunkt.Datum;
    StartDatum := LetzterEndpunkt.Datum;
    Datum := StartDatum;
    while Datum < EndDatum do
    begin
      DBVerbrauch.Init;
      DBVerbrauch.ZaId  := aZaId;
      DBVerbrauch.Wert  := VerbrauchProTag;
      DBVerbrauch.Datum := Datum;
      DBVerbrauch.SaveToDB;
      Datum := IncDay(Datum, 1);
    end;

    if NaechsterEndpunkt.Datum <= BasisEndpunkt.Datum then
      exit;

    Tage := DaysBetween(BasisEndpunkt.Datum, NaechsterEndpunkt.Datum);
    VerbrauchGesamt := NaechsterEndpunkt.Wert - BasisEndpunkt.Wert;
    VerbrauchProTag := VerbrauchGesamt / Tage;
    EndDatum   := NaechsterEndpunkt.Datum;
    StartDatum := BasisEndpunkt.Datum;
    Datum := StartDatum;
    while Datum < EndDatum do
    begin
      DBVerbrauch.Init;
      DBVerbrauch.ZaId  := aZaId;
      DBVerbrauch.Wert  := VerbrauchProTag;
      DBVerbrauch.Datum := Datum;
      DBVerbrauch.SaveToDB;
      Datum := IncDay(Datum, 1);
    end;


  finally
    FreeAndNil(DBVerbrauch);
    FreeAndNil(DBZaehlerstand);
  end;

end;


procedure TEnergieverbrauchCalc.VerbrauchKomplettNeuBerechnen(aZaId: Integer);
var
  DBVerbrauch: TDBEnergieverbrauchVerbrauch;
  DBZaehlerstandList: TDBEnergieverbrauchZaehlerstandList;
  i1: Integer;
  JahrVon: Integer;
  JahrBis: Integer;
begin
  JahrVon := 3000;
  JahrBis := 0;
  DBZaehlerstandList := TDBEnergieverbrauchZaehlerstandList.Create;
  DBVerbrauch    := TDBEnergieverbrauchVerbrauch.Create(nil);
  try
    DBZaehlerstandList.Trans := fTrans;
    DBVerbrauch.Trans    := fTrans;
    DBVerbrauch.DeleteAllByZaehler(aZaId);
    DBZaehlerstandList.ReadAllByZaehler(aZaId);
    for i1 := 0 to DBZaehlerstandList.Count -1 do
    begin
      CalcVerbrauch(aZaId, DBZaehlerstandList.Item[i1].Datum);
      if YearOf(DBZaehlerstandList.Item[i1].Datum) < JahrVon then
        JahrVon := YearOf(DBZaehlerstandList.Item[i1].Datum);

      if YearOf(DBZaehlerstandList.Item[i1].Datum) > JahrBis then
        JahrBis := YearOf(DBZaehlerstandList.Item[i1].Datum);

    end;
    for i1 := JahrVon to JahrBis do
      CalcVerbrauchMonate(aZaId, i1);
  finally
    FreeAndNil(DBVerbrauch);
    FreeAndNil(DBZaehlerstandList);
  end;

end;


procedure TEnergieverbrauchCalc.CalcVerbrauchMonate(aZaId, aJahr: Integer);
var
  DBVerbrauchList: TDBEnergieverbrauchVerbrauchList;
  DBVerbrauch: TDBEnergieverbrauchVerbrauch;
  DBVerbrauchMonat: TDBEnergieverbrauchVerbrauchMonat;
  DatumVon: TDateTime;
  DatumBis: TDateTime;
  i1: Integer;
  Monat: Integer;
  Verbrauch: Currency;
begin //
  DBVerbrauchList  := TDBEnergieverbrauchVerbrauchList.Create;
  DBVerbrauchMonat := TDBEnergieverbrauchVerbrauchMonat.Create(nil);
  try
    DBVerbrauchList.Trans  := fTrans;
    DBVerbrauchMonat.Trans := fTrans;

    for Monat := 1 to 12 do
    begin
      DatumVon := StrToDate('01.' +  Monat.ToString  + '.' + aJahr.ToString);
      DatumBis := EndOfTheMonth(DatumVon);
      DBVerbrauchList.ReadZeitraum(aZaId, DatumVon, DatumBis);
      Verbrauch := 0;
      for i1 := 0 to DBVerbrauchList.Count -1 do
      begin
        DBVerbrauch := DBVerbrauchList.Item[i1];
        Verbrauch := Verbrauch + DBVerbrauch.Wert;
      end;
      DBVerbrauchMonat.Read(aZaId, Monat, aJahr);
      DBVerbrauchMonat.ZaId  := aZaId;
      DBVerbrauchMonat.Wert  := Verbrauch;
      DBVerbrauchMonat.Monat := Monat;
      DBVerbrauchMonat.Jahr  := aJahr;
      DBVerbrauchMonat.SaveToDB;
    end;

  finally
    FreeAndNil(DBVerbrauchList);
    FreeAndNil(DBVerbrauchMonat);
  end;

end;


end.
