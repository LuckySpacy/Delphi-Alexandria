unit DB.BasisHistorie;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery, DB.Basis, Data.db,
  c_Historie, DB.Historie2, DB.Historietext;

type
  TGetHistorieTextEvent = procedure (aFieldname: string; var aHistorieText: string; var aEventId: Integer) of object;
  TDBBasisHistorie = class(TDBBasis)
  private
    fOnGetHistorieText: TGetHistorieTextEvent;
    fOnGetAfterHistorieText: TGetHistorieTextEvent;
  protected
    fHistorie2    : TDBHistorie2;
    fHistorietext : TDBHistorietext;
    procedure AfterSqlExec(Sender: TObject);
    property OnGetHistorieText: TGetHistorieTextEvent read fOnGetHistorieText write fOnGetHistorieText;
    property OnGetAfterHistorieText: TGetHistorieTextEvent read fOnGetAfterHistorieText write fOnGetAfterHistorieText;
    function getTableId: Integer; virtual; abstract;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
  end;

implementation

{ TDBBasisHistorie }

//uses
//  o_Mitarbeiter;


constructor TDBBasisHistorie.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fHistorie2    := TDBHistorie2.Create(nil);
  fHistorietext := TDBHistorietext.Create(nil);
  OnAfterExecSql := AfterSqlExec;
end;

destructor TDBBasisHistorie.Destroy;
begin
  FreeAndNil(fHistorie2);
  FreeAndNil(fHistorietext);
  inherited;
end;

procedure TDBBasisHistorie.Init;
begin
  inherited;

end;


procedure TDBBasisHistorie.AfterSqlExec(Sender: TObject);
var
  HistorieText: string;
  EventId: Integer;
  i1: Integer;
begin
  if not Assigned(fOnGetHistorieText) then
    exit;

  fHistorie2.Trans    := Trans;
  fHistorietext.Trans := Trans;
  fHistorie2.Init;
  fHistorietext.Init;

  if (fNeu) or (fGeloescht) then
  begin

    if fNeu then
      EventId := fHistorie2.HistorieEvent.Angelegt
    else
      EventId := fHistorie2.HistorieEvent.Geloescht;

    fOnGetHistorieText('', HistorieText, EventId);
    //fHistorietext.MA_ID    := LoginMA.getId;
    fHistorietext.MA_ID    := 0;
    fHistorietext.Event_ID := EventId;
    fHistorietext.Info     := Historietext;
    fHistorietext.SaveToDB;
    fHistorie2.HT_ID := fHistorietext.Id;
    fHistorie2.Fremd_ID := fId;
    fHistorie2.TabelleId := getTableId;
    fHistorie2.SaveToDB;
    if Assigned(fOnGetAfterHistorieText) then
      fOnGetAfterHistorieText('', HistorieText, EventId);
    //exit;
  end;


  for i1 := 0 to fFeldList.Count -1 do
  begin
    if  ((fFeldList.Feld[i1].Changed)
    and (fFeldList.Feld[i1].AsString <> fFeldListHis.FieldByName(fFeldList.Feld[i1].Feldname).AsString))
    or  ((fNeu) and (Trim(fFeldList.Feld[i1].AsString) > '')) then
    begin
      HistorieText := '';
      EventId      := -1;
      fOnGetHistorieText(fFeldList.Feld[i1].Feldname, HistorieText, EventId);
      if (HistorieText = '') and (EventId = -1) then
        continue;
       fHistorie2.Init;
      fHistorietext.Init;
      fHistorietext.MA_ID    := 0;
      //fHistorietext.MA_ID    := LoginMA.getId;
      fHistorietext.Event_ID := EventId;
      fHistorietext.Info     := Historietext;
      fHistorietext.SaveToDB;
      fHistorie2.HT_ID := fHistorietext.Id;
      fHistorie2.Fremd_ID := Id;
      fHistorie2.TabelleId := getTableId;
      fHistorie2.SaveToDB;
      if Assigned(fOnGetAfterHistorieText) then
        fOnGetAfterHistorieText(fFeldList.Feld[i1].Feldname, HistorieText, EventId);
    end;
  end;
end;


end.
