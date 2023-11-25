unit Prop.NFSSpell;

interface

uses
  Classes, SysUtils, Contnrs, Buttons, Controls, RvHunSpell;

type
  TPropNFSSpell = class(TPersistent)
  private
    fFormStyle: TRVHunSpellFormStyle;
    fDLLName: string;
    fDictName: string;
    fUseSpell: Boolean;
    fOnUseSpell: TNotifyEvent;
    fDLLDir: string;
    fDictDir: string;
    fOnChangedDict: TNotifyEvent;
    fDictCustomDir: string;
    fDictCustomName: string;
    fUseSpellOnlyWriteCapability: Boolean;
    procedure setUseSpell(const Value: Boolean);
    procedure ChangedDictionary;
    procedure setDLLName(const Value: string);
    procedure setDLLDir(const Value: string);
    procedure setDictName(const Value: string);
    procedure setDictDir(const Value: string);
    procedure setDictCustomDir(const Value: string);
    procedure setDictCustomName(const Value: string);
  protected
  public
    destructor Destroy; override;
    constructor Create(aOwner: TComponent); reintroduce;
    property OnUseSpell: TNotifyEvent read fOnUseSpell write fOnUseSpell;
    property OnChangedDict: TNotifyEvent read fOnChangedDict write fOnChangedDict;
  published
    property FormStyle: TRVHunSpellFormStyle read fFormStyle write fFormstyle;
    property DLLName: string read fDLLName write setDLLName;
    property DLLDir: string read fDLLDir write setDLLDir;
    property DictName: string read fDictName write setDictName;
    property DictDir: string read fDictDir write setDictDir;
    property DictCustomerName: string read fDictCustomName write setDictCustomName;
    property DictCustomerDir: string read fDictCustomDir write setDictCustomDir;
    property UseSpell: Boolean read fUseSpell write setUseSpell;
    property UseSpellOnlyWriteCapability: Boolean read fUseSpellOnlyWriteCapability write fUseSpellOnlyWriteCapability;
  end;

implementation

{ TPropNFSSpell }

uses
  Vcl.Dialogs;


constructor TPropNFSSpell.Create(aOwner: TComponent);
begin
  fUseSpellOnlyWriteCapability := false;
  fUseSpell := false;
end;

destructor TPropNFSSpell.Destroy;
begin

  inherited;
end;

procedure TPropNFSSpell.setDictCustomDir(const Value: string);
begin
  fDictCustomDir := Value;
  ChangedDictionary;
end;

procedure TPropNFSSpell.setDictCustomName(const Value: string);
begin
  fDictCustomName := Value;
  ChangedDictionary;
end;

procedure TPropNFSSpell.setDictDir(const Value: string);
begin
  fDictDir := Value;
  ChangedDictionary;
end;

procedure TPropNFSSpell.setDictName(const Value: string);
begin
  fDictName := Value;
  ChangedDictionary;
end;

procedure TPropNFSSpell.setDLLDir(const Value: string);
begin
  fDLLDir := Value;
  ChangedDictionary;
end;

procedure TPropNFSSpell.setDLLName(const Value: string);
begin
  fDLLName := Value;
  ChangedDictionary;
end;

procedure TPropNFSSpell.setUseSpell(const Value: Boolean);
var
  FullDLLName: string;
  FullDicName: string;
  FullDicCustomName: string;
begin
  if Value = fUseSpell then
    exit;

  fUseSpell := Value;
  if fUseSpell then
  begin
    FullDicCustomName := '';
    if not DirectoryExists(fDLLDir) then
    begin
      ShowMessage('DLL directory not exist');
      fUseSpell := false;
    end;

    if not DirectoryExists(fDictDir) then
    begin
      ShowMessage('Dictionary directory not exist');
      fUseSpell := false;
    end;

    if (fDictCustomDir > '') or (fDictCustomName > '') then
    begin
      if not DirectoryExists(fDictCustomDir) then
      begin
        ShowMessage('Customer dictionary directory not exist');
        fUseSpell := false;
      end;
    end;

    FullDLLName := IncludeTrailingPathDelimiter(fDLLDir) + fDLLName;
    FullDicName := IncludeTrailingPathDelimiter(fDictDir) + fDictName;

    if (fDictCustomDir > '') or (fDictCustomName > '') then
      FullDicCustomName := IncludeTrailingPathDelimiter(fDictCustomDir) + fDictCustomName;

    if not FileExists(FullDLLName) then
    begin
      ShowMessage('DLLName not found');
      fUseSpell := false;
    end;
    if not FileExists(FullDicName) then
    begin
      ShowMessage('DictName not found');
      fUseSpell := false;
    end;
    if (FullDicCustomName > '') and (not FileExists(FullDicCustomName)) then
    begin
      ShowMessage('DictCustomerName not found');
      fUseSpell := false;
    end;
  end;
  if Assigned(fOnUseSpell) then
    fOnUseSpell(Self);
end;

procedure TPropNFSSpell.ChangedDictionary;
begin
  if fUseSpell then
    fUseSpell := false;
  if Assigned(fOnChangedDict) then
    fOnChangedDict(Self);
end;


end.
