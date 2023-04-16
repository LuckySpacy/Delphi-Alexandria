unit Objekt.BildList;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, types.PhotoOrga, Objekt.ObjektList, Objekt.Bild;

type
  TBildList = class(TObjektList)
  private
    function getBild(Index: Integer): TBild;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    function Add: TBild;
    property Item[Index: Integer]: TBild read getBild;
  end;

implementation

{ TBildList }


constructor TBildList.Create;
begin
  inherited;

end;

destructor TBildList.Destroy;
begin

  inherited;
end;

function TBildList.Add: TBild;
begin
  Result := TBild.Create;
  fList.Add(Result);
end;


function TBildList.getBild(Index: Integer): TBild;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TBild(fList.Items[Index]);
end;

end.
