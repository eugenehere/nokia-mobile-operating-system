unit Nokia_OS;

interface

uses GraphABC,Timers;

const x1s=28; x2s=169; y1s=64; y2s=248;

type
  monomenu = record
    name:string;
    id:byte;
    icon:picture;
    end;
    
  listmenu = class
    size:byte;
    menu:array of monomenu;
    constructor create(h:byte);
    begin
      setlength(menu,h);size:=h-1;
    end;
    procedure newpunkt(sname:string;sid:byte;sicon:string);
    procedure printpunkt(id,tab:integer);
  end;
  
  TIcon = class
    tname:string;
    tslot:integer;
    timage:picture;
    tx,ty,nx,ny:integer;// x/3=47 y(180)/5=45
    constructor create(image,name:string);
    begin
      timage:=picture.Create(image);
      tname:=name;
    end;
    procedure print(slot:integer;tab:integer);
    procedure changeicon(newicon:string);
  end;
  
  opensetting = class
    id:integer;
    constructor create(ids:integer);
      begin id:=ids; end;
    procedure Configurations;
    procedure about;
    procedure display;
    procedure reset;
  end;
  
  tfilephone = record
    tshadowfont,tstandfontcol,tshowsec,ttrueconfig,ttruehalt,ttruecmd:boolean;
    tnamebackgrnd:string[100];
    ttimepos,ticonset:byte;
    tfontcolor:color;
  end;
    
var
  screencolor,fontcolor:color;
  lockbutt,turn,shadowfont,standfontcol,showsec,trueconfig,truehalt,truecmd:boolean;
  settings,multimedia,calendar,notepad,music,opera,youtube,googleplay,massages:ticon;
  tsetting,generalsett,displaysett,changebackgroundsett,changefontsett,changefontcolorsett,changepostimesett,changeiconsett:listmenu;
  open:opensetting;
  background,pan,pmonopic,screenpanel,warnpic:picture;
  min,sec,namebackgrnd:string;
  butt,ids,timepos,iconset:byte;
  dt: system.datetime;
  filephone:file of tfilephone;
  recfileph:tfilephone;
  bt:array[1..11]of boolean;i:integer;
  directory:string;

procedure startos;
procedure loadwindow(str1,str2:string;x1,y1,x2,y2,pt:integer;style1,style2:fontstyletype;k:integer);
procedure scrclr(col:color);
procedure updatebutt;
procedure writefont(str:string;x,y,pt:integer;cl1,cl2:color;style:FontStyleType;name:string;xb,yb,xu,yu:integer;modif:boolean);
function selectmenu:integer;
procedure sellsett(ids:integer);
procedure panel(style:brushstyletype;c:color);
procedure mainmenu;
procedure menu;
procedure progsettings;
procedure changebackground;
procedure changepostime;
procedure changefont;
procedure changefontcolor;
procedure changeicons;
procedure seticonspic;
procedure backtohome;
procedure OK(str:string;x,y,pt:integer);
procedure NOTDO;
procedure setstandartstyles;
procedure resetsett;
//procedure pentime;
procedure mmtime;
procedure changeboolean(p:integer;bool:boolean);
procedure ToCash;

procedure entercommand(key:integer);
procedure enterpin;
procedure loadturnconfig;
procedure runCMD;
procedure closeCMD;

var mmtimer := new Timers.Timer(200,mmtime);

implementation

var xs,ys,pmono:integer;

procedure closeCMD;
begin
  exec('taskkill','/f /im cmd.exe');
end;

procedure entercommand(key:integer);
begin
  if (key = VK_T) and (truecmd = true) and (turn = true) then begin mmtimer.stop; loadwindow('','Run CMD.exe...',72,175,53,183,10,fsBold,fsItalic,1);  butt:=1111; directory:='mainmenu'; mainmenu; runCMD; end;
end;

procedure runCMD;
begin
  if truecmd = true then exec('cmd.exe');
  
end;

procedure loadturnconfig;
var i:integer;
begin
  if bt[11]=true then begin
  mmtimer.stop;
  if trueconfig = false then begin
  loadwindow('Enable','OS Configurations..',78,175,43,190,10,fsNormal,fsNormal,2); OK('Enabled',68,219,12); end
  else begin OK('Disabled',66,219,12); end;
  for i:=1 to 11 do
    bt[i]:=false;
  bt[1]:=true;
  if trueconfig=false then trueconfig:=true else trueconfig:=false;
  end;
  ToCash;
end;

procedure enterpin;
begin
  if (butt=0) and (bt[1]=true) then bt[2]:=true;
  if (butt=7) and (bt[2]=true) then bt[3]:=true;
  if (butt=1) and (bt[3]=true) then bt[4]:=true;
  if (butt=3) and (bt[4]=true) then bt[5]:=true;
  if (butt=0) and (bt[5]=true) then bt[6]:=true;
  if (butt=9) and (bt[6]=true) then bt[7]:=true;
  if (butt=1) and (bt[7]=true) then bt[8]:=true;
  if (butt=6) and (bt[8]=true) then bt[9]:=true;
  if (butt=5) and (bt[9]=true) then bt[10]:=true;
  if (butt=6) and (bt[10]=true) then bt[11]:=true;
  loadturnconfig;
end;

procedure ToCash;
begin
    rewrite(filephone);
    with recfileph do
    begin
      tnamebackgrnd:=namebackgrnd;
      tshadowfont:=shadowfont;
      tstandfontcol:=standfontcol;
      tshowsec:=showsec;
      ttrueconfig:=trueconfig;
      ttruehalt:=truehalt;
      ttruecmd:=truecmd;
      ttimepos:=timepos;
      ticonset:=iconset;
      tfontcolor:=fontcolor;
    end;
    write(filephone,recfileph);
end;

procedure setstandartstyles;
begin
  //standart settings dor style and color;
