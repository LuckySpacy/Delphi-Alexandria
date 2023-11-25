unit NFSToolbarFontSize;

interface

uses
  SysUtils, Classes, Controls, Windows, Graphics, StdCtrls, Forms,
  Spin;

type
  TNFSToolbarFontSize = class(TSpinEdit)
  private
  protected
    procedure Change; override;
    procedure SetParent(AParent: TWinControl); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
  end;

implementation

{ TNFSToolbarFontSize }

constructor TNFSToolbarFontSize.Create(AOwner: TComponent);
begin
  inherited;
  Width := 40;
  Height := 21;
end;

destructor TNFSToolbarFontSize.Destroy;
begin

  inherited;
end;


procedure TNFSToolbarFontSize.Change;
begin
  inherited;
  if Text = '' then
    exit;
  if Text = '-' then
    exit;
  if Value < 0 then
    Value := 0;
end;


procedure TNFSToolbarFontSize.SetParent(AParent: TWinControl);
begin
  inherited;

end;

end.
