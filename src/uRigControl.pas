unit uRigControl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Process, ExtCtrls, lNetComponents, lnet, Forms, strutils;

type TRigMode =  record
    mode : String[10];
    pass : integer;   //this can not be word as rigctld uses "-1"="keep as is" IntToStr gives 65535 for word with -1
    raw  : String[10];
end;

type TVFO = (VFOA,VFOB);


type
  TExplodeArray = Array of String;

type TRigControl = class
    RigctldConnect : TLTCPComponent;
    rigProcess     : TProcess;
    tmrRigPoll     : TTimer;
  private
    fRigCtldPath   : String;
    fRigCtldArgs   : String;
    fRunRigCtld    : Boolean;
    fMode          : TRigMode;
    fFreq          : Double;
    fSFreq         : Double;
    fRigPoll       : Word;
    fRigCtldPort   : Word;
    fLastError     : String;
    fRigId         : Word;
    fRigDevice     : String;
    fDebugMode     : Boolean;
    fRigCtldHost   : String;
    fVFO           : TVFO;
    RigCommand     : TStringList;
    fRigSendCWR    : Boolean;
    fRigChkVfo     : Boolean;
    fRXOffset      : Double;
    fTXOffset      : Double;
    fMorse         : boolean;
    fPower         : boolean;
    fPowerON	    : boolean;
    fGetVfo         : boolean;
    fCompoundPoll   : Boolean;
    fVoice          : Boolean;
    fIsNewHamlib    : Boolean;
    fGetSplitTX     : Boolean;
    fRigSplitActive : Boolean;
    fPollTimeout    : integer;
    fPollCount      : integer;
    fPwrPcnt        : String;   //not actually %, but value 0.0 .. 1.0
    fPwrmW          : String;
    fRfPwrMtrWtts   : String;
    fMemRfPwrMtrWtts: String;   //last TX value of meter.
    fGetRFPower     : boolean;
    fMemGetRFP      : boolean;
    fSetRFPower     : boolean;
    fMemSetRFP      : boolean;
    fSetFunc        : boolean; //if can set/get func then test "U currVFO ?" supported functions "fSupFuncs"
    fGetFunc        : boolean;
    fSetLevel       : boolean;
    fGetLevel       : boolean;
    fSupSetLevels   : String;
    fSupSetFuncs    : String;
    fSupGetLevels   : String;
    fSupGetFuncs    : String;
    fPtt            : String;
    fResponseTimeout: Boolean;
    AllowCommand    : integer; //for command priority
    ErrorRigctldConnect : Boolean;
    ConnectionDone  : Boolean;
    PowerOffIssued  : Boolean;

    RigCmdChannelBusy : Boolean;
    RigCmdChannelMsg  : String;


    function  RigConnected   : Boolean;
    function  StartRigctld   : Boolean;
    function  Explode(const cSeparator, vString: String): TExplodeArray;
    function  SendPoll(msg:string):boolean;

    //Connect is for rig initate and fmv polling
    procedure OnReceivedRigctldConnect(aSocket: TLSocket);
    procedure OnConnectRigctldConnect(aSocket: TLSocket);
    procedure OnErrorRigctldConnect(const msg: string; aSocket: TLSocket);
    procedure OnRigPollTimer(Sender: TObject);

    procedure HamlibErrors(e:string);

