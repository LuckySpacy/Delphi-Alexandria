unit DB.BasisList;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, Objekt.BasisList, IBX.IBQuery, IBX.ib,
  db.TBTransaction, DB.TBQuery;

type
  TDBBasisList = class(TBasisList)
  private
  protected
    fTrans: TTBTransaction;
    fQuery: TTBQuery;
  public
    constructor Create; override;
    destructor Destroy; override;
    property Trans: TTBTransaction read fTrans write fTrans;
    procedure Clear; override;
  end;


implementation

{ TDBBasisList }

constructor TDBBasisList.Create;
begin
  inherited;
  fTrans := nil;
  fQuery := TTBQuery.Create(nil);
end;

destructor TDBBasisList.Destroy;
begin
  FreeAndNil(fQuery);
  inherited;
end;



procedure TDBBasisList.Clear;
begin
  fList.Clear;
  inherited;
end;


end.
