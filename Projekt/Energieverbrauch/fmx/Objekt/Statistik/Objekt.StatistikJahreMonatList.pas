unit Objekt.StatistikJahreMonatList;

interface

uses
  SysUtils, Types, Variants, Classes, Objekt.BasisList, Objekt.StatistikMonatList;

type
  TStatistikJahreMonatsList = class(TBasisList)
  private
    function getItem(Index: Integer): TStatistikMonatList;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    function Add(aJahr: Integer): TStatistikMonatList;
    function getJahr(aJahr: Integer): TStatistikMonatList;
    property Item[Index:Integer]: TStatistikMonatList read getItem;
  end;

implementation

{ TStatistikJahreMonatsList }


constructor TStatistikJahreMonatsList.Create;
begin
  inherited
end;

destructor TStatistikJahreMonatsList.Destroy;
begin

  inherited;
end;


function TStatistikJahreMonatsList.getItem(Index: Integer): TStatistikMonatList;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TStatistikMonatList(fList.Items[Index]);
end;

function TStatistikJahreMonatsList.getJahr(aJahr: Integer): TStatistikMonatList;
var
  i1: Integer;
begin
  Result := nil;
  for i1 := 0 to fList.Count -1 do
  begin
    if aJahr = TStatistikMonatList(fList.Items[i1]).Jahr then
    begin
      Result := TStatistikMonatList(fList.Items[i1]);
      exit;
    end;
  end;
end;

function TStatistikJahreMonatsList.Add(aJahr: Integer): TStatistikMonatList;
begin
  Result := TStatistikMonatList.Create;
  Result.Jahr := aJahr;
  fList.Add(Result);
end;


end.