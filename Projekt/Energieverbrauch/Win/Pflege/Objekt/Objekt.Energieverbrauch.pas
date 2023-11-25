unit Objekt.Energieverbrauch;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Objekt.Logger, Objekt.IniEnergieverbrauch;


type
  TEnergieverbrauch = class
  private
    fIniEnergieverbrauch: TIniEnergieverbrauch;
  public
    Log: TLogger;
    constructor Create;
    destructor Destroy; override;
    property Ini: TIniEnergieverbrauch read fIniEnergieverbrauch write fIniEnergieverbrauch;
  end;


var
  Energieverberbrauch : TEnergieverbrauch;

implementation

{ TEnergieverbrauch }


constructor TEnergieverbrauch.Create;
begin
  Log   := TLogger.Create;
  fIniEnergieverbrauch := TIniEnergieverbrauch.Create;
end;

destructor TEnergieverbrauch.Destroy;
begin
  FreeAndNil(Log);
  FreeAndNil(fIniEnergieverbrauch);
  inherited;
end;

end.
