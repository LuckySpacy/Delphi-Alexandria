unit Form.NFSRichViewEditPreview;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, RVScroll, CRVPP, RVPP, Vcl.StdCtrls,
  Vcl.ExtCtrls;

type
  Tfrm_NFSRichViewEditPreview = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    cmb: TComboBox;
    btn_First: TButton;
    btn_Prev: TButton;
    btn_Next: TButton;
    btn_Last: TButton;
    rvpp: TRVPrintPreview;
    procedure btn_FirstClick(Sender: TObject);
    procedure btn_LastClick(Sender: TObject);
    procedure btn_PrevClick(Sender: TObject);
    procedure btn_NextClick(Sender: TObject);
    procedure DoZoom(Sender: TObject);
    procedure cmbKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    procedure UpdateZoom;
  public
  end;

var
  frm_NFSRichViewEditPreview: Tfrm_NFSRichViewEditPreview;

implementation

{$R *.dfm}

//******************************************************************************
//*** EVENTS
//******************************************************************************

//------------------------------------------------------------------------------
//--- Buttons
//------------------------------------------------------------------------------

procedure Tfrm_NFSRichViewEditPreview.btn_FirstClick(Sender: TObject);
begin
  rvpp.First;
  Label1.Caption :=Format('%d von %d', [rvpp.PageNo, rvpp.RVPrint.PagesCount]);
end;

procedure Tfrm_NFSRichViewEditPreview.btn_LastClick(Sender: TObject);
begin
  rvpp.Last;
  Label1.Caption :=Format('%d von %d', [rvpp.PageNo, rvpp.RVPrint.PagesCount]);
end;

procedure Tfrm_NFSRichViewEditPreview.btn_NextClick(Sender: TObject);
begin
  rvpp.Next;
  Label1.Caption :=Format('%d von %d', [rvpp.PageNo, rvpp.RVPrint.PagesCount]);
end;

procedure Tfrm_NFSRichViewEditPreview.btn_PrevClick(Sender: TObject);
begin
  rvpp.Prev;
  Label1.Caption :=Format('%d von %d', [rvpp.PageNo, rvpp.RVPrint.PagesCount]);
end;



//------------------------------------------------------------------------------
//--- Combobox
//------------------------------------------------------------------------------

procedure Tfrm_NFSRichViewEditPreview.cmbKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=VK_RETURN then
  begin
    UpdateZoom;
    Key := 0;
  end;
end;


procedure Tfrm_NFSRichViewEditPreview.DoZoom(Sender: TObject);
begin
  UpdateZoom;
end;


//******************************************************************************
//*** Private Funktionen und Prozeduren
//******************************************************************************
procedure Tfrm_NFSRichViewEditPreview.UpdateZoom;
var
  s: String;
  zoom: Integer;
begin
  s := Trim(cmb.Text);
  if s='Bildschirmbreite' then
  begin
    rvpp.ZoomMode := rvzmPageWidth;
    exit;
  end;
  if s='Ganze Seite' then
  begin
    rvpp.ZoomMode := rvzmFullPage;
    exit;
  end;
  if (s<>'') and (s[Length(s)]='%') then
    s := Copy(s,1,Length(s)-1);
  zoom := StrToIntDef(s,0);
  if (zoom<10) or (zoom>500) then
    Application.MessageBox('Bitte geben Sie eine Zahl zwischen 10 und 500 ein.','Scale',MB_OK or MB_ICONSTOP)
  else
    rvpp.SetZoom(zoom);
end;

end.