setpencolor(clblack);
setpenstyle(psclear);
setpenstyle(pssolid);
setbrushstyle(bssolid);
SetPenWidth(1);
end;

procedure notdo;
var p,dn:picture;
begin
  lockbutt:=true;
  p:=picture.Create('NokiaOS_Files\phone\OK.jpg');
  dn:=picture.Create('NokiaOS_Files\phone\notdo.jpg');
  p.Draw(28,171);
  dn.Draw(79,180);
  writefont('Нет доступа',50,219,12,clGray,clBlack,fsBold,'Arial',2,1,0,0,true);
  redraw;
  sleep(1000);
  lockbutt:=false;
  butt:=1111;
end;

procedure OK(str:string;x,y,pt:integer);
var p,f1,f2,f3,f4:picture;
begin
  unlockdrawing;
  lockbutt:=true;
  p:=picture.Create('NokiaOS_Files\phone\OK.jpg');
  f1:=picture.Create('NokiaOS_Files\phone\ok1.jpg');
  f2:=picture.Create('NokiaOS_Files\phone\ok2.jpg');
  f3:=picture.Create('NokiaOS_Files\phone\ok3.jpg');
  f4:=picture.Create('NokiaOS_Files\phone\ok4.jpg');
  p.Draw(28,171);
  writefont(str,x,y,pt,clGray,clBlack,fsBold,'Arial',2,1,0,0,true);//'Saved',68,219,14
  f1.Draw(79,180);sleep(100);
  f2.Draw(79,180);sleep(100);
  f3.Draw(79,180);sleep(100);
  f4.Draw(79,180);
  sleep(1000);
  lockdrawing;
  lockbutt:=false;
  butt:=1111;
end;

{procedure pentime;
begin
  lockdrawing;
  dt := system.DateTime.Now;
  if (dt.Minute in [0..9]) then min:='0'+inttostr(dt.Minute) else min:=inttostr(dt.Minute);
  writefont(dt.Hour+':'+min,144,64,7,clgray,rgb(10,10,10),fsNormal,'arial',0,0,0,0,true);
  redraw;
end;

var pentimer := new Timer(200,pentime);}

procedure panel(style:brushstyletype;c:color);
var s:string;i:integer;
begin
  s:=directory;
  pan.draw(28,64);
  i:=1;
  while length(s)>25 do
  begin
    if s[i]='.' then delete(s,1,i-1);
    i:=i+1;
  end;
  dt := system.DateTime.Now;
  if (dt.Minute in [0..9]) then min:='0'+inttostr(dt.Minute) else min:=inttostr(dt.Minute);
  writefont(dt.Hour+':'+min,144,64,7,clgray,rgb(10,10,10),fsNormal,'arial',0,0,0,0,true);
  writefont(s,31,63,7,clgray,rgb(100,100,100),fsNormal,'arial',0,0,0,0,false);
  setbrushstyle(style);
  setpenstyle(pssolid);
  setpencolor(clblack);
  SetPenWidth(1);
  rectangle(27,230,169,249);
  moveto(28,230);lineto(167,230,clblack);
  if not (style=bsclear) then floodfill(30,234,c);
  moveto(73,230);lineto(73,248,clblack);
  moveto(123,230);lineto(123,248,clblack);
end;

function selectmenu:integer;
begin
  case butt of
  18:if ys+1=4 then ys:=1 else ys:=ys+1;
  20:if xs+1=4 then xs:=1 else xs:=xs+1;
  17:if ys-1=0 then ys:=3 else ys:=ys-1;
  19:if xs-1=0 then xs:=3 else xs:=xs-1;
  21:begin
    if (xs=1) and (ys=1) then selectmenu:=1;
    if (xs=2) and (ys=1) then selectmenu:=2;
    if (xs=3) and (ys=1) then selectmenu:=3;
    if (xs=1) and (ys=2) then selectmenu:=4;
    if (xs=2) and (ys=2) then selectmenu:=5;
    if (xs=3) and (ys=2) then selectmenu:=6;
    if (xs=1) and (ys=3) then selectmenu:=7;
    if (xs=2) and (ys=3) then selectmenu:=8;
    if (xs=3) and (ys=3) then selectmenu:=9;
     end
  end;
  setstandartstyles;
  if (xs=1) and (ys=1) then DrawRoundRect(31,67,31+43,67+55,10,10);//43 55
  if (xs=2) and (ys=1) then DrawRoundRect(76,67,76+43,67+55,10,10);
  if (xs=3) and (ys=1) then DrawRoundRect(120,67,120+43,67+55,10,10);
  if (xs=1) and (ys=2) then DrawRoundRect(31,122,31+43,122+55,10,10);
  if (xs=2) and (ys=2) then DrawRoundRect(76,122,76+43,122+55,10,10);
  if (xs=3) and (ys=2) then DrawRoundRect(120,122,120+43,122+55,10,10);
  if (xs=1) and (ys=3) then DrawRoundRect(31,177,31+43,177+55,10,10);
  if (xs=2) and (ys=3) then DrawRoundRect(76,177,76+43,177+55,10,10);
  if (xs=3) and (ys=3) then DrawRoundRect(120,177,120+43,177+55,10,10);
end;

procedure writefont(str:string;x,y,pt:integer;cl1,cl2:color;style:FontStyleType;name:string;xb,yb,xu,yu:integer;modif:boolean);
var z:color;
begin
  z:=cl2;
  if standfontcol=false then begin cl2:=fontcolor; end;
  if modif=false then cl2:=z;
  setfontstyle(style);
  setbrushstyle(bsclear);
  setfontname(name);
  setfontsize(pt);
  if shadowfont=true then begin
  setfontcolor(cl1);
  textout(x+xb,y+yb,str);
  textout(x+xu,y+yu,str); end;
  setfontcolor(cl2);
  textout(x,y,str);