public

    ParmVfoChkd : Boolean;
    ParmHasVfo  : integer;
    VfoStr      : String;
    InitDone    : Boolean;

    constructor Create;
    destructor  Destroy; override;

    property DebugMode   : Boolean read fDebugMode write fDebugMode;

    property RigCtldPath : String  read fRigCtldPath write fRigCtldPath;     //path to rigctld binary
    property RigCtldArgs : String  read fRigCtldArgs write fRigCtldArgs;     //rigctld command line arguments
    property RunRigCtld  : Boolean read fRunRigCtld  write fRunRigCtld;      //run rigctld command before connection
    property RigId       : Word    read fRigId       write fRigId;           //hamlib rig id
    property RigDevice   : String  read fRigDevice   write fRigDevice;       //port where is rig connected
    property RigCtldPort : Word    read fRigCtldPort write fRigCtldPort;     // port where rigctld is listening to connecions, default 4532
    property RigCtldHost : String  read fRigCtldHost write fRigCtldHost;     //host where is rigctld running
    property Connected   : Boolean read RigConnected;                        //connect rigctld
    property RigPoll     : Word    read fRigPoll     write fRigPoll;         //poll rate in milliseconds
    property RigSendCWR  : Boolean read fRigSendCWR    write fRigSendCWR;    //send CWR instead of CW
    property RigChkVfo  : Boolean read fRigChkVfo    write fRigChkVfo;       //test if rigctld "--vfo" start parameter is used
    property Morse      : Boolean read fMorse;                               //can rig send CW
    property Voice      : Boolean read fVoice;                               //can rig launch voice memories
    property IsNewHamlib: Boolean read fIsNewHamlib;                         //Is Hamlib version date higer than 2023-06-01
                                                                             //not used internally, but can give info out
    property Power      : Boolean read fPower;                               //can rig switch power
    property PowerON      : Boolean write fPowerON;                          //may rig switch power on at start
    property CanGetVfo  : Boolean read fGetVfo;                              //can rig show vfo (many Icoms can not)
    property LastError   : String  read fLastError;                          //last error during operation
    property RXOffset : Double read fRXOffset write fRXOffset;               //RX offset for transvertor in MHz
    property TXOffset : Double read fTXOffset write fTXOffset;               //TX offset for transvertor in MHz
    property GetSplitTX : Boolean read fGetSplitTX write  fGetSplitTX;       //TX freq from split vfo
    property RigSplitActive : Boolean read fRigSplitActive;

    property GetRFPower: boolean read fGetRFPower  write fGetRFPower;        //Can get RFpower
    property SetRFPower: boolean read fSetRFPower  write fSetRFPower;        //Can set RFpower
    property MemGetRFP: boolean read fMemGetRFP;                             //Memory what rig said
    property MemSetRFP: boolean read fMemSetRFP;                             //Memory what rig said
    property RfPwrMtrWtts : String read fRfPwrMtrWtts;
    property MemRfPwrMtrWtts : String read fMemRfPwrMtrWtts;                    //last TX value of meter.

    property SetFunc   : boolean read fSetFunc;                              //Can set
    property GetFunc   : boolean read fGetFunc;                              //can get functions
    property SupSetFuncs  : String read fSupSetFuncs;                        //list of supported functions set
    property SupGetFuncs  : String read fSupGetFuncs;                        //list of supported functions set
    property SetLevel  : boolean read fSetLevel;                             //Can set
    property GetLevel  : boolean read fGetLevel;                             //can get Levels
    property SupSetLevels : String read fSupSetLevels;                       //list of supported Levels set
    property SupGetLevels : String read fSupGetLevels;                       //list of supported Levels get
    property Ptt          : String read fPtt;                                //PTT state;

    property PwrPcnt :  String read fPwrPcnt write fPwrPcnt;                 //Set/Get the amount of Power level in %
    property PwrmW   :  String read fPwrmW   write fPwrmW;                   //Mode-band related milliWatts for  Power level in %

    property ResponseTimeout : Boolean read fResponseTimeout;
    property CompoundPoll : Boolean read fCompoundPoll  write  fCompoundPoll;//Char to use between compound commands.
                                                                             //Default is space, can be also LineEnding that breaks compound
    property PollTimeout  : integer read fPollTimeout write fPolltimeout;    //Poll timeout in poll rounds (PollTimeout X RigPoll = timeout in milliseconds)

    function  GetCurrVFO  : TVFO;
    function  GetModePass : TRigMode;
    function  GetPassOnly : word;
    function  GetModeOnly : String;
    function  GetFreqHz   : Double;
    function  GetFreqKHz  : Double;
    function  GetFreqMHz  : Double;
    function  GetSplitTXFreqMHz  : Double;
    function  GetModePass(vfo : TVFO) : TRigMode;  overload;
    function  GetModeOnly(vfo : TVFO) : String; overload;
    function  GetFreqHz(vfo : TVFO)   : Double; overload;
    function  GetFreqKHz(vfo : TVFO)  : Double; overload;
    function  GetFreqMHz(vfo : TVFO)  : Double; overload;
    function  GetRawMode : String;
    function  GetPowerPercent: integer;
    function  GetPowermW : integer;

    procedure SetCurrVFO(vfo : TVFO);
    procedure SetModePass(mode : TRigMode);
    procedure SetFreqKHz(freq : Double);
    procedure SetSplit(up:integer);
    procedure DisableSplit;  //this is disable XIT
    procedure ClearXit;
    procedure ClearRit;
    procedure DisableRit;
    procedure Restart;
    procedure PwrOn;
    procedure PwrOff;
    procedure PwrStBy;
    procedure PttOn;
    procedure PttOff;
    procedure SendVoice(VMem:String);
    procedure StopVoice;
    procedure UsrCmd(cmd:String);
    procedure SetPowerPercent(p:integer);
    procedure SetTuner;
    procedure ReSetTuner;
end;

implementation

constructor TRigControl.Create;
begin
  RigCommand           := TStringList.Create;
  RigCommand.Sorted    :=False;
  fDebugMode           := False;
  if fDebugMode then Writeln('In create');
  fRigCtldHost         := 'localhost';
  fRigCtldPort         := 4532;
  fRigPoll             := 500;   //Check relationship to fPollTimeout
  fRunRigCtld          := True;
  RigctldConnect       := TLTCPComponent.Create(nil);
  rigProcess           := TProcess.Create(nil);
  tmrRigPoll           := TTimer.Create(nil);
  tmrRigPoll.Enabled   := False;
  VfoStr               := ''; //defaults to non-"--vfo" (legacy) mode
  fPowerON             := true;  //we do this via rigctld startup parameter autopower_on
  fGetVfo              := true;   //defaut these true
  fMorse               := true;
  fVoice               := false;
  fIsNewHamlib         := false;
  fGetSplitTX          := false;  //poll rig polls also split TX vfo
  PowerOffIssued       := false;
  fCompoundPoll        := True;
  fPollTimeout         := 15;  //max count of false responses when polled. Set_power ON is critical. Must be big enough to allow rig wake up.
  fPollCount           := fPollTimeout;
  fRigSplitActive      := False;
  fGetRFPower          := false;
  fSetRFPower          := false;
  fGetFunc             := false;
  fSetFunc             := false;
  fSupSetFuncs         := '';
  fSupGetFuncs         := '';
  fSupSetLevels        := '';
  fSupGetLevels        := '';
  fRfPwrMtrWtts        := '';
  fMemRfPwrMtrWtts     := '0';
  fPtt                 := '';
  tmrRigPoll.OnTimer       := @OnRigPollTimer;
  RigctldConnect.OnReceive := @OnReceivedRigctldConnect;
  RigctldConnect.OnConnect := @OnConnectRigctldConnect;
  RigctldConnect.OnError   := @OnErrorRigctldConnect;
end;

function TRigControl.StartRigctld : Boolean;
var
   index     : integer;
   paramList : TStringList;
