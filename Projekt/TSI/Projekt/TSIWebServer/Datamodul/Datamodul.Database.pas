unit Datamodul.Database;

interface

uses
  System.SysUtils, System.Classes, IBX.IBDatabase, Data.DB, Objekt.IBConnectData;

type
  Tdm = class(TDataModule)
    IB_TSI: TIBDatabase;
    IBT_TSI: TIBTransaction;
    IB_Kurse: TIBDatabase;
    IBT_Kurse: TIBTransaction;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    fTSIConnectData: TIBConnectData;
    fKurseConnectData: TIBConnectData;
  public
    property TSIConnectData: TIBConnectData read fTSIConnectData write fTSIConnectData;
    property KurseConnectData: TIBConnectData read fKurseConnectData write fKurseConnectData;
    function ConnectTSI: Boolean;
    function ConnectKurse: Boolean;
  end;

var
  dm: Tdm;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses
  Dialogs, system.UITypes;



procedure Tdm.DataModuleCreate(Sender: TObject);
begin  //
  fTSIConnectData   := TIBConnectData.create;
  fKurseConnectData := TIBConnectData.create;
end;

procedure Tdm.DataModuleDestroy(Sender: TObject);
begin  //
  FreeAndNil(fTSIConnectData);
  FreeAndNil(fKurseConnectData);
end;


function Tdm.ConnectKurse: Boolean;
begin
  Result := false;
  IB_Kurse.Databasename := Trim(fKurseConnectData.Host) +':' +
                               Trim(IncludeTrailingPathDelimiter(fKurseConnectData.Datenbankpfad)) +
                               Trim(fKurseConnectData.Datenbankname);
  IB_Kurse.Params.Clear;
  IB_Kurse.Params.Add('user_name=' + fKurseConnectData.Username);
  IB_Kurse.Params.Add('password=' + fKurseConnectData.Passwort);
  //dm.IB_Rezept.Params.Add('default character set UTF8');
  IB_Kurse.Params.Add('lc_ctype=UTF8');

  IB_Kurse.LoginPrompt := false;
  try
    if IB_Kurse.Connected then
      IB_Kurse.Close;
    IB_Kurse.Open;
  except
    on E: Exception do
    begin
      MessageDlg(e.Message, TMsgDlgType.mtError, [mbOk], 0);
      MessageDlg('Verbindung zur Datenbank "Kurse" fehlgeschlagen', TMsgDlgType.mtError, [mbOk], 0);
      exit;
    end;
  end;
  Result := true;
end;

function Tdm.ConnectTSI: Boolean;
begin
  Result := false;
  IB_TSI.Databasename := Trim(fTSIConnectData.Host) +':' +
                               Trim(IncludeTrailingPathDelimiter(fTSIConnectData.Datenbankpfad)) +
                               Trim(fTSIConnectData.Datenbankname);
  IB_TSI.Params.Clear;
  IB_TSI.Params.Add('user_name=' + fTSIConnectData.Username);
  IB_TSI.Params.Add('password=' + fTSIConnectData.Passwort);
  //dm.IB_Rezept.Params.Add('default character set UTF8');
  IB_TSI.Params.Add('lc_ctype=UTF8');

  IB_TSI.LoginPrompt := false;
  try
    if IB_TSI.Connected then
      IB_TSI.Close;
    IB_TSI.Open;
  except
    on E: Exception do
    begin
      MessageDlg(e.Message, TMsgDlgType.mtError, [mbOk], 0);
      MessageDlg('Verbindung zur Datenbank "TSI" fehlgeschlagen', TMsgDlgType.mtError, [mbOk], 0);
      exit;
    end;
  end;
  Result := true;
end;


end.
