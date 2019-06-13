{*******************************************************}
{                                                       }
{  Zlot programistów Delphi                             }
{  RTTI w Delph                                         }
{  Sylwester Wojnar                                     }
{                                                       }
{  Mszczonów 2019                                       }
{*******************************************************}

unit fListViewer;
{$TYPEINFO OFF}

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  System.RTTI, System.TypInfo,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls;

type
  TfmListViewer = class(TForm)
    Panel1: TPanel;
    ListView1: TListView;
    Timer1: TTimer;
    StatusBar1: TStatusBar;
    procedure Timer1Timer(Sender: TObject);
  private
    class
      var FViewer: TfmListViewer;
    procedure AddLine(AText: TArray<String>);
  public
    { Public declarations }
    class procedure Add(AText: TArray<String>);
    class procedure ShowPropertyValues(AObject: TObject);
    class procedure Clear();
  end;


implementation

{$R *.dfm}

{ TfmListViewer }

class procedure TfmListViewer.Add(AText: TArray<String>);
begin
  if not Assigned(FViewer) then begin
    FViewer := Self.Create(Application);
  end;
  FViewer.AddLine(AText);
end;

procedure TfmListViewer.AddLine(AText: TArray<String>);
var
  i: Integer;
  lLvItem: TListItem;
  lW: Integer;
begin
  if (Timer1.Enabled) then begin
    Timer1.Enabled := False;
    Timer1.Enabled := True;
  end else begin
    Timer1.Enabled := True;
    ListView1.Clear();
    ListView1.Items.BeginUpdate();
  end;
  lLvItem := ListView1.Items.Add();
  lLvItem.Caption := AText[0];
  lW := ListView1.Canvas.TextWidth(lLvItem.Caption) + 50;
  if (ListView1.Columns[0].Width < lW) then
    ListView1.Columns[0].Width := lW;

  while (ListView1.Columns.Count < Length(AText)) do
    ListView1.Columns.Add;

  for i := 1 to Length(AText) - 1 do begin
    lLvItem.SubItems.Add(AText[i]);
    lW := ListView1.Canvas.TextWidth(AText[i])+50;
    if (ListView1.Columns[i].Width < lW) then
       ListView1.Columns[i].Width := lW;

  end;
  StatusBar1.Panels[0].Text := Format('Iloœæ elementów: %d', [ListView1.Items.Count]);
end;

class procedure TfmListViewer.Clear;
begin
  if Assigned(FViewer) then
    FViewer.ListView1.Clear;
end;

class procedure TfmListViewer.ShowPropertyValues(AObject: TObject);
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
        tkClass: ShowPropertyValues(LValue.AsObject);
      else
        LStrValue := Format('Unsupported type: %s', [iprop.PropertyType.Name]);
      end;
      Add([iprop.Name + ': ' + LStrValue]);
    end;
  finally
    LContext.Free;
  end;
end;

procedure TfmListViewer.Timer1Timer(Sender: TObject);
begin
  ListView1.Items.EndUpdate;
  Timer1.Enabled := False;
  Show();
end;

end.
