unit Json.BasisList;

interface
uses
  System.SysUtils, System.Variants, System.Classes, Objekt.BasisList, Json.ErrorList;

type
  TJBasisList = class(TBasisList)
  private
  protected
    fJErrorList: TJErrorList;
  public
    constructor Create; override;
    destructor Destroy; override;
    property JErrorList: TJErrorList read fJErrorList write fJErrorList;
  end;

implementation

{ TJBasisList }

constructor TJBasisList.Create;
begin
  inherited;
  fJErrorList := TJErrorList.Create;
end;

destructor TJBasisList.Destroy;
begin
  FreeAndNil(fJErrorList);
  inherited;
end;

end.
