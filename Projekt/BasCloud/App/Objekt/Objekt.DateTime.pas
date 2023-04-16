unit Objekt.DateTime;

interface

uses
  System.SysUtils, System.Variants, System.Classes, DateUtils;

type
  TAssDateTime = class(TComponent)
  private
    fJahr: Word;
    fSekunde: Word;
    fStunde: Word;
    fTag: Word;
    fMinute: Word;
    fMonat: Word;
    fMilli: Word;
    function getDatum: TDateTime;
    procedure TryStrToWord(aStr: string; var aWord: Word; const aDefault: Word = 0);
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Jahr: Word read fJahr write fJahr;
    property Monat: Word read fMonat write fMonat;
    property Tag: Word read fTag write fTag;
    property Stunde: Word read fStunde write fStunde;
    property Minute: Word read fMinute write fMinute;
    property Sekunde: Word read fSekunde write fSekunde;
    property Milli: Word read fMilli write fMilli;
    property Datum: TDateTime read getDatum;
    procedure SetMySqlDateTimeStr(aValue: string);
    procedure setDatum(aValue: TDateTime);
    procedure Init;
    function SetTimeToDate(aDate, aTime: TDateTime): TDateTime;
    function StrDateTime: string;
  end;

implementation

{ TTbDateTime }

constructor TAssDateTime.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TAssDateTime.Destroy;
begin

  inherited;
end;

function TAssDateTime.getDatum: TDateTime;
begin
  Result := EncodeDateTime(fJahr, fMonat, fTag, fStunde, fMinute, fSekunde, fMilli);
end;

procedure TAssDateTime.Init;
var
  dDatum: TDateTime;
begin
  dDatum := 0;
  DecodeDateTime(dDatum, fJahr, fMonat, fTag, fStunde, fMinute, fSekunde, fMilli);
end;

procedure TAssDateTime.setDatum(aValue: TDateTime);
begin
  DecodeDateTime(aValue, fJahr, fMonat, fTag, fStunde, fMinute, fSekunde, fMilli);
end;

procedure TAssDateTime.SetMySqlDateTimeStr(aValue: string);
var
  sJahr: string;
  sMonat: string;
  sTag: string;
  sStunde: string;
  sMin: string;
  sSek: string;
  //wJahr: Word;
begin
  Init;
  if length(avalue) = 19 then
  begin
    sJahr   := copy(avalue, 1, 4);
    sMonat  := copy(aValue, 6,2);
    sTag    := copy(aValue, 9,2);
    sStunde := copy(aValue, 12,2);
    sMin := copy(aValue, 15,2);
    sSek := copy(aValue, 18,2);
    TryStrToWord(sJahr, fJahr);
    TryStrToWord(sMonat, fMonat);
    TryStrToWord(sTag, fTag);
    TryStrToWord(sStunde, fStunde);
    TryStrToWord(sMin, fMinute);
    TryStrToWord(sSek, fSekunde);
  end;
  if length(avalue) = 10 then
  begin
    sJahr   := copy(avalue, 1, 4);
    sMonat  := copy(aValue, 6,2);
    sTag    := copy(aValue, 9,2);
    TryStrToWord(sJahr, fJahr);
    TryStrToWord(sMonat, fMonat);
    TryStrToWord(sTag, fTag);
  end;
end;

procedure TAssDateTime.TryStrToWord(aStr: string; var aWord: Word; const aDefault: Word = 0);
var
  iTemp: Integer;
begin
  try
    if not TryStrToInt(aStr, iTemp) then
    begin
      aWord := aDefault;
      exit;
    end;
    aWord := Word(iTemp);
  except
    aWord := aDefault;
  end;
end;


function TAssDateTime.SetTimeToDate(aDate, aTime: TDateTime): TDateTime;
var
  Tag: Word;
  Monat: Word;
  Jahr: Word;
  Stunde: Word;
  Minute: Word;
  Sekunde: Word;
  Milli: Word;
begin
  DecodeDate(aDate, Jahr, Monat, Tag);
  DecodeTime(aTime, Stunde, Minute, Sekunde, Milli);
  Result := EncodeDateTime(Jahr, Monat, Tag, Stunde, Minute, Sekunde, Milli);
end;


function TAssDateTime.StrDateTime: string;
begin
  Result := FormatDateTime('dd.mm.yyyy hh:nn:ss:z', Datum);
end;

end.
