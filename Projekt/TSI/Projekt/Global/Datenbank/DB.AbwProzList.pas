unit DB.AbwProzList;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery, Objekt.BasisList, DB.BasisList,
  DB.AbwProz, Objekt.ObjektList;


type
  TDBAbwProzList = class(TDBBasisList)
  private
    function getItem(Index: Integer): TDBAbwProz;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    property Item[Index:Integer]: TDBAbwProz read getItem;
    function Add: TDBAbwProz;
  end;

implementation

{ TDBAbwProzList }


constructor TDBAbwProzList.Create;
begin
  inherited;

end;

destructor TDBAbwProzList.Destroy;
begin

  inherited;
end;

function TDBAbwProzList.Add: TDBAbwProz;
begin
  Result := TDBAbwProz.Create(nil);
  Result.Trans := Trans;
  fList.Add(Result);
end;


function TDBAbwProzList.getItem(Index: Integer): TDBAbwProz;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TDBAbwProz(fList.Items[Index]);
end;



end.
