unit Objekt.EditAutoComplete;

interface

uses
  SysUtils, Classes, vcl.Dialogs;

type
  TEditAutoComplete = class
  private
    fId: Integer;
    fMatch: string;
    fSuchStr: string;
    fNr: string;
  public
    constructor Create;
    destructor Destroy; override;
    property Id: Integer read fId write fId;
    property Match: string read fMatch write fMatch;
    property Nr: string read fNr write fNr;
    property SucheStr: string read fSuchStr write fSuchStr;
    procedure Init;
  end;

implementation

{ TEditAutoComplete }

constructor TEditAutoComplete.Create;
begin
  Init;
end;

destructor TEditAutoComplete.Destroy;
begin

  inherited;
end;

procedure TEditAutoComplete.Init;
begin
  fId      := 0;
  fMatch   := '';
  fSuchStr := '';
  fNr      := '';
end;

end.
