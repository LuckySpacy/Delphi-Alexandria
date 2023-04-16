unit Objekt.AufgabePointerList;

interface

uses
  SysUtils, System.Classes, Objekt.Aufgabe;

type
  TAufgabePointerList = class(TList)
  private
    function getItem(Index: Integer): TAufgabe;
    procedure setAnzeigeBevorToday;
    procedure setAnzeigeAfterToday;
  public
    constructor Create;
    destructor Destroy; override;
    property Item[Index: Integer]: TAufgabe read getItem;
    procedure setAnzeige;
  end;


implementation

{ TAufgabePointerList }

constructor TAufgabePointerList.Create;
begin

end;

destructor TAufgabePointerList.Destroy;
begin

  inherited;
end;

function TAufgabePointerList.getItem(Index: Integer): TAufgabe;
begin
  Result := nil;
  if Index > Count -1 then
    exit;
  Result := TAufgabe(Items[Index]);
end;

procedure TAufgabePointerList.setAnzeige;
begin
  setAnzeigeBevorToday;
  setAnzeigeAfterToday;
end;

procedure TAufgabePointerList.setAnzeigeAfterToday;
var
  i1: Integer;
  Datum: TDateTime;
  Aufgabe: TAufgabe;
  Aufgabe_Merken: TAufgabe;
begin
  Datum := 0;
  Aufgabe_Merken := nil;
  for i1 := 0 to Count -1 do
  begin
    Aufgabe := Item[i1];
    if trunc(Aufgabe.Datum) = trunc(now) then
    begin
      Aufgabe.Anzeigen := true;
      exit;
    end;
    if trunc(Aufgabe.Datum) < trunc(now) then
      continue;
    if (Datum > trunc(Aufgabe.Datum)) or (Datum = 0)  then
    begin
      Datum := trunc(Aufgabe.Datum);
      Aufgabe_Merken := Aufgabe;
    end;
  end;
  if Aufgabe_Merken <> nil then
    Aufgabe_Merken.Anzeigen := true;
end;

procedure TAufgabePointerList.setAnzeigeBevorToday;
var
  i1: Integer;
  Datum: TDateTime;
  Aufgabe: TAufgabe;
  Aufgabe_Merken: TAufgabe;
begin
  Datum := 0;
  Aufgabe_Merken := nil;
  for i1 := 0 to Count -1 do
  begin
    Aufgabe := Item[i1];
    if trunc(Aufgabe.Datum) = trunc(now) then
    begin
      Aufgabe.Anzeigen := true;
      continue;
    end;
    if trunc(Aufgabe.Datum) > trunc(now) then
      continue;
    if trunc(Aufgabe.Datum) > Datum then
    begin
      Datum := trunc(Aufgabe.Datum);
      Aufgabe_Merken := Aufgabe;
    end;
  end;

  if Aufgabe_Merken <> nil then
    Aufgabe_Merken.Anzeigen := true;
end;

end.
