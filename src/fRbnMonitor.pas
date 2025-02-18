unit fRbnMonitor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  ComCtrls, ActnList, StdCtrls, Grids, lNetComponents, lNet, lclType, ExtCtrls,
  RegExpr;

const
  C_MAX_ROWS = 1000;     //max lines in the list of RBN spots
  C_MAX_DUPE_LIST = 300; //max spots for dupe check. Should be enough to filter same spot from different spotters

type
    TCounter = record
    total    : longint;
    minute   : integer;   //this and below resets every minute, so integer is enough.
    spot     : integer;
    dupe     : integer;
    pass     : integer;
    BandMap  : integer;
    xplanet  : integer;
    end;

type
  TRbnSpot = record
    spotter : String[20];
    dxstn   : String[20];
    freq    : String[20];
    mode    : String[10];
    qsl     : String[2];
    dxinfo  : String[1];
    stren   : String[3];
    LoTW    : String[1];
    eQSL    : String[1];
  end;


type

  { TfrmRbnMonitor }

  TfrmRbnMonitor = class(TForm)
    acRbnMonitor: TActionList;
    acConnect: TAction;
    acDisconnect: TAction;
    acFontSettings: TAction;
    acFilter: TAction;
    acRbnServer: TAction;
    acScrollDown : TAction;
    acHelp : TAction;
    acClear: TAction;
    btnEatFocus: TButton;
    dlgFont: TFontDialog;
    imgRbnMonitor: TImageList;
    lblRate: TLabel;
    pnlTools: TPanel;
    sbRbn: TStatusBar;
    sgRbn: TStringGrid;
    tbtnClear: TToolButton;
    tbtnConnect: TToolButton;
    tbtnFilter: TToolButton;
    tbtnFont: TToolButton;
    tbtnHelp: TToolButton;
    tbtnLastLine: TToolButton;
    tbtnServer: TToolButton;
    tmrSpotRate: TTimer;
    tmrUnfocus: TTimer;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton11: TToolButton;
    ToolButton2: TToolButton;
    ToolButton4: TToolButton;
    ToolButton7: TToolButton;
    procedure acClearExecute(Sender: TObject);
    procedure acConnectExecute(Sender: TObject);
    procedure acDisconnectExecute(Sender: TObject);
    procedure acFilterExecute(Sender: TObject);
    procedure acFontSettingsExecute(Sender: TObject);
    procedure acHelpExecute(Sender : TObject);
    procedure acRbnServerExecute(Sender: TObject);
    procedure acScrollDownExecute(Sender : TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyUp(Sender : TObject; var Key : Word; Shift : TShiftState);
    procedure FormShow(Sender: TObject);
    procedure sgRbnDblClick(Sender: TObject);
    procedure sgRbnDrawCell(Sender: TObject; aCol, aRow: Integer; aRect: TRect;
      aState: TGridDrawState);
    procedure sgRbnHeaderSized(Sender: TObject; IsColumn: Boolean;
      Index: Integer);
    procedure sgRbnMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure tmrSpotRateTimer(Sender: TObject);
    procedure tmrUnfocusTimer(Sender: TObject);
  private
    lTelnet        : TLTelnetClientComponent;
    SrcCalls       : TStringlist;
    SpotCount      : TCounter;
    slDupeCheck    : TStringlist;
    DupeFiltUsed   : boolean;
    DupeResolution : integer;
    WaitMe         : boolean;
    NoScroll       : boolean;
    NoSpotsRcvd    : boolean;  //false. Set active if telnet recieved is zero during last minute.
                              //if true and still zero received initiates telnet reconnect
    DxccWithLoTW              : Boolean;
    fil_SrcCont               : String;
    fil_SrcCalls              : TStringList;
    fil_IgnWkdHour            : Boolean;
    fil_IgnHourValue          : Integer;
    fil_IgnDate               : Boolean;
    fil_IgnDateValue          : String;
    fil_IgnTimeValue          : String;
    fil_AllowAllCall          : Boolean;
    fil_AllowOnlyCall         : Boolean;
    fil_AllowOnlyCallValue    : String;
    fil_AllowOnlyCallReg      : Boolean;
    fil_AllowOnlyCallRegValue : String;
    fil_AllowCont             : String;
    fil_AllowBands            : String;
    fil_AllowModes            : String;
    fil_AllowCnty             : String;
    fil_NotCnty               : String;
    fil_LoTWOnly              : Boolean;
    fil_eQSLOnly              : Boolean;
    fil_NewDXCOnly            : Boolean;
    fil_ToBandMap             : Boolean;
    fil_gcfgNewCountryColor   : TColor;
    fil_gcfgNewBandColor      : TColor;
    fil_gcfgNewModeColor      : TColor;
    fil_ThBckColor            : Integer;
    fil_gcfgUseBackColor      : Boolean;
    fil_gcfgeUseBackColor     : Boolean;
    fil_gcfgBckColor          : TColor;
    fil_gcfgeBckColor         : TColor;
    fil_gcfgUseDXCColors      : Boolean;

    DebugThis                 : boolean;

    procedure lConnect(aSocket: TLSocket);
    procedure lDisconnect(aSocket: TLSocket);
    procedure lReceive(aSocket: TLSocket);
    procedure ClearAllCounters;
    procedure ClearCounters;
    procedure ParseSpots(spot:String; var InSpot:TRBNSpot);
    procedure SpotChecksAndShow(tmp:String;CSpot:TRBNSpot);
    procedure Reconnect;
    procedure lError(const msg: AnsiString; aSocket: TLSocket);
    procedure LoadConfig;

    function OkSource(var ASpot:TRBNSpot) : Boolean;
    function AllowedSpot(var ASpot:TRBNSpot) : Boolean;

  public
  end;

var
  frmRbnMonitor: TfrmRbnMonitor;

implementation
{$R *.lfm}

uses dUtils, uMyIni, dData, fRbnServer, dDXCluster, fRbnFilter, fNewQSO, fGrayline,fBandMap, fTRXControl, fMain;

{ TfrmRbnMonitor }


procedure TfrmRbnMonitor.ClearAllCounters;
Begin
   SpotCount.total:=0;        //total received from telnet during connection
   ClearCounters;
end;
procedure TfrmRbnMonitor.ClearCounters;
Begin
  SpotCount.minute:=0;       //total received from telnet during one minute
  SpotCount.dupe:=0;         //duplicates filtered with pre-dupe-filtering
  SpotCount.pass:=0;         //passed to RBN filter section
  SpotCount.spot:=0;         //added to RBN grid table
  SpotCount.BandMap:=0;      //passed to BandMap
  SpotCount.xplanet:=0;      //passed to xplanet
  tmrSpotRate.Enabled:=True; //timer to freeze counts from one minute period
end;

procedure TfrmRbnMonitor.lConnect(aSocket: TLSocket);
begin
  tbtnConnect.Action   := acDisconnect;
  sbRbn.Panels[0].Text := 'Connected to RBN';
  ClearAllCounters;
  WaitMe:=false;
  NoScroll:=false;
  NoSpotsRcvd:=false;
  lblRate.Hint:='Spot rate in minute:'+LineEnding+
                 ' Please wait. Counting...'+LineEnding+
                 '.'+LineEnding+
                 'Grid MAX rows: '+IntToStr(C_MAX_ROWS);
  lblRate.Caption:= 'Counting...';
  lblRate.Repaint;
end;

procedure TfrmRbnMonitor.lDisconnect(aSocket: TLSocket);
begin
  tbtnConnect.Action := acConnect;
  sbRbn.Panels[0].Text := 'Disconected';
  tmrSpotRate.Enabled:=False;
  lblRate.Hint:='';
  lblRate.Caption:= '';
  lblRate.Repaint;
end;

procedure TfrmRbnMonitor.Reconnect;
Begin
  acDisconnectExecute(nil);
  sleep(3000);
  acConnectExecute(nil);
end;

procedure TfrmRbnMonitor.lError(const msg: AnsiString; aSocket: TLSocket);
begin
  //if dmData.DebugLevel >=1  then
     Writeln('Connect RBN FAILED: '+msg);
end;

procedure TfrmRbnMonitor.lReceive(aSocket: TLSocket);
const
  CR = #13;
  LF = #10;
var
  TheSpot       : TRBNSpot;
  sStart, sStop : Integer;
  tmp,dup       : String;
  buffer        : String;
  UserName      : String;
  s             : String;
  EX            : boolean;
  i             : integer;

procedure GoOn;
Begin
     inc(SpotCount.pass);
     While WaitMe do
      Begin
        sleep(1);
        Application.ProcessMessages;
      end;
     SpotChecksAndShow(tmp,TheSpot);
end;



begin
  if lTelnet.GetMessage(buffer) = 0 then
    exit;
  sStart := 1;
  sStop := Pos(CR, Buffer);
  if sStop = 0 then
    sStop := Length(Buffer) + 1;
  while sStart <= Length(Buffer) do
  begin
    tmp  := Copy(Buffer, sStart, sStop - sStart);
    tmp  := trim(tmp);
    if dmData.DebugLevel >=1 then Writeln(tmp);

    if (Pos('DX DE',UpperCase(tmp))>0)  then
    begin
      ex:=false;
      dup:='(nil)';
      inc(SpotCount.total);
      inc(SpotCount.minute);
      ParseSpots(tmp, TheSpot);
      if OkSource(TheSpot) then   //check spotter source here before dupe
       Begin
          if  DupeFiltUsed then    //check duplicate spot
           begin
             if pos('.', TheSpot.freq)>0 then
                     s:=copy(TheSpot.freq,1,pos('.',TheSpot.freq)-DupeResolution) //cut check frequency resolution
                   else
                     s:=copy(TheSpot.freq,1,length(TheSpot.freq)-(DupeResolution-1)); //just in case the dot is missing, shouldnt.

             dup:=TheSpot.dxstn+s+TheSpot.mode;  //combine all to one string. Assume they are trim():ed already
             ex:=(slDupeCheck.IndexOf(dup)>-1);  //this combined spot exist in dupelist

           if ex then
             begin
             inc(SpotCount.dupe);
             if DebugThis then
                                  Writeln('RBNMonitor: ','Duplicate spot - ',TheSpot.dxstn);
             end
             else
             Begin
               slDupeCheck.Add(dup);
               if   slDupeCheck.Count >= C_MAX_DUPE_LIST then
                                                   slDupeCheck.Delete(0);
               GoOn;
             end;
           end
         else
           Begin
            GoOn;
           end;
       end;
    end
    else //Pos('DX DE'
     begin
      UserName := cqrini.ReadString('RBNMonitor','UserName',cqrini.ReadString('Station', 'Call', ''));
      if (Pos('LOGIN',UpperCase(tmp)) > 0) and (UserName <> '') then
        lTelnet.SendMessage(UserName+#13+#10);
      if (Pos('please enter your call',LowerCase(tmp)) > 0) and (UserName <> '') then
        lTelnet.SendMessage(UserName+#13+#10)
     end;

    sStart := sStop + 1;
    if sStart > Length(Buffer) then
      Break;
    if Buffer[sStart] = LF then
      sStart := sStart + 1;
    sStop := sStart;
    while (Buffer[sStop] <> CR) and (sStop <= Length(Buffer)) do
      sStop := sStop + 1
  end;
  lTelnet.CallAction
end;

procedure TfrmRbnMonitor.acConnectExecute(Sender: TObject);
var
  port   : Integer;
  server : String;
  user   : String;
begin
  if lTelnet.Connected then exit;

  ClearAllCounters;
  slDupeCheck.Clear;

  LoadConfig;

  server := cqrini.ReadString('RBNMonitor','ServerName','telnet.reversebeacon.net:7000');
  user   := cqrini.ReadString('RBNMonitor','UserName',cqrini.ReadString('Station', 'Call', ''));

  if (user='') then
  begin
    Application.MessageBox('User name is not defined!','Warning...',mb_ok+mb_IconWarning);
    acRbnServer.Execute;
    exit
  end;

  lTelnet.Host := Copy(server,1,Pos(':',server)-1);
  if not TryStrToInt(Copy(server,Pos(':',server)+1,6),port) then
    port := 7000;
  lTelnet.Port := port;
  if dmData.DebugLevel>=2 then Writeln(server,'   ',port);
  lTelnet.Connect;
  btnEatFocus.SetFocus;

end;

procedure TfrmRbnMonitor.acClearExecute(Sender: TObject);
var l: integer;
begin
  WaitMe:=true;
  sgRbn.Clear;
  l := sgRbn.RowCount;
       sgRbn.RowCount := l+1;
  sgRbn.Cells[0,l] := 'Source';
  sgRbn.Cells[1,l] := 'Freq';
  sgRbn.Cells[2,l] := 'DX';
  sgRbn.Cells[3,l] := 'Mode';
  sgRbn.Cells[4,l] := 'dB';
  sgRbn.Cells[5,l] := 'Qsl';
  sgRbn.Cells[6,l] := 'DXCC';
  WaitMe:=false;
  NoScroll:=false;
end;

procedure TfrmRbnMonitor.acDisconnectExecute(Sender: TObject);
begin
  if lTelnet.Connected then
  begin
    lTelnet.Disconnect;
    tmrUnfocus.Enabled:=false;
    tmrSpotRate.Enabled:=false;
    tbtnConnect.Action := acConnect;
    sbRbn.Panels[0].Text := 'Disconnected'
  end;
end;

procedure TfrmRbnMonitor.acFilterExecute(Sender: TObject);
begin
  with TfrmRbnFilter.Create(frmRbnMonitor) do
  try
    if ShowModal = mrOK then
      LoadConfig
  finally
    Free;
  end;
  btnEatFocus.SetFocus
end;

procedure TfrmRbnMonitor.acFontSettingsExecute(Sender: TObject);
begin
  dlgFont.Font := sgRbn.Font;
  if dlgFont.Execute then
  begin
    cqrini.WriteString('RBNMonitor','Font',dlgFont.Font.Name);
    cqrini.WriteInteger('RBNMonitor','FontSize',dlgFont.Font.Size);
    sgRbn.Font := dlgFont.Font
  end;
  btnEatFocus.SetFocus
end;

procedure TfrmRbnMonitor.acHelpExecute(Sender : TObject);
begin
  dmUtils.OpenInApp(dmData.HelpDir+'h31.html')
end;

procedure TfrmRbnMonitor.acRbnServerExecute(Sender: TObject);
begin
  with TfrmRbnServer.Create(frmRbnMonitor) do
  try
    edtServerName.Text := cqrini.ReadString('RBNMonitor','ServerName','telnet.reversebeacon.net:7000');
    edtUserName.Text   := cqrini.ReadString('RBNMonitor','UserName',cqrini.ReadString('Station', 'Call', ''));
    if ShowModal = mrOK then
    begin
      cqrini.WriteString('RBNMonitor','ServerName',edtServerName.Text);
      cqrini.WriteString('RBNMonitor','UserName',edtUserName.Text)
    end
  finally
    Free
  end;
  btnEatFocus.SetFocus
end;

procedure TfrmRbnMonitor.acScrollDownExecute(Sender : TObject);
begin
  NoScroll:=false;
  sgRbn.Row := sgRbn.RowCount;
  btnEatFocus.SetFocus
end;

procedure TfrmRbnMonitor.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
var
  i : Integer;
begin
  for i:=0 to sgRbn.ColCount-1 do
    cqrini.WriteInteger('WindowSize','RbnCol'+IntToStr(i),sgRbn.ColWidths[i]);
  acDisconnectExecute(nil);
  SrcCalls.Clear;
  slDupeCheck.Clear;
  dmUtils.SaveWindowPos(self);
end;

procedure TfrmRbnMonitor.FormCreate(Sender: TObject);
begin

  sgRbn.RowCount := 1;
  tmrSpotRate.Enabled:=False;

  slDupeCheck := TStringList.Create;
  SrcCalls    := TStringList.Create;

  lTelnet     := TLTelnetClientComponent.Create(nil);
  lTelnet.OnConnect    := @lConnect;
  lTelnet.OnDisconnect := @lDisconnect;
  lTelnet.OnReceive    := @lReceive;
  lTelnet.OnError      := @lError;

  //set debug rules for this form
  // bit 6, %100000,  ---> -32 for routines in this form
  DebugThis := dmData.DebugLevel >= 1 ;
  if dmData.DebugLevel < 0 then
      DebugThis :=  DebugThis or ((abs(dmData.DebugLevel) and 32) = 32 );

end;


procedure TfrmRbnMonitor.FormDestroy(Sender: TObject);
begin
  FreeAndNil(lTelnet);
  FreeAndNil(SrcCalls);
  FreeandNil(slDupeCheck);
end;

procedure TfrmRbnMonitor.FormKeyUp(Sender : TObject; var Key : Word;
  Shift : TShiftState);
begin
  if (key= VK_ESCAPE) then
  begin
    frmNewQSO.ReturnToNewQSO;
    key := 0
  end
end;

procedure TfrmRbnMonitor.FormShow(Sender: TObject);
var
  i : Integer;
begin
  for i:=0 to sgRbn.ColCount-1 do
    sgRbn.ColWidths[i] := cqrini.ReadInteger('WindowSize','RbnCol'+IntToStr(i),70);

  dmUtils.LoadWindowPos(self);

  sgRbn.Options   := sgRbn.Options + [goColSizing] - [goRowSelect, goRangeSelect];
  sgRbn.Font.Name := cqrini.ReadString('RBNMonitor','Font','DejaVu Sans Mono');
  sgRbn.Font.Size := cqrini.ReadInteger('RBNMonitor','FontSize',10);

  sgRbn.Cells[0,0] := 'Source';
  sgRbn.Cells[1,0] := 'Freq';
  sgRbn.Cells[2,0] := 'DX';
  sgRbn.Cells[3,0] := 'Mode';
  sgRbn.Cells[4,0] := 'dB';
  sgRbn.Cells[5,0] := 'Qsl';
  sgRbn.Cells[6,0] := 'DXCC';


  if ( cqrini.ReadBool('RBN','AutoConnectM',False)) then
     acConnectExecute(nil);
end;

procedure TfrmRbnMonitor.sgRbnDblClick(Sender: TObject);
var i:real;
    f:TFormatSettings;
begin
  //if (sgRbn.Cells[1,sgRbn.Row]<>'Freq') then  //easy way, but works only with header
  f.DecimalSeparator := '.';
  if TryStrToFloat( sgRbn.Cells[1,sgRbn.Row],i,f) then
    frmNewQSO.NewQSOFromSpot(sgRbn.Cells[2,sgRbn.Row],sgRbn.Cells[1,sgRbn.Row],sgRbn.Cells[3,sgRbn.Row],True);
  frmRbnMonitor.Caption:= 'RBN Monitor';
  NoScroll:=false;
end;

procedure TfrmRbnMonitor.sgRbnDrawCell(Sender: TObject; aCol, aRow: Integer;
  aRect: TRect; aState: TGridDrawState);
begin
  {
  if (aRow>0) then
   begin
     if (Arow mod 2 > 0) then
       sgRbn.Canvas.Brush.Color:= clwhite
     else
       sgRbn.Canvas.Brush.Color:= $00E7FFEB;
     sgRbn.Canvas.FillRect(aRect);
     sgRbn.Canvas.TextOut(aRect.Left, aRect.top + 4, sgRbn.Cells[ACol, ARow])
   end }
end;

procedure TfrmRbnMonitor.sgRbnHeaderSized(Sender: TObject; IsColumn: Boolean;
  Index: Integer);
begin
  btnEatFocus.SetFocus
end;

procedure TfrmRbnMonitor.sgRbnMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  frmRbnMonitor.Caption:= 'RBN Monitor  PAUSED!';
  tmrUnfocus.Enabled:=true;
  NoScroll:=True;
end;

procedure TfrmRbnMonitor.tmrSpotRateTimer(Sender: TObject);
begin
  tmrSpotRate.Enabled:=False;
  SpotCount.total:=SpotCount.total+SpotCount.spot;

  lblRate.Caption:=IntToStr(SpotCount.minute)+'/'+IntToStr(SpotCount.spot)+'/min';
  lblRate.Hint:='Spot rate during last minute:'+LineEnding+
                 ' Spots received: '+IntToStr(SpotCount.minute)+LineEnding+
                 ' Duplicates: '+IntToStr(SpotCount.dupe)+LineEnding+
                 ' Passed to RBN filter: '+IntToStr(SpotCount.pass)+LineEnding+
                 ' Passed by RBN filter settings: '+IntToStr(SpotCount.spot)+LineEnding+
                 ' From RBNmonitor to xplanet: '+IntToStr(SpotCount.xplanet)+LineEnding+
                 ' From RBNmonitor to BandMap: '+IntToStr(SpotCount.BandMap)+LineEnding+
                 '--------------------------------------'+LineEnding+
                 'Total spots since connected: '+IntToStr(SpotCount.total)+LineEnding+
                 '.'+LineEnding+
                 'Grid MAX rows: '+IntToStr(C_MAX_ROWS);

  if (SpotCount.minute=0) and NoSpotsRcvd then  //takes two minutes(rounds) to initiate reconnect when zero spots received.
                                          Reconnect;
  NoSpotsRcvd:=(SpotCount.minute=0);

  ClearCounters;
end;

procedure TfrmRbnMonitor.FormDeactivate(Sender: TObject);
begin
  frmRbnMonitor.Caption:= 'RBN Monitor';
  tmrUnfocus.Enabled:=false;
  NoScroll:=false;
end;

procedure TfrmRbnMonitor.tmrUnfocusTimer(Sender: TObject);
begin
  tmrUnfocus.Enabled:=false;
  Self.FormDeactivate(nil);
end;
//-------------------------------------------------
procedure TfrmRbnMonitor.LoadConfig;

begin
    WaitMe:=true;

    fil_SrcCont := cqrini.ReadString('RBNFilter','SrcCont',C_RBN_CONT);

    SrcCalls.Clear;    //we need to do this via another TString list. Direct mods to fil_SrcCalls cause SIGSEGV
    SrcCalls.Delimiter:=',';
    SrcCalls.AddDelimitedtext(cqrini.ReadString('RBNFilter','SrcCall',''));
    fil_SrcCalls := SrcCalls;

    fil_IgnWkdHour    := (cqrini.ReadInteger('RBNFilter','Ignore',0) = 1);
    fil_IgnDate       := (cqrini.ReadInteger('RBNFilter','Ignore',0) = 2);

    fil_IgnHourValue  := cqrini.ReadInteger('RBNFilter','IgnHourValue',48);
    fil_IgnDateValue  := cqrini.ReadString('RBNFilter','IgnDateValue','');
    fil_IgnTimeValue  := cqrini.ReadString('RBNFilter','IgnTimeValue','');

    fil_AllowAllCall          := cqrini.ReadBool('RBNFilter','AllowAllCall',True);
    fil_AllowOnlyCall         := cqrini.ReadBool('RBNFilter','AllowOnlyCall',False);
    fil_AllowOnlyCallValue    := cqrini.ReadString('RBNFilter','AllowOnlyCallValue','');
    fil_AllowOnlyCallReg      := cqrini.ReadBool('RBNFilter','AllowOnlyCallReg',False);
    fil_AllowOnlyCallRegValue := cqrini.ReadString('RBNFilter','AllowOnlyCallRegValue','');

    fil_AllowCont  := cqrini.ReadString('RBNFilter','AllowCont',C_RBN_CONT);
    fil_AllowBands := cqrini.ReadString('RBNFilter','AllowBands',C_RBN_BANDS);
    fil_AllowModes := cqrini.ReadString('RBNFilter','AllowModes',C_RBN_MODES);
    fil_AllowCnty  := cqrini.ReadString('RBNFilter','AllowCnty','');
    fil_NotCnty    := cqrini.ReadString('RBNFilter','NotCnty','');

    fil_LoTWOnly := cqrini.ReadBool('RBNFilter','LoTWOnly',False);
    fil_eQSLOnly := cqrini.ReadBool('RBNFilter','eQSLOnly',False);

    fil_NewDXCOnly := cqrini.ReadBool('RBNFilter','NewDXCOnly',False);
    //note: we can do WriteString and then ReadInteger if parameter has only numbers. No conversion needed.

    fil_ToBandMap           := cqrini.ReadBool('RBNMonitor','ToBandMap',false);
    fil_gcfgNewCountryColor := cqrini.ReadInteger('DXCluster','NewCountry',0);
    fil_gcfgNewBandColor    := cqrini.ReadInteger('DXCluster','NewBand',0);
    fil_gcfgNewModeColor    := cqrini.ReadInteger('DXCluster','NewMode',0);
    fil_gcfgUseBackColor    := cqrini.ReadBool('LoTW','UseBackColor',True);
    fil_gcfgeUseBackColor   := cqrini.ReadBool('LoTW','eUseBackColor',True);
    fil_gcfgBckColor        := cqrini.ReadInteger('LoTW','BckColor',clMoneyGreen);
    fil_gcfgeBckColor       := cqrini.ReadInteger('LoTW','eBckColor',clSkyBlue);
    fil_gcfgUseDXCColors    := cqrini.ReadBool('BandMap','UseDXCColors',False);

    DupeResolution:=cqrini.ReadInteger('RBNMonitor','DupeRes',1);
    DupeFiltUsed := cqrini.ReadBool('RBNMonitor','DupeFiltUsed', false);

    WaitMe:=false;
    NoScroll:=false;
  end;

procedure TfrmRbnMonitor.ParseSpots(spot : String; var InSpot : TRBNSpot);
//DX de DL9GTB-#:  14027.1  HB9CCL         CW    10 dB  20 WPM  CQ      0713Z
 var
   i : shortInt;
   y : Integer;
   b : Array of String[50];
   p : Integer=0;
 begin

   SetLength(b,1);
   for i:=1 to Length(spot) do
   begin
     if spot[i]<>' ' then
       b[p] := b[p]+spot[i]
     else begin
       if (b[p]<>'') then
       begin
         inc(p);
         SetLength(b,p+1)
       end
     end
   end;

  With InSpot do
  begin
   spotter := b[2];
   i := pos('-', spotter);
   if i > 0 then
     spotter := copy(spotter, 1, i-1);
   dxstn := b[4];
   freq  := b[3];
   mode  := b[5];
   stren := b[6]
 end;
end;
function TfrmRbnMonitor.OkSource(var ASpot:TRBNSpot) : Boolean;
var
  i:integer;
  SrcCont  : String;
  Country  : String;
  waz,itu  : String;
  pfx      : String;

begin
 with ASpot do
  begin
   if (fil_SrcCalls.Count>0) then //chk source here before dupe check.
    Begin
     Result:=false;
     for i:=0 to fil_SrcCalls.Count-1 do
      Begin
        if (pos(fil_SrcCalls.Strings[i], spotter)=1) then  //begins with definition
                                   begin
                                     Result := True;
                                     Break;
                                   end;
      end;
     if Not Result then
        Begin
          if DebugThis then
                                  Writeln('RBNMonitor: ','Wrong source callsign - ',Spotter);
          Exit
        end
       else
         if DebugThis then
                                  Writeln('RBNMonitor: ','Source callsign passed - ',Spotter);
    end
   else   //if not source call defined then check continent
    begin
     Result:=true;
     if fil_SrcCont<>C_RBN_CONT then
       begin
        dmDXCluster.id_country(spotter,now,pfx,Country,waz,itu,SrcCont);
        if (Pos(SrcCont+',',fil_SrcCont+',') = 0) and (fil_SrcCont<>'') then
        begin
          if DebugThis then Writeln('RBNMonitor: ','Wrong source continent - ',SrcCont);
          Result:=false;
          exit
        end
        else
         if DebugThis then
                                  Writeln('RBNMonitor: ','Source continent passed - ',Spotter);
       end;
    end;
  end;
end;
function TfrmRbnMonitor.AllowedSpot(var ASpot:TRBNSpot) : Boolean;
var
  SrcCont  : String;
  DestCont : String;
  Country  : String;
  waz,itu  : String;
  pfx      : String;
  LastDate : String;
  LastTime : String;
  Band     : String;
  tmp      : String;
  adif     : Word;
  index    : Integer;
  f        : Double;
  i        : integer;
  SpotterOk: Boolean;

begin
  Result := False;

 With ASpot do
 Begin

  if fil_IgnWkdHour then
  begin
    dmUtils.DateHoursAgo(fil_IgnHourValue,LastDate,LastTime);
  end
  else begin
   if  fil_IgnDate then
    begin
    LastDate := fil_IgnDateValue;
    LastTime := fil_IgnTimeValue;
    end  else
     Begin  //IgnNone
       LastDate := Copy(frmMain.sbMain.Panels[4].Text,1,10);
       LastTime := Copy(frmMain.sbMain.Panels[4].Text,13,5);
     end;
  end;

  Band := dmDXCluster.GetBandFromFreq(freq,True);
  if (Band='') then
  begin
    if DebugThis then Writeln('RBNMonitor: ','Wrong band - ',Band);
    exit
  end;
  if dmData.IsCallInLogR(dxstn,Band,mode,LastDate,LastTime) then
  begin
    if DebugThis then Writeln('RBNMonitor: ','Station already exist in the log - ',dxstn);
    exit
  end;
  if fil_AllowOnlyCall then
  begin
    if Pos(dxstn+',',fil_AllowOnlyCallValue+',') = 0 then
    begin
      if DebugThis then Writeln('RBNMonitor: ','Station is not between allowed callsigns - ',dxstn);
      exit
    end
  end;
  if fil_AllowOnlyCallReg then
   begin
   if (trim(fil_AllowOnlyCallRegValue)='') or (trim(dxstn)='') then
    begin    // do not allow empty regexp
      if DebugThis then Writeln('RBNMonitor: ','Station or allowed callsigns - empty ');
      exit
    end;
    reg.Expression  := fil_AllowOnlyCallRegValue;
    reg.InputString := dxstn;
    if not reg.Exec(1) then
    begin
      if DebugThis then Writeln('RBNMonitor: ','Station is not between allowed callsigns - ',dxstn);
      exit
    end
  end;
  tmp:=fil_AllowBands;
  If (pos('RIG',UpperCase(tmp))>0) then
           tmp:=StringReplace(tmp,'RIG', dmDXCluster.GetBandFromFreq(FloatToStr(frmTRXControl.GetFreqkHz),True),[rfReplaceAll,rfIgnoreCase]);
  if (Pos(','+band+',',','+tmp+',')=0) and (tmp<>'') then
  begin
    if DebugThis then Writeln('RBNMonitor: ','This band is NOT allowed - ',band);
    exit
  end;
  tmp:= fil_AllowModes;
  If (pos('RIG',UpperCase(tmp))>0) then
           tmp:=StringReplace(tmp,'RIG',frmTRXControl.GetActualMode,[rfReplaceAll,rfIgnoreCase]);
  if DebugThis then Writeln(mode,'->',tmp);
  if (Pos(','+mode+',',','+tmp+',')=0) and (tmp<>'') then
  begin
    if DebugThis then Writeln('RBNMonitor: ','This mode is NOT allowed - ',mode);
    exit
  end;
  adif := dmDXCluster.id_country(dxstn,now,Pfx,Country,waz,itu,DestCont);

  if (Pos(DestCont+',',fil_AllowCont+',') = 0) and (fil_AllowCont<>'') then
  begin
    if DebugThis then Writeln('RBNMonitor: ','Wrong continent - ',DestCont);
    exit
  end;
  if ((fil_NotCnty<>'') and (Pos(pfx+',',fil_NotCnty+',')>0)) then
  begin
    if DebugThis then Writeln('RBNMonitor: ','This country is not allowed - ',pfx);
    exit
  end;

  if ((fil_AllowCnty<>'') and (Pos(pfx+',',fil_AllowCnty+',')=0)) then
  begin
    if DebugThis then Writeln('RBNMonitor: ','This country is not allowed - ',pfx);
    exit
  end;
  if fil_LoTWOnly and (LoTW<>'L') then
  begin
    if DebugThis then Writeln('RBNMonitor: ','This station is not LoTW user - ',dxstn);
    exit
  end;
  if fil_eQSLOnly and (eQSL<>'E') then
  begin
    if DebugThis then Writeln('RBNMonitor: ','This station is not eQSL user - ',dxstn);
    exit
  end;
  dmData.RbnMonDXCCInfo(adif,band,mode,DxccWithLoTW,index);
  case index of
    1 : dxinfo := 'N';
    2 : dxinfo := 'B';
    3 : dxinfo := 'M';
    else
     Begin
      dxinfo := '';
      if fil_NewDXCOnly then
                        Begin
                          if DebugThis then Writeln('RBNMonitor: ','Not new one, band or mode - ',dxstn);
                          exit;
                        end;
     end;
  end; //case
  Result := True
 end;
end;
procedure  TfrmRbnMonitor.SpotChecksAndShow(tmp:String;CSpot:TRBNSpot);
var
 i,
 bkCOlor,
 sColor  : Integer;
 band    : String;
 Mfreq   : String;
 dfreq   : extended;
 cLat,
 clon     : Currency;

begin
  if tmp='' then exit;

  with CSpot do
  Begin
     WaitMe:=true;
      if dmData.UsesLotw(dxstn) then
         LoTW := 'L'
       else
         loTW:='';
      if dmDXCluster.UseseQSL(dxstn) then
         eQSL := 'E'
       else
         eQSL:='';
     if DebugThis then
                  Writeln('RBNMonitor: LotW+eQSL - ',dxstn,' - ',LoTW,eQSL);
     if AllowedSpot(CSpot) then
     begin
       i := sgRbn.RowCount;
       sgRbn.RowCount := i+1;

       sgRbn.Cells[0,i] := spotter;
       sgRbn.Cells[1,i] := freq;
       sgRbn.Cells[2,i] := dxstn;
       sgRbn.Cells[3,i] := mode;
       sgRbn.Cells[4,i] := stren;
       sgRbn.Cells[5,i] := LoTW+eQSL;
       sgRbn.Cells[6,i] := dxinfo;
       inc(SpotCount.spot);

       if i>=C_MAX_ROWS then
                        sgRbn.DeleteRow(0);

       if  (frmGrayline.Showing and frmGrayline.acLinkToRbnMonitor.Checked) then
           Begin
             frmGrayline.AddSpotToList(tmp);
             inc(SpotCount.xplanet);
           end;

       if fil_ToBandMap and frmBandMap.Showing and (dxinfo<>'') then
        begin
         dFreq:=0.0; MFreq:='0.0';
         if TryStrToFloat(freq,dFreq) then
            Mfreq:=FloatToStr( dFreq/1000);
         bkColor := clWindow;
         sColor     := clDefault;
         if fil_gcfgUseDXCColors then
          Begin
            case dxinfo of
             'N': sColor:=fil_gcfgNewCountryColor;
             'B': sColor:=fil_gcfgNewBandColor;
             'M': sColor:=fil_gcfgNewModeColor;
            end;


           if fil_gcfgeUseBackColor and (eQSL='E') then
             bkColor := fil_gcfgeBckColor;
           if fil_gcfgUseBackColor and (LoTW='L') then
             bkColor := fil_gcfgBckColor;
           end;
           cLat:=0;
           cLon:=0;
           dmUtils.GetCoordinate(dmUtils.GetPfx(dxstn),cLat,cLon);
           frmBandMap.AddToBandMap(dFreq,dxstn,mode,dmUtils.GetBandFromFreq(Mfreq),'',cLat,cLon,
                                   sColor,bkColor, False, (LoTW='L'),(eQSL='E') );
           inc(SpotCount.BandMap);
        end;
     end;
    WaitMe:=False;

    if NoScroll then
                exit
         else
           Begin
              sgRbn.Row := sgRbn.RowCount;
           end;
  end;
end;

end.

