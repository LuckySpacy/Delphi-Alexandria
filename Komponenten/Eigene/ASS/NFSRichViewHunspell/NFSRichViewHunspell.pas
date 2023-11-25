unit NFSRichViewHunspell;

interface

uses
  System.SysUtils, System.Classes, Prop.NFSSpell, RvHunspell, RvTypes, Richview,
  RvEdit, RvWordEnum;

type
  THunspellSettingsErrorEvent = procedure(Sender: TObject; aErrorText: string; aErrorCode: Integer; var aUseSpell: Boolean) of object;
  TNFSRvHunspell = class(TComponent)
  private
    FPropSpell: TPropNFSSpell;
    fOnUseSpell: TNotifyEvent;
    fOnChangedDict: TNotifyEvent;
    fHunSpell: TRVHunSpell;
    FOnSpellFormAction: TRVHunSpellFormActionEvent;
    fHunspellSettingsError: THunspellSettingsErrorEvent;
    procedure DoUseSpell(Sender: TObject);
    procedure DoChangedDict(Sender: TObject);
    procedure DoRVHunSpellFormAction(Sender: TRVHunSpell; const AWord, AReplaceTo: TRVUnicodeString; Action: TRVHunSpellFormAction);
    procedure SetDirectories;
    procedure HunspellSettingsError(Sender: TObject; aErrorText: string; aErrorCode: Integer; var aUseSpell: Boolean);
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Check(Editor: TCustomRichViewEdit; Scope: TRVEnumScope);
    function LoadCustomDic: Boolean;
    function Spells(Word: TRVUnicodeString; Language: TRVUnicodeString = ''): Boolean;
  published
    property Spell: TPropNFSSpell read FPropSpell write FPropSpell;
    property OnUseSpell: TNotifyEvent read fOnUseSpell write fOnUseSpell;
    property OnChangedDict: TNotifyEvent read fOnChangedDict write fOnChangedDict;
    property OnSpellFormAction: TRVHunSpellFormActionEvent read FOnSpellFormAction write FOnSpellFormAction;
    property OnHunspellSettingsError: THunspellSettingsErrorEvent read fHunspellSettingsError write fHunspellSettingsError;
  end;

procedure Register;

implementation

uses
  Vcl.Dialogs;

procedure Register;
begin
  RegisterComponents('Optima', [TNFSRvHunspell]);
end;

{ TNFSRvHunspell }



constructor TNFSRvHunspell.Create(AOwner: TComponent);
begin
  inherited;
  fPropSpell := TPropNFSSpell.Create(Self);
  fPropSpell.OnUseSpell := DoUseSpell;
  fPropSpell.OnChangedDict := DoChangedDict;
  fHunSpell := TRVHunSpell.Create(Self);
  fHunSpell.OnSpellFormAction := DoRVHunSpellFormAction;
  fPropSpell.OnHunspellSettingsError := HunspellSettingsError;
end;

destructor TNFSRvHunspell.Destroy;
begin
  FreeAndNil(fPropSpell);
  FreeAndNil(fHunSpell);
  inherited;
end;

procedure TNFSRvHunspell.DoChangedDict(Sender: TObject);
begin
  if fPropSpell.UseSpell then
    FPropSpell.UseSpell := false;

  SetDirectories;

  if Assigned(fOnChangedDict) then
    fOnChangedDict(Sender);
end;

procedure TNFSRvHunspell.DoRVHunSpellFormAction(Sender: TRVHunSpell;
  const AWord, AReplaceTo: TRVUnicodeString; Action: TRVHunSpellFormAction);
begin
  if Assigned(FOnSpellFormAction) then
    FOnSpellFormAction(Sender, AWord, AReplaceTo, Action);
end;

procedure TNFSRvHunspell.DoUseSpell(Sender: TObject);
begin
  if Spell.UseSpell then
  begin
    setDirectories;
    fHunSpell.Dictionaries.Clear;
    fHunSpell.LoadAllDictionaries;
    fHunSpell.LoadCustomDic;
  end;
  if Assigned(fOnUseSpell) then
    fOnUseSpell(Sender);
end;

procedure TNFSRvHunspell.HunspellSettingsError(Sender: TObject;
  aErrorText: string; aErrorCode: Integer; var aUseSpell: Boolean);
begin
  if Assigned(fHunspellSettingsError) then
    fHunspellSettingsError(Sender, aErrorText, aErrorCode, aUseSpell)
  else
    ShowMessage(aErrorText);
end;

function TNFSRvHunspell.LoadCustomDic: Boolean;
begin
  Result := fHunSpell.LoadCustomDic;
end;

procedure TNFSRvHunspell.SetDirectories;
begin
  fHunSpell.SpellFormStyle := fPropSpell.FormStyle;
  fHunSpell.DllDir := fPropSpell.DLLDir;
  fHunSpell.DllName := fPropSpell.DLLName;
  fHunSpell.DictDir := fPropSpell.DictDir;
  if fPropSpell.DictCustomerDir > '' then
    fHunSpell.CustomDictionaryFileName := IncludeTrailingPathDelimiter(fPropSpell.DictCustomerDir) + fPropSpell.DictCustomerName
  else
    fHunSpell.CustomDictionaryFileName := '';
end;


function TNFSRvHunspell.Spells(Word, Language: TRVUnicodeString): Boolean;
begin
  Result := fHunspell.Spell(Word, Language);
end;

procedure TNFSRvHunspell.Check(Editor: TCustomRichViewEdit;
  Scope: TRVEnumScope);
begin
  fHunspell.Check(Editor, Scope);
end;


end.
