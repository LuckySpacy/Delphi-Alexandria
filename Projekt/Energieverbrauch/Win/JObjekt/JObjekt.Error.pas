unit JObjekt.Error;

interface

uses
  System.SysUtils, System.JSON;

type
  TJObjError = class
  private
    fCode: string;
    fDetail: string;
    fTitle: string;
    fStatus: string;
  protected
  public
    constructor Create;
    destructor Destroy; override;
    property Code: string read fCode write fCode;
    property Status: string read fStatus write fStatus;
    property Title: string read fTitle write fTitle;
    property Detail: string read fDetail write fDetail;
    procedure Init;
  end;

implementation

{ TJObjError }

constructor TJObjError.Create;
begin
  Init;
end;

destructor TJObjError.Destroy;
begin

  inherited;
end;

procedure TJObjError.Init;
begin
  fCode   := '';
  fDetail := '';
  fTitle  := '';
  fStatus := '';
end;

end.
