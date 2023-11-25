unit Objekt.DBSchnittstelle;

interface

uses
  System.SysUtils, System.JSON, DB.Zaehler, JObjekt.Zaehler, db.TBTransaction;

type
  TDBSchnittstelle = class
  private
  protected
  public
    constructor Create;
    destructor Destroy; override;
    function PatchZaehler(aJObjZaehler: TJObjZaehler): Boolean;
  end;

implementation

{ TDBSchnittstelle }

uses
  Datenmodul.Database, Data.DB, IBX.IBDatabase;

constructor TDBSchnittstelle.Create;
begin//
end;

destructor TDBSchnittstelle.Destroy;
begin

  inherited;
end;

function TDBSchnittstelle.PatchZaehler(aJObjZaehler: TJObjZaehler): Boolean;
var
  DBZaehler: TDBZaehler;
  IBTrans: TTBTransaction;
begin
  IBTrans   := TTBTransaction.Create(nil);
  DBZaehler := TDBZaehler.Create(nil);
  try
    IBTrans.DefaultDatabase := dm.IB;
    DBZaehler.Trans := IBTrans;
    DBZaehler.Patch(aJObjZaehler);
    //DBZaehler.SaveToDB;
  finally
    FreeAndNil(DBZaehler);
    FreeAndNil(IBTrans);
  end;

end;

end.
