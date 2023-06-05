unit Objekt.AnsichtList;

interface

uses
  system.SysUtils, System.Classes, Objekt.BasisList, Objekt.Ansicht;

type
  TAnsichtList = class(TBasisList)
  private
    function getItem(aIndex: Integer): TAnsicht;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    function Add: TAnsicht;
    property Item[aIndex: Integer]: TAnsicht read getItem;
    procedure KGVSort;
    procedure AktieSort;
    procedure TSI27Sort;
  end;

implementation


uses
  Math;


function KGVSortieren(Item1, Item2: Pointer): Integer;
begin
  Result := math.CompareValue(TAnsicht(Item1).KGV, TAnsicht(Item2).KGV);
end;

function AktieSortieren(Item1, Item2: Pointer): Integer;
begin
  Result := AnsiCompareText(TAnsicht(Item1).Aktie, TAnsicht(Item2).Aktie);
end;

function TSI27Sortieren(Item1, Item2: Pointer): Integer;
begin
  Result := math.CompareValue(TAnsicht(Item1).Wert27, TAnsicht(Item2).Wert27);
end;


{ TAnsichtList }



constructor TAnsichtList.Create;
begin
  inherited;

end;

destructor TAnsichtList.Destroy;
begin

  inherited;
end;


function TAnsichtList.getItem(aIndex: Integer): TAnsicht;
begin
  Result := nil;
  if aIndex > fList.Count then
    exit;
  Result := TAnsicht(fList.Items[aIndex]);
end;

procedure TAnsichtList.KGVSort;
begin
  fList.Sort(@KGVSortieren);
end;

procedure TAnsichtList.TSI27Sort;
begin
  fList.Sort(@TSI27Sortieren);
end;

procedure TAnsichtList.AktieSort;
begin
  fList.Sort(@AktieSortieren);
end;


function TAnsichtList.Add: TAnsicht;
begin
  Result := TAnsicht.Create;
  fList.Add(Result);
end;


end.
