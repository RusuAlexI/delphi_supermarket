unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ToolWin, Vcl.Imaging.pngimage,
  Vcl.Imaging.jpeg, System.JSON, System.IOUtils, System.ImageList, Vcl.ImgList;

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
    Recalc: TButton;
    RemoveBtn: TButton;
    ProductImageList: TImageList;

    procedure FormCreate(Sender: TObject);
    procedure PrintClick(Sender: TObject);
    procedure btnLoadProductsClick(Sender: TObject);
    procedure CalculateTotal;
    procedure RemoveClick(Sender: TObject);
    procedure RecalcClick(Sender: TObject);

  private
    procedure LoadProducts;
    procedure AddClick(Sender: TObject);
  public
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

type
  TTotalCalculationThread = class(TThread)
  private
    FTotal: Double;
  protected
    procedure Execute; override;
    procedure UpdateUI;
  end;

  TLogThread = class(TThread)
  private
    FLogData: string;
  protected
    procedure Execute; override;
  public
    constructor Create(const AData: string);
  end;

constructor TLogThread.Create(const AData: string);
begin
  inherited Create(False); // Auto-start
  FreeOnTerminate := True;
  FLogData := AData;
end;

procedure TLogThread.Execute;
var
  LogFile: TextFile;
  LogPath: string;
begin
  LogPath := 'Logs';
  if not DirectoryExists(LogPath) then
    CreateDir(LogPath);

  AssignFile(LogFile, LogPath + '\sales.log');
  if FileExists(LogPath + '\sales.log') then
    Append(LogFile)
  else
    Rewrite(LogFile);

  try
    Writeln(LogFile, FormatDateTime('[yyyy-mm-dd hh:nn:ss] ', Now) + FLogData);
  finally
    CloseFile(LogFile);
  end;
end;

procedure TMainForm.CalculateTotal;
begin
  ProgressBar1.Visible := True;
  ProgressBar1.Position := 0;

  TThread.CreateAnonymousThread(
    procedure
    var
      I: Integer;
      Item: TListItem;
      Quantity: Integer;
      Price: Double;
      Total: Double;
    begin
      Total := 0;
      for I := 0 to CartListView.Items.Count - 1 do
      begin
        Item := CartListView.Items[I];
        Quantity := StrToIntDef(Item.SubItems[0], 0);  // Quantity
        Price := StrToFloatDef(Item.SubItems[1], 0);   // Price
        Total := Total + Quantity * Price;
        Sleep(200); // simulate load
      end;

      TThread.Synchronize(nil,
        procedure
        begin
          StatusBar1.Panels[0].Text := Format('Total: $%.2f', [Total]);
          ProgressBar1.Visible := False;
        end);
    end
  ).Start;
end;

procedure TTotalCalculationThread.Execute;
var
  i: Integer;
  Price, Quantity: Double;
begin
  FTotal := 0;
  for i := 0 to MainForm.CartListView.Items.Count - 1 do
  begin
    Sleep(100);
    Quantity := StrToFloatDef(MainForm.CartListView.Items[i].SubItems[0], 0);
    Price := StrToFloatDef(MainForm.CartListView.Items[i].SubItems[1], 0);
    FTotal := FTotal + (Quantity * Price);
  end;
  Synchronize(UpdateUI);
end;

procedure TTotalCalculationThread.UpdateUI;
begin
  MainForm.StatusBar1.SimpleText := Format('Total: $%.2f', [FTotal]);
  MainForm.ProgressBar1.Visible := False;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Add.OnClick := AddClick;
  Print.OnClick := PrintClick;
  RemoveBtn.OnClick := RemoveClick;
  ProductListView.LargeImages := ProductImageList;
end;

procedure TMainForm.btnLoadProductsClick(Sender: TObject);
begin
  LoadProducts;
end;

procedure TMainForm.RemoveClick(Sender: TObject);
begin
  if Assigned(CartListView.Selected) then
    CartListView.Selected.Delete
  else
    ShowMessage('Select an item from the cart to remove.');
end;

procedure TMainForm.LoadProducts;
var
  SL: TStringList;
  LineParts: TArray<string>;
  i: Integer;
  Product: TProduct;
  Item: TListItem;
  ImagePath: string;
  PNG: TPngImage;
  BMP: TBitmap;
