unit DB.GuVJahrList;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery, Objekt.BasisList, DB.BasisList,
  DB.GuVJahr, Objekt.ObjektList;


type
  TDBGuVJahrList = class(TDBBasisList)
  private
    function getItem(Index: Integer): TDBGuVJahr;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    property Item[Index:Integer]: TDBGuVJahr read getItem;
    function Add: TDBGuVJahr;
  end;

implementation

{ TDBGuVJahrList }


constructor TDBGuVJahrList.Create;
begin
  inherited;

end;

destructor TDBGuVJahrList.Destroy;
begin

  inherited;
end;

function TDBGuVJahrList.Add: TDBGuVJahr;
begin
  Result := TDBGuVJahr.Create(nil);
  Result.Trans := Trans;
  fList.Add(Result);
end;



function TDBGuVJahrList.getItem(Index: Integer): TDBGuVJahr;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TDBGuVJahr(fList.Items[Index]);
end;

end.
