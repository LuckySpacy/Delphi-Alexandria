unit Objekt.UpgradeSqlList;

interface

uses
  SysUtils, System.Classes, Objekt.BasisList, Objekt.UpgradeSql;

type
  TUpgradeSqlList = class(TBasisList)
  private
    function getItem(Index: Integer): TUpgradeSqlList;
  public
    constructor Create; override;
    destructor Destroy; override;
    property Item[Index: Integer]: TUpgradeSqlList read getItem;
    function Add: TUpgradeSqlList;
  end;

implementation

{ TUpgradeSqlList }


constructor TUpgradeSqlList.Create;
begin
  inherited;

end;

destructor TUpgradeSqlList.Destroy;
begin

  inherited;
end;

function TUpgradeSqlList.getItem(Index: Integer): TUpgradeSqlList;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TUpgradeSqlList(fList.Items[Index]);
end;

function TUpgradeSqlList.Add: TUpgradeSqlList;
begin
  Result := TUpgradeSqlList.Create;
  fList.Add(Result);
end;


end.
