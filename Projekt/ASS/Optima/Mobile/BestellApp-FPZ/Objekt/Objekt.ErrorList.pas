unit Objekt.ErrorList;

interface

uses
  SysUtils, System.Classes, Objekt.BasisList, Objekt.Error;

type
  TErrorList = class(TBasisList)
  private
    function getItem(Index: Integer): TError;
  public
    constructor Create; override;
    destructor Destroy; override;
    property Item[Index: Integer]: TError read getItem;
    function Add: TError;
    function getErrorsString: string;
    function ConnectToServerError: Boolean;
  end;

implementation

{ TErrorList }



constructor TErrorList.Create;
begin
  inherited;

end;

destructor TErrorList.Destroy;
begin

  inherited;
end;

function TErrorList.Add: TError;
begin
  Result := TError.Create;
  fList.Add(Result);
end;



function TErrorList.getItem(Index: Integer): TError;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TError(fList.Items[Index]);
end;


function TErrorList.getErrorsString: string;
var
  i1: Integer;
  s: string;
  Error: TError;
begin
  Result := '';
  for i1 := 0 to fList.Count -1 do
  begin
    Error := TError(fList.Items[i1]);
    s := Trim(Error.Title);
    if s > '' then
      s := s + ' / ' + Trim(Error.Status)
    else
      s := s + Trim(Error.Status);

    if s > '' then
      s := s + ' / ' + Trim(Error.Detail)
    else
      s := s + Trim(Error.Detail);
    if s > '' then
      Result := Result + s + sLineBreak;
  end;
end;


function TErrorList.ConnectToServerError: Boolean;
var
  i1: Integer;
begin
  Result := false;
  for i1 := 0 to fList.Count -1 do
  begin
    if TError(fList.Items[i1]).Status = '12029' then
    begin
      Result := true;
      exit;
    end;
  end;
end;



end.
