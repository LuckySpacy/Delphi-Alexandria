unit Objekt.JsonWebToken;

interface

uses
  System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TJsonWebToken = class
  private
    fAlgorithm: Integer;
    fThema: string;
    fAblaufdatum: TDateTime;
    fAustelldatum: TDateTime;
    fAussteller: string;
    fSchluessel: string;
    fLastError: string;
    fAlgorithmStr: string;
    fVerified: Boolean;
    fAbgelaufen: Boolean;
    procedure Init;
  public
    property Algorithm: Integer read fAlgorithm write fAlgorithm;
    property AlgorithmStr: string read fAlgorithmStr;
    property Thema: string read fThema write fThema;
    property Aussteller: string read fAussteller write fAussteller;
    property Austelldatum: TDateTime read fAustelldatum write fAustelldatum;
    property Ablaufdatum: TDateTime read fAblaufdatum write fAblaufdatum;
    property Schluessel: string read fSchluessel write fSchluessel;
    property Abgelaufen: Boolean read fAbgelaufen;
    property Verified: Boolean read fVerified;
    property LastError: string read fLastError;
    function BuildToken: string;
    function VerifyToken(aToken, aSchluessel: string): Boolean;
    function TokenInfo(aToken, aSchluessel: string): Boolean;
    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TJsonWebToken }

uses
  JOSE.Core.JWT, JOSE.Core.JWA, JOSE.Core.Builder, JOSE.Core.JWK, JOSE.Core.JWS;


constructor TJsonWebToken.Create;
begin
  Init;
end;

destructor TJsonWebToken.Destroy;
begin

  inherited;
end;


procedure TJsonWebToken.Init;
begin
  fAlgorithm    := 0;
  fThema        := '';
  fAblaufdatum  := 0;
  fAustelldatum := 0;
  fAussteller   := '';
  fSchluessel   := '';
  fLastError    := '';
  fAlgorithmStr := '';
  fVerified     := false;
  fAbgelaufen   := false;
end;

function TJsonWebToken.BuildToken: string;
var
  LToken: TJWT;
  LAlg: TJOSEAlgorithmId;
begin

  LToken := TJWT.Create;
  try
    LToken.Claims.Subject    := fThema;
    LToken.Claims.IssuedAt   := fAustelldatum;
    LToken.Claims.Expiration := fAblaufdatum;
    LToken.Claims.Issuer     := fAussteller;

    case fAlgorithm of
      0: LAlg := TJOSEAlgorithmId.HS256;
      1: LAlg := TJOSEAlgorithmId.HS384;
      2: LAlg := TJOSEAlgorithmId.HS512;
    else LAlg := TJOSEAlgorithmId.HS256;
    end;

    Result := TJOSE.SerializeCompact(fSchluessel, LAlg, LToken);

  finally
    LToken.Free;
  end;

end;


function TJsonWebToken.VerifyToken(aToken, aSchluessel: string): Boolean;
var
  LKey: TJWK;
  LToken: TJWT;
  LSigner: TJWS;
begin
  LKey := TJWK.Create(aSchluessel);
  try
    LToken := TJWT.Create;
    try
      LSigner := TJWS.Create(LToken);
      try
        LSigner.SkipKeyValidation := true;
        try
          LSigner.SetKey(LKey);
          LSigner.CompactToken := aToken;
          Result := LSigner.VerifySignature;
        except
          on E: Exception do
          begin
            fLastError := E.Message;
            Result := false;
            exit;
          end;
        end;
        if Result then
          fVerified := true
        else
          fVerified := false;
      finally
        LSigner.Free;
      end;
    finally
      LToken.Free;
    end;
  finally
    LKey.Free;
  end;
end;


function TJsonWebToken.TokenInfo(aToken, aSchluessel: string): Boolean;
var
  LToken: TJWT;
begin
  Result := false;
  Init;
  try
    LToken := TJOSE.DeserializeCompact(aSchluessel, aToken);
  except
    on E: Exception do
    begin
      fLastError := e.Message;
      exit;
    end;
  end;
  try
    if Assigned(LToken) then
    begin
      Result := true;
      fAussteller   := LToken.Claims.Issuer;
      fAustelldatum := LToken.Claims.IssuedAt;
      fThema        := LToken.Claims.Subject;
      fAblaufdatum  := LToken.Claims.Expiration;
      fAlgorithmStr := LToken.Header.Algorithm;
      fVerified     := LToken.Verified;
      if (LToken.Claims.HasExpiration) and (LToken.Claims.Expiration < now) then
        fAbgelaufen   := true
      else
        fAbgelaufen := false;
      //memoJSON.Lines.Add(LToken.Claims.JSON.ToJSON);
    end;
  finally
    LToken.Free;
  end;
end;


end.
