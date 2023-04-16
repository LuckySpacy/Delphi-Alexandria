unit DB.Historietext;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, NFSQuery, DB.Basis, Data.db;

type
  TDBHistorietext = class(TDBBasis)
  private
    fMA_ID: Integer;
    fInfo: string;
    fDatum: TDateTime;
    fEvent_ID: Integer;
    fTimeStamp: string;
    procedure setDatum(const Value: TDateTime);
    procedure setEvent_ID(const Value: Integer);
    procedure setInfo(const Value: string);
    procedure setMA_ID(const Value: Integer);
  protected
    function getGeneratorName: string; override;
    function getTableName: string; override;
    function getTablePrefix: string; override;
    procedure FuelleDBFelder; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure LoadByQuery(aQuery: TNFSQuery); override;
    procedure SaveToDB; override;
    property Datum: TDateTime read fDatum write setDatum;
    property TimeStamp: string read fTimeStamp;
    property MA_ID: Integer read fMA_ID write setMA_ID;
    property Event_ID: Integer read fEvent_ID write setEvent_ID;
    property Info: string read fInfo write setInfo;
  end;

var
  Historietext: TDBHistorietext;

implementation

{ TDBHistorietext }

uses
  Vcl.Dialogs;

constructor TDBHistorietext.Create(AOwner: TComponent);
begin
  inherited;
  FFeldList.Add('HT_DATUM', ftDateTime);
  FFeldList.Add('HT_MA_ID', ftInteger);
  FFeldList.Add('HT_EVENT_ID', ftInteger);
  FFeldList.Add('HT_INFO', ftString);
  FFeldList.Add('HT_TIMESTAMP', ftString);
  Init;
end;

destructor TDBHistorietext.Destroy;
begin

  inherited;
end;

procedure TDBHistorietext.Init;
begin
  inherited;
  fMA_ID    := 0;
  fInfo     := '';
  fDatum    := 0;
  fEvent_ID := 0;
  fTimeStamp := '';
end;

function TDBHistorietext.getGeneratorName: string;
begin
  Result := 'HT_ID';
end;

function TDBHistorietext.getTableName: string;
begin
  Result := 'HISTORIETEXT';
end;

function TDBHistorietext.getTablePrefix: string;
begin
  Result := 'HT';
end;


procedure TDBHistorietext.FuelleDBFelder;
begin
  fFeldList.FieldByName('HT_ID').AsInteger        := fID;
  fFeldList.FieldByName('HT_DATUM').AsDateTime    := fDatum;
  fFeldList.FieldByName('HT_EVENT_ID').AsDateTime := fEvent_Id;
  fFeldList.FieldByName('HT_INFO').AsString       := fInfo;
  fFeldList.FieldByName('HT_MA_ID').AsInteger     := fMA_ID;
  fFeldList.FieldByName('HT_TIMESTAMP').AsString  := fTimeStamp;
  inherited;
end;



procedure TDBHistorietext.LoadByQuery(aQuery: TNFSQuery);
begin
  inherited;
  if aQuery.Eof then
    exit;
  fDatum     := aQuery.FieldByName('HT_DATUM').AsDateTime;
  fEvent_ID  := aQuery.FieldByName('HT_EVENT_ID').AsInteger;
  fInfo      := aQuery.FieldByName('HT_INFO').AsString;
  fMA_ID     := aQuery.FieldByName('HT_MA_ID').AsInteger;
  fTimeStamp := aQuery.FieldByName('HT_TIMESTAMP').AsString;
  FuelleDBFelder;
end;

procedure TDBHistorietext.SaveToDB;
begin
  setDatum(now);
  fTimeStamp := FormatDateTime('yyyymmddhhnnsszzz', fDatum);
  fFeldList.FieldByName('HT_TIMESTAMP').AsString := fTimeStamp;
  inherited;

end;

procedure TDBHistorietext.setDatum(const Value: TDateTime);
begin
  //fDatum := Value;
  UpdateV(fDatum, Value);
  fFeldList.FieldByName('HT_DATUM').AsDateTime := fDatum;
end;

procedure TDBHistorietext.setEvent_ID(const Value: Integer);
begin
  //fEvent_ID := Value;
  UpdateV(fEvent_ID, Value);
  fFeldList.FieldByName('HT_EVENT_ID').AsInteger := fEvent_ID;
end;

procedure TDBHistorietext.setInfo(const Value: string);
begin
  //fInfo := Value;
  UpdateV(fInfo, Value);
  fFeldList.FieldByName('HT_INFO').AsString := fInfo;
end;

procedure TDBHistorietext.setMA_ID(const Value: Integer);
begin
  UpdateV(fMA_ID, Value);
  //fMA_ID := Value;
  fFeldList.FieldByName('HT_MA_ID').AsInteger := fMA_ID;
end;


initialization
  Historietext := nil;

finalization
 if Historietext <> nil then
   FreeAndNil(Historietext);

end.
