unit Objekt.User;

interface

uses
  System.SysUtils, System.Types, System.Classes;

type
  TUser = class
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

{ TUser }

constructor TUser.Create;
begin
  Init;
end;

destructor TUser.Destroy;
begin

  inherited;
end;

procedure TUser.Init;
begin
  fNachname := '';
  fVorname  := '';
  fMaId     := 0;
end;

end.
