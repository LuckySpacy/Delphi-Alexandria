program JWT;

uses
  Vcl.Forms,
  Form.JWT in 'Form\Form.JWT.pas' {frm_JWT},
  Objekt.JsonWebToken in 'Objekt\Objekt.JsonWebToken.pas',
  JOSE.Builder in 'jwt\JOSE\JOSE.Builder.pas',
  JOSE.Consumer in 'jwt\JOSE\JOSE.Consumer.pas',
  JOSE.Consumer.Validators in 'jwt\JOSE\JOSE.Consumer.Validators.pas',
  JOSE.Context in 'jwt\JOSE\JOSE.Context.pas',
  JOSE.Core.Base in 'jwt\JOSE\JOSE.Core.Base.pas',
  JOSE.Core.Builder in 'jwt\JOSE\JOSE.Core.Builder.pas',
  JOSE.Core.JWA.Compression in 'jwt\JOSE\JOSE.Core.JWA.Compression.pas',
  JOSE.Core.JWA.Encryption in 'jwt\JOSE\JOSE.Core.JWA.Encryption.pas',
  JOSE.Core.JWA.Factory in 'jwt\JOSE\JOSE.Core.JWA.Factory.pas',
  JOSE.Core.JWA in 'jwt\JOSE\JOSE.Core.JWA.pas',
  JOSE.Core.JWA.Signing in 'jwt\JOSE\JOSE.Core.JWA.Signing.pas',
  JOSE.Core.JWE in 'jwt\JOSE\JOSE.Core.JWE.pas',
  JOSE.Core.JWK in 'jwt\JOSE\JOSE.Core.JWK.pas',
  JOSE.Core.JWS in 'jwt\JOSE\JOSE.Core.JWS.pas',
  JOSE.Core.JWT in 'jwt\JOSE\JOSE.Core.JWT.pas',
  JOSE.Core.Parts in 'jwt\JOSE\JOSE.Core.Parts.pas',
  JOSE.Producer in 'jwt\JOSE\JOSE.Producer.pas',
  JOSE.Encoding.Base64 in 'jwt\Common\JOSE.Encoding.Base64.pas',
  JOSE.Hashing.HMAC in 'jwt\Common\JOSE.Hashing.HMAC.pas',
  JOSE.OpenSSL.Headers in 'jwt\Common\JOSE.OpenSSL.Headers.pas',
  JOSE.Signing.Base in 'jwt\Common\JOSE.Signing.Base.pas',
  JOSE.Signing.ECDSA in 'jwt\Common\JOSE.Signing.ECDSA.pas',
  JOSE.Signing.RSA in 'jwt\Common\JOSE.Signing.RSA.pas',
  JOSE.Types.Arrays in 'jwt\Common\JOSE.Types.Arrays.pas',
  JOSE.Types.Bytes in 'jwt\Common\JOSE.Types.Bytes.pas',
  JOSE.Types.JSON in 'jwt\Common\JOSE.Types.JSON.pas',
  JOSE.Types.Utils in 'jwt\Common\JOSE.Types.Utils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tfrm_JWT, frm_JWT);
  Application.Run;
end.
