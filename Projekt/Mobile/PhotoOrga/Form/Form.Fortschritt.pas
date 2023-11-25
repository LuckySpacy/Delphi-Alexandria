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
    Panel1: TPanel;
    Panel2: TPanel;
  private
    { Private-Deklarationen }
  public
    procedure ProgressMaxValue(aValue: Integer);
    procedure Progress(aIndex: Integer; aValue: string);
    procedure setActiv; override;
  end;

var
  frm_Fortschritt: Tfrm_Fortschritt;

implementation

{$R *.fmx}

{ Tfrm_Fortschritt }

procedure Tfrm_Fortschritt.Progress(aIndex: Integer; aValue: string);
begin
  pg.Value := aIndex;
  Label1.Text := aValue;
end;

procedure Tfrm_Fortschritt.ProgressMaxValue(aValue: Integer);
begin
  pg.Max := aValue;
end;

procedure Tfrm_Fortschritt.setActiv;
begin
  inherited;
  pg.Value := 0;
  Label1.Text := '';
end;

end.
