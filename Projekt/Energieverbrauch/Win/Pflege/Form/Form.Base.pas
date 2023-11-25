unit Form.Base;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs;

type
  Tfrm_Base = class(TForm)
  private
    fOnBack: TNotifyEvent;
  protected
    procedure BackClick(Sender: TObject);
  public
    property OnBack: TNotifyEvent read fOnBack write fOnBack;
  end;

var
  frm_Base: Tfrm_Base;

implementation

{$R *.dfm}

{ Tfrm_Base }

procedure Tfrm_Base.BackClick(Sender: TObject);
begin
  if Assigned(fOnBack) then
    fOnBack(Self);
end;

end.
