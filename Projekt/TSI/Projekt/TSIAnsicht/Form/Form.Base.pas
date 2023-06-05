unit Form.Base;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Communication.Base;

type
  Tfrm_Base = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
  protected
    fCommunication: TCommunicationBase;
  public
    property Communication: TCommunicationBase read fCommunication write fCommunication;
  end;

var
  frm_Base: Tfrm_Base;

implementation

{$R *.dfm}

procedure Tfrm_Base.FormCreate(Sender: TObject);
begin
  fCommunication := nil;
end;

procedure Tfrm_Base.FormDestroy(Sender: TObject);
begin //

end;

end.
