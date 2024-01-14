unit Datenmodul.Database;

interface

uses
  System.SysUtils, System.Classes, Data.DB, IBX.IBCustomDataSet, IBX.IBQuery,
  IBX.IBDatabase, Objekt.IniDB, db.TBTransaction;

type
  Tdm = class(TDataModule)
    IB_Token: TIBDatabase;
    IBTrans_Token: TIBTransaction;
    qry_Token: TIBQuery;
    IB_Energieverbrauch: TIBDatabase;
    IBTrans_Energieverbrauch: TIBTransaction;
    qry_Energieverbrauch: TIBQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    fTrans_Token: TTBTransaction;
    fTrans_Energieverbrauch: TTBTransaction;
  public
    function CheckConnetion_Token: Boolean;
    function CheckConnetion_Energieverbrauch: Boolean;
    function CheckConnection(aIBDatabase: TIBDatabase; aIniDB: TIniDB; aErrorMsg: string): Boolean;
    property Trans_Token: TTBTransaction read fTrans_Token write fTrans_Token;
    property Trans_Energieverbrauch: TTBTransaction read fTrans_Energieverbrauch write fTrans_Energieverbrauch;
  end;

var
  dm: Tdm;

implementation

uses
  Objekt.Webservice, Dialogs, System.UITypes;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ Tdm }


procedure Tdm.DataModuleCreate(Sender: TObject);
begin
  fTrans_Token := TTBTransaction.Create(Self);
  fTrans_Token.DefaultDatabase := IB_Token;
  fTrans_Energieverbrauch := TTBTransaction.Create(Self);
  fTrans_Energieverbrauch.DefaultDatabase := IB_Energieverbrauch;
end;

procedure Tdm.DataModuleDestroy(Sender: TObject);
begin
  FreeAndNil(fTrans_Token);
  FreeAndNil(fTrans_Energieverbrauch);
end;


function Tdm.CheckConnetion_Energieverbrauch: Boolean;
begin
  Result := CheckConnection(IB_Energieverbrauch, Webservice.Ini.Datenbanken.Energieverbrauch, 'Fehler beim Verbinden von Energieverbrauch');
end;

function Tdm.CheckConnetion_Token: Boolean;
begin
  Result := CheckConnection(IB_Token, Webservice.Ini.Datenbanken.Token, 'Fehler beim Verbinden von Token');
end;


function Tdm.CheckConnection(aIBDatabase: TIBDatabase; aIniDB: TIniDB; aErrorMsg: string): Boolean;
begin
  Result := true;
  if not aIniDB.Aktiv then
    exit;
  aIBDatabase.Close;
  aIBDatabase.DatabaseName := aIniDB.Host + ':' + IncludeTrailingPathDelimiter(aIniDB.Pfad) + aIniDB.DatenbankName;
  aIBDatabase.Params.Add('user_name=sysdba');
  aIBDatabase.Params.Add('password=masterkey');
  //ib.Params.Add('CharacterSet=utf8');
  //ib.Params.Add('default character set UTF8');
  aIBDatabase.Params.Add('lc_ctype=UTF8');
  try
    aIBDatabase.Open;
    Result := aIBDatabase.Connected;
  except
    on e: Exception do
    begin
      Result := false;
      MessageDlg('Fehler beim Verbinden von Token', mtError, [mbOk], 0);
      MessageDlg(E.Message, mtError, [mbOk], 0);
    end;
  end;
end;


end.
