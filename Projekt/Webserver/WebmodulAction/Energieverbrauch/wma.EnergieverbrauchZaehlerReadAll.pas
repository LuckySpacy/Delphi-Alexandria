unit wma.EnergieverbrauchZaehlerReadAll;

interface

uses
  System.SysUtils, System.Variants, System.Classes, wma.Base, Web.HTTPApp,
  c.JsonError, Json.EnergieverbrauchZaehler, Json.EnergieverbrauchZaehlerList,
  DB.EnergieverbrauchZaehlerList;

type
  TwmaEnergieverbrauchZaehlerReadAll = class(TwmaBase)
  private
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure DoIt(aRequest: TWebRequest; aResponse: TWebResponse); override;
  end;

implementation

{ TwmaEnergieverbrauchZaehlerReadAll }

uses
  Datenmodul.Database;

constructor TwmaEnergieverbrauchZaehlerReadAll.Create;
begin
  inherited;

end;

destructor TwmaEnergieverbrauchZaehlerReadAll.Destroy;
begin

  inherited;
end;

procedure TwmaEnergieverbrauchZaehlerReadAll.DoIt(aRequest: TWebRequest; aResponse: TWebResponse);
var
  DBZaehlerList : TDBEnergieverbrauchZaehlerlist;
  JZaehlerList  : TJEnergieverbrauchZaehlerList;
  JZaehler: TJEnergieverbrauchZaehler;
  i1: Integer;
begin
  inherited;
  if JErrorList.Count > 0 then
  begin
    aResponse.Content := JErrorList.JsonString;
    exit;
  end;
  try
    DBZaehlerList := TDBEnergieverbrauchZaehlerlist.Create;
    JZaehlerList  := TJEnergieverbrauchZaehlerList.Create;
    try
      DBZaehlerList.Trans := dm.Trans_Energieverbrauch;
      if aRequest.Content = '' then
      begin
        DBZaehlerList.ReadAll;
      end
      else
      begin
        JZaehler := TJEnergieverbrauchZaehler.Create;
        try
          JZaehler.JsonString := aRequest.Content;
           DBZaehlerList.ReadbyId(JZaehler.FieldByName('ZA_ID').AsInteger);
        finally
          FreeAndNil(JZaehler);
        end;
      end;

      for i1 := 0 to DBZaehlerList.Count -1 do
      begin
        JZaehler := JZaehlerList.Add;
        DBZaehlerList.Item[i1].LoadToJsonObjekt(JZaehler);
      end;
      aResponse.Content := JZaehlerList.JsonString;
    finally
      FreeAndNil(DBZaehlerList);
      FreeAndNil(JErrorList);
      FreeAndNil(JZaehlerList);
    end;
  except
    on E: Exception do
    begin
      JErrorList.setError('TwmaEnergieverbrauchZaehlerReadAll -> ' +  E.Message, '99');
    end;
  end;
end;

end.
