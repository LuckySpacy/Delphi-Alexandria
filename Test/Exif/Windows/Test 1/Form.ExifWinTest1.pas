unit Form.ExifWinTest1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Memo.Types,
  FMX.ScrollBox, FMX.Memo, FMX.StdCtrls, FMX.Controls.Presentation, CloudExif;

type
  TForm2 = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    mem: TMemo;
    Button2: TButton;
    Button3: TButton;
    AdvCloudExifImage: TAdvCloudExifImage;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form2: TForm2;

implementation

{$R *.fmx}

uses
  Winapi.Windows, Winapi.Messages, Vcl.Graphics, vcl.Imaging.jpeg,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Winapi.GDIPOBJ, Winapi.GDIPAPI, Vcl.StdCtrls;
  {
  vcl.Graphics, vcl.Imaging.jpeg, winapi.GraphicsRT, winapi.Media, Wincodec, Winapi.PropKey, Winapi.GDIPAPI, Winapi.GDIPUTIL,
  Winapi.GDIPOBJ;
  }


procedure TForm2.FormCreate(Sender: TObject);
begin //

end;

procedure TForm2.FormDestroy(Sender: TObject);
begin //

end;


procedure TForm2.Button1Click(Sender: TObject);
var
  f: File;
  s: string;
  Buf: array[1..2048] of char;
  i1: Integer;
begin
  mem.Lines.LoadFromFile('d:\Bachmann\Daten\OneDrive\Bilder\20230402_143303.jpg');
  {
  AssignFile(f,'d:\Bachmann\Daten\OneDrive\Bilder\20230402_143303.jpg');
  reset(f,1);
  while not eof(f) do
  begin
    BlockRead(f, Buf, SizeOf(Buf), i1);
    s := '';
    for i1 := 1 to SizeOf(Buf) -1 do
    begin
      s := s + Buf[i1];
    end;
    break;
  end;
  //Mem.Lines.Add(S); { String in ein TMemo schreiben
  CloseFile(f);
  }
end;


procedure TForm2.Button2Click(Sender: TObject);
var
  jpeg: TJPEGImage;
begin //

  jpeg := TJPEGImage.Create;
  try
    jpeg.LoadFromFile('d:\Bachmann\Daten\OneDrive\Bilder\20230402_143303.jpg');
//    jpeg.
  finally
    FreeAndNil(jpeg);
  end;

end;



procedure TForm2.Button3Click(Sender: TObject);
var
  Bitmap: TGPBitmap;
  PropertyItem: TPropertyItem;
  Size: Integer;
  Value: PByte;
  ExifData: AnsiString;
  DateTimeOriginal: AnsiString;
  totalBufferSize: UInt;
  f: TAdvCloudExifImage;    
begin
    f := TAdvCloudExifImage.Create(nil);
    try
      f.FileName := 'd:\Bachmann\Daten\OneDrive\Bilder\20230402_143303.jpg';
    
    finally
      FreeAndNil(f);
    end;
 
{
    Bitmap := TGPBitmap.Create('d:\Bachmann\Daten\OneDrive\Bilder\20230402_143303.jpg');
    try
      totalBufferSize := Sizeof(PropertyItem);
//      Bitmap.GetPropertySize(
      if Bitmap.GetPropertySize(Sizeof(PropertyItem), Size) = Ok then
      begin
        GetMem(Value, Size);
        try
          if Bitmap.GetPropertyItem(PropertyTagExifIFD, Size, @PropertyItem) = Ok then
          begin
            //function TGPImage.GetPropertyItem(propId: PROPID; propSize: UINT;
            //   buffer: PPropertyItem): TStatus;
            Bitmap.GetPropertyItem(PropertyTagExifIFD, Size, @PropertyItem);
            ExifData := AnsiString(PChar(@PropertyItem.Value));
            Mem.Lines.Add('Exif data for ' + 'd:\Bachmann\Daten\OneDrive\Bilder\20230402_143303.jpg' + ':');
            //Mem.Lines.Add('Exif Data: ' + ExifData);
            DateTimeOriginal := Copy(ExifData, Pos('DateTimeOriginal', ExifData) + 17, 19);
            Mem.Lines.Add('Date/Time Taken: ' + DateTimeOriginal);
          end;
        finally
          FreeMem(Value);
        end;
      end;
    finally
      Bitmap.Free;
    end;
    }
end;

end.
