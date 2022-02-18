unit contrail_lib;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DXDraws,math, DXInput, DXClass, ExtCtrls, StdCtrls, DXSounds, DIB,
  ComCtrls, jpeg, Buttons,FileCtrl;

procedure reset;
procedure zapisz_opcje;
procedure wczytaj_opcje;
procedure popraw_katy;
procedure zaliczanie_okrazen;
procedure wykrywanie_kolizji_i_jazda;
procedure dzwiek_silnika;
procedure zakonczenie_jazdy;
procedure obsluga_klawiszy;
procedure opory;
procedure popraw_obroty;
procedure obrotomierz;
procedure samochod;
procedure start_gry;
Procedure zapisz_wyniki;
procedure info;
procedure wczytaj_trase;
implementation


uses unit1;

procedure reset;
var i1,i2:integer;
begin
 i:=0; k:=0; i1:=0; i2:=0; ha:=0; rich:='';
 auto.x:=0; auto.y:=0;
 auto.alfa:=0; auto.a:=0; auto.v:=0;
 auto.obroty:=0; auto.gear:=1; auto.engine:=true;
 auto.nr_auta:=0;
 auto.h_auta:=0; auto.w_auta:=0;
 auto.jazda:=false;
 trasa.il_lap:=0; trasa.lap:=0; trasa.czas_okr:=0;
    for i1:=0 to 600 do
    begin
    for i2:=0 to 800 do
    begin
     mapa[i2,i1]:=0;
    end;
    end;
end;

procedure zapisz_opcje;
begin
form1.memo2.lines.clear;
form1.memo2.lines[0]:=form1.label9.caption;
form1.memo2.lines.add('');
form1.memo2.lines[1]:=inttostr(form1.trackbar1.position);
form1.memo2.lines.savetofile(sciezka+'data\opcje.dat');
form1.memo2.clear;
form1.panel4.visible:=false;
end;

procedure wczytaj_opcje;
begin
form1.memo2.lines.loadfromfile(sciezka+'data\opcje.dat');
form1.updown1.position:=strtoint(form1.memo2.lines[0]);
form1.label9.caption:=inttostr(form1.updown1.position);
form1.trackbar1.position:=strtoint(form1.memo2.lines[1]);
form1.image3.Picture:=form1.dximagelist.Items[form1.trackbar1.position-1].Picture;
auto.nr_auta:=strtoint(form1.memo2.lines[1])-1;
form1.memo2.clear;
end;

procedure popraw_katy;
begin
  if auto.a > 256 then auto.a:=0;
  if auto.a < 0 then auto.a:=256;
end;

procedure zaliczanie_okrazen;
begin
   if mapa[round(auto.x),round(auto.y)] = 3 then
  begin
   form1.memo2.lines[0]:='1';
   form1.memo2.lines.add(' ');
  end;

  if mapa[round(auto.x),round(auto.y)] = 4 then
  begin
   form1.memo2.lines[1]:='2';
  end;

  if mapa[round(auto.x),round(auto.y)] = 2 then
  begin
   if form1.memo2.lines[0]='1' then
   begin
    if form1.memo2.lines[1]='2' then
     begin
      trasa.lap:=trasa.lap+1;
     end;
   end;
   form1.memo2.lines.clear;
  end;
end;

