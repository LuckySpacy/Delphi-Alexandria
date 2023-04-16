unit Form.GestemImageTest1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, Objekt.Android.Permissions,
  FMX.Gestures;

type
  TForm3 = class(TForm)
    Panel1: TPanel;
    Img: TImage;
    Button1: TButton;
    Label1: TLabel;
    GestureManager1: TGestureManager;
    pnl_Img: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormGesture(Sender: TObject; const EventInfo: TGestureEventInfo;
      var Handled: Boolean);
    procedure FormShow(Sender: TObject);
  private
    fLastDistance: Integer;
    fAndroidPermissions: TAndroidPermission;
    fLastPosition: TPointF;
    fPfad: string;
    fImgMinWidth: single;
    fImgMinHeight: single;
    procedure ImageInfo;
  public

  end;

var
  Form3: TForm3;

implementation

{$R *.fmx}

uses
  System.IOUtils, System.Math;


procedure TForm3.FormCreate(Sender: TObject);
begin //
  fAndroidPermissions := TAndroidPermission.Create;
  fAndroidPermissions.Request;
  fPfad := System.IOUtils.TPath.Combine(TPath.GetSharedDocumentsPath, 'ThumbnailTest');
end;

procedure TForm3.FormDestroy(Sender: TObject);
begin //
  FreeAndNil(fAndroidPermissions);
end;



procedure TForm3.Button1Click(Sender: TObject);
var
  Filename: string;
begin
  Filename := System.IOUtils.TPath.Combine(fPfad, 'Hurra.jpg');
  Img.Bitmap.LoadFromFile(Filename);
  ImageInfo;
end;


procedure TForm3.FormGesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
var
  LObj: IControl;
  LImage: TImage;
  LImageCenter: TPointF;
begin

  if EventInfo.GestureID = igiZoom then
  begin
    LObj := Self.ObjectAtPoint(ClientToScreen(EventInfo.Location));
    if LObj is TImage then
    begin
      if (not(TInteractiveGestureFlag.gfBegin in EventInfo.Flags)) and
        (not(TInteractiveGestureFlag.gfEnd in EventInfo.Flags)) then
      begin
        { zoom the image }
        Button1.Text := 'Hurrax';
        LImage := TImage(LObj.GetObject);
        //LImage.Width := LImage.Width +1;
        //LImage.Height := LImage.Height + 1;


        LImageCenter := LImage.Position.Point + PointF(LImage.Width / 2,LImage.Height / 2);
        LImage.Width := Max(LImage.Width + (EventInfo.Distance - FLastDistance), 10);
        LImage.Height := Max(LImage.Height + (EventInfo.Distance - FLastDistance), 10);
        //LImage.Position.X := LImageCenter.X - LImage.Width / 2;
        //LImage.Position.Y := LImageCenter.Y - LImage.Height / 2;

        if lImage.Width < fImgMinWidth then
          lImage.Width := fImgMinWidth;

        if lImage.Height < fImgMinHeight then
          lImage.Height := fImgMinHeight;

        if (lImage.Width = fImgMinWidth) and (lImage.Height = fImgMinHeight) then
        begin
          LImage.Position.X := 0;
          LImage.Position.Y := 0;
        end;


      end;
      FLastDistance := EventInfo.Distance;
      Label1.Text := EventInfo.Distance.ToString;
    end;
  end;

  {
  if EventInfo.GestureID = sgiLeft then
  begin
    Button1.Text := 'Left';
    Img.Position.X := Img.Position.X -10;
  end;
  if EventInfo.GestureID = sgiRight then
  begin
    Button1.Text := 'Right';
     Img.Position.X := Img.Position.X +10;
  end;
  }


  if EventInfo.GestureID = igiPan then
  begin
    LObj := Self.ObjectAtPoint(ClientToScreen(EventInfo.Location));
    if LObj is TImage then
    begin
      if not(TInteractiveGestureFlag.gfBegin in EventInfo.Flags) then
      begin
        LImage := TImage(LObj.GetObject);

        if (lImage.Width <= fImgMinWidth) and (lImage.Height <= fImgMinHeight) then
          exit;

        //Set the X coordinate.
        LImage.Position.X := LImage.Position.X + (EventInfo.Location.X - FLastPosition.X);
       // if LImage.Position.X < 0 then
       //   LImage.Position.X := 0;
        //if LImage.Position.X > (pnl_Img.Width - LImage.Width) then
        //  LImage.Position.X := pnl_Img.Width - LImage.Width;

          //Set the Y coordinate.
        LImage.Position.Y := LImage.Position.Y + (EventInfo.Location.Y - FLastPosition.Y);
       // if LImage.Position.Y < 0 then
       //   LImage.Position.Y := 0;
       // if LImage.Position.Y > (pnl_Img.Height - LImage.Height) then
        //  LImage.Position.Y := pnl_Img.Height - LImage.Height;
      end;

      FLastPosition := EventInfo.Location;
    end;
  end;

  if EventInfo.GestureID = igiPressAndTap then
  begin
    Button1.Text := 'Press';
  end;

  if EventInfo.GestureID = igiLongTap then
  begin
    Button1.Text := 'igiLongTap';
  end;

  if EventInfo.GestureID = igiDoubleTap then
  begin
    Button1.Text := 'igiLongTap';
  end;


  ImageInfo;
end;

procedure TForm3.FormShow(Sender: TObject);
begin
  fImgMinWidth  := pnl_Img.Width;
  fImgMinHeight := pnl_Img.Height;
  Img.Position.x := 0;
  Img.Position.y := 0;
  Img.Height := pnl_Img.Height;
  Img.Width := pnl_Img.Width;
  ImageInfo;
end;

procedure TForm3.ImageInfo;
begin
  Label1.Text := Img.Width.ToString + ' / ' + Img.Height.ToString +
                 Img.Position.X.ToString + ' / ' + Img.Position.Y.ToString;
end;

end.
