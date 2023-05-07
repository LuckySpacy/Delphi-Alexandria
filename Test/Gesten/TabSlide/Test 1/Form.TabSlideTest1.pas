unit Form.TabSlideTest1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.TabControl, FMX.Gestures, System.Actions,
  FMX.ActnList, FMX.Objects;

type
  TForm3 = class(TForm)
    ToolBar1: TToolBar;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    btn_1: TButton;
    Button4: TButton;
    GestureManager1: TGestureManager;
    ActionList1: TActionList;
    Image1: TImage;
    procedure TabControl1Gesture(Sender: TObject;
      const EventInfo: TGestureEventInfo; var Handled: Boolean);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form3: TForm3;

implementation

{$R *.fmx}

procedure TForm3.TabControl1Gesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
begin
  case EventInfo.GestureID of
    sgiLeft:
      begin
        //if NextTabAction.Enabled then
          TabControl1.Next;
        Handled := True;
      end;
    sgiRight:
      begin
        TabControl1.Previous;
        Handled := True;
      end;
  end;
end;

end.
