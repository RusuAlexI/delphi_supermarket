object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'POS System'
  ClientHeight = 600
  ClientWidth = 900
  Position = poScreenCenter
  OnCreate = FormCreate
  object MainPanel: TPanel
    Align = alClient
    object ProductsPanel: TPanel
      Align = alLeft
      Width = 450
      Caption = 'Products'
      object ProductListView: TListView
        Align = alClient
        ViewStyle = vsReport
        Columns = <
          item Caption = 'Name' Width = 150 end
          item Caption = 'Price' Width = 80 end
          item Caption = 'Image' Width = 150 end>
      end
    end
    object CartPanel: TPanel
      Align = alRight
      Width = 450
      Caption = 'Cart'
      object CartListView: TListView
        Align = alClient
        ViewStyle = vsReport
        Columns = <
          item Caption = 'Product' Width = 150 end
          item Caption = 'Quantity' Width = 80 end
          item Caption = 'Total' Width = 100 end>
      end
    end
  end
  object ToolBar1: TToolBar
    Align = alTop
    ShowCaptions = True
    object Load: TToolButton
      Caption = 'Load'
    end
    object Add: TToolButton
      Caption = 'Add'
      OnClick = AddClick
    end
    object Print: TToolButton
      Caption = 'Print'
    end
  end
  object btnLoadProducts: TButton
    Caption = 'Load Products'
    Left = 20
    Top = 550
    Width = 120
    OnClick = btnLoadProductsClick
  end
  object StatusBar1: TStatusBar
    Align = alBottom
    Panels = <
      item Width = 200 Text = 'Ready' end>
  end
  object Remove: TToolButton
  Caption = 'Remove'
  OnClick = RemoveClick
end
  object ProgressBar1: TProgressBar
    Left = 150
    Top = 555
    Width = 200
    Height = 16
    Visible = False
  end
end