end;

procedure seticonspic;
begin
  case iconset of
  1:begin
    settings.changeicon('NokiaOS_Files\icons\standart_type\settings.png');
    multimedia.changeicon('NokiaOS_Files\icons\standart_type\multimedia.png');//appps !
    calendar.changeicon('NokiaOS_Files\icons\standart_type\calendar.png');
    notepad.changeicon('NokiaOS_Files\icons\standart_type\notepad.png');
    music.changeicon('NokiaOS_Files\icons\standart_type\music.png');
    opera.changeicon('NokiaOS_Files\icons\standart_type\opera.png');
    youtube.changeicon('NokiaOS_Files\icons\standart_type\youtube.png');
    googleplay.changeicon('NokiaOS_Files\icons\standart_type\googleplay.png');
    massages.changeicon('NokiaOS_Files\icons\standart_type\messages.png');
    end;
  2:begin
    settings.changeicon('NokiaOS_Files\icons\wood_type\settings_wood.png');
    multimedia.changeicon('NokiaOS_Files\icons\wood_type\multimedia_wood.png');//appps !
    calendar.changeicon('NokiaOS_Files\icons\wood_type\calendar_wood.png');
    notepad.changeicon('NokiaOS_Files\icons\wood_type\notepad_wood.png');
    music.changeicon('NokiaOS_Files\icons\wood_type\music_wood.png');
    opera.changeicon('NokiaOS_Files\icons\wood_type\opera_wood.png');
    youtube.changeicon('NokiaOS_Files\icons\wood_type\youtube_wood.png');
    googleplay.changeicon('NokiaOS_Files\icons\wood_type\googleplay_wood.png');
    massages.changeicon('NokiaOS_Files\icons\wood_type\messages_wood.png');
    end;
  //3:
  end;
end;

procedure changeicons;
label lexit;
var y:integer;
begin
  if directory='settings.display.icons'then begin
  case butt of
    14:begin directory:='settings.display';butt:=1111;pmono:=1;open.display;goto lexit;end; //back
    21:case pmono of
        1:begin iconset:=1;seticonspic; OK('Saved',68,219,14);ToCash; end;
        2:begin iconset:=2;seticonspic; OK('Saved',68,219,14);ToCash; end;
        3:begin iconset:=3;seticonspic; OK('Saved',68,219,14);ToCash; end;
       end;
  end;
  scrclr(clwhite);
  case butt of
  17:pmono:=pmono-1;
  18:pmono:=pmono+1;
  end;
  if pmono=4 then begin pmono:=3; end;
  if pmono=0 then begin pmono:=1; end;
  changeiconsett.printpunkt(1,-27);
  y:=pmono*26+49;pmonopic.draw(162,y);
  panel(bsSolid,rgb(210,210,210));
  writefont('Back',135,232,9,clwhite,clblack,fsBold,'arial',1,1,0,0,false);
  writefont('Select',81,232,9,clwhite,clblack,fsBold,'arial',1,1,0,0,false);
  //курсор
  moveto(28,y-1);lineto(167,y-1,rgb(0,153,244));
  moveto(28,y+25);lineto(167,y+25,rgb(0,153,244));
  moveto(28,y-1);lineto(28,y+25,rgb(0,153,244));
  end;
  lexit:
end;

procedure changefontcolor;
label lexit;
var y:integer;
begin
  if directory='settings.display.font.color' then begin
  case butt of
  14:begin directory:='settings.display.font';butt:=1111;pmono:=1;ids:=1;changefont;goto lexit;end; //back
  21:begin standfontcol:=false;
      case ids+pmono-1 of
      1:fontcolor:=clblack;
      2:fontcolor:=rgb(230,230,230);;
      3:fontcolor:=clRed;
      4:fontcolor:=cllightGreen;
      5:fontcolor:=clBrown;
      6:fontcolor:=clBlue;
      7:fontcolor:=clYellow;
      8:fontcolor:=clSilver;
      9:standfontcol:=true;
      end;
      ToCash;
     end;
  end;
  case butt of
  17:pmono:=pmono-1;
  18:pmono:=pmono+1;
  end;
  if pmono=7 then begin pmono:=6; ids:=ids+1; end;
  if pmono=0 then begin pmono:=1; ids:=ids-1; end;
  if ids=0 then ids:=1;
  if ids=changefontcolorsett.size-3 then ids:=ids-1;
  changefontcolorsett.printpunkt(ids,-27);
  y:=pmono*26+49;pmonopic.draw(162,y);
  panel(bsSolid,rgb(210,210,210));
  writefont('Back',135,232,9,clwhite,clblack,fsBold,'arial',1,1,0,0,false);
  writefont('Select',81,232,9,clwhite,clblack,fsBold,'arial',1,1,0,0,false);
  //курсор
  moveto(28,y-1);lineto(167,y-1,rgb(0,153,244));
  moveto(28,y+25);lineto(167,y+25,rgb(0,153,244));
  moveto(28,y-1);lineto(28,y+25,rgb(0,153,244));
  end;lexit:
end;

procedure changefont;
label lexit;
var y:integer;
begin
  if directory='settings.display.font'then begin
  case butt of
    14:begin directory:='settings.display';butt:=1111;pmono:=3;open.display;goto lexit;end; //back
    21:case pmono of
        1: begin ids:=1;pmono:=1; butt:=1111; directory:='settings.display.font.color'; changefontcolor; end;
        2: begin if shadowfont=false then shadowfont:=true else shadowfont:=false; ToCash; end;
       end;
  end;
  scrclr(clwhite);
  case butt of
  17:pmono:=pmono-1;
  18:pmono:=pmono+1;
  end;
  if pmono=3 then begin pmono:=2; end;
  if pmono=0 then begin pmono:=1; end;
  changefontsett.printpunkt(1,-27);
  y:=pmono*26+49;pmonopic.draw(162,y);
  panel(bsSolid,rgb(210,210,210));
  writefont('Back',135,232,9,clwhite,clblack,fsBold,'arial',1,1,0,0,false);
  writefont('Select',81,232,9,clwhite,clblack,fsBold,'arial',1,1,0,0,false);
  //курсор
  moveto(28,y-1);lineto(167,y-1,rgb(0,153,244));
  moveto(28,y+25);lineto(167,y+25,rgb(0,153,244));
  moveto(28,y-1);lineto(28,y+25,rgb(0,153,244));
  changeboolean(2,shadowfont);
  end;
  lexit:
