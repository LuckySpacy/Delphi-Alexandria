unit Objekt.IniBase;

interface

uses
  IniFiles, SysUtils, Types, Variants, Classes,
  Objekt.Ini;

type
  TIniBase = class(TIni)
  private
  protected
    fSection: string;
    fPfad: string;
    fIniFullname: string;
  public
    constructor Create; override;
    destructor Destroy; override;
    property Pfad: String read fPfad write fPfad;
    property IniFullname: string read fIniFullname write fIniFullname;
    property Section: String read fSection write fSection;
  end;

implementation

{ TIniBase }

constructor TIniBase.Create;
begin
  inherited;

end;

destructor TIniBase.Destroy;
begin

  inherited;
end;

end.
