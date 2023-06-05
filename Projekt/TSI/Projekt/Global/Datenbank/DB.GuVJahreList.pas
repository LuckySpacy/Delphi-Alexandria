unit DB.GuVJahreList;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery, Objekt.BasisList, DB.BasisList,
  DB.GuVJahre, Objekt.ObjektList;


type
  TDBGuVJahreList = class(TDBBasisList)
  private
    function getItem(Index: Integer): TDBGuVJahre;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    property Item[Index:Integer]: TDBGuVJahre read getItem;
    function Add: TDBGuVJahre;
  end;

implementation

constructor TDBGuVJahreList.Create;
begin
  inherited;

end;

destructor TDBGuVJahreList.Destroy;
begin

  inherited;
end;

function TDBGuVJahreList.Add: TDBGuVJahre;
begin
  Result := TDBGuVJahre.Create(nil);
  Result.Trans := Trans;
  fList.Add(Result);
end;



function TDBGuVJahreList.getItem(Index: Integer): TDBGuVJahre;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TDBGuVJahre(fList.Items[Index]);
end;


end.