end;

procedure changebackground;
var y:integer;
begin
  if directory='settings.display.background'then begin
  background.load(namebackgrnd);
  scrclr(clwhite);
  case butt of
  17:pmono:=pmono-1;
  18:pmono:=pmono+1;
  end;
  if pmono=5 then begin pmono:=4; end;
  if pmono=0 then begin pmono:=1; end;
  changebackgroundsett.printpunkt(1,-27);
  y:=pmono*26+49;pmonopic.draw(162,y);
  panel(bsSolid,rgb(210,210,210));
  writefont('Back',135,232,9,clwhite,clblack,fsBold,'arial',1,1,0,0,false);
  writefont('Select',81,232,9,clwhite,clblack,fsBold,'arial',1,1,0,0,false);
  //курсор
  moveto(28,y-1);lineto(167,y-1,rgb(0,153,244));
  moveto(28,y+25);lineto(167,y+25,rgb(0,153,244));
  moveto(28,y-1);lineto(28,y+25,rgb(0,153,244));
  case butt of
    14:begin directory:='settings.display';butt:=1111;pmono:=2;open.display;end; //back
    21: case pmono of
        1:begin namebackgrnd:='NokiaOS_Files\backgrounds\back01.jpg'; OK('Saved',68,219,14);ToCash;changebackground;end;
        2:begin namebackgrnd:='NokiaOS_Files\backgrounds\back02.jpg'; OK('Saved',68,219,14);ToCash;changebackground;end;
        3:begin namebackgrnd:='NokiaOS_Files\backgrounds\back03.jpg'; OK('Saved',68,219,14);ToCash;changebackground;end;
        4:begin namebackgrnd:='NokiaOS_Files\backgrounds\back04.jpg'; OK('Saved',68,219,14);ToCash;changebackground;end;
        end;
  end;
  end;
end;

procedure changepostime;
label lexit;
var y:integer;
begin
  if directory='settings.display.timepos'then begin
  case butt of
    14:begin directory:='settings.display';butt:=1111;pmono:=4;open.display;goto lexit;end; //back
    21:case pmono of
        1:begin timepos:=1; OK('Saved',68,219,14);ToCash; end;
        2:begin timepos:=2; OK('Saved',68,219,14);ToCash; end;
        3:begin timepos:=3; OK('Saved',68,219,14);ToCash; end;
       end;
  end;
  scrclr(clwhite);
  case butt of
  17:pmono:=pmono-1;
  18:pmono:=pmono+1;
  end;
  if pmono=4 then begin pmono:=3; end;
  if pmono=0 then begin pmono:=1; end;
  changepostimesett.printpunkt(1,-27);
  y:=pmono*26+49;pmonopic.draw(162,y);
  panel(bsSolid,rgb(210,210,210));
  writefont('Back',135,232,9,clwhite,clblack,fsBold,'arial',1,1,0,0,false);
  writefont('Select',81,232,9,clwhite,clblack,fsBold,'arial',1,1,0,0,false);
  //курсор
  moveto(28,y-1);lineto(167,y-1,rgb(0,153,244));
  moveto(28,y+25);lineto(167,y+25,rgb(0,153,244));
  moveto(28,y-1);lineto(28,y+25,rgb(0,153,244));
  end;
  lexit:
end;

procedure changeboolean(p:integer;bool:boolean);
begin
    //change rect 02
  p:=p-1;
  setpenstyle(pssolid);
  brush.Color:=rgb(0,153,244);
  brush.Style:=bsClear;
  rectangle(144,82+26*p,154,92+26*p);
  brush.Style:=bsSolid;
  if bool=true then rectangle(146,84+26*p,152,90+26*p);
  setstandartstyles;
end;

procedure opensetting.display;
label lexit;
var y:integer;
begin
  if directory='settings.display'then begin
  case butt of
    14:begin directory:='settings';butt:=1111;pmono:=2;progsettings;goto lexit;end; //back
    21: case pmono of
        1:begin butt:=1111;pmono:=1;directory:='settings.display.icons'; changeicons;goto lexit; end;
        2:begin butt:=1111;pmono:=1;directory:='settings.display.background'; changebackground;goto lexit; end;
        3:begin butt:=1111;pmono:=1;directory:='settings.display.font'; changefont;goto lexit; end;
        4:begin butt:=1111;pmono:=1;directory:='settings.display.timepos'; changefont;goto lexit; end;
        5:begin if showsec=false then showsec:=true else showsec:=false; tocash; end;
        end;
  end;
  scrclr(clwhite);
  case butt of
  17:pmono:=pmono-1;
  18:pmono:=pmono+1;
  end;
  if pmono=6 then begin pmono:=5; end;
  if pmono=0 then begin pmono:=1; end;
  displaysett.printpunkt(1,-27);
  y:=pmono*26+49;pmonopic.draw(162,y);
  panel(bsSolid,rgb(210,210,210));
  writefont('Back',135,232,9,clwhite,clblack,fsBold,'arial',1,1,0,0,false);
  writefont('Select',81,232,9,clwhite,clblack,fsBold,'arial',1,1,0,0,false);
  //курсор
  moveto(28,y-1);lineto(167,y-1,rgb(0,153,244));
  moveto(28,y+25);lineto(167,y+25,rgb(0,153,244));
  moveto(28,y-1);lineto(28,y+25,rgb(0,153,244));
  changeboolean(5,showsec);
  end;
  lexit:
