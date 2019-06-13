program DemoORM;

uses
  Vcl.Forms,
  fMainForm in 'fMainForm.pas' {MainForm},
  demortti.FDModul in '..\DemoRtti\demortti.FDModul.pas',
  fListViewer in '..\DemoRtti\fListViewer.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
