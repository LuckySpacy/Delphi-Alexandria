unit DB.Basis;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet;

type
  TProgressInfoEvent = procedure(aInfo: string; aIndex, aCount: Integer) of object;
  TDBBasis = class
  private
    fOnProgressInfo: TProgressInfoEvent;
  protected
    fQuery: TFDQuery;
    procedure ProgressInfo(aInfo: string; aIndex, aCount: Integer);
  public
    constructor Create; virtual;
    destructor Destroy; override;
    property OnProgressInfo: TProgressInfoEvent read fOnProgressInfo write fOnProgressInfo;
  end;


implementation

{ TDBBasis }

uses
  Datenmodul.db;

constructor TDBBasis.Create;
begin
  fQuery := TFDQuery.Create(nil);
  fQuery.Connection := dm_db.Connection;
end;

destructor TDBBasis.Destroy;
begin
  FreeAndNil(fQuery);
  inherited;
end;

procedure TDBBasis.ProgressInfo(aInfo: string; aIndex, aCount: Integer);
begin
  if Assigned(fOnProgressInfo) then
    fOnProgressInfo(aInfo, aIndex, aCount);
end;

end.
