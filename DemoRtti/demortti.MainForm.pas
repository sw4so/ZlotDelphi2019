{*******************************************************}
{                                                       }
{  Zlot programistów Delphi                             }
{  RTTI w Delph                                         }
{  Sylwester Wojnar                                     }
{                                                       }
{  Mszczonów 2019                                       }
{*******************************************************}

unit demortti.MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  System.RTTI, System.TypInfo, demortti.descriptions, demortti.vehicles;

type
  TfMainFrom = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Test: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure TestClick(Sender: TObject);
  private
    { Private declarations }
    procedure ShowValues(const AObject: TObject);
    procedure ListProps(AClass: TClass);
  public
  end;

  TFruit4 = class

  end;

var
  fMainFrom: TfMainFrom;

implementation
uses
  demortti.classes, demortti.dbsession, fListViewer;

{$R *.dfm}

procedure TfMainFrom.Button1Click(Sender: TObject);
var
  LContext: TRttiContext;
  LRttiType: TRttiType;
  it: TRttiProperty;
begin
  TfmListViewer.Clear;
  LContext := TRttiContext.Create;
  try
    LRttiType := LContext.GetType(TFruit);
    for it in LRttiType.GetProperties do begin
      TfmListViewer.Add([it.Name, it.PropertyType.Name]);
    end;
  finally
    LContext.Free;
  end;
end;

procedure TfMainFrom.ListProps(AClass: TClass);
var
  LContext: TRttiContext;
  LTypeInfo: TRttiType;
  it: TRttiProperty;
begin
  TfmListViewer.Clear;
  LContext := TRttiContext.Create;
  try
    LTypeInfo := LContext.GetType(TFruit);
    for it in LTypeInfo.GetProperties do begin
      TfmListViewer.Add([it.Name, it.PropertyType.Name]);
    end;
  finally
    LContext.Free;
  end;
end;

procedure TfMainFrom.Button2Click(Sender: TObject);
var
  LFruet: TFruit;
begin
  LFruet := TFruit.Create;
  try
    LFruet.Name := 'Jab³ko';
    LFruet.Weight := 200;
    LFruet.SugarContent := 10;
    LFruet.Price := 3.51;
    LFruet.Colour := TFruitColor.Red;
    ShowValues(LFruet);
  finally
    LFruet.Free;
  end;
end;

procedure TfMainFrom.Button4Click(Sender: TObject);
var
  LContext: TRttiContext;
  it: TRttiType;
begin
  TfmListViewer.Clear;
  LContext := TRttiContext.Create;
  try
    for it in LContext.GetTypes do begin
      if (CompareText('TFruit', it.Name) = 0) then
        TfmListViewer.Add([it.Name]);
    end;
  finally
    LContext.Free;
  end;
end;

procedure TfMainFrom.Button5Click(Sender: TObject);
var
  LContext: TRttiContext;
  it: TRttiType;
begin
  TfmListViewer.Clear;
  LContext := TRttiContext.Create;
  try
    it := LContext.FindType('demortti.classes.TFruit');
    if (Assigned(it)) then
      TfmListViewer.Add([it.Name]);
  finally
    LContext.Free;
  end;
end;

procedure TfMainFrom.Button6Click(Sender: TObject);
var
  LContext: TRttiContext;
  it: TRttiType;
  LPackageName: string;
  LUnitName: string;
begin
  LContext := TRttiContext.Create;
  try
    for it in LContext.GetTypes() do begin
      if (it.TypeKind = tkClass) then begin
        LPackageName := ExtractFileName(it.Package.Name);
        if (CompareText('RttiCommon.bpl', LPackageName) = 0) then begin
          case it.TypeKind of
            tkUnknown: ;
            tkInteger: ;
            tkChar: ;
            tkEnumeration: ;
            tkFloat: ;
            tkString: ;
            tkSet: ;
            tkClass: ;
            tkMethod: ;
            tkWChar: ;
            tkLString: ;
            tkWString: ;
            tkVariant: ;
            tkArray: ;
            tkRecord: ;
            tkInterface: ;
            tkInt64: ;
            tkDynArray: ;
            tkUString: ;
            tkClassRef: ;
            tkPointer: ;
            tkProcedure: ;
            tkMRecord: ;
          end;

         LUnitName := '';
         if (it.IsInstance) then
            LUnitName := TRttiInstanceType(it).DeclaringUnitName;

          TfmListViewer.Add([it.Name,
             LUnitName,
             it.Package.Name]);
         end
     end;
    end;
  finally
    LContext.Free;
  end;
