unit DB.TBQuery;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery, IBX.ib, db.TBTransaction, db;

type
  TTBQuery = class(TIBQuery)
  private
    fTrans: TTBTransaction;
    procedure setTrans(const Value: TTBTransaction);
  protected
  public
    procedure OpenTrans;
    procedure CommitTrans;
    procedure RollbackTrans;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Trans: TTBTransaction read fTrans write setTrans;
    procedure LoadFromStream(aStream: TMemoryStream; aBlob: TBlobField);
  end;

implementation

{ TTBQuery }


constructor TTBQuery.Create(AOwner: TComponent);
begin
  inherited;
  fTrans := nil;
end;

destructor TTBQuery.Destroy;
begin

  inherited;
end;


{
Procedure LoadBitmapFromBlob(Bitmap: TBitmap; Blob: TBlobField);
var
  ms, ms2: TMemoryStream;
begin
  ms := TMemoryStream.Create;
  try
    Blob.SaveToStream(ms);
    ms.Position := 0;
    Bitmap.LoadFromStream(ms);
  finally
    ms.Free;
  end;
end;
}

procedure TTBQuery.LoadFromStream(aStream: TMemoryStream; aBlob: TBlobField);
begin
  aStream.Clear;
  aStream.Position := 0;
  aBlob.SaveToStream(aStream);
  aStream.Position := 0;
end;

procedure TTBQuery.OpenTrans;
begin
  if fTrans <> nil then
    fTrans.OpenTrans;
end;

procedure TTBQuery.RollbackTrans;
begin
  if fTrans <> nil then
    fTrans.RollbackTrans;
end;

procedure TTBQuery.setTrans(const Value: TTBTransaction);
begin
  fTrans := Value;
  Transaction := TIBTransaction(fTrans);
end;

procedure TTBQuery.CommitTrans;
begin
  if fTrans <> nil then
    fTrans.CommitTrans;
end;


end.
