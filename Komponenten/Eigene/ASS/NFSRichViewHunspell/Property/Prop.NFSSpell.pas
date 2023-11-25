unit Prop.NFSSpell;

interface

uses
  Classes, SysUtils, Contnrs, Buttons, Controls, RvHunSpell;

type
  THunspellSettingsErrorEvent = procedure(Sender: TObject; aErrorText: string; aErrorCode: Integer; var aUseSpell: Boolean) of object;
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
    fHunspellSettingsError: THunspellSettingsErrorEvent;
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
    property OnHunspellSettingsError: THunspellSettingsErrorEvent read fHunspellSettingsError write fHunspellSettingsError;
  end;

implementation

{ TPropNFSSpell }

uses
  Vcl.Dialogs;


constructor TPropNFSSpell.Create(aOwner: TComponent);
begin
  fUseSpellOnlyWriteCapability := false;
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
  fUseSpell := Value;
  if fUseSpell then
  begin
    FullDicCustomName := '';
    if not DirectoryExists(fDLLDir) then
    begin
      fUseSpell := false;
      if Assigned(fHunspellSettingsError) then
        fHunspellSettingsError(Self, 'DLL directory not exist', 1, fUseSpell)
      else
        ShowMessage('DLL directory not exist');
    end;

    if not DirectoryExists(fDictDir) then
    begin
      fUseSpell := false;
      if Assigned(fHunspellSettingsError) then
        fHunspellSettingsError(Self, 'Dictionary directory not exist', 2, fUseSpell)
      else
        ShowMessage('Dictionary directory not exist');
    end;

    if (fDictCustomDir > '') or (fDictCustomName > '') then
    begin
      if not DirectoryExists(fDictCustomDir) then
      begin
        fUseSpell := false;
        if Assigned(fHunspellSettingsError) then
          fHunspellSettingsError(Self, 'Customer dictionary directory not exist', 3, fUseSpell)
        else
          ShowMessage('Customer dictionary directory not exist');
      end;
    end;

    FullDLLName := IncludeTrailingPathDelimiter(fDLLDir) + fDLLName;
    FullDicName := IncludeTrailingPathDelimiter(fDictDir) + fDictName;

    if (fDictCustomDir > '') or (fDictCustomName > '') then
      FullDicCustomName := IncludeTrailingPathDelimiter(fDictCustomDir) + fDictCustomName;

    if not FileExists(FullDLLName) then
    begin
      fUseSpell := false;
      if Assigned(fHunspellSettingsError) then
        fHunspellSettingsError(Self, 'DLLName not found', 4, fUseSpell)
      else
        ShowMessage('DLLName not found');
    end;
    if not FileExists(FullDicName) then
    begin
      fUseSpell := false;
      if Assigned(fHunspellSettingsError) then
        fHunspellSettingsError(Self, 'DictName not found', 5, fUseSpell)
      else
        ShowMessage('DictName not found');
    end;
    if (FullDicCustomName > '') and (not FileExists(FullDicCustomName)) then
    begin
      fUseSpell := true;
      if Assigned(fHunspellSettingsError) then
        fHunspellSettingsError(Self, 'DictCustomerName not found', 6, fUseSpell)
      else
        ShowMessage('DictCustomerName not found');
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
