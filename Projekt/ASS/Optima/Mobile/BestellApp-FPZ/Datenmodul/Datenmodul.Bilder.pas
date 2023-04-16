unit Datenmodul.Bilder;

interface

uses
  System.SysUtils, System.Classes, System.ImageList, FMX.ImgList, FMX.Types,
  FMX.Controls;

type
  TButtonStyleEvents = (bse_ButtonDown, bse_ButtonUp, bse_ButtonNone);

type
  Tdm_Bilder = class(TDataModule)
    iml_16: TImageList;
    iml_32: TImageList;
    SB: TStyleBook;
    procedure DataModuleCreate(Sender: TObject);
  private
    fButtonStyleEvents: TButtonStyleEvents;
  public
    procedure ASSButtonStyleMouseDown(Sender: TObject);
    procedure ASSButtonStyleMouseUp(Sender: TObject);
    procedure ASSButtonStyleApplyStyleLookup(Sender: TObject);
  end;

var
  dm_Bilder: Tdm_Bilder;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

uses
  fmx.StdCtrls, fmx.Effects, fmx.Styles.Objects;

procedure Tdm_Bilder.DataModuleCreate(Sender: TObject);
begin
  fButtonStyleEvents := bse_ButtonNone;
end;


procedure Tdm_Bilder.ASSButtonStyleApplyStyleLookup(Sender: TObject);
var
  Obj: TfmxObject;
begin
  //if fButtonStyleEvents = bse_ButtonNone then
  //  exit;

  Obj := TButton(Sender).FindStyleResource('ASSButtonStyle_Shadow');
  if (Obj <> nil) and (Obj is TShadowEffect) then
  begin
    if fButtonStyleEvents = bse_ButtonDown then
      TShadowEffect(Obj).Enabled := false;
    if fButtonStyleEvents = bse_ButtonUp then
      TShadowEffect(Obj).Enabled := true;
  end;

  Obj := TButton(Sender).FindStyleResource('text');
  if (Obj <> nil) and (Obj is TbuttonStyleTextObject) then
  begin
    if fButtonStyleEvents = bse_ButtonDown then
    begin
      TbuttonStyleTextObject(Obj).Position.x := TbuttonStyleTextObject(Obj).Position.x + 1;
      TbuttonStyleTextObject(Obj).Position.y := TbuttonStyleTextObject(Obj).Position.y + 1;
    end;
    if fButtonStyleEvents = bse_ButtonUp then
    begin
      TbuttonStyleTextObject(Obj).Position.x := TbuttonStyleTextObject(Obj).Position.x - 1;
      TbuttonStyleTextObject(Obj).Position.y := TbuttonStyleTextObject(Obj).Position.y - 1;
    end;
  end;


  Obj := TButton(Sender).FindStyleResource('glyphstyle');
  if (Obj <> nil) and (Obj is TGlyph) then
  begin
    if fButtonStyleEvents = bse_ButtonDown then
    begin
      TGlyph(Obj).Position.x := TGlyph(Obj).Position.x + 1;
      TGlyph(Obj).Position.y := TGlyph(Obj).Position.y + 1;
    end;
    if fButtonStyleEvents = bse_ButtonUp then
    begin
      TGlyph(Obj).Position.x := TGlyph(Obj).Position.x - 1;
      TGlyph(Obj).Position.y := TGlyph(Obj).Position.y - 1;
    end;
  end;

  if fButtonStyleEvents = bse_ButtonNone then
  begin
    Obj := TButton(Sender).FindStyleResource('glyphstyle');
    if (Obj <> nil) and (Obj is TGlyph) then
    begin
      TGlyph(Obj).Position.x := 10;
    end;
  end;

end;



procedure Tdm_Bilder.ASSButtonStyleMouseDown(Sender: TObject);
begin
  fButtonStyleEvents := bse_ButtonDown;
  TButton(Sender).NeedStyleLookup;
  TButton(Sender).ApplyStyleLookup;
end;

procedure Tdm_Bilder.ASSButtonStyleMouseUp(Sender: TObject);
begin
  fButtonStyleEvents := bse_ButtonUp;
  TButton(Sender).NeedStyleLookup;
  TButton(Sender).ApplyStyleLookup;
end;

end.