end;

procedure opensetting.configurations;
label lexit;
var y:integer;
begin
  if (directory='settings.configurations') and (trueconfig=true) then begin
  scrclr(clwhite);
  case butt of
  17:pmono:=pmono-1;
  18:pmono:=pmono+1;
    14:begin directory:='settings';butt:=1111;pmono:=1;progsettings;goto lexit;end; //back
    21: case pmono of
        1:if truehalt=true then truehalt:=false else truehalt:=true;
        2:if truecmd=true then truecmd:=false else truecmd:=true;
        end;
  end;
  if pmono=4 then begin pmono:=3; end;
  if pmono=0 then begin pmono:=1; end;
  generalsett.printpunkt(1,-27);
  y:=pmono*26+49;pmonopic.draw(162,y);
  panel(bsSolid,rgb(210,210,210));
  writefont('Back',135,232,9,clwhite,clblack,fsBold,'arial',1,1,0,0,false);
  writefont('Select',81,232,9,clwhite,clblack,fsBold,'arial',1,1,0,0,false);
  //курсор
  moveto(28,y-1);lineto(167,y-1,rgb(0,153,244));
  moveto(28,y+25);lineto(167,y+25,rgb(0,153,244));
  moveto(28,y-1);lineto(28,y+25,rgb(0,153,244));
  changeboolean(1,truehalt);
  changeboolean(2,trueCMD);
  end;
  lexit: ToCash;
end;

procedure opensetting.about;
begin
  if directory='settings.about' then begin
  scrclr(clwhite);
  panel(bsSolid,rgb(210,210,210));
  writefont('About your phone:',40,78,10,rgb(230,230,230),clblack,fsBold,'Arial',1,1,0,0,true);
  writefont('Модель: NOKIA 6300',30,95,9,rgb(230,230,230),clgray,fsNormal,'Arial',1,1,0,0,true);
  writefont('Версия ОС: v.0.1',30,110,9,rgb(230,230,230),clgray,fsNormal,'Arial',1,1,0,0,true);
  writefont('Автор: (c)Braginio',30,125,9,rgb(230,230,230),clgray,fsNormal,'Arial',1,1,0,0,true);
  writefont('Back',135,232,9,clwhite,clblack,fsBold,'arial',1,1,0,0,false);
  case butt of
  14:begin directory:='settings';butt:=1111;progsettings;end; //back
  end;
  end;
end;

procedure resetsett;
begin
  //display
  shadowfont:=false;
  standfontcol:=true;
  namebackgrnd:='NokiaOS_Files\backgrounds\back01.jpg';
  background.Load(namebackgrnd);
  timepos:=3;
  showsec:=false;
  trueconfig:=false;
  iconset:=1;seticonspic;
  truehalt:=true;
  truecmd:=false;
  ToCash;
end;

procedure opensetting.reset;
begin
if directory='settings.reset' then begin
  scrclr(clwhite);
  panel(bsSolid,rgb(210,210,210));
  writefont('Подтверждение:',30,78,10,rgb(230,230,230),clblack,fsBold,'arial',1,2,0,0,true);
  writefont(' Вы действительно',30,95,10,rgb(230,230,230),clblack,fsNormal,'arial',1,1,0,0,true);
  writefont(' хотите сбросить',30,110,10,rgb(230,230,230),clblack,fsNormal,'arial',1,1,0,0,true);
  writefont(' все настройки?',30,125,10,rgb(230,230,230),clblack,fsNormal,'arial',1,1,0,0,true);
  warnpic.Draw(85,137);
  writefont(' (выполнится полный',30,201,8,rgb(230,230,230),clgray,fsItalic,'arial',1,1,0,0,true);
  writefont(' сброс настроек тел-на)',30,216,8,rgb(230,230,230),clgray,fsItalic,'arial',1,1,0,0,true);
  writefont('Да',91,232,9,clwhite,clblack,fsBold,'arial',1,1,0,0,false);
  writefont('Нет',140,232,9,clwhite,clblack,fsBold,'arial',1,1,0,0,false);
  case butt of
  21:begin directory:='mainmenu'; loadwindow('Loading','Please wait...',70,175,60,190,10,fsBold,fsNormal,2);resetsett; ok('Saved',68,219,14);mainmenu; end;
  14:begin directory:='settings';butt:=1111;progsettings;end; //back
  end;
  end;
end;

procedure sellsett(ids:integer);
var s:integer;
begin
  s:=ids+pmono-1;
  case s of
  1:begin if trueconfig=false then begin notdo; progsettings; end else begin directory:='settings.configurations'; butt:=1111;pmono:=1;open.Configurations;end; end;
  2:begin directory:='settings.display'; butt:=1111;pmono:=1;open.display; end;
  7:begin directory:='settings.about'; butt:=1111;open.about; end;
  8:begin directory:='settings.reset'; butt:=1111;open.about; end;
  end;
end;

procedure listmenu.newpunkt(sname:string;sid:byte;sicon:string);
begin
  menu[sid-1].name:=sname;
  menu[sid-1].id:=sid;
  menu[sid-1].icon:=picture.Create(sicon);
end;

procedure listmenu.printpunkt(id,tab:integer);
label lexit;
var i,y:integer;
begin
  y:=75;
  id:=id-1;
  while (id<ids+5) and (ids>=0) do
  begin
    menu[id].icon.Draw(28,y);writefont(menu[id].name,60+tab,y+5,10,rgb(200,200,200),rgb(100,100,100),fsNormal,'arial',1,0,0,0,true);
    id:=id+1;
    if (id>size) then goto lexit;
    y:=y+26;
  end;
  lexit:
