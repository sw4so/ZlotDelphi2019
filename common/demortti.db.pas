
{*******************************************************}
{                                                       }
{  Zlot programistów Delphi                             }
{  RTTI w Delph                                         }
{  Sylwester Wojnar                                     }
{                                                       }
{  Mszczonów 2019                                       }
{*******************************************************}

unit demortti.db;
{$SCOPEDENUMS ON}
interface
uses
  data.db;

type
  TDataType = (Undefined, AutoInc, Integer, Varchar, Boolean);

  DBField = class(TCustomAttribute)
  private
    FPrimaryKeyPos: Integer;
    FLength: Integer;
    FDataType: TDataType;
    FFieldName: String;
  public
    property FieldName: String read FFieldName;
    property PrimaryKeyPos: Integer read FPrimaryKeyPos;
    property Length: Integer read FLength;
    property DataType: TDataType read FDataType;
    constructor Create(
       const AFieldName: String;
       const APrimaryKeyPos: Integer;
       const ALength: Integer = 0;
       const ADataType: TDataType = TDataType.Undefined); overload;
    constructor Create(
       const APrimaryKeyPos: Integer;
       const ADataType: TDataType = TDataType.Undefined;
       const ALength: Integer = 0
       ); overload;
  end;

implementation

{ DDField }

constructor DBField.Create(const AFieldName: String;const APrimaryKeyPos, ALength: Integer;
 const  ADataType: TDataType);
begin
  FFieldName := AFieldName;
  FPrimaryKeyPos := APrimaryKeyPos;
  FLength := ALength;
  FDataType := ADataType;
end;

constructor DBField.Create(const APrimaryKeyPos: Integer;
  const ADataType: TDataType; const ALength: Integer);
begin
  FPrimaryKeyPos := APrimaryKeyPos;
  FLength := ALength;
  FDataType := ADataType;
end;

end.
