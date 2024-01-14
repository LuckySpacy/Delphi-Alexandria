unit Objekt.JWT;

interface

uses
  System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TJWT = class
  private
    fAlgorithm: Integer;
    fThema: string;
    fAblaufdatum: TDateTime;
    fAustelldatum: TDateTime;
    fAussteller: string;
    fSchluessel: string;
    constructor Create;
    destructor Destroy; override;
    function BuildToken: string;
    procedure Init;
    property Algorithm: Integer read fAlgorithm write fAlgorithm;
    property Thema: string read fThema write fThema;
    property Aussteller: string read fAussteller write fAussteller;
    property Austelldatum: TDateTime read fAustelldatum write fAustelldatum;
    property Ablaufdatum: TDateTime read fAblaufdatum write fAblaufdatum;
    property Schluessel: string read fSchluessel write fSchluessel;
  public
  end;

implementation

{ TJWT }


constructor TJWT.Create;
begin
  Init;
end;

destructor TJWT.Destroy;
begin

  inherited;
end;


procedure TJWT.Init;
begin
  fAlgorithm    := 0;
  fThema        := '';
  fAblaufdatum  := 0;
  fAustelldatum := 0;
  fAussteller   := '';
  fSchluessel   := '';
end;

function TJWT.BuildToken: string;
begin

end;


end.