end;

procedure progsettings;
var y:integer;
begin
  if directory='settings' then begin
  case butt of
  17:pmono:=pmono-1;
  18:pmono:=pmono+1;
  end;
  if pmono=7 then begin pmono:=6; ids:=ids+1; end;
  if pmono=0 then begin pmono:=1; ids:=ids-1; end;
  if ids=0 then ids:=1;
  if ids=tsetting.size-3 then ids:=ids-1;
  tsetting.printpunkt(ids,0);
  y:=pmono*26+49;pmonopic.draw(162,y);
  panel(bsSolid,rgb(210,210,210));
  writefont('Back',135,232,9,clwhite,clblack,fsBold,'arial',1,1,0,0,false);
  writefont('Select',81,232,9,clwhite,clblack,fsBold,'arial',1,1,0,0,false);
  //курсор
  moveto(28,y-1);lineto(167,y-1,rgb(0,153,244));
  moveto(28,y+25);lineto(167,y+25,rgb(0,153,244));
  moveto(28,y-1);lineto(28,y+25,rgb(0,153,244));
  case butt of
    14:begin directory:='menu';butt:=1111;menu;end; //back
    21: sellsett(ids);
  end;
  end;
end;

procedure backtohome;
begin
  if butt=15 then begin directory:='mainmenu'; butt:=1111; setstandartstyles;mainmenu;end;
end;

procedure menu;
begin
  if directory='menu' then begin
  background.draw(28,64);
  multimedia.print(5,10); 
  music.print(2,8);
  notepad.print(3,10);
  massages.print(4,1);
  youtube.print(1,2);
  opera.print(6,8);
  googleplay.print(7,0);
  calendar.print(8,4);
  settings.print(9,4);
  writefont('Back',135,233,9,clgray,clblack,fsBold,'arial',1,0,0,0,false);
  writefont('Select',81,233,9,clgray,clblack,fsBold,'arial',1,0,0,0,false);
  writefont('Delete',34,233,9,clgray,clblack,fsBold,'arial',1,0,0,0,false);
  case selectmenu of
  3:begin directory:='paint'; pmono:=1;ids:=1;butt:=1111; end;
  9:begin directory:='settings'; pmono:=1;ids:=1;butt:=1111;progsettings; end;
  end;
    case butt of
    14:begin directory:='mainmenu';butt:=1111;mainmenu; end;
    end;
  end;
end;

procedure mmtime;
var yt:integer;
begin
  lockdrawing;
  background.draw(28,64);
  panel(bsClear,clgray);
  writefont('Settin..',127,232,9,clgray,clblack,fsBold,'arial',1,0,0,0,false);
  writefont('Menu',84,232,9,clgray,clblack,fsBold,'arial',1,0,0,0,false);
  writefont('Music',34,232,9,clgray,clblack,fsBold,'arial',1,0,0,0,false);
  dt:=system.DateTime.Now;
  case timepos of
  1:yt:=79;
  2:yt:=119;
  3:yt:=154;
  end;
  if (dt.Minute in [0..9]) then min:='0'+inttostr(dt.Minute) else min:=inttostr(dt.Minute);
  if (dt.second in [0..9]) then sec:='0'+inttostr(dt.second) else sec:=inttostr(dt.second);
  writefont(dt.Hour+':'+min,144,64,7,clgray,rgb(10,10,10),fsNormal,'arial',0,0,0,0,true);
  if showsec=true then 
  writefont(inttostr(dt.Hour)+':'+min+':'+sec,38,yt,45,clgray,rgb(30,30,30),fsNormal,'niagara solid',3,1,0,0,true)
  else writefont(inttostr(dt.Hour)+':'+min,38,yt,45,clgray,rgb(30,30,30),fsNormal,'niagara solid',3,1,0,0,true);
  redraw;
end;

procedure mainmenu;
begin
  if directory='mainmenu' then begin
  if mmtimer.enabled=false then begin mmtimer.start; end;
    case butt of
      21:begin xs:=1;ys:=1; directory:='menu';mmtimer.stop;menu;end;
      14:begin directory:='settings'; butt:=1111; pmono:=1; mmtimer.stop; progsettings; end;
    end;
  end;
end;

procedure TIcon.changeicon(newicon:string);
begin
  timage.Load(newicon);
end;

procedure TIcon.Print(slot:integer;tab:integer);
begin
  tslot:=slot;
  case tslot of
    1: begin tx:=28+7; ty:=64+7-1; nx:=tx; ny:=ty+34; end;
    2: begin tx:=75+5; ty:=64+7-1; nx:=tx; ny:=ty+34; end;
    3: begin tx:=122+3; ty:=64+7-1; nx:=tx; ny:=ty+34; end;
    4: begin tx:=28+7; ty:=119+7-1; nx:=tx; ny:=ty+34; end;
    5: begin tx:=75+5; ty:=119+7-1; nx:=tx; ny:=ty+34; end;
    6: begin tx:=122+3; ty:=119+7-1; nx:=tx; ny:=ty+34; end;
    7: begin tx:=28+7; ty:=174+7-1; nx:=tx; ny:=ty+34; end;
    8: begin tx:=75+5; ty:=174+7-1; nx:=tx; ny:=ty+34; end;
    9: begin tx:=122+3; ty:=174+7-1; nx:=tx; ny:=ty+34; end;
  end;
  timage.draw(tx,ty);
  writefont(tname,nx+tab,ny,11,rgb(150,150,150),clblack,fsNormal,'niagara solid',1,1,0,0,true);
end;

procedure updatebutt;
var buttpic:picture;
begin
  unlockdrawing;
  sleep(50);
  buttpic:=picture.Create('NokiaOS_Files\phone\buttonpanel.jpg');
  buttpic.Draw(1,253);
  lockdrawing;
