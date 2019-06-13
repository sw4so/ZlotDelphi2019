object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'MainForm'
  ClientHeight = 408
  ClientWidth = 800
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 113
    Height = 408
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      113
      408)
    object Button1: TButton
      Left = 8
      Top = 6
      Width = 99
      Height = 25
      Caption = 'Create Table'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button3: TButton
      Left = 8
      Top = 37
      Width = 99
      Height = 25
      Caption = 'Persist'
      TabOrder = 1
      OnClick = Button3Click
    end
    object Button4: TButton
      Left = 8
      Top = 370
      Width = 99
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = 'Drop Table'
      TabOrder = 2
      OnClick = Button4Click
    end
    object Button5: TButton
      Left = 8
      Top = 68
      Width = 99
      Height = 25
      Caption = 'Get '
      TabOrder = 3
      OnClick = Button5Click
    end
    object Button6: TButton
      Left = 8
      Top = 336
      Width = 99
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = 'Gen 10'
      TabOrder = 4
      OnClick = Button6Click
    end
    object SpinEditId: TSpinEdit
      Left = 11
      Top = 99
      Width = 96
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 5
      Value = 1
    end
  end
  object Panel2: TPanel
    Left = 113
    Top = 0
    Width = 687
    Height = 408
    Align = alClient
    BorderWidth = 5
    TabOrder = 1
    DesignSize = (
      687
      408)
    object Splitter1: TSplitter
      Left = 6
      Top = 204
      Width = 675
      Height = 3
      Cursor = crVSplit
      Align = alBottom
      ExplicitTop = 6
      ExplicitWidth = 396
    end
    object DBGrid1: TDBGrid
      Left = 6
      Top = 6
      Width = 675
      Height = 198
      Align = alClient
      DataSource = DataSource1
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
    end
    object Memo1: TMemo
      Left = 6
      Top = 207
      Width = 675
      Height = 154
      Align = alBottom
      Lines.Strings = (
        'select * from tvehicle')
      TabOrder = 1
    end
    object Panel3: TPanel
      Left = 6
      Top = 361
      Width = 675
      Height = 41
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 2
      object Button2: TButton
        Left = 0
        Top = 6
        Width = 75
        Height = 25
        Caption = 'Open SQL'
        TabOrder = 0
        OnClick = Button2Click
      end
    end
    object ListBox1: TListBox
      Left = 560
      Top = 305
      Width = 121
      Height = 97
      Anchors = [akRight, akBottom]
      ItemHeight = 13
      Items.Strings = (
        'ABARTH'
        'ALFA ROMEO'
        'ASTON MARTIN'
        'AUDI'
        'BENTLEY'
        'BMW'
        'BUICK'
        'CADILLAC'
        'CHEVROLET'
        'CHRYSLER'
        'CITROEN'
        'DACIA'
        'DODGE'
        'FIAT'
        'FORD'
        'GMC'
        'HARLEY-DAVIDSON'
        'HONDA'
        'HYUNDAI'
        'INFINITI'
        'IVECO'
        'JAGUAR'
        'KIA'
        'LAND ROVER'
        'LEXUS'
        'MASERATI'
        'MAYBACH'
        'MAZDA'
        'MEGA'
        'MERCEDES'
        'MERCURY'
        'MINI'
        'MITSUBISHI'
        'OPEL'
        'PEUGEOT'
        'PONTIAC'
        'PORSCHE'
        'RENAULT'
        'ROLLS ROYCE'
        'ROVER'
        'SEAT'
        'SKODA'
        'SUBARU'
        'SUZUKI'
        'TOYOTA'
        'VOLKSWAGEN'
        'VOLVO')
      TabOrder = 3
      Visible = False
    end
  end
  object DataSource1: TDataSource
    Left = 368
    Top = 112
  end
end
