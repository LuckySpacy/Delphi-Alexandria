unit Form.QRCodeWallet;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.ImgList, Datenmodul.dm,
  datenmodul.Bilder, Frame.Main, FMX.TabControl, Frame.NeuBibliothek;

type
  Tfrm_QRCodeWallet = class(TForm)
    tbc: TTabControl;
    tbs_Main: TTabItem;
    tbs_NeuBibliothek: TTabItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    fFrameMain: Tfra_Main;
    fFrameAddBibliothek: Tfra_AddBibliothek;
    fFormVerlauf: TList;
    fFrameList: TList;
    procedure CreateFrame(aFrame: TFrame; aTabItem: TTabItem);
    procedure ShowFrame(aFrame: TFrame);
    procedure AddBibliothek(Sender: TObject);
    procedure Back(Sender: TObject);
  public
  end;

var
  frm_QRCodeWallet: Tfrm_QRCodeWallet;

implementation

{$R *.fmx}

uses
  Frame.Base;



procedure Tfrm_QRCodeWallet.FormCreate(Sender: TObject);
begin//
  fFormVerlauf := TList.Create;
  fFrameList   := TList.Create;
  fFrameMain := TFra_Main.Create(Self);
  CreateFrame(fFrameMain, tbs_Main);
  fFrameAddBibliothek := Tfra_AddBibliothek.Create(Self);
  CreateFrame(fFrameAddBibliothek, tbs_NeuBibliothek);
  fFrameMain.OnAddBibliothek := AddBibliothek;
end;

procedure Tfrm_QRCodeWallet.FormDestroy(Sender: TObject);
begin //
  FreeAndNil(fFormVerlauf);
  FreeAndNil(fFrameList);
end;


procedure Tfrm_QRCodeWallet.FormShow(Sender: TObject);
begin
  ShowFrame(fFrameMain);
end;

procedure Tfrm_QRCodeWallet.ShowFrame(aFrame: TFrame);
var
  i1: Integer;
begin
  for i1 := 0 to fFrameList.Count -1 do
  begin
    if SameText(aFrame.Name, TFrame(fFrameList.Items[i1]).Name) then
    begin
      if fFormVerlauf.Count = 0 then
        fFormVerlauf.Add(fFrameList.Items[i1]);
      if (fFormVerlauf.Count > 0) and (not SameText(TFrame(fFormVerlauf.Items[fFormVerlauf.Count-1]).Name, aFrame.Name)) then
        fFormVerlauf.Add(fFrameList.Items[i1]);

      tbc.ActiveTab := Tfra_Base(fFrameList.Items[i1]).TabItem;
    end;
  end;
end;

procedure Tfrm_QRCodeWallet.AddBibliothek(Sender: TObject);
begin
  ShowFrame(fFrameAddBibliothek);
end;

procedure Tfrm_QRCodeWallet.Back(Sender: TObject);
begin
  if fFormVerlauf.Count = 0 then
  begin
    ShowFrame(fFrameMain);
    exit;
  end;

  fFormVerlauf.Delete(fFormVerlauf.Count-1);
  ShowFrame(TFrame(fFormVerlauf.Items[fFormVerlauf.Count-1]));

end;

procedure Tfrm_QRCodeWallet.CreateFrame(aFrame: TFrame; aTabItem: TTabItem);
begin //
  while aFrame.ChildrenCount > 0 do
    aFrame.Children[0].Parent := aTabItem;
  aFrame.Align  := TAlignLayout.Client;
  Tfra_Base(aFrame).TabItem := aTabItem;
  Tfra_Base(aFrame).OnBack  := Back;
  fFrameList.Add(aFrame);
end;


end.