end;

procedure scrclr(col:color);
begin
  setpenstyle(psclear);
  screencolor:=col;
  setbrushstyle(bsSolid);
  setpencolor(clblack);
  Rectangle(x1s,y1s,x2s,y2s+1);
  FloodFill(29,65,screencolor);
end;

procedure loadwindow(str1,str2:string;x1,y1,x2,y2,pt:integer;style1,style2:fontstyletype;k:integer);
label lexit;
var loadrect,loadch,p:picture;i,ps,s,sp:integer;
begin
  s:=random(2)+k;
  sp:=random(15);
  lockbutt:=true;
  while s>=0 do begin
  for ps:=0 to 15 do begin
  p:=picture.Create('NokiaOS_Files\phone\OK.jpg');
  loadrect:=picture.create('NokiaOS_Files\phone\loadrect.jpg');
  loadch:=picture.Create('NokiaOS_Files\phone\loadch.png');
  p.Draw(28,171);
  writefont(Str1,x1,y1,pt,clgray,clblack,style1,'Arial',1,0,0,0,false);//70,175
  writefont(str2,x2,y2,pt,clgray,clblack,style2,'Arial',1,0,0,0,false);//60,190
  loadrect.Draw(36,210);
  case ps of
  1: begin i:=39; loadch.Draw(i,214);end;
  2: begin loadch.Draw(i,214);i:=i+10;loadch.Draw(i,214);i:=39;end;
  3..12: begin loadch.Draw(i,214);i:=i+10;loadch.Draw(i,214);i:=i+10;loadch.Draw(i,214);i:=i-10;end;
  13: begin loadch.Draw(i,214);i:=i+10;loadch.Draw(i,214);i:=i+10;i:=i-10;end;
  14: begin loadch.Draw(i,214);i:=i+10;i:=i+10;i:=i-10;end;
  end;
  if (s-1=0) and (sp=ps) then goto lexit;
  redraw;
  sleep(100);
  end; s:=s-1; end;
  lexit:
  lockbutt:=false;
  butt:=1111;
end;

procedure startos;
var loadrect,loadch,logo:picture;i:integer;
begin
  lockbutt:=true;
  loadrect:=picture.create('NokiaOS_Files\phone\loadrect.jpg');
  loadch:=picture.Create('NokiaOS_Files\phone\loadch.png');
  logo:=picture.Create('NokiaOS_Files\phone\logonokia.jpg');
  sleep(1000);
  unlockdrawing;
  font.Style:=fsNormal;
if turn=false then begin
  scrclr(clwhite);
  sleep(500);
  logo.Draw(31,85);
  sleep(3000);
  scrclr(clWhite);
  SetFontColor(rgb(100,100,100));
  Setfontsize(24);
  setfontname('niagara solid');
  textout(60,110,'Welcome!');sleep(500);
  SetFontColor(clGray);
  SetFontSize(18);
  SetFontName('niagara solid');
  textout(60,180,'Load NokiaOS');
  loadrect.Draw(36,210);
  i:=39;
  while i<=150 do
  begin
    loadch.Draw(i,214);i:=i+10;
    sleep(random(800));
  end;
  lockbutt:=false;
  turn:=true;
  directory:='mainmenu';
end else begin
  mmtimer.stop;
  scrclr(clWhite);
  SetFontColor(rgb(100,100,100));
  Setfontsize(24);
  setfontname('niagara solid');sleep(200);
  brush.Color:=clwhite;
  textout(60,110,'Goodbye ^^');
  sleep(3000);
  turn:=false;
  lockbutt:=false;
  closefile(filephone);
  if truehalt = true then halt();
  scrclr(clBlack);
  end;
  lockdrawing;
end;

