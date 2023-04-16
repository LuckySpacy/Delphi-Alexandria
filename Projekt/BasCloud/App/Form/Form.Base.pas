unit Form.Base;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects;

type
  Tfrm_Base = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  frm_Base: Tfrm_Base;

implementation

{$R *.fmx}

uses
  Objekt.BasCloud;

procedure Tfrm_Base.FormCreate(Sender: TObject);
var
  i1: Integer;
begin

  for i1 := 0 to ComponentCount -1 do
  begin
    if Components[i1] is TLabel then
      TLabel(Components[i1]).TextSettings.FontColor := BasCloud.Style.LabelColor;
  end;

end;

end.
