unit Form.FontFav;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.StdCtrls, Vcl.ExtCtrls,
  Objekt.SyncListbox;

type
  Tfrm_FontFavoriten = class(TForm)
    pnl_Buttton: TPanel;
    btn_Close: TButton;
    btn_Cancel: TButton;
    pnl_Left: TPanel;
    pnl_Fonts: TPanel;
    lsb_Font: TListBox;
    pnl_Right: TPanel;
    pnl_Favoriten: TPanel;
    lsb_Favoriten: TListBox;
    pnl_Client: TPanel;
    cmd_Right: TSpeedButton;
    cmd_Left: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure lsb_FavoritenDblClick(Sender: TObject);
    procedure lsb_FontDblClick(Sender: TObject);
    procedure btn_CancelClick(Sender: TObject);
    procedure btn_CloseClick(Sender: TObject);
    procedure cmd_LeftClick(Sender: TObject);
    procedure cmd_RightClick(Sender: TObject);
  private
    FCancel: Boolean;
    FSyncListBoxFont: TSyncListBox;
    FMemFontFavList: TStringList;
    procedure LoadFonts;
  public
    function ChangedFontFavList: Boolean;
    procedure SetFavoriten(aValue: string);
    function GetFavoriten: string;
    property Cancel: Boolean read FCancel;
  end;

var
  frm_FontFavoriten: Tfrm_FontFavoriten;

implementation

{$R *.dfm}




procedure Tfrm_FontFavoriten.FormCreate(Sender: TObject);
begin
  FCancel := true;
  LoadFonts;
  lsb_Favoriten.Clear;
  lsb_Font.Sorted := true;
  lsb_Favoriten.Sorted := true;
  FSyncListBoxFont := TSyncListBox.Create(Self);
  FSyncListBoxFont.BoxLeft  := lsb_Font;
  FSyncListBoxFont.BoxRight := lsb_Favoriten;
  FSyncListBoxFont.DeleteRightItems;
  FMemFontFavList := TStringList.Create;
  FMemFontFavList.Sorted := true;
  FMemFontFavList.Duplicates := dupIgnore;
end;

procedure Tfrm_FontFavoriten.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FMemFontFavList);
  FreeAndNil(FSyncListBoxFont);
end;

procedure Tfrm_FontFavoriten.FormResize(Sender: TObject);
begin
  pnl_Left.Left  := 0;
  pnl_Left.Top   := 0;
  pnl_Left.Width := Trunc((ClientWidth - 50)/2);
  pnl_Client.Left := pnl_Left.Width;
  pnl_Client.Top  := 0;
  pnl_Right.Width := pnl_Left.Width;
  pnl_Right.Left  := pnl_Left.Width + pnl_Client.Width;
  pnl_Left.Height := ClientHeight - pnl_Buttton.Height;
  pnl_client.Height := pnl_Left.Height;
  pnl_Right.Height  := pnl_Left.height;
end;

function Tfrm_FontFavoriten.GetFavoriten: string;
begin
  Result := lsb_Favoriten.Items.Text;
end;

procedure Tfrm_FontFavoriten.LoadFonts;
var
  i1: Integer;
begin
  lsb_Font.Items := Screen.Fonts;
  for i1 := lsb_Font.Items.Count -1 downto 0 do
  begin
    if lsb_Font.Items.Strings[i1][1] = '@'  then
      lsb_Font.Items.Delete(i1);
  end;
end;

procedure Tfrm_FontFavoriten.lsb_FavoritenDblClick(Sender: TObject);
begin
  FSyncListBoxFont.MoveRightToLeft;
end;

procedure Tfrm_FontFavoriten.lsb_FontDblClick(Sender: TObject);
begin
  FSyncListBoxFont.MoveLeftToRight;
end;

procedure Tfrm_FontFavoriten.SetFavoriten(aValue: string);
begin
  lsb_Favoriten.Items.Text := aValue;
  FSyncListBoxFont.DeleteLeftItems;
  FMemFontFavList.Text := aValue;
end;

procedure Tfrm_FontFavoriten.btn_CancelClick(Sender: TObject);
begin
  close;
end;

procedure Tfrm_FontFavoriten.btn_CloseClick(Sender: TObject);
begin
  FCancel := false;
  close;
end;

function Tfrm_FontFavoriten.ChangedFontFavList: Boolean;
begin
  Result := false;
  if FMemFontFavList.Text <> lsb_Favoriten.Items.Text then
    Result := true;
end;

procedure Tfrm_FontFavoriten.cmd_LeftClick(Sender: TObject);
begin
  FSyncListBoxFont.MoveRightToLeft;
end;

procedure Tfrm_FontFavoriten.cmd_RightClick(Sender: TObject);
begin
  FSyncListBoxFont.MoveLeftToRight;
end;

end.
