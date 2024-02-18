unit Objekt.StatistikMonat;

interface

uses
  SysUtils, Types, Variants, Classes;

type
  TStatistikMonat = class
  private
    fMonat: Integer;
    fWert: Currency;
    fJahr: Integer;
    function getJahrMonat: string;
  protected
  public
    constructor Create;
    destructor Destroy; override;
    property Monat: Integer read fMonat write fMonat;
    property Jahr: Integer read fJahr write fJahr;
    property Wert: Currency read fWert write fWert;
    property JahrMonat: string read getJahrMonat;
    procedure init;
    function Monatslabel: string;
  end;

implementation

{ TStatistikMonat }

constructor TStatistikMonat.Create;
begin
  Init;
end;

destructor TStatistikMonat.Destroy;
begin

  inherited;
end;


function TStatistikMonat.getJahrMonat: string;
begin
  Result := fJahr.ToString;
  if fMonat < 10 then
    Result := Result + '0' + fMonat.ToString
  else
    Result := Result + fMonat.ToString;
end;

procedure TStatistikMonat.init;
begin
  fWert  := 0;
  fMonat := 0;
  fJahr  := 0;
end;


function TStatistikMonat.Monatslabel: string;
begin
  case fMonat of
    1: Result := 'Jan';
    2: Result := 'Feb';
    3: Result := 'Mär';
    4: Result := 'Apr';
    5: Result := 'Mai';
    6: Result := 'Jun';
    7: Result := 'Jul';
    8: Result := 'Aug';
    9: Result := 'Sep';
    10: Result := 'Okt';
    11: Result := 'Nov';
    12: Result := 'Dez';
  end;
end;

end.
