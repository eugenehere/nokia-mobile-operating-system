unit utility_paint;
interface

uses GraphABC, Nokia_OS;
var
  xpaint,ypaint:integer;
  buffpaint,buffundo:picture;
  pencolor:color;
  penstyle:DashStyle;
  penwidth:integer;
  paintinstrument:string;
  buffpaintbool:boolean;
  
procedure pmenu;
procedure psave;
procedure psett;
procedure setpstyle;
procedure setpcolor;
procedure setpwidth;
procedure pscreen;
procedure inbuff;
procedure inbuffundo;
procedure bufferpaint(x,y,mb:integer);
procedure undo;
procedure setpinstr;
procedure pnill(x,y,mb:integer);
procedure pneg(x,y,mb:integer);
procedure p15;
procedure clearsett;

implementation

var
  plmenu,plsett,plstyle,plcolor,plwidth,plinstr:listmenu;
  p:integer;
  backcl:color;
  dirold:string;

procedure clearsett;
begin
p:=1;paintinstrument:='pen';buffpaint.Clear(clwhite);buffundo.clear(clwhite);buffpaintbool:=false;pencolor:=clblack;penstyle:=pssolid;penwidth:=1;dirold:='';
end;

procedure pmenu;
label lexit;
var y:integer;
begin
  if directory='paint' then begin
  case butt of
  17:p:=p-1;
  18:p:=p+1;
  21:case p of
      1:begin directory:='paint.screen';buffpaint.clear(clwhite);butt:=1111;panel(bsSolid,rgb(210,210,210));writefont('Back',135,232,9,clwhite,clblack,fsBold,'arial',1,1,0,0,false);goto lexit; end;
      2:if buffpaintbool=true then begin directory:='paint.screen';butt:=1111;scrclr(clwhite);pscreen;panel(bsSolid,rgb(210,210,210));writefont('Back',135,232,9,clwhite,clblack,fsBold,'arial',1,1,0,0,false);goto lexit;end;
      3:begin if buffpaintbool=true then psave;end;
      4:begin directory:='paint.settings';butt:=1111; p:=1; psett; end;
      5:begin directory:='menu';butt:=1111;p:=1;paintinstrument:='pen';buffpaint.Clear(clwhite);buffundo.clear(clwhite);buffpaintbool:=false;pencolor:=clblack;penstyle:=pssolid;penwidth:=1;menu;goto lexit;end; //back
  end;
  end;
  scrclr(clwhite);
  if p=6 then p:=5;
  if p=0 then p:=1;
  plmenu.printpunkt(1,0);
  y:=p*26+49;pmonopic.draw(162,y);
  panel(bsSolid,rgb(210,210,210));
  writefont('Select',81,232,9,clwhite,clblack,fsBold,'arial',1,1,0,0,false);
  //курсор
  moveto(28,y-1);lineto(167,y-1,rgb(0,153,244));
  moveto(28,y+25);lineto(167,y+25,rgb(0,153,244));
  moveto(28,y-1);lineto(28,y+25,rgb(0,153,244));
  end;
  lexit:
end;

procedure pscreen;
label lexit;
begin
  if directory='paint.screen' then begin
  dirold:=directory;
  buffpaint.Draw(28,75);
  case butt of
  13:begin undo; buffundo.Draw(28,75); end;
  14:begin directory:='paint';butt:=1111;p:=1;dirold:='';pmenu;goto lexit;end;
  21:begin directory:='paint.settings';butt:=1111; p:=1; psett;goto lexit;end;
  end;
  panel(bsSolid,rgb(210,210,210));
  writefont('Back',135,232,9,clwhite,clblack,fsBold,'arial',1,1,0,0,false);
  writefont('Settings',76,232,9,clwhite,clblack,fsBold,'arial',1,0,0,0,false);
  writefont('Undo',34,232,9,clwhite,clblack,fsBold,'arial',1,0,0,0,false);
  lexit:
end;
end;

