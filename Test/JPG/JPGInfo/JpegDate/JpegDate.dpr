// ..................................................................
//
//                           JpegDate
//
//            Copyright © 2001-2002 by Martin Djernæs
//
// ..................................................................
// $Id: JpegDate.dpr,v 1.5 2002/10/25 03:05:08 martin Exp $
// ..................................................................
// Description:
//   Rename / Copy Jpeg files to a file name containing the date
//   extracted from the jpeg file.
// ..................................................................
// Know issues:
//   The "wild card" match isn't very good!
//   (*.jpg does not match "image.from.aunt.lissie.jpg")
// ..................................................................
// Initial Date: November 11th, 2001
// + Can rename files based on date from inside the file.
// November 12th, 2001
// + Changed the parameters to set tag and mark the tag as suffix
//   or prefix
// November 22nd, 2001
// + Added the /i command, to print all avalible information from
//   the jpeg file
// March 13th, 2002
// + Wrapping long (binary) data on the screen
// ..................................................................
program JpegDate;

uses
  Windows,
  SysUtils,
  Classes,
  mdJpegInfo in '..\mdJpegInfo\mdJpegInfo.pas',
  mdFileStream in '..\mdFileStream\mdFileStream.pas';

{$R *.RES}
{$APPTYPE CONSOLE}

Var
  CurrentDir : String;
  DoInfo : Boolean;
  DoCopy : Boolean;
  DoRecursive : Boolean;
  FileStr : String;
  FileMask : Boolean;
  FileTag : String;
  TagPrefix : Boolean;

  FileCounter : Integer;

//
// Print a simple information about how to use the program
//
Procedure PrintInfo;
Begin
  Writeln;
  Writeln('Copyright (c) 2001-2002 by Martin Djernaes <martin@djernaes.dk>');
  Writeln('  http://www.djernaes.dk/martin/');
  Writeln;
  Writeln('JpegDate [/c] [/r] [/s] [/t:tag] <filename>');
  Writeln(' /i : Don''t copy or rename, but print all information');
  Writeln(' /c : Copy instead of rename');
  Writeln(' /r : Recursive in sub directories');
  Writeln(' /s : Use name or tag as suffix instead of prefix');
  Writeln(' /t : Use this tag for all files, instead of the file name');
  Writeln;
end;

//
// Get the parameters for the program.
// The "answer" is stored in the global variables
//
Procedure GetParam;
Var
  Cnt : Integer;
