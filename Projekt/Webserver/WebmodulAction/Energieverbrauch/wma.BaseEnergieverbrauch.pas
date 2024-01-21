unit wma.BaseEnergieverbrauch;

interface

uses
  System.SysUtils, System.Variants, System.Classes, Json.ErrorList, Web.HTTPApp,
  Objekt.AccessPermission, c.JsonError, db.TBTransaction, wma.Base;
type
  TwmaBaseEnergieverbrauch = class(TwmaBase)
  private
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
  end;

implementation

{ TwmaBaseEnergieverbrauch }
uses
  Datenmodul.Database;

constructor TwmaBaseEnergieverbrauch.Create;
begin
  inherited;
  fTrans.DefaultDatabase := dm.IB_Energieverbrauch;
end;

destructor TwmaBaseEnergieverbrauch.Destroy;
begin

  inherited;
end;

end.