procedure wykrywanie_kolizji_i_jazda;
begin

  if mapa[round(auto.x)-3,round(auto.y)] <> 1 then
  begin
  if mapa[round(auto.x)+3,round(auto.y)] <> 1 then
  begin
   auto.x:=auto.x+r*sin(degtorad(auto.alfa));
  end
  else
  begin
   auto.x:=auto.x-3;
   if auto.v >3 then
   begin
   auto.v:=3;
   auto.obroty:=15;
   auto.gear:=1;
   end
   else
   begin
    auto.v:=0;    auto.obroty:=0;  auto.jazda:=false;
   end;

   form1.dxwavelist1.Items[1].Play(false);
  end;
  end
  else
  begin
   auto.x:=auto.x+3;
   if auto.v >3 then
   begin
   auto.v:=3;
   auto.obroty:=15;
   auto.gear:=1;
   end
   else
   begin
    auto.v:=0;   auto.obroty:=0; auto.jazda:=false;
   end;
   form1.dxwavelist1.Items[1].Play(false);
  end;

  if mapa[round(auto.x),round(auto.y)-3] <> 1 then
  begin
  if mapa[round(auto.x),round(auto.y)+3] <> 1 then
   begin
   auto.y:=auto.y+r*cos(degtorad(auto.alfa));
   end
   else
   begin
    auto.y:=auto.y-3;
   if auto.v >3 then
   begin
   auto.v:=3;
   auto.obroty:=15;
   auto.gear:=1;
   end
   else
   begin
    auto.v:=0;   auto.obroty:=0;  auto.jazda:=false;
   end;
    form1.dxwavelist1.Items[1].Play(false);
   end;
  end
  else
  begin
    auto.y:=auto.y+3;
   if auto.v >3 then
   begin
   auto.v:=3;
   auto.obroty:=15;
   auto.gear:=1;
   end
   else
   begin
    auto.v:=0;    auto.obroty:=0;  auto.jazda:=false;
   end;
    form1.dxwavelist1.Items[1].Play(false);
  end;

end;

procedure dzwiek_silnika;
begin
 if auto.engine=true then
 begin
  form1.dxwavelist1.Items[0].Frequency:=auto.obroty*2000;
  if form1.dxwavelist1.Items[0].Frequency = 0 then
  form1.dxwavelist1.Items[0].Frequency:= 1000;
  form1.dxwavelist1.Items[0].Play(false);
 end;
end;

procedure zakonczenie_jazdy;
var
  FileStream : TFileStream;
begin
if trasa.lap>=trasa.il_lap then
begin
 form1.dxtimer.enabled:=false;
 form1.timer1.enabled:=false;
 form1.panel5.visible:=true;
 form1.button7.enabled:=true;
 form1.panel2.visible:=true;
 form1.label5.enabled:=true;
 form1.label2.enabled:=false;
 if not FileExists(sciezka+'data\wyniki.dat') then Exit;
 FileStream := TFileStream.Create(sciezka+'data\wyniki.dat', fmOpenRead);
 FileStream.ReadComponent(form1.listbox1);
 FileStream.Free;
end;
end;

procedure obsluga_klawiszy;
begin
  form1.DXInput.Update;

  if isLeft in form1.DXInput.States then
   begin
   if auto.jazda=true then
    begin
    auto.a:=auto.a+3;
    end;
   end;

  if isRight in form1.DXInput.States then
   begin
    if auto.jazda=true then
    begin
    auto.a:=auto.a-3;
    end;
   end;

   if auto.engine=true then
   begin
   if isUp in form1.DXInput.States then
   begin
    auto.jazda:=true;
    if auto.v < 30 then
    begin
    auto.v:=auto.v+1;
    auto.obroty:=auto.obroty+6;
    end;
   end;
   end;

  if isDown in form1.DXInput.States then
   begin
    if auto.v >= 1  then
    begin
    auto.v:=auto.v-1;
    auto.obroty:=auto.obroty-5;
    end;
    if auto.v < 3 then
    begin
     if auto.v >= 2 then
      form1.dxwavelist1.Items[2].Play(false);
    end;
    if auto.v <= 0 then
    begin
    auto.jazda:=false;
    auto.gear:=1;
    auto.obroty:=0;
    end;
   end;

   if isbutton1 in form1.DXInput.States then
   begin
     form1.dxtimer.enabled:=false;
     form1.timer1.enabled:=false;
     reset;
     form1.panel2.visible:=true;
     form1.label2.enabled:=false;
   end;

   if isbutton2 in form1.DXInput.States then
   begin
     if auto.engine= true then
      auto.engine:=false
     else
      auto.engine:=true;
   end;

end;

procedure opory;
begin
if auto.engine=false then
begin
if auto.v> 0 then
begin
auto.v:=auto.v-1;
auto.obroty:=auto.obroty-5;
end
else
begin
 auto.jazda:=false;
end;
end;
end;

procedure popraw_obroty;
begin
  if auto.obroty>60 then
  begin
   auto.gear:=auto.gear+1;
   auto.obroty:=11;
  end;

  if auto.obroty<0 then
  begin
   auto.gear:=auto.gear-1;
   auto.obroty:=50;
  end;
end;

procedure obrotomierz;
begin
   form1.DXImageList.Items[10].draw(form1.dxdraw.surface,700,500,0);
