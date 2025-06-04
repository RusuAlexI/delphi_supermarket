object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'POS System'
  ClientHeight = 600
  ClientWidth = 900
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 15
  object MainPanel: TPanel
    Left = 0
    Top = 29
    Width = 900
    Height = 552
    Align = alClient
    TabOrder = 0
    object ProductsPanel: TPanel
      Left = 1
      Top = 1
      Width = 450
      Height = 550
      Align = alLeft
      Caption = 'Products'
      TabOrder = 0
      object ProductListView: TListView
        Left = 1
        Top = 1
        Width = 448
        Height = 548
        Align = alClient
        Columns = <
          item
            Caption = 'Name'
            Width = 150
          end
          item
            Caption = 'Price'
            Width = 80
          end
          item
            Caption = 'Image'
            Width = 150
          end>
        LargeImages = ProductImageList
        TabOrder = 0
      end
    end
    object CartPanel: TPanel
      Left = 449
      Top = 1
      Width = 450
      Height = 550
      Align = alRight
      Caption = 'Cart'
      TabOrder = 1
      object CartListView: TListView
        Left = 1
        Top = 1
        Width = 448
        Height = 548
        Align = alClient
        Columns = <
          item
            Caption = 'Product'
            Width = 150
          end
          item
            Caption = 'Quantity'
            Width = 80
          end
          item
            Caption = 'Total'
            Width = 100
          end>
        TabOrder = 0
        ViewStyle = vsReport
      end
    end
  end
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 900
    Height = 29
    ButtonHeight = 23
    ButtonWidth = 33
    ShowCaptions = True
    TabOrder = 1
    object Load: TToolButton
      Left = 0
      Top = 0
      Caption = 'Load'
    end
    object Add: TToolButton
      Left = 33
      Top = 0
      Caption = 'Add'
    end
    object Print: TToolButton
      Left = 66
      Top = 0
      Caption = 'Print'
    end
    object RemoveBtn: TButton
      Left = 99
      Top = 0
      Width = 75
      Height = 23
      Caption = 'Remove'
      TabOrder = 1
    end
    object Recalc: TButton
      Left = 174
      Top = 0
      Width = 75
      Height = 23
      Caption = 'Recalculate'
      TabOrder = 0
      OnClick = RecalcClick
    end
  end
  object btnLoadProducts: TButton
    Left = 20
    Top = 550
    Width = 120
    Height = 25
    Caption = 'Load Products'
    TabOrder = 2
    OnClick = btnLoadProductsClick
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 581
    Width = 900
    Height = 19
    Panels = <
      item
        Text = 'Ready'
        Width = 200
      end>
  end
  object ProgressBar1: TProgressBar
    Left = 150
    Top = 555
    Width = 200
    Height = 16
    TabOrder = 4
    Visible = False
  end
  object ProductImageList: TImageList
    Height = 48
    Width = 48
    Left = 273
    Top = 182
  end
  object InactivityTimer: TTimer
    Interval = 60000
    Left = 545
    Top = 222
  end
end
