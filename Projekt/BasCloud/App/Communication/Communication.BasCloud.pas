unit Communication.BasCloud;

interface

uses
  System.SysUtils, System.Types, System.Classes, Communication.BasCloudAPI,
  Communication.BasCloudImageServiceAPI, Communication.BasCloudMeteringServiceAPI;

type
  TCommunicationBaseCloud = class
  protected
  private
    fBasCloudAPI: TCommunicationBasCloudAPI;
    fImageServiceAPI: TCommunicationBasCloudImageServiceAPI;
    fMeteringServiceAPI: TCommunicationBasCloudMeteringServiceAPI;
    fToken: string;
    procedure setToken(const Value: string);
  public
    constructor Create;
    destructor Destroy; override;
    property BasCloudAPI: TCommunicationBasCloudAPI read fBasCloudAPI;
    property ImageServiceAPI: TCommunicationBasCloudImageServiceAPI read fImageServiceAPI;
    property MeteringServiceAPI: TCommunicationBasCloudMeteringServiceAPI read fMeteringServiceAPI;
    property Token: string read fToken write setToken;
  end;

implementation

{ TCommunicationBaseCloud }

constructor TCommunicationBaseCloud.Create;
begin
  fBasCloudAPI := TCommunicationBasCloudAPI.Create;
  fImageServiceAPI := TCommunicationBasCloudImageServiceAPI.Create;
  fMeteringServiceAPI := TCommunicationBasCloudMeteringServiceAPI.Create;
end;

destructor TCommunicationBaseCloud.Destroy;
begin
  FreeAndNil(fBasCloudAPI);
  FreeAndNil(fImageServiceAPI);
  FreeAndNil(fMeteringServiceAPI);
  inherited;
end;

procedure TCommunicationBaseCloud.setToken(const Value: string);
begin
  fToken := Value;
  fBasCloudAPI.Token := fToken;
  fImageServiceAPI.Token := fToken;
  fMeteringServiceAPI.Token := fToken;
end;

end.
