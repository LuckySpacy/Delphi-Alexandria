unit Objekt.JEnergieverbrauch;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, FMX.Graphics,
  Communication.API;


type
  TJEnergieverbrauch = class
  private
    fCommunicationAPI: TCommunicationAPI;
    fToken: string;
  protected
  public
    constructor Create;
    destructor Destroy; override;
    function ReadZaehlerList: string;
    function AddZaehler(aJsonString: string): string;
    function DeleteZaehler(aJsonString: string): string;
    function AddZaehlerstand(aJsonString: string): string;
    function ReadZaehlerstandListInZeitraum(aJsonString: string): string;
    function DeleteZaehlerstand(aJsonString: string): string;
    property Token: string read fToken write fToken;
    function ReadVerbrauchMonatListImJahr(aJsonString: string): string;
    function ZaehlerverbrauchNeuBerechnen(aJsonString: string): string;
  end;

var
  JEnergieverbrauch: TJEnergieverbrauch;

implementation

{ TJEnergieverbrauch }



constructor TJEnergieverbrauch.Create;
begin
//  fCommunicationAPI := TCommunicationAPI.Create;
  fToken := '';
end;


destructor TJEnergieverbrauch.Destroy;
begin
  FreeAndNil(fCommunicationAPI);
  inherited;
end;

function TJEnergieverbrauch.ReadVerbrauchMonatListImJahr(aJsonString: string): string;
var
  API: TCommunicationAPI;
begin
  API := TCommunicationAPI.Create(fToken);
  try
    API.Post('/Verbrauch/Monate', aJsonString);
    Result := API.ReturnValue;
  finally
    FreeAndNil(API);
  end;
end;

function TJEnergieverbrauch.ReadZaehlerList: string;
var
  API: TCommunicationAPI;
begin
  API := TCommunicationAPI.Create(fToken);
  try
    API.Get('/Zaehler/ReadAll', '');
    if API.ErrorList.Count > 0 then
      Result := API.ErrorList.JsonString
    else
      Result := API.ReturnValue;
  finally
    FreeAndNil(API);
  end;
end;


function TJEnergieverbrauch.AddZaehler(aJsonString: string): string;
var
  API: TCommunicationAPI;
begin
  API := TCommunicationAPI.Create(fToken);
  try
    API.Post('/Zaehler/Update', aJsonString);
    Result := API.ReturnValue;
  finally
    FreeAndNil(API);
  end;
end;

function TJEnergieverbrauch.DeleteZaehler(aJsonString: string): string;
var
  API: TCommunicationAPI;
begin
  API := TCommunicationAPI.Create(fToken);
  try
    API.delete('/Zaehler/Update', aJsonString);
    Result := API.ReturnValue;
  finally
    FreeAndNil(API);
  end;
end;


function TJEnergieverbrauch.AddZaehlerstand(aJsonString: string): string;
var
  API: TCommunicationAPI;
begin
  API := TCommunicationAPI.Create(fToken);
  try
    API.Post('/Zaehlerstand/Update', aJsonString);
    Result := API.ReturnValue;
  finally
    FreeAndNil(API);
  end;
end;


function TJEnergieverbrauch.ReadZaehlerstandListInZeitraum(aJsonString: string): string;
var
  API: TCommunicationAPI;
begin
  API := TCommunicationAPI.Create(fToken);
  try
    API.Post('/Zaehlerstand/ReadZeitraum', aJsonString);
    Result := API.ReturnValue;
  finally
    FreeAndNil(API);
  end;
end;

function TJEnergieverbrauch.DeleteZaehlerstand(aJsonString: string): string;
var
  API: TCommunicationAPI;
begin
  API := TCommunicationAPI.Create(fToken);
  try
    API.delete('/Zaehlerstand/Delete', aJsonString);
    Result := API.ReturnValue;
  finally
    FreeAndNil(API);
  end;
end;


function TJEnergieverbrauch.ZaehlerverbrauchNeuBerechnen(aJsonString: string): string;
var
  API: TCommunicationAPI;
begin
  API := TCommunicationAPI.Create(fToken);
  try
    API.Post('/Verbrauch/KomplNeuBerechnen', aJsonString);
    Result := API.ReturnValue;
  finally
    FreeAndNil(API);
  end;
end;



end.
