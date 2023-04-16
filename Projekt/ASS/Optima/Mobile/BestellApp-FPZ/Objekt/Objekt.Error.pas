unit Objekt.Error;

interface

uses
  System.SysUtils, System.Types, System.Classes;

type
  TError = class
  private
    fDetail: string;
    fStatus: string;
    fTitle: string;
  public
    constructor Create;
    destructor Destroy; override;
    property Status: string read fStatus write fStatus;
    property Title: string read fTitle write fTitle;
    property Detail: string read fDetail write fDetail;
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
  fDetail := '';
  fStatus := '';
  fTitle  := '';
end;

end.
