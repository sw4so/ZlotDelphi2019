{*******************************************************}
{                                                       }
{  Zlot programistów Delphi                             }
{  RTTI w Delph                                         }
{  Sylwester Wojnar                                     }
{                                                       }
{  Mszczonów 2019                                       }
{*******************************************************}

unit demortti.dbsession.fd;

interface
uses
  System.Classes, System.SysUtils, Data.DB,
  FireDAC.Phys.Intf, FireDAC.Phys.SQLGenerator, FireDAC.Stan.Option,
  FireDAC.Comp.Client, demortti.dbsession;

type

  TFDSession = class(TInterfacedObject, IDBSession)
  private
    FConnection: TFDConnection;
    FLogFileName: String;
  protected
    procedure OpenConnection();
    procedure CloseConnection();
    function CreateQuery(ASQLText: String): TDataSet;
    procedure ExecuteSQL(ACmd: String);
    procedure BeginTran();
    procedure CommitTran();
    procedure RollbackTran();
    function Connected(): Boolean;
    procedure WriteToLog(AText: String);

  public
    constructor Create();
    destructor Destroy; override;
    property LogFileName: String read FLogFileName write FLogFileName;
  end;

implementation

{ TDFSession }

procedure TFDSession.BeginTran;
begin
  FConnection.StartTransaction();
end;

procedure TFDSession.CloseConnection;
begin
  FConnection.Close;
end;

procedure TFDSession.CommitTran;
begin
  FConnection.Commit();
end;

constructor TFDSession.Create();
begin
  inherited;
  FConnection := TFDConnection.Create(nil);
  FLogFileName := 'sql.log';
end;

function TFDSession.CreateQuery(ASQLText: String): TDataSet;
begin
  Result := TFDQuery.Create(FConnection);
  TFDQuery(Result).SQL.Text := ASQLText;
  TFDQuery(Result).Connection := FConnection;
  WriteToLog('=====================================================');
  WriteToLog(ASQLText);
end;

destructor TFDSession.Destroy;
begin
  if (FConnection.Connected) then
    CloseConnection();
  FConnection.Free;
  inherited;
end;

procedure TFDSession.ExecuteSQL(ACmd: String);
var
  LCmd: TFDCommand;
begin
  inherited;
  LCmd := TFDCommand.Create(FConnection);
  try
    LCmd.Connection := FConnection;
    LCmd.CommandText.Text := ACmd;
    LCmd.Execute();
    WriteToLog('=====================================================');
    WriteToLog(ACmd);
  finally
    LCmd.Free;
  end;
end;


function TFDSession.Connected: Boolean;
begin
  Result := FConnection.Connected;
end;

procedure TFDSession.OpenConnection;
var
  LS: TStrings;
begin
  LS := TStringList.Create;
  LS.LoadFromFile('demo.ini');
  FConnection.DriverName := 'PG';
  //FConnection.ConnectionName :=
  FConnection.Params.Password := LS.Values['password'];
  FConnection.Params.UserName := LS.Values['UserName'];
  FConnection.Params.Database := LS.Values['Database'];
  FConnection.Open();
end;

procedure TFDSession.RollbackTran;
begin
  FConnection.Rollback();
end;

procedure TFDSession.WriteToLog(AText: String);
var
  LAnsiTxt: AnsiString;
  oFS: TFileStream;
begin
  if (not FileExists(LogFileName)) then begin
    with TFileStream.Create(LogFileName, fmCreate) do
       Free;
  end;
  {$WARNINGS OFF}
  LAnsiTxt := AText;
  {$WARNINGS ON}
  oFS := TFileStream.Create(LogFileName, fmOpenWrite or fmShareDenyWrite);
  try
    oFS.Seek(0, soFromEnd);
    oFS.Write(PAnsiChar(LAnsiTxt)^, Length(LAnsiTxt));
  finally
    oFS.Free;
  end;
end;

end.
