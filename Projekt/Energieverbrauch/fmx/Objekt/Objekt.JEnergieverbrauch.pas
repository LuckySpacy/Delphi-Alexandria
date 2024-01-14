unit Objekt.JEnergieverbrauch;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, FMX.Graphics,
  Communication.API;


type
  TJEnergieverbrauch = class
  private
    fCommunicationAPI: TCommunicationAPI;
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
  end;

var
  JEnergieverbrauch: TJEnergieverbrauch;

implementation

{ TJEnergieverbrauch }



constructor TJEnergieverbrauch.Create;
begin
  fCommunicationAPI := TCommunicationAPI.Create;

end;


destructor TJEnergieverbrauch.Destroy;
begin
  FreeAndNil(fCommunicationAPI);
  inherited;
end;

function TJEnergieverbrauch.ReadZaehlerList: string;
var
  API: TCommunicationAPI;
begin
  API := TCommunicationAPI.Create;
  try
    API.Get('/Zaehler/Read', '');
    Result := API.ReturnValue;
  finally
    FreeAndNil(API);
  end;
end;


function TJEnergieverbrauch.AddZaehler(aJsonString: string): string;
var
  API: TCommunicationAPI;
begin
  API := TCommunicationAPI.Create;
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
  API := TCommunicationAPI.Create;
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
  API := TCommunicationAPI.Create;
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
  API := TCommunicationAPI.Create;
  try
    API.Get('/Zaehlerstand/ReadZeitraum', aJsonString);
    Result := API.ReturnValue;
  finally
    FreeAndNil(API);
  end;
end;

function TJEnergieverbrauch.DeleteZaehlerstand(aJsonString: string): string;
var
  API: TCommunicationAPI;
begin
  API := TCommunicationAPI.Create;
  try
    API.delete('/Zaehlerstand/Update', aJsonString);
    Result := API.ReturnValue;
  finally
    FreeAndNil(API);
  end;
end;



end.
