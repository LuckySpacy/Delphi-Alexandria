unit Objekt.BasCloudStyle;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, FMX.StdCtrls, FMX.Objects, FMX.Types;

type
  TBasCloudStyle = class
  private
    fLabelColor: TAlphaColor;
  public
    constructor Create;
    destructor Destroy; override;
    property LabelColor: TAlphaColor read fLabelColor;
    procedure setCornerButtonDefaultStyle(aCornerButton: TCornerButton);
    procedure setCornerButtonDefaultTextColor(aCornerButton: TCornerButton);
  end;

implementation

{ TBasCloudStyle }

constructor TBasCloudStyle.Create;
begin
  fLabelColor := TAlphaColors.Black;
end;

destructor TBasCloudStyle.Destroy;
begin

  inherited;
end;

procedure TBasCloudStyle.setCornerButtonDefaultStyle(
  aCornerButton: TCornerButton);
var
  rec: TRectangle;
begin
  rec := TRectangle(TCornerButton(aCornerButton).FindStyleResource('Background'));
  if rec = nil then
  begin
    rec := TRectangle(TCornerButton(aCornerButton).FindStyleResource('CornerFrame'));
    rec.Stroke.Color := TAlphacolors.Gray;
  end;
  if rec <> nil then
    rec.Fill.Color := TAlphaColor(#005686);
end;

procedure TBasCloudStyle.setCornerButtonDefaultTextColor(
  aCornerButton: TCornerButton);
begin
  aCornerButton.StyledSettings := aCornerButton.StyledSettings - [TStyledSetting.FontColor];
  aCornerButton.TextSettings.FontColor := TAlphaColors.Black;
end;



end.
