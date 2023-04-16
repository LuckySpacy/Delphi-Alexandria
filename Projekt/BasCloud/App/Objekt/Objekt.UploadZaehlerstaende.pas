unit Objekt.UploadZaehlerstaende;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, FMX.Dialogs,
  Thread.UploadZaehlerstaende;

type
  TUploadZaehlerstaende = class
  private
    fThreadUploadZaehlerstaende: TThreadUploadZaehlerstaende;
    fOnUploadEnde: TNotifyEvent;
    fBusy: Boolean;
    fOnBreakUpload: TNotifyEvent;
    fOnUploadStart: TNotifyEvent;
    procedure UploadEnde(Sender: TObject);
    procedure BreakUpload(Sender: TObject);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Start;
    property OnUploadEnde: TNotifyEvent read fOnUploadEnde write fOnUploadEnde;
    property OnBreakUpload: TNotifyEvent read fOnBreakUpload write fOnBreakUpload;
    property OnUploadStart: TNotifyEvent read fOnUploadStart write fOnUploadStart;
    property Busy: Boolean read fBusy;
  end;

var
  UploadZaehlerstaendex : TUploadZaehlerstaende;


implementation

{ TUploadZaehlerstaende }

uses
  Objekt.BasCloud;



constructor TUploadZaehlerstaende.Create;
begin
  fThreadUploadZaehlerstaende := TThreadUploadZaehlerstaende.Create;
  fThreadUploadZaehlerstaende.OnUploadEnde := UploadEnde;
  fThreadUploadZaehlerstaende.OnBreakUpload := BreakUpload;
  fBusy := false;
end;

destructor TUploadZaehlerstaende.Destroy;
begin
  if fThreadUploadZaehlerstaende <> nil  then
    FreeAndNil(fThreadUploadZaehlerstaende);
  inherited;
end;

procedure TUploadZaehlerstaende.Start;
begin
  if fBusy then
    exit;
  fBusy := true;
  if Assigned(fOnUploadStart) then
    fOnUploadStart(Self);
  fThreadUploadZaehlerstaende.DoUploadZaehlerstaende;
 // Sleep(5000);
 // UploadEnde(nil);
end;

procedure TUploadZaehlerstaende.UploadEnde(Sender: TObject);
begin
  fBusy := false;
  if Assigned(fOnUploadEnde) then
    fOnUploadEnde(Self);
end;

procedure TUploadZaehlerstaende.BreakUpload(Sender: TObject);
begin
  fBusy := false;
  BasCloud.BreakUpload := false;
  if Assigned(fOnBreakUpload) then
    fOnBreakUpload(Self);
end;





end.
