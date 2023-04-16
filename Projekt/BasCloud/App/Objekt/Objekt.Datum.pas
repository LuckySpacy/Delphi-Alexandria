unit Objekt.Datum;

interface

uses
  SysUtils, System.Classes, DateUtils, Objekt.DateTime;

type
  TDatum = class
  private
    fDateTime: TASSDateTime;
  public
    constructor Create;
    destructor Destroy; override;
    function getDateTimeFromTimestamp(aTimeStamp: string): TDateTime;
    function getTimestampFromDateTime(aDateTime: TDateTime): string;
    function getUTCTimestampDatumAndNow(aDatum: TDateTime): string;
    function getUTCTimestampDatum(aDatum: TDateTime): string;
    function getUTCDateTime: TDateTime;
  end;

implementation

{ TDatum }

constructor TDatum.Create;
begin
  fDateTime := TASSDateTime.Create(nil);
end;

destructor TDatum.Destroy;
begin
  FreeAndNil(fDateTime);
  inherited;
end;


function TDatum.getDateTimeFromTimestamp(aTimeStamp: string): TDateTime;
var
  Jahr, Monat, Tag: Word;
  Std, Min, Sek, Mill: Word;
  sJahr, sMonat, sTag: string;
  sStd, sMin, sSek, sMill: string;
begin
  try
    sJahr  := copy(aTimeStamp, 1, 4);
    sMonat := copy(aTimeStamp, 6, 2);
    sTag   := copy(aTimeStamp, 9, 2);
    sStd   := copy(aTimeStamp, 12,2);
    sMin   := copy(aTimeStamp, 15,2);
    sSek   := copy(aTimeStamp, 18,2);
    sMill  := copy(aTimeStamp, 21,3);
    Jahr   := StrToInt(sJahr);
    Monat  := StrToInt(sMonat);
    Tag    := StrToInt(sTag);
    Std    := StrToInt(sStd);
    Min    := StrToInt(sMin);
    Sek    := StrToInt(sSek);
    Mill   := StrToInt(sMill);
    Result := EncodeDateTime(Jahr, Monat, Tag, Std, Min, Sek, Mill);
  except
    Result := 0;
  end;
end;

function TDatum.getTimestampFromDateTime(aDateTime: TDateTime): string;
begin
  Result := FormatDateTime('YYYY', aDateTime) + '-' + FormatDateTime('mm', aDateTime) + '-' + FormatDateTime('dd', aDateTime) + 'T' +
            FormatDateTime('hh:nn:ss', aDateTime) + '.' + FormatDateTime('zzz', aDateTime) + 'Z';
end;



       {
function TDatum.getUTCDateTime: TDateTime;
var
  SystemTime: TSystemTime;
begin
  GetSystemTime(SystemTime);
  fDateTime.Jahr    := SystemTime.wYear;
  fDateTime.Monat   := SystemTime.wMonth;
  fDateTime.Tag     := SystemTime.wDay;
  fDateTime.Stunde  := SystemTime.wHour;
  fDateTime.Minute  := SystemTime.wMinute;
  fDateTime.Sekunde := SystemTime.wSecond;
  fDateTime.Milli   := SystemTime.wMilliseconds;
  Result := fDateTime.Datum;
end;
}

function TDatum.getUTCDateTime: TDateTime;
begin
  Result := TTimeZone.Local.ToUniversalTime(now);
end;


function TDatum.getUTCTimestampDatum(aDatum: TDateTime): string;
var
  Std, Min, Sek, Mil, Tag, Monat, Jahr: Word;
begin
  DecodeDateTime(aDatum, Jahr, Monat, Tag, Std, Min, Sek, Mil);
  aDatum := EncodeDateTime(Jahr, Monat, Tag, Std, Min, Sek, Mil);
  Result := FormatDateTime('yyyy-mm-dd', aDatum) + 'T' + FormatDateTime('hh:nn:ss.zzz', aDatum) + 'Z';
end;


function TDatum.getUTCTimestampDatumAndNow(aDatum: TDateTime): string;
var
  Tag1, Monat1, Jahr1, Std, Min, Sek, Mil, Tag, Monat, Jahr: Word;
begin
  DecodeDateTime(aDatum, Jahr, Monat, Tag, Std, Min, Sek, Mil);
  DecodeDateTime(now, Jahr1, Monat1, Tag1, Std, Min, Sek, Mil);
  aDatum := EncodeDateTime(Jahr, Monat, Tag, Std, Min, Sek, Mil);
  Result := FormatDateTime('yyyy-mm-dd', aDatum) + 'T' + FormatDateTime('hh:nn:ss.zzz', aDatum) + 'Z';
end;



end.
