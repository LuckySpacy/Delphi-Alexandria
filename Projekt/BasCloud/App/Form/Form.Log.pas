unit Form.Log;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Memo.Types,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, FMX.ImgList, FMX.Objects;

type
  Tfrm_Log = class(TForm)
    mem: TMemo;
    Rec_Toolbar_Background: TRectangle;
    gly_Return: TGlyph;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    fOnZurueck: TNotifyEvent;
    procedure btn_ReturnClick(Sender: TObject);
  public
    property OnZurueck: TNotifyEvent read fOnZurueck write fOnZurueck;
  end;

var
  frm_Log: Tfrm_Log;

implementation

{$R *.fmx}


procedure Tfrm_Log.FormCreate(Sender: TObject);
begin //
  gly_Return.HitTest := true;
  gly_return.OnClick := btn_ReturnClick;
end;

procedure Tfrm_Log.FormDestroy(Sender: TObject);
begin //

end;


procedure Tfrm_Log.btn_ReturnClick(Sender: TObject);
begin
  if Assigned(fOnZurueck) then
    fOnZurueck(Self);
end;


end.