begin

  if fDebugMode then Writeln('Starting RigCtld ...');

  rigProcess.Executable := fRigCtldPath;
  index:=0;
  paramList := TStringList.Create;
  paramList.Delimiter := ' ';
  if pos('AUTO_POWER',UpperCase(RigCtldArgs))=0 then
   if (RigId>10) then  //only true rigs can do auto_power_on
    begin
    if fPowerON then RigCtldArgs:= RigCtldArgs+' -C auto_power_on=1';
          //2023-08-02 auto_power on is not any more default "1" and it should stay so (by W9MDB)
          //so we need just set it "1" if user wants, otherwise no parameter added. This should help old Hamlibs
          //that claim auto_power is wrong parameter and refuse to start.
          //If there are Hamlibs that defaut to "1" user must set "Extra command line parameters" as
          //-C auto_power_on=0
      //else RigCtldArgs:= RigCtldArgs+' -C auto_power_on=0';
    end;
  paramList.DelimitedText := RigCtldArgs;
  rigProcess.Parameters.Clear;
  while index < paramList.Count do
  begin
    rigProcess.Parameters.Add(paramList[index]);
    inc(index);
  end;
  paramList.Free;
  if fDebugMode then Writeln('rigProcess.Executable: ',rigProcess.Executable,LineEnding,'Parameters:',LineEnding,rigProcess.Parameters.Text);

  try
    rigProcess.Execute;
    sleep(1500);
    if not rigProcess.Active then
    begin
      Result := False;
      exit
    end
  except
    on E : Exception do
    begin
      if fDebugMode then
        Writeln('Starting rigctld E: ',E.Message);
      fLastError := E.Message;
      Result     := False;
      exit
    end
  end;
  Result := True
end;

function TRigControl.RigConnected  : Boolean;
const
  ERR_MSG = 'Could not connect to rigctld';
var
 RetryCount    : integer;
 Connection2Done: boolean;

begin
  if fDebugMode then
  begin
    Writeln('');
    Writeln('Settings:');
    Writeln('-----------------------------------------------------');
    Writeln('RigCtldPath:',RigCtldPath);
    Writeln('RigCtldArgs:',RigCtldArgs);
    Writeln('RunRigCtld: ',RunRigCtld);
    Writeln('RigDevice:  ',RigDevice);
    Writeln('RigCtldPort:',RigCtldPort);
    Writeln('RigCtldHost:',RigCtldHost);
    Writeln('RigPoll:    ',RigPoll);
    Writeln('RigSendCWR: ',RigSendCWR);
    Writeln('RigChkVfo   ',RigChkVfo);
    Writeln('RigId:      ',RigId);
    Writeln('')
  end;

  if fRunRigCtld then
   begin
    if not StartRigctld then
      begin
        if fDebugMode then Writeln('rigctld failed to start!');
        Result := False;
        exit
      end
     else
      if fDebugMode then Writeln('rigctld started!');
   end
  else
    if fDebugMode then Writeln('Not started rigctld process. (Run is set FALSE)');


  RigctldConnect.Host := fRigCtldHost;
  RigctldConnect.Port := fRigCtldPort;
  RetryCount          := 1;
  ErrorRigctldConnect := False;
  ConnectionDone      := False;
  InitDone            :=false;
  fResponseTimeout    :=false;

  if ( RigctldConnect.Connect(fRigCtldHost,fRigCtldPort) and (fRigCtldHost<>'') ) then
   Begin
     repeat
         begin
            if fDebugMode then
                          Writeln('Waiting for rigctld Poll ',RetryCount,' @ ',fRigCtldHost,':',fRigCtldPort);
            if  ErrorRigctldConnect then
                Begin
                  ErrorRigctldConnect := False;
                  RigctldConnect.Connect(fRigCtldHost,fRigCtldPort);
                end;
            inc(RetryCount);
            sleep(1000);
            Application.ProcessMessages;
          end;
     until (ConnectionDone or (Retrycount > 10)) ;

     if ConnectionDone then
      Begin
       if fDebugMode then
                     Writeln('Connected to rigctld Poll (RigConnected)');
       result := True
      end
    else
      begin
       if fDebugMode then
                     Writeln('RETRY ERROR: *NOT* connected to rigctld Poll @ ',fRigCtldHost,':',fRigCtldPort);
       fLastError := ERR_MSG;
       Result     := False
      end;
    end
  else
   begin
    if fDebugMode then
                  Writeln('SETTINGS ERROR: *NOT* connected to rigctld @ ',fRigCtldHost,':',fRigCtldPort);
    fLastError := ERR_MSG;
    Result     := False
   end;

end;


procedure TRigControl.SetCurrVFO(vfo : TVFO);
begin
  case vfo of
    VFOA : RigCommand.Add('V VFOA');
    VFOB : RigCommand.Add('V VFOB');
  end; //case
  Allowcommand:=1;
end;

procedure TRigControl.SetModePass(mode : TRigMode);
begin
  if (mode.mode='CW') and fRigSendCWR then
    mode.mode := 'CWR';
  RigCommand.Add('+\set_mode'+VfoStr+' '+mode.mode+' '+IntToStr(mode.pass));
  Allowcommand:=1;
end;

procedure TRigControl.SetFreqKHz(freq : Double);
begin
  RigCommand.Add('+\set_freq'+VfoStr+' '+FloatToStr(freq*1000-TXOffset*1000000));
  Allowcommand:=1;
end;

procedure TRigControl.SetTuner;
begin
  if fSetFunc and (Pos('TUNER', fSupSetFuncs)>0) then
    RigCommand.Add('+\set_func'+VfoStr+' TUNER 1');
  Allowcommand:=1;
end;

