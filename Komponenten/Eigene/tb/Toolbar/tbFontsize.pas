unit tbFontsize;

interface

uses
  SysUtils, Classes, Controls, Windows, Graphics, StdCtrls, Forms,
  Spin;

type
  TTbFontSize = class(TSpinEdit)
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

{ TTbFontSize }


constructor TTbFontSize.Create(AOwner: TComponent);
begin
  inherited;
  Width := 40;
  Height := 21;
end;

destructor TTbFontSize.Destroy;
begin

  inherited;
end;

procedure TTbFontSize.SetParent(AParent: TWinControl);
begin
  inherited;

end;

procedure TTbFontSize.Change;
begin
  inherited;
  if Text = '' then
    exit;
  if Text = '-' then
    exit;
  if Value < 0 then
    Value := 0;
end;



end.
