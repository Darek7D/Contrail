////////////////////////////////////
//            Contrail            //
//               by               //
//        Dariusz £azowski        //
//      All rights reserved       //
////////////////////////////////////
unit Unit1;

interface

uses
  SysUtils, Classes,DXSounds,DXDraws, DXInput,Forms,
  contrail_lib, DXClass,ComCtrls, FileCtrl, Graphics,
  Controls, StdCtrls, ExtCtrls, Dialogs;

type

  auto_gry = object
    x,y,alfa: real;
    a,v,nr_auta,h_auta,w_auta,gear,obroty:integer;
    jazda,engine:boolean;
 end;

   trasa_gry = object
    il_lap,lap,czas_okr:integer;
    nazwa_trasy : string;
 end;


  TForm1 = class(TForm)
    DXDraw: TDXDraw;
    DXTimer: TDXTimer;
    DXInput: TDXInput;
    DXImageList: TDXImageList;
    DXWaveList1: TDXWaveList;
    DXSound1: TDXSound;
    Panel2: TPanel;
    Memo1: TMemo;
    OpenDialog1: TOpenDialog;
    DXImageList1: TDXImageList;
    RichEdit1: TRichEdit;
    Image1: TImage;
    Image2: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Memo2: TMemo;
    Panel3: TPanel;
    DriveComboBox1: TDriveComboBox;
    DirectoryListBox1: TDirectoryListBox;
    FileListBox1: TFileListBox;
    Button2: TButton;
    Button3: TButton;
    Label6: TLabel;
    Panel4: TPanel;
    Button4: TButton;
    Button5: TButton;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    UpDown1: TUpDown;
    Timer1: TTimer;
    Label10: TLabel;
    Image3: TImage;
    TrackBar1: TTrackBar;
    Panel5: TPanel;
    ListBox1: TListBox;
    Button6: TButton;
    Button7: TButton;
    Edit1: TEdit;
    Label11: TLabel;
    Label12: TLabel;
    Button8: TButton;
    Button1: TButton;
    Panel1: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DXTimerTimer(Sender: TObject; LagCount: Integer);
    procedure Label1Click(Sender: TObject);
    procedure Label3Click(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure Label1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label5MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label3MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label2MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image2MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Label5Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure UpDown1Click(Sender: TObject; Button: TUDBtnType);
    procedure TrackBar1Change(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

  auto:auto_gry;
  trasa:trasa_gry;

  odliczanie:integer; //odliczanie
  i,k,i1,i2,ha:integer; //zmienne pomocnicze
  rich:string;  //zmienna pomocnicza
  sciezka:string; //sciezka dostepowa do gry
  r:real; //promien
  mapa:array[0..800,0..600] of integer;  //mapa

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
reset;
randomize;
auto.v:=0;
dximagelist.Items.loadfromfile('data\auta.dxg');
sciezka:=directorylistbox1.Directory+'\';
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
dxdraw.Finalize;
end;

procedure TForm1.DXTimerTimer(Sender: TObject; LagCount: Integer);
begin
if odliczanie=0 then
begin
zakonczenie_jazdy;
dxdraw.Surface.Fill(clblack);
obsluga_klawiszy;
  if auto.jazda = true then
  begin
  for i:=0 to auto.v do
  begin
   auto.alfa:=auto.a*1.4063;
   r:=0.7;
   zaliczanie_okrazen;
   wykrywanie_kolizji_i_jazda;
  end;

  end;

  end
  else
  begin
  odliczanie:=odliczanie-1;
  end;

  popraw_obroty;
  popraw_katy;
  dzwiek_silnika;
  opory;

  auto.h_auta:=50;
  auto.w_auta:=27;

  DXImageList1.Items[0].draw(dxdraw.surface,0,0,0);
  samochod;
  DXImageList1.Items[1].draw(dxdraw.surface,0,0,0);
  obrotomierz;
  info;

 if odliczanie <>0 then
 begin
  if not form1.DXDraw.CanDraw then exit;
  with form1.DXDraw.Surface.Canvas do
  begin
    Font.Size := 200;
    font.Name:= 'Westminster';
    Textout(285,170 , inttostr(odliczanie))
  end;
 end;

  dxdraw.Surface.Canvas.Release;
  dxdraw.Flip;
end;

procedure TForm1.Label1Click(Sender: TObject);
begin
Application.Terminate();
end;

procedure TForm1.Label3Click(Sender: TObject);
begin
FileListbox1.ApplyFilePath('*.trs');
panel3.visible:=true;
end;

procedure TForm1.Label2Click(Sender: TObject);
begin
odliczanie:=50;
wczytaj_opcje;
start_gry;
end;

procedure TForm1.Label1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
label1.Font.Color:=clgreen;
end;

procedure TForm1.Label5MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
label5.Font.Color:=clgreen;
end;

procedure TForm1.Label3MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
label3.Font.Color:=clgreen;
end;

procedure TForm1.Label2MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
label2.Font.Color:=clgreen;
end;

procedure TForm1.Image2MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
label1.Font.Color:=clblack;
label2.Font.Color:=clblack;
label3.Font.Color:=clblack;
label5.Font.Color:=clblack;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
reset;
wczytaj_trase;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
panel3.visible:=false;
end;

procedure TForm1.Label5Click(Sender: TObject);
begin
panel4.visible:=true;
wczytaj_opcje;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
panel4.visible:=false;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
if odliczanie = 0 then
trasa.czas_okr:=trasa.czas_okr+1;
end;

procedure TForm1.UpDown1Click(Sender: TObject; Button: TUDBtnType);
begin
label9.caption:=inttostr(updown1.position);
trasa.il_lap:=updown1.position;
end;

procedure TForm1.TrackBar1Change(Sender: TObject);
begin
image3.Picture:=dximagelist.Items[trackbar1.position-1].Picture;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
zapisz_opcje;
end;

procedure TForm1.Button6Click(Sender: TObject);
var
  FileStream : TFileStream;
begin
panel5.visible:=false;
listbox1.sorted:=false;
listbox1.sorted:=true;
if FileExists(sciezka+'data\wyniki.dat') then
  FileStream := TFileStream.Create(sciezka+'data\wyniki.dat', fmOpenWrite) else
  FileStream := TFileStream.Create(sciezka+'data\wyniki.dat', fmCreate);
  FileStream.WriteComponent(form1.listbox1);
  FileStream.Free;
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
listbox1.Items.Add(floattostr(trasa.czas_okr/10)+' s. '+trasa.nazwa_trasy+' Okr¹¿enia : '+inttostr(trasa.il_lap)+' - '+edit1.text);
button7.enabled:=false;
listbox1.Sorted:=false;
listbox1.Sorted:=true;
reset;
end;

procedure TForm1.Button8Click(Sender: TObject);
begin
zapisz_wyniki;
panel5.visible:=true;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
listbox1.Clear;
zapisz_wyniki;
end;

procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
if button7.enabled=true then
begin
 if key=#13 then
 button7.click;
end
else
 button6.click;
end;

end.
