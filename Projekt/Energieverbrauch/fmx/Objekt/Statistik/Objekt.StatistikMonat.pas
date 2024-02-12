unit Objekt.StatistikMonat;

interface

uses
  SysUtils, Types, Variants, Classes;

type
  TStatistikMonat = class
  private
    fMonat: Integer;
    fWert: Currency;
  protected
  public
    constructor Create;
    destructor Destroy; override;
    property Monat: Integer read fMonat write fMonat;
    property Wert: Currency read fWert write fWert;
    procedure init;
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
procedure TStatistikMonat.init;
begin
  fWert  := 0;
  fMonat := 0;
end;

end.
