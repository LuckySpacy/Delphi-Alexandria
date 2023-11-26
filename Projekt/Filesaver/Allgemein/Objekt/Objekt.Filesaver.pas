unit Objekt.Filesaver;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Objekt.Logger;

type
  TFilesaver = class
  private
  protected
  public
    Log: TLogger;
    constructor Create;
    destructor Destroy; override;
  end;

var
  Filesaver : TFilesaver;

implementation

{ TFilesaver }

constructor TFilesaver.Create;
begin
  Log   := TLogger.Create;
end;

destructor TFilesaver.Destroy;
begin
  FreeAndNil(Log);
  inherited;
end;

end.
