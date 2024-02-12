unit Objekt.StatistikMonatList;

interface

uses
  SysUtils, Types, Variants, Classes, Objekt.BasisList, Objekt.StatistikMonat;

type
  TStatistikMonatList = class(TBasisList)
  private
    fJahr: Integer;
    function getItem(Index: Integer): TStatistikMonat;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    property Item[Index:Integer]: TStatistikMonat read getItem;
    function Add: TStatistikMonat;
    property Jahr: Integer read fJahr write fJahr;
  end;

implementation

{ TStatistikMonatList }



constructor TStatistikMonatList.Create;
begin
  inherited;
end;

destructor TStatistikMonatList.Destroy;
begin

  inherited;
end;


function TStatistikMonatList.Add: TStatistikMonat;
begin
  Result := TStatistikMonat.Create;
  fList.Add(Result);
end;


function TStatistikMonatList.getItem(Index: Integer): TStatistikMonat;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TStatistikMonat(fList.Items[Index]);
end;

end.
