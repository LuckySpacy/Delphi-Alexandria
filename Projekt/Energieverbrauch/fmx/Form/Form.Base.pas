unit Form.Base;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs;

type
  Tfrm_Base = class(TForm)
  private
    fOnZurueck: TNotifyEvent;
  protected
    procedure DoZurueck(Sender: TObject);
  public
    property OnZurueck: TNotifyEvent read fOnZurueck write fOnZurueck;
    procedure setActiv; virtual;
  end;

var
  frm_Base: Tfrm_Base;

implementation

{$R *.fmx}

{ Tfrm_Base }

procedure Tfrm_Base.DoZurueck(Sender: TObject);
begin
  if Assigned(fOnZurueck) then
    fOnZurueck(Self);
end;

procedure Tfrm_Base.setActiv;
begin

end;

end.
