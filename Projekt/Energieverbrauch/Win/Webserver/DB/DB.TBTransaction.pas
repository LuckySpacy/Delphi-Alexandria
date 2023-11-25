unit DB.TBTransaction;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery, IBX.ib;

type
  TTBTransaction = class(TIBTransaction)
  private
  protected
    fAnzOpenTrans: Integer;
  public
    procedure OpenTrans;
    procedure CommitTrans;
    procedure RollbackTrans;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;


implementation

{ TTBTransaction }


constructor TTBTransaction.Create(AOwner: TComponent);
begin
  inherited;
  fAnzOpenTrans := 0;
end;

destructor TTBTransaction.Destroy;
begin

  inherited;
end;

procedure TTBTransaction.OpenTrans;
begin
  inc(fAnzOpenTrans);
  if not InTransaction then
    StartTransaction;
end;

procedure TTBTransaction.RollbackTrans;
begin
  if (fAnzOpenTrans = 1) and (InTransaction) then
    Rollback;
  inc(fAnzOpenTrans, -1);

  if  (fAnzOpenTrans < 0) then
  begin
    fAnzOpenTrans := 0;
    if InTransaction then
      Rollback;
  end;

end;

procedure TTBTransaction.CommitTrans;
begin
  if (fAnzOpenTrans = 1) and (InTransaction) then
    commit;
  inc(fAnzOpenTrans, -1);

  if  (fAnzOpenTrans < 0) then
  begin
    fAnzOpenTrans := 0;
    if InTransaction then
      commit;
  end;
end;


end.