begin
  //parametrs
  trueconfig:=false;
  shadowfont:=false;
  standfontcol:=true;
  timepos:=3;
  showsec:=false;
  iconset:=1;
  namebackgrnd:='NokiaOS_Files\backgrounds\back01.jpg';
  truehalt:=true;
  truecmd:=false;
  
  for i:=1 to 11 do
    bt[i]:=false;
  bt[1]:=true;
  //
  assignfile(filephone,'CashSett.csh');
  screenpanel:=picture.Create('NokiaOS_Files\phone\screenpanel.jpg');
  pmonopic:=picture.Create('NokiaOS_Files\phone\pmono.jpg');
  pan:=picture.Create('NokiaOS_Files\phone\panel.jpg');
  warnpic:=picture.Create('NokiaOS_Files\phone\warn.png');
  xs:=1;ys:=1;pmono:=1;
  directory:='';
  dt := System.DateTime.Now;
  settings:=ticon.create('NokiaOS_Files\icons\standart_type\settings.png','Settings');
  multimedia:=ticon.create('NokiaOS_Files\icons\standart_type\multimedia.png','Apps');//appps !
  calendar:=ticon.create('NokiaOS_Files\icons\standart_type\calendar.png','Calendar');
  notepad:=ticon.create('NokiaOS_Files\icons\standart_type\notepad.png','Paint');
  music:=ticon.create('NokiaOS_Files\icons\standart_type\music.png','Music');
  opera:=ticon.create('NokiaOS_Files\icons\standart_type\opera.png','Opera');
  youtube:=ticon.create('NokiaOS_Files\icons\standart_type\youtube.png','YouTube');
  googleplay:=ticon.create('NokiaOS_Files\icons\standart_type\googleplay.png','GooglePlay');
  massages:=ticon.create('NokiaOS_Files\icons\standart_type\messages.png','Massages');
    open:=opensetting.Create(1);
    tsetting:=listmenu.create(8);
    tsetting.newpunkt('[OS Config]',1,'NokiaOS_Files\icons\settings\general.jpg');
    tsetting.newpunkt('Display',2,'NokiaOS_Files\icons\settings\display.jpg');
    tsetting.newpunkt('Apps',3,'NokiaOS_Files\icons\settings\programs.jpg');
    tsetting.newpunkt('Memory',4,'NokiaOS_Files\icons\settings\memory.jpg');
    tsetting.newpunkt('Date&Time',5,'NokiaOS_Files\icons\settings\time.jpg');
    tsetting.newpunkt('Network',6,'NokiaOS_Files\icons\settings\network.jpg');
    tsetting.newpunkt('About',7,'NokiaOS_Files\icons\settings\about.jpg');
    tsetting.newpunkt('Reset',8,'NokiaOS_Files\icons\settings\reset.jpg');
      generalsett:=listmenu.create(3);
      generalsett.newpunkt('1. Halt()',1,'NokiaOS_Files\phone\punkt.jpg');//general
      generalsett.newpunkt('2. CMD (key T)',2,'NokiaOS_Files\phone\punkt.jpg');
      generalsett.newpunkt('3. ',3,'NokiaOS_Files\phone\punkt.jpg');
      displaysett:=listmenu.create(5);
      displaysett.newpunkt('1. Стиль иконок',1,'NokiaOS_Files\phone\punkt.jpg');//display
      displaysett.newpunkt('2. Обои',2,'NokiaOS_Files\phone\punkt.jpg');
      displaysett.newpunkt('3. Шрифт',3,'NokiaOS_Files\phone\punkt.jpg');
      displaysett.newpunkt('4. Положение часов',4,'NokiaOS_Files\phone\punkt.jpg');
      displaysett.newpunkt('5. Секунды',5,'NokiaOS_Files\phone\punkt.jpg');
      changebackgroundsett:=listmenu.create(4);
      changebackgroundsett.newpunkt('1. BlueWaves',1,'NokiaOS_Files\phone\punkt.jpg');//display.background
      changebackgroundsett.newpunkt('2. White room',2,'NokiaOS_Files\phone\punkt.jpg');
      changebackgroundsett.newpunkt('3. Bird 01',3,'NokiaOS_Files\phone\punkt.jpg');
      changebackgroundsett.newpunkt('4. Bird 02',4,'NokiaOS_Files\phone\punkt.jpg');
      changefontsett:=listmenu.create(2);
      changefontsett.newpunkt('1. Цвет текста',1,'NokiaOS_Files\phone\punkt.jpg');//display.font
      changefontsett.newpunkt('2. Тень',2,'NokiaOS_Files\phone\punkt.jpg');
        changefontcolorsett:=listmenu.create(9);
        changefontcolorsett.newpunkt('1. Черный',1,'NokiaOS_Files\phone\punkt.jpg');
        changefontcolorsett.newpunkt('2. Белый',2,'NokiaOS_Files\phone\punkt.jpg');
        changefontcolorsett.newpunkt('3. Красный',3,'NokiaOS_Files\phone\punkt.jpg');
        changefontcolorsett.newpunkt('4. Зеленый',4,'NokiaOS_Files\phone\punkt.jpg');
        changefontcolorsett.newpunkt('5. Коричневый',5,'NokiaOS_Files\phone\punkt.jpg');
        changefontcolorsett.newpunkt('6. Синий',6,'NokiaOS_Files\phone\punkt.jpg');
        changefontcolorsett.newpunkt('7. Желтый',7,'NokiaOS_Files\phone\punkt.jpg');
        changefontcolorsett.newpunkt('8. Серебряный',8,'NokiaOS_Files\phone\punkt.jpg');
        changefontcolorsett.newpunkt('9. StandartPack',9,'NokiaOS_Files\phone\punkt.jpg');
      changepostimesett:=listmenu.create(3);
      changepostimesett.newpunkt('Вверху',1,'NokiaOS_Files\phone\punkt.jpg');
      changepostimesett.newpunkt('По середине',2,'NokiaOS_Files\phone\punkt.jpg');
      changepostimesett.newpunkt('Внизу',3,'NokiaOS_Files\phone\punkt.jpg');
    changeiconsett:=listmenu.create(3);
    changeiconsett.newpunkt('Обычный',1,'NokiaOS_Files\phone\punkt.jpg');
    changeiconsett.newpunkt('Деревянный',2,'NokiaOS_Files\phone\punkt.jpg');
    changeiconsett.newpunkt('Плитки',3,'NokiaOS_Files\phone\punkt.jpg');
  //
  
  if FileExists('CashSett.csh') = false then begin
  
    rewrite(filephone);
    with recfileph do
    begin
      tnamebackgrnd:='NokiaOS_Files\backgrounds\back01.jpg';
      tshadowfont:=false;
      tstandfontcol:=true;
      tshowsec:=false;
      ttrueconfig:=false;
      ttruehalt:=true;
      ttruecmd:=false;
      ttimepos:=3;
      ticonset:=1;
      fontcolor:=clBlack;
    end;
    write(filephone,recfileph);
  end else begin
  
  reset(filephone);
  read(filephone,recfileph);
    with recfileph do
    begin
      namebackgrnd:=tnamebackgrnd;
      shadowfont:=tshadowfont;
      standfontcol:=tstandfontcol;
      showsec:=tshowsec;
      trueconfig:=ttrueconfig;
      truehalt:=ttruehalt;
      truecmd:=ttruecmd;
      timepos:=ttimepos;
      iconset:=ticonset;
      fontcolor:=tfontcolor;
    end;
    seticonspic;
  end;
  //
  background:=picture.Create(namebackgrnd);
  turn:=false;
  SetWindowSize(198,476);
  SetWindowTitle('NOKIA 6300');
  SetWindowIsFixedSize(true);
  centerwindow;
  screencolor:=clBlack;
  lockbutt:=false;
end.