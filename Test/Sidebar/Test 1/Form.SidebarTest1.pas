unit Form.SidebarTest1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.MultiView, FMX.StdCtrls, FMX.Edit,
  FMX.SearchBox, FMX.Layouts, FMX.ListBox, System.ImageList, FMX.ImgList,
  System.Generics.Collections;

type
  Tfrm_SidebarTest1 = class(TForm)
    MultiView: TMultiView;
    Button1: TButton;
    Lay_Sidebar: TLayout;
    ListBox1: TListBox;
    SearchBox1: TSearchBox;
    CornerButton1: TCornerButton;
    ListBoxItem1: TListBoxItem;
    SB: TStyleBook;
    Img: TImageList;
    CornerButton2: TCornerButton;
    btn_Test1: TCornerButton;
    ListBoxItem2: TListBoxItem;
    btn_Message: TCornerButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btn_Test1Click(Sender: TObject);
    procedure btn_MessageClick(Sender: TObject);
  private
    fListMenu: TList<TCornerButton>;
    procedure setMenu(B: TCornerButton);
  public
    { Public-Deklarationen }
  end;

var
  frm_SidebarTest1: Tfrm_SidebarTest1;

implementation

{$R *.fmx}

uses
  fmx.DialogService;



procedure Tfrm_SidebarTest1.FormCreate(Sender: TObject);
begin  //
  MultiView.Width := 250;
  MultiView.Mode := TMultiViewMode.Drawer;
  fListMenu := TList<TCornerButton>.Create;
  fListMenu.Add(btn_Test1);
  fListMenu.Add(btn_Message);
end;

procedure Tfrm_SidebarTest1.FormDestroy(Sender: TObject);
begin //
  fListMenu.DisposeOf;
end;

procedure Tfrm_SidebarTest1.setMenu(B: TCornerButton);
begin
  var lb: TCornerbutton;
  for lb in fListMenu do
  begin
    lb.StyleLookup := 'btn_Sidebar';
    lb.Font.Style  := [];
    lb.FontColor   := $FF5E5E5E;
    lb.StyledSettings := [];
  end;
  b.Font.Style :=[TFontStyle.fsBold];
  b.FontColor   := $FFFFFFFF;
  b.StyleLookup := 'btn_SidebarS';
end;

procedure Tfrm_SidebarTest1.Button1Click(Sender: TObject);
begin
  MultiView.ShowMaster;
end;


procedure Tfrm_SidebarTest1.btn_Test1Click(Sender: TObject);
begin
  setMenu(TCornerButton(Sender));
  //TDialogService.ShowMessage('Hurra');
end;

procedure Tfrm_SidebarTest1.btn_MessageClick(Sender: TObject);
begin
  setMenu(TCornerButton(Sender));
 // MultiView.HideMaster;
end;

end.
