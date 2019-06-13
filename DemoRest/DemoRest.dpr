program DemoRest;
{$APPTYPE GUI}

uses
  Vcl.Forms,
  Web.WebReq,
  IdHTTPWebBrokerBridge,
  MainFormUnit in 'MainFormUnit.pas' {Form1},
  WebModuleUnit1 in 'WebModuleUnit1.pas' {WebModule1: TWebModule},
  rttidemo.web.vehicles in 'rttidemo.web.vehicles.pas',
  demortti.FDModul in '..\DemoRtti\demortti.FDModul.pas';

{$R *.res}

begin
  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := WebModuleClass;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
