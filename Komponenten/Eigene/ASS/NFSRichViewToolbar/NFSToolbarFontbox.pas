unit NFSToolbarFontbox;

interface

uses
  SysUtils, Classes, Controls, Windows, Graphics, StdCtrls, Forms;

type
  TNFSToolbarFontbox = class(TCombobox)
  private
  protected
    procedure SetParent(AParent: TWinControl); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
  end;

implementation

{ TNFSToolbarFontbox }

constructor TNFSToolbarFontbox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AlignWithMargins := true;
  Style := csDropDownList;
end;

destructor TNFSToolbarFontbox.Destroy;
begin

  inherited;
end;

procedure TNFSToolbarFontbox.SetParent(AParent: TWinControl);
var
  i1: Integer;
begin
  inherited;
  if AParent = nil then
    exit;
  if Parent = nil then
    exit;
  if (csDesigning In ComponentState) then
     exit;
  Items.Clear;
  Items := Screen.Fonts;
  for i1 := Items.Count -1 downto 0 do
  begin
    if Items.Strings[i1][1] = '@'  then
      Items.Delete(i1);
  end;
end;

end.
