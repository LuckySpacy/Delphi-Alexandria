unit Objekt.DatumZeit;

interface

uses
  DateUtils, System.SysUtils;

type
  TDatumZeit = class
  private
    fsJahr: string;
    fsMonat: string;
    fsTag: string;
    fsStunde: string;
    fsMin: string;
    fsSek: string;

    fwJahr: Word;
    fwMonat: Word;
    fwTag: Word;
    fwStunde: Word;
    fwMin: Word;
    fwSek: Word;

  public
    function StringZuDatum(aValue: string): TDateTime;
    function DatumZuString(aDateTime: TDateTime): string;
    function AnzeigeString(aValue: string): string;
    function TryStrToWord(aValue: string; var aWord: Word): Boolean;
    constructor Create;
    destructor Destroy; override;
    procedure Init;
  end;


implementation

{ TDatumZeit }


constructor TDatumZeit.Create;
begin
  Init;
end;


destructor TDatumZeit.Destroy;
begin

  inherited;
end;

procedure TDatumZeit.Init;
begin
  fsJahr   := '';
  fsMonat  := '';
  fsTag    := '';
  fsStunde := '';
  fsMin    := '';
  fsSek    := '';
  fwJahr   := 0;
  fwMonat  := 0;
  fwTag    := 0;
  fwStunde := 0;
  fwMin    := 0;
  fwSek    := 0;
end;


function TDatumZeit.AnzeigeString(aValue: string): string;
begin
  Result := FormatDateTime('dd.mm.yyyy hh:nn:ss', StringZuDatum(aValue));
end;


function TDatumZeit.StringZuDatum(aValue: string): TDateTime;
begin
  if Trim(aValue) = '' then
  begin
    Result := 0;
    exit;
  end;

  fsJahr   :=  copy(aValue, 1, 4);
  fsMonat  := copy(aValue, 6, 2);
  fsTag    := copy(aValue, 9, 2);
  fsStunde := copy(aValue, 12, 2);
  fsMin    := copy(aValue, 15, 2);
  fsSek    := copy(aValue, 18, 2);

  if not TryStrToWord(fsJahr, fwJahr) then
    exit;
  if not TryStrToWord(fsMonat, fwMonat) then
    exit;
  if not TryStrToWord(fsTag, fwTag) then
    exit;
  if not TryStrToWord(fsStunde, fwStunde) then
    exit;
  if not TryStrToWord(fsMin, fwMin) then
    exit;
  if not TryStrToWord(fsSek, fwSek) then
    exit;

  Result := EncodeDateTime(fwJahr, fwMonat, fwTag, fwStunde, fwMin, fwSek, 0);

end;

function TDatumZeit.TryStrToWord(aValue: string; var aWord: Word): Boolean;
var
 Code: Integer;
begin
  Val(aValue, aWord, Code);
  Result := Code = 0;
end;

function TDatumZeit.DatumZuString(aDateTime: TDateTime): string;
begin
  Result := FormatDateTime('yyyy-mm-dd hh:nn:ss', aDateTime);
end;


end.
