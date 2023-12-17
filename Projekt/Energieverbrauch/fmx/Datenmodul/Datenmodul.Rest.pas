unit Datenmodul.Rest;

interface

uses
  System.SysUtils, System.Classes, System.Net.URLClient, System.Net.HttpClient,
  System.Net.HttpClientComponent;

type
  Tdm_Rest = class(TDataModule)
    HTTPClient: TNetHTTPClient;
    HTTPRequest: TNetHTTPRequest;
  private
  public
    procedure ReadZaehlerList;
  end;

var
  dm_Rest: Tdm_Rest;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

{ Tdm_Rest }

uses
  Objekt.Energieverbrauch, Objekt.JZaehlerList;

procedure Tdm_Rest.ReadZaehlerList;
begin
  dm_Rest.HTTPRequest.MethodString := 'GET';
  //dm_Rest.HTTPRequest.URL := 'http://' +edt_Host.Text + ':' + Trim(edt_Port.Text) + '/CheckConnect';
  dm_Rest.HTTPRequest.URL := Energieverbrauch.HostIni.Host + ':' + Energieverbrauch.HostIni.Port.ToString + '/Zaehler/Read';
//  dm_Rest.HTTPRequest.OnRequestCompleted := HTTPRequestRequestCompleted;
//  dm_Rest.HTTPRequest.OnRequestError := HTTPRequestRequestError;
  dm_Rest.HTTPRequest.Execute();
end;

end.
