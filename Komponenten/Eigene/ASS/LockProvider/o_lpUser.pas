unit o_lpUser;

interface

uses
  SysUtils, Classes, Contnrs;


type
  Tlp_User = class
  private
    fKey: Integer;
    fHint: string;
    fMachine: string;
    fId: Integer;
    fUser: string;
    fIncId: Integer;
    fLastUpdate: String;
    fSession: string;
    fMandant: string;
    fMandantname: string;
    fAppType: string;
    fAlive: string;
    fConnected: string;
    fZeitpunkt_der_letzten_Aktivitaet: string;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Init;
    property Id         : Integer  read fId          write fId;
    property IncId      : Integer  read fIncId       write fIncId;
    property Machine    : string   read fMachine     write fMachine;
    property Key        : Integer  read fKey         write fKey;
    property User       : string   read fUser        write fUser;
    property Session    : string   read fSession     write fSession;
    property Hint       : string   read fHint        write fHint;
    property LastUpdate : String   read fLastUpdate  write fLastUpdate;
    property Mandant    : string   read fMandant     write fMandant;
    property Mandantname: string   read fMandantname write fMandantname;
    property Connected  : string   read fConnected   write fConnected;
    property AppType    : string   read fAppType     write fAppType;
    property Alive      : string   read fAlive       write fAlive;
    property Zeitpunkt_der_letzten_Aktivitaet: string read fZeitpunkt_der_letzten_Aktivitaet write fZeitpunkt_der_letzten_Aktivitaet;
  end;


implementation

{ Tlp_User }

constructor Tlp_User.Create;
begin
  Init;
end;

destructor Tlp_User.Destroy;
begin

  inherited;
end;

procedure Tlp_User.Init;
begin
  fKey       := 0;
  fHint      := '';
  fMachine   := '';
  fId        := 0;
  fUser      := '';
  fIncId     := 0;
  fLastUpdate:= '';
  fSession   := '';
  fMandant   := '';
  fMandantname := '';
  fConnected := '';
  fAppType := '';
  fAlive := '';
  fZeitpunkt_der_letzten_Aktivitaet := '';
end;

end.
