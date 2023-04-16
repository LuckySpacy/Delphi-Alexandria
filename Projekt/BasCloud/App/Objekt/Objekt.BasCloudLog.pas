unit Objekt.BasCloudLog;

interface

uses
  FMX.Platform, FMX.Types;

type
  TBasCloudLog = class
  private
  public
    constructor Create;
    destructor Destroy; override;
    procedure Log(const Msg: string); overload;
  end;


implementation

{ TBasCloudLog }

constructor TBasCloudLog.Create;
begin

end;

destructor TBasCloudLog.Destroy;
begin

  inherited;
end;

procedure TBasCloudLog.Log(const Msg: string);
begin
  FMX.Types.Log.d(Msg);
end;

end.
