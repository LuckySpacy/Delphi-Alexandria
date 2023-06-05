unit API.Base;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Controls, Vcl.Dialogs, Communication.Base;

type
  TAPIBase = class
  private
  protected
    fCommunication: TCommunicationBase;
  public
    constructor Create(aCommuncationBase: TCommunicationBase); virtual;
    destructor Destroy; override;
    function Get(aURL: string): string;
  end;


implementation

{ TAPIBase }

constructor TAPIBase.Create(aCommuncationBase: TCommunicationBase);
begin
  fCommunication := aCommuncationBase;
end;

destructor TAPIBase.Destroy;
begin

  inherited;
end;

function TAPIBase.Get(aURL: string): string;
begin
  Result := fCommunication.Get(aUrl);
end;

end.
