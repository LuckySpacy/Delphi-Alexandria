unit o_synclistbox;

interface

uses
  SysUtils, Classes, StdCtrls;

type
  TSyncListBox = class(TComponent)
  private
    _BoxLeft: TCustomListBox;
    _BoxRight: TCustomListBox;
    procedure DeleteItemsFromList(aSource, aDest: TCustomListBox);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property BoxLeft : TCustomListBox read _BoxLeft  write _BoxLeft;
    property BoxRight: TCustomListBox read _BoxRight write _BoxRight;
    procedure DeleteLeftItems;
    procedure DeleteRightItems;
    procedure MoveLeftToRight;
    procedure MoveRightToLeft;
  end;


implementation

{ TSyncListBox }

constructor TSyncListBox.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TSyncListBox.Destroy;
begin

  inherited;
end;

procedure TSyncListBox.MoveLeftToRight;
begin
  if not Assigned(_BoxLeft) then
    exit;
  if not Assigned(_BoxRight) then
    exit;
  if _BoxLeft.ItemIndex = -1 then
    exit;
  _BoxRight.AddItem(_BoxLeft.Items[_BoxLeft.ItemIndex], TObject(_BoxLeft.items.Objects[_BoxLeft.ItemIndex]));
  DeleteLeftItems;
end;

procedure TSyncListBox.MoveRightToLeft;
begin
  if not Assigned(_BoxLeft) then
    exit;
  if not Assigned(_BoxRight) then
    exit;
  if _BoxRight.ItemIndex = -1 then
    exit;
  _BoxLeft.AddItem(_BoxRight.Items[_BoxRight.ItemIndex], TObject(_BoxRight.items.Objects[_BoxRight.ItemIndex]));
  DeleteRightItems;
end;


procedure TSyncListBox.DeleteItemsFromList(aSource, aDest: TCustomListBox);
var
  i1, i2: Integer;
begin
  if not Assigned(aSource) then
    exit;
  if not Assigned(aDest) then
    exit;

  for i1 := 0 to aSource.Count - 1 do
  begin
    for i2 := aDest.Count - 1 downto 0 do
    begin
      if SameText(aSource.Items[i1], aDest.Items[i2]) then
        aDest.Items.Delete(i2);
    end;
  end;

end;

procedure TSyncListBox.DeleteLeftItems;
begin
  DeleteItemsFromList(_BoxRight, _BoxLeft);
end;

procedure TSyncListBox.DeleteRightItems;
begin
  DeleteItemsFromList(_BoxLeft, _BoxRight);
end;

end.
