unit fMonWsjtx;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, maskedit, ColorBox, Menus, ExtCtrls, Grids, StrUtils,
  process, Types, iniFiles, LCLType, ComCtrls, dateutils, BaseUnix;

type

  { TfrmMonWsjtx }

  TfrmMonWsjtx = class(TForm)
    chkDs: TCheckBox;
    chkFFlt: TCheckBox;
    chkCbCQ: TCheckBox;
    chkdB: TCheckBox;
    chkFlt: TCheckBox;
    chkSort: TCheckBox;
    cmMapCq: TMenuItem;
    edtFltMap: TEdit;
    mnuSort1: TMenuItem;
    mnuSort2: TMenuItem;
    mnuSort3: TMenuItem;
    mnuSort4: TMenuItem;
    mnuSort5: TMenuItem;
    mnuSort6: TMenuItem;
    mnuSort7: TMenuItem;
    pnlMap: TPanel;
    popSort: TPopupMenu;
    ShAll: TMenuItem;
    btFtxtName: TButton;
    cbflw: TCheckBox;
    chkDx: TCheckBox;
    chkMap: TCheckBox;
    chknoHistory: TCheckBox;
    chknoTxt: TCheckBox;
    chkStopTx: TCheckBox;
    chkUState: TCheckBox;
    EditAlert: TEdit;
    edtFollow: TEdit;
    edtFollowCall: TEdit;
    lblBand: TLabel;
    lblInfo: TLabel;
    lblMode: TLabel;
    ShAS: TMenuItem;
    ShEU: TMenuItem;
    ShNA: TMenuItem;
    ShOC: TMenuItem;
    ShSA: TMenuItem;
    ShAF: TMenuItem;
    pnlTrigPop: TPanel;
    pnlSelects: TPanel;
    pnlChecks: TPanel;
    pnlFollow: TPanel;
    pnlAlert: TPanel;
    popDx: TPopupMenu;
    sgMonitor: TStringGrid;
    tbAlert: TToggleBox;
    cmCqDx: TMenuItem;
    cmFont: TMenuItem;
    popFontDlg: TFontDialog;
    popColorDlg: TColorDialog;
    cmHead: TMenuItem;
    cmNever: TMenuItem;
    cmBand: TMenuItem;
    cmAny: TMenuItem;
    cmHere: TMenuItem;
    popColors: TPopupMenu;
    tbLocAlert: TToggleBox;
    tbmyAll: TToggleBox;
    tbmyAlrt: TToggleBox;
    tbFollow: TToggleBox;
    tbTCAlert: TToggleBox;
    tmrStartupDone: TTimer;
    tmrFollow: TTimer;
    tmrCqPeriod: TTimer;
    procedure btFtxtNameClick(Sender: TObject);
    procedure chkDsClick(Sender: TObject);
    procedure chkFFltChange(Sender: TObject);
    procedure chkFFltClick(Sender: TObject);
    procedure chkFFltMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure chkFltChange(Sender: TObject);
    procedure chkFltClick(Sender: TObject);
    procedure chkMapClick(Sender: TObject);
    procedure chkSortClick(Sender: TObject);
    procedure chkSortMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure chkCbCQChange(Sender: TObject);
    procedure cbflwChange(Sender: TObject);
    procedure chkdBChange(Sender: TObject);
    procedure chkDxClick(Sender: TObject);
    procedure chkDxMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure chknoHistoryChange(Sender: TObject);
    procedure chkStopTxChange(Sender: TObject);
    procedure chkUStateClick(Sender: TObject);
    procedure StateCallCount(var c:integer);
    procedure chkUStateMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure cmAnyClick(Sender: TObject);
    procedure cmBandClick(Sender: TObject);
    procedure cmCqDxClick(Sender: TObject);
    procedure cmFontClick(Sender: TObject);
    procedure cmHereClick(Sender: TObject);
    procedure cmMapCqClick(Sender: TObject);
    procedure cmNeverClick(Sender: TObject);
    procedure EditAlertEnter(Sender: TObject);
    procedure EditAlertExit(Sender: TObject);
    procedure edtFollowCallEnter(Sender: TObject);
    procedure edtFollowCallExit(Sender: TObject);
    procedure edtFollowCallKeyDown(Sender: TObject; var Key: word;
      Shift: TShiftState);
    procedure edtFollowDblClick(Sender: TObject);
    procedure edtFltMapEnter(Sender: TObject);
    procedure edtFltMapExit(Sender: TObject);
    procedure edtFltMapKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtFltMapMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDropFiles(Sender: TObject; const FileNames: array of String);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure chknoTxtChange(Sender: TObject);
    procedure mnuSort1Click(Sender: TObject);
    procedure pnlSelectsClick(Sender: TObject);
    procedure pnlTrigPopMouseEnter(Sender: TObject);
    procedure popColorsPopup(Sender: TObject);
    procedure popDxClose(Sender: TObject);
    procedure sgMonitorDblClick(Sender: TObject);
    procedure sgMonitorDrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure ShAFClick(Sender: TObject);
    procedure ShAllClick(Sender: TObject);
    procedure tbAlertChange(Sender: TObject);
    procedure tbFollowChange(Sender: TObject);
    procedure tbLocAlertChange(Sender: TObject);
    procedure tbmyAllChange(Sender: TObject);
    procedure tbmyAlrtChange(Sender: TObject);
    procedure tbTCAlertChange(Sender: TObject);
    procedure tmrCqPeriodTimer(Sender: TObject);
    procedure tmrStartupDoneTimer(Sender: TObject);
    procedure tmrFollowTimer(Sender: TObject);
  private
    CqState   : string;  //use in map mode to join state and Cqdir
    FileFilter  : TStringList;
    procedure AddColorStr(s: string; const col: TColor = clBlack; c:integer =0;r:integer =-1);
    procedure RunVA(Afile: string);
    procedure scrollSgMonitor;
    procedure decodetest(i: boolean);
    procedure PrintCall(Pcall: string;PCB:Boolean=false);  // prints colored call
    procedure PrintLoc(PLoc, tTa, mT: string;PCB:Boolean=false);  // prints colored loc
    function isItACall(Call: string): boolean;
    procedure SendQsoInit(reply: string);
    procedure TryCallAlert(S: string);
    procedure TryAlerts;
    procedure SaveFormPos(FormMode: string);
    procedure LoadFormPos(FormMode: string);
    procedure CqPeriodTimerStart(msgnow,msglast:string);
    procedure AddXplanetList(call,loc:string);
    procedure Setbitmap(bm:TBitmap;col:Tcolor);
    procedure SetAllbitmaps;
    procedure setDefaultColorSgMonitorAttributes;
    procedure SetsgMonitorColumnHW;
    procedure scrollSgMonitorToLastLine;
    function  LineFilter(L: string):string;
    procedure PrintDecodedMessage;
    function getCurMode(sMode: String): String;
    procedure extcqprint;
    Procedure ReColorsgMonitor(Fc,Bc:tColor;Boff:Boolean);
    Procedure DxccStatus(adif:word;CB,Cm:String;var R:String);
    function UsCallState(call:string;var StatClr:TColor):string;
    { private declarations }
  public
    CanCloseUSDBProcess :boolean;
    DblClickCall  :string;      //callsign that is called by doubleclick
    procedure clearSgMonitor;
    procedure AddCqCallMessage(Time,mode,WsjtxBand,Message,Reply:string; Df,Sr:integer);
    procedure AddMyCallMessage(Time,mode,WsjtxBand,Message,Reply:string; Df,Sr:integer);
    procedure AddFollowedMessage(Message, Reply: string;Df,Sr:integer);
    procedure AddOtherMessage(Time,Message, Reply: string;Df,Sr:integer);
    procedure NewBandMode(Band, Mode: string);
    procedure SendFreeText(MyText: string);
    procedure SendConfigure(Mode,Submode,DXCall,DXGrid:string;FreqTol,TRPeriod,RxDF:Dword;Fmode,GMsg:boolean);
    procedure ColorBack(Myitem:string;Mycolor:Tcolor;bkg:Boolean=false);
    procedure BufDebug(MyHeader,MyBuf:string);
    function HexStrToStr(const HexStr: string): string;
    function StrToHexStr(const S: string): string;
    { public declarations }
  end;

const
  MaxLinesSgMonitor = 50;  //max line nr in sgmonitor grid (lines count is 0..MaxLinesSgMonitor => MaxLinesSgMonitor+1
  CountryLen = 15;         //length of printed country name in monitor
  CallFieldLen = 10;       //max len of callsign
  Sdelim = ',';            //separator of several text alerts

  //color bitmap size
  bmW = 10;
  bmH = 10;

  C_STATE_SOURCE = 'ctyfiles/usdbraw';

type //DL7OAP: define type for grid coloring
 TsgMonitorAttributes = Record // saves the attributes textcolor, backgroundcolor for stringgrid
     FG_Color : TColor; // Foregroundcolor
     BG_Color : TColor; // Backgroundcolor
     isBold : Boolean;
end;

var
  frmMonWsjtx: TfrmMonWsjtx;
  LastWsjtLineTime: string;                  //time of last printed line
  myAlert: string;
  //alert name moved to script as 1st parameter
  //can be:'my'= ansver to my cq,
  //       'loc'=new main grid,
  //       'text'= text given is found from new monitor line
  timeToAlert: string;                  //only once per event per minute
  MonitorLine: string;                  // complete line as printed to monitor
  AlertLine:   string;                  //copy of monitor line but has spaces between items
  extCqCall: Tcolor;    // extended cq (cq dx, cq na etc.) color
  UsedBkgCqCol : Tcolor;
  BkgCqCol : Tcolor;    // Map monitor background
  wkdhere: Tcolor;
  wkdband: Tcolor;
  wkdany: Tcolor;
  wkdnever: Tcolor;
  EditedText: string;
  //holds editAlert after finished (loose focus)
  Ssearch, Sfull: string;
  Spos: integer;
  RepFlw: string [255];
  RepBuf: string;  //for sending UDP to wsjt-x
  //reply in case of follow line double click

  msgCall: string;
  msgLocator: string;
  msgTime: string;
  msgMode : string;  //mode in wsjt-x 1chr form
  msgRes :string;
  CqDir : string;
  mycont, cont, country, waz, posun, itu, pfx, lat, long: string;
  dxcc_number_adif : word;
  Dfreq,Snr:integer;
  isMyCall: boolean;
  CurMode: string = '';   //mode in human readable format
  CurBand: string = '';
  LockMap: boolean;
  LockFlw: boolean;
  PCallColor :Tcolor;  //color that was last used for callsign printing, will be used in xplanet
  sgMonitorAttributes : array [0..7,0..MaxLinesSgMonitor] of TsgMonitorAttributes;
  LocalDbg : boolean;

  USDB_Address :String;
  DXpopOK      : boolean;

implementation

{$R *.lfm}

{ TfrmMonWsjtx }

uses fNewQSO, dData, dUtils, dDXCC, fWorkedGrids, uMyIni, dDXCluster,fProgress;

procedure TfrmMonWsjtx.RunVA(Afile: string);
const
  cAlert = 'voice_keyer/voice_alert.sh';

var
   AProcess: TProcess;
begin
  if not FileExists(dmData.HomeDir + cAlert) then
    exit;

  AProcess := TProcess.Create(nil);
  try
    AProcess.Executable:=dmData.HomeDir + cAlert;
    AProcess.Parameters.Clear;
    AProcess.Parameters.Add(AFile);
    AProcess.Parameters.Add(AlertLine);
    if LocalDbg then
       Writeln('AProcess.Executable: ',AProcess.Executable,' Parameters: ',AProcess.Parameters.Text);
    AProcess.Execute;
    While AProcess.Running do
          Application.ProcessMessages;
  finally
    Aprocess.Terminate(0);
    Aprocess.Free;
  end;
end;

procedure TfrmMonWsjtx.AddXplanetList(call,loc:string);
var lat,lon :currency;
   slat,slon:String;
   i       : integer;
Begin
    if cqrini.ReadInteger('xplanet','ShowFrom',0) <> 2 then exit;  //dxclust =0, bandmap=1

    dmUtils.CoordinateFromLocator(dmUtils.CompleteLoc(loc),lat,lon);
    slat:= FloatToStrF(lat,ffFixed,4,2);
    slon:= FloatToStrF(lon,ffFixed,4,2);
    if LocalDbg then
       Writeln('For xplanet: ',slat,' ',slon,' "',call);
    dmDXCluster.AddToMarkFile('',call,PCallColor,IntToStr(cqrini.ReadInteger('xplanet','LastSpots',20)),slat,slon);
