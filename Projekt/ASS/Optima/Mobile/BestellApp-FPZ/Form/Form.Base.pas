unit Form.Base;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.ImgList, FMX.Objects;

type
  Tfrm_Base = class(TForm)
    Rec_Toolbar_Background: TRectangle;
  private
    fOnBack: TNotifyEvent;
  protected
    procedure GoBack(Sender: TObject);
  public
    procedure setActiv; virtual; abstract;
    property OnBack: TNotifyEvent read fOnBack write fOnBack;
  end;

var
  frm_Base: Tfrm_Base;

implementation

{$R *.fmx}

{ Tfrm_Base }


procedure Tfrm_Base.GoBack(Sender: TObject);
begin
  if Assigned(fOnBack) then
    fOnBack(Self);
end;

end.
