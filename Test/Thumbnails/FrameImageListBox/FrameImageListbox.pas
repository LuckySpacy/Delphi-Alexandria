/// <summary>
/// Frame that displays an image thumbnail-list
// <img src="FrameImageListbox.jpg">
/// </summary>
unit FrameImageListbox;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, System.IOUtils, System.Threading,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, FMX.Objects, FMX.ListBox, FMX.Layouts;

type
  TFr_ImageListbox = class(TFrame)
    lbFiles: TListBox;
    lbTemplate: TListBox;
    ListBoxItemImageTemplate: TListBoxItem;
    ImageMini: TImage;
    FileInfo: TText;
    Line1: TLine;
    Line2: TLine;
    procedure ListBoxItemImageTemplateApplyStyleLookup(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    /// <summary>
    /// With this procedure you can show the images in the given directory
    /// </summary>
    /// <example>
    /// If you want to access the name of a clicked file,
    /// use Onclick of the listbox. Example:
    /// <code>
    /// procedure TForm1.Fr_ImageListbox1lbFilesClick(Sender: TObject);
    /// begin
    ///   Image1.Bitmap.LoadFromFile(Fr_ImageListbox1.lbFiles.listitems[Fr_ImageListbox1.lbFiles.itemindex].tagstring)
    /// end;
    /// </code>
    /// </example>
    procedure ShowFilesInFolder(Dir: string; AMask: string = '*.*');
  end;

implementation

{$R *.fmx}

{ TFr_ImageListbox }
procedure TFr_ImageListbox.ListBoxItemImageTemplateApplyStyleLookup(Sender: TObject);
var
  LI: TListboxItem; TI: TImage;

  procedure LoadAndShrinkImage;
  begin
    try
      TI.Bitmap.LoadFromFile(LI.TagString);
      TI.Bitmap.CreateThumbnail(round (TI.Width), Round (TI.Height));
    except
    end;
  end;

begin
  if Sender is TListboxItem then begin
    LI := TListBoxItem(Sender);

    for var x := 0 to LI.ChildrenCount-1 do begin
      if LI.Children[x] is TImage then begin
        TI := TImage (LI.Children[x]); break;
      end;
    end;

    if (TI <> NIL) and (LI.TagString <> '') then begin
      if FileExists (LI.TagString) then begin
        {$IFDEF MSWindows}
        try
          TI.Bitmap.LoadThumbnailFromFile (LI.TagString,TI.Width, TI.Height );
        except
          LoadAndShrinkImage;
        end;
        {$ELSE}
        LoadAndShrinkImage;
        {$ENDIF}
      end;
    end;
  end;
end;

procedure TFr_ImageListbox.ShowFilesInFolder(Dir: string; AMask: string = '*.*');
var
  TI: TImage; LI: TListBoxItem; FileName: String;  FilterPredicate: TDirectory.TFilterPredicate;
begin
  FilterPredicate :=
    function(const Path: string; const SearchRec: TSearchRec): Boolean
    begin
      Result := (System.ioutils.TPath.MatchesPattern(SearchRec.Name, AMask, False));
      if Result then begin
        Result := Pos(LowerCase(ExtractFileExt(SearchRec.Name)), TBitmapCodecManager.GetFileTypes) > 0;
      end;
    end;

  lbFiles.Clear;

  var I : Integer := 0;
  lbFiles.BeginUpdate;
  for FileName in TDirectory.GetFiles(Dir, FilterPredicate) do begin
    Inc (i);

    LI := TListBoxItem (listboxitemImageTemplate.clone (listboxitemImageTemplate));
    LI.Parent := lbFiles;

    LI.Width := 134;
    LI.Height := 110;

    LI.TagString := FileName;
    TText (LI.Children[1]).Text := '[' + i.ToString + '] ' +  ExtractFileName (FileName);

    LI.OnApplyStyleLookup := ListBoxItemImageTemplateApplyStyleLookup;
  end;
  lbFiles.EndUpdate;
end;

end.
