unit Objekt.Queue;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, types.PhotoOrga;

type
  TQueue = class
  private
    fProcess: TQueueProcess;
    fDel: Boolean;
  protected
  public
    constructor Create;
    destructor Destroy; override;
    property Process: TQueueProcess read fProcess write fProcess;
    property Del: Boolean read fDel write fDel;
  end;

implementation

{ TQueue }

constructor TQueue.Create;
begin

end;

destructor TQueue.Destroy;
begin

  inherited;
end;

end.
