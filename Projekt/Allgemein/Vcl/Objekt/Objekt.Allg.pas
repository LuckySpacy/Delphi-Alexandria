unit Objekt.Allg;

interface

uses
  SysUtils, Classes, variants, Data.DB, Math;
type
  TAllg = class
  private
  protected
  public
    constructor Create;
    destructor Destroy; override;
    function VergleichFloatValue(aMenge1, amenge2 : real; aNachkommastellen : integer) : integer;
    function Runden(aValue: real; aAnzahlStellen: Integer): real;
    function Trunc(AValue : real): int64;
  end;

implementation

{ TAllg }

constructor TAllg.Create;
begin

end;

destructor TAllg.Destroy;
begin

  inherited;
end;

function TAllg.VergleichFloatValue(aMenge1, amenge2: real;
  aNachkommastellen: integer): integer;
var
  Wert1, Wert2 : real;
begin
  Wert1 := runden(aMenge1, aNachkommastellen);
  Wert2 := runden(amenge2, aNachkommastellen);
  result := 0;

  if Wert1 < Wert2 then
     result := -1
  else
  if Wert1 > Wert2 then
     result := 1;
end;

function TAllg.Runden(aValue: real; aAnzahlStellen: Integer): real;
var
  LFactor: Extended;
  e: Extended;
  i: Int64;
begin
  // SimpleRoundTo liefert nicht immer das gewünschte Ergebnis
  // Bitte einmal in eine Extended, Double oder Real Variable den Wert 87.285 versuchen
  // Das Ergebnis was SimpleRoundTo zurückliefert wird 87.28 sein.
  // Siehe dazu http://pages.cs.wisc.edu/~rkennedy/exact-float?number=87.285
  //r := IntPower(10, -(aAnzahlStellen+2));
  //aValue := aValue + r;
//  Result := SimpleRoundTo(aValue, aAnzahlStellen*-1);
//  Result := ArithRoundTo(aValue, aAnzahlStellen*-1);

  LFactor := IntPower(10.0, aAnzahlStellen*-1);
  e := AValue / LFactor;

  if AValue < 0 then
    e := e - 0.5
  else
    e := e + 0.5;

  i := Trunc(e);
  Result := i * LFactor;

end;

function TAllg.Trunc(AValue: real): int64;
var
  s: string;
  iPos : integer;
begin
  s := FloatToStr(AValue);
  StringReplace(s, '.', ',', [rfReplaceAll]);
  iPos := Pos(',', s);
  if iPos > 0 then
    s :=  Copy(s, 1, iPos-1);
  result := StrToInt64(s);
end;

end.
