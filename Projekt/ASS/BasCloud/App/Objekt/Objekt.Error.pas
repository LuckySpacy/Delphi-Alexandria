unit Objekt.Error;

interface

uses
  System.SysUtils, System.Types, System.Classes;

type
  TError = class
  private
    fDetail: string;
    fActivityId: string;
    fStatus: string;
    fTitle: string;
    fSystemError: Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    property Status: string read fStatus write fStatus;
    property Title: string read fTitle write fTitle;
    property Detail: string read fDetail write fDetail;
    property ActivityId: string read fActivityId write fActivityId;
    property SystemError: Boolean read fSystemError write fSystemError;
    procedure Init;
  end;

implementation

{ TError }

constructor TError.Create;
begin
  Init;
end;

destructor TError.Destroy;
begin

  inherited;
end;

procedure TError.Init;
begin
  fDetail      := '';
  fActivityId  := '';
  fTitle       := '';
  fStatus      := '';
  fSystemError := false;
end;

end.
