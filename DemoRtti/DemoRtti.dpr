program DemoRtti;
{$M+}
{$TYPEINFO ON}

uses
  Vcl.Forms,
  demortti.MainForm in 'demortti.MainForm.pas' {fMainFrom},
  fListViewer in 'fListViewer.pas' {fmListViewer},
  demortti.FDModul in 'demortti.FDModul.pas' {DataModule2: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfMainFrom, fMainFrom);
  Application.CreateForm(TDataModule2, DataModule2);
  Application.Run;
end.
