{*******************************************************}
{                                                       }
{  Zlot programistów Delphi                             }
{  RTTI w Delph                                         }
{  Sylwester Wojnar                                     }
{                                                       }
{  Mszczonów 2019                                       }
{*******************************************************}

unit demortti.vehicles;

interface
uses
  demortti.db;

type
  TColor = (Grean, Red, Yellow, Silver, Gold, Black);
  TVehicleType = (Car, Truck, Bus);

  TVehicle = class
  private
    FId: Integer;
    FVin: String;
    FBrand: String;
    FColor: TColor;
    FKind: TVehicleType;
    FNew: Boolean;
  public
    [DBField(1, TDataType.AutoInc)]
    property Id: Integer read FId write FId;
    [DBField(0, TDataType.Varchar, 32)]
    property Brand: String read FBrand write FBrand;
    [DBField(0, TDataType.Varchar, 17)]
    property Vin: String read FVin write FVin;
    [DBField(0, TDataType.Varchar, 8)]
    property Color: TColor read FColor write FColor;
    [DBField(0, TDataType.Varchar, 8)]
    property Kind: TVehicleType read FKind write FKind;
    property New: Boolean read FNew write FNew;
  end;

  TCustomer = class
  private
    FName: String;
    FId: Integer;
    FVehicles: TArray<TVehicle>;
  public
    property Id: Integer read FId write FId;
    property Name: String read FName write FName;
    property Vehicles: TArray<TVehicle> read FVehicles write FVehicles;
  end;

implementation


end.
