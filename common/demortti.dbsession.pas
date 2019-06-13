{*******************************************************}
{                                                       }
{  Zlot programistów Delphi                             }
{  RTTI w Delph                                         }
{  Sylwester Wojnar                                     }
{                                                       }
{  Mszczonów 2019                                       }
{*******************************************************}


unit demortti.dbsession;
{$SCOPEDENUMS ON}

interface
  uses System.Generics.Collections, data.db, System.SysUtils, System.TypInfo, System.rtti,
     demortti.db;

type

  IDBSession = interface
  ['{946792ED-A50E-4FFB-A668-494592FABC7D}']
    procedure OpenConnection();
    procedure CloseConnection();
    function Connected(): Boolean;

    function CreateQuery(ASQLText: String): TDataSet;
    procedure ExecuteSQL(ASQLText: String);

    procedure BeginTran();
    procedure CommitTran();
    procedure RollbackTran();
  end;

  IDataController = interface
  ['{318F1D2F-1183-4B60-A3C6-9BB2F70A714C}']
    function GetSession: IDBSession;
    procedure SetSession(const Value: IDBSession);
    property Session: IDBSession read GetSession write SetSession;

    procedure CreateTableIfNotExists(AClass: TClass);
    procedure DropTable(AClass: TClass);

    procedure Persist(AObject: TObject);
  end;


  TCustomDataController = class(TInterfacedObject, IDataController)
  private
    FSession: IDBSession;
  protected
    function GetObject(AClass: TClass; AKey: TArray<TValue>): TObject; virtual;
    function GetSession: IDBSession;
    procedure SetSession(const Value: IDBSession);
  public
    procedure CreateTableIfNotExists(AClass: TClass); virtual; abstract;
    procedure DropTable(AClass: TClass);
    procedure Persist(AObject: TObject); virtual; abstract;
    function Get<T: Class>(const AKey: TArray<TValue>): T;
  public
    property Session: IDBSession read GetSession write SetSession;
  end;


  TSQLEngine = (ORACLE, MSSQL, POSTGRESQL, INTERBASE);

  DataController = class(TCustomAttribute)
  private
    FSQLEngine: TSQLEngine;
  public
    property SQLEngine: TSQLEngine read FSQLEngine write FSQLEngine;
    constructor Create(ASQLEngine: TSQLEngine);
  end;

  TDataContext = class
  public
    class function CreateSession(const ASessionName: String): IDBSession;
    class function CreateController(ASQLLialect: TSQLEngine): TCustomDataController;
  end;

  function AddStr(const ASurce: string; const AValue: String; ASeperator: string = ','): string;

implementation

  function AddStr(const ASurce: string; const AValue: String; ASeperator: string = ','): string;
  begin
    Result := ASurce;
    if (Result <> '') then
      Result := Result + ASeperator;
    Result := Result + AValue;
  end;

class function TDataContext.CreateController(
  ASQLLialect: TSQLEngine): TCustomDataController;
var
  LContext: TRttiContext;
  iMethod: TRttiMethod;
  LObj: TValue;
  iTyp: TRttiType;
  iAttrib: TCustomAttribute;
begin
  for iTyp in LContext.GetTypes do begin
    if (iTyp.IsInstance) then begin
      for iAttrib in iTyp.GetAttributes do begin
        if (iAttrib is DataController)
           and  (DataController(iAttrib).SQLEngine = ASQLLialect) then begin
           Result :=  TRttiInstanceType(iTyp).MetaclassType.Create as TCustomDataController;
           Exit;
        end;
      end;
    end;
  end;
  Result := nil;
end;


class function TDataContext.CreateSession(const ASessionName: String): IDBSession;
var
  LContext: TRttiContext;
  LType: TRttiType;
  imt: TRttiMethod;
  LObj: TValue;
begin
  LType := LContext.FindType(ASessionName);

  if (not Assigned(LType)) then
    raise Exception.CreateFmt('Type %s not found', [ASessionName]);

  if (LType.IsInstance) then begin
    for imt in TRttiInstanceType(LType).GetMethods do begin
      if (imt.IsConstructor) then begin
        LObj := imt.Invoke(TRttiInstanceType(LType).MetaclassType, []);

        if  (LObj.AsObject.GetInterface(IDBSession, Result)) then;
          Exit;
        LObj.AsObject.Free;
      end;
    end;
  end;

 raise Exception.CreateFmt('Type %s is incorrect.', [ASessionName]);
end;

{ DataController }

constructor DataController.Create(ASQLEngine: TSQLEngine);
begin
  FSQLEngine := ASQLEngine;
end;

{ TCustomDataControler }

procedure TCustomDataController.DropTable(AClass: TClass);
var
  LSQL: string;
begin
  LSQL := Format('drop table %s', [AClass.ClassName]);
  FSession.ExecuteSQL(LSQL);
end;

function TCustomDataController.Get<T>(const AKey: TArray<TValue>): T;
begin
  Result :=  GetObject(T, AKey) as T;
end;


function TCustomDataController.GetObject(AClass: TClass; AKey: TArray<TValue>): TObject;
var
  LContext: TRttiContext;
  LType: TRttiType;
  iprop: TRttiProperty;
  LQry: TDataSet;
  LFld: TField;
  lenumVal: Integer;
  LValue: TValue;
  LSType: string;
  LWhere: string;
  iatt: TCustomAttribute;
  LFieldAtrribute: DBField;
  i: Integer;
  LCnd: string;
begin
  Result := nil;
  LContext := TRttiContext.Create;
  try
    LType := LContext.GetType(AClass);
    Result := nil;
    LWhere := '';
    for iprop in LType.GetProperties do begin
      LSType := '';
      for iatt in iprop.GetAttributes do begin
        if (iatt is DBField) then begin
          LFieldAtrribute := DBField(iatt);
          if (LFieldAtrribute.PrimaryKeyPos > 0) then begin
            if (LFieldAtrribute.PrimaryKeyPos > Length(AKey)) then begin
              raise Exception.Create('Incorrect key value');
            end;

            LValue := AKey[LFieldAtrribute.PrimaryKeyPos-1];
            case (LValue.Kind) of
              tkUString: LCnd := Format('''%s''', [LValue.AsString]);
              tkInteger: LCnd := Format('%d', [LValue.AsInteger]);
            end;
            LWhere := AddStr(LWhere, Format('%s=%s', [iprop.Name, LCnd]), ' and ');
          end;
        end;
      end;
    end;

    LQry := Session.CreateQuery(Format('select * from %s where %s', [AClass.ClassName, LWhere]));
    LQry.Open;
    if (LQry.Eof) then
      Exit;

    Result := AClass.Create;
    for iprop in LType.GetProperties do begin
      LFld := LQry.FindField(iprop.Name);
      if Assigned(LFld) then begin
        case iprop.PropertyType.TypeKind of
          tkUString: iprop.SetValue(Result, LFld.AsString);
          tkInteger: iprop.SetValue(Result, LFld.AsInteger);
          tkEnumeration: begin
            lenumVal := GetEnumValue(iprop.PropertyType.Handle, LFld.AsString);
            if (lenumVal = -1) then
              lenumVal := 0;

            TValue.Make(@lenumVal, iprop.PropertyType.Handle, LValue);
            iprop.SetValue(Result, LValue);
          end;
        end;
      end;
    end;
  finally
    LContext.Free;
  end;
end;

function TCustomDataController.GetSession: IDBSession;
begin
  Result := FSession;
end;

procedure TCustomDataController.SetSession(const Value: IDBSession);
begin
 FSession := Value;
end;

end.
