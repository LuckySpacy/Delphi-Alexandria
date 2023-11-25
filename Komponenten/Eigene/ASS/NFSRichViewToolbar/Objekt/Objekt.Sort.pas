unit Objekt.Sort;

interface

uses
  SysUtils, Classes, NFSToolbarTypes;

type
  TSortObj = class
  private
    fName: string;
    fNr: Integer;
    fToolbarItem: TNFSToolbaritem;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Init;
    property Name : string read fName write fName;
    property Nr : Integer read fNr write fNr;
    property ToolbarItem: TNFSToolbaritem read fToolbarItem write fToolbarItem;
  end;

implementation

{ TSortObj }

constructor TSortObj.Create;
begin
  Init;
end;

destructor TSortObj.Destroy;
begin

  inherited;
end;

procedure TSortObj.Init;
begin
  fName := '';
  fNr   := 0;
end;

end.
