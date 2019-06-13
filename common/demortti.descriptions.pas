{*******************************************************}
{                                                       }
{  Zlot programistów Delphi                             }
{  RTTI w Delph                                         }
{  Sylwester Wojnar                                     }
{                                                       }
{  Mszczonów 2019                                       }
{*******************************************************}

unit demortti.descriptions;

interface
uses
 System.Classes;

type
  IDescription = interface
  ['{8CB83CF6-EE75-4B49-8CA8-DF684B0CE618}']
    function Get(const AName: String): String;
  end;

  Descriptor = class(TCustomAttribute)
  private
    FLanguage: String;
  public
    property Language: String read FLanguage;
    constructor Create(const ALanguage: string);
  end;


implementation

{ Descriptor }

constructor Descriptor.Create(const ALanguage: string);
begin
  FLanguage := ALanguage;
end;


end.
