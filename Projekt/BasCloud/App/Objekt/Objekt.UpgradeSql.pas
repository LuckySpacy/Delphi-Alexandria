unit Objekt.UpgradeSql;

interface

uses
  System.SysUtils, System.Classes;

type
  TUpgradeSql = class
  private
    fDatum: string;
    fSql: string;
  protected
  public
    constructor Create;
    destructor Destroy; override;
    property Datum: string read fDatum write fDatum;
    property Sql: string read fSql write fSql;
  end;


implementation

{ TUpgradeSql }

constructor TUpgradeSql.Create;
begin

end;

destructor TUpgradeSql.Destroy;
begin

  inherited;
end;

end.
