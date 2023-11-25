unit o_lpLockItem;

interface

uses
  SysUtils, Classes, Contnrs;


type
  Tlp_LockItem = class
  private
    fLockId: Integer;
    fHint: string;
    fDatensatzId: Integer;
    fMandant: string;
    fMandantname: string;
    fMachine: string;
    fId: Integer;
    fTabelle: string;
    fTabelleKey: Integer;
    fUser: string;
    fLastUpdate: String;
    fSession: string;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Init;
    property Id          : Integer  read fId          write fId;
    property LockId      : Integer  read fLockId      write fLockId;
    property Machine     : string   read fMachine     write fMachine;
    property TabelleKey  : Integer  read fTabelleKey  write fTabelleKey;
    property Tabelle     : string   read fTabelle     write fTabelle;
    property DatensatzId : Integer  read fDatensatzId write fDatensatzId;
    property User        : string   read fUser        write fUser;
    property Session     : string   read fSession     write fSession;
    property LastUpdate  : String   read fLastUpdate  write fLastUpdate;
    property Hint        : string   read fHint        write fHint;
    property Mandant     : string   read fMandant     write fMandant;
    property Mandantname : string   read fMandantname write fMandantname;
  end;


implementation

{ Tlp_LockItem }

constructor Tlp_LockItem.Create;
begin
  init;
end;

destructor Tlp_LockItem.Destroy;
begin

  inherited;
end;

procedure Tlp_LockItem.Init;
begin
  fLockId      := 0;
  fHint        := '';
  fDatensatzId := 0;
  fMandant     := '';
  fMandantname := '';
  fMachine     := '';
  fId          := 0;
  fTabelle     := '';
  fTabelleKey  := 0;
  fUser        := '';
  fLastUpdate  := '';
  fSession     := '';
end;

end.
