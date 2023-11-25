unit Objekt.IniEnergieverbrauch;

interface

uses
  IniFiles, SysUtils, Types, Registry, Variants, Windows, Classes, Objekt.IniEinstellung;

type
  TIniEnergieverbrauch = class
  private
    fIniEinstellung: TIniEinstellung;
  protected
  public
    constructor Create;
    destructor Destroy; override;
    property Einstellung: TIniEinstellung read fIniEinstellung write fIniEinstellung;
  end;


implementation

{ TIniEnergieverbrauch }

constructor TIniEnergieverbrauch.Create;
begin
  fIniEinstellung := TIniEinstellung.Create;
end;

destructor TIniEnergieverbrauch.Destroy;
begin
  FreeAndNil(fIniEinstellung);
  inherited;
end;

end.
