unit Frame.ImageListBox;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, FMX.ListBox, FMX.Objects, DB.BilderList, DB.Bilder;

type
  Tfra_ImageListBox = class(TFrame)
    lbx_Image: TListBox;
    lbTemplate: TListBox;
    ListBoxItemImageTemplate: TListBoxItem;
    ImageMini: TImage;
    FileInfo: TText;
    Line1: TLine;
    Line2: TLine;
    procedure ListBoxItemImageTemplateApplyStyleLookup(Sender: TObject);
  private
    fDBBilderList: TDBBilderList;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ShowFilesInFolder(Dir: string; AMask: string = '*.*');
    procedure ShowFilesInFolder2(aDir: string);
  end;

implementation

{$R *.fmx}

{ Tfra_ImageListBox }

uses
  System.IOUtils, Objekt.PhotoOrga;

constructor Tfra_ImageListBox.Create(AOwner: TComponent);
begin   //
  inherited;
  lbTemplate.Visible := false;
  lbx_Image.Align := TAlignLayout.Client;
  fDBBilderList := TDBBilderList.Create;
  fDBBilderList.Connection := PhotoOrga.Connection;
end;

destructor Tfra_ImageListBox.Destroy;
begin  //
  FreeAndNil(fDBBilderList);
  inherited;
end;

procedure Tfra_ImageListBox.ListBoxItemImageTemplateApplyStyleLookup(
  Sender: TObject);
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

procedure Tfra_ImageListBox.ShowFilesInFolder(Dir, AMask: string);
var
  TI: TImage;
  LI: TListBoxItem;
  FileName: String;
  FilterPredicate: TDirectory.TFilterPredicate;
begin
  FilterPredicate :=
    function(const Path: string; const SearchRec: TSearchRec): Boolean
    begin
      Result := (System.ioutils.TPath.MatchesPattern(SearchRec.Name, AMask, False));
      if Result then begin
        Result := Pos(LowerCase(ExtractFileExt(SearchRec.Name)), TBitmapCodecManager.GetFileTypes) > 0;
      end;
    end;

  lbx_Image.Clear;

  var I : Integer := 0;
  lbx_Image.BeginUpdate;
  for FileName in TDirectory.GetFiles(Dir, FilterPredicate) do begin
    Inc (i);

    LI := TListBoxItem (listboxitemImageTemplate.clone (listboxitemImageTemplate));
    LI.Parent := lbx_Image;

    LI.Width := 134;
    LI.Height := 110;

    LI.TagString := FileName;
    TText (LI.Children[1]).Text := '[' + i.ToString + '] ' +  ExtractFileName (FileName);

    LI.OnApplyStyleLookup := ListBoxItemImageTemplateApplyStyleLookup;
  end;
  lbx_Image.EndUpdate;

end;

procedure Tfra_ImageListBox.ShowFilesInFolder2(aDir: string);
var
  i1: Integer;
  LI: TListBoxItem;
  TI : TImage;
  DBBilder: TDBBilder;
begin
  lbx_Image.Clear;
  lbx_Image.BeginUpdate;
  try
    fDBBilderList.ReadDir(aDir);
    for i1 := 0 to fDBBilderList.Count -1 do
    begin
      DBBilder := fDBBilderList.Item[i1];
      LI := TListBoxItem (listboxitemImageTemplate.clone (listboxitemImageTemplate));
      LI.Parent := lbx_Image;

      LI.Width := 134;
      LI.Height := 110;

      LI.TagString := DBBilder.Bildname;
      TText (LI.Children[1]).Text := DBBilder.Bildname;

      TI := nil;
      for var x := 0 to LI.ChildrenCount-1 do
      begin
        if LI.Children[x] is TImage then
        begin
          TI := TImage (LI.Children[x]);
          break;
        end;
      end;

      if TI <> nil then
        DBBilder.LoadBildIntoBitmap(TI.Bitmap);

      //LI.OnApplyStyleLookup := ListBoxItemImageTemplateApplyStyleLookup;

    end;

  finally
    lbx_Image.EndUpdate;
  end;
end;

end.