if auto.engine= true then
  form1.DXImageList.Items[11].DrawRotate(form1.dxdraw.surface,785,585,90,25,0,0.79,0.5,round(auto.obroty)+random(2))
else
  form1.DXImageList.Items[11].DrawRotate(form1.dxdraw.surface,785,585,90,25,0,0.79,0.5,0);

  if not form1.DXDraw.CanDraw then exit;
  with form1.DXDraw.Surface.Canvas do
  begin
    Brush.Style := bsClear;
    Font.Color := clwhite;
    Font.Size := 15;
    font.Name:= 'Westminster';
    Textout(730, 470, inttostr(auto.v*5)+' km\h');
    Textout(730, 450, inttostr(auto.gear)+' gear')
  end;
end;

procedure samochod;
begin
 form1.DXImageList.Items[auto.nr_auta].DrawRotate(form1.dxdraw.surface,round(auto.x),round(auto.y),auto.w_auta,auto.h_auta,0,0.5,0.3,auto.a*-1);
end;

procedure start_gry;
begin
trasa.il_lap:=form1.updown1.position;
form1.panel2.visible:=false;
//dxdraw.Initialize;
form1.dximagelist.Items.MakeColorTable;
form1.dxdraw.ColorTable := form1.dximagelist.Items.ColorTable;
form1.dxdraw.DefColorTable := form1.dximagelist.Items.ColorTable;
form1.DXDraw.UpdatePalette;
form1.dxtimer.enabled:=true;
form1.timer1.enabled:=true;
end;

Procedure zapisz_wyniki;
var
  FileStream : TFileStream;
begin
if FileExists(sciezka+'data\wyniki.dat') then
  FileStream := TFileStream.Create(sciezka+'data\wyniki.dat', fmOpenWrite) else
  FileStream := TFileStream.Create(sciezka+'data\wyniki.dat', fmCreate);
  FileStream.WriteComponent(form1.listbox1);
  FileStream.Free;
 form1.listbox1.sorted:=false;
 form1.listbox1.sorted:=true;
end;

procedure info;
begin
  if not form1.DXDraw.CanDraw then exit;
  with form1.DXDraw.Surface.Canvas do
  begin
    Brush.Style := bsClear;
    Font.Color := clwhite;
    Font.Size := 15;
    font.Name:= 'Westminster';
    Textout(20, 20, 'Okr¹¿enie : '+inttostr(trasa.lap));
    Textout(20, 40, 'Czas : '+floattostr(trasa.czas_okr/10)+' s.')
  end;
end;

procedure wczytaj_trase;
var roz:string;
    i1,i2:integer;
begin
 roz:=copy(form1.filelistbox1.FileName,length(form1.filelistbox1.FileName)-2,3);
if roz='trs' then
begin
form1.memo1.lines.clear;
form1.memo1.lines.loadfromfile(form1.filelistbox1.FileName);
auto.x:=strtoint(form1.memo1.lines[0]);
auto.y:=strtoint(form1.memo1.lines[1]);
auto.a:=strtoint(form1.memo1.lines[2]);
form1.dximagelist1.Items.loadfromfile(form1.directorylistbox1.Directory+'\'+form1.memo1.lines[3]+'.dxg');
form1.dximagelist1.Items[0].SystemMemory:=false;
trasa.nazwa_trasy:=form1.memo1.lines[3];
form1.label2.enabled:=true;
form1.richedit1.lines.clear;
form1.richedit1.lines.loadfromfile(form1.directorylistbox1.Directory+'\'+form1.memo1.lines[3]+'.pte');
rich:=form1.richedit1.text;
   for i1:=0 to 600 do
    begin
    for i2:=0 to 800 do
    begin
     mapa[i2,i1]:=0;
    end;
    end;

   for i1:=0 to 600 do
    begin
    for i2:=0 to 800 do
    begin
     ha:=ha+1;
     mapa[i2,i1]:=strtoint(copy(rich,ha,1));
    end;
    end;
form1.memo1.lines.clear;
form1.richedit1.lines.clear;
form1.panel3.visible:=false;
end
else
begin
MessageDlg('Z³y typ pliku! Plik musi byc typu : *.trs .', mtInformation,
     [mbOk], 0);
end;
end;


end.
