unit tbToolRichview;

interface

uses
  SysUtils, Classes, RvStyle, tbToolButton;


  procedure CurTextStyleChanged(Sender: TObject);
  procedure CurParaStyleChanged(Sender: TObject);
  procedure ParaStyleConversion(Sender: TObject;
                  StyleNo, UserData: Integer; AppliedToText: Boolean;
                  var NewStyleNo: Integer);


implementation



// current text style was changed
procedure TTbToolbar.CurTextStyleChanged(Sender: TObject);
var
  fi: TFontInfo;
  btn: TTbToolbutton;
begin
  fi := FRv.Style.TextStyles[FRv.CurTextStyleNo];
  FFontbox.ItemIndex := FFontbox.Items.IndexOf(fi.FontName);
  FPropFontSize.FontSizeBox.Value := fi.Size;

  btn := GetButtonFromTag(Ord(tbBold));
  btn.Down := fsBold in fi.Style;

  btn := GetButtonFromTag(Ord(tbItalic));
  btn.Down := fsItalic in fi.Style;

  btn := GetButtonFromTag(Ord(tbUnderline));
  btn.Down := fsUnderline in fi.Style;
  {
  IgnoreChanges := True;
  StatusBar1.Panels[1].Text := 'Style : '+IntToStr(rve.CurTextStyleNo);
  // Changing selection in comboboxes with font names and sizes:
  fi := rvs.TextStyles[rve.CurTextStyleNo];
  cmbFont.ItemIndex := cmbFont.Items.IndexOf(fi.FontName);
  cmbFontSize.Text := IntToStr(fi.Size);
  // Checking font buttons
  btnBold.Down      := fsBold      in fi.Style;
  btnItalic.Down    := fsItalic    in fi.Style;
  btnUnderline.Down := fsUnderline in fi.Style;
  IgnoreChanges := False;
  }
end;
{------------------------------------------------------------------------------}
// current paragraph style was changed
procedure TTbToolbar.CurParaStyleChanged(Sender: TObject);
begin
  SetAlignmentToUI(FRv.Style.ParaStyles[FRv.CurParaStyleNo].Alignment);
end;

procedure TTbToolbar.SetAlignmentToUI(Alignment: TRVAlignment);
var
  btn: TTbToolbutton;
begin
  case Alignment of
    rvaLeft:
      begin
        btn := GetButtonFromTag(Ord(tbLeft));
        btn.Down := true;
      end;
    rvaCenter:
      begin
        btn := GetButtonFromTag(Ord(tbCenter));
        btn.Down := true;
      end;
    rvaRight:
      begin
        btn := GetButtonFromTag(Ord(tbRight));
        btn.Down := true;
      end;
    rvaJustify:
      begin
        btn := GetButtonFromTag(Ord(tbJustify));
        btn.Down := true;
      end;
  end;
end;

procedure TTbToolbar.ParaStyleConversion(Sender: TObject;
  StyleNo, UserData: Integer; AppliedToText: Boolean;
  var NewStyleNo: Integer);
var ParaInfo: TParaInfo;
begin
  {
  ParaInfo := TParaInfo.Create(nil);
  try
    ParaInfo.Assign(rvs.ParaStyles[StyleNo]);
    case UserData of
      PARA_ALIGNMENT:
        ParaInfo.Alignment := GetAlignmentFromUI;
      PARA_INDENTINC:
        begin
          ParaInfo.LeftIndent := ParaInfo.LeftIndent+20;
          if ParaInfo.LeftIndent>200 then
            ParaInfo.LeftIndent := 200;
        end;
      PARA_INDENTDEC:
        begin
          ParaInfo.LeftIndent := ParaInfo.LeftIndent-20;
          if ParaInfo.LeftIndent<0 then
            ParaInfo.LeftIndent := 0;
        end;
      PARA_COLOR:
        ParaInfo.Background.Color := cd.Color;
      // add your code here....
    end;
    NewStyleNo := rvs.FindParaStyle(ParaInfo);
  finally
    ParaInfo.Free;
  end;
  }
end;


end.
