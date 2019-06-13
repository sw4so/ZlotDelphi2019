{*******************************************************}
{                                                       }
{  Zlot programistów Delphi                             }
{  RTTI w Delph                                         }
{  Sylwester Wojnar                                     }
{                                                       }
{  Mszczonów 2019                                       }
{*******************************************************}

unit fMainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Data.DB, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, demortti.dbsession,  Vcl.Grids,
  Vcl.DBGrids, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Samples.Spin;

type
  TMainForm = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    DataSource1: TDataSource;
    Panel2: TPanel;
    DBGrid1: TDBGrid;
    Splitter1: TSplitter;
    Memo1: TMemo;
    Panel3: TPanel;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    ListBox1: TListBox;
    SpinEditId: TSpinEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
  private
    FSession: IDBSession;
    FController: TCustomDataController;
    procedure OpenSQL(ASqlTest: String);
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  MainForm: TMainForm;

implementation

uses
  demortti.vehicles, fListViewer;

{$R *.dfm}

{ TForm2 }

procedure TMainForm.Button1Click(Sender: TObject);
begin
  if (not FSession.Connected) then
    FSession.OpenConnection();

  FController.CreateTableIfNotExists(TVehicle);
  FController.CreateTableIfNotExists(TCustomer);
end;

procedure TMainForm.Button2Click(Sender: TObject);
begin
  OpenSQL(Memo1.Text);
end;

procedure TMainForm.Button3Click(Sender: TObject);
var
  lv: TVehicle;
begin
  if (not FSession.Connected) then
    FSession.OpenConnection();

  lv := TVehicle.Create;
  try
    lv.Vin := 'ZZZZ11112222444';
    lv.Brand := 'HONDA';
    lv.Color := TColor.Grean;
    lv.Kind := TVehicleType.Car;
    FController.Persist(lv);
  finally
    lv.Free;
  end;
end;

procedure TMainForm.Button6Click(Sender: TObject);

  function _RVin(): string;
  var
    lW: Integer;
  begin
    Result := '';
    while (Result.Length < 17)  do begin
      lW := Random(42);
      if (CharInSet(Chr(48 + lw), ['0'..'9', 'A'..'Z'])) then
        Result := Result +  Chr(48 + lw);
    end;
  end;

var
  lv: TVehicle;
  i: Integer;
begin
  if (not FSession.Connected) then
    FSession.OpenConnection();

  for i := 0 to 9 do begin

    lv := TVehicle.Create;
    try
      lv.Vin := _RVin;
      lv.Color := TColor(Random(5));
      lv.Kind := TVehicleType(Random(2));
      lv.Brand :=  ListBox1.Items[Random(ListBox1.Items.Count - 1)];
      lv.New := Random(2)= 0;
      FController.Persist(lv);
    finally
      lv.Free;
    end;
  end;
end;

procedure TMainForm.Button4Click(Sender: TObject);
begin
  if (not FSession.Connected) then
    FSession.OpenConnection();
  FController.DropTable(TVehicle);
end;

procedure TMainForm.Button5Click(Sender: TObject);
var
  LVehicle: TVehicle;
begin
  if (not FSession.Connected) then
    FSession.OpenConnection();

  LVehicle := FController.Get<TVehicle>([SpinEditId.Value]);
  try
  TfmListViewer.ShowPropertyValues(LVehicle);
  finally
    LVehicle.Free;
  end;
end;


constructor TMainForm.Create(AOwner: TComponent);
begin
  inherited;
  FSession := TDataContext.CreateSession('demortti.dbsession.fd.TFDSession');
  FController := TDataContext.CreateController(TSQLEngine.POSTGRESQL);
  FController.Session := FSession;
end;

procedure TMainForm.OpenSQL(ASqlTest: String);
var
  LQry: TDataSet;
  LLast: TDataSet;
begin
  if (not FSession.Connected) then
    FSession.OpenConnection();

  LQry := FSession.CreateQuery(ASqlTest);
  LQry.Open;
  LLast := nil;
  if (Assigned(DataSource1.DataSet)) then begin
    LLast := DataSource1.DataSet;
  end;
  DataSource1.DataSet := LQry;
  LLast.Free;
end;

end.
