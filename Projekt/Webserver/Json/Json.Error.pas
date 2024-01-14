unit Json.Error;

interface

uses
  System.SysUtils, System.Variants, System.Classes, Objekt.Feld, Objekt.FeldList;

type
  TJError = class(TFeldList)
  private
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Init;
  end;

implementation

{ TError }

constructor TJError.Create;
begin
  inherited;
  Add('Code');
  Add('Status');
  Add('Title');
  Add('Detail');
end;

destructor TJError.Destroy;
begin

  inherited;
end;

procedure TJError.Init;
begin

end;

end.
