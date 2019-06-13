{*******************************************************}
{                                                       }
{  Zlot programistów Delphi                             }
{  RTTI w Delph                                         }
{  Sylwester Wojnar                                     }
{                                                       }
{  Mszczonów 2019                                       }
{*******************************************************}

unit WebModuleUnit1;

interface

uses
  System.SysUtils, System.Classes, Web.HTTPApp, System.RTTI,
  System.JSON, Rest.Json;

type
  TWebModule1 = class(TWebModule)
    procedure WebModule1DefaultHandlerAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  WebModuleClass: TComponentClass = TWebModule1;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TWebModule1.WebModule1DefaultHandlerAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);


var
  LContext: TRttiContext;
  lRequestParam: string;
  LResult: TValue;
  LJson: TJSONObject;

  function _GetHandlerClass(AName: String): TClass;
  var
    it: TRttiType;
  begin
    for it in LContext.GetTypes() do begin
      if (it.IsInstance and (CompareText('T' + AName, it.Name )= 0)) then begin
        Result := TRttiInstanceType(it).MetaclassType;
        Exit;
      end;
    end;
    Result := nil;
  end;

var
  lPath: TStrings;
  LHandlerClass: TClass;
  LHandler: TObject;
  LTypeInfo: TRttiType;
  LMethod: TRttiMethod;
  i: Integer;
  ipar: TRttiParameter;
  LInvokeParams: TArray<TValue>;
begin
  //Klasa/Metoda
  lPath := TStringList.Create;
  try
    lPath.LineBreak := '/';
    lPath.Text := Request.PathInfo;

    if (lPath.Count < 3) then
       Exit;

    LHandlerClass := _GetHandlerClass(lPath[1]);

    if (LHandlerClass = nil) then
      Exit;

    LHandler := LHandlerClass.Create;
    LTypeInfo := LContext.GetType(LHandlerClass);

    LMethod := LTypeInfo.GetMethod(lPath[2]);

    if (LMethod = nil) then
       Exit;

    SetLength(LInvokeParams, Length(LMethod.GetParameters));

    for i := 0 to Length(LMethod.GetParameters) - 1 do begin
      ipar := LMethod.GetParameters[i];
      lRequestParam := Request.ContentFields.Values[ipar.Name];
      case ipar.ParamType.TypeKind of
        tkInteger: LInvokeParams[i] := StrToIntDef(lRequestParam, 0);
        tkUString: LInvokeParams[i] := lRequestParam;
      end;
    end;

    LResult := LMethod.Invoke(LHandler, LInvokeParams);
    if (LResult.IsObject) then begin
      LJson := TJson.ObjectToJsonObject(LResult.AsObject);
      Response.Content := LJson.ToString;
      LResult.AsObject.Free;
    end;

  finally
    lPath.Free;
  end;

end;

end.
