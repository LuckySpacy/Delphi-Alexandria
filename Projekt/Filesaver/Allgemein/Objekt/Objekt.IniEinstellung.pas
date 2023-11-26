unit Objekt.IniEinstellung;

interface

uses
  IniFiles, SysUtils, Types, Registry, Variants, Windows, Classes,
  Objekt.Ini, Objekt.IniBase;

type
  TIniEinstellung = class(TIniBase)
  private
    function getQuellPfad: string;
    function getZielpfad: string;
    procedure setQuellPfad(const Value: string);
    procedure setZielpfad(const Value: string);
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    property Quellpfad: string read getQuellPfad write setQuellPfad;
    property Zielpfad: string read getZielpfad write setZielpfad;

  end;

implementation

{ TIniEinstellung }

constructor TIniEinstellung.Create;
begin
  inherited;

end;

destructor TIniEinstellung.Destroy;
begin

  inherited;
end;

function TIniEinstellung.getQuellPfad: string;
begin
  //Result := ReadIni(fIniFullname, '', 'Host', '');
end;

function TIniEinstellung.getZielpfad: string;
begin
  //
end;

procedure TIniEinstellung.setQuellPfad(const Value: string);
begin
  //
end;

procedure TIniEinstellung.setZielpfad(const Value: string);
begin
  //
end;

end.
