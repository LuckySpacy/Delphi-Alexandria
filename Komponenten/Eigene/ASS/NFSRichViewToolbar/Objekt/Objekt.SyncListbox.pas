unit Objekt.SyncListbox;

interface

uses
  SysUtils, Classes, StdCtrls;

type
  TSyncListBox = class(TComponent)
  private
    fBoxLeft: TCustomListBox;
    fBoxRight: TCustomListBox;
    procedure DeleteItemsFromList(aSource, aDest: TCustomListBox);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property BoxLeft : TCustomListBox read fBoxLeft  write fBoxLeft;
    property BoxRight: TCustomListBox read fBoxRight write fBoxRight;
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
  DeleteItemsFromList(fBoxRight, fBoxLeft);
end;

procedure TSyncListBox.DeleteRightItems;
begin
  DeleteItemsFromList(fBoxLeft, fBoxRight);
end;


procedure TSyncListBox.MoveLeftToRight;
begin
  if not Assigned(fBoxLeft) then
    exit;
  if not Assigned(fBoxRight) then
    exit;
  if fBoxLeft.ItemIndex = -1 then
    exit;
  fBoxRight.AddItem(fBoxLeft.Items[fBoxLeft.ItemIndex], TObject(fBoxLeft.items.Objects[fBoxLeft.ItemIndex]));
  DeleteLeftItems;
end;

procedure TSyncListBox.MoveRightToLeft;
begin
  if not Assigned(fBoxLeft) then
    exit;
  if not Assigned(fBoxRight) then
    exit;
  if fBoxRight.ItemIndex = -1 then
    exit;
  fBoxLeft.AddItem(fBoxRight.Items[fBoxRight.ItemIndex], TObject(fBoxRight.items.Objects[fBoxRight.ItemIndex]));
  DeleteRightItems;
end;

end.
