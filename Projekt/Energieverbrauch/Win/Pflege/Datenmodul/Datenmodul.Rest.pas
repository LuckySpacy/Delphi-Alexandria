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
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  dm_Rest: Tdm_Rest;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
