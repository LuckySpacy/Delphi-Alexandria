unit Frame.Base;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  fmx.TabControl;

type
  Tfra_Base = class(TFrame)
  private
    fOnBack: TNotifyEvent;
    fTabItem: TTabItem;
  protected
    procedure BackClick(Sender: TObject);
  public
    property OnBack: TNotifyEvent read fOnBack write fOnBack;
    property TabItem: TTabItem read fTabItem write fTabItem;
  end;

implementation

{$R *.fmx}

{ Tfra_Base }

procedure Tfra_Base.BackClick(Sender: TObject);
begin
  if Assigned(fOnBack) then
    fOnBack(Self);
end;

end.
