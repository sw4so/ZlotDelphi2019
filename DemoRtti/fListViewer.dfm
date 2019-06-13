object fmListViewer: TfmListViewer
  Left = 0
  Top = 0
  Caption = 'Lista'
  ClientHeight = 592
  ClientWidth = 1135
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
    Width = 1135
    Height = 592
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 3
    TabOrder = 0
    object ListView1: TListView
      Left = 3
      Top = 3
      Width = 1129
      Height = 567
      Align = alClient
      Columns = <
        item
          Caption = 'Info'
        end>
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ReadOnly = True
      ParentFont = False
      TabOrder = 0
      ViewStyle = vsReport
    end
    object StatusBar1: TStatusBar
      Left = 3
      Top = 570
      Width = 1129
      Height = 19
      Panels = <
        item
          Width = 150
        end>
    end
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 552
    Top = 64
  end
end