procedure TRigControl.ReSetTuner;
begin
  if fSetFunc and (Pos('TUNER', fSupSetFuncs)>0) then
    RigCommand.Add('+\set_func'+VfoStr+' TUNER 0');
  Allowcommand:=1;
end;
procedure TRigControl.ClearRit;
begin
  RigCommand.Add('+\set_rit'+VfoStr+' 0');
  Allowcommand:=1;
end;
procedure TRigControl.DisableRit;
Begin
  RigCommand.Add('+\set_func'+VfoStr+' RIT 0');
  Allowcommand:=1;
end;
procedure TRigControl.SetSplit(up:integer);
Begin
  RigCommand.Add('+\set_xit'+VfoStr+' '+IntToStr(up));
  RigCommand.Add( '+\set_func'+VfoStr+' XIT 1');
  Allowcommand:=1;
end;
procedure TRigControl.ClearXit;
begin
 RigCommand.Add('+\set_xit'+VfoStr+' 0');
 Allowcommand:=1;
end;
procedure TRigControl.DisableSplit;
Begin
 RigCommand.Add('+\set_func'+VfoStr+' XIT 0');
 Allowcommand:=1;
end;
procedure TRigControl.PttOn;
begin
  RigCommand.Add('+\set_ptt'+VfoStr+' 1');
  Allowcommand:=1;
end;
procedure TRigControl.PttOff;
begin
 RigCommand.Add('+\set_ptt'+VfoStr+' 0');
 Allowcommand:=1;
end;
procedure TRigControl.SendVoice(Vmem:String);
begin
  RigCommand.Add('+\send_voice_mem '+Vmem);
  Allowcommand:=1;
end;
procedure TRigControl.StopVoice;
begin
  RigCommand.Add('+\stop_voice_mem');
  Allowcommand:=1;
end;
procedure TRigControl.PwrOn;
begin
  AllowCommand:=4; //high prority  passes -1 state
end;
procedure TRigControl.PwrOff;
begin
  PowerOffIssued:=true;
  RigCommand.Add('+\set_powerstat 0');
  Allowcommand:=1;
end;
procedure TRigControl.PwrStBy;
begin
   PowerOffIssued:=true;
   RigCommand.Add('+\set_powerstat 2');
   Allowcommand:=1;
end;
procedure TRigControl.UsrCmd(cmd:String);
begin
  if (cmd<>'') then RigCommand.Add(cmd);
  Allowcommand:=1;
end;

procedure TRigControl.SetPowerPercent(p:integer);
var
   s:String;
begin
  if not fSetRFPower then exit;
  case p of
     0:   s:='0';
     100: s:='1';
   else
    s:='0.'+IntToStr(p)+'66';
  end;
  RigCommand.Add('+\set_level'+VfoStr+' RFPOWER '+s);
  Allowcommand:=1;
end;

function TRigControl.GetCurrVFO  : TVFO;
begin
  result := fVFO
end;

function TRigControl.GetModePass : TRigMode;
begin
  result := fMode
end;
function TRigControl.GetRawMode : String;
begin
  Result := fMode.raw
end;
function TRigControl.GetModeOnly : String;
begin
  result := fMode.mode
end;
function TRigControl.GetPassOnly : word;
begin
  result := fMode.pass
end;

function TRigControl.GetFreqHz : Double;
begin
  result := fFreq + fRXOffset*1000000;
end;

function TRigControl.GetFreqKHz : Double;
begin
  result := (fFreq + fRXOffset*1000000) / 1000
end;

function TRigControl.GetFreqMHz : Double;
begin
  result := (fFreq + fRXOffset*1000000) / 1000000
end;

function TRigControl.GetSplitTXFreqMHz : Double;
begin
  result := fSFreq / 1000000
end;

function  TRigControl.GetPowerPercent: integer;
var
   p:integer;
Begin
    if TryStrToInt(fPwrPcnt,p) then
     Result:=p
    else
     Result:=-1;
end;
function  TRigControl.GetPowermW : integer;
var
 f:string;
 r:integer;
begin
   if not fGetRFPower then exit;
   if TryStrToInt(fPwrmW,r) then
      Result:=r
    else
      Result:=-1;
end;

function TRigControl.GetModePass(vfo : TVFO) : TRigMode;
var
  old_vfo : TVFO;
begin
  if fVFO <> vfo then
  begin
    old_vfo := fVFO;
    SetCurrVFO(vfo);
    Sleep(fRigPoll*2);
    result := fMode;
    SetCurrVFO(old_vfo)
  end;
  result := fMode
end;

function TRigControl.GetModeOnly(vfo : TVFO) : String;
var
  old_vfo : TVFO;
begin
  if fVFO <> vfo then
  begin
    old_vfo := fVFO;
    SetCurrVFO(vfo);
    Sleep(fRigPoll*2);
    result := fMode.mode;
    SetCurrVFO(old_vfo)
  end;
  result := fMode.mode
end;

function TRigControl.GetFreqHz(vfo : TVFO)   : Double;
var
  old_vfo : TVFO;
begin
  if fVFO <> vfo then
  begin
    old_vfo := fVFO;
    SetCurrVFO(vfo);
    Sleep(fRigPoll*2);
    result := fFreq;
    SetCurrVFO(old_vfo)
  end;
  result := fFreq
end;

function TRigControl.GetFreqKHz(vfo : TVFO)  : Double;
var
  old_vfo : TVFO;
begin
  if fVFO <> vfo then
  begin
    old_vfo := fVFO;
    SetCurrVFO(vfo);
    Sleep(fRigPoll*2);
    result := fFreq/1000;
    SetCurrVFO(old_vfo)
  end;
  result := fFreq
end;

function TRigControl.GetFreqMHz(vfo : TVFO)  : Double;
var
  old_vfo : TVFO;
