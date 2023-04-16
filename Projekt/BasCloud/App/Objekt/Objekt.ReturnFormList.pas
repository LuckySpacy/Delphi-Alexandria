unit Objekt.ReturnFormList;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants;

type
  TReturnFormList = class
  private
    fList: TStringList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(aFormName: string);
    function Count: Integer;
    function LastFormname: string;
    procedure DeleteLastItem;
    procedure Clear;
  end;

implementation

{ TReturnFormList }

constructor TReturnFormList.Create;
begin
  fList := TStringList.Create;
end;


destructor TReturnFormList.Destroy;
begin
  FreeAndNil(fList);
  inherited;
end;



procedure TReturnFormList.Add(aFormName: string);
begin
  fList.Add(aFormname);
end;

procedure TReturnFormList.Clear;
begin
  fList.Clear;
end;

function TReturnFormList.Count: Integer;
begin
  Result := fList.Count;
end;


function TReturnFormList.LastFormname: string;
begin
  Result := '';
  if fList.Count = 0 then
    exit;
  Result := fList.Strings[fList.Count-1];
end;


procedure TReturnFormList.DeleteLastItem;
begin
  if fList.Count = 0 then
    exit;
  fList.Delete(fList.Count-1);
end;



end.
