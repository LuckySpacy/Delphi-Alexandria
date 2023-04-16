unit c_Historie;

interface

type

{$REGION 'Historietabelle'}
TOptimaTabelleID = Record const
  Contract: Integer = 1;
  Vorgangpos: Integer = 2;
  VorgangposErw: Integer = 3;
  Artikel: Integer = 4;
  ContractLizenztyp: Integer = 5;
  ContractStatusEinstellung: Integer = 6;
  CL_SP_TEXT: Integer = 7;
  Dokumente: Integer = 8;
  ContractLizenzTypStatus = 9;
  Standardfont = 10;
  AR_CH = 11;
  Mehrwertsteuer = 12;
  Projektzeiten = 13;
  Webshopdaten = 14;
  FTPDaten = 15;
  Bilder = 16;
  VorgangVorlageKunde= 17;
  PjArbeitspaket = 18;
  PjAufgabe = 19;
  PjProjektrolle = 20;
  PjProjekt = 21;
  PjPersonrolle = 22;
  WGBonus = 23;
  Preisblatt = 24;
  Vorgangsoption = 25;
  Klassifikation = 26;
  Klassifikationdaten = 27;
  Artikelklassifikation = 28;
  VoAnschrift = 29;
  Lizenzwarnung = 30;
  ErlmengeAenderung = 31;
  KUVOartrabatt = 32;
  VOVI = 33;
  Vorgang = 34;
  VorgangsText = 35;
  EmpfVOText = 36;
End;
{$ENDREGION}

{$REGION 'HistorieEvent'}
THistorieEvent = Record const
  Angelegt: Integer = 1;
  Geloescht: Integer = 2;
  VertragWurdePositionZugeordnet: Integer = 3;
  VertragWurdeAusDerPositionEntfernt: Integer = 4;
  LizenztypWurdePositionZugeordnet: Integer = 5;
  LizenztypWurdeAusDerPositionEntfernt: Integer = 6;
  MwstDatumVongeaendert: Integer = 7;
  MwstDatumBisgeaendert: Integer = 8;
  MwstVermindertgeaendert: Integer = 9;
  MwstVollgeaendert: Integer = 10;
  Debug: Integer = 11;
  BudgetGeaendert: Integer = 12;
  VschluesselGeaendert: Integer = 13;
  Verrechnungsartgeaendert: Integer = 14;
  Zeiteinheitgeaendert: Integer = 15;
  VerSatzgeaendert : integer = 16;
  PjNrGeaendert : integer = 17;
  PjMatchGeaendert : integer = 18;
  PjBezeichnung1Geaendert : integer = 19;
  PjBeschreibungGeaendert : integer = 20;
  PjFremdNrGeaendert : integer = 21;
  PjDatumGeaendert : integer = 22;
  StartDatumGeaendert : integer = 23;
  EndeDatumGeaendert : integer = 24;
  PjStatusGeaendert : integer = 25;
  PjControllerIDGeaendert : integer = 26;
  PjVerantwortlicherIdGeaendert : integer = 27;
  PjKundenIDGeaendert : integer = 28;
  PjAnsprechpartnerIDGeaendert : integer = 29;
  PjLieferanschriftIDGeaendert : integer = 30;
  PjProjektgruppeIDGeaendert : integer = 31;
  PjAbrechnungsinfoGeaendert : integer = 32;
  IntSTDSatzGeaendert : integer = 33;
  IntTagSatzGeaendert : integer = 34;
  ExtSTDSatzGeaendert : integer = 35;
  ExtTagSatzGeaendert : integer = 36;
  PersonHinzugefuegt : integer = 37;
  PersonGeaendert : integer = 38;
  RolleGeaendert : integer = 39;
  PjPersonGeaendert : integer = 40;
  LizenztypAktivGeandert: Integer = 41;
  PreisblattGueltigkeitGeaendert : integer = 42;
  LizenztypAktivDatumGeaendert: Integer = 43;
  PosErlaubtReservebestandGeaendert: Integer = 44;
end;
{$ENDREGION}




implementation

end.
