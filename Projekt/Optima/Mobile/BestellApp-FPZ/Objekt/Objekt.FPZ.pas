unit Objekt.FPZ;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.Notification, Objekt.FPZIni, Objekt.User, Objekt.ArtikelList;

type
  TFPZ = class
  private
    fIni: TFPZIni;
    fUser: TUser;
    fArtikelList: TArtikelList;
  public
    constructor Create;
    destructor Destroy; override;
    property Ini: TFPZIni read fIni;
    function User: TUser;
    function ArtikelList: TArtikelList;
  end;


var
  FPZ: TFPZ;


implementation

{ TFPZ }



function TFPZ.ArtikelList: TArtikelList;
begin
  Result := fArtikelList;
end;

constructor TFPZ.Create;
begin
  fIni  := TFPZIni.Create;
  fUser := TUser.Create;
  fArtikelList := TArtikelList.Create;
end;

destructor TFPZ.Destroy;
begin
  FreeAndNil(fIni);
  FreeAndNil(fUser);
  FreeAndNil(fArtikelList);
  inherited;
end;

function TFPZ.User: TUser;
begin
  Result := fUser;
end;


end.
