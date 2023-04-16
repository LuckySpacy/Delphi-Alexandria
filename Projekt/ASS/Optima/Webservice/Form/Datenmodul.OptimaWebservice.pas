unit Datenmodul.OptimaWebservice;

interface

uses
  System.SysUtils, System.Classes, IBX.IBDatabase, Data.DB, DB.Sprachen;

type
  Tdm = class(TDataModule)
    IBD_Optima: TIBDatabase;
    IBT_Optima: TIBTransaction;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    fDBSprachen: TDBSprachen;
    fSpId: Integer;
  public
    function ConnectOptima: Boolean;
    property SpId: Integer read fSpId;
  end;

var
  dm: Tdm;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses
  Objekt.IBDIni, Objekt.OptimaWebservice, system.IOUtils, FMX.DialogService;

{ Tdm }


procedure Tdm.DataModuleCreate(Sender: TObject);
begin
  fDBSprachen := TDBSprachen.Create(nil);
  fSpId := 0;
end;

procedure Tdm.DataModuleDestroy(Sender: TObject);
begin
  FreeAndNil(fDBSprachen);
end;


function Tdm.ConnectOptima: Boolean;
var
  IBDIni: TIBDIni;
  FullFilename: string;
begin
  if IBD_Optima.Connected then
  begin
    Result := true;
    exit;
  end;

  Result := false;
  IBDIni := ows.IBDIniList.getByName('Optima');
  if not TDirectory.Exists(IBDIni.Pfad) then
  begin
    TDialogService.ShowMessage('Datenbankpfad existiert nicht:' + sLineBreak + IBDIni.Pfad);
    exit;
  end;
  FullFilename := TPath.Combine(IBDIni.Pfad, IBDIni.Datenbankname);
  if not TFile.Exists(FullFilename) then
  begin
    TDialogService.ShowMessage('Datenbank existiert nicht:' + sLineBreak + FullFilename);
    exit;
  end;
  IBD_Optima.DatabaseName := IBDIni.Host + ':' + FullFilename;
  IBD_Optima.Params.Clear;
  IBD_Optima.Params.Add('user_name=sysdba');
  IBD_Optima.Params.Add('password=masterkey');
  IBD_Optima.Connected := true;
  Result := IBD_Optima.Connected;
  if Result then
  begin
    fDBSprachen.Trans := IBT_Optima;
    fDBSprachen.Read_Std;
    fSpId := fDBSprachen.id;
  end;
end;


end.
