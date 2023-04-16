unit Objekt.ErrorList;

interface

uses
  SysUtils, System.Classes, Objekt.BasisList, Objekt.Error;

type
  TErrorList = class(TBasisList)
  private
    function getItem(Index: Integer): TError;
    function getStatus: string;
    function getTitle: string;
  public
    constructor Create; override;
    destructor Destroy; override;
    property Item[Index: Integer]: TError read getItem;
    function Add: TError;
    property Status: string read getStatus;
    property Title: string read getTitle;
    function TokenNichtMehrGueltig: Boolean;
    function InternalServerError: Boolean;
   function getErrorString: string;
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


function TErrorList.getStatus: string;
begin
  Result := '';
  if fList.Count > 0 then
    Result := Item[0].Status;
end;

function TErrorList.getTitle: string;
begin
  Result := '';
  if fList.Count > 0 then
    Result := Item[0].Title;
end;

function TErrorList.InternalServerError: Boolean;
begin
  Result := false;
  if fList.Count = 0 then
    exit;

  if (Item[0].SystemError) and (getStatus = '500') and (SameText(getTitle, 'Internal server error')) then
    Result := true;
end;

function TErrorList.TokenNichtMehrGueltig: Boolean;
begin
  Result := false;
  if (getStatus = '401') and (SameText(getTitle, 'Unauthorized')) then
    Result := true;
end;


function TErrorList.getErrorString: string;
begin
  Result := '';
  if fList.Count = 0 then
    exit;
  Result := Trim(Item[0].title + ' ' + Item[0].detail + ' ' + Item[0].status);
end;

end.
