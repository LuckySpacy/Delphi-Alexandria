unit Objekt.fraBildList;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, types.PhotoOrga, Objekt.ObjektList, Objekt.Queue, frame.Bild;

type
  TfraBildList = class(TObjektList)
  private
    function getBild(Index: Integer): Tfra_Bild;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    function Add: Tfra_Bild;
    property Item[Index: Integer]: Tfra_Bild read getBild;
  end;


implementation

{ TfraBildList }


constructor TfraBildList.Create;
begin
  inherited;

end;

destructor TfraBildList.Destroy;
begin

  inherited;
end;

function TfraBildList.getBild(Index: Integer): Tfra_Bild;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := Tfra_Bild(fList.Items[Index]);
end;

function TfraBildList.Add: Tfra_Bild;
begin
  Result := Tfra_Bild.Create(nil);
  fList.Add(Result);
end;


end.
