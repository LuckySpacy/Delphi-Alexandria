unit Frame.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  Datenmodul.dm, Datenmodul.Bilder, FMX.ImgList, FMX.Layouts,
  FMX.Controls.Presentation, Frame.Base;

type
  Tfra_Main = class(Tfra_Base)
    VertScrollBox1: TVertScrollBox;
    FlowLayout1: TFlowLayout;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Layout1: TLayout;
    Label1: TLabel;
    gly_Add: TGlyph;
  private
    fOnAddBibliothek: TNotifyEvent;
    procedure AddClick(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    property OnAddBibliothek: TNotifyEvent read fOnAddBibliothek write fOnAddBibliothek;
  end;

implementation

{$R *.fmx}

{ Tfra_Main }


constructor Tfra_Main.Create(AOwner: TComponent);
begin
  inherited Create(aOwner);

  gly_Add.HitTest := true;
  gly_Add.OnClick := AddClick;

end;

procedure Tfra_Main.AddClick(Sender: TObject);
begin
  if Assigned(fOnAddBibliothek) then
    fOnAddBibliothek(Self);
end;


end.