procedure psave;
var xp,yp:integer;
begin
  dt := System.DateTime.Now;
  buffpaint.save('directory\images\'+inttostr(dt.Second)+inttostr(dt.Minute)+inttostr(dt.Hour)+inttostr(dt.Day)+inttostr(dt.Month)+inttostr(dt.Year)+'.jpg');
  OK('Saved',68,219,14);pmenu;
end;

procedure inbuff;
var xp,yp:integer;
begin
  for yp:=0 to 154 do
  begin
    for xp:=0 to 139 do
    begin
      buffpaint.SetPixel(xp,yp,getpixel(28+xp,75+yp));
      buffpaintbool:=true;
    end;
  end;
end;

procedure inbuffundo;
var xp,yp:integer;
begin
  for yp:=0 to 154 do
  begin
    for xp:=0 to 139 do
    begin
      buffundo.SetPixel(xp,yp,getpixel(28+xp,75+yp));
    end;
  end;
end;

procedure undo;
var xp,yp:integer;
begin
  for yp:=0 to 154 do
  begin
    for xp:=0 to 139 do
    begin
      buffpaint.SetPixel(xp,yp,buffundo.getpixel(xp,yp));
    end;
  end;
end;

procedure psett;
label lexit;
var y:integer;
begin
if directory='paint.settings' then begin
  case butt of
  17:p:=p-1;
  18:p:=p+1;
  14:if dirold='paint.screen' then begin directory:='paint.screen';butt:=1111;p:=1;pscreen;goto lexit;end else begin directory:='paint';butt:=1111;p:=4;pmenu;goto lexit;end; //back
  21:case p of
     1:begin directory:='paint.settings.color';butt:=1111;p:=1;goto lexit; setpcolor; end;
     2:begin directory:='paint.settings.style';butt:=1111;p:=1;goto lexit; setpstyle; end;
     3:begin directory:='paint.settings.width';butt:=1111;p:=1;goto lexit; setpwidth; end;
     4:begin directory:='paint.settings.instruments';butt:=1111;p:=1;goto lexit; setpinstr; end;
     5:begin directory:='paint';clearsett;butt:=1111;pmenu; goto lexit; end;
  end;
  end;
  scrclr(clwhite);
  if p=6 then p:=5;
  if p=0 then p:=1;
  plsett.printpunkt(1,-27);
  y:=p*26+49;pmonopic.draw(162,y);
  panel(bsSolid,rgb(210,210,210));
  writefont('Back',135,232,9,clwhite,clblack,fsBold,'arial',1,1,0,0,false);
  writefont('Select',81,232,9,clwhite,clblack,fsBold,'arial',1,1,0,0,false);
  //курсор
  moveto(28,y-1);lineto(167,y-1,rgb(0,153,244));
  moveto(28,y+25);lineto(167,y+25,rgb(0,153,244));
  moveto(28,y-1);lineto(28,y+25,rgb(0,153,244));
  lexit:
end;
end;

procedure setpstyle;
label lexit;
var y:integer;
begin
if directory='paint.settings.style' then begin
  case butt of
  17:p:=p-1;
  18:p:=p+1;
  14:if dirold='paint.screen' then begin directory:='paint.screen';butt:=1111;p:=1;pscreen;goto lexit;end else begin directory:='paint.settings';butt:=1111;p:=2;psett;goto lexit;end; //back
  21:case p of
    1:begin penstyle:=psSolid;if dirold='paint.screen' then begin directory:='paint.screen';butt:=1111;p:=1;pscreen;goto lexit;end else begin directory:='paint.settings';butt:=1111;p:=2;psett;goto lexit;end;end;
    2:begin penstyle:=psClear;if dirold='paint.screen' then begin directory:='paint.screen';butt:=1111;p:=1;pscreen;goto lexit;end else begin directory:='paint.settings';butt:=1111;p:=2;psett;goto lexit;end;end;
    3:begin penstyle:=psDash;if dirold='paint.screen' then begin directory:='paint.screen';butt:=1111;p:=1;pscreen;goto lexit;end else begin directory:='paint.settings';butt:=1111;p:=2;psett;goto lexit;end;end;
    4:begin penstyle:=psDot;if dirold='paint.screen' then begin directory:='paint.screen';butt:=1111;p:=1;pscreen;goto lexit;end else begin directory:='paint.settings';butt:=1111;p:=2;psett;goto lexit;end;end;
    5:begin penstyle:=psDashDot;if dirold='paint.screen' then begin directory:='paint.screen';butt:=1111;p:=1;pscreen;goto lexit;end else begin directory:='paint.settings';butt:=1111;p:=2;psett;goto lexit;end;end;
    6:begin penstyle:=psDashDotDot;if dirold='paint.screen' then begin directory:='paint.screen';butt:=1111;p:=1;pscreen;goto lexit;end else begin directory:='paint.settings';butt:=1111;p:=2;psett;goto lexit;end;end;
  end;
  end;
  scrclr(clwhite);
  if p=7 then p:=6;
  if p=0 then p:=1;
  plstyle.printpunkt(1,-27);
  y:=p*26+49;pmonopic.draw(162,y);
  panel(bsSolid,rgb(210,210,210));
  writefont('Back',135,232,9,clwhite,clblack,fsBold,'arial',1,1,0,0,false);
  writefont('Select',81,232,9,clwhite,clblack,fsBold,'arial',1,1,0,0,false);
  //курсор
  moveto(28,y-1);lineto(167,y-1,rgb(0,153,244));
  moveto(28,y+25);lineto(167,y+25,rgb(0,153,244));
  moveto(28,y-1);lineto(28,y+25,rgb(0,153,244));
  lexit:
  end;
end;

procedure setpcolor;
label lexit;
var y:integer;
begin
if directory='paint.settings.color' then begin
  case butt of
  17:p:=p-1;
  18:p:=p+1;
  14:if dirold='paint.screen' then begin directory:='paint.screen';butt:=1111;p:=1;pscreen;goto lexit;end else begin directory:='paint.settings';butt:=1111;p:=1;psett;goto lexit;end; //back
  21:case p of
    1:begin pencolor:=clblack;if dirold='paint.screen' then begin directory:='paint.screen';butt:=1111;p:=1;pscreen;goto lexit;end else begin directory:='paint.settings';butt:=1111;p:=1;psett;goto lexit;end;end;
    2:begin pencolor:=clred;if dirold='paint.screen' then begin directory:='paint.screen';butt:=1111;p:=1;pscreen;goto lexit;end else begin directory:='paint.settings';butt:=1111;p:=1;psett;goto lexit;end;end;
    3:begin pencolor:=clgreen;if dirold='paint.screen' then begin directory:='paint.screen';butt:=1111;p:=1;pscreen;goto lexit;end else begin directory:='paint.settings';butt:=1111;p:=1;psett;goto lexit;end;end;
    4:begin pencolor:=clyellow;if dirold='paint.screen' then begin directory:='paint.screen';butt:=1111;p:=1;pscreen;goto lexit;end else begin directory:='paint.settings';butt:=1111;p:=1;psett;goto lexit;end;end;
    5:begin pencolor:=clmediumblue;if dirold='paint.screen' then begin directory:='paint.screen';butt:=1111;p:=1;pscreen;goto lexit;end else begin directory:='paint.settings';butt:=1111;p:=1;psett;goto lexit;end;end;
    6:begin pencolor:=clwhite;if dirold='paint.screen' then begin directory:='paint.screen';butt:=1111;p:=1;pscreen;goto lexit;end else begin directory:='paint.settings';butt:=1111;p:=1;psett;goto lexit;end;end;
  end;
  end;
  scrclr(clwhite);
  if p=7 then p:=6;
  if p=0 then p:=1;
  plcolor.printpunkt(1,-27);
  y:=p*26+49;pmonopic.draw(162,y);
  panel(bsSolid,rgb(210,210,210));
  writefont('Back',135,232,9,clwhite,clblack,fsBold,'arial',1,1,0,0,false);
  writefont('Select',81,232,9,clwhite,clblack,fsBold,'arial',1,1,0,0,false);
  //курсор
  moveto(28,y-1);lineto(167,y-1,rgb(0,153,244));
  moveto(28,y+25);lineto(167,y+25,rgb(0,153,244));
  moveto(28,y-1);lineto(28,y+25,rgb(0,153,244));
  lexit:
end;
end;

procedure setpwidth;
label lexit;
var y:integer;
begin
if directory='paint.settings.width' then begin
  case butt of
  17:p:=p-1;
  18:p:=p+1;
  14:if dirold='paint.screen' then begin directory:='paint.screen';butt:=1111;p:=1;pscreen;goto lexit;end else begin directory:='paint.settings';butt:=1111;p:=2;psett;goto lexit;end; //back
  21:case p of
    1:begin penwidth:=1;if dirold='paint.screen' then begin directory:='paint.screen';butt:=1111;p:=1;pscreen;goto lexit;end else begin directory:='paint.settings';butt:=1111;p:=1;psett;goto lexit;end;end;
    2:begin penwidth:=2;if dirold='paint.screen' then begin directory:='paint.screen';butt:=1111;p:=1;pscreen;goto lexit;end else begin directory:='paint.settings';butt:=1111;p:=1;psett;goto lexit;end;end;
    3:begin penwidth:=4;if dirold='paint.screen' then begin directory:='paint.screen';butt:=1111;p:=1;pscreen;goto lexit;end else begin directory:='paint.settings';butt:=1111;p:=1;psett;goto lexit;end;end;
    4:begin penwidth:=6;if dirold='paint.screen' then begin directory:='paint.screen';butt:=1111;p:=1;pscreen;goto lexit;end else begin directory:='paint.settings';butt:=1111;p:=1;psett;goto lexit;end;end;
    5:begin penwidth:=10;if dirold='paint.screen' then begin directory:='paint.screen';butt:=1111;p:=1;pscreen;goto lexit;end else begin directory:='paint.settings';butt:=1111;p:=1;psett;goto lexit;end;end;
    6:begin penwidth:=16;if dirold='paint.screen' then begin directory:='paint.screen';butt:=1111;p:=1;pscreen;goto lexit;end else begin directory:='paint.settings';butt:=1111;p:=1;psett;goto lexit;end;end;
  end;
  end;
  scrclr(clwhite);
  if p=7 then p:=6;
  if p=0 then p:=1;
  plwidth.printpunkt(1,-27);
  y:=p*26+49;pmonopic.draw(162,y);
  panel(bsSolid,rgb(210,210,210));
  writefont('Back',135,232,9,clwhite,clblack,fsBold,'arial',1,1,0,0,false);
  writefont('Select',81,232,9,clwhite,clblack,fsBold,'arial',1,1,0,0,false);
  //курсор
  moveto(28,y-1);lineto(167,y-1,rgb(0,153,244));
  moveto(28,y+25);lineto(167,y+25,rgb(0,153,244));
  moveto(28,y-1);lineto(28,y+25,rgb(0,153,244));
  lexit:
end;
end;

procedure setpinstr;
label lexit;
var y:integer;
begin
if directory='paint.settings.instruments' then begin
  case butt of
  17:p:=p-1;
  18:p:=p+1;
  14:if dirold='paint.screen' then begin directory:='paint.screen';butt:=1111;p:=1;pscreen;goto lexit;end else begin directory:='paint.settings';butt:=1111;p:=2;psett;goto lexit;end; //back
  21:case p of
    1:begin paintinstrument:='pen';if dirold='paint.screen' then begin directory:='paint.screen';butt:=1111;p:=1;pscreen;goto lexit;end else begin directory:='paint.settings';butt:=1111;p:=1;psett;goto lexit;end;end;
    2:begin paintinstrument:='fill';if dirold='paint.screen' then begin directory:='paint.screen';butt:=1111;p:=1;pscreen;goto lexit;end else begin directory:='paint.settings';butt:=1111;p:=1;psett;goto lexit;end;end;
    3:begin {paintinstrument:='neg';}if dirold='paint.screen' then begin directory:='paint.screen';butt:=1111;p:=1;pscreen;goto lexit;end else begin directory:='paint.settings';butt:=1111;p:=1;psett;goto lexit;end;end;
    4:begin paintinstrument:='nill';if dirold='paint.screen' then begin directory:='paint.screen';butt:=1111;p:=1;pscreen;goto lexit;end else begin directory:='paint.settings';butt:=1111;p:=1;psett;goto lexit;end;end;
  end;
  end;
  scrclr(clwhite);
  if p=5 then p:=4;
  if p=0 then p:=1;
  plinstr.printpunkt(1,-27);
  y:=p*26+49;pmonopic.draw(162,y);
  panel(bsSolid,rgb(210,210,210));
  writefont('Back',135,232,9,clwhite,clblack,fsBold,'arial',1,1,0,0,false);
  writefont('Select',81,232,9,clwhite,clblack,fsBold,'arial',1,1,0,0,false);
  //курсор
  moveto(28,y-1);lineto(167,y-1,rgb(0,153,244));
  moveto(28,y+25);lineto(167,y+25,rgb(0,153,244));
  moveto(28,y-1);lineto(28,y+25,rgb(0,153,244));
  lexit:
end;
end;

procedure bufferpaint(x,y,mb:integer);
begin
  if (directory='paint.screen') and (mb=1) and ((x in [28..167])and(y in [75..229])) then
  begin
  inbuff;
  end;
end;

procedure pnill(x,y,mb:integer);
var i,j,x1,y1:integer;
begin
  if mb=1 then begin
  if penwidth>1 then
  begin
  x1:=x-trunc(penwidth/2);
  y1:=trunc(y-penwidth/2);
  for i:=0 to penwidth do
  for j:=0 to penwidth do
  begin
  if (x1+j in [28..167])and(y1+i in [75..229]) then
  setpixel(x1+j,y1+i,clwhite);
  end;
  end
  else setpixel(x,y,clwhite);
  end;
end;

procedure pneg(x,y,mb:integer);
var i,j,x1,y1:integer;
begin
  {setpencolor(clwhite);
  setpenstyle(pmNot);
  if mb=1 then begin
  if penwidth>1 then
  begin
  x1:=x-trunc(penwidth/2);
  y1:=trunc(y-penwidth/2);
  for i:=0 to penwidth do
    for j:=0 to penwidth do
    begin
      if (x1+j in [28..167])and(y1+i in [75..229]) then
      setpixel(x1+j,y1+i,clwhite);
    end;
  end
  else setpixel(x,y,pencolor);
  end;
  setpenstyle(pmCopy);}
end;

procedure p15;
begin
if (butt=15) and (pos('paint',directory)<>0) then begin directory:='mainmenu';clearsett; butt:=1111; setstandartstyles; mainmenu; end;
end;

begin
  paintinstrument:='pen';
  pencolor:=clblack;penwidth:=1;
  p:=1;dirold:='';
  buffpaint:=picture.Create(140,155);
  buffpaint.Clear(clwhite);
  buffpaintbool:=false;
  buffundo:=picture.Create(140,155);
  buffundo.Clear(clwhite);
  plmenu:=listmenu.create(5);
  plmenu.newpunkt('Новый',1,'NokiaOS_Files\icons\paint\new.jpg');
  plmenu.newpunkt('Продолжить',2,'NokiaOS_Files\icons\paint\resume.jpg');
  plmenu.newpunkt('Сохранить',3,'NokiaOS_Files\icons\paint\save.jpg');
  plmenu.newpunkt('Настройки',4,'NokiaOS_Files\icons\paint\settings.jpg');
  plmenu.newpunkt('Выход',5,'NokiaOS_Files\icons\paint\quit.jpg');
    plsett:=listmenu.create(5);
    plsett.newpunkt('Цвет пера',1,'NokiaOS_Files\phone\punkt.jpg');
    plsett.newpunkt('Стиль пера',2,'NokiaOS_Files\phone\punkt.jpg');
    plsett.newpunkt('Ширина пера',3,'NokiaOS_Files\phone\punkt.jpg');
    plsett.newpunkt('Инструмент',4,'NokiaOS_Files\phone\punkt.jpg');
    plsett.newpunkt('Очистить буфер',5,'NokiaOS_Files\phone\punkt.jpg');
      plstyle:=listmenu.create(6);
      plstyle.newpunkt('Сплошной',1,'NokiaOS_Files\phone\punkt.jpg');
      plstyle.newpunkt('Прозрачный',2,'NokiaOS_Files\phone\punkt.jpg');
      plstyle.newpunkt('Штриховой',3,'NokiaOS_Files\phone\punkt.jpg');
      plstyle.newpunkt('Пунктирный',4,'NokiaOS_Files\phone\punkt.jpg');
      plstyle.newpunkt('Штрихунктирный',5,'NokiaOS_Files\phone\punkt.jpg');
      plstyle.newpunkt('Альтерн. штрихункт.',6,'NokiaOS_Files\phone\punkt.jpg');
      plcolor:=listmenu.create(6);
      plcolor.newpunkt('Черный',1,'NokiaOS_Files\icons\paint\colors\black.jpg');
      plcolor.newpunkt('Красный',2,'NokiaOS_Files\icons\paint\colors\red.jpg');
      plcolor.newpunkt('Зеленый',3,'NokiaOS_Files\icons\paint\colors\green.jpg');
      plcolor.newpunkt('Желтый',4,'NokiaOS_Files\icons\paint\colors\yellow.jpg');
      plcolor.newpunkt('Синий',5,'NokiaOS_Files\icons\paint\colors\blue.jpg');
      plcolor.newpunkt('Белый',6,'NokiaOS_Files\icons\paint\colors\white.jpg');
      plwidth:=listmenu.create(6);
      plwidth.newpunkt('1 пиксель',1,'NokiaOS_Files\phone\punkt.jpg');
      plwidth.newpunkt('2 пикселя',2,'NokiaOS_Files\phone\punkt.jpg');
      plwidth.newpunkt('4 пикселя',3,'NokiaOS_Files\phone\punkt.jpg');
      plwidth.newpunkt('6 пикселей',4,'NokiaOS_Files\phone\punkt.jpg');
      plwidth.newpunkt('10 пикселей',5,'NokiaOS_Files\phone\punkt.jpg');
      plwidth.newpunkt('16 пикселей',6,'NokiaOS_Files\phone\punkt.jpg');
      plinstr:=listmenu.create(4);
      plinstr.newpunkt('Перо',1,'NokiaOS_Files\phone\punkt.jpg');
      plinstr.newpunkt('Заливка',2,'NokiaOS_Files\phone\punkt.jpg');
      plinstr.newpunkt('(Негатив)',3,'NokiaOS_Files\phone\punkt.jpg');
      plinstr.newpunkt('Ластик (ширина пера)',4,'NokiaOS_Files\phone\punkt.jpg');
        
end.