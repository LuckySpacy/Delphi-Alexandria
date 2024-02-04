unit Objekt.ZaehlerList;

interface

uses
  System.SysUtils, System.Variants, System.Classes, Objekt.BasisList, Json.EnergieverbrauchZaehler,
  Json.ErrorList, Json.BasisList, Json.EnergieverbrauchZaehlerList, Objekt.JEnergieverbrauch;

type
  TZaehlerList = class(TJEnergieverbrauchZaehlerList)
  private
    procedure ShowErrors;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Init;
    procedure LadeListe;
  end;

implementation

{ TZaehlerList }

uses
  fmx.DialogService, system.UITypes, Objekt.Energieverbrauch;

constructor TZaehlerList.Create;
begin
  inherited;

end;

destructor TZaehlerList.Destroy;
begin

  inherited;
end;

procedure TZaehlerList.Init;
begin

end;

procedure TZaehlerList.LadeListe;
var
  lJsonString: String;
  lJEnergieverbrauch: TJEnergieverbrauch;
begin
  Clear;
  lJEnergieverbrauch := TJEnergieverbrauch.Create;
  lJEnergieverbrauch.Token := Energieverbrauch.Token;
  try
    lJsonString := lJEnergieverbrauch.ReadZaehlerList;
    JErrorList.JsonString := lJsonString;
    if JErrorList.Count > 0 then
      ShowErrors
    else
      JsonString := lJsonString;
  finally
    FreeAndNil(lJEnergieverbrauch);
  end;
end;

procedure TZaehlerList.ShowErrors;
var
  i1: Integer;
begin
  for i1 := 0 to fJErrorList.Count -1 do
  begin
    TDialogService.MessageDialog(fJErrorList.Item[i1].FieldByName('Title').AsString, TMsgDlgType.mtError, [TMsgDlgBtn.mbOk], TMsgDlgBtn.mbOK, 0, nil);
  end;
end;

end.
