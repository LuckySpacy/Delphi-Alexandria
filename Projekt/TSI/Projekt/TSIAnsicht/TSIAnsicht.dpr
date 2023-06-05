program TSIAnsicht;

uses
  Vcl.Forms,
  Form.TSIAnsicht in 'Form\Form.TSIAnsicht.pas' {frm_TSIAnsicht},
  API.Base in 'API\API.Base.pas',
  Communication.Base in 'Communication\Communication.Base.pas',
  Form.Base in 'Form\Form.Base.pas' {frm_Base},
  Form.RestTest in 'Form\Form.RestTest.pas' {frm_RestTest},
  Objekt.Ansicht in 'Objekt\Objekt.Ansicht.pas',
  Objekt.ObjektList in '..\Global\Objekt\Objekt.ObjektList.pas',
  Objekt.AnsichtList in 'Objekt\Objekt.AnsichtList.pas',
  Objekt.Basislist in '..\Global\Objekt\Objekt.Basislist.pas',
  Form.TSI2 in 'Form\Form.TSI2.pas' {frm_TSI2},
  Json.AnsichtList in '..\Global\Json\Json.AnsichtList.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tfrm_TSIAnsicht, frm_TSIAnsicht);
  Application.Run;
end.
