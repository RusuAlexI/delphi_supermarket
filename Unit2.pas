unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ToolWin, Vcl.Imaging.pngimage,
  Vcl.Imaging.jpeg;

type
  TProduct = record
    ID: Integer;
    Name: string;
    Price: Double;
    ImageFileName: string;
  end;

var
  ProductList: array of TProduct;

type
  TMainForm = class(TForm)
    MainPanel: TPanel;
    ProductsPanel: TPanel;
    CartPanel: TPanel;
    Label1: TLabel;
    ProductListView: TListView;
    Cart: TLabel;
    CartListView: TListView;
    StatusBar1: TStatusBar;
    ProgressBar1: TProgressBar;
    ToolBar1: TToolBar;
    Load: TToolButton;
    Add: TToolButton;
    Print: TToolButton;
    btnLoadProducts: TButton;

    procedure FormCreate(Sender: TObject);
    procedure btnLoadProductsClick(Sender: TObject);

  private
    procedure LoadProducts;
  public
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  // Optional: auto-load on start
  // LoadProducts;
end;

procedure TMainForm.btnLoadProductsClick(Sender: TObject);
begin
  LoadProducts;
end;

procedure TMainForm.LoadProducts;
var
  SL: TStringList;
  LineParts: TArray<string>;
  i: Integer;
  Product: TProduct;
  Item: TListItem;
  ImagePath: string;
begin
  SL := TStringList.Create;
  try
    if not FileExists('Data\products.csv') then
    begin
      ShowMessage('File "Data\products.csv" not found.');
      Exit;
    end;

    SL.LoadFromFile('Data\products.csv');
    SetLength(ProductList, SL.Count);
    ProductListView.Items.Clear;

    // Optional: set columns in code if not done in the form designer
    if ProductListView.Columns.Count = 0 then
    begin
      ProductListView.ViewStyle := vsReport;
      ProductListView.Columns.Add.Caption := 'Name';
      ProductListView.Columns.Add.Caption := 'Price';
      ProductListView.Columns.Add.Caption := 'Image';
    end;
  ShowMessage(ExtractFilePath(Application.ExeName));

    for i := 0 to SL.Count - 1 do
    begin
      LineParts := SL[i].Split([';']);
      if Length(LineParts) = 4 then
      begin
        Product.ID := StrToIntDef(LineParts[0], 0);
        Product.Name := LineParts[1];
        Product.Price := StrToFloatDef(LineParts[2], 0);
        Product.ImageFileName := LineParts[3];
        ProductList[i] := Product;

        Item := ProductListView.Items.Add;
        Item.Caption := Product.Name;
        Item.SubItems.Add(Format('%.2f', [Product.Price]));

        ImagePath := 'Images\' + Product.ImageFileName;
        if FileExists(ImagePath) then
          Item.SubItems.Add('[Image OK]')
        else
          Item.SubItems.Add('[Missing Image]');
      end;
    end;
  finally
    SL.Free;
  end;
end;

end.

