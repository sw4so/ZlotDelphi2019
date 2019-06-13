{*******************************************************}
{                                                       }
{  Zlot programistów Delphi                             }
{  RTTI w Delph                                         }
{  Sylwester Wojnar                                     }
{                                                       }
{  Mszczonów 2019                                       }
{*******************************************************}


unit demortti.classes;
{$SCOPEDENUMS ON}
interface

type
  {$RTTI EXPLICIT PROPERTIES([vcPrivate, vcProtected, vcPublic])}
  TPlant = class
  private
    FName: String;
    FWeight: Integer;
    FProtectedPlantIndex: Integer;
    FPrivatePlantIndex: Integer;
    procedure SetName(const Value: String);
    procedure SetWeight(const Value: Integer);
  private
    FPrice: Currency;
    property PrivatePlantIndex: Integer read FPrivatePlantIndex write FPrivatePlantIndex;
  protected
    property ProtectedPlantIndex: Integer read FProtectedPlantIndex write FProtectedPlantIndex;
  public
    property Name: String read FName write SetName;
    property Weight: Integer read FWeight write SetWeight;
    property Price: Currency read FPrice write FPrice;
  end;

  TFruitColor = (Grean, Red, Yellow);

  TFruit = class(TPlant)
  private
    FSugarContent: Integer;
    FColour: TFruitColor;
    FProtectedFruitIndex: Integer;
    procedure SetSugarContent(const Value: Integer);
    procedure SetColour(const Value: TFruitColor);
  protected
    property ProtectedFruitIndex: Integer read FProtectedFruitIndex write FProtectedFruitIndex;
  public
    property SugarContent: Integer read FSugarContent write SetSugarContent;
    property Colour: TFruitColor read FColour write SetColour;
  end;

  TCrat = class
  private
    FPlants: TArray<TPlant>;
  public
    property Plants: TArray<TPlant> read FPlants write FPlants;
    destructor Destroy; override;
  end;

implementation


{ TPlant }

procedure TPlant.SetName(const Value: String);
begin
  FName := Value;
end;

procedure TPlant.SetWeight(const Value: Integer);
begin
  FWeight := Value;
end;

{ TFruet }

procedure TFruit.SetColour(const Value: TFruitColor);
begin
  FColour := Value;
end;

procedure TFruit.SetSugarContent(const Value: Integer);
begin
  FSugarContent := Value;
end;

{ TCrat }

destructor TCrat.Destroy;
var
  i: Integer;
begin
  for i := 0 to Length(FPlants) -1   do
    FPlants[i].Free;

  inherited;
end;

end.
