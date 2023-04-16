unit Form.Datenschutzbestimmung;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.WebBrowser,
  FMX.ImgList, FMX.Objects;

type
  Tfrm_Datenschutzbestimmung = class(TForm)
    Rec_Toolbar_Background: TRectangle;
    gly_Return: TGlyph;
    WebBrowser: TWebBrowser;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    fOnZurueck: TNotifyEvent;
    procedure btn_ReturnClick(Sender: TObject);
  public
    property OnZurueck: TNotifyEvent read fOnZurueck write fOnZurueck;
    procedure setUrl(aUrl: string);
  end;

var
  frm_Datenschutzbestimmung: Tfrm_Datenschutzbestimmung;

implementation

{$R *.fmx}

{ Tfrm_Datenschutzbestimmung }


procedure Tfrm_Datenschutzbestimmung.FormCreate(Sender: TObject);
begin
  gly_Return.HitTest := true;
  gly_return.OnClick := btn_ReturnClick;
end;

procedure Tfrm_Datenschutzbestimmung.FormDestroy(Sender: TObject);
begin //

end;

procedure Tfrm_Datenschutzbestimmung.setUrl(aUrl: string);
begin
  WebBrowser.URL := aUrl;
end;

procedure Tfrm_Datenschutzbestimmung.btn_ReturnClick(Sender: TObject);
begin
  if Assigned(fOnZurueck) then
    fOnZurueck(Self);
end;


end.
