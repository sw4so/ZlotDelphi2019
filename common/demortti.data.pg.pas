{*******************************************************}
{                                                       }
{  Zlot programistów Delphi                             }
{  RTTI w Delph                                         }
{  Sylwester Wojnar                                     }
{                                                       }
{  Mszczonów 2019                                       }
{*******************************************************}

unit demortti.data.pg;


interface
uses
  System.SysUtils, System.Classes, data.db, System.Rtti, System.TypInfo,
  System.Generics.Collections, demortti.dbsession, demortti.db;

type
  [DataController(TSQLEngine.POSTGRESQL)]
  TPGController = class(TCustomDataController)
  private
  protected
  public
    procedure CreateTableIfNotExists(AClass: TClass); override;
    procedure Persist(AObject: TObject); override;
  end;

implementation

 { przyk³adowy kod SQL
     CREATE TABLE tvehicle (
        id SERIAL,
        vin VARCHAR(17),
        color VARCHAR(8),
        kind VARCHAR(8),
      CONSTRAINT PRIMARY KEY(id)
     )
 }


{ TPGController }

procedure TPGController.CreateTableIfNotExists(AClass: TClass);
var
  LContext: TRttiContext;
  LType: TRttiType;
  iprop: TRttiProperty;

  LPrimaryKey: TDictionary<Integer, String>;
  LFieldAtrribute: DBField;
  i: Integer;

  LSType: string;
  LSFields: string;
  LSQL: TStrings;
  iatt: TCustomAttribute;
  FSPrimaryKey: string;
begin
  LSQL := TStringList.Create;
  LContext := TRttiContext.Create;
  LPrimaryKey := TDictionary<Integer, String>.Create();
  try
    LSFields := '';
    LType := LContext.GetType(AClass);
    for iprop in LType.GetProperties do begin
      LSType := '';

      LFieldAtrribute := nil;
      for iatt in iprop.GetAttributes do begin
        if (iatt is DBField) then begin
          LFieldAtrribute := DBField(iatt);
          if (LFieldAtrribute.PrimaryKeyPos > 0) then
            LPrimaryKey.Add(LFieldAtrribute.PrimaryKeyPos, iprop.Name);
          Break;
        end;
      end;

      if Assigned(LFieldAtrribute) and (LFieldAtrribute.DataType <> TDataType.Undefined) then begin
        case (LFieldAtrribute.DataType) of
          TDataType.AutoInc: LSType := 'serial';
          TDataType.Integer: LSType := 'integer';
          TDataType.Boolean: LSType := 'boolean';
          TDataType.Varchar: LSType := Format('varchar(%d)', [LFieldAtrribute.Length]);
        end;
      end
      else begin
        case iprop.PropertyType.TypeKind of
          tkString, tkUString: begin
            LSType := 'varchar';
            if (Assigned(LFieldAtrribute)) and (LFieldAtrribute.Length > 0) then
               LSType := Format('varchar(%d)', [LFieldAtrribute.Length]);
          end;
          tkInteger: LSType := 'integer';
          tkEnumeration: begin
            LSType := 'varchar';
            if (iprop.PropertyType.Handle = TypeInfo(Boolean)) then
              LSType := 'boolean';
          end;
        end;
      end;

      if (LSType <> '') then begin
        if (LSFields <> '') then
          LSFields := LSFields + ',' + sLineBreak;

        LSFields := LSFields + Format('  %s %s', [iprop.Name, LSType])
      end;
    end;

    FSPrimaryKey := '';
    for i := 1 to LPrimaryKey.Count do
      FSPrimaryKey := AddStr(FSPrimaryKey, LPrimaryKey[i]);

    LSQL.Add(Format('CREATE TABLE IF NOT EXISTS %s(', [AClass.ClassName]));
    LSQL.Add(LSFields);
    if (FSPrimaryKey <> '') then begin
      LSQL.Add(',');
      LSQL.Add(Format('PRIMARY KEY (%s)', [FSPrimaryKey]))
    end;
    LSQL.Add(');');
    Session.ExecuteSQL(LSQL.Text);
  finally
    LSQL.Free;
    LContext.Free;
    LPrimaryKey.Free;
  end;
end;

procedure TPGController.Persist(AObject: TObject);
var
  LContext: TRttiContext;
  LType: TRttiType;
  iprop: TRttiProperty;
  LSType: string;
  LSFields: string;
  LSValues: string;
  LSQL: TStrings;
  LVal: TValue;
  lsval: string;
  LSQLText: string;
  iatt: TObject;
  LFieldAttribute: DBField;
begin
  LContext := TRttiContext.Create;
  LSQL := TStringList.Create;
  try
    LType := LContext.GetType(AObject.ClassType);
    LSFields := '';
    LSValues := '';

    for iprop in LType.GetProperties do begin
      LSType := '';
      LVal := iprop.GetValue(AObject);
      lsval := '';

      LFieldAttribute := nil;
      for iatt in iprop.GetAttributes do begin
        if (iatt is DBField) then begin
          LFieldAttribute := DBField(iatt);
          Break;
        end;
      end;

      if (Assigned(LFieldAttribute) and  (LFieldAttribute.DataType = TDataType.AutoInc)) then
        Continue;

      case iprop.PropertyType.TypeKind of
        tkString, tkUString: begin
          LSFields := AddStr(LSFields, iprop.Name);
          LSValues := AddStr(LSValues, Format('''%s''', [LVal.AsString]));
        end;
        tkInteger: begin
          LSFields := AddStr(LSFields, iprop.Name);
          LSValues := AddStr(LSValues, IntToStr(LVal.AsInteger));
        end;
        tkEnumeration: begin
          LSFields := AddStr(LSFields, iprop.Name);
          LSValues := AddStr(LSValues, ''''
            +  GetEnumName(iprop.PropertyType.Handle, LVal.AsOrdinal)
            + '''');
        end;
      end;
    end;

    LSQLText := Format('INSERT INTO %s(%s) values(%s)', [AObject.ClassName, LSFields, LSValues]);
    Session.ExecuteSQL(LSQLText);
  finally
    LSQL.Free;
    LContext.Free;
  end;
end;

end.
