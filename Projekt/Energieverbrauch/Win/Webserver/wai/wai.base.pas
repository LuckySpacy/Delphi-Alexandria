unit wai.base;

interface

uses
  System.SysUtils, System.Classes, Web.HTTPApp, Objekt.JErrorList,
  DB.Zaehler, DB.ZaehlerList, DB.Zaehlerstand, DB.ZaehlerstandList,
  Objekt.JZaehlerstandList, Objekt.JZaehlerstand, Objekt.JZaehlerList,
  Objekt.JZaehler;


type
  Twm_Base = class
  private
  protected
    fRequest: TWebRequest;
    fResponse: TWebResponse;
    fJErrorList: TJErrorList;
    fDBZaehler: TDBZaehler;
    fDBZaehlerList: TDBZaehlerList;
    fDBZaehlerstand: TDBZaehlerstand;
    fDBZaehlerstandList: TDBZaehlerstandList;
    fJZaehlerstandList: TJZaehlerstandList;
    fJZaehlerstand: TJZaehlerstand;
    fJZaehlerList: TJZaehlerList;
    fJZaehler: TJZaehler;
  public
    constructor Create(aRequest: TWebRequest; aResponse: TWebResponse); virtual;
    destructor Destroy; override;
  end;






implementation

{ Twm_Base }

constructor Twm_Base.Create(aRequest: TWebRequest; aResponse: TWebResponse);
begin
  fRequest  := aRequest;
  fResponse := aResponse;
  fResponse.ContentType := 'application/json; charset=UTF-8';
  fJErrorList := TJErrorList.Create;
  fDBZaehler          := TDBZaehler.Create(nil);
  fDBZaehlerList      := TDBZaehlerList.Create;
  fDBZaehlerstand     := TDBZaehlerstand.Create(nil);
  fDBZaehlerstandList := TDBZaehlerstandList.Create;

  fJZaehlerstandList := TJZaehlerstandList.Create;
  fJZaehlerstand     := TJZaehlerstand.Create;
  fJZaehlerList      := TJZaehlerList.Create;
  fJZaehler          := TJZaehler.Create;

end;

destructor Twm_Base.Destroy;
begin
  FreeAndNil(fJErrorList);
  FreeAndNil(fDBZaehler);
  FreeAndNil(fDBZaehlerList);
  FreeAndNil(fDBZaehlerstand);
  FreeAndNil(fDBZaehlerstandList);
  FreeAndNil(fJZaehlerstandList);
  FreeAndNil(fJZaehlerstand);
  FreeAndNil(fJZaehlerList);
  FreeAndNil(fJZaehler);

  inherited;
end;

end.
