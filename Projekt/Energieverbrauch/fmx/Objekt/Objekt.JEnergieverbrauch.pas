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
    API.Get('/Zaehler/Read');
    Result := API.ReturnValue;
  finally
    FreeAndNil(API);
  end;
end;

end.
