unit View.Base;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, Objekt.DBFeldList, Data.db, IBX.IBQuery;

type
  TVWBasis = class
  private
    procedure setTrans(const Value: TIBTransaction);
  protected
    fTrans: TIBTransaction;
    fQuery: TIBQuery;
    fFeldList: TDBFeldList;
    fGefunden: Boolean;
    fWasOpen: Boolean;
    //fTransCounter: Integer;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Init; virtual;
    procedure OpenTrans;
    procedure CommitTrans;
    procedure RollbackTrans;
    procedure LoadByQuery(aQuery: TIBQuery); virtual;
    property Trans: TIBTransaction read fTrans write setTrans;
    property FeldList: TDBFeldList read fFeldList write fFeldList;
    property Gefunden: Boolean read fGefunden;
  end;

implementation

{ TVWBasis }

constructor TVWBasis.Create;
begin
  fTrans := nil;
  fQuery := TIBQuery.Create(nil);
  fFeldList := TDBFeldList.Create;
end;

destructor TVWBasis.Destroy;
begin
  FreeAndNil(fQuery);
  FreeAndNil(fFeldList);
  inherited;
end;




procedure TVWBasis.Init;
begin

end;

procedure TVWBasis.LoadByQuery(aQuery: TIBQuery);
var
  i1: Integer;
  FeldName: string;
begin
  inherited;
  for i1 := 0 to fFeldList.Count -1 do
  begin
    FeldName := fFeldList.Feld[i1].Feldname;
    if aQuery.FieldByName(FeldName) <> nil then
      fFeldList.Feld[i1].AsString := aQuery.FieldByName(FeldName).AsString;
  end;
end;

procedure TVWBasis.OpenTrans;
begin
  fWasOpen := fTrans.InTransaction;
  if not fTrans.InTransaction then
    fTrans.StartTransaction;
end;

procedure TVWBasis.CommitTrans;
begin
  if (not fWasOpen) and (fTrans.InTransaction) then
    fTrans.Commit;
end;


procedure TVWBasis.RollbackTrans;
begin
  if (not fWasOpen) and (fTrans.InTransaction) then
    fTrans.Commit;
end;


procedure TVWBasis.setTrans(const Value: TIBTransaction);
begin
  fTrans := Value;
end;

end.
