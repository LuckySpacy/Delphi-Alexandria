unit NFSRvHunspell;

interface

uses
  System.SysUtils, System.Classes, Prop.NFSSpell;

type
  TNFSRvHunspell = class(TComponent)
  private
    FPropSpell: TPropNFSSpell;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Spell: TPropNFSSpell read FPropSpell write FPropSpell;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Optima', [TNFSRvHunspell]);
end;

{ TNFSRvHunspell }

constructor TNFSRvHunspell.Create(AOwner: TComponent);
begin
  inherited;
  fPropSpell := TPropNFSSpell.Create(Self);
//  fPropSpell.OnUseSpell := UseSpell;
//  fPropSpell.OnChangedDict := ChangedSpellDictionary;
end;

destructor TNFSRvHunspell.Destroy;
begin
  FreeAndNil(fPropSpell);
  inherited;
end;

end.