Begin
  // Check if any parameters is supplied
  If ParamCount > 0 Then
  Begin
    // Find options
    For Cnt := 1 To ParamCount-1 do
    Begin
      // Information
      If ParamStr(Cnt) = '/i' Then
        DoInfo := True;
      // Copy
      If ParamStr(Cnt) = '/c' Then
        DoCopy := True;
      // Recursive
      If ParamStr(Cnt) = '/r' Then
        DoRecursive := True;
      If Copy(ParamStr(Cnt),1,3) = '/t:' Then
        FileTag := Copy(ParamStr(Cnt),4,Length(ParamStr(Cnt)));
      If Copy(ParamStr(Cnt),1,3) = '/s' Then
        TagPrefix := False;
    end;

    // Get the file name or mask
    If Copy(ParamStr(ParamCount),1,1) <> '/' Then
    Begin
      FileStr := ParamStr(ParamCount);

      // Check if it's a mask
      FileMask := (Pos('*',FileStr) <> 0) OR
                  (Pos('?',FileStr) <> 0) OR
                  (Pos('(',FileStr) <> 0) OR
                  (Pos(')',FileStr) <> 0);

      If FileMask Then
      Begin
        // Sanity check the mask
        If (Pos('..', FileStr) <> 0) OR
           (Pos('\', FileStr) <> 0) Then
        Begin
          Writeln('Error, file mask isn''t legal');
          Writeln;
          Halt(3);
        end;
        // We rely on this when comparing with the real
        // file names later
        FileStr := LowerCase(FileStr);
      end
      else
      Begin
        // If it's a file name, it must exist
        If NOT FileExists(FileStr) Then
        Begin
          Writeln('Error, file wasn''t found');
          Writeln;
          Halt(2);
        end;
      end;
    end;
  end;

  // If we didn't get any file info, print info and stop
  If FileStr = '' Then
  Begin
    PrintInfo;
    Halt(1);
  end;
end;

//
// Return the relative file name
//
Function ShortFileName(FileName : String) : String;
Begin
  Result := ExtractRelativepath(CurrentDir+'\', FileName);
end;

//
// Match a file name with the mask.
// We support a ? for a single char, and a * for
// any char. This should match traditional Windows stuff
//
// There may be a limit which is wrong!
// Mask: "*.jpg" File: "test.file.jpg" won't match!!!
//
Function FileMatch(AName, AMask : String) : Boolean;
Var
  NameCnt, NameLen,
  MaskCnt, MaskLen : Integer;
Begin
  Result := False;
  NameLen := Length(AName);
  MaskLen := Length(AMask);
  MaskCnt := 0;
  NameCnt := 0;

  While  NameCnt < NameLen do
  Begin
    Inc(NameCnt);
    Inc(MaskCnt);
    If MaskCnt > MaskLen Then
      Exit;

    Case AMask[MaskCnt] of
      '?' : Continue;
      '*' :
      Begin
        Inc(MaskCnt);
        // We have a mask ending with a star
        // So we can ignore the rest of the file!
        If MaskCnt > MaskLen Then
        Begin
          Result := True;
          Exit;
        end;
        // Find the next char in the name matching
        // the next char in the mask.
        while AMask[MaskCnt] <> AName[NameCnt] do
        Begin
          Inc(NameCnt);
          If NameCnt > NameLen Then
            Exit; // Name wasn't any longer - wrong
        end;
      end;
    else
      Begin
        If AMask[MaskCnt] <> AName[NameCnt] Then
          Exit;
      end;
    end;
  end;
  // We have to have checked the full mask
  If MaskCnt <> MaskLen Then
    Exit;
  Result := True;
end;

//
// Convert the file to the name given by the date
// field inside the image file
//
Procedure ConvertFile(FileName : String);
Var
  SL : TStringList;
  Str : String;
  Tmp : String;
  Cnt : Integer;

  Function NumStr(Num : Integer) : String;
  Begin
    If Num > 1 Then
      Result := ' ('+IntToStr(Num)+') '
    else
      Result := '';
  end;
Begin
  SL := TStringList.Create;
  Try
    // Get the information stored in the jpeg image (if any)
    If NOT GetJpegInfo(FileName, SL) Then
    begin
      Writeln('File: '+ShortFileName(FileName)+
              ' doesn''t contain any image information.');
    end
    else
    Begin
      // We allow the user to request the full information
      // for each file.
      // This is inside convert, which is not very presice,
      // but it's very convenient!
      If DoInfo Then
      Begin
        Inc(FileCounter); // We also want to be counted...
        Writeln('Information for: '+ShortFileName(FileName));
        For Cnt := 0 To SL.Count-1 do
        Begin
          Str := SL.Values[SL.Names[Cnt]];
          If Str = '' Then
            Str := '[Unsupported]';
          If Length(Str) > 48 Then
          Begin
            Tmp := SL.Names[Cnt];
            While Length(Str) > 0 do
            Begin
              Writeln(Format('%29s: %s',[Tmp, Copy(Str,1,48)]));
              Str := Copy(Str,49,65535);
              Tmp := '';
            end;
          end
          else
            Writeln(Format('%29s: %s',[SL.Names[Cnt], Str]));
        end;
        Writeln;
        Exit;
      end;

      // The date is stored under the key "DateTime"
      Str := SL.Values['DateTime'];
      If Str = '' Then
      Begin
        Writeln('File: '+ShortFileName(FileName)+
                ' doesn''t have any date information');
      end
      else
      Begin
        //
        // Make the file info "filename_date_time.jpg"
        // - The DateTime is yyyy:mm:dd hh:nn:ss,
        //   we'll make this into yyyy-mm-dd_hh-nn-ss
        //
        For Cnt := 1 To Length(Str) do
        Begin
          Case Str[Cnt] of
            ':' : Str[Cnt] := '-';
//            ' ' : Str[Cnt] := '_';
          end
        end;

        If FileTag = '' Then
          FileTag := ChangeFileExt(ExtractFileName(FileName),'');
        Cnt := 0;
        Repeat
          If TagPrefix Then
          Begin
            Str := ExtractFilePath(FileName)+
                     FileTag+' '+Str+NumStr(Cnt)+
                     ExtractFileExt(FileName);
          end
          else
          Begin
            Str := ExtractFilePath(FileName)+
                     Str+NumStr(Cnt)+' '+FileTag+
                     ExtractFileExt(FileName);
          end;
          Inc(Cnt);
          If Cnt > 999 Then
          Begin
            Writeln('Error, can''t find new name for image');
            Exit;
          end;
        Until NOT FileExists(Str);

        If DoCopy Then
        Begin
          CopyFile(PChar(FileName), PChar(Str), True);
        end
        else
          RenameFile(FileName,Str);
        If FileMask Then
        Begin
          Writeln(ShortFileName(Str));
        end;
        Inc(FileCounter);
      end;
    end;
  Finally
    SL.Free;
  end;
end;

//
// Find a file, based on the file name
// and a mask
//
Procedure FindFile(ADir, AMask : String);
Var
  Rec : TSearchRec;
Begin
  If FindFirst(ADir+'\*.*', faAnyFile, Rec) = 0 Then
  Begin
    Repeat
      If (Rec.Name = '.') OR
         (Rec.Name = '..') Then
        Continue;
      If Rec.Attr = faDirectory Then
      Begin
        If DoRecursive Then
        Begin
          FindFile(ADir+Rec.Name, AMask);
        end;
      end
      else
      begin
        If FileMatch(LowerCase(Rec.Name), AMask) Then
          ConvertFile(ADir+'\'+Rec.Name);
      end;
    until FindNext(Rec) <> 0;
  end;
  FindClose(Rec);
end;

begin
  CurrentDir := GetCurrentDir;
  DoInfo := False;
  DoCopy := False;
  DoRecursive := False;
  FileMask := False;
  TagPrefix := True;

  GetParam;

  If NOT FileMask Then
    ConvertFile(FileStr)
  else
  Begin
    FindFile(CurrentDir, FileStr);
    If FileCounter = 0 Then
    Begin
      Writeln('The system cannot find the file specified.');
    end;

    // Print summary
    If DoInfo Then
      Writeln(Format('%8d file(s) printed.',[FileCounter]))
    else
    Begin
      If DoCopy Then
        Writeln(Format('%8d file(s) copied.',[FileCounter]))
      else
        Writeln(Format('%8d file(s) renamed.',[FileCounter]));
    end;
  end;
end.

// EOF