end;

procedure TfrmMonWsjtx.AddColorStr(s: string; const col: TColor = clBlack; c:integer =0;r:integer =-1);
var
  i: integer;
begin
  sgMonitor.Height:=250;

  for i := 1 to length(s) do
  begin
    if ((Ord(s[i]) >= 32) and (Ord(s[i]) <= 122)) then   //from space to z accepted
      MonitorLine := MonitorLine + s[i];
      AlertLine := AlertLine + s[i];
  end;
  AlertLine := AlertLine + ' ';
  if ((not chknoTxt.Checked) and (r > -1)) then
        Begin
             sgMonitor.Cells[c,r]:= s;  //trim ??
             sgMonitorAttributes[c,r].FG_Color:=col;
             sgMonitorAttributes[c,r].BG_Color:=clWhite;
             if (chkMap.Checked) and (not ChkCbCq.Checked) and (c in  [3,4,5]) then   //CQ background printing fails if Cqs are colored back to wsjtx. There are none :)
               begin
                sgMonitorAttributes[c,r].BG_Color:=UsedBkgCqCol; //global var
                if (c=5) then UsedBkgCqCol:=clWhite;  //reset for next
               end;
             sgMonitorAttributes[c,r].isBold:=false;
             if ((col = wkdnever) and ((c > 2) and (c < 6))) then
               sgMonitorAttributes[c,r].isBold:=true
        end;
end;
function TfrmMonWsjtx.LineFilter(L: string):string;
Begin
   if LocalDbg then Writeln('F incoming Message is:', L);
  //remove < > from Message here (wsjtx v2.0)
  L := StringReplace(L,'<','',[rfReplaceAll]);
  L := StringReplace(L,'>','',[rfReplaceAll]);
  //cut message if there is a decode note like 'a2'
  //175200 ~ OH1KH DL2BQV JO73                     a2'
  if pos('    ',L) > 11 then L := copy(L,1,pos('    ',L));
  if LocalDbg then Writeln('F Message after filter is:', L);
  LineFilter := L;
end;

procedure TfrmMonWsjtx.clearSgMonitor;
//removes all rows in stringgrid
//initialize the array
var
  l: integer;
begin
  for l:= sgMonitor.rowcount - 1 downto 0 do
    sgMonitor.DeleteRow(l);
  SetsgMonitorColumnHW;
  setDefaultColorSgMonitorAttributes;
  if LocalDbg then
        Writeln('sgMonitor clear finished');
end;

procedure TfrmMonWsjtx.scrollSgMonitorToLastLine;
//scrolls down, so last line is in view in sgMonitor
begin
  sgMonitor.TopRow:= sgMonitor.RowCount-sgMonitor.VisibleRowCount;
end;

procedure TfrmMonWsjtx.setDefaultColorSgMonitorAttributes;
//DL7OAP: initialize sgMonitorAttributes to default colors
var
  i, j: integer;
begin
  for i:= 0 to 7 do
  begin
       for j:=0 to MaxLinesSgMonitor do
       begin
          sgMonitorAttributes[i,j].FG_Color:=clBlack;
          sgMonitorAttributes[i,j].BG_Color:=clWhite;
          sgMonitorAttributes[i,j].isBold:=false;
       end;
  end;
end;

procedure TfrmMonWsjtx.scrollSgMonitor;
//when MaxLinesSgMonitor is reached scrolling have to be done
var
  i,j: integer;
begin
  // -2 to have 1 row for the next addmessage left
  if (sgMonitor.RowCount >= MaxLinesSgMonitor - 2) then
  begin
    // scroll grid: by delete oldest entry in the grid
    sgMonitor.DeleteRow(0);
    // scroll array: by shift sgMonitorAttributes array -1
    for i:= 0 to 7 do
    begin
         for j:=0 to MaxLinesSgMonitor - 2 do
         begin
            sgMonitorAttributes[i,j].FG_Color:=sgMonitorAttributes[i,j+1].FG_Color;
            sgMonitorAttributes[i,j].BG_Color:=sgMonitorAttributes[i,j+1].BG_Color;
            sgMonitorAttributes[i,j].isBold:=sgMonitorAttributes[i,j+1].isBold;
         end;
      end;
  end;
end;

procedure TfrmMonWsjtx.SetsgMonitorColumnHW;
Var
  FSz : integer;
  i   : integer;
Begin
  with (frmMonWsjtx.sgMonitor) do
   begin
      FSz := Font.Size;
      DefaultRowHeight:= FSz + FSz div 2;
      for i:=0 to 6 do
         ColWidths[i] := Columns.Items[i].maxSize * FSz;
   end;
end;

procedure TfrmMonWsjtx.SendQsoInit(reply: string);
var
  i: byte;
