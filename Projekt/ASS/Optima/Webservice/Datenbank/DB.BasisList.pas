unit DB.BasisList;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, Objekt.BasisList, NFSQuery;

type
  TDBBasisList = class(TBaseList)
  private
  protected
    fTrans: TIBTransaction;
    fQuery: TNFSQuery;
    fWasOpen: Boolean;
    procedure OpenTrans;
    procedure CommitTrans;
    procedure RollbackTrans;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Trans: TIBTransaction read fTrans write fTrans;
  end;


implementation

{ TDBBasisList }

constructor TDBBasisList.Create(AOwner: TComponent);
begin
  inherited;
  fTrans := nil;
  fQuery := TNFSQuery.Create(nil);
end;

destructor TDBBasisList.Destroy;
begin
  FreeAndNil(fQuery);
  inherited;
end;


procedure TDBBasisList.OpenTrans;
begin
  fWasOpen := fTrans.InTransaction;
  if not fTrans.InTransaction then
    fTrans.StartTransaction;
end;


procedure TDBBasisList.CommitTrans;
begin
  if (not fTrans.InTransaction) or (fWasOpen) then
    exit;
  fTrans.Commit;
  fWasOpen := false;
end;



procedure TDBBasisList.RollbackTrans;
begin
  if (not fTrans.InTransaction) or (fWasOpen) then
    exit;
  fTrans.Rollback;
  fWasOpen := false;
end;




end.
