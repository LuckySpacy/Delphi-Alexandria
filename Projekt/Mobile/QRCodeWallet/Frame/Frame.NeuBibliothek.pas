unit Frame.NeuBibliothek;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  Frame.Base, FMX.ImgList, FMX.Controls.Presentation, FMX.Layouts, FMX.Edit;

type
  Tfra_AddBibliothek = class(Tfra_Base)
    Layout1: TLayout;
    Label1: TLabel;
    gly_Save: TGlyph;
    Label2: TLabel;
    edt_Bibliothek: TEdit;
    gly_Cancel: TGlyph;
  private
    procedure Save(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  fra_AddBibliothek: Tfra_AddBibliothek;

implementation

{$R *.fmx}

uses
  fmx.DialogService;

{ Tfra_AddBibliothek }

constructor Tfra_AddBibliothek.Create(AOwner: TComponent);
begin
  inherited Create(aOwner);
  gly_Save.HitTest := true;
  gly_Save.OnClick := Save;
  gly_Cancel.HitTest := true;
  gly_Cancel.OnClick := BackClick;
end;

procedure Tfra_AddBibliothek.Save(Sender: TObject);
begin
  TDialogService.ShowMessage('Gespeichert');
  BackClick(Self);
end;

end.
