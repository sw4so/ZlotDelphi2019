{*******************************************************}
{                                                       }
{  Zlot programistów Delphi                             }
{  RTTI w Delph                                         }
{  Sylwester Wojnar                                     }
{                                                       }
{  Mszczonów 2019                                       }
{*******************************************************}


unit rttidemo.web.vehicles;

interface
uses
  System.SysUtils, demortti.vehicles, demortti.dbsession;

const
  RESPONSE_STATUS_SUCCESS        = 200;
  RESPONSE_STATUS_BAD_REQUEST    = 400;
  RESPONSE_STATUS_INVALID_USER   = 401;
  RESPONSE_STATUS_INTERNAL_ERROR = 500;

type


  TRestResutl = class
  private
    FMessage: string;
    FStatusCode: Integer;
  public
    property StatusCode: Integer read FStatusCode write FStatusCode;
    property Message: string read FMessage write FMessage;
  end;

  TVehicles = class
  private
  public
    function Add(const Vin: String): TRestResutl;
    function Get(const Id: Integer): TVehicle;
  end;

implementation

{ TVehicles }

function TVehicles.Add(const Vin: String): TRestResutl;
var
  LSession: IDBSession;
  LController: TCustomDataController;
  LVehicle: TVehicle;
begin
  Result := TRestResutl.Create;
  Result.StatusCode := RESPONSE_STATUS_SUCCESS;
  try
    LSession := TDataContext.CreateSession('demortti.dbsession.fd.TFDSession');
    LSession.OpenConnection();

    LController := TDataContext.CreateController(TSQLEngine.POSTGRESQL);
    LVehicle := TVehicle.Create;
    try
      LController.Session := LSession;
      LVehicle.Vin := Vin;
      LController.Persist(LVehicle);
    finally
      LVehicle.Free();
      LController.Free();
    end;
  except
    on e: Exception do begin
      Result.StatusCode := RESPONSE_STATUS_INTERNAL_ERROR;
    end;
  end;
end;

function TVehicles.Get(const Id: Integer): TVehicle;
var
  LSession: IDBSession;
  LController: TCustomDataController;
begin
  LSession := TDataContext.CreateSession('demortti.dbsession.fd.TFDSession');
  LSession.OpenConnection();
  LController := TDataContext.CreateController(TSQLEngine.POSTGRESQL);
  try
    LController.Session := LSession;
    Result := LController.Get<TVehicle>([Id]);
  finally
    LController.Free;
  end;
end;

initialization
  TVehicles.Create.Free;

end.