end;

procedure TfMainFrom.TestClick(Sender: TObject);
var
  LContext: TRttiContext;
  LPlantTypeInfo: TRttiType;
  it: TRttiProperty;
  LStrValue: string;
  LValue: TValue;
  LCart: demortti.classes.TCrat;
  lPlants: TArray<TPlant>;
begin
  LCart := TCrat.Create;
  SetLength(lPlants, 4);


  lPlants[0] := TFruit.Create;
  lPlants[0].Name := 'Jab³ko';
  lPlants[0].Weight := 100;


  lPlants[1] := TFruit.Create;
  lPlants[1].Name := 'Œliwka';
  lPlants[1].Weight := 34;

  lPlants[2] := TFruit.Create;
  lPlants[2].Name := 'Gruszka';
  lPlants[2].Weight := 120;

  lPlants[3] := TPlant.Create;
  lPlants[3].Name := 'Ogólrek';
  lPlants[3].Weight := 120;
  LCart.Plants := lPlants;

  TfmListViewer.Clear;
  LContext := TRttiContext.Create;


  try
    LPlantTypeInfo := LContext.GetType(LCart.ClassType);
    for it in LPlantTypeInfo.GetProperties do begin

      LValue := it.GetValue(LCart);
      case it.PropertyType.TypeKind of
        tkUString: LStrValue := it.GetValue(lCart).AsString;
        tkInteger: LStrValue := IntToStr(it.GetValue(lCart).AsInteger);
        tkEnumeration: begin
                         LStrValue := GetEnumName(it.PropertyType.Handle, LValue.AsOrdinal);
                       end;
        tkDynArray: begin
                      TfmListViewer.Add([it.Name, InttoStr(LValue.GetArrayLength)]);
                    end

      else
        LStrValue := Format('Unsupported type: %s', [it.PropertyType.Name]);
      end;
      TfmListViewer.Add([it.Name + ': ' + LStrValue]);
    end;
  finally
    LContext.Free;
  end;
end;


procedure TfMainFrom.ShowValues(const AObject: TObject);
var
  LContext: TRttiContext;
  LRttiType: TRttiType;
  iprop: TRttiProperty;
  LStrValue: string;
  LValue: TValue;
  i: Integer;
  LArrayElement: TValue;
begin
  TfmListViewer.Clear;

  LContext := TRttiContext.Create;
  try
    LRttiType := LContext.GetType(AObject.ClassType);
    for iprop in LRttiType.GetProperties do begin
      LValue := iprop.GetValue(AObject);
      case iprop.PropertyType.TypeKind of
        tkString, tkUString, tkChar, tkWChar: LStrValue := LValue.AsString;
        tkInteger: LStrValue := IntToStr(LValue.AsInteger);
        tkEnumeration: LStrValue := GetEnumName(iprop.PropertyType.Handle, LValue.AsOrdinal);
        tkDynArray: begin
                      for i := 0 to  LValue.GetArrayLength - 1 do begin
                        LArrayElement := LValue.GetArrayElement(i);
                        //.....
                      end;
                    end;
        tkFloat: LStrValue := FloatToStr(LValue.AsExtended);
        tkClass: ShowValues(LValue.AsObject);
      else
        LStrValue := Format('Unsupported type: %s', [iprop.PropertyType.Name]);
      end;
      TfmListViewer.Add([iprop.Name + ': ' + LStrValue]);
    end;
  finally
    LContext.Free;
  end;
end;

end.
