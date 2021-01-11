program phone;

uses GraphABC, Nokia_OS, utility_paint;

var bt1,bt2,bt3,bt4,bt5,bt6,bt7,bt8,bt9,bt0,btr,btz,btq,bte,btgr,btrd,btup,btdown,btright,btleft,btcent:picture;

procedure Button(x,y,mb:integer);
label lexit;
begin
if lockbutt=false then begin
  if (x in [24..67]) and (y in [349..364]) and (mb=1) then begin bt1.Draw(15,339); butt:=1; end else
  if (x in [71..122]) and (y in [345..366]) and (mb=1) then begin bt2.Draw(71,342); butt:=2; end else
  if (x in [128..173]) and (y in [345..366]) and (mb=1) then begin bt3.Draw(125,342); butt:=3; end else
  if (x in [22..66]) and (y in [373..391]) and (mb=1) then begin bt4.Draw(19,369); butt:=4; end else
  if (x in [73..123]) and (y in [371..393]) and (mb=1) then begin bt5.Draw(71,369); butt:=5; end else
  if (x in [128..174]) and (y in [372..392]) and (mb=1) then begin bt6.Draw(125,369); butt:=6; end else
  if (x in [22..68]) and (y in [398..417]) and (mb=1) then begin bt7.Draw(19,395); butt:=7; end else
  if (x in [73..122]) and (y in [397..418]) and (mb=1) then begin bt8.Draw(71,395); butt:=8; end else
  if (x in [128..174]) and (y in [398..418]) and (mb=1) then begin bt9.Draw(125,395); butt:=9; end else
  if (x in [22..66]) and (y in [424..444]) and (mb=1) then begin btz.Draw(19,421); butt:=11; end else
  if (x in [73..122]) and (y in [423..445]) and (mb=1) then begin bt0.Draw(71,421); butt:=0; end else
  if (x in [127..175]) and (y in [425..445]) and (mb=1) then begin btr.Draw(125,421); butt:=12; end else
  if (x in [24..58]) and (y in [264..284]) and (mb=1) then begin btq.Draw(26,267); butt:=13; end else
  if (x in [135..170]) and (y in [264..284]) and (mb=1) then begin bte.Draw(134,261); butt:=14; end else
  if (x in [136..170]) and (y in [300..319]) and (mb=1) then begin btrd.Draw(135,300); butt:=15; end else
  if (x in [136..170]) and (y in [300..319]) and (mb=2) then begin btrd.Draw(135,300); butt:=22; end else
  if (x in [23..61]) and (y in [300..321]) and (mb=1) then begin btgr.Draw(23,299); butt:=16; end else
  if (x in [78..113]) and (y in [263..276]) and (mb=1) then begin btup.Draw(63,255); butt:=17; end else
  if (x in [85..114]) and (y in [308..324]) and (mb=1) then begin btdown.Draw(63,255); butt:=18; end else
  if (x in [66..81]) and (y in [277..305]) and (mb=1) then begin btright.Draw(63,255); butt:=19; end else
  if (x in [114..127]) and (y in [280..308]) and (mb=1) then begin btleft.Draw(63,255); butt:=20; end else
  if (x in [86..109]) and (y in [280..303]) and (mb=1) then begin btcent.Draw(63,255); butt:=21; end else goto lexit;
updatebutt;
end;
  
  lockdrawing;
  setstandartstyles;
  if butt=22 then begin startos; end;
  
  if (turn=true) then
  begin
  //OSConfig
    EnterPIN;
  //basic
    mainmenu;
    menu;
    progsettings;
      open.about;
      open.configurations;
      open.display;
        changeicons;
        changebackground;
        changefont;
          changefontcolor;
        changepostime;
      open.reset;
    //paint
    pmenu;
      pscreen;
      psett;
        setpcolor;
        setpstyle;
        setpwidth;
        setpinstr;  
    p15;
    
    backtohome;
  end;
  lexit: redraw;
  setstandartstyles;
