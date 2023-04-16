unit Objekt.Benutzer;

interface

uses
  System.SysUtils, System.Types, System.Classes;

type
  TBenutzer = class
  private
    fNachname: string;
    fVorname: string;
    fMaId: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    property Vorname: string read fVorname write fVorname;
    property Nachname: string read fNachname write fNachname;
    property MaId: Integer read fMaId write fMaId;
    procedure Init;
  end;

implementation

{ TBenutzer }

constructor TBenutzer.Create;
begin
  Inti;
end;

destructor TBenutzer.Destroy;
begin

  inherited;
end;

procedure TBenutzer.Init;
begin
  fNachname := '';
  fVorname  := '';
  fMaId     := 0;
end;

end.
