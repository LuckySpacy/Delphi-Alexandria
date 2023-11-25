unit Form.Fortschritt;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  Form.Base, FMX.Controls.Presentation;

type
  Tfrm_Fortschritt = class(Tfrm_Base)
    pg: TProgressBar;
    Label1: TLabel;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  frm_Fortschritt: Tfrm_Fortschritt;

implementation

{$R *.fmx}

end.
