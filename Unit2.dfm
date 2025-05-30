object MainForm: TMainForm
  Left = 0
  Top = 0
  Align = alClient
  Caption = 'POS Terminal'
  ClientHeight = 471
  ClientWidth = 784
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object MainPanel: TPanel
    Left = 0
    Top = 0
    Width = 784
    Height = 471
    Align = alClient
    Caption = 'Panel1'
    TabOrder = 0
    object ProductsPanel: TPanel
      Left = 1
      Top = 30
      Width = 500
      Height = 404
      Align = alLeft
      TabOrder = 0
      object Label1: TLabel
        Left = 240
        Top = 112
        Width = 47
        Height = 15
        Caption = 'Products'
      end
      object ProductListView: TListView
        Left = 1
        Top = 1
        Width = 498
        Height = 402
        Align = alClient
        Columns = <
          item
            Caption = 'Name'
          end
          item
            Caption = 'Price'
          end
          item
            Caption = 'Image'
          end>
        GridLines = True
        ReadOnly = True
        RowSelect = True
        TabOrder = 0
        ViewStyle = vsReport
        OnClick = btnLoadProductsClick
      end
      object btnLoadProducts: TButton
        Left = 216
        Top = 192
        Width = 75
        Height = 25
        Caption = 'Load Products'
        TabOrder = 1
        OnClick = btnLoadProductsClick
      end
    end
    object CartPanel: TPanel
      Left = 501
      Top = 30
      Width = 282
      Height = 404
      Align = alClient
      TabOrder = 1
      object Cart: TLabel
        Left = 72
        Top = 200
        Width = 22
        Height = 15
        Caption = 'Cart'
      end
      object CartListView: TListView
        Left = 1
        Top = 1
        Width = 280
        Height = 402
        Align = alClient
        Columns = <
          item
            Caption = 'Name'
          end
          item
            Caption = 'Qty'
          end
          item
            Caption = 'Price'
          end
          item
            Caption = 'Total'
          end>
        TabOrder = 0
        ViewStyle = vsReport
      end
    end
    object StatusBar1: TStatusBar
      Left = 1
      Top = 451
      Width = 782
      Height = 19
      Panels = <
        item
          Text = 'Ready'
          Width = 50
        end
        item
          Text = 'Ready'
          Width = 50
        end>
    end
    object ProgressBar1: TProgressBar
      Left = 1
      Top = 434
      Width = 782
      Height = 17
      Align = alBottom
      TabOrder = 3
      Visible = False
    end
    object ToolBar1: TToolBar
      Left = 1
      Top = 1
      Width = 782
      Height = 29
      Caption = 'ToolBar1'
      TabOrder = 4
      object Load: TToolButton
        Left = 0
        Top = 0
        Caption = 'Load'
        ImageIndex = 0
      end
      object Add: TToolButton
        Left = 23
        Top = 0
        Caption = 'Add'
        ImageIndex = 1
      end
      object Print: TToolButton
        Left = 46
        Top = 0
        Caption = 'Print'
        ImageIndex = 2
      end
    end
  end
end
