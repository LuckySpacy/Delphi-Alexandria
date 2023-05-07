unit Form.Base;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs;

type
  Tfrm_Base = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    fOnBack: TNotifyEvent;
    fId: string;
  protected
    procedure GoBack(Sender: TObject);
  public
    procedure setActiv; virtual; abstract;
    property OnBack: TNotifyEvent read fOnBack write fOnBack;
    property Id: string read fId;
    function ErzeugeGuid: string;
  end;

var
  frm_Base: Tfrm_Base;

implementation

{$R *.fmx}

{ Tfrm_Base }

procedure Tfrm_Base.FormCreate(Sender: TObject);
begin
  fId := ErzeugeGuid;
end;

procedure Tfrm_Base.GoBack(Sender: TObject);
begin
  if Assigned(fOnBack) then
    fOnBack(Self);
end;

function Tfrm_Base.ErzeugeGuid: string;
var
  GuId: TGUid;
begin //
  CreateGUID(GuId);
  Result := GUIDToString(GuId);
  Result := StringReplace(Result , '{', '', [rfReplaceAll]);
  Result := StringReplace(Result , '}', '', [rfReplaceAll]);
end;

end.

