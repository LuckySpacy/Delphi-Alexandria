unit Form.Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvUtil, Vcl.Grids, AdvObj, BaseGrid,
  AdvGrid, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  Tfrm_Main = class(TForm)
    Panel1: TPanel;
    btn_Neu: TButton;
    btn_Loeschen: TButton;
    btn_Starten: TButton;
    Panel3: TPanel;
    Label1: TLabel;
    grd: TAdvStringGrid;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  frm_Main: Tfrm_Main;

implementation

{$R *.dfm}

end.