end;

procedure mousedown(x,y,mb:integer);
begin
  if (directory='paint.screen') and ((x in [28..167])and(y in [75..229])) then
  begin
  inbuffundo;
  lockdrawing;
  screenpanel.Draw(0,0);buffpaint.Draw(28,75);
  panel(bsSolid,rgb(210,210,210));
  writefont('Back',135,232,9,clwhite,clblack,fsBold,'arial',1,1,0,0,false);
  writefont('Settings',76,232,9,clwhite,clblack,fsBold,'arial',1,0,0,0,false);
  writefont('Undo',34,232,9,clwhite,clblack,fsBold,'arial',1,0,0,0,false);
  case paintinstrument of
  'pen':begin
        moveto(x,y);
  if mb=1 then begin setpixel(x,y,pencolor); end;
  end;
  'fill':floodfill(x,y,pencolor);
  'nill':pnill(x,y,mb);
  'neg':pneg(x,y,mb);
  end;
  end;
end;

procedure pmoving(x,y,mb:integer);
begin
  if (directory='paint.screen') and (mb=1) and ((x in [28..167])and(y in [75..229])) then
  begin
  unlockdrawing;
  case paintinstrument of
  'pen':begin setpencolor(pencolor);
  setpenstyle(penstyle);
  SetPenWidth(penwidth);
  lineto(x,y);
  end;
  'fill':begin end;
  'nill':pnill(x,y,mb);
  'neg':pneg(x,y,mb);
  end;
  lockdrawing;
  end;
end;

procedure crd(x,y,mb:integer);
begin
  
  //writefont(,1,457,10,clwhite,clblack,fsnormal,'arial',1,2,1,2,true);
end;

begin
//phone .exe
  bt1:=picture.Create('NokiaOS_Files\phone\bt1.jpg');
  bt2:=picture.Create('NokiaOS_Files\phone\bt2.jpg');
  bt3:=picture.Create('NokiaOS_Files\phone\bt3.jpg');
  bt4:=picture.Create('NokiaOS_Files\phone\bt4.jpg');
  bt5:=picture.Create('NokiaOS_Files\phone\bt5.jpg');
  bt6:=picture.Create('NokiaOS_Files\phone\bt6.jpg');
  bt7:=picture.Create('NokiaOS_Files\phone\bt7.jpg');
  bt8:=picture.Create('NokiaOS_Files\phone\bt8.jpg');
  bt9:=picture.Create('NokiaOS_Files\phone\bt9.jpg');
  bt0:=picture.Create('NokiaOS_Files\phone\bt0.jpg');
  btz:=picture.Create('NokiaOS_Files\phone\btz.jpg');
  btr:=picture.Create('NokiaOS_Files\phone\btr.jpg');
  btq:=picture.Create('NokiaOS_Files\phone\btq.jpg');
  bte:=picture.Create('NokiaOS_Files\phone\bte.jpg');
  btgr:=picture.Create('NokiaOS_Files\phone\btgr.jpg');
  btrd:=picture.Create('NokiaOS_Files\phone\btrd.jpg');
  btup:=picture.Create('NokiaOS_Files\phone\btup.jpg');
  btdown:=picture.Create('NokiaOS_Files\phone\btdown.jpg');
  btright:=picture.Create('NokiaOS_Files\phone\btright.jpg');
  btleft:=picture.Create('NokiaOS_Files\phone\btleft.jpg');
  btcent:=picture.Create('NokiaOS_Files\phone\btcent.jpg');
window.fill('NokiaOS_Files\phone\phone.jpg');
Rectangle(x1s,y1s,x2s,y2s);
FloodFill(x1s+1,y1s+1,screencolor);
OnMouseDown:=mousedown+Button+crd;
OnMouseMove:=pmoving;
OnMouseUp:=bufferpaint;
OnKeyDown:=entercommand;
OnClose:=closecmd;
end.