begin
  SL := TStringList.Create;
  try
    if not FileExists('Data\products.csv') then
    begin
      ShowMessage('File "Data\products.csv" not found.');
      Exit;
    end;
    if ProductListView.Columns.Count = 0 then
    begin
      ProductListView.ViewStyle := vsReport;
      ProductListView.Columns.Add.Caption := 'Name';
      ProductListView.Columns.Add.Caption := 'Price';
    end;

    SL.LoadFromFile('Data\products.csv');
    SetLength(ProductList, SL.Count);
    ProductListView.Items.Clear;
    ProductImageList.Clear;

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

        // Load image
        ImagePath := 'Images\' + Product.ImageFileName;
        if FileExists(ImagePath) then
        begin
          PNG := TPngImage.Create;
          BMP := TBitmap.Create;
          try
            PNG.LoadFromFile(ImagePath);
            BMP.SetSize(ProductImageList.Width, ProductImageList.Height);
            BMP.Canvas.StretchDraw(Rect(0, 0, BMP.Width, BMP.Height), PNG);
            Item.ImageIndex := ProductImageList.Add(BMP, nil);
          finally
            PNG.Free;
            BMP.Free;
          end;
        end
        else
        begin
          Item.ImageIndex := -1;
        end;
      end;
    end;
  finally
    SL.Free;
  end;
end;




procedure TMainForm.PrintClick(Sender: TObject);
var
  I: Integer;
  Item: TListItem;
  ReceiptJSON, ItemJSON: TJSONObject;
  ItemsArray: TJSONArray;
  LogSummary: string;
  FileName: string;
begin
  if CartListView.Items.Count = 0 then
  begin
    ShowMessage('Cart is empty.');
    Exit;
  end;

  ReceiptJSON := TJSONObject.Create;
  ItemsArray := TJSONArray.Create;

  try
    for I := 0 to CartListView.Items.Count - 1 do
    begin
      Item := CartListView.Items[I];

      ItemJSON := TJSONObject.Create;
      ItemJSON.AddPair('name', Item.Caption);
      ItemJSON.AddPair('quantity', Item.SubItems[0]);
      ItemJSON.AddPair('lineTotal', Item.SubItems[1]);

      ItemsArray.AddElement(ItemJSON);
    end;

    ReceiptJSON.AddPair('timestamp', DateTimeToStr(Now));
    ReceiptJSON.AddPair('items', ItemsArray);
    ReceiptJSON.AddPair('total', StatusBar1.Panels[0].Text);

    if not DirectoryExists('Receipts') then
      CreateDir('Receipts');

    FileName := 'Receipt_' + FormatDateTime('yyyymmdd_hhnnss', Now) + '.json';
    TFile.WriteAllText('Receipts\' + FileName, ReceiptJSON.Format);

    ShowMessage('Receipt saved to Receipts\' + FileName);

    LogSummary := 'Sale: ' + IntToStr(CartListView.Items.Count) +
      ' items, ' + StatusBar1.Panels[0].Text;
    TLogThread.Create(LogSummary);
  finally
    ReceiptJSON.Free;
  end;
end;

procedure TMainForm.RecalcClick(Sender: TObject);
begin
  CalculateTotal;
end;

procedure TMainForm.AddClick(Sender: TObject);
var
  SelectedItem: TListItem;
  ProductName: string;
  ProductIndex: Integer;
  CartItem: TListItem;
  i: Integer;
  Found: Boolean;
begin
  SelectedItem := ProductListView.Selected;
  if not Assigned(SelectedItem) then
  begin
    ShowMessage('Please select a product first.');
    Exit;
  end;

  ProductName := SelectedItem.Caption;

  ProductIndex := -1;
  for i := 0 to Length(ProductList) - 1 do
    if ProductList[i].Name = ProductName then
    begin
      ProductIndex := i;
      Break;
    end;

  if ProductIndex = -1 then Exit;

  Found := False;
  for i := 0 to CartListView.Items.Count - 1 do
    if CartListView.Items[i].Caption = ProductName then
    begin
      CartListView.Items[i].SubItems[0] := IntToStr(StrToInt(CartListView.Items[i].SubItems[0]) + 1);
      CartListView.Items[i].SubItems[1] :=
        FormatFloat('0.00', StrToInt(CartListView.Items[i].SubItems[0]) * ProductList[ProductIndex].Price);
      Found := True;
      Break;
    end;

  if not Found then
  begin
    CartItem := CartListView.Items.Add;
    CartItem.Caption := ProductName;
    CartItem.SubItems.Add('1'); // Quantity
    CartItem.SubItems.Add(FormatFloat('0.00', ProductList[ProductIndex].Price)); // Line total
  end;
end;

end.