begin
  if fVFO <> vfo then
  begin
    old_vfo := fVFO;
    SetCurrVFO(vfo);
    Sleep(fRigPoll*2);
    result := fFreq/1000000;
    SetCurrVFO(old_vfo)
  end;
  result := fFreq
end;

procedure TRigControl.OnReceivedRigctldConnect(aSocket: TLSocket);
var
  msg,
  Imsg : String;
  a,b : TExplodeArray;
  i   : Integer;
  f   : Double;
  Hit : boolean;
  tmp : string;
  MaxArg: integer;

begin
  msg:='';
  Hit:=false;
  while (( aSocket.GetMessage(msg) > 0 ) and (not fResponseTimeout)) do
  begin
    msg := StringReplace(upcase(trim(msg)),#$09,' ',[rfReplaceAll]); //note the char case upper for now on! Remove TABs
    Imsg:=StringReplace(msg,LineEnding,'|',[rfReplaceAll]);
    if fDebugMode then
         Writeln('Msg from rig:',Imsg);

    if not InitDone then
      Begin
       if pos('CHKVFO',Imsg)>0 then
         Begin
         ParmVfoChkd:=true;
         if  (pos('1', Imsg)>0) then
           if (pos('CHKVFO:', Imsg)>0) then   //oller rigctld has 'CHKVFO' (without double dot)
                                                        ParmHasVfo := 1  //rigctld > 4.0
                                                       else
                                                        ParmHasVfo := 2;  // rigctld vers 3.x

         if ParmHasVfo > 0 then VfoStr:=' currVFO';  //note set leading one space to string!
         if fDebugMode then
                           Writeln('"--vfo" checked:',ParmHasVfo,' using VfoString:',VfoStr);
         Hit:=true;
         AllowCommand:=9; //next dump_caps
        end;

       if pos('DUMP_CAPS',Imsg)>0 then
         Begin
            fIsNewHamlib := (pos('HAMLIB VERSION:',      Imsg)>0);  //old versions do not have this
            fPower       := (pos('CAN SET POWER STAT: Y',Imsg)>0);
            fGetVfo      := (pos('CAN GET VFO: Y',       Imsg)>0);
            fSetFunc     := (pos('CAN SET FUNC: Y',      Imsg)>0);
            fGetFunc     := (pos('CAN GET FUNC: Y',      Imsg)>0);
            fSetLevel    := (pos('CAN SET LEVEL: Y',     Imsg)>0);
            fGetLevel    := (pos('CAN GET LEVEL: Y',     Imsg)>0);
            fMorse       := (pos('CAN SEND MORSE: Y',    Imsg)>0);
            fVoice       := (pos('CAN SEND VOICE: Y',    Imsg)>0);
            fGetRFPower  := (pos('CAN GET POWER2MW: Y',  Imsg)>0);
            fMemGetRFP   := fGetRFPower; //this is to remember rig's answer
            fSetRFPower  := (pos('CAN GET MW2POWER: Y',  Imsg)>0);
            fMemSetRFP   := fSetRFPower; //this is to remember rig's answer

          if fDebugMode then
                 Begin
                    Writeln(LineEnding,'This is New Hamlib: ',fIsNewHamlib);
                    Writeln('Cqrlog can switch power: ',fPower);
                    Writeln('Cqrlog can get VFO: ',fGetVfo);
                    Writeln('Cqrlog can get func: ',fGetFunc);
                    Writeln('Cqrlog can set func: ',fSetFunc);
                    Writeln('Cqrlog can get level: ',fGetLevel);
                    Writeln('Cqrlog can set level: ',fSetLevel);
                    Writeln('Cqrlog can send Morse: ',fMorse);
                    Writeln('Cqrlog can launch voice memories: ',fVoice);
                    Writeln('Cqrlog can get power2mW: ',fGetRFPower);
                    Writeln('Cqrlog can set mW2power: ',fSetRFPower,LineEnding);
                 end;
          Hit:=true;
          AllowCommand:=8; //next get_func
          end;

       if pos('GET_FUNC',Imsg)>0 then
        Begin
          fSupSetFuncs:= ExtractWord(2,Imsg,['|']);
          if fDebugMode then
                     Writeln(LineEnding,'Get functions: ',fSupGetFuncs);
          Hit:=true;
          AllowCommand:=7; //next get_level
        end;

       if pos('SET_FUNC',Imsg)>0 then
        Begin
           fSupSetFuncs:= ExtractWord(2,Imsg,['|']);
           if fDebugMode then
                      Writeln(LineEnding,'Set functions: ',fSupSetFuncs);
           Hit:=true;
           AllowCommand:=6; //next get_func
        end;

        if pos('GET_LEVEL',Imsg)>0 then
         Begin
            fSupGetLevels:= ExtractWord(2,Imsg,['|']);
            if fDebugMode then
                       Writeln(LineEnding,'Get levels: ',fSupGetLevels);
            Hit:=true;
            AllowCommand:=5; //next set_level
         end;

       if pos('SET_LEVEL',Imsg)>0 then
        Begin
          fSupSetLevels:= ExtractWord(2,Imsg,['|']);
          if fDebugMode then
                      Writeln(LineEnding,'Set Levels: ',fSupSetLevels);
           Hit:=true;
           RigCommand.Clear;
           tmrRigPoll.Interval := fRigPoll;  //set user poll speed
           InitDone:=true;
           if ((fRigId<10) and fPowerON and fPower) then
               AllowCommand:=4 // if rigctld is remote it can not make auto_power_on as startup parameter
                               // then we should send set_powerstat 1 if power up is asked and rig can do it
           else
               AllowCommand:=0;
        end;
     end //init
  else
     Begin
        a := Explode(LineEnding,msg);
        MaxArg:=Length(a)-1;

        for i:=0 to MaxArg do     //this handles received message line by line
        begin
          Hit:=false;
          if fDebugMode then
             Writeln('a['+IntToStr(i)+']:',a[i]);
          if a[i]='' then Continue;


          //we send all commands with '+' prefix that makes receiving sort lot easier
          b:= Explode(' ', a[i]);

          if (( not Hit ) and (pos('RFPOWER_METER_',a[i])>0) and (i+2 <= MaxArg)) then //must check that array a[] has i+2 members
            if (pos('RPRT 0',a[i+2])>0) then
             Begin
              Hit:=true;
              fRfPwrMtrWtts:= trim(a[i+1]);
              if (fRfPwrMtrWtts<>'0') and (fRfPwrMtrWtts<>'') then
                  fMemRfPwrMtrWtts:= fRfPwrMtrWtts;
             end;

           if (( not Hit ) and (pos('RFPOWER',a[i])>0) and (pos('RFPOWER_MET',a[i])=0) and (i+2 <= MaxArg)) then //must check that array a[] has i+2 members
             if (pos('RPRT 0',a[i+2])>0) then
              Begin
               Hit:=true;
               fPwrPcnt:= a[i+1];
              end;

           if (( not Hit ) and (pos('POWER MW:',a[i])>0) and (i+1 <= MaxArg)) then
            if(pos('RPRT 0',a[i+1])>0) then
             Begin
              Hit:=true;
              fPwrmW:=b[2];
             end;

           if (( not Hit ) and (pos('SET_POWERSTAT:',a[i])>0)) then
           Begin
             Hit:=true;
             if pos('1',a[i])>0 then //line may have 'STAT: 1' or 'STAT: CURRVFO 1'
              Begin
                if fDebugMode then Writeln('Power on, start polling');
                AllowCommand:=92; //check pending commands via delay Assume rig needs time to start
                PowerOffIssued:=false;
              end
             else
              Begin
                if fDebugMode then Writeln('Power off, stop poll decode (-2)');
                AllowCommand:=-2; //there is no timeout for this
                Exit;
              end;
           end;

          if ( not Hit ) then
           Begin
           case b[0] of

            'FREQUENCY:'         : Begin
                                     if TryStrToFloat(b[1],f) then
                                       Begin
                                         fFReq := f;
                                       end
                                      else
                                       fFReq := 0;
                                      Hit:=true;
                                   end;

            'TX'                   : begin
                                      if (b[1]='FREQUENCY:') then    //get split TX freq
                                       Begin
                                         if TryStrToFloat(b[2],f) then
                                           Begin
                                             fSFReq := f;
                                           end
                                          else
                                           fSFReq := 0;
                                          Hit:=true;
                                       end;

                                       if (b[1]='MODE:')  then   //WFview false rigctld emulating says "TX MODE:"
                                          Begin
                                            b[0]:=b[1];
                                            b[1]:=b[2];
                                          end;
                                     end;

             'SPLIT:'              : Begin
                                       fRigSplitActive:= (b[1] = '1');
                                       AllowCommand:=1;
                                     end;

             'MODE:'               : Begin
                                       fMode.raw  := b[1];
                                       fMode.mode :=  fMode.raw;
                                       if (fMode.mode = 'USB') or (fMode.mode = 'LSB') then
                                         fMode.mode := 'SSB';
                                       if fMode.mode = 'CWR' then
                                         fMode.mode := 'CW';
                                       Hit:=true;
                                      end;

              'VFO:'                : //FT-920 returned VFO as MEM
                                      //Some rigs report VFO as Main,MainA,MainB or Sub,SubA,SubB
                                      //Hamlib dummy has also "None" could it be in some real rigs too?
                                       Begin
                                         b:= Explode(' ', a[i]);
                                         case b[1] of
                                           'VFOA',
                                           'MAIN',
                                           'MAINA',
                                           'SUBA'    :fVFO := VFOA;

                                           'VFOB',
                                           'SUB',
                                           'MAINB',
                                           'SUBB'    :fVFO := VFOB;
                                          else
                                            fVFO := VFOA;
                                         end;
                                         Hit:=true;
                                        end;

              'PTT:'                  : Begin
                                         fPtt:= b[1];
                                        end;

              'RPRT'                  : Begin
                                         //RPRT should always end the received command
                                           AllowCommand:=1; //check pending commands
                                           HamlibErrors(b[1]);
                                        end;
          end; //case
         end   //not Hit
        else  //Hit from first block (RF)
         Allowcommand:=1;
     end; //max arg loop
   end; //other than init
  end;  //while rcvd

end;

procedure TRigControl.OnRigPollTimer(Sender: TObject);
var
  cmd     : String;
  i       : Integer;
  f       :integer;
  s       :array[1..5] of string=('','','','','');

begin
 if fDebugMode then
               Writeln('Polling - allowcommand:',AllowCommand);

 case AllowCommand of
     -2:  Exit;
     -1:  Begin
               dec(fPollCount);
               if fPollCount<1 then
                  Begin
                    if fDebugMode then
                                Writeln('Rig/rigctld did not respond to command within timeout!');
                    tmrRigPoll.Enabled  := False;
                    fResponseTimeout := true;
                  end;
               Exit;   //no sending allowed
           end;

     //delay up to 10 timer rounds with this selecting one of numbers
     99:  Begin AllowCommand:=98;  end;
     98:  Begin AllowCommand:=97;  end;
     97:  Begin AllowCommand:=96;  end;
     96:  Begin AllowCommand:=95;  end;
     95:  Begin AllowCommand:=94;  end;
     94:  Begin AllowCommand:=93;  end;
     93:  Begin AllowCommand:=92;  end;
     92:  Begin AllowCommand:=91;  end;
     91:  AllowCommand:=1;

     //high priority (init) commands
     10:  Begin
               cmd:='+\chk_vfo'+LineEnding;
               if fDebugMode then
                     Write(LineEnding+'Sending: '+cmd);
               if not SendPoll(cmd) then exit;
               AllowCommand:=-1; //waiting for reply
               fPollCount :=  fPollTimeout;
          end;
      9:  Begin
               cmd:='+\dump_caps'+LineEnding;
                if fDebugMode then
                     Write(LineEnding+'Sending: '+cmd);
               if not SendPoll(cmd) then exit;
               AllowCommand:=-1; //waiting for reply
               fPollCount :=  fPollTimeout;
          end;
      8:  Begin
               cmd:=('+\get_func'+VfoStr+' ?'+LineEnding);
               if fDebugMode then
                   Write(LineEnding+'Sending: '+cmd);
               if not SendPoll(cmd) then exit;
               AllowCommand:=-1; //waiting for reply
               fPollCount :=  fPollTimeout;
          end;
      7:  Begin
               cmd:=('+\set_func'+VfoStr+' ?'+LineEnding);
               if fDebugMode then
                   Write(LineEnding+'Sending: '+cmd);
               if not SendPoll(cmd) then exit;
               AllowCommand:=-1; //waiting for reply
               fPollCount :=  fPollTimeout;
          end;
      6:  Begin
               cmd:=('+\get_level'+VfoStr+' ?'+LineEnding);
               if fDebugMode then
                     Write(LineEnding+'Sending: '+cmd);
               if not SendPoll(cmd) then exit;
               AllowCommand:=-1; //waiting for reply
               fPollCount :=  fPollTimeout;
          end;
      5:  Begin
               cmd:=('+\set_level'+VfoStr+' ?'+LineEnding);
               if fDebugMode then
                     Write(LineEnding+'Sending: '+cmd);
               if not SendPoll(cmd) then exit;
               AllowCommand:=-1; //waiting for reply
               fPollCount :=  fPollTimeout;
          end;
      4:  Begin
               cmd:= '+\set_powerstat 1'+LineEnding;
               if fDebugMode then
                     Write(LineEnding+'Sending: '+cmd);
               if not SendPoll(cmd) then exit;
               AllowCommand:=-1; //waiting for reply
               sleep(4000); //allow rig to wake up
               fPollCount :=  fPollTimeout;
          end;

      //lower priority commands queue handled here
      1:  Begin
           if (RigCommand.Text<>'') then
              begin
                if fDebugMode then
                     write('Queue has:'+LineEnding,RigCommand.Text);
                 cmd := Trim(RigCommand.Strings[0])+LineEnding;
                  if fDebugMode then
                          Write(LineEnding+'Queue Sending[0]:',cmd);
                 for i:=0 to RigCommand.Count-2 do
                    RigCommand.Exchange(i,i+1);
                  RigCommand.Delete(RigCommand.Count-1);
                  if fDebugMode then
                     write('Queue left:'+LineEnding,RigCommand.Text);
                  if not SendPoll(cmd) then exit;
                  AllowCommand:=-1; //wait answer
                  fPollCount :=  fPollTimeout;
               end
            else
              AllowCommand :=0;
          end;

       end;//case

     //polling has lowest prority, do if there is nothing else to do
    if (AllowCommand=0 ) then
     begin
      if   ((not RigctldConnect.Connected)
             or fResponseTimeout )
                           then exit;

     if  ParmHasVfo=2 then
       begin
         if fGetVfo then
            begin
              s[1]:='+f'+VfoStr;
              s[2]:='+m'+VfoStr;
              s[3]:='+v'+VfoStr;
              if fGetSplitTX then
               Begin
                 s[4]:='+i'+VfoStr;
                 s[5]:='+s'+VfoStr;
               end;
              //cmd := '+f'+VfoStr+' +m'+VfoStr+' +v'+VfoStr+LineEnding //chk this with rigctld v3.1
            end
          else
            begin
              s[1]:='+f'+VfoStr;
              s[2]:='+m'+VfoStr;
              if fGetSplitTX then
               Begin
                 s[3]:='+i'+VfoStr;
                 s[4]:='+s'+VfoStr;
               end;
              //cmd := '+f'+VfoStr+' +m'+VfoStr+LineEnding //do not ask vfo if rig can't
            end

       end
      else
       begin
         if fGetVfo then
            begin
              s[1]:='+f'+VfoStr;
              s[2]:='+m'+VfoStr;
              s[3]:='+v';
              if fGetSplitTX then
               Begin
                 s[4]:='+i'+VfoStr;
                 s[5]:='+s'+VfoStr;
               end;
              //cmd := '+f'+VfoStr+' +m'+VfoStr+' +v'+LineEnding
            end
          else
          begin
              s[1]:='+f'+VfoStr;
              s[2]:='+m'+VfoStr;
              if fGetSplitTX then
               Begin
                 s[3]:='+i'+VfoStr;
                 s[4]:='+s'+VfoStr;
               end;
              //cmd := '+f'+VfoStr+' +m'+VfoStr+LineEnding //do not ask vfo if rig can't
            end
       end;


     if fCompoundPoll then
           Begin
            if fDebugMode then
               Write(LineEnding+'Poll Sending:'+trim(s[1]+' '+s[2]+' '+s[3]+' '+s[4]+' '+s[5])+LineEnding);
            if not SendPoll(trim(s[1]+' '+s[2]+' '+s[3]+' '+s[4]+' '+s[5])+LineEnding) then exit;
           end
          else
            Begin
              for f:=1 to 5 do
                Begin
                  if s[f]<>'' then
                   Begin
                      if fDebugMode then
                            Write(LineEnding+'Poll Sending:'+s[f]+LineEnding);
                      if not SendPoll(s[f]+LineEnding) then exit;
                   end
                  else
                  break;
                  sleep(2);
                end;
            end;

       if fGetRFPower then   //if it is possible and allowed by user
           Begin
             if fGetLevel and (Pos('RFPOWER ', fSupGetLevels)>0) then
               rigCommand.Add('+\get_level'+VfoStr+' RFPOWER'+LineEnding);

             if fGetLevel and (Pos('RFPOWER_METER_WATTS', fSupGetLevels)>0) then
               rigCommand.Add('+\get_level'+VfoStr+' RFPOWER_METER_WATTS'+LineEnding);

             rigCommand.Add('+\get_ptt'+VfoStr);  //PTT controls TRXCOntrol Power out display
           end
        else
          fPtt:='';

     AllowCommand:=-1; //waiting for reply
     fPollCount :=  fPollTimeout;
    end;

end;
procedure TRigControl.OnConnectRigctldConnect(aSocket: TLSocket);
Begin
    if fDebugMode then
                   Writeln('Connecting to rigctld Poll (OnConnect)');

    ParmHasVfo:=0;   //default: "--vfo" is not used as start parameter
    AllowCommand:=10;  //start with chk_vfo
    RigCommand.Clear;
    tmrRigPoll.Interval := 50; //to speed up init
    tmrRigPoll.Enabled  := True;

    if RigChkVfo then
      Begin
        AllowCommand:=10;  //start with chkvfo
        ParmVfoChkd:=false;
      end
     else
      Begin
        AllowCommand:=9;  //otherwise start with dump caps
        ParmVfoChkd:=false;
      end;
    ConnectionDone:=true;
end;
procedure TRigControl.OnErrorRigctldConnect(const msg: string; aSocket: TLSocket);

begin
  ErrorRigctldConnect:= True;
  if fDebugMode then
                   writeln('Error with rigctld: ' ,msg);
   if (pos('[107]',msg)>0) or (pos('[104]',msg)>0) then
   Begin
     tmrRigPoll.Enabled  := False;
     fResponseTimeout := true;
   end;
end;
function TRigControl.SendPoll(msg:string):boolean;
var r: integer;
begin
  Result:=false;
  if   ((not RigctldConnect.Connected)
         or fResponseTimeout )
                       then exit;
  r:=RigctldConnect.SendMessage(msg);
  Result:=(r=length(msg)); //SendMessage returns sent char count (inc LineEnding)
  if fDebugMode then
                writeln('Sent :',r,' ',Result);
end;
procedure TRigControl.Restart;
var
  excode : Integer = 0;
begin
  tmrRigPoll.Enabled := False;
  sleep(fRigPoll);
  RigctldConnect.Disconnect(true);
  sleep(100);
  rigProcess.Terminate(excode);

  RigConnected
end;

function TRigControl.Explode(const cSeparator, vString: String): TExplodeArray;
var
  i: Integer;
  S: String;
begin
  S := vString;
  Result:=nil;
  SetLength(Result, 0);
  i := 0;
  while Pos(cSeparator, S) > 0 do begin
    SetLength(Result, Length(Result) +1);
    Result[i] := Copy(S, 1, Pos(cSeparator, S) -1);
    Inc(i);
    S := Copy(S, Pos(cSeparator, S) + Length(cSeparator), Length(S));
  end;
  SetLength(Result, Length(Result) +1);
  Result[i] := Copy(S, 1, Length(S))
end;

destructor TRigControl.Destroy;
var
  excode : Integer=0;
begin
  inherited;
  if fDebugMode then Writeln('Destroy rigctld'+LineEnding+'1');
  if fRunRigCtld then
  begin
    if rigProcess.Running then
    begin
      if fDebugMode then Writeln('1a');
      rigProcess.Terminate(excode)
    end
  end;
  if fDebugMode then Writeln(2);
  tmrRigPoll.Enabled := False;
  sleep(fRigPoll);
  if fDebugMode then Writeln(3);
  RigctldConnect.Disconnect();
  if fDebugMode then Writeln(4);
  FreeAndNil(RigctldConnect);
  if fDebugMode then Writeln(5);
  FreeAndNil(rigProcess);
  FreeAndNil(RigCommand);
  if fDebugMode then Writeln('6'+LineEnding+'Done!')
end;

procedure TRigControl.HamlibErrors(e:string);
Begin
  case e of
     '-1' : Writeln('Invalid parameter');
     '-2' : Writeln('Invalid configuration (serial,..)');
     '-3' : Writeln('Memory shortage');
     '-4' : Writeln('Function not implemented, but will be');
     '-5' : Writeln('Communication timed out');
     '-6' : Writeln('IO error, including open failed');
     '-7' : Writeln('Internal Hamlib error, huh!');
     '-8' : Writeln('Protocol error');
     '-9' : Writeln('Command rejected by the rig');
     '-10': Writeln('Command performed, but arg truncated');
     '-11': Writeln('Function not available');
     '-12': Writeln('VFO not targetable');
     '-13': Writeln('Error talking on the bus');
     '-14': Writeln('Collision on the bus');
     '-15': Writeln('NULL RIG handle or any invalid pointer parameter in get arg');
     '-16': Writeln('Invalid VFO');
     '-17': Writeln('Argument out of domain of func');
     '-18': Writeln('Function deprecated');
     '-19': Writeln('Security error password not provided or crypto failure');
     '-20': Writeln('Rig is not powered on');
  end;
end;


end.

