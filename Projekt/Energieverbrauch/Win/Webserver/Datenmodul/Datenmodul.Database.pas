unit Datenmodul.Database;

interface

uses
  System.SysUtils, System.Classes, Data.DB, IBX.IBDatabase, IBX.IBCustomDataSet,
  IBX.IBQuery;

type
  Tdm = class(TDataModule)
    IB: TIBDatabase;
    IBTrans: TIBTransaction;
    qry: TIBQuery;
  private
    fDatenbankname: string;
    fHost: string;
    fPfad: string;
  public
    property Host: string read fHost write fHost;
    property Datenbankname: string read fDatenbankname write fDatenbankname;
    property Pfad: string read fPfad write fPfad;
    function ConnectDB: Boolean;
  end;

var
  dm: Tdm;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ Tdm }

uses
  Dialogs, System.UITypes;

function Tdm.ConnectDB: Boolean;
begin
  IB.Close;
  ib.DatabaseName := fHost + ':' + IncludeTrailingPathDelimiter(fPfad) + fDatenbankname;
  ib.Params.Add('user_name=sysdba');
  ib.Params.Add('password=masterkey');
  //ib.Params.Add('CharacterSet=utf8');
  //ib.Params.Add('default character set UTF8');
  ib.Params.Add('lc_ctype=UTF8');
  try
    ib.Open;
    Result := ib.Connected;
  except
    on e: Exception do
    begin
      Result := false;
      MessageDlg(E.Message, mtError, [mbOk], 0);
    end;
  end;
end;

end.
