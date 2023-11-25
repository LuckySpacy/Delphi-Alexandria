unit Objekt.EditAutoCompleteList;

interface

uses
  SysUtils, Classes, System.Contnrs, Objekt.EditAutoComplete;

type
  TEditAutoCompleteList = class(TComponent)
  private
    function GetCount: Integer;
    function getItem(Index: Integer): TEditAutoComplete;
  protected
    fList: TObjectList;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Count: Integer read GetCount;
    procedure Clear;
    property Item[Index:Integer]: TEditAutoComplete read getItem;
    function Add: TEditAutoComplete;
  end;

implementation

{ TEditAutoCompleteList }


constructor TEditAutoCompleteList.Create(AOwner: TComponent);
begin
  inherited;
  fList := TObjectList.Create;
end;

destructor TEditAutoCompleteList.Destroy;
begin
  FreeAndNil(fList);
  inherited;
end;

function TEditAutoCompleteList.GetCount: Integer;
begin
  Result := fList.Count;
end;

function TEditAutoCompleteList.Add: TEditAutoComplete;
begin
  Result := TEditAutoComplete.Create;
  fList.Add(Result);
end;

function TEditAutoCompleteList.getItem(Index: Integer): TEditAutoComplete;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TEditAutoComplete(fList.Items[Index]);
end;


procedure TEditAutoCompleteList.Clear;
begin
  fList.Clear;
end;


end.