begin
  if (length(reply) > 11) and (reply[12] = #$02) then //we should have proper reply
  begin
    reply[12] := #$04;    //quick hack: change message type from 2 to 4
    if LocalDbg then
      Writeln('Changed message type from 2 to 4. Sending...');
    frmNewQSO.Wsjtxsock.SendString(reply);
    //if LocalDbg then BufDebug('Send data buffer contains:',reply);
  end;
end;

procedure TfrmMonWsjtx.sgMonitorDblClick(Sender: TObject);
var
  i: byte;
begin

  DblClickCall := sgMonitor.Cells[3,sgMonitor.row];

  if LocalDbg then
  begin
    Writeln('Clicked line no:', sgMonitor.row, ' 2click Call is:',DblClickCall);
    BufDebug('Array gives '+INtToStr(length(sgMonitor.Cells[8,sgMonitor.row]))+' :',
             HexStrToStr(sgMonitor.Cells[8,sgMonitor.row]));
  end;
  SendQsoInit(HexStrToStr(sgMonitor.Cells[8,sgMonitor.row]));
  frmNewQSO.GetCallInfo(DblClickCall,CurMode,sgMonitor.Cells[1,sgMonitor.row]);
  frmNewQSO.SendToBack;
end;

procedure TfrmMonWsjtx.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  FileFilter.Free;
  LockMap := True;
  if chkMap.Checked then
    SaveFormPos('Map')
  else
    SaveFormPos('Cq');  //to be same as intial save
  dmUtils.SaveWindowPos(frmMonWsjtx);
end;
 
procedure TfrmMonWsjtx.Setbitmap(bm: TBitmap; col: Tcolor);
begin
 with bm do
  Begin
    Width  := bmW + 2;
    Height := bmH + 2;
    with Canvas do
     Begin
        Brush.Style := bsSolid;
        if col = clBlack then Pen.Color := clFuchsia else Pen.Color := clBlack;
        Brush.Color := col;
        Rectangle(0, 0, bmW, bmH);
     end;
  end;
end;

procedure TfrmMonWsjtx.SetAllbitmaps;
Begin
   Setbitmap(cmHere.Bitmap, wkdhere);
   Setbitmap(cmBand.Bitmap, wkdband);
   Setbitmap(cmAny.Bitmap, wkdAny);
   Setbitmap(cmNever.Bitmap, wkdnever);
   Setbitmap(cmCqDX.Bitmap, extCqCall);
   Setbitmap(cmMapCq.Bitmap, BkgCqCol);
end;

procedure TfrmMonWsjtx.popColorsPopup(Sender: TObject);
begin
   cmMapCq.Visible:=chkMap.Checked;
end;

procedure TfrmMonWsjtx.cmNeverClick(Sender: TObject);
begin
  popColorDlg.Color := wkdNever;
  popColorDlg.Title := 'Qso never before color';
  if popColorDlg.Execute then
  begin
    wkdNever := (popColorDlg.Color);
    cqrini.WriteString('MonWsjtx', 'wkdnever', ColorToString(wkdnever));
    SetAllbitmaps;
  end;
end;
procedure TfrmMonWsjtx.cmBandClick(Sender: TObject);
begin
  popColorDlg.Color := wkdBand;
  popColorDlg.Title := 'Qso on this band, but not this mode color';
  if popColorDlg.Execute then
  begin
    wkdBand := (popColorDlg.Color);
    cqrini.WriteString('MonWsjtx', 'wkdband', ColorToString(wkdband));
    SetAllbitmaps;
  end;

end;

procedure TfrmMonWsjtx.cmAnyClick(Sender: TObject);
begin
  popColorDlg.Color := wkdAny;
  popColorDlg.Title := 'Qso on some other band/mode color';
  if popColorDlg.Execute then
  begin
    wkdAny := (popColorDlg.Color);
    cqrini.WriteString('MonWsjtx', 'wkdany', ColorToString(wkdany));
    SetAllbitmaps;
  end;
end;

procedure TfrmMonWsjtx.cmHereClick(Sender: TObject);
begin
  popColorDlg.Color := wkdHere;
  popColorDlg.Title := 'Qso on this band and mode color';
  if popColorDlg.Execute then
  begin
    wkdHere := (popColorDlg.Color);
    cqrini.WriteString('MonWsjtx', 'wkdhere', ColorToString(wkdhere));
    SetAllbitmaps;
  end;
end;

procedure TfrmMonWsjtx.cmCqDxClick(Sender: TObject);
begin
  popColorDlg.Color := extCqCall;
  popColorDlg.Title := 'Extended CQ (DX, NA, SA ...) color';
  if popColorDlg.Execute then
   Begin
    extCqCall := (popColorDlg.Color);
    cqrini.WriteString('MonWsjtx', 'extCqCall', ColorToString(extCqCall));
    SetAllbitmaps;
   end;
end;

procedure TfrmMonWsjtx.cmMapCqClick(Sender: TObject);
begin
  popColorDlg.Color := BkgCqCol;
  popColorDlg.Title := 'Map mode: CQ caller background color';
  if popColorDlg.Execute then
   Begin
    BkgCqCol := (popColorDlg.Color);
    cqrini.WriteString('MonWsjtx', 'BkgCqCol', ColorToString(BkgCqCol));
    SetAllbitmaps;
   end;
end;

procedure TfrmMonWsjtx.EditAlertEnter(Sender: TObject);
begin
  tbAlert.Checked := False;
end;

procedure TfrmMonWsjtx.EditAlertExit(Sender: TObject);
begin
  cqrini.WriteString('MonWsjtx', 'TextAlert', EditAlert.Text);
  cqrini.WriteBool('MonWsjtx', 'Follow', tbFollow.Checked);
  EditAlert.Text := trim(EditAlert.Text);
  EditedText := EditAlert.Text;
end;

procedure TfrmMonWsjtx.edtFollowCallEnter(Sender: TObject);
begin
  tbFollow.Checked := False;
  edtFollowCall.Clear;
end;

procedure TfrmMonWsjtx.edtFollowCallExit(Sender: TObject);
begin
  edtFollowCall.Text := trim(UpperCase(edtFollowCall.Text));   //sure upcase-trimmed
  cqrini.WriteString('MonWsjtx', 'FollowCall', edtFollowCall.Text);
end;

procedure TfrmMonWsjtx.edtFollowCallKeyDown(Sender: TObject; var Key: word;
  Shift: TShiftState);
begin
  if key = 13 then
  begin
    key := 0;
    tbFollow.SetFocus;
    tbFollow.Checked := True;
  end;
end;

procedure TfrmMonWsjtx.SendFreeText(MyText: string);
var
  i: byte;
begin
  if (length(MyText) > 13) then
    MyText := copy(MyText, 1, 13); //free text max len 13
  if frmNewQSO.RepHead <> '' then
  begin
    RepBuf := frmNewQSO.RepHead;
    RepBuf[12] := #9; //Free Text command
    RepBuf := RepBuf + #0 + #0 +#0 + chr(length(MyText)) + MyText + #0;
    //if LocalDbg then BufDebug('Free text buffer contains:',RepBuf
    frmNewQSO.Wsjtxsock.SendString(RepBuf);
  end;
end;

procedure TfrmMonWsjtx.SendConfigure(Mode,Submode,DXCall,DXGrid:string;FreqTol,TRPeriod,RxDF:Dword;Fmode,GMsg:boolean);
var
  i: byte;

procedure AddCint(c:Dword);
begin
     RepBuf := RepBuf + chr(hi(hi(c))) + chr(lo(hi(c))) + chr(hi(lo(c))) + chr(lo(lo(c)));
end;
procedure AddString(s:string);  //strings here can not be over 256 length here
var  l: integer;
Begin
    l:=  length(s);
    if l=0 then
       RepBuf := RepBuf +#$FF+#$FF+#$FF+#$FF
     else
       RepBuf := RepBuf +#0 + #0 +#0 + chr(l) + Uppercase(s);
end;
procedure AddBool(b:boolean);
Begin
  if b then
             RepBuf := RepBuf +#1
           else
             RepBuf := RepBuf +#0;
end;


begin
  if frmNewQSO.RepHead <> '' then
  begin
    RepBuf := frmNewQSO.RepHead;
    RepBuf[12] := #15; //Send config 15

    AddString(Mode);
    AddCint(Freqtol);
    AddString(Submode);
    AddBool(Fmode);
    AddCint(TRPeriod);
    AddCint(RxDF);
    AddString(DXCall);
    AddString(DXGrid);
    AddBool(GMsg);

    frmNewQSO.Wsjtxsock.SendString(RepBuf);
    //BufDebug('UDP#15',RepBuf);
  end;
  {
 *                         Mode                   utf8
 *                         Frequency Tolerance    quint32
 *                         Submode                utf8
 *                         Fast Mode              bool
 *                         T/R Period             quint32
 *                         Rx DF                  quint32
 *                         DX Call                utf8
 *                         DX Grid                utf8
 *                         Generate Messages      bool
 *      For  utf8  string
 *      fields an empty value implies no change, for the quint32 Rx DF
 *      and  Frequency  Tolerance  fields the  maximum  quint32  value
 *      implies  no change.
  }
end;

procedure TfrmMonWsjtx.edtFollowDblClick(Sender: TObject);
begin
  if LocalDbg then
    Writeln('Clicked follow line gives: ', RepFlw);
  SendQsoInit(RepFlw);
end;

procedure TfrmMonWsjtx.edtFltMapEnter(Sender: TObject);
begin
  edtFltMap.Text:='';
  chkFlt.Checked:=false;
end;

procedure TfrmMonWsjtx.edtFltMapExit(Sender: TObject);
begin
  edtFltMap.Text := trim(UpperCase(edtFltMap.Text));   //sure upcase-trimmed
  cqrini.WriteString('MonWsjtx', 'MapFilterString', edtFltMap.Text);
end;

procedure TfrmMonWsjtx.edtFltMapKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=VK_RETURN then
   Begin
     if edtFltMap.Text<>'' then chkFlt.Checked:=True;
     sgMonitor.SetFocus;
   end;
end;

procedure TfrmMonWsjtx.edtFltMapMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button=mbRight then edtFltMap.Text:='';
end;



procedure TfrmMonWsjtx.chknoHistoryChange(Sender: TObject);
begin
  cqrini.WriteBool('MonWsjtx', 'NoHistory', chknoHistory.Checked);
  with sgMonitor do
   Begin
    if chknoHistory.Checked then
      Begin
        Columns.Items[0].maxSize := 4;
        Columns.Items[0].minSize := 4;
        Columns.Items[1].maxSize := 3;
        Columns.Items[1].minSize := 3;
      end
     else
      Begin
       Columns.Items[0].maxSize := 6;
       Columns.Items[0].minSize := 6;
       Columns.Items[1].maxSize := 1;
       Columns.Items[1].minSize := 1;
      end;
    clearSgMonitor;
  end;
end;
procedure TfrmMonWsjtx.SaveFormPos(FormMode: string);

begin
  if LocalDbg then
    Writeln('---------------------------------------SaveFormPos:', FormMode);
  if frmMonWsjtx.WindowState = wsMaximized then
    cqrini.WriteBool('MonWsjtx', FormMode + 'Max', True)
  else
  begin
    cqrini.WriteInteger('MonWsjtx', FormMode + 'Height', frmMonWsjtx.Height);
    cqrini.WriteInteger('MonWsjtx', FormMode + 'Width', frmMonWsjtx.Width);
    cqrini.WriteInteger('MonWsjtx', FormMode + 'Top', frmMonWsjtx.Top);
    cqrini.WriteInteger('MonWsjtx', FormMode + 'Left', frmMonWsjtx.Left);
    cqrini.WriteBool('MonWsjtx', FormMode + 'Max', False);
  end;
end;

procedure TfrmMonWsjtx.LoadFormPos(FormMode: string);
Const
  Mh=600;      //starting defaults
  Mw=300;
  Ch=400;
  Cw=550;
var
  w,h : integer;
begin
  if LocalDbg then
    Writeln('---------------------------------------LoadFormPos:', FormMode);
  if cqrini.ReadBool('MonWsjtx', FormMode + 'Max', False) then
    frmMonWsjtx.WindowState := wsMaximized
  else
  begin
    if (pos('MAP',UpperCase(FormMode))>0) then
      Begin
        h:=Mh;
        w:=Mw;
      end
     else
      Begin
        h:=Ch;
        w:=Cw;
      end;
    frmMonWsjtx.Height := cqrini.ReadInteger('MonWsjtx', FormMode + 'Height', h);
    frmMonWsjtx.Width := cqrini.ReadInteger('MonWsjtx', FormMode + 'Width', w);
    frmMonWsjtx.Top := cqrini.ReadInteger('MonWsjtx', FormMode + 'Top', 3);
    frmMonWsjtx.Left := cqrini.ReadInteger('MonWsjtx', FormMode + 'Left', 3);
  end;
end;

procedure TfrmMonWsjtx.chkMapClick(Sender: TObject);
begin
  sgMonitor.Visible:= not(chknoTxt.Checked and not chkMap.Checked);
  lblInfo.Visible := not sgMonitor.Visible;

  if not LockMap then    //do not run automaticly on init or leave form
  begin
    cqrini.WriteBool('MonWsjtx', 'MapMode', chkMap.Checked);

    if chkMap.Checked then
    begin   //Map
      //write width/height CQ read width Map
      if not Sender.ClassNameIs('TfrmMonWsjtx') then  SaveFormPos('Cq');  //no save from init
      LoadFormPos('Map');
      LockFlw := True;
      cbflw.Checked := False;
      //drops panel size reservation. Map drops "follow" it does not return ON  when back to monitor mode
      LockFlw := False;
      pnlMap.Visible := chkMap.Checked;
      frmMonWsjtx.Caption := 'Wsjt-x map';
      pnlFollow.Visible := False;
      pnlAlert.Visible := False;
      cbflw.Visible := False;
      chknoTxt.Visible := False;
      chknoTxt.Checked := False;
      chknoHistory.Checked := True;
      chkDs.Visible:= True;
      chkCbCQ.Checked := cqrini.ReadBool('MonWsjtx', 'ColorBacCQkMap', False);
      chkdB.Checked   := cqrini.ReadBool('MonWsjtx', 'ShowdB', False);
      chkFlt.Checked  := cqrini.ReadBool('MonWsjtx', 'MapFilter', False);
      chkFFlt.Checked := cqrini.ReadBool('MonWsjtx', 'FileFilter', False);
      edtFltMap.Text  := cqrini.ReadString('MonWsjtx', 'MapFilterString', '');
      //map mode allows text printing. Printing stays on when return to monitor mode.
      chknoHistory.Visible := False;
      sgMonitor.Columns.Items[0].Visible:= false;
      sgMonitor.Columns.Items[1].Visible:= chkdB.Checked;
      sgMonitor.Columns.Items[7].Visible:= true;
      sgMonitor.Columns.Items[6].MinSize:=2;  //map mode -> US state
      sgMonitor.Columns.Items[6].MaxSize:=2;
    end
    else
    begin   //Cq
      //write width/height Map read width CQ
      if  not Sender.ClassNameIs('TfrmMonWsjtx')  then  SaveFormPos('Map');   //no save from init
      LoadFormPos('Cq');
      cbflw.Checked := cqrini.ReadBool('MonWsjtx', 'FollowShow', False);
      tbFollow.Checked := cqrini.ReadBool('MonWsjtx', 'Follow', False);
      frmMonWsjtx.Caption := 'Wsjt-x CQ-monitor';
      pnlMap.Visible := False;
      pnlAlert.Visible := True;
      cbflw.Visible := True;
      chknoTxt.Visible := True;
      chknoHistory.Visible := True;
      chkDs.Visible:= False;
      sgMonitor.Columns.Items[0].Visible:= true;
      sgMonitor.Columns.Items[1].Visible:= true;
      sgMonitor.Columns.Items[7].Visible:= true;
      sgMonitor.Columns.Items[6].MinSize:=15;
      sgMonitor.Columns.Items[6].MaxSize:=15;
    end;
    clearSgMonitor;
  end;
end;

procedure TfrmMonWsjtx.chkStopTxChange(Sender: TObject);
begin
  cqrini.WriteBool('MonWsjtx', 'StopTX', chkStopTx.Checked);
  if chkStopTx.Checked = false then
    begin
      DblClickCall := '';
      if LocalDbg then Writeln('Reset 2click call: sTx unchecked');
    end;
end;
procedure TfrmMonWsjtx.StateCallCount(var c:integer);
begin
      if dmData.trQstate.Active then dmData.trQstate.Rollback;
      dmData.trQstate.StartTransaction;
      dmData.Qstate.SQL.Text := 'select count(callsign) as c from cqrlog_common.states';
      if LocalDbg then  Writeln(dmData.Qstate.SQL.Text);
      dmData.Qstate.open;
      c:= dmData.Qstate.FieldByName('c').AsInteger;
      dmData.trQstate.Rollback;
      dmData.Qstate.Close;
      sgMonitor.InsertRowWithValues(sgMonitor.rowcount , ['']);
      AddColorStr(IntToStr(c),clBlack,3,sgMonitor.rowcount-1);
      AddColorStr('ca',clBlack,4,sgMonitor.rowcount-1);
      AddColorStr('ll',clBlack,5,sgMonitor.rowcount-1);
      AddColorStr('in',clBlack,6,sgMonitor.rowcount-1);
      AddColorStr('DB',clBlack,7,sgMonitor.rowcount-1);
end;

procedure TfrmMonWsjtx.chkUStateClick(Sender: TObject);

var
  SourceFile,
  msg ,
  call,
  tmp,
  HasState        : String;
  StateSourceIn    : Textfile;
  BuildFile        : TIniFile;
  i                : integer;
  c                : integer=0;
begin
  cqrini.WriteBool('MonWsjtx', 'UStates', chkUState.Checked);
  if (Sender.ClassNameIs('TfrmNewQso')) then   //user init
                                          c:= -1;
  if (chkUState.Checked or (c=-1)) then
    Begin
      if LocalDbg then  Writeln('State check activated');
      SourceFile :=  dmData.HomeDir+C_STATE_SOURCE;
      if (c=0) then
       if (FileExists(SourceFile)) then   //no user init, check age
                                c:= DaysBetween(now,FileDateTodateTime(FileAge(SourceFile)))
                               else
                                c:=-2; //no file found
      if ((c > 90) or (c<0)) then
            Begin //over 3 month old, missing or manual
             case c of
              -2  : tmp:='File is missing!';
              -1  : tmp:='You did manual update request.';
              else
                tmp:= 'File is over 90 days old!';
              end;
             msg := 'Source file '+SourceFile+LineEnding
                    +#13+#13+tmp+#13+'Do you want to update data?'
                    +#13+#13+'(More info: Help/Digital modes: wjstx/Checking "USt”)' ;
              if Application.MessageBox(PChar(msg),'Question ...',MB_ICONQUESTION + MB_YESNO) = IDYES Then
                Begin
                 frmProgress.UpdateUSDBState(SourceFile); //direct this via NewQSO so that closing WSJT remote does not kill it's owner
                end
               else
                   if (c=-2) then
                          begin
                            chkUState.Checked := false;
                            exit;
                          end

            end;
       StateCallCount(c);

    end;
  if (chkUState.Checked and (c<1000000)) then
       begin
        msg := 'Could it be that database does not have all US callsigns?'+#13+
               'Found '+IntToStr(c)+' callsigns. '+#13+ 'Try to rebuild? (NO = use as is)';
        if Application.MessageBox(PChar(msg),'Question ...',MB_ICONQUESTION + MB_YESNO) = IDYES Then
           begin
            frmProgress.BuildUSDBState;
            StateCallCount(c);
           end
       end;
end;

procedure TfrmMonWsjtx.chkUStateMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    If (Button = mbRight) and (Shift=[ssShift]) then        //asks update DB by user event
            chkUStateClick(frmNewQso);    //fake with form NewQso name
end;
procedure TfrmMonWsjtx.cbflwChange(Sender: TObject);
begin
  if not LockFlw then
    cqrini.WriteBool('MonWsjtx', 'FollowShow', cbflw.Checked);
  if cbflw.Checked then
  begin
    sgMonitor.BorderSpacing.Bottom := 96;
    pnlFollow.Visible := True;
    edtFollow.Text := '';
    ;
  end
  else
  begin
    tbFollow.Checked := False;
    sgMonitor.BorderSpacing.Bottom := 51;
    pnlFollow.Visible := False;
  end;
end;

procedure TfrmMonWsjtx.chkdBChange(Sender: TObject);
begin
  cqrini.WriteBool('MonWsjtx', 'ShowdB', chkdB.Checked);
end;

procedure TfrmMonWsjtx.chkDxClick(Sender: TObject);
var
  f:integer;
  c:String;
begin
   if chkDx.Checked then
    Begin
      for f:=1 to 6 do
            begin
              popDx.Items[f].Enabled:=true;  //first enable all
              popDx.Items[f].Checked:=False; //but disable checks
            end;
      case dmUtils.MyContinent of            //then disable own
        'AF': ShAF.Enabled:=False;
        'AS': ShAS.Enabled:=False;
        'EU': ShEU.Enabled:=False;
        'NA': ShNA.Enabled:=False;
        'OC': ShOC.Enabled:=False;
        'SA': ShSA.Enabled:=False;
      end;
      //preset values
      c:=cqrini.ReadString('MonWsjtx', 'ShowDxList', 'AFASEUNAOCSA');
      for f:=1 to 6 do                      //enable selected checks
          if popDx.Items[f].Enabled then
             if (pos(ExtractWord(2,popDx.Items[f].Caption,[' ']),c)>0) then
                                                         popDx.Items[f].Checked:=True;

     if DXpopOK then popDx.PopUp;
    end
     else
      Begin
       chkDx.Font.Style:=[];
       chkDx.Font.Color:=clDefault;
      end;
   cqrini.WriteBool('MonWsjtx', 'CheckDx',chkDx.Checked);
end;

procedure TfrmMonWsjtx.chkDxMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 if (Button=mbRight) and chkDX.Checked then
   Begin
      popDX.popup;
   end;
end;

procedure TfrmMonWsjtx.btFtxtNameClick(Sender: TObject);
var
  My: string;
begin
  if frmNewQSO.edtName.Text <> '' then
  begin
    My := Upcase('TU ' + copy(frmNewQSO.edtName.Text,1,7) + ' 73');
    if length(My) < 14 then
    begin
      SendFreeText(My);
      if LocalDbg then
        Writeln('Sent Free text>', My, '<');
    end
    else
    btFtxtName.Visible:=false;
  end;
end;

procedure TfrmMonWsjtx.chkDsClick(Sender: TObject);
begin
  cqrini.WriteBool('MonWsjtx', 'DxStatus',chkDs.Checked);
end;

procedure TfrmMonWsjtx.chkFFltChange(Sender: TObject);
var
  s:String;
  f:integer;
begin
  if chkFFlt.Checked then
  chkFlt.Checked := false;
   Begin
      FileFilter.Clear;
      s:= FileSearch('filefilter.txt',dmData.HomeDir + 'ctyfiles' + PathDelim,[]);

      if (s <> '') then
                     Begin
                      FileFilter.LoadFromFile(s);
                      for f:=0 to FileFilter.Count-1 do
                         FileFilter[f]:=UpperCase(FileFilter[f]);
                     end
                 else
                     Begin
                      cqrini.WriteBool('MonWsjtx', 'FileFilter',false);
                      ShowMessage(dmData.HomeDir + 'ctyfiles' + PathDelim+'filefilter.txt'+
                      LineEnding+'Not found!');
                      chkFFlt.Checked:=False;
                     end;
   end;
end;

procedure TfrmMonWsjtx.chkFFltClick(Sender: TObject);
begin
  cqrini.WriteBool('MonWsjtx', 'FileFilter', chkFFlt.Checked);
end;

procedure TfrmMonWsjtx.chkFFltMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
            dmUtils.ViewTextFile(dmData.HomeDir + 'ctyfiles' + PathDelim+'filefilter.txt');
end;

procedure TfrmMonWsjtx.chkFltChange(Sender: TObject);
begin
  if chkFlt.Checked then
                         chkFFlt.Checked:=false;
end;

procedure TfrmMonWsjtx.chkFltClick(Sender: TObject);
begin
  cqrini.WriteBool('MonWsjtx', 'MapFilter', chkFlt.Checked);
end;

procedure TfrmMonWsjtx.chkSortClick(Sender: TObject);
begin
  cqrini.WriteBool('MonWsjtx', 'Sort', chkSort.Checked);
  if chkSort.Checked and DXpopOK then
     popSort.PopUp;
end;

procedure TfrmMonWsjtx.chkSortMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (Button=mbRight) and chkSort.Checked then
   Begin
      popSort.popup;
   end;
end;

procedure TfrmMonWsjtx.chkCbCQChange(Sender: TObject);
begin
  cqrini.WriteBool('MonWsjtx', 'ColorBacCQkMap', chkCbCQ.Checked);
  chkds.Enabled:=not chkCbCQ.Checked;     //DXCC status printing fails if Cqs are colored back to wsjtx
end;

procedure TfrmMonWsjtx.chknoTxtChange(Sender: TObject);
begin
  cqrini.WriteBool('MonWsjtx', 'NoTxt', chknoTxt.Checked);
  sgMonitor.Visible:= not(chknoTxt.Checked and not chkMap.Checked);
  lblInfo.Visible := not sgMonitor.Visible;
end;

procedure TfrmMonWsjtx.mnuSort1Click(Sender: TObject);
var f,i:integer;

begin
     for f:=0 to 6 do
          popSort.Items[f].Checked:=false;

     TMenuitem(Sender).Checked:=true;
     if tryStrToInt(copy(TMenuitem(Sender).Caption,11,1),i) then
        cqrini.WriteInteger('MonWsjtx', 'SortCol', i);
end;

procedure TfrmMonWsjtx.pnlSelectsClick(Sender: TObject);
begin
  pnlSelects.Visible:=False;
  sgMonitor.BorderSpacing.Top:= 3;
end;

procedure TfrmMonWsjtx.pnlTrigPopMouseEnter(Sender: TObject);
begin
  pnlSelects.Visible:=True;
  sgMonitor.BorderSpacing.Top:=pnlSelects.Height;
end;

procedure TfrmMonWsjtx.sgMonitorDrawCell(Sender: TObject; aCol, aRow: Integer;
  aRect: TRect; aState: TGridDrawState);
//DL7OAP: complete procedure for the coloring, this function is called every time
//the system repaints the grid. you can force repainting with sgMonitor.repaint;
begin
  sgMonitor.Canvas.Brush.Color:=sgMonitorAttributes[ACol,ARow].BG_Color; // sets background color
  sgMonitor.Canvas.Font.Color:=sgMonitorAttributes[ACol,ARow].FG_Color; // sets foreground color
  if sgMonitorAttributes[ACol,ARow].isbold then
    sgMonitor.Canvas.Font.Style:=[fsBold];
  sgMonitor.Canvas.Fillrect(aRect); // fills cell with backcolor, text is lost in this moment
  sgMonitor.Canvas.TextRect(aRect, aRect.Left + 1, aRect.Top + 1, sgMonitor.Cells[ACol, ARow]); //refills the text
end;
                        
procedure TfrmMonWsjtx.ShAFClick(Sender: TObject);
var
   p: TPoint;
Begin
  p:=popDx.PopupPoint;
  TMenuitem(Sender).checked:= not TMenuitem(Sender).checked;
  popDx.PopUp(p.x,p.y);
end;

procedure TfrmMonWsjtx.ShAllClick(Sender: TObject);
var
    f: integer;
    b: boolean;
    p:TPoint;
Begin
  p:=popDx.PopupPoint;
  b:= not popDx.Items[0].Checked;
  for f:=1 to 6 do
   if popDx.Items[f].Enabled then
             popDx.Items[f].Checked:=b;
  popDx.PopUp(p.x,p.y);
end;

procedure TfrmMonWsjtx.popDxClose(Sender: TObject);
var
    f: integer;
    c:string ='';
begin
     for f:=1 to 6 do
       if popDx.Items[f].Checked then
        Begin
          c:= c+ExtractWord(2,popDx.Items[f].Caption,[' ']);
        end;
     if (c='') then
                 Begin
                   c:='!'; //indicates empty, but exisiting list
                   chkDx.Font.Style:=[fsBold];
                   chkDx.Font.Color:=clRed;
                 end
                else
                 begin
                  chkDx.Font.Style:=[fsBold];
                  chkDx.Font.Color:=clGreen;
                 end;
     cqrini.WriteString('MonWsjtx', 'ShowDxList', c);
end;

procedure TfrmMonWsjtx.tbAlertChange(Sender: TObject);
begin
  cqrini.WriteBool('MonWsjtx', 'TextAlertSet', tbAlert.Checked);
  if tbAlert.Checked then
  begin
    tbAlert.Font.Color := clGreen;
    tbAlert.Font.Style := [fsBold];
    if tbTCAlert.Checked then
    begin
      EditAlert.Text := trim(UpperCase(EditAlert.Text));
      EditedText := EditAlert.Text;
    end;
  end
  else
  begin
    tbAlert.Font.Color := clRed;
    tbAlert.Font.Style := [];
  end;
end;

procedure TfrmMonWsjtx.tbFollowChange(Sender: TObject);
begin
  if not LockFlw then
    cqrini.WriteBool('MonWsjtx', 'Follow', tbFollow.Checked);
  if  tbFollow.Checked  then
  begin
    tbFollow.Font.Color := clGreen;
    tbFollow.Font.Style := [fsBold];
    cqrini.WriteString('MonWsjtx', 'FollowCall', edtFollowCall.Text);
  end
  else
  begin
    tbFollow.Font.Color := clRed;
    tbFollow.Font.Style := [];
    edtFollow.Text := '';
  end;
end;

procedure TfrmMonWsjtx.tbLocAlertChange(Sender: TObject);
begin
  cqrini.WriteBool('MonWsjtx', 'LocAlert', tbLocAlert.Checked);
  if tbLocAlert.Checked then
  begin
    tbLocAlert.Font.Color := clGreen;
    tbLocAlert.Font.Style := [fsBold];
  end
  else
  begin
    tbLocAlert.Font.Color := clRed;
    tbLocAlert.Font.Style := [];
  end;
end;

procedure TfrmMonWsjtx.tbmyAllChange(Sender: TObject);
begin
  cqrini.WriteBool('MonWsjtx', 'MyAll', tbmyAll.Checked);
  if tbmyAll.Checked then
  begin
    tbmyAll.Font.Color := clGreen;
    tbmyAll.Font.Style := [fsBold];
  end
  else
  begin
    tbmyAll.Font.Color := clRed;
    tbmyAll.Font.Style := [];
  end;
end;

procedure TfrmMonWsjtx.tbmyAlrtChange(Sender: TObject);
begin
  cqrini.WriteBool('MonWsjtx', 'MyAlert', tbmyAlrt.Checked);
  if tbmyAlrt.Checked then
  begin
    tbmyAlrt.Font.Color := clGreen;
    tbmyAlrt.Font.Style := [fsBold];
  end
  else
  begin
    tbmyAlrt.Font.Color := clRed;
    tbmyAlrt.Font.Style := [];
  end;
end;

procedure TfrmMonWsjtx.tbTCAlertChange(Sender: TObject);
begin
  cqrini.WriteBool('MonWsjtx', 'TextAlertCall', tbTCAlert.Checked);
  tbAlert.Checked := False;   //drop alert off if text/call change
  if tbTCAlert.Checked then
  begin
    tbTCAlert.SetTextBuf('Call');
    EditAlert.Text := trim(UpperCase(EditAlert.Text));   //sure upcase-trimmed
    EditedText := EditAlert.Text;
  end
  else
  begin
    tbTCAlert.SetTextBuf('Text');
  end;
end;

procedure TfrmMonWsjtx.tmrCqPeriodTimer(Sender: TObject);
var
  i, j: integer;
begin
  tmrCqPeriod.Enabled := False;
  if LocalDbg then Writeln('Period timer hit the time!');
  if (chknoHistory.Checked) then
     ReColorsgMonitor(clSilver,clWhite,true);
end;

procedure TfrmMonWsjtx.tmrStartupDoneTimer(Sender: TObject);
begin   //post actions after window has opened.
   tmrStartupDone.Enabled:=False;
   chkUState.Checked:= cqrini.ReadBool('MonWsjtx', 'UStates', False);

   chkDx.Checked:=cqrini.ReadBool('MonWsjtx', 'CheckDx',false);
   chkSort.Checked:= cqrini.ReadBool('MonWsjtx', 'Sort', false);
   popSort.Items[cqrini.ReadInteger('MonWsjtx', 'SortCol', 1)-1].Checked:=true;
   if chkDx.Checked then
                    popDxClose(nil);
   if chkSort.Checked then
                    popSort.Close;
   DXpopOK:=true;
end;

procedure TfrmMonWsjtx.tmrFollowTimer(Sender: TObject);
begin
  tmrFollow.Enabled := False;
  if tbFollow.Checked then
    edtFollow.Font.Color := clSilver;
end;

procedure TfrmMonWsjtx.CqPeriodTimerStart(msgnow,msglast:string);
var
    tmr: integer;
    n,l: Longint;
begin
  tmrCqPeriod.Enabled := False;
  if (msgnow='') or (msglast='') then exit;
  n:=3600*StrToInt(msgnow[1]+msgnow[2])+60*StrToInt(msgnow[3]+msgnow[4])+StrToInt(msgnow[5]+msgnow[6]);
  l:=3600*StrToInt(msglast[1]+msglast[2])+60*StrToInt(msglast[3]+msglast[4])+StrToInt(msglast[5]+msglast[6]);
  tmr:= ((n-l)*1000*2) div 3;
  if (tmr<=0) or (tmr>120000) then exit;

  tmrCqPeriod.Interval := tmr;
  if LocalDbg then
              Writeln('Period timer set to: ',tmr);
  tmrCqPeriod.Enabled := True;
end;

procedure TfrmMonWsjtx.cmFontClick(Sender: TObject);
begin
  popFontDlg.Font.Name := cqrini.ReadString('MonWsjtx', 'Font', 'Monospace');
  popFontDlg.Font.Size := cqrini.ReadInteger('MonWsjtx', 'FontSize', 10);
  popFontDlg.Title := 'Use monospace fonts, style is ignored';
  if popFontDlg.Execute then
  begin
    cqrini.WriteString('MonWsjtx', 'Font', popFontDlg.Font.Name);
    cqrini.WriteInteger('MonWsjtx', 'FontSize', popFontDlg.Font.Size);
    edtFollow.Font.Name := popFontDlg.Font.Name;
    edtFollow.Font.Size := popFontDlg.Font.Size;
    sgMonitor.Font.Name := popFontDlg.Font.Name;
    sgMonitor.Font.Size := popFontDlg.Font.Size;
    clearSgMonitor;
    edtFollow.Text := '';
  end;
end;

procedure TfrmMonWsjtx.FormCreate(Sender: TObject);
begin
  LockMap := True;
  EditAlert.Text := '';
  EditedText := '';
  LastWsjtLineTime := '';
  DblClickCall :='';
  DXpopOK      :=false;

  cmHere.Bitmap := TBitmap.Create;
  cmBand.Bitmap := TBitmap.Create;
  cmAny.Bitmap  := TBitmap.Create;
  cmNever.Bitmap := TBitmap.Create;
  cmCqDX.Bitmap := TBitmap.Create;
  CanCloseUSDBProcess := True;  //there is no process yet
  UsedBkgCqCol :=clWhite;
  FileFilter:= TStringList.Create;

  //DL7OAP
  setDefaultColorSgMonitorAttributes;
  sgMonitor.DefaultDrawing:= True; // setting to true to use DrawCell-Event for coloring

end;

procedure TfrmMonWsjtx.FormDropFiles(Sender: TObject;
  const FileNames: array of String);
begin
  edtFollowCall.Clear;
  tbFollow.SetFocus;
  tbFollow.Checked:=True;
end;

procedure TfrmMonWsjtx.FormHide(Sender: TObject);
begin
  //decodetest(true);  //release these for decode tests
  //decodetest(false);
  exit;
  LockMap := True;
  if chkMap.Checked then
    SaveFormPos('Map')
  else
    SaveFormPos('Cq');  //to be same as intial save
  dmUtils.SaveWindowPos(frmMonWsjtx);
  writeln('------------- hide form');
  frmMonWsjtx.hide;
end;


procedure TfrmMonWsjtx.FormShow(Sender: TObject);
begin
  dmUtils.LoadWindowPos(frmMonWsjtx);
  dmUtils.LoadFontSettings(frmMonWsjtx);
  //overrides font loading
  sgMonitor.Font.Name := cqrini.ReadString('MonWsjtx', 'Font', 'Monospace');
  sgMonitor.Font.Size := cqrini.ReadInteger('MonWsjtx', 'FontSize', 10);

  chknoHistory.Checked := cqrini.ReadBool('MonWsjtx', 'NoHistory', False);
  chknoTxt.Checked := cqrini.ReadBool('MonWsjtx', 'NoTxt', False);
  chkStopTx.Checked := cqrini.ReadBool('MonWsjtx', 'StopTX',  False );
  tbmyAlrt.Checked := cqrini.ReadBool('MonWsjtx', 'MyAlert', False);
  tbmyAll.Checked := cqrini.ReadBool('MonWsjtx', 'MyAll', False);
  tbLocAlert.Checked := cqrini.ReadBool('MonWsjtx', 'LocAlert', False);
  EditAlert.Text := cqrini.ReadString('MonWsjtx', 'TextAlert', '');
  EditedText := EditAlert.Text;
  tbAlert.Checked := cqrini.ReadBool('MonWsjtx', 'TextAlertSet', False);
  tbTCAlert.Checked := cqrini.ReadBool('MonWsjtx', 'TextAlertCall', False);
  wkdhere := StringToColor(cqrini.ReadString('MonWsjtx', 'wkdhere', '$000A07E1'));
  wkdband := StringToColor(cqrini.ReadString('MonWsjtx', 'wkdband', '$00FF00FF'));
  wkdany := StringToColor(cqrini.ReadString('MonWsjtx', 'wkdany', '$00000080'));
  wkdnever := StringToColor(cqrini.ReadString('MonWsjtx', 'wkdnever', '$00008000'));
  BkgCqCol := StringToColor(cqrini.ReadString('MonWsjtx', 'BkgCqCol', '$FFFFFFFF'));
  extCqCall := StringToColor(cqrini.ReadString('MonWsjtx', 'extCqCall', '$00FF6B00'));
  SetAllbitmaps;
  edtFollow.Font.Name := sgMonitor.Font.Name;
  edtFollow.Font.Size := sgMonitor.Font.Size;
  cbflw.Checked := cqrini.ReadBool('MonWsjtx', 'FollowShow', False);
  tbFollow.Checked := cqrini.ReadBool('MonWsjtx', 'Follow', False);
  edtFollowCall.Text := uppercase(cqrini.ReadString('MonWsjtx', 'FollowCall', ''));
  chkMap.Checked := cqrini.ReadBool('MonWsjtx', 'MapMode', False);
  chkDs.Checked := cqrini.ReadBool('MonWsjtx', 'DxStatus', False);
  if ((trim(edtFollowCall.Text) = '') and tbFollow.Checked) then
    tbFollow.Checked := False; //should not happen, chk it here
  LockFlw := False;
  LockMap := False; //last thing to do
  chkMapClick(frmMonWsjtx);
  btFtxtName.Visible := False;
  //DL7OAP
  SetsgMonitorColumnHW;
  sgMonitor.FocusRectVisible:=false; // no red dot line in stringgrid
   //for debug
   { sgMonitor.GridLineColor:=clBlack;
    sgMonitor.GridLineStyle:=psSolid;
    sgMonitor.GridLineWidth:=1;
   }
  chknoHistoryChange(nil); // sure to get history settings right
  pnlTrigPopMouseEnter(nil); //starts with panel visible,

  //set debug rules for this form
  LocalDbg := dmData.DebugLevel >= 1 ;
  if dmData.DebugLevel < 0 then
        LocalDbg :=  LocalDbg or ((abs(dmData.DebugLevel) and 4) = 4 );
  tmrStartupDone.Enabled:=True;    //post actions

end;

procedure TfrmMonWsjtx.NewBandMode(Band, Mode: string);
begin
  lblBand.Caption := Band;
  lblMode.Caption := Mode;
  CurBand := Band;
  CurMode := Mode;
  clearSgMonitor;
  edtFollow.Text := '';
end;

//-----------------------------------------------------------------------------------------
procedure TfrmMonWsjtx.decodetest(i: boolean);           // run execptions for debug
var
  mycall : string;
begin
  mycall := UpperCase(cqrini.ReadString('Station', 'Call', ''));
  //split message it can be: (note: when testing remember continent compare set calls to be non dx]
  if (i) then
  begin
    AddCqCallMessage('175200','#','20M','CQ OH1LL KP11','reply', 0, 0);      //normal cq
    AddCqCallMessage('175200','@','20M','CQ DX OH1DX KP11','reply', 0, 0);   //directed cq
    AddCqCallMessage('175200','@','20M','CQ NA RV3NA','reply', 0, 0);
    //call and continents/prefixes  no loc
    AddCqCallMessage('175200','@','20M','CQ USA RV3USA','reply', 0, 0);
    //call and continents/prefixes
    AddCqCallMessage('175200','@','20M','CQ USA RV3USL KO30','reply', 0, 0);
    //call and continents/prefixes
    AddCqCallMessage('175200','@','20M','CQ OH1LL DX','reply', 0, 0);
    //old official cq dx
    AddMyCallMessage('175200','~','20M',mycall+' DL2BQV JO73                     a2','reply', 0, 0);
    AddMyCallMessage('175200','~','20M',mycall+' DL2BQV RR73','reply', 0, 0);
    AddCqCallMessage('175200','#','20M','CQ 000 PA7ZZ JO22','reply', 0, 0);
    AddCqCallMessage('175200','#','20M','CQ ASOC PA7ZZ JO22','reply', 0, 0);
    AddCqCallMessage('175200','~','20M','CQ NO EU RZ3DX','reply', 0, 0);  // for dbg
    //ignore these, no callers callsign
    AddCqCallMessage('201045','~','20M','CQ KAZAKHSTAN','reply', 0, 0);
    AddCqCallMessage('201045','~','20M','CQ WHO EVER','reply', 0, 0);
    // some special
    AddCqCallMessage('175200','@','20M','CQ EA7/DL8FCL','reply', 0, 0);
    AddCqCallMessage('175200','@','20M','CQ <AA2019CALL>','reply', 0, 0);
    // this will fail, it is like real locator
    AddCqCallMessage('175200','@','20M','CQ <OH60AB> KP01','reply', 0, 0);
  end
  else
  begin
    ShowMessage('Test with CQ extensions:' + sLineBreak +
      '175200 # CQ OH1LL KP11' + sLineBreak + '175200 @ CQ DX OH1DX KP11' + sLineBreak +
      '175200 @ CQ NA RV3NA' + sLineBreak + '175200 @ CQ USA RV3USA' + sLineBreak +
      '175200 @ CQ USA RV3USL KO30' + sLineBreak + '175200 @ CQ OH1LL DX' + sLineBreak +
      '175200 # '+mycall+' DL2BQV JO73                     a2' + sLineBreak +
      '175200 # '+mycall+' DL2BQV RR73' + sLineBreak +
      '175200 # CQ 000 PA7ZZ JO22' + sLineBreak +
      '175200 # CQ ASOC PA7ZZ JO22'   + sLineBreak +
      '175200 ~ CQ NO EU RZ3DX' + sLineBreak + '201045 ~ CQ KAZAKHSTAN' + sLineBreak +
      '201045 ~ CQ WHO EVER' + sLineBreak +
      '175200 @ CQ EA7/DL8FCL'  + sLineBreak +
      '175200 @ CQ <AA2019CALL>' + sLineBreak +
      '175200 @ CQ <OH60AB> KP01'
      );  // for dbg
  end;
end;

 function TfrmMonWsjtx.HexStrToStr(const HexStr: string): string;
var
  ResultLen: Integer;
begin
  ResultLen := Length(HexStr) div 2;
  SetLength(Result, ResultLen);
  if ResultLen > 0 then
    SetLength(Result, HexToBin(Pointer(HexStr), Pointer(Result), ResultLen));
end;

function TfrmMonWsjtx.StrToHexStr(const S: string): string;
var
  ResultLen: Integer;
begin
  ResultLen := Length(S) * 2;
  SetLength(Result, ResultLen);
  if ResultLen > 0 then
    BinToHex(Pointer(S), Pointer(Result), Length(S));
end;

procedure TfrmMonWsjtx.AddOtherMessage(Time,Message, Reply: string;Df,Sr:integer);
var
  msgList: TStringList;
  index: integer;
  ClLine : String = '';
  adif:integer;
  pfx:string = '';
  msgRes:string = '';
  StatClr: Tcolor;
  dxinfo : string = '';
begin
  Message := LineFilter(Message);

  //to stop transmitting if CQ answered,split called, stn answers to someone else (can be set with checkbox chkStopTx)
  //here check if DblClickCall is set then if it exist in message: stop tx and clear DblClickCall
  //DblClickCall is set at doubleclick of monitor line event

  if (( DblClickCall <> '' ) and chkStopTx.Checked ) then  //stop requested
   if (pos(DblClickCall,Message)> 0) then  //and call is call answered
   Begin
     if LocalDbg then Writeln('Disabling TX, 2click call answered to someone else');
     RepBuf := frmNewQSO.RepHead;
     RepBuf[12] := #8; //Halt TX
     RepBuf := RepBuf +#0;
     frmNewQSO.Wsjtxsock.SendString(RepBuf);

     DblClickCall := '';
   end;

  btFtxtName.Visible := ((frmNewQSO.RepHead <> '') and (frmNewQSO.edtName.Text <> ''));
  if tbFollow.Checked and (trim(edtFollowCall.Text)='') then tbFollow.Checked:=false; //must have a call

  if (tbFollow.Checked and (pos(edtFollowCall.Text, Message) > 0)) then
    AddFollowedMessage(Message, Reply,Df,Sr)    //first check
 else
    if chkMap.Checked then
        begin
          if LocalDbg then
           Writeln('Other line:', Message);
          if  (pos('RR73',Message)= length(Message)-3)
           or (pos(' 73',Message)= length(Message)-2) then
              ClLine:='*'
           else
              ClLine:=')';
          msgTime := Time;
          Dfreq := Df;
          Snr := Sr;
          msgCall := '';
          msgLocator := '';
          isMyCall := False;
          index:=0;

          msgList := TStringList.Create;
          msgList.Delimiter := ' ';
          msgList.DelimitedText := Message;

          while index < msgList.Count do
          begin
            if index=0 then
              isMyCall := pos(msgList[index], UpperCase(cqrini.ReadString('Station', 'Call', ''))) > 0;
            if index=1 then
              msgCall := msgList[index];
            if index=2 then
              msgLocator := msgList[index]; //avoid out of index in certain compound call lines
            inc(index);
          end;
          msgList.Free;


          if LocalDbg then
            Writeln('Other call:', msgCall, '    loc:', msgLocator);
          //print only DX drops here
          if (chkDx.Checked) and (not dmUtils.IsHeDX(msgCall)) then exit;
          //print filter callsign drops here
          if chkFlt.Checked and (pos(edtFltMap.Text,msgCall)=0) then exit;
          if cqrini.ReadBool('MonWsjtx', 'FileFilter', False) and (FileFilter.IndexOf(msgCall)=-1) then exit;

          if (not frmWorkedGrids.GridOK(msgLocator)) or (msgLocator = 'RR73') then //disble false used "RR73" being a loc
                  msgLocator := '';

          if isItACall(msgCall) then
          begin
            myAlert := '';
            MonitorLine := '';
            AlertLine := '';

            //starts a row
            if (msgTime <> LastWsjtLineTime) then
               Begin
                     if LocalDbg then
                                 Writeln('---O msgtime is:', msgTime,'  LastWsjtlinetime is:',LastWsjtLineTime);
                    if chkdB.Checked then sgMonitor.Columns.Items[1].Visible:= true
                                       else sgMonitor.Columns.Items[1].Visible:= false;
                    clearSgMonitor;
                    CqPeriodTimerStart(msgTime, LastWsjtLineTime);
                  end;
            LastWsjtLineTime := msgTime;
            sgMonitor.InsertRowWithValues(sgMonitor.rowcount , [msgtime]);
            //Snr
            //X if chkdB.Checked then sgMonitor.Columns.Items[1].Visible:= true
            // else sgMonitor.Columns.Items[1].Visible:= false;
            sgMonitor.Cells[1, sgMonitor.rowCount-1]:= Format('%.2d',[Snr]);


            if LocalDbg then
               Writeln('Other: Add reply array:', sgMonitor.rowCount-1);
              sgMonitor.Cells[8, sgMonitor.rowCount-1]:= StrToHexStr(Reply);  //corresponding reply string to array in hex
            //start printing Map mode
            if LocalDbg then
              Writeln('Start Other printing, Map mode');
            AddColorStr('(', clBlack,2, sgMonitor.rowCount-1);//make in-qso indicator start
            PrintCall(msgcall);  //make not-CQ indicator start
            if msgLocator <> '' then
            begin
              PrintLoc(msgLocator, timeToAlert, msgTime);
              if frmWorkedGrids.GridOK(msgLocator) then  AddXplanetList(msgCall,msgLocator);
            end;
            adif:= dmDXCC.id_country(msgCall, Now(), pfx, msgRes);

            if cqrini.ReadBool('MonWsjtx', 'DxStatus', False) and (not ChkCbCq.Checked) then
                                           DxccStatus(adif,CurBand,CurMode,ClLine);


            //PCallColor closes parenthesis(not-CQ ind) with same color as it was opened with callsign
            AddColorStr(ClLine, clBlack,6,sgMonitor.rowCount-1);//make in-qso indicator stop

            //here
             if (chkUState.Checked) then

              case adif of
                6,9,103,110,166,202,285,291:
                                               Begin
                                                 StatClr :=clBlack;
                                                 msgRes := UsCallState(msgCall,StatClr);
                                                  if (StatClr<>clBlack)  then  //there is US state to print to Map
                                                     AddColorStr(msgRes, StatClr,7,sgMonitor.rowCount-1);
                                               end;
              end;
            scrollSgMonitor;
            if LocalDbg then
              Begin
               Writeln('All written in Addother. Next alerts');
               Writeln;
              end;
            TryAlerts;
          end;
          if chkMap.Checked and chkSort.Checked then
             Begin
                   sgMonitor.SortColRow(true,cqrini.ReadInteger('MonWsjtx', 'SortCol', 1),0,sgMonitor.RowCount-1);
                   ReColorsgMonitor(clBlack,clWhite,false);
             end;
        end;  //chkMap.Checked
  scrollSgMonitorToLastLine;
end;

procedure TfrmMonWsjtx.AddFollowedMessage(Message, Reply: string;Df,Sr:integer);
var
  msgList: TStringList;
begin
  if LocalDbg then writeln('Follow stage#1 passed:', Message);

  msgList:=TStringList.Create;
  msgList.Linebreak:=' '; // space delimiter
  msgList.Text:=Message;

  if (( msgList.Count < 2 ) and (pos(edtFollowCall.Text,msgList[0])>0))//1 items: Fcall exist: "OH1KH/IMAGE"
   or (( msgList.Count > 1 ) and (pos(edtFollowCall.Text,msgList[0])=0))//2 or more items and Fcall is not 1st
    or (( msgList.Count > 1 ) and (pos(edtFollowCall.Text,msgList[0])=1) //special call is 1st and second is
       and frmWorkedGrids.GridOK(msgList[1]) )                                         //locator like "F5MYK/MM OJ12"
     then
          begin
            edtFollow.Font.Color := clBlack;
            edtFollow.Text := IntToStr(Df)+' '+IntToStr(Sr)+' '+message;
            if (( msgList.Count > 1 ) and (pos(edtFollowCall.Text,msgList[1])>0)) then RepFlw := Reply;
               //only if Fcall is second, do reply
               //otherwise not sure to get right call for reply

            tmrFollow.Enabled := False;
            if CurMode = 'FT8' then tmrFollow.Interval := 16000 else tmrFollow.Interval := 61000;
            tmrFollow.Enabled := True;
          end;
  msgList.Free;
end;

procedure TfrmMonWsjtx.BufDebug(MyHeader,MyBuf:string);
var l,i,f: integer;
Begin
      l:=30;  //bytes per line
      Writeln(MyHeader);
      i:=1;
      repeat
       begin
        for f:=i to i+l do
             if f<=length(MyBuf) then Write('|', HexStr(Ord(MyBuf[f]), 2));
        writeln;
        for f:=i to i+l do
           Begin
             if f<=length(MyBuf) then
              if ((MyBuf[f] > #32) and (Mybuf[f]< #127)) then
                   write('| ',MyBuf[f]) else write('| _');
           end;
        writeln();
        writeln();
        i:=i+l;
       end;
      until ( i>= length(MyBuf) ) ;

end;

procedure TfrmMonWsjtx.ColorBack(Myitem:string;Mycolor:Tcolor;bkg:Boolean=false);
var r,g,b : char;
Begin     //"print" back to wsjt-x Band activity (color line there)
    r:=chr(Red(Mycolor));
    g:=chr(Green(Mycolor));
    b:=chr(Blue(Mycolor));
    RepBuf := frmNewQSO.RepHead
          +#0+#0+#0+chr(length(Myitem))+Myitem;
   if bkg then
    Begin
      //background when 2color loc is needed
      RepBuf := RepBuf
      +#1               // format spec
      +#255+#255        //alpha
      +#255+#255        //r
      +#245+#245        //g
      +#100+#100        //b
      +#0+#0;           //pad
    end
   else
    Begin
      //background       white
      RepBuf := RepBuf
      +#1             //format spec
      +#255+#255      //alpha
      +#255+#255      //r
      +#255+#255      //g
      +#255+#255      //b
      +#0+#0;         //pad
    end;

      //foreground
      RepBuf := RepBuf
      +#1             //format spec
      +#255+#255      //alpha
      +r+r
      +g+g
      +b+b
      +#0+#0          //pad

      +#1;           //highlight only last line

    RepBuf[12] := #13;
    frmNewQSO.Wsjtxsock.SendString(RepBuf);
end;

procedure TfrmMonWsjtx.PrintCall(Pcall: string;PCB:Boolean=false);
var    i:integer;

begin
  Pcall := trim(Pcall);
  RepBuf := Pcall;
  //We have plain callsign now for database search and coloback printing
  i:= frmWorkedGrids.WkdCall(Pcall, CurBand, CurMode);
  case i of
    0: Begin
        PCallColor :=wkdnever;
       end;
    1: Begin
        RepBuf := LowerCase(RepBuf);
        PCallColor :=wkdhere;
       end;
    2: Begin
        PCallColor :=wkdband;
       end;
    3: Begin
         PCallColor :=wkdany;
       end;
    else
      Begin
        PCallColor :=clBlack;
      end;
      //should not happen
  end;
 if LocalDbg then Writeln(' Callsign WB4 status is: ',i);

 if (chknoTxt.Checked or PCB) then    //returns color to wsjtx Band activity window needs upcase
        ColorBack(Pcall,PCallColor)
   else   AddColorStr(RepBuf, PCallColor,3,sgMonitor.rowCount-1);

   //if LocalDbg then BufDebug('color buffer contains:',RepBuf);
    {
    QColor
    Color spec (qint8)      1 (rgb)    * Highlight Callsign In   13                     quint32
    Alpha value (quint16)   255 0(opaq) *                         Id (unique key)        utf8
    Red value (quint16)                *                         Callsign               utf8
    Green value (quint16)              *                         Background Color       QColor
    Blue value (quint16)               *                         Foreground Color       QColor
    Pad value (quint16)       0        *                         Highlight last         bool
    }
end;

procedure TfrmMonWsjtx.PrintLoc(PLoc, tTa, mT: string;PCB:Boolean=false);
var L1,L2:String;     //locator main
       p :integer = 0;    //locator sub
Mycolor  :Tcolor = clBlack;     //color main. color sub sub is same, or else wkdnever
MyMcolor :Tcolor = clBlack;     //color main. color sub sub is same, or else wkdnever

Begin
  if (PLoc = '----') then
   begin
     p:=1;
     Mycolor := clBlack;
   end
  else
    if (PLoc = '*QSO') then
     begin
       p:=1;
       Mycolor := wkdnever;
     end
    else
     Begin
        L1:= UpperCase(copy(PLoc, 1, 2));
        L2:= copy(PLoc, 3, 2);
        case frmWorkedGrids.WkdGrid(PLoc, CurBand, CurMode) of
          //returns 0=not wkd
          //        1=full grid this band and mode
          //        2=full grid this band but NOT this mode
          //        3=full grid any other band/mode
          //        4=main grid this band and mode
          //        5=main grid this band but NOT this mode
          //        6=main grid any other band/mode
          0:Begin
              //not wkd
              p:=1;
              Mycolor := wkdnever;
              if tbLocAlert.Checked and (tTa <> mT) then
              myAlert := 'loc';    //locator alert
            end;
          1:Begin
              //grid wkd        PrintLoc
              p:=1;
              L1:= lowerCase(L1);
              Mycolor := wkdhere;
            end;
          2:Begin
              //grid wkd band
              p:=1;
              Mycolor := wkdband;
            end;
          3:Begin
              //grid wkd any
              p:=1;
              Mycolor := wkdany;
            end;
          4:Begin
              //maingrid wkd
              p:=2;
              L1:= lowerCase(L1);
              Mycolor := wkdhere;
             end;
          5:Begin
              //maingrid wkd band
              p:=2;
              Mycolor := wkdband;
            end;
          6:Begin
              //maingrid wkd any
              p:=2;
              Mycolor := wkdany;
            end;
          else
            Begin
              L1:= lowerCase(L1);//should not happen
              p:=1;
              Mycolor := clBlack;
            end;
        end; //case
     end; // ----  *QSO

  if  (chknoTxt.Checked or PCB) then
       begin
        if p=1 then ColorBack(L1+L2,Mycolor)
          else ColorBack(UpperCase(L1+L2),Mycolor,True);
       end
   else
       begin
        case frmWorkedGrids.WkdMainGrid(PLoc, CurBand, CurMode) of
          //returns 0=not wkd
          //        1=main grid this band and mode
          //        2=main grid this band but NOT this mode
          //        3=main grid any other band/mode
          0:Begin
              //not wkd
              MyMcolor := wkdnever;
            end;
          1:Begin
              //grid wkd        PrintLoc
              L1:= lowerCase(L1);
              MyMcolor := wkdhere;
            end;
          2:Begin
              //grid wkd band
              MyMcolor := wkdband;
            end;
          3:Begin
              //grid wkd any
              MyMcolor := wkdany;
            end;
          else
            Begin
              L1:= lowerCase(L1);//should not happen
              p:=1;
              MyMcolor := clBlack;
            end;
        end; //case
        AddColorStr(L1, MyMcolor,4,sgMonitor.rowCount-1);

        if p=1 then AddColorStr(L2, Mycolor,5,sgMonitor.rowCount-1)
         else AddColorStr(L2, wkdnever,5,sgMonitor.rowCount-1);
       end;
end;
function TfrmMonWsjtx.isItACall(Call: string): boolean;

var
  i      : integer;
  HasNum,
  HasChr : boolean;

begin
  HasNum := False;
  HasChr := False;

  // remove spaces, convert upcase. Just for sure (should not need that);
  Call:=Upcase(trim(Call));

  //returns false if empty call or shorter than 3
  if (length(Call) < 3) then exit(false);

  // check numbers at beginning
  If (
       (
         (length(Call) = 3) and
         (Call[1] in ['0'..'9'])
       )
       or
       (
         (length(Call) > 3) and
         (Call[1] in ['0'..'9']) and
         (Call[2] in ['0'..'9'])
       )
      ) then exit(false);

  // check if it is a small locator with 4 digits format AA00, RR73 or report R+00, R-00
    If (
         (Call.length = 4) and
         (Call[1] in ['A'..'R']) and
          (
           (Call[2] in ['A'..'R']) or
           (Call[2] in ['+','-'])
          ) and
         (Call[3] in ['0'..'9']) and
         (Call[4] in ['0'..'9'])
       ) then exit(false);

  //call must end with letter unless it has '/' at the suffix side of compound call
  If (
         (Call[length(Call)] in ['0'..'9']) and
          (
            (
              (pos('/',Call)<5) and
              (length(Call)>7)
             )
             or
            (
              (pos('/',Call)<4) and
              (length(Call)<8)
             )
           )
      ) then exit(false);

  //special case kh6/k1a variations k1a/kh6 kh6/kh6  k1a/k1a
  if (
        (
         (length(Call)=7) and
         (pos('/',Call)=4)
        )
      and
       not
        (
          (isItACall(ExtractWord(1,Call,['/']))) xor
          (isItACall(ExtractWord(2,Call,['/'])))
        )
      ) then exit(false);

  // Call has letters and numbers and does not have special charcters
  for i:= 1 to length(Call) do
      begin
        if (Call[i] in ['0'..'9']) then HasNum := True;
        if (Call[i] in ['A'..'Z']) then HasChr := True;
        if Call[i] in ['+','.','?'] then exit(false);
      end;
   if not (HasNum and HasChr) then exit(false);

  // if pased this far
  exit(true);
end;
procedure TfrmMonWsjtx.TryCallAlert(S: string);

begin
  //if no asterisk, compare as is
  if ((pos('*', S) = 0) and (pos(S, msgCALL) > 0)) then
  begin
    if LocalDbg then
      Write('Text-', S, '-');
    myAlert := 'call'; // overrides locator
  end
  else
  begin     //has asterisk
    //if starts with asterisk remove it and compare right side
    if (LeftStr(S, 1) = '*') then
    begin
      if LocalDbg then
        Write('Right-', S, '-');
      S := copy(S, 2, length(S) - 1);         //asterisk removed, then compare
      if (S = RightStr(msgCall, (length(S)))) then
        myAlert := 'call'; // overrides locator
    end
    else
    begin
      //if ends with asterisk remove it and compare left side
      if (RightStr(S, 1) = '*') then
        S := copy(S, 1, length(S) - 1);  //asterisk removed, then compare
      if (S = LeftStr(msgCall, length(S))) then
        myAlert := 'call'; // overrides locator
      if LocalDbg then
        Write('Left-', S, '-');
    end;
  end;
  if LocalDbg then
    Writeln('compare with:', S, ':results:', myAlert);
end;

procedure TfrmMonWsjtx.TryAlerts;
var
  a: TExplodeArray;
  i: integer;
begin
  if tbAlert.Checked then
  begin
    if tbTCAlert.Checked then
    begin
      if (EditedText <> '') then
      begin
        if LocalDbg then
          Writeln('Alert text search');
        if (pos(Sdelim, EditedText) > 0) then //many variants
        begin
          SetLength(a, 0);
          a := dmUtils.Explode(',', EditedText);
          for i := 0 to Length(a) - 1 do
          begin
            a[i] := trim(a[i]);
            if LocalDbg then
              Writeln('Split text search >', Sfull, '[', i, ']=', a[i]);
            TryCallAlert(a[i]);
          end;
        end
        else
          TryCallAlert(EditedText);
      end;
    end
    else if ((EditedText <> '') and (pos(EditedText, MonitorLine) > 0)) then
      myAlert := 'text'; // overrides locator
  end; // tbAlert
  if (tbmyAlrt.Checked and isMyCall) then
    myAlert := 'my'; //overrides anything else

  if (myAlert <> '') and (timeToAlert <> msgTime) then
  begin
    timeToAlert := msgTime;
    RunVA(myAlert); //play bash script
  end;
end;

procedure TfrmMonWsjtx.AddMyCallMessage(Time,mode,WsjtxBand,Message,Reply:string; Df,Sr:integer);
var
   Fox73    : boolean;
begin
     AlertLine:='';
     if LocalDbg then Writeln('Start AddMyCallMessage');
     isMyCall:= true;
     Dfreq:=Df;
     Snr :=Sr;
     RepBuf := Reply;
     msgTime:=Time;
     msgMode := mode;
     CurMode:=getCurMode(mode);
     Message:=LineFilter(Message);
     msgCall := ExtractWord(2,Message,[' ']);
     msgLocator := ExtractWord(3,Message,[' ']);
     CqDir := ''; // Must be reseted here, otherwise will print old CQ DIR from previous decoded line

     Fox73 := ((msgCall = 'RR73') and (msgLocator =''));

     if LocalDbg then  Writeln('caller:', msgCall, '  loc:', msgLocator);
     if (not frmWorkedGrids.GridOK(msgLocator)) or (msgLocator = 'RR73') then //disble false used "RR73" being a loc
            msgLocator := '*QSO'; //if not real loc it is report, RRR, or 73

     if Fox73 then
       Begin
          if LocalDbg then Writeln('Fox said 73, log qso!');
          msgCall:= 'LOG';
          msgLocator := '*QSO';
       end;

     if (IsItACall(msgCall) or Fox73 ) then
         Begin
            if (chknoHistory.Checked or chkMap.Checked) and
                     (msgTime <> LastWsjtLineTime) then
                  Begin
                     if LocalDbg then
                                 Writeln('Msgtime is:', msgTime,'  LastWsjtlinetime is:',LastWsjtLineTime);
                    clearSgMonitor;
                    CqPeriodTimerStart(msgTime, LastWsjtLineTime);
                  end;

            LastWsjtLineTime := msgTime;
            PrintDecodedMessage;
            if LocalDbg then
              Begin
               Writeln('All written in AddMy. Next alerts');
               Writeln;
              end;
            if tbmyAll.Checked then TryAlerts
             else
               if ( msgLocator <> '*QSO')  then TryAlerts;
         end;
end;

procedure TfrmMonWsjtx.AddCqCallMessage(Time,mode,WsjtxBand,Message,Reply:string; Df,Sr:integer);
//procedure TfrmMonWsjtx.AddDecodedMessage(Message, band, Reply: string; Dfreq,Snr: integer);
var
  i, index: integer;
  msgList : TStringList;

  isCallCqDir,            //CQ caller calling directed call
  HasNum, HasChr: boolean;

begin

  if LocalDbg then Writeln('Start AddCQCallMessage');
   isMyCall:= false;
   Dfreq:=Df;
   Snr :=Sr;
   RepBuf := Reply;
   msgTime:=Time;
   msgMode := mode;
   CurMode:=getCurMode(mode);
   Message:=LineFilter(Message);
   UsedBkgCqCol:= BkgCqCol;

  btFtxtName.Visible := ((frmNewQSO.RepHead <> '') and (frmNewQSO.edtName.Text <> ''));

  mycont := '';
  cont := '';
  country := '';
  waz := '';
  posun := '';
  itu := '';
  lat := '';
  long := '';

  myAlert := '';
  MonitorLine := '';
  AlertLine:='';

  dxcc_number_adif := dmDXCC.id_country(
    UpperCase(cqrini.ReadString('Station', 'Call', '')), '', Now(), pfx,
    mycont, country, WAZ, posun, ITU, lat, long);

  index:=0;
  msgList:=TStringList.Create;
  msgList.Linebreak:=' '; // space delimiter
  msgList.Text:=Message;

  msgCall:='NOCALL';     // call of the received station
  msgLocator:='----';    // locator of the received station
  CqDir := '';           // only filled when received station is CQ DX or CQ continent/regionDX with the label of continent or region (DX, EU, OC, AS, etc)

  // msgList[0] should alway be 'CQ'

  // messages with less then 2 and more then 4 entries should not happen
  // and will be ignored
  if (msgList.count >= 2) and (msgList.count <= 4) then begin
    while index < msgList.count do
    begin
      // index 0 = CQ

      // identify if its a call or a DX/continent/region
      // if its not a call and not a 2 length string, it will be ignored
      if index = 1 then
      begin
        if isItACall(msgList[index]) then
          msgCall:=msgList[index]
        else if msgList[index].Length < 5 then //extensions 4chr and below with wsjt-x v2.0
          CqDir:=msgList[index];
      end;

      // identify if its a call, a DX (old style) or a Locator
      // if its match to nothing it will be ignored
      if index = 2 then
      begin
        if msgList[index] = 'DX' then
          CqDir:='DX'
        else if frmWorkedGrids.GridOK(msgList[index]) AND (msgList[index] <> 'RR73') then
          msgLocator:=msgList[index]
        else if isItACall(msgList[index]) then
          msgCall:=msgList[index]
      end;

      // identify if its a call or a Locator
      // if its match to nothing it will be ignored
      if index = 3 then
      begin
        if frmWorkedGrids.GridOK(msgList[index]) AND (msgList[index] <> 'RR73') then
          msgLocator:=msgList[index]
        else if isItACall(msgList[index]) then
          msgCall:=msgList[index]
      end;
      inc(index);
    end;
    msgList.Free;
  end;

  // collecting content for variables msgTime, msgMode, msgCall, msgLocator, CqDir is done
  // now starts the filling and prepartion of the new column in wsjtx monitor

  if (CurMode <> '') AND (msgCall <> 'NOCALL') then //mode and call is known; we can continue
  begin
    //print only DX drops here
    if (chkDx.Checked) and (not dmUtils.IsHeDX(msgCall)) then
       Begin
         UsedBkgCqCol :=clWhite;
         exit;
       end;
    //print filter callsign drops here
    if chkMap.Checked then
     Begin
       if ( (chkFlt.Checked and (pos(edtFltMap.Text,msgCall)=0))
        or (cqrini.ReadBool('MonWsjtx', 'FileFilter', False) and (FileFilter.IndexOf(msgCall)=-1)) ) then
           Begin
             UsedBkgCqCol :=clWhite;
             exit;
           end;
     end;

    if LocalDbg then
      Writeln('LOCATOR IS:', msgLocator);

    if (chknoHistory.Checked or chkMap.Checked) and
        (msgTime <> LastWsjtLineTime) then
            Begin
               if LocalDbg then
                           Writeln('Msgtime is:', msgTime,'  LastWsjtlinetime is:',LastWsjtLineTime);
              clearSgMonitor;
              CqPeriodTimerStart(msgTime, LastWsjtLineTime);
            end;

      LastWsjtLineTime := msgTime;
      RepBuf := Reply;
      PrintDecodedMessage;
      if LocalDbg then
        Begin
         Writeln('All written in AddCq. Next alerts');
         Writeln;
        end;
      TryAlerts;

  end;  //continued
  scrollSgMonitorToLastLine;
end;
procedure TfrmMonWsjtx.PrintDecodedMessage;
Var
   i      : integer;
  freq,le,
  tmp     : string;
StatClr   : Tcolor;

begin
  cont := '';
  country := '';
  waz := '';
  posun := '';
  itu := '';
  lat := '';
  long := '';
   //++++++++++++++++++++++++++++start printing++++++++++++++++++++++++++++++++
   if LocalDbg then
     Writeln('Start adding monitor lines');
   CqState:='';

   if (not ChkCbCq.Checked) and (not chknoTxt.Checked) then      //was chkmap
    begin
     if (chknoHistory.Checked)  then
      Begin
       //sgMonitor.InsertRowWithValues(sgMonitor.rowcount , [PadLeft(IntToStr(Dfreq), 4), PadLeft(IntToStr(Snr),3)]);
         sgMonitor.InsertRowWithValues(sgMonitor.rowcount , [Format('%4d',[Dfreq]), Format('%.2d',[Snr])]);
      end
     else
      Begin
       //time + mode;
       sgMonitor.InsertRowWithValues(sgMonitor.rowcount , [msgTime, msgMode]);
      end;
    end;

   //Reply added here as sgMonitor row is now created
   if (not chkCbCQ.Checked) and (not chknoTxt.Checked) then
    Begin
     sgMonitor.Cells[8, sgMonitor.rowCount-1]:= StrToHexStr(RepBuf);  //corresponding reply string to array in hex
     if LocalDbg then
      Writeln('Decode Add reply array:', sgMonitor.rowCount-1,'len:',length(RepBuf),':',length(sgMonitor.Cells[8, sgMonitor.rowCount-1]));
    end;

   if isMyCall then
     begin
      DblClickCall := '';
      if LocalDbg then  Writeln('Reset 2click call: answered to me');
      PrintCall(msgCall,chkCbCQ.Checked);
      if not chkCbCQ.Checked then AddColorStr('=', PcallColor,2 ,sgMonitor.rowCount-1);
     end
   else
       PrintCall(msgCall,chkCbCQ.Checked);
   
   le:='';
   if cqrini.ReadBool('wsjt', 'chkLoTWeQSL', False) then
    Begin
      le:='   ';
      if dmData.UsesLotw(msgCall) then le[1]:='L';
      if dmData.UseseQSL(msgCall) then le[2]:='E';
    end;

   PrintLoc(msgLocator, timeToAlert, msgTime,chkCbCQ.Checked);
   if frmWorkedGrids.GridOK(msgLocator) then AddXplanetList(msgCall,msgLocator);

     dxcc_number_adif := dmDXCC.id_country(msgCall, '', Now(), pfx, cont,
       msgRes, WAZ, posun, ITU, lat, long);
     if (pos(',', msgRes)) > 0 then
       msgRes := copy(msgRes, 1, pos(',', msgRes) - 1);
     //case of USA print it only. Forget state. It is not shown full and may be false
     StatClr :=clBlack;
     if pos('USA',upcase(msgRes))=1 then
        Begin
           if chkUState.Checked then
              msgRes := 'USA '+UsCallState(msgCall,StatClr)
            else
              msgRes := 'USA';
          end;

     //exception to USA is Hawaii that is also US state, but call may also be in mainland
      if pos('HAWAII',upcase(msgRes))=1  then
       begin
         if chkUState.Checked then
          begin
           if upcase(UsCallState(msgCall,StatClr))='HI' then
            Begin
             if chkMap.Checked then
                 msgRes := 'HAW '+UsCallState(msgCall,StatClr)
                else
                 msgRes := 'Hawaii '+UsCallState(msgCall,StatClr);
            end
           else
            if upcase(UsCallState(msgCall,StatClr))<>'' then
              msgRes := 'USA '+UsCallState(msgCall,StatClr)
          end;
         end;

      if chkMap.Checked then
       Begin
         if  (StatClr<>clBlack)  then  //there is US state to print to Map
           Begin
            CqState:= copy(msgRes,5,2);
             AddColorStr(CqState, StatClr,7,sgMonitor.rowCount-1);
           end;

         if cqrini.ReadBool('MonWsjtx', 'DxStatus', False) and (not ChkCbCq.Checked)   then
           Begin
            tmp:=' ';
            DxccStatus(dxcc_number_adif,CurBand,CurMode,tmp);
            AddColorStr(tmp,clBlack,6,sgMonitor.rowCount-1);
           end;

       end;
     if LocalDbg then
       Writeln('My continent is:', mycont, '  His continent is:', cont);

      if CqDir <> '' then
       begin
             if ((mycont <> '') and (cont <> '')) then
                 //we can do some comparisons of continents
               begin
               if not dmUtils.IsHeDx(msgCall,CqDir) then
                 //I'm not DX for caller: color to warn directed call
                 //CQ NOT directed to my continent: color to warn directed call
                 extcqprint;
               end
             else  // should be ok to answer this directed cq
              begin
               if ((not chkMap.Checked) and (not chkCbCQ.Checked))  then
                begin
                 //AddColorStr(' ' + copy(PadRight(msgRes, CountryLen), 1, CountryLen) + ' ', StatClr,6, sgMonitor.rowCount-1);
                 //space prefix is for what? forgot that
                 //AddColorStr(copy(PadRight(msgRes, CountryLen), 1, CountryLen) + ' ', StatClr,6, sgMonitor.rowCount-1);

                 AddColorStr(' ' + copy(PadRight(msgRes, CountryLen), 1, CountryLen) + ' ', clBlack,6, sgMonitor.rowCount-1)
                end
               else
                begin
                 // we can not compare continents, but it is directed cq. Best to warn with color anyway
                 extcqprint;
                end
              end
      end
     else    // CqDir <> ''
      begin
       // should be ok to answer this is not directed cq
         if ((not chkMap.Checked) and (not chkCbCQ.Checked))  then
             Begin
              AddColorStr(copy(PadRight(msgRes, CountryLen), 1, CountryLen)+' ', StatClr,6, sgMonitor.rowCount-1);
             end;
      end;


   if (not chkMap.Checked) then
    begin
     freq := dmUtils.FreqFromBand(CurBand, CurMode);
     msgRes := StringReplace(dmDXCC.DXCCInfo(dxcc_number_adif, freq, CurMode, i),'!','',[rfReplaceAll]);    //wkd info

     if LocalDbg then
       Writeln('Looking this>', msgRes[1], '< from:', msgRes);
     case msgRes[1] of
       'U': AddColorStr(le+cont + ':' + msgRes, wkdhere,7 ,sgMonitor.rowCount-1);       //Unknown
       'C': AddColorStr(le+cont + ':' + msgRes, wkdAny,7 ,sgMonitor.rowCount-1);        //Confirmed
       'Q': AddColorStr(le+cont + ':' + msgRes, clTeal,7 ,sgMonitor.rowCount-1);        //Qsl needed
       'N': AddColorStr(le+cont + ':' + msgRes, wkdnever,7 ,sgMonitor.rowCount-1);      //New something

       else
         AddColorStr(msgRes, clBlack,7 ,sgMonitor.rowCount-1);     //something else...can't be
     end;
    end //not Map mode
   else
      if chkMap.Checked and chkSort.Checked  then
             Begin
                   sgMonitor.SortColRow(true,cqrini.ReadInteger('MonWsjtx', 'SortCol', 1),0,sgMonitor.RowCount-1);
                   ReColorsgMonitor(clBlack,clWhite,false);
             end;

   if not (chkCbCQ.Checked or chknoTxt.Checked) then
     Begin
        scrollSgMonitor; // if needed
        //sgMonitor.AutoSizeColumns;
     end;

 end;//printing out  line
procedure TfrmMonWsjtx.extcqprint;
  begin
    if (chknoTxt.Checked or chkCbCQ.Checked) then ColorBack('CQ '+CqDir, extCqCall)
    else
    Begin
      if CqDir='' then exit;
      if not  chkMap.Checked then
        Begin
          AddColorStr(copy(PadRight(msgRes, CountryLen), 1, CountryLen - 6)+' CQ:'+CqDir, extCqCall,6,sgMonitor.rowCount-1);
        end
       else
        Begin
         if CqState<>'' then
            AddColorStr(CqState+' >'+CqDir,extCqCall,7,sgMonitor.rowCount-1)
          else
            AddColorStr('>'+CqDir, extCqCall,7,sgMonitor.rowCount-1)
        end;
    end;
  end;

function TfrmMonWsjtx.getCurMode(sMode: String): String;
  // function getCurMode converts a wsjtx binary mode in human readable ham mode
  begin
    getCurMode:='';
    case sMode of
      chr(36) : getCurMode := 'JT4';
      '#'     : getCurMode := 'JT65';
      '@'     : getCurMode := 'JT9';
      '&'     : getCurMode := 'MSK144';
      ':'     : if frmNewQSO.RemoteName= 'WSJT-X' then
                          getCurMode:='QRA64'
                       else
                          getCurMode:='FT4';
      '+'     : if frmNewQSO.RemoteName= 'WSJT-X' then
                          getCurMode:='FT4'
                       else
                          getCurMode:='T10';
      'FT4' : getCurMode := 'FT4'; // For MSHV added by LB2EG nov 7th 2021
      chr(126): getCurMode := 'FT8';    // ~
      'FT8' : getCurMode := 'FT8'; // For MSHV added by LB2EG nov 7th 2021
      chr(96) : getCurMode := 'FST4';   // `
    end;
  end;
function TfrmMonWsjtx.UsCallState(call:string;var StatClr:TColor):string;
var
   us:integer;
   Stat:string;
begin

  Result:='';
  if CanCloseUSDBProcess then   //there is no database update going on
   Begin
     try
      if dmData.trQstate.Active then dmData.trQstate.Rollback;
      dmData.trQstate.StartTransaction;
      dmData.Qstate.SQL.Text := 'select call_state from cqrlog_common.states where callsign='+QuotedStr(call);
      if LocalDbg then  Writeln(dmData.Qstate.SQL.Text);
      dmData.Qstate.open;
      Stat:= dmData.Qstate.FieldByName('call_state').AsString;
      dmData.trQstate.Rollback;
      dmData.Qstate.Close;


     if Stat <>''  then
       begin
        us := frmWorkedGrids.WkdState(Stat,Curband, Curmode);
         case us of
              0: Begin
                  StatClr :=wkdnever;
                 end;
              1: Begin
                  Stat := LowerCase(Stat);
                  StatClr :=wkdhere;
                 end;
              2: Begin
                  StatClr :=wkdband;
                 end;
              3: Begin
                   StatClr :=wkdany;
                 end;
              else
                Begin
                  StatClr :=clBlack;
                end;
                //should not happen
            end;

        if LocalDbg then Writeln(' State WB4 status is: ',us);
        Result:=Stat;
       end
    finally
    end;
   end;
end;

Procedure  TfrmMonWsjtx.ReColorsgMonitor(Fc,Bc:tColor;Boff:Boolean);
var
  i, j : integer;
begin
  for i:= 0 to 7 do
  begin
       for j:=0 to MaxLinesSgMonitor do
       begin
          sgMonitorAttributes[i,j].FG_Color:=Fc;
          sgMonitorAttributes[i,j].BG_Color:=Bc;
          if Boff then
                  sgMonitorAttributes[i,j].isBold:=false;
       end;
  end;
  sgMonitor.Repaint;
end;
Procedure TfrmMonWsjtx.DxccStatus(adif:word;CB,Cm:String;var R:String);    //used in map mode
var
  index : integer = 0;

Begin
        dmData.RbnMonDXCCInfo(adif,CB,CM,True,index);
        case index of
          1 : R:= R+'n'; //new country
          2 : R:= R+'b'; //new band
          3 : R:= R+'m'; //new mode
          4 : R:= R+'q'; //qsl needed
        end;
end;



//initialization

end.
