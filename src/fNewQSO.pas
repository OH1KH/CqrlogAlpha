(*
***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License.        *
 *                                                                         *
 ***************************************************************************
*)


unit fNewQSO;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  DBGrids, StdCtrls, Buttons, ComCtrls, Grids, inifiles,
  LCLType, httpsend, Menus, ActnList, process, db,
  uCWKeying, ipc, baseunix, dLogUpload, blcksock, dateutils,
  fMonWsjtx, fWorkedGrids,fPropDK0WCY, fAdifImport, RegExpr,
  FileUtil, LazFileUtils, sqldb, strutils, LazUTF8;

const
  cRefCall = 'Ref.call (CTRL+R): ';
  cMyLoc   = 'My Loc (CTRL+L): ';
  cOperator ='Operator (ALT+O): ';
  cQSLMgrVersionCheckUrl = 'http://www.ok2cqr.com/linux/cqrlog/qslmgr/ver.dat';
  cDOKVersionCheckUrl = 'https://www.df2et.de/cqrlog/ver.dat';
  cCntyVersionCheckUrl = 'http://www.ok2cqr.com/linux/cqrlog/ctyfiles/ver.dat';

type
  TRemoteModeType = (rmtFldigi, rmtWsjt, rmtADIF);


type

  { TfrmNewQSO }

  TfrmNewQSO = class(TForm)
    acAbout: TAction;
    acClose: TAction;
    acDXCluster: TAction;
    acGrayline: TAction;
    acPreferences: TAction;
    acShowToolBar: TAction;
    acDetails: TAction;
    acQSOperMode: TAction;
    acShowBandMap: TAction;
    acAddToBandMap: TAction;
    acLongNote: TAction;
    acDXCCCfm: TAction;
    acITUCfm: TAction;
    acEditQSO: TAction;
    acCWMessages: TAction;
    acCWType: TAction;
    acRemoteMode: TAction;
    acQSOBefore: TAction;
    acCWFKey: TAction;
    acShowStatBar: TAction;
    acShowQSOB4: TAction;
    acRefreshTRX: TAction;
    acOpenLog: TAction;
    acBigSquare: TAction;
    acSendSpot : TAction;
    acSCP : TAction;
    acQSOList: TAction;
    acRotControl: TAction;
    acReloadCW: TAction;
    acLogUploadStatus: TAction;
    acHotkeys: TAction;
    acRefreshTime: TAction;
    acRBNMonitor: TAction;
    acRemoteWsjt: TAction;
    acCommentToCallsign : TAction;
    acMonitorWsjtx: TAction;
    acLocatorMap: TAction;
    acpDK0WCY: TAction;
    acProp: TAction;
    acReminder: TAction;
    acContest: TAction;
    acRemoteModeADIF: TAction;
    acCounty: TAction;
    acUploadToAll: TAction;
    acUploadToHrdLog: TAction;
    acUploadToClubLog: TAction;
    acUploadToHamQTH: TAction;
    acUploadToUDPLog: TAction;
    acTune : TAction;
    btnClearSatellite : TButton;
    cbOffline: TCheckBox;
    cbTxLo: TCheckBox;
    cbRxLo: TCheckBox;
    cbSpotRX: TCheckBox;
    cbSplitTX: TCheckBox;
    chkAutoMode: TCheckBox;
    cmbPropagation : TComboBox;
    cmbSatellite : TComboBox;
    dbgrdQSOBefore: TDBGrid;
    edtContestExchangeMessageReceived: TEdit;
    edtContestExchangeMessageSent: TEdit;
    edtContestName: TEdit;
    edtContestSerialReceived: TEdit;
    edtContestSerialSent: TEdit;
    edtDOK: TEdit;
    edtTXLO: TEdit;
    edtRXLO: TEdit;
    edtRXFreq : TEdit;
    gbContest: TGroupBox;
    lblContestExchangeMessageReceived: TLabel;
    lblContestExchangeMessageSent: TLabel;
    lblContestName: TLabel;
    lblContestSerialReceived: TLabel;
    lblContestSerialSent: TLabel;
    lblStimeFormat: TLabel;
    lblEtimeFormat: TLabel;
    lblDateformat: TLabel;
    Label38: TLabel;
    Label37: TLabel;
    lblCallbookInformation : TLabel;
    lblPropagation : TLabel;
    lblDOK: TLabel;
    lblStatellite : TLabel;
    lblRXFreq : TLabel;
    lblRXMhz : TLabel;
    mCallBook : TMemo;
    mCountry : TMemo;
    MenuItem32 : TMenuItem;
    MenuItem33 : TMenuItem;
    MenuItem34 : TMenuItem;
    MenuItem35 : TMenuItem;
    MenuItem36 : TMenuItem;
    MenuItem37: TMenuItem;
    MenuItem38: TMenuItem;
    MenuItem39: TMenuItem;
    MenuItem4 : TMenuItem;
    MenuItem40: TMenuItem;
    MenuItem41: TMenuItem;
    MenuItem43: TMenuItem;
    MenuItem45: TMenuItem;
    MenuItem46: TMenuItem;
    MenuItem51: TMenuItem;
    MenuItem52: TMenuItem;
    MenuItem53: TMenuItem;
    MenuItem56: TMenuItem;
    MenuItem57: TMenuItem;
    MenuItem58: TMenuItem;
    MenuItem63: TMenuItem;
    MenuItem84: TMenuItem;
    MenuItem94 : TMenuItem;
    MenuItem95: TMenuItem;
    MenuItem96: TMenuItem;
    mnueQSLView: TMenuItem;
    mnuRemoteModeADIF: TMenuItem;
    mnuReminder: TMenuItem;
    MenuItem86: TMenuItem;
    MenuItem87: TMenuItem;
    MenuItem88: TMenuItem;
    MenuItem89: TMenuItem;
    MenuItem90: TMenuItem;
    MenuItem91: TMenuItem;
    MenuItem92 : TMenuItem;
    MenuItem93 : TMenuItem;
    mnuWsjtxmonitor: TMenuItem;
    mnuLocatorMap: TMenuItem;
    mnuRemoteModeWsjt: TMenuItem;
    mnuOnlineLog: TMenuItem;
    MenuItem54: TMenuItem;
    MenuItem55: TMenuItem;
    acWASCfm: TAction;
    acWACCfm: TAction;
    acDOKCfm: TAction;
    acViewQSO: TAction;
    acWAZCfm: TAction;
    acXplanet: TAction;
    ActionList1: TActionList;
    acTRXControl: TAction;
    btnCancel: TButton;
    btnDXCCRef: TButton;
    btnQSLMgr: TButton;
    btnSave: TButton;
    cmbFreq: TComboBox;
    cmbIOTA: TComboBox;
    cmbMode: TComboBox;
    cmbProfiles: TComboBox;
    cmbQSL_R: TComboBox;
    cmbQSL_S: TComboBox;
    edtAward: TEdit;
    edtCall: TEdit;
    edtCounty: TEdit;
    edtDate: TEdit;
    edtDXCCRef: TEdit;
    edtEndTime: TEdit;
    edtGrid: TEdit;
    edtHisRST: TEdit;
    edtITU: TEdit;
    edtMyRST: TEdit;
    edtName: TEdit;
    edtPWR: TEdit;
    edtQSL_VIA: TEdit;
    edtQTH: TEdit;
    edtRemQSO: TEdit;
    edtStartTime: TEdit;
    edtState: TEdit;
    edtWAZ: TEdit;
    gbDXCCdata: TGroupBox;
    imgMain: TImageList;
    imgMain1: TImageList;
    lblDate: TLabel;
    lblQTH: TLabel;
    lblCommentToCallsign: TLabel;
    lblPwr: TLabel;
    lblItuEdit: TLabel;
    lblLocalCaption: TLabel;
    lblTarSunSet: TLabel;
    lblTarSunRise: TLabel;
    lblLocSunSet: TLabel;
    lblLocSunRise: TLabel;
    lblGrid: TLabel;
    lblCounty: TLabel;
    lblQSLS: TLabel;
    lblQSLR: TLabel;
    lblStartTime: TLabel;
    lblAward: TLabel;
    lblDXCCRef: TLabel;
    lblWazEdit: TLabel;
    lblCommentToQSO: TLabel;
    lblQSONrDesc: TLabel;
    lblState: TLabel;
    lblDXCCCaption: TLabel;
    lblWAZCaption: TLabel;
    lblITUCaption: TLabel;
    lblEndTime: TLabel;
    lblContCaption: TLabel;
    lblLatCaption: TLabel;
    lblLongCaption: TLabel;
    lblDistCaption: TLabel;
    lblAzim: TLabel;
    lblMode: TLabel;
    lblFrequency: TLabel;
    blbQTHProfile: TLabel;
    lblRstSent: TLabel;
    lblRSTRcvd: TLabel;
    lblName: TLabel;
    lblAmbiguous: TLabel;
    lblAzi: TLabel;
    lblCall: TLabel;
    lblCont: TLabel;
    lblCountryInfo: TLabel;
    lblDXCC: TLabel;
    lblGreeting: TLabel;
    lblHisTime: TLabel;
    lblIOTA: TLabel;
    lblITU: TLabel;
    lblLat: TLabel;
    lblLong: TLabel;
    lblQRA: TLabel;
    lblQSLMgr: TLabel;
    lblQSLVia: TLabel;
    lblQSONr: TLabel;
    lblQSOTakes: TLabel;
    lblWAZ: TLabel;
    MainMenu1: TMainMenu;
    mComment: TMemo;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem16: TMenuItem;
    MenuItem17: TMenuItem;
    MenuItem18: TMenuItem;
    MenuItem19: TMenuItem;
    MenuItem20: TMenuItem;
    MenuItem21: TMenuItem;
    MenuItem22: TMenuItem;
    MenuItem23: TMenuItem;
    MenuItem24: TMenuItem;
    MenuItem25: TMenuItem;
    MenuItem26: TMenuItem;
    MenuItem27: TMenuItem;
    MenuItem28: TMenuItem;
    MenuItem29: TMenuItem;
    MenuItem30: TMenuItem;
    MenuItem31: TMenuItem;
    mnuViewQso: TMenuItem;
    MenuItem42: TMenuItem;
    mnuEditQso: TMenuItem;
    MenuItem44: TMenuItem;
    mnuQrz: TMenuItem;
    mnuIK3QAR: TMenuItem;
    MenuItem47: TMenuItem;
    MenuItem48: TMenuItem;
    MenuItem49: TMenuItem;
    MenuItem50: TMenuItem;
    MenuItem59: TMenuItem;
    MenuItem60: TMenuItem;
    MenuItem61: TMenuItem;
    MenuItem62: TMenuItem;
    MenuItem64: TMenuItem;
    MenuItem65: TMenuItem;
    MenuItem66: TMenuItem;
    MenuItem67: TMenuItem;
    MenuItem68: TMenuItem;
    MenuItem69: TMenuItem;
    MenuItem70: TMenuItem;
    MenuItem71: TMenuItem;
    MenuItem72: TMenuItem;
    MenuItem73: TMenuItem;
    MenuItem74: TMenuItem;
    MenuItem75: TMenuItem;
    MenuItem76: TMenuItem;
    MenuItem77: TMenuItem;
    MenuItem78: TMenuItem;
    MenuItem79: TMenuItem;
    MenuItem80: TMenuItem;
    MenuItem81: TMenuItem;
    MenuItem82: TMenuItem;
    MenuItem83: TMenuItem;
    mnuHamQth : TMenuItem;
    MenuItem85 : TMenuItem;
    mnuQSOBefore: TMenuItem;
    mnuRemoteMode: TMenuItem;
    mnuIOTA: TMenuItem;
    mnuQSOList: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    mnuHelp: TMenuItem;
    mnuClose: TMenuItem;
    mnuPreferences: TMenuItem;
    mnuNewQSO: TMenuItem;
    mnuFile: TMenuItem;
    mnuTRXControl: TMenuItem;
    pnlSbtn2: TPanel;
    pnlSbtn0: TPanel;
    pnlOffline: TPanel;
    pgDetails : TPageControl;
    pnlAll: TPanel;
    pnlDXCCinfo: TPanel;
    pnlQsoInfo: TPanel;
    pnlProfiles: TPanel;
    pnlDXCCCountry : TPanel;
    pnlQSOinput: TPanel;
    pnlSbtn1: TPanel;
    pnlSbtn3: TPanel;
    pnlSbtn4: TPanel;
    pnlSbtn5: TPanel;
    pnlSbtn6: TPanel;
    pnlSbtn7: TPanel;
    popEditQSO: TPopupMenu;
    sbNewQSO: TStatusBar;
    sbtnAttach: TSpeedButton;
    sbtneQSL: TSpeedButton;
    sbtnHamQTH: TSpeedButton;
    sbtnLocatorMap: TSpeedButton;
    sbtnUsrbtn: TSpeedButton;
    sbtnLoTW: TSpeedButton;
    sbtnQRZ: TSpeedButton;
    sbtnQSL: TSpeedButton;
    sgrdStatistic : TStringGrid;
    btnSunRise: TSpeedButton;
    sgrdCallStatistic: TStringGrid;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    btnSunSet: TSpeedButton;
    sbtnRefreshTime: TSpeedButton;
    tabDXCCStat : TTabSheet;
    tabSatellite : TTabSheet;
    tabLOConfig: TTabSheet;
    tabCallStat: TTabSheet;
    tmrADIF: TTimer;
    tmrWsjtx: TTimer;
    tmrUploadAll: TTimer;
    tmrFldigi: TTimer;
    tmrESC: TTimer;
    tmrRadio: TTimer;
    tmrRotor: TTimer;
    tmrEnd: TTimer;
    tmrStart: TTimer;
    procedure acBigSquareExecute(Sender: TObject);
    procedure acCommentToCallsignExecute(Sender : TObject);
    procedure acContestExecute(Sender: TObject);
    procedure acCountyExecute(Sender: TObject);
    procedure acCWFKeyExecute(Sender: TObject);
    procedure acHotkeysExecute(Sender: TObject);
    procedure acLocatorMapExecute(Sender: TObject);
    procedure acLogUploadStatusExecute(Sender: TObject);
    procedure acMonitorWsjtxExecute(Sender: TObject);
    procedure acOpenLogExecute(Sender: TObject);
    procedure acpDK0WCYExecute(Sender: TObject);
    procedure acQSOListExecute(Sender: TObject);
    procedure acRBNMonitorExecute(Sender: TObject);
    procedure acRefreshTimeExecute(Sender: TObject);
    procedure acRefreshTRXExecute(Sender: TObject);
    procedure acReloadCWExecute(Sender: TObject);
    procedure acReminderExecute(Sender: TObject);
    procedure acRemoteWsjtExecute(Sender: TObject);
    procedure acRotControlExecute(Sender: TObject);
    procedure acSCPExecute(Sender : TObject);
    procedure acSendSpotExecute(Sender : TObject);
    procedure acShowStatBarExecute(Sender: TObject);
    procedure acRemoteModeADIFExecute(Sender: TObject);
    procedure acTuneExecute(Sender : TObject);
    procedure acUploadToAllExecute(Sender: TObject);
    procedure acUploadToClubLogExecute(Sender: TObject);
    procedure acUploadToHamQTHExecute(Sender: TObject);
    procedure acUploadToHrdLogExecute(Sender: TObject);
    procedure acUploadToUDPLogExecute(Sender: TObject);
    procedure acPropExecute(Sender: TObject);
    procedure btnClearSatelliteClick(Sender : TObject);
    procedure cbRxLoChange(Sender: TObject);
    procedure cbSplitTXChange(Sender: TObject);
    procedure cbTxLoChange(Sender: TObject);
    procedure cbSpotRXChange(Sender: TObject);
    procedure chkAutoModeChange(Sender: TObject);
    procedure cmbFreqExit(Sender: TObject);
    procedure cmbIOTAEnter(Sender: TObject);
    procedure cmbPropagationChange(Sender : TObject);
    procedure cmbQSL_REnter(Sender: TObject);
    procedure cmbQSL_RExit(Sender: TObject);
    procedure cmbQSL_SEnter(Sender: TObject);
    procedure cmbQSL_SExit(Sender: TObject);
    procedure cmbSatelliteChange(Sender : TObject);
    procedure dbgrdQSOBeforeColumnSized(Sender: TObject);
    procedure dbgrdQSOBeforeExit(Sender: TObject);
    procedure edtAwardEnter(Sender: TObject);
    procedure edtCallChange(Sender: TObject);
    procedure edtCountyChange(Sender: TObject);
    procedure edtDateEnter(Sender: TObject);
    procedure edtDXCCRefEnter(Sender: TObject);
    procedure edtEndTimeEnter(Sender: TObject);
    procedure edtGridChange(Sender: TObject);
    procedure edtGridEnter(Sender: TObject);
    procedure edtGridKeyPress(Sender: TObject; var Key: char);
    procedure edtHisRSTExit(Sender: TObject);
    procedure edtHisRSTKeyPress(Sender : TObject; var Key : char);
    procedure edtITUEnter(Sender: TObject);
    procedure edtMyRSTExit(Sender: TObject);
    procedure edtMyRSTKeyPress(Sender : TObject; var Key : char);
    procedure edtNameChange(Sender: TObject);
    procedure edtNameEnter(Sender: TObject);
    procedure edtPWRChange(Sender: TObject);
    procedure edtPWREnter(Sender: TObject);
    procedure edtQSL_VIAChange(Sender: TObject);
    procedure edtQSL_VIAEnter(Sender: TObject);
    procedure edtQTHChange(Sender: TObject);
    procedure edtQTHEnter(Sender: TObject);
    procedure edtRemQSOEnter(Sender: TObject);
    procedure edtRXFreqChange(Sender: TObject);
    procedure edtRXFreqExit(Sender: TObject);
    procedure edtRXLOExit(Sender: TObject);
    procedure edtStartTimeEnter(Sender: TObject);
    procedure edtStateChange(Sender: TObject);
    procedure edtStateEnter(Sender: TObject);
    procedure edtTXLOExit(Sender: TObject);
    procedure edtWAZEnter(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormWindowStateChange(Sender: TObject);
    procedure lblAziChangeBounds(Sender: TObject);
    procedure lblDOKClick(Sender: TObject);
    procedure lblModeClick(Sender: TObject);
    procedure lblQRAChangeBounds(Sender: TObject);
    procedure lblStateClick(Sender: TObject);
    procedure MenuItem11Click(Sender: TObject);
    procedure MenuItem12Click(Sender: TObject);
    procedure MenuItem17Click(Sender: TObject);
    procedure MenuItem46Click(Sender: TObject);
    procedure MenuItem95Click(Sender: TObject);
    procedure MenuItem96Click(Sender: TObject);
    procedure MenuItem45Click(Sender: TObject);
    procedure mnuQrzClick(Sender: TObject);
    procedure mnuIK3QARClick(Sender: TObject);
    procedure mnuHamQthClick(Sender : TObject);
    procedure MenuItem9Click(Sender: TObject);
    procedure acRemoteModeExecute(Sender: TObject);
    procedure acWASCfmExecute(Sender: TObject);
    procedure acDOKCfmExecute(Sender: TObject);
    procedure acAddToBandMapExecute(Sender: TObject);
    procedure acCWMessagesExecute(Sender: TObject);
    procedure acCWTypeExecute(Sender: TObject);
    procedure acCloseExecute(Sender: TObject);
    procedure acDXCCCfmExecute(Sender: TObject);
    procedure acDXClusterExecute(Sender: TObject);
    procedure acDetailsExecute(Sender: TObject);
    procedure acEditQSOExecute(Sender: TObject);
    procedure acGraylineExecute(Sender: TObject);
    procedure acITUCfmExecute(Sender: TObject);
    procedure acLongNoteExecute(Sender: TObject);
    procedure acNewQSOExecute(Sender: TObject);
    procedure acPreferencesExecute(Sender: TObject);
    procedure acQSOperModeExecute(Sender: TObject);
    procedure acShowBandMapExecute(Sender: TObject);
    procedure acTRXControlExecute(Sender: TObject);
    procedure acViewQSOExecute(Sender: TObject);
    procedure acWACCfmExecute(Sender: TObject);
    procedure acWASLoTWExecute(Sender: TObject);
    procedure acWAZCfmExecute(Sender: TObject);
    procedure acXplanetExecute(Sender: TObject);
    procedure btnDXCCRefClick(Sender: TObject);
    procedure btnQSLMgrClick(Sender: TObject);
    procedure cbOfflineChange(Sender: TObject);
    procedure cmbFreqChange(Sender: TObject);
    procedure cmbFreqEnter(Sender: TObject);
    procedure cmbFreqKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure cmbIOTAChange(Sender: TObject);
    procedure cmbIOTAExit(Sender: TObject);
    procedure cmbIOTAKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure cmbModeChange(Sender: TObject);
    procedure cmbModeEnter(Sender: TObject);
    procedure cmbModeExit(Sender: TObject);
    procedure cmbModeKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure cmbProfilesChange(Sender: TObject);
    procedure cmbQSL_RKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure cmbQSL_SKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure dbgrdQSOBeforeDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure edtAwardExit(Sender: TObject);
    procedure edtCallEnter(Sender: TObject);
    procedure edtCallExit(Sender: TObject);
    procedure edtCallKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtCallKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtCountyEnter(Sender: TObject);
    procedure edtCountyExit(Sender: TObject);
    procedure edtCountyKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtCQKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtDateExit(Sender: TObject);
    procedure edtDateKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure edtAwardKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtDXCCRefExit(Sender: TObject);
    procedure edtDXCCRefKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtDateKeyPress(Sender: TObject; var Key: char);
    procedure edtEndTimeExit(Sender: TObject);
    procedure edtEndTimeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtGridExit(Sender: TObject);
    procedure edtGridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure edtHisRSTEnter(Sender: TObject);
    procedure edtHisRSTKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtITUExit(Sender: TObject);
    procedure edtITUKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtMyRSTEnter(Sender: TObject);
    procedure edtMyRSTKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure edtNameKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);

    procedure edtPWRKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtQSL_VIAKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtQTHExit(Sender: TObject);
    procedure edtQTHKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtRemQSOKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ModifyTimeFormat( var time:string);
    procedure edtStartTimeExit(Sender: TObject);
    procedure edtStartTimeKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure edtStartTimeKeyPress(Sender: TObject; var Key: char);
    procedure edtStateExit(Sender: TObject);
    procedure edtStateKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure edtWAZExit(Sender: TObject);
    procedure mCommentKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure mCommentKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure mnueQSLViewClick(Sender: TObject);
    procedure mnuIOTAClick(Sender: TObject);
    procedure mnuQSOBeforeClick(Sender: TObject);
    procedure mnuQSOListClick(Sender: TObject);
    procedure pgDetailsChange(Sender: TObject);
    procedure popEditQSOPopup(Sender: TObject);
    procedure sbtnAttachClick(Sender: TObject);
    procedure sbtnLocatorMapClick(Sender: TObject);
    procedure sbtnQSLClick(Sender: TObject);
    procedure sbtnQRZClick(Sender: TObject);
    procedure sbtnHamQTHClick(Sender : TObject);
    procedure sbtnUsrbtnClick(Sender: TObject);
    procedure sgrdCallStatisticPrepareCanvas(Sender: TObject; aCol,
      aRow: Integer; aState: TGridDrawState);
    procedure tmrESCTimer(Sender: TObject);
    procedure tmrEndStartTimer(Sender: TObject);
    procedure tmrEndTimer(Sender: TObject);
    procedure tmrFldigiTimer(Sender: TObject);
    procedure tmrADIFTimer(Sender: TObject);
    procedure tmrRadioTimer(Sender: TObject);
    procedure tmrStartStartTimer(Sender: TObject);
    procedure tmrStartTimer(Sender: TObject);
    procedure tmrUploadAllTimer(Sender: TObject);
    procedure tmrWsjtxTimer(Sender: TObject);
  private
    StartUpCount : integer;
    StartRun    : Boolean;
    old_stat_adif : Word;
    TabUsed     : Boolean;
    old_cmode   : String;
    old_ccall   : String;
    old_cfreq   : String;

    old_prof   : Integer;
//    old_pfx    : String;
    old_adif   : Word;
    old_date   : TDateTime;
    old_mode   : String;
    old_freq   : String;
    old_qslr   : String;
    old_sat    : String;
    old_prop   : String;
    old_rxfreq : String;
    posun      : String;

    old_time   : String;
    old_rsts   : String;
    old_rstr   : String;
    ChangeDXCC : Boolean;
    StartTime  : TDateTime;
    Running    : Boolean;
    idcall     : String;
    old_t_mode : String;
    lotw_qslr  : String;
    fromNewQSO : Boolean;
    FreqBefChange : Double;
    adif : Word;
    WhatUpNext : TWhereToUpload;
    UploadAll  : Boolean;
    WsjtxDecodeRunning : boolean;
    DiffCalls          : byte;
    RememberAutoMode : Boolean;
    IsJS8Callrmt     : Boolean; //way to isolate adif from JS8's JSON
    QSLcfm,
    eQSLcfm,
    LoTWcfm    : String;
    UsrAssignedProfile : String;
    EditId             : longint;     //id_cqrlog_main of qso in edit mode
    DetailsCMBColorDone : string;     //changes done for DXCCdetails column color by currently used call+mode+band
    FirstClose          : boolean;    //When close button is clicked first time wit call in call column.

    procedure showDOK(stat:boolean);
    procedure ShowDXCCInfo(ref_adif : Word = 0);
    procedure ShowFields;
    procedure ChangeReports;
    procedure CalculateDistanceEtc;
    procedure SetDateTime(EndTime : Boolean = True);
    procedure CheckCallsignClub;
    procedure CheckQTHClub;
    procedure CheckAwardClub;
    procedure CheckCountyClub;
    procedure CheckStateClub;
    procedure ShowWindows;
    procedure CheckAttachment;
    procedure CheckQSLImage;
    procedure ShowCountryInfo;
    procedure InsertNameQTH;
    procedure LoadSettings;
    procedure SaveSettings;
    procedure ChangeCallBookCaption;
    procedure SendSpot;
    procedure RefreshInfoLabels;
    procedure FillDateTimeFields;
    procedure GoToRemoteMode(RemoteType : TRemoteModeType);

    procedure CloseAllWindows;
    procedure onExcept(Sender: TObject; E: Exception);
    procedure DisplayCoordinates(latitude, Longitude : Currency);
    procedure DrawGrayline;

    procedure CheckForExternalTablesUpdate;
    procedure CheckForDXCCTablesUpdate;
    procedure CheckForDOKTablesUpdate;
    procedure CheckForQslManagersUpdate;
    procedure CheckForMembershipUpdate;
    procedure CheckForAlphaVersion;

    procedure SelTextFix(Edit : TEdit; var Key : Char);

    function CheckFreq(freq : String) : String;
    procedure WaitWeb(secs:integer);
    function RigCmd2DataMode(mode:String):String;
    procedure StartUpRemote;
    procedure NewLogSplash;

  public
    fEditQSO    : Boolean;
    fViewQSO    : Boolean;
    QTHfromCb   : Boolean;
    FromDXC     : Boolean;
    UseSpaceBar : Boolean;
    CWint       : TCWDevice;
    ShowWin     : Boolean;
    LastFkey    : Word;
    old_t_band  : String;
    RemoteName  : String; //with wsjt has name from UDP datagram
    RemoteActive: String; //Actve remote name, empty if no remote running.
    CallFromSpot: Boolean; //Used with wsjtx UDP#15
    Op          : String;

    WsjtxSock             : TUDPBlockSocket; //receive socket
    WsjtxSockS            : TUDPBlockSocket; //multicast send socket
    ADIFSock              : TUDPBlockSocket;

    WsjtxMode             : String;    //Moved from private
    WsjtxBand             : String;
    wSpeed                : integer;   // udp polling speeds (tmrWsjtx)
    old_call              : String;    //Moved from private
    was_call              : String;    //holds recent edtCallsign.text before it was cleared
    FldigiXmlRpc          : Boolean;
    AnyRemoteOn           : Boolean;     //true if any of remotes fldigi,wsjt,or ADIF is active);

    ClearAfterFreqChange  : Boolean;
    ChangeFreqLimit       : Double;
    RepHead                :String;                //the heading for possible reply commands created
                                                  //includes message type #0 (change it)
    ContestNr             : integer;              //wsjtx 2.0 contest type definition in status msg

    ModeBeforeChange      : String; //flush CW buffer after mode change
    CurrentMyLoc          : String; //currently valid my locator global var and public for other units.
    EditViewMyLoc         : String;  //this is needed for exeption when edit/viev myloc is not CurrentMyloc

    property EditQSO : Boolean read fEditQSO write fEditQSO default False;
    property ViewQSO : Boolean read fViewQSO write fViewQSO default False;
    procedure ShowOperator;

    procedure DisableRemoteMode;   //Moved from private
    procedure SaveRemote;
    procedure GetCallInfo(callTOinfo,mode,rsts:string);    //used with wsjtx remote

    procedure OnBandMapClick(Sender:TObject;Call,Mode : String;Freq:Currency);
    procedure AppIdle(Sender: TObject; var Handled: Boolean);
    procedure ShowQSO;
    procedure NewQSO;
    procedure ClearAll;
    procedure ClearGrayLineMapLine;
    procedure SavePosition;
    procedure NewQSOFromSpot(call,freq,mode : String;FromRbn : Boolean = False);
    procedure SetEditLabel;
    procedure UnsetEditLabel;
    procedure SetSplit(s : String);
    procedure StoreClubInfo(where,StoreText : String);
    procedure SynCallBook;
    procedure SynDXCCTab;
    procedure SynDOKTab;
    procedure SynQSLTab;
    procedure CalculateLocalSunRiseSunSet;
    procedure UploadAllQSOOnline;
    procedure ReturnToNewQSO;
    procedure InitializeCW;
    procedure UpdateFKeyLabels;
    procedure RunVK(key_pressed: String);
    procedure RunST(script: String);
    procedure CreateAutoBackup;
  end;

  type
    TQRZThread = class(TThread)
    protected
      procedure Execute; override;
  end;

  type
    TDXCCTabThread = class(TThread)
    protected
      procedure Execute; override;
  end;

  type
    TDOKTabThread = class(TThread)
    protected
      procedure Execute; override;
  end;

  type
    TQSLTabThread = class(TThread)
    protected
      procedure Execute; override;
  end;


var
  frmNewQSO    : TfrmNewQSO;

  EscFirstPressDone : Boolean = True;
  multicast    : boolean = false;

  c_callsign  : String;
  c_nick      : String;
  c_qth       : String;
  c_address   : String;
  c_zip       : String;
  c_grid      : String;
  c_state     : String;
  c_county    : String;
  c_qsl       : String;
  c_iota      : String;
  c_waz       : String;
  c_itu       : String;
  c_dok       : String;
  c_ErrMsg    : String;
  c_SyncText  : String;
  c_running   : Boolean = False;
  c_lock      : Boolean = False;
  Azimuth     : String;

  minimalize    : Boolean;
  MinDXCluster  : Boolean;
  MinGrayLine   : Boolean;
  MinTRXControl : Boolean;
  MinNewQSO     : Boolean;
  MinQSODetails : Boolean;
  
implementation
  {$R *.lfm}

{ TfrmNewQSO }

uses dUtils, fChangeLocator, fChangeOperator, dDXCC, dDXCluster, dData, fMain, fSelectDXCC, fGrayline,
     fTRXControl, fPreferences, fSplash, fDXCluster, fDXCCStat,fQSLMgr, fSendSpot,
     fQSODetails, fWAZITUStat, fDOKStat, fIOTAStat, fGraphStat, fImportProgress, fBandMap,
     fLongNote, fRefCall, fKeyTexts, fCWType, fExportProgress, fPropagation, fCallAttachment,
     fQSLViewer, fCWKeys, uMyIni, fDBConnect, fAbout, uVersion, fChangelog,
     fBigSquareStat, fSCP, fRotControl, fLogUploadStatus, fRbnMonitor, fException, fCommentToCall,
     fRemind, fContest, fXfldigi, dMembership, dSatellite, fCountyStat,fFreq;



procedure TQSLTabThread.Execute;
var
  data   : string;
  FileDate : TDateTime;
begin
  FreeOnTerminate := True;
  if dmUtils.GetDataFromHttp(cQSLMgrVersionCheckUrl, data) then
  begin
   if (pos('NOT FOUND',upcase(data))=0) then
     begin
      FileDate := dmUtils.MyStrToDate(data);
      if FileDate > dmUtils.GetLastQSLUpgradeDate then
        Synchronize(@frmNewQSO.SynQSLTab)
     end
    else
     if dmData.DebugLevel>=1 then writeln (data);
  end;
end;


procedure TDXCCTabThread.Execute;
var
  data   : string;
  FileDate : TDateTime;
begin
  FreeOnTerminate := True;
  if dmUtils.GetDataFromHttp(cCntyVersionCheckUrl, data) then
  begin
    if (pos('NOT FOUND',upcase(data))=0) then
     begin
      FileDate := dmUtils.MyStrToDate(data);
      if FileDate > dmUtils.GetLastUpgradeDate then
          Synchronize(@frmNewQSO.SynDXCCTab)
     end
    else
     if dmData.DebugLevel>=1 then writeln (data);
  end
end;



procedure TDOKTabThread.Execute;
var
  data   : string;
  FileDate : TDateTime;
begin
  FreeOnTerminate := True;
  if dmUtils.GetDataFromHttp(cDOKVersionCheckUrl, data) then
  begin
    if (pos('NOT FOUND',upcase(data))=0) then
     begin
      FileDate := dmUtils.MyStrToDate(data);
      if FileDate > dmUtils.GetLastDOKUpgradeDate then
          Synchronize(@frmNewQSO.SynDOKTab)
     end
    else
     if dmData.DebugLevel>=1 then writeln (data);
  end
end;

procedure TfrmNewQSO.GetCallInfo(callTOinfo,mode,rsts:string);
var
  m,f :String;
begin
  if  edtCall.Text <> callTOinfo then  //call (and web info) maybe there already ok from pevious status packet
  begin
    m:= cmbMode.Text; //keep these while call is cleared
    f:= cmbFreq.Text;
    edtCall.Text := '';//clean grid like double ESC does
    Sleep(200); //to be sure edtCallChange has time to run;
    old_ccall := '';
    old_cfreq := '';
    old_cmode := '';
    edtCall.Text := callTOinfo;
    c_lock:=False;
    cmbMode.Text:=m;   //return these after new call is given
    cmbFreq.Text:=f;
    edtCallExit(nil);    //<--------this will fetch web info
    if dmData.DebugLevel>=1 then Writeln('GetCallInfo: Call was not there already');
    WaitWeb(2); // give time for web
  end;

  //mode and report may change if call stays same
  cmbMode.Text:=mode;
  edtMyRST.Text :='';
  rsts:=trim(rsts);
  if pos('-',rsts)>0 then
  begin
    if length(rsts)<3 then rsts:= rsts[1]+'0'+rsts[2]
  end
  else begin
  if length(rsts)=1 then
    rsts:= '+0'+rsts
  else
    rsts:= '+'+rsts
  end;
  edtHisRST.Text := rsts;
  SendToBack;
end;

procedure TfrmNewQSO.WaitWeb(secs:integer);
var
   l:integer;
Begin
  //set c_lock false before calling info fetch!
  for l:=1 to secs*10 do  //wait for web response sec timeout
  Begin
    if (( not c_lock) and c_running )then c_lock := true;
    sleep(100);
    Application.ProcessMessages;
    if ( c_lock and (not c_running ))then break;
  end;
end;

procedure TfrmNewQSO.SynDXCCTab;
begin
  if Application.MessageBox('New DXCC tables are available. Do you want to download and install it?','Question ...',
                            mb_YesNo + mb_IconQuestion) = idYes then
  begin
    with TfrmImportProgress.Create(self) do
    try
      Caption            := 'Downloading DXCC data ...';
      lblComment.Caption := 'Downloading DXCC data ...';
      ImportType := imptDownloadDXCCData;
      ShowModal;
    finally
      Free
    end;
    if (edtCall.Text = '') then
      ClearAll;                //reload combo boxes with prop modes and satelite names
    dmDXCC.ReloadDXCCTables;
    dmDXCluster.ReloadDXCCTables
  end
end;

procedure TfrmNewQSO.SynDOKTab;
begin
  if Application.MessageBox('New DOK tables are available. Do you want to download and install it?','Question ...',
                            mb_YesNo + mb_IconQuestion) = idYes then
  begin
    with TfrmImportProgress.Create(self) do
    try
      Caption            := 'Downloading DOK data ...';
      lblComment.Caption := 'Downloading DOK data ...';
      ImportType := imptDownloadDOKData;
      ShowModal;
    finally
      Free
    end;
    if (edtCall.Text = '') then
      ClearAll;                //reload combo boxes with prop modes and satelite names
  end
end;

procedure TfrmNewQSO.SynQSLTab;
begin
  if Application.MessageBox('New QSL managers database is available. Do you want to download and install it?','Question ...',
                            mb_YesNo + mb_IconQuestion) = idYes then
  begin
    with TfrmImportProgress.Create(self) do
    try
      Caption            := 'Downloading QSL managers ...';
      lblComment.Caption := 'Downloading QSL managers ...';
      ImportType := imptDownloadQSLData;
      ShowModal;
    finally
      Free
    end
  end
end;

procedure TQRZThread.Execute;
begin
  c_running := True;
  try
    c_nick     := '';
    c_qth      := '';
    c_address  := '';
    c_zip      := '';
    c_grid     := '';
    c_state    := '';
    c_county   := '';
    c_qsl      := '';
    c_iota     := '';
    c_ErrMsg   := '';
    c_waz      := '';
    c_itu      := '';
    c_dok      := '';

    FreeOnTerminate:= True;
    c_SyncText := 'Working ...';
    Synchronize(@frmNewQSO.SynCallBook);
    dmUtils.GetCallBookData(c_callsign,c_nick,c_qth,c_address,c_zip,c_grid,c_state,c_county,c_qsl,c_iota,c_waz,c_itu, c_dok, c_ErrMsg);
    c_SyncText := '';
    Synchronize(@frmNewQSO.SynCallBook)
  finally
    c_running := False
  end
end;

procedure TfrmNewQSO.SetDateTime(EndTime : Boolean =  True);
var
  date  : TDateTime;
  Mask  : String;
  sDate : String;
begin
  Mask  := '';
  sDate := '';
  date := dmUtils.GetDateTime(0);
  edtDate.Clear;
  dmUtils.DateInRightFormat(date,Mask,sDate);
  edtDate.Text      := sDate;
  edtStartTime.Text := FormatDateTime('hh:mm',date);
  if EndTime then
    edtEndTime.Text   := FormatDateTime('hh:mm',date);
end;

procedure TfrmNewQSO.InsertNameQTH;
var
  sName, QTH, loc  : String;
  county, qsl_via  : String;
  award,state, dok : String;
  qslrdate         : String;
  eqslrdate        : String;
  lotw_qslrdate    : String;
  waz, itu         : String;
begin
  sName    := '';
  QTH      := '';
  loc      := '';
  county   := '';
  qsl_via  := '';
  award    := '';
  state    := '';
  dok      := '';
  qslrdate := '';
  eqslrdate :='';
  lotw_qslrdate :='';
  waz      := '';
  itu      := '';
  
  if dmData.qQSOBefore.RecordCount > 0 then
  begin
    try
      dmData.qQSOBefore.DisableControls;
      dmData.qQSOBefore.Last;
      while (not dmData.qQSOBefore.bof) do
      begin
        if (sName = '') then
          sName := dmData.qQSOBefore.FieldByName('name').AsString;
        if (qth = '') and (dmData.qQSOBefore.FieldByName('callsign').AsString=edtCall.Text) then
          qth := dmData.qQSOBefore.FieldByName('qth').AsString;
        if (loc = '') and (dmData.qQSOBefore.FieldByName('callsign').AsString=edtCall.Text) then
          loc := dmData.qQSOBefore.FieldByName('loc').AsString;
        if (county = '') and (dmData.qQSOBefore.FieldByName('callsign').AsString=edtCall.Text) then
          county := dmData.qQSOBefore.FieldByName('county').AsString;
        if (qsl_via = '') and (dmData.qQSOBefore.FieldByName('callsign').AsString=edtCall.Text) then
          qsl_via := dmData.qQSOBefore.FieldByName('qsl_via').AsString;
        if (award = '') then
          award := dmData.qQSOBefore.FieldByName('award').AsString;
        if (state = '') and (dmData.qQSOBefore.FieldByName('callsign').AsString=edtCall.Text) then
          state := dmData.qQSOBefore.FieldByName('state').AsString;
        if (dok = '') and (dmData.qQSOBefore.FieldByName('callsign').AsString=edtCall.Text) then
          dok := dmData.qQSOBefore.FieldByName('dok').AsString;
        if (qslrdate = '') and (not dmData.qQSOBefore.FieldByName('qslr_date').IsNull) then
          QSLcfm := dmData.qQSOBefore.FieldByName('qslr_date').AsString+'  '+
                    dmData.qQSOBefore.FieldByName('band').AsString+'  QSL rcvd';
        if (lotw_qslrdate = '') and (not dmData.qQSOBefore.FieldByName('lotw_qslrdate').IsNull) then
          LoTWcfm := dmData.qQSOBefore.FieldByName('lotw_qslrdate').AsString+'  '+
                     dmData.qQSOBefore.FieldByName('band').AsString+'  LoTW cfmd';
        if (eqslrdate = '') and (not dmData.qQSOBefore.FieldByName('eqsl_qslrdate').IsNull) then
          eQSlcfm := dmData.qQSOBefore.FieldByName('eqsl_qslrdate').AsString+'  '+
                     dmData.qQSOBefore.FieldByName('band').AsString+'  eQSL rcvd';
        if (waz = '') and (dmData.qQSOBefore.FieldByName('callsign').AsString=edtCall.Text) then
          waz := dmData.qQSOBefore.FieldByName('waz').AsString;
        if (itu = '') and (dmData.qQSOBefore.FieldByName('callsign').AsString=edtCall.Text) then
          itu := dmData.qQSOBefore.FieldByName('itu').AsString;

        dmData.qQSOBefore.Prior
      end;

    finally
      dmData.qQSOBefore.Last;  //after this, dbgrid is not set to last record
      dmData.qQSOBefore.EnableControls;
      dmData.qQSOBefore.Last
    end;

    if (edtName.Text = '') then
      edtName.Text := sName;
    if (edtQTH.Text = '') then
      edtQTH.Text := qth;
    if (edtGrid.Text = '') then
      edtGrid.Text := loc;
    if (edtCounty.Text = '') then
      edtCounty.text := county;
    if (edtQSL_VIA.Text = '') then
      edtQSL_VIA.Text := qsl_via;
    if (edtAward.Text = '') and cqrini.ReadBool('NewQSO','FillAwardField',True) then
      edtAward.Text := award;
    if (edtState.Text = '') then
      edtState.Text := state;
    if (edtDOK.Text = '') then
      edtDOK.Text := dok;
    if (waz <> '') then
      edtWAZ.Text := waz;
    if (itu <> '') then
      edtITU.Text := itu
  end
end;

Procedure TfrmNewQSO.ShowCountryInfo;
var
  index : Integer;
begin
  if (edtCall.Text = '') then
    exit;
  index := 0;
  lblCountryInfo.Caption := dmDXCC.DXCCInfo(adif, cmbFreq.Text, cmbMode.Text,index);
  if pos('UNKN',Uppercase(lblCountryInfo.Caption))>0 then lblCountryInfo.Font.Color:=clRed;
  if pos('CONF',Uppercase(lblCountryInfo.Caption))>0 then lblCountryInfo.Font.Color:=clGreen;
  if pos('NEW C',Uppercase(lblCountryInfo.Caption))>0 then
  lblCountryInfo.Font.Color:=cqrini.ReadInteger('DXCluster','NewCountry',0);
  if pos('NEW B',Uppercase(lblCountryInfo.Caption))>0 then
  lblCountryInfo.Font.Color:=cqrini.ReadInteger('DXCluster','NewBand',0);
  if pos('NEW M',Uppercase(lblCountryInfo.Caption))>0 then
  lblCountryInfo.Font.Color:=cqrini.ReadInteger('DXCluster','NewMode',0);
  lblCountryInfo.Refresh;
end;

procedure TfrmNewQSO.ShowDXCCInfo(ref_adif : Word = 0);
var
  cont, country, WAZ, ITU, pfx : string;
  Date : TDateTime;
  lat, long : String;
  sDate : String = '';
  Delta : Currency;
  sDelta : String;
begin
  cont    := '';
  country := '';
  waz     := '';
  posun   := '';
  itu     := '';
  lat     := '';
  long    := '';
  if not dmUtils.IsDateOK(edtDate.Text) then
    exit;
    
  if ref_adif = 0 then
  begin
    Date := dmUtils.StrToDateFormat(edtDate.Text);
    adif := dmDXCC.id_country(edtCall.Text,edtState.Text,date,pfx, cont, country, WAZ, posun, ITU, lat, long);
    dmUtils.ModifyWAZITU(waz,itu);
    sDelta := posun
  end
  else begin
     dmDXCC.qDXCCRef.Close;
     dmDXCC.qDXCCRef.SQL.Text := 'SELECT * FROM cqrlog_common.dxcc_ref WHERE adif = ' + IntToStr(adif);
     dmDXCC.qDXCCRef.Open;
     if dmDXCC.qDXCCRef.RecordCount > 0 then
     begin
       pfx     := dmDXCC.qDXCCRef.FieldByName('pref').AsString;
       cont    := dmDXCC.qDXCCRef.FieldByName('CONT').AsString;
       lat     := dmDXCC.qDXCCRef.FieldByName('LAT').AsString;
       long    := dmDXCC.qDXCCRef.FieldByName('longit').AsString;
       country := dmDXCC.qDXCCRef.FieldByName('name').AsString;;
       waz     := dmDXCC.qDXCCRef.FieldByName('WAZ').AsString;
       itu     := dmDXCC.qDXCCRef.FieldByName('ITU').AsString;
       sDelta  := dmDXCC.qDXCCRef.FieldByName('utc').AsString
     end;
     dmDXCC.qDXCCRef.Close
  end;
  if not TryStrToCurr(sDelta,Delta) then
    Delta := 0;
  Date := dmUtils.GetDateTime(Delta);
  dmUtils.DateInRightFormat(date,sDelta,sDate);
  lblHisTime.Caption := sDate + '  ' + TimeToStr(Date) + '     ';
  lblGreeting.Caption := dmUtils.GetGreetings(lblHisTime.Caption);
  mCountry.Clear;
  mCountry.Lines.Add(country);
  if QSLcfm<>'' then mCountry.Lines.Add(QSLcfm);
  if eQSLcfm<>'' then mCountry.Lines.Add(eQSLcfm);
  if LoTWcfm<>'' then mCountry.Lines.Add(LoTWcfm);
  mCountry.Repaint;
  if not (fEditQSO or fViewQSO) then
  begin
    lblWAZ.Caption  := WAZ;
    lblITU.Caption  := itu;
    edtWAZ.Text     := WAZ;
    edtITU.Text     := ITU;
  end;
  lblDXCC.Caption := pfx;
  lblCont.Caption := cont;
  edtDXCCRef.Text := pfx;
  lblLat.Caption  := lat;
  lblLong.Caption := long;
  if (pfx='!') or (pfx='#') then ClearGrayLineMapLine;

  showDOK(pfx='DL');
end;
procedure TfrmNewQSO.ClearGrayLineMapLine;
var
  lat,long :currency;
Begin
  dmUtils.ModifyXplanetQso;
  frmGrayLine.ob^.GC_line_clear; //clear short and long path lines
  dmUtils.CoordinateFromLocator(dmUtils.CompleteLoc(CurrentMyLoc),lat,long);
  lat := lat*-1;
  frmGrayLine.ob^.jachcucaru(true,long,lat,long+0.03,lat+0.03); //trying to make own qth dot a bit bigger
                                                                //the Grayline window zoom affects to visibility anyhow
  frmGrayline.Refresh;
  frmRotControl.BeamDir:=-1;
end;

procedure TfrmNewQSO.ClearAll;
var
  i      : Integer;
  sDate,
  Mask,
  tmp    : String;
  date   : TDateTime;
  sTimeOn  : String = '';
  sTimeOff : String = '';
  ShowRecentQSOs : Boolean = False;
  ShowB4call     : Boolean = False;
  RecentQSOCount : Integer = 0;
  since  : String;
  lat,long,p : Currency;
begin
  if fViewQSO then
  begin
    if (not (fViewQSO or fEditQSO or cbOffline.Checked)) then
      tmrRadio.Enabled := True;
    btnSave.Enabled  := True;
    for i:=0 to ComponentCount-1 do
    begin
      if (frmNewQSO.Components[i] is TEdit) then
         (frmNewQSO.Components[i] As TEdit).ReadOnly := False;
    end;
    edtDate.ReadOnly  := False;
    mComment.ReadOnly := False;
    edtDXCCRef.ReadOnly:=True;  //we allow only DXCCs from list, no free type
  end;
  sbtnQRZ.Visible        := False;
  sbtnLoTW.Visible       := False;
  sbtneQSL.Visible       := False;
  sbtnHamQTH.Visible     := False;
  sbtnLocatorMap.Visible := False;
  sbtnUsrBtn.Visible     := False;
  TabUsed    := False;
  fromNewQSO := False;
  FromDXC  := False;

  old_stat_adif := 0;
  old_adif := 0;
  lblQSOTakes.Visible := False;
  lblWAZ.Caption     := '';
  lblDXCC.Caption    := '';
  lblITU.Caption     := '';
  lblLat.Caption     := '';
  lblLong.Caption    := '';
  lblCont.Caption    := '';
  lblHisTime.Caption := '';
  lblQRA.Caption     := '';
  lblAzi.Caption     := '';
  lblGreeting.Caption := '';
  lblTarSunRise.Caption := '';
  lblTarSunSet.Caption  := '';
  mCountry.Clear;
  mComment.Clear;
  QTHfromCb := False;
  lblAmbiguous.Visible := False;
  old_call := '';
  idcall  := '';   //without this 2ESC when cursor is at cmbfreq(Auto=unchecked) restores club->award text after clearall
  old_time := '';
  old_rstr := '';
  old_rsts := '';
  QSLcfm:= '';
  eQSLcfm := '';
  LoTWcfm := '';
  lblCountryInfo.Caption := '';
  Mask  := '';
  lblQSONr.Caption := '0';
  mCallBook.Clear;
  dmData.qQSOBefore.Close;
  lblIOTA.Font.Color := clDefault;
  idcall := ''; //OH1KH: this line fixes issue #201 but does it something wrong elsewhere? (I did not notice)
  showDOK(false);
  if frmQSODetails.Showing then
  begin
    frmQSODetails.ClearAll;
    frmQSODetails.ClearStat
  end;

  if cbOffline.Checked then
  begin
    sTimeOn  := edtStartTime.Text;
    sTimeOff := edtEndTime.Text;
    sDate    := edtDate.Text
  end;

  for i:=0 to ComponentCount-1 do
  begin
    if (frmNewQSO.Components[i] is TEdit) then
      (frmNewQSO.Components[i] As TEdit).Text := ''
    else
      if (frmNewQSO.Components[i] is TComboBox) then
        (frmNewQSO.Components[i] As TComboBox).Text := ''
  end;
  dmUtils.InsertModes(cmbMode);
  dmUtils.InsertFreq(cmbFreq);
  dmSatellite.GetListOfSatellites(cmbSatellite, old_sat);
  dmSatellite.GetListOfPropModes(cmbPropagation, old_prop);
  edtRXFreq.Text := old_rxfreq;

  cbSpotRX.Checked := cqrini.ReadBool('DXCluster', 'SpotRX', False);

  cbTxLo.Checked := cqrini.ReadBool('NewQSO', 'UseTXLO', False);
  cbSplitTX.Checked:= cqrini.ReadBool('NewQSO', 'UseSplitTX', False);
  edtTXLO.Text   := cqrini.ReadString('NewQSO', 'TXLO', '');
  cbRxLo.Checked := cqrini.ReadBool('NewQSO', 'UseRXLO', False);
  edtRXLO.Text   := cqrini.ReadString('NewQSO', 'RXLO', '');

  if cbOffline.Checked then
  begin
    edtStartTime.Text := sTimeOn;
    edtEndTime.Text   := sTimeOff;
    edtDate.Text      := sDate
  end;

  dmData.InsertProfiles(cmbProfiles,False);
  if old_prof = -1 then
    cmbProfiles.Text := dmData.GetDefaultProfileText
  else begin
    cmbProfiles.Text := dmData.GetProfileText(old_prof)
  end;
  //if cmbProfiles.Text <> '' then
     //cmbProfilesChange(nil);

  if fEditQSO or fViewQSO then
    Begin
      cmbProfiles.Text := UsrAssignedProfile;
      Op := cqrini.ReadString('TMPQSO','OP','');
      ShowOperator;
      fEditQSO := False;
      fViewQSO := False;
    end;

  if sbNewQSO.Panels[0].Text = '' then
    sbNewQSO.Panels[0].Text := cMyLoc + CurrentMyLoc;

  cmbFreq.Text := cqrini.ReadString('TMPQSO','FREQ',cqrini.ReadString('NewQSO','FREQ','7.025'));
  cmbMode.Text := cqrini.ReadString('TMPQSO','Mode',cqrini.ReadString('NewQSO','Mode','CW'));

  edtPWR.Text  := cqrini.ReadString('TMPQSO','PWR',cqrini.ReadString('NewQSO','PWR','100'));

  edtHisRST.Text := cqrini.ReadString('NewQSO', 'RST_S', '599');
  edtMyRST.Text  := cqrini.ReadString('NewQSO', 'RST_R', '599');

  edtRemQSO.Text := cqrini.ReadString('NewQSO','RemQSO','');

  cbOffline.Checked := cqrini.ReadBool('TMPQSO','OFF',False);
  cmbQSL_S.Text     := cqrini.ReadString('NewQSO','QSL_S','');

  ShowRecentQSOs := cqrini.ReadBool('NewQSO','ShowRecentQSOs',False);
  RecentQSOCount := cqrini.ReadInteger('NewQSO','RecQSOsNum',5);
  ShowB4call :=  cqrini.ReadBool('NewQSO','ShowB4call',False);
  if NOT cbOffline.Checked then
  begin
    date := dmUtils.GetDateTime(0);
    edtDate.Clear;
    dmUtils.DateInRightFormat(date,Mask,sDate);
    edtDate.Text      := sDate;
    edtStartTime.Text := FormatDateTime('hh:mm',date);
    edtEndTime.Text   := FormatDateTime('hh:mm',date)
  end;
  tmrRadio.Enabled  := True;
  if ShowRecentQSOs or ShowB4call then
  begin
    since := dmUtils.MyDateToStr(now - RecentQSOCount);
    dmData.qQSOBefore.Close;
    dmData.trQSOBefore.Rollback;
    dmData.qQSOBefore.SQL.Text := 'select * from view_cqrlog_main_by_qsodate where qsodate >= '+QuotedStr(since)+
                                   ' order by qsodate,time_on';
       if ShowB4call then dmData.qQSOBefore.SQL.Text := 'SELECT * FROM view_cqrlog_main_by_qsodate WHERE callsign = '+
                                    QuotedStr(was_call)+' ORDER BY qsodate,time_on';
    if dmData.DebugLevel>=1 then Writeln(dmData.qQSOBefore.SQL.Text);
    dmData.trQSOBefore.StartTransaction;
    dmData.qQSOBefore.Open;
    ShowFields;
    dmData.qQSOBefore.DisableControls;
    dmData.qQSOBefore.Last;
    dmData.qQSOBefore.EnableControls;
  end;
  ChangeCallBookCaption;
  dmUtils.ClearStatGrid(sgrdStatistic);
  dmUtils.AddBandsToStatGrid(sgrdStatistic);
  dmUtils.ClearStatGrid(sgrdCallStatistic);
  dmUtils.AddBandsToStatGrid(sgrdCallStatistic);
  tabDXCCStat.Caption:='DXCC statistic';
  tabCallStat.Caption:='Call statistic';
  ClearGrayLineMapLine;

  if not AnyRemoteOn then
                       ReturnToNewQSO;
  if not (fEditQSO or fViewQSO or cbOffline.Checked) then
    tmrStart.Enabled := True;
  tmrEnd.Enabled := False;
  FromDXC := False;
  lblQSLMgr.Visible := False;
  sbNewQSO.Panels[1].Text := '';
  sbtnAttach.Visible := False;
  sbtnQSL.Visible    := False;
  ChangeDXCC := False;
  adif := 0;
  FreqBefChange := frmTRXControl.GetFreqMHz;
  dmUtils.HamClockSetNewDE(CurrentMyloc,'','',UpperCase(cqrini.ReadString('Station', 'Call', '')));
  dmUtils.HamClockSetNewDX('','',CurrentMyloc);   //a way to clear SP/LP line (but draws vertical line instead)
  DetailsCMBColorDone:='';

  btnCancel.Hint:='';
  btnCancel.ShowHint:=False;

  btnCancel.Caption:='Quit [CTRL+Q]';
  btnCancel.Font.Color:=clDefault;
  btnCancel.Font.Style:=[];
  btnCancel.Repaint;
  Application.ProcessMessages;

end;

procedure TfrmNewQSO.LoadSettings;
begin
  dmUtils.ModifyXplanetConf;
  dmUtils.LoadFontSettings(frmNewQSO);

  dmUtils.LoadBandLabelSettins;
  sbNewQSO.Panels[0].Width := 180;
  sbNewQSO.Panels[1].Width := 200;
  sbNewQSO.Panels[2].Width := 200;
  sbNewQSO.Panels[3].Text  := 'Ver. '+ dmData.VersionString;
  sbNewQSO.Panels[3].Width := 150;
  sbNewQSO.Panels[4].Width :=  50;

  dmUtils.LoadWindowPos(frmNewQSO);

  UseSpaceBar := cqrini.ReadBool('NewQSO','UseSpaceBar',False);
  dbgrdQSOBefore.Visible := cqrini.ReadBool('NewQSO','ShowGrd',True);
  sbNewQSO.Visible := cqrini.ReadBool('NewQSO','StatBar',True);
  acShowStatBar.Checked := sbNewQSO.Visible;

  dmData.LoadQSODateColorSettings;

  if cqrini.ReadBool('CW', 'NoReset', false) then     //is set: user does not want reset CW keyer at rig switch/init
                                        InitializeCW; //so we have to do it at least once: Here.

  Op := cqrini.ReadString('NewQSO', 'Op', '');
  if OP<>'' then
   begin
    cqrini.WriteString('TMPQSO','OP',Op);
    ShowOperator;
   end;

  if dbgrdQSOBefore.Visible then
    mnuQSOBefore.Caption := 'Disable QSO before grid'
  else
    mnuQSOBefore.Caption := 'Enable QSO before grid';

  if cqrini.ReadBool('Window','Grayline',False) then
    frmGrayline.Show;

  if cqrini.ReadBool('Window','TRX',False) then
  begin
    frmTRXControl.Show;
    frmTRXControl.BringToFront
  end;

   if cqrini.ReadBool('Window','ROT',False) then
  begin
    frmRotControl.Show;
    frmRotControl.BringToFront
  end;

  if frmTRXControl.Showing then
      tmrRadio.Interval := cqrini.ReadInteger('TRX'+IntToStr(frmTRXControl.cmbRig.ItemIndex),'Poll',500);

  cbTxLo.Checked := cqrini.ReadBool('NewQSO', 'UseTXLO', False);
  edtTXLO.Text   := cqrini.ReadString('NewQSO', 'TXLO', '');
  cbRxLo.Checked := cqrini.ReadBool('NewQSO', 'UseRXLO', False);
  edtRXLO.Text   := cqrini.ReadString('NewQSO', 'RXLO', '');

  cbSpotRX.Checked := cqrini.ReadBool('DXCluster', 'SpotRX', False);

  if frmRotControl.Showing then
  begin
    if frmRotControl.rbRotor1.Checked then
      tmrRotor.Interval := cqrini.ReadInteger('ROT1','Poll',500)
    else
      tmrRotor.Interval := cqrini.ReadInteger('ROT2','Poll',500)
  end
  else begin
    tmrRotor.Interval := cqrini.ReadInteger('ROT1','Poll',500)
  end;

  if cqrini.ReadBool('Window','Details',True) then
  begin
    frmQSODetails.Show;
    frmQSODetails.BringToFront
  end;

  if cqrini.ReadBool('Window','BandMap',False) then
  begin
    frmBandMap.Show;
    frmBandMap.BringToFront
  end;

  if cqrini.ReadBool('Window','SCP',False) then
  begin
    frmSCP.Show;
    frmSCP.BringToFront
  end;

  if cqrini.ReadBool('xplanet','run',False) then
    dmUtils.RunXplanet;

  if cqrini.ReadBool('Window','Prop',False) then
    frmPropagation.Show;

  if cqrini.ReadBool('Window','pDK0WCY',False) then
    frmPropDK0WCY.Show;

   if cqrini.ReadBool('Window','WorkedGrids',False) then
    frmWorkedGrids.Show;

  if cqrini.ReadBool('Window','CWKeys',False) then
    acCWFKey.Execute;

  if cqrini.ReadBool('Window','QSOList',False) then
    acQSOList.Execute;

  if cqrini.ReadBool('Window','LogUploadStatus', False) then
    acLogUploadStatus.Execute;

  if cqrini.ReadBool('Window','CWType',False) then
    acCWType.Execute;


  CheckForExternalTablesUpdate;

  if cqrini.ReadBool('Window','RBNMonitor',False) then
    acRBNMonitor.Execute;

  if cqrini.ReadBool('Window','Dxcluster',False) then
  begin
    frmDXCluster.Show;
    frmDXCluster.BringToFront
  end;

  if cqrini.ReadBool('Window','Contest',False) then
    acContest.Execute;

  if not cqrini.ReadBool('NewQSO','SatelliteMode', False) then
      if  (cqrini.ReadInteger('NewQSO','DetailsTabIndex', 0)>1 ) then
          cqrini.WriteInteger('NewQSO','DetailsTabIndex',1);

  frmNewQSO.pgDetails.TabIndex:=  cqrini.ReadInteger('NewQSO','DetailsTabIndex', 0);
  frmNewQSO.pgDetails.Pages[2].TabVisible := cqrini.ReadBool('NewQSO','SatelliteMode', False);
  frmNewQSO.pgDetails.Pages[3].TabVisible := cqrini.ReadBool('NewQSO','SatelliteMode', False);

  //this have to be done here when log is selected (settings at database)
  frmReminder.chRemi.Checked := cqrini.ReadBool('Reminder','chRemi',False);
  frmReminder.chUTRemi.Checked := cqrini.ReadBool('Reminder','chUTRemi',False);
  frmReminder.RemindTimeSet.EditText := cqrini.ReadString('Reminder','RemindTimeSet','000');
  frmReminder.RemindUThour.EditText := cqrini.ReadString('Reminder','RemindUThour','00:00');
  frmReminder.RemiMemo.Lines.Clear;
  frmReminder.RemiMemo.Lines.Add(cqrini.ReadString('Reminder','RemiMemo',''));
  frmReminder.btCloseClick(nil);

  dmUtils.InsertQSL_S(cmbQSL_S);
  dmUtils.InsertQSL_R(cmbQSL_R);

  frmBandMap.LoadSettings;
  frmBandMap.LoadFonts;

  if cqrini.ReadBool('BandMap', 'Save', False) then
    frmBandMap.LoadBandMapItemsFromFile(dmData.HomeDir+'bandmap.csv');

  ClearAfterFreqChange := False;//cqrini.ReadBool('NewQSO','ClearAfterFreqChange',False);
  ChangeFreqLimit      := cqrini.ReadFloat('NewQSO','FreqChange',0.010);

  CalculateLocalSunRiseSunSet;
  tmrRadio.Enabled := True;
  dmData.InsertProfiles(cmbProfiles,False);
  cmbProfiles.Text := dmData.GetDefaultProfileText;
  ChangeCallBookCaption;
  BringToFront;
  if not StartRun then
   Begin   //run "when cqrlog is starting" -script
    RunST('start.sh');
    StartRun := true;
   end;
end;

procedure TfrmNewQSO.CloseAllWindows;
begin
  dmUtils.SaveDBGridInForm(frmNewQSO) ;
  tmrRadio.Enabled := False;
  tmrEnd.Enabled   := False;
  tmrStart.Enabled := False;

  if Assigned(cqrini) then
  begin
    cqrini.WriteBool('Window','CWKeys',frmCWKeys.Showing);

    //I have to close window manually because of bug in lazarus.

    if frmGrayline.Showing then
    begin
      frmGrayline.Close;
      cqrini.WriteBool('Window','Grayline',True)
    end
    else
      cqrini.WriteBool('Window','Grayline',False);

    if frmTRXControl.Showing then
    begin
      frmTRXControl.Close;
      cqrini.WriteBool('Window','TRX',True)
    end
    else begin
      cqrini.WriteBool('Window','TRX',False)
    end;
    frmTRXControl.CloseRigs;

    if frmRotControl.Showing then
    begin
      frmRotControl.Close;
      cqrini.WriteBool('Window','ROT',True)
    end
    else
      cqrini.WriteBool('Window','ROT',False);

    if frmDXCluster.Showing then
    begin
      frmDXCluster.Close;
      cqrini.WriteBool('Window','Dxcluster',True)
    end
    else
      cqrini.WriteBool('Window','Dxcluster',False);

    if frmQSODetails.Showing then
    begin
      frmQSODetails.Close;
      cqrini.WriteBool('Window','Details',True)
    end
    else
      cqrini.WriteBool('Window','Details',False);

    if frmBandMap.Showing then
    begin
      frmBandMap.Close;
      cqrini.WriteBool('Window','BandMap',True)
    end
    else
      cqrini.WriteBool('Window','BandMap',False);

    if frmPropagation.Showing then
    begin
      frmPropagation.Close;
      cqrini.WriteBool('Window','Prop',True)
    end
    else
      cqrini.WriteBool('Window','Prop',False);

    if frmPropDK0WCY.Showing then
    begin
      frmPropDK0WCY.Close;
      cqrini.WriteBool('Window','pDK0WCY',True)
    end
    else
      cqrini.WriteBool('Window','pDK0WCY',False);

   if frmWorkedGrids.Showing then
    begin
      frmWorkedGrids.Close;
      cqrini.WriteBool('Window','WorkedGrids',True)
    end
    else
      cqrini.WriteBool('Window','WorkedGrids',False);

   if (frmMonWsjtx <> nil) and frmMonWsjtx.Showing then
     begin
       frmMonWsjtx.Close;
     end;

    if frmCWKeys.Showing then
    begin
      frmCWKeys.Close;
      cqrini.WriteBool('Window','CWKeys',True)
    end
    else
      cqrini.WriteBool('Window','CWKeys',False);

    if frmSCP.Showing then
    begin
      cqrini.WriteBool('Window','SCP',True);
      frmSCP.Close
    end
    else
      cqrini.WriteBool('Window','SCP',False);

    if frmMain.Showing then
    begin
      cqrini.WriteBool('Window','QSOList',True);
      frmMain.Close
    end
    else
      cqrini.WriteBool('Window','QSOList',False);

    if frmLogUploadStatus.Showing then
    begin
      cqrini.WriteBool('Window','LogUploadStatus', True);
      frmLogUploadStatus.Close
    end
    else
      cqrini.WriteBool('Window','LogUploadStatus', False);

    if frmCWType.Showing then
    begin
      cqrini.WriteBool('Window','CWType',True);
      frmCWType.Close
    end
    else
      cqrini.WriteBool('Window','CWType',False);

    if frmRBNMonitor.Showing then
    begin
      cqrini.WriteBool('Window','RBNMonitor',True);
      frmRBNMonitor.Close
    end
    else
      cqrini.WriteBool('Window','RBNMonitor',False)
  end ;

  if frmContest.Showing then
    begin
      cqrini.WriteBool('Window','Contest',True);
      frmContest.Close
    end
    else
      cqrini.WriteBool('Window','Contest',False)

end;

procedure TfrmNewQSO.SaveSettings;
begin

  if Assigned(CWint) then
  begin
    CWint.Close;
    FreeAndNil(CWint)
  end ;

  cqrini.DeleteKey('TMPQSO','OFF');
  cqrini.DeleteKey('TMPQSO','FREQ');
  cqrini.DeleteKey('TMPQSO','Mode');
  cqrini.DeleteKey('TMPQSO','PWR');
  cqrini.DeleteKey('TMPQSO','OP');
  cqrini.WriteBool('NewQSO','AutoMode',chkAutoMode.Checked);
  cqrini.WriteInteger('NewQSO','DetailsTabIndex', pgDetails.TabIndex);
  SavePosition;
  cqrini.WriteBool('NewQSO','ShowGrd',dbgrdQSOBefore.Visible);
  if cqrini.ReadBool('xplanet','close',False) then
    dmUtils.CloseXplanet;
  cqrini.SaveToDisk;
  dmData.SaveConfigFile;
end;

procedure TfrmNewQSO.FormShow(Sender: TObject);
var
  ini       : TIniFile;
  changelog : Boolean = False;

begin
  with TfrmDBConnect.Create(self) do
  begin
    try
      ShowModal;
      if ModalResult <> mrOK then
      begin
        Application.Terminate;
        exit
      end
      else
        frmNewQSO.Caption := dmUtils.GetNewQSOCaption('New QSO')
    finally
      Free
    end;
  end;  //without this begin-end editor offers "finally; end" for every new line entered until end of procedure

  ini := TIniFile.Create(GetAppConfigDir(False)+'cqrlog_login.cfg');
  try
    if ini.ReadString('Changelog','Version','') <> cVERSION then
    begin
      changelog := True;
      ini.WriteString('Changelog','Version',cVERSION)
    end
  finally
    ini.Free
  end;

 if changelog then
  begin
    with TfrmChangelog.Create(Application) do
    try
      ViewChangelog;
      ShowModal
    finally
      Free
    end
  end;

  if not (Sender = nil) then
    LoadSettings;

  frmBandMap.OnBandMapClick := @OnBandMapClick;

  old_ccall := '';
  old_cmode := '';
  old_cfreq := '';

  QSLcfm    := '';
  eQSLcfm   := '';
  LoTWcfm   := '';

  Running      := False;
  EscFirstPressDone := False;
  ChangeDXCC   := False;

  RemoteActive:='';

  CurrentMyLoc := cqrini.ReadString('Station','LOC','');
  ClearAll;
  dmUtils.AddBandsToStatGrid(sgrdStatistic);
  dmUtils.AddBandsToStatGrid(sgrdCallStatistic);
  ReturnToNewQSO;
  tmrRadio.Enabled := True;
  tmrStart.Enabled := True;
  if cqrini.ReadBool('Modes', 'Rig2Data', False) then chkAutoMode.Font.Color:=clRed;
  dmUtils.UpdateHelpBrowser;
  dmSatellite.SetListOfSatellites(cmbSatellite); //load combo box lists
  dmSatellite.SetListOfPropModes(cmbPropagation);

  ModeBeforeChange := cmbMode.Text;
  UsrAssignedProfile:= cmbProfiles.Text;   //initial value

  if cqrini.ReadString('Station','Call','') = '' then
     NewLogSplash;

   dmUtils.UpdateCallBookcnf;  //renames old user and pass of ini file
   FirstClose:=True;
end;

procedure TfrmNewQSO.tmrEndStartTimer(Sender: TObject);
begin
  tmrEndTimer(nil)
end;

procedure TfrmNewQSO.tmrEndTimer(Sender: TObject);
var
  Date  : TDateTime;
  sDate : String='';
  Mask  : String='';
  Takes : TDateTime;
  h,m,s : Word;
  ms    : Word = 0;
begin
  h := 0;
  m := 0;
  s := 0;
  if not cbOffline.Checked then
  begin
    lblQSOTakes.Visible := True;

    if cqrini.ReadBool('Fonts','UseDefault',True) then
    begin
      lblQSOTakes.Font.Name := 'default';
      lblQSOTakes.Font.Size := 0
    end
    else begin
      lblQSOTakes.Font.Name := cqrini.ReadString('Fonts','Buttons','Sans 10');
      lblQSOTakes.Font.Size := cqrini.ReadInteger('Fonts','bSize',10)
    end;

    date := dmUtils.GetDateTime(0);
    dmUtils.DateInRightFormat(date,Mask,sDate);
    edtEndTime.Text   := FormatDateTime('hh:mm',date);
    Takes := StartTime - Date;
    DecodeTime(Takes,h,m,s,ms);
    lblQSOTakes.Caption := 'QSO takes: ' + AddChar('0',IntToStr(h),2) + 'hr '
                                         + AddChar('0',IntToStr(m),2) + 'min '
                                         + AddChar('0',IntToStr(s),2) + 'sec'
  end
end;

procedure TfrmNewQSO.tmrFldigiTimer(Sender: TObject);
    type
      PMyMsgBuf = ^TMyMsgBuf;
      TMyMsgBuf = record
        mtype : PtrInt;
        mtext : array[0..1024] of char;
      end;

    procedure DoError (Const Msg : string);
    begin
      Writeln (msg,' returned an error : ',fpgeterrno);
    end;

var
  ID    : longint;
  Buf   : TMyMsgBuf;
  i     : Integer;
  logged,
  Mo    :TStringList;
  mhz,
  mode,
  submode,
  Mask,
  data  : String;
begin

 if FldigiXmlRpc then
    frmxfldigi.TimTime
 else
 Begin
  ID:=msgget(1238,IPC_CREAT or 438);
  If ID<0 then DoError('MsgGet');
  Buf.MType:=1024;
  while msgrcv(ID,PMSGBuf(@Buf),1024,0,0 or IPC_NOWAIT)<>-1 do
  begin
    ClearAll;
    cbOffline.Checked := True;
    Mo:= TStringList.create;
    Mo.Delimiter := ',';
    Mo.DelimitedText:='JAN,FEB,MAR,APR,MAY,JUN,JUL,AUG,SEP,OCT,NOV,DEC';
    logged:=TStringlist.Create;
    if dmData.DebugLevel>=1 then
    Begin
        Writeln ('Type : ',buf.mtype,' Text : ',buf.mtext);
        frmMonWsjtx.BufDebug('',buf.mtext);
    end;
    data := buf.mtext;
    While length(data)>0 do
     Begin
        i:= pos(#01,data);
        Mask:=copy(data,1,i-1);
        data := copy(data,i+1, length(data));
        Mask[pos(':',Mask)]:='=';
        if dmData.DebugLevel>=1 then
               writeln(Mask);
        logged.Add(Mask);
     end;
    {
     A QSO record contents after placing buf.mtext to string list value pairs:
     program=fldigi v 4.1.20.36
     version=1
     date=30 Mar 2022
     TIME=1509
     endtime=1517
     call=OH1KH
     mhz=14.097150
     mode=OLIVIA
     submode=OLIVIA 8/500      (submode does not exist here if there is no submode for used mode!)
     tx=599
     rx=599
     name=saku
     qth=Pori
     state=PO
     province=SA
     country=Finland
     locator=KP01tn
     serialout=000
     serialin=
     free1=
     notes=remaks
     power=
     }
    edtCall.Text      := logged.ValueFromIndex[logged.IndexOfName('call')];
    edtCallExit(nil);

    // set date
    Mask              := logged.ValueFromIndex[logged.IndexOfName('date')];
    try
      data            := IntToStr(Mo.IndexOf(uppercase(ExtractWord(2,Mask,[' '])))+1);
    finally
      if length(data)<2 then data:='0'+data;
    end;
    data              := ExtractWord(3,Mask,[' '])+'-'+data+'-'+ ExtractWord(1,Mask,[' ']);
    edtDate.Text      := data;
    Mask              := logged.ValueFromIndex[logged.IndexOfName('TIME')];
    edtStartTime.Text := copy(Mask,1,2)+':'+ copy(Mask,3,2);
    Mask              := logged.ValueFromIndex[logged.IndexOfName('endtime')];
    edtEndTime.Text   := copy(Mask,1,2)+':'+ copy(Mask,3,2);
    edtName.Text      := logged.ValueFromIndex[logged.IndexOfName('name')];
    edtQTH.Text       := logged.ValueFromIndex[logged.IndexOfName('qth')];
    edtQTHExit(nil);
    edtGrid.Text      := logged.ValueFromIndex[logged.IndexOfName('locator')];
    edtGridExit(nil);
    edtState.Text     := logged.ValueFromIndex[logged.IndexOfName('state')];
    edtStateExit(nil);
    edtRemQSO.Text    := logged.ValueFromIndex[logged.IndexOfName('notes')];
    edtPWR.text       := logged.ValueFromIndex[logged.IndexOfName('power')];
    //Contest serial numbers. Test numerical value and >0
    Mask              := logged.ValueFromIndex[logged.IndexOfName('serialout')];
    i:= StrToIntDef(Mask,0);
    if i>0  then
                      edtContestSerialSent.Text:=Mask;
    Mask              := logged.ValueFromIndex[logged.IndexOfName('serialin')];
    i:= StrToIntDef(Mask,0);
    if i>0  then
                      edtContestSerialReceived.Text:=Mask;

    //first set mode by mode, then if submode exist replace mode with it.
    //Here no problem with SSB/USB/LSB combination
    mode      := logged.ValueFromIndex[logged.IndexOfName('mode')];
    if logged.IndexOfName('submode')> -1 then
         submode := logged.ValueFromIndex[logged.IndexOfName('submode')]
     else
         submode:='';
     cmbMode.Text:=dmUtils.ModeToCqr(mode,submode,dmData.DebugLevel>=1);

    //set frquency
    mhz               := logged.ValueFromIndex[logged.IndexOfName('mhz')];
    if Pos('.', mhz) > 0 then mhz[Pos('.', mhz)] := FormatSettings.DecimalSeparator;
    if pos(',', mhz) > 0 then mhz[pos(',', mhz)] := FormatSettings.DecimalSeparator;
    if dmUtils.GetBandFromFreq(mhz) <> '' then
                         cmbFreq.Text := mhz;

    //set RST
    edtHisRST.Text       := logged.ValueFromIndex[logged.IndexOfName('tx')];
    edtMyRST.Text        := logged.ValueFromIndex[logged.IndexOfName('rx')];

    //then override with possible defaults for frequency, mode and RST from Cqrlog settings
    case cqrini.ReadInteger('fldigi','freq',0) of
      0 : if frmTRXControl.GetModeFreqNewQSO(mode,mhz) then  cmbFreq.Text := mhz;
      2 : cmbFreq.Text := cqrini.ReadString('fldigi','deffreq','3.600')
    end;

  case cqrini.ReadInteger('fldigi','mode',1) of
      0 : if frmTRXControl.GetModeFreqNewQSO(mode,mhz) then cmbMode.Text := mode;
      2 : cmbMode.Text := cqrini.ReadString('fldigi','defmode','RTTY')
    end;

  if cqrini.ReadInteger('fldigi','rst',0) = 1 then
    begin
          edtHisRST.Text := cqrini.ReadString('fldigi','defrst','599');
          edtMyRST.Text  := cqrini.ReadString('fldigi','defrst','599')
    end;

    SaveRemote;
    FreeAndNil(logged);
    FreeAndNil(Mo);
  end;   //while msgrcv
 end; //else fldigixmlrpc

end;

procedure TfrmNewQSO.tmrADIFTimer(Sender: TObject);
var
  Buf, buf2,
  prik,data     :string;
  chkDuplicates :boolean;
  i             :longint;
  a,b,l         :integer;
  fixed         :Boolean;
  mode,submode  :string;

begin
  fixed:=false;
  tmrADIF.Enabled:=false;
  chkDuplicates:=false;
  if ADIFsock.WaitingData > 0 then
  Begin
   if dmData.DebugLevel>=1 then Writeln('rmtADIF has data. JS8CALL mode is now ',IsJS8Callrmt);
   while ADIFsock.WaitingData > 0 do     //do all pending messages in one go
    begin
      Buf := trim(ADIFsock.RecvPacket(50));    //Read all data waitingtimeout 50ms
      if dmData.DebugLevel>=1 then Writeln('rmtADIF read data');
      if ADIFSock.lasterror=0 then
       begin
         //check data.
         //N1MM contact info
         if (pos('<CONTACTINFO>',Uppercase(Buf))>0 )
           and(pos('<APP>N1MM',Uppercase(Buf))>0 ) then
                                                 Begin
                                                  Buf:=dmUtils.FromN1MMToAdif(Buf);
                                                  lblCall.Caption := 'rmt ADIF N1MM+';
                                                  fixed:=true;
                                                 end;
         //if JS8CALL JSON with ADIF inside
          if (pos('"LOG.QSO","value":"',Buf)>0) and (pos('"}',Buf)>0)  then
                                                Begin
                                                 Buf:=dmUtils.FromJS8CALLToAdif(Buf);
                                                 lblCall.Caption := 'rmt ADIF JS8CALL';
                                                 IsJS8Callrmt :=true;
                                                 fixed:=true;
                                                end;

          //if headerless ADIF from wsjtx secondary server, not from old versions of js8call
          if (pos('<CALL',uppercase (Buf))=1)
            and (pos('<EOR>',uppercase (Buf))>0)
            and (not IsJS8Callrmt)     then
                                               Begin
                                                 Buf:='<ADIF_VER:5>3.1.0<EOH>'+Buf;
                                                 lblCall.Caption := 'rmt ADIF hdless';
                                                 fixed:=true;
                                                end;


          //now all types should have proper adif header

         if ( (pos('<ADIF_VER',uppercase (Buf))>0)
          and (pos('<EOH>',uppercase (Buf))>0)
          and (pos('<CALL',uppercase (Buf))>0)
          and (pos('<EOR',uppercase (Buf))>0) ) then //we have at least one full record
            Begin  //remove header
               Buf:=copy(Buf,pos('<EOH>',uppercase (Buf))+5,length(Buf));
               if not fixed then lblCall.Caption := 'REMOTE ADIF';
            end
           else
            Begin      //nothing to do
              tmrADIF.Enabled:=true;
              exit;
            end;

           Buf2:=Buf;
           repeat //here check if several qsorecords in UDP block
            begin
             b:=pos('<EOR>',uppercase(buf2));
             buf:=copy(Buf2,1,b+5);   //holds one record
             buf2:= copy(buf2,b+6,length(buf2));  //holds remaining records
            //check now that at least tag '<call:' is found. If not throw away...
            if pos('<CALL:',uppercase (Buf)) > 0 then
             Begin
              if dmData.DebugLevel>=1 then writeln('Handle qso record: ',Buf);
              mode:='';
              submode:='';
              //this is fake as call info(qslmgr) needs date. We use current date if call tag comes before qso_date tag
              //qso_date will then replace this
              edtDate.Text := FormatDateTime('YYYY-MM-DD',now());
              repeat
                begin
                  if frmAdifImport.getNextAdifTag(Buf,prik,data,True) then
                    if dmData.DebugLevel>=1 then
                                                Begin
                                                 write(prik,'->');
                                                 writeln(data);
                                                end;
                                                 case uppercase(prik) of
                                                  'CALL'       : Begin
                                                                  edtCall.Text := uppercase(data);
                                                                  c_lock :=false;
                                                                  edtCallExit(nil);   //does info fetch
                                                                  WaitWeb(2);  //wait for web response 5sec timeout
                                                                 end;
                                                  'GRIDSQUARE' :Begin
                                                                     data := uppercase(data);
                                                                     if dmUtils.IsLocOK(data) then
                                                                        if pos(data,edtGrid.Text)=0  then   //if qso loc does not fit to QRZ loc , or qrz loc is empty
                                                                                      edtGrid.Text := data; //replace qrz loc, otherwise keep it
                                                                 end;
                                                  'MODE'       : mode := uppercase(data);
                                                  'SUBMODE'    : submode := uppercase(data);
                                                  'FREQ'       : cmbFreq.Text := data;
                                                  'FREQ_RX'    : edtRXFreq.Text := data;
                                                  'RST_SENT'   : edtHisRST.Text := data;
                                                  'RST_RCVD'   : edtMyRST.Text := data;
                                                  'QSO_DATE'   : Begin
                                                                  edtDate.Text := copy(data,1,4)+'-'+
                                                                                  copy(data,5,2)+'-'+
                                                                                  copy(data,7,2);
                                                                 end;
                                                   'TIME_ON'   : edtStartTime.Text := copy(data,1,2)+':'+ copy(data,3,2);
                                                   'TIME_OFF'  : edtEndTime.Text := copy(data,1,2)+':'+ copy(data,3,2);
                                                   'TX_PWR'    : edtPWR.Text := data;
                                       'NAME_INTL','NAME'      : if (data<>edtName.Text) and (data<>'') then edtName.Text := data;
                                        'QTH_INTL','QTH'       : if (data<>edtQTH.Text) and (data<>'') then edtQTH.Text := data;
                                    'COMMENT_INTL','COMMENT'   : if (data<>edtRemQSO.Text) and (data<>'') then edtRemQSO.Text := data;
                                                   'IOTA'      : if cmbIOTA.Text = '' then cmbIOTA.Text := data;
                                                   'STATE'     : if edtState.Text='' then edtState.Text := data;
                                                   'CQZ'       : edtWaz.Text := data;
                                                   'ITUZ'      : edtITU.Text := data;
                                                   'CONTEST_ID':  edtContestName.Text := data;
                                                   'STX'       : edtContestSerialSent.Text := data;
                                                   'SRX'       : edtContestSerialReceived.Text := data;
                                                    //ADIF logger+ definition does not have STXString tag. Added anyway(future?).
                                                   'STX_STRING':edtContestExchangeMessageSent.Text := data;
                                                    //same with SRX
                                                   'SRX_STRING': edtContestExchangeMessageReceived.Text:= data;
                                                   'OPERATOR'  : Begin
                                                                 data :=UpperCase(data);
                                                                 if ((data<>'') and (data <> UpperCase(cqrini.ReadString('Station', 'Call', '')))) then
                                                                  Begin
                                                                   Op := data;
                                                                   sbNewQSO.Panels[2].Text := cOperator+Op;
                                                                  end;
                                                                end;
                                                end; //case
                    end;  //repeat
               until pos('<EOR>',uppercase(Buf))=1;

              //set the final Cqrlmode
              cmbMode.Text:=dmUtils.ModeToCqr(mode,submode,dmData.DebugLevel>=1 );

              SaveRemote;

              //these do not reset in qso save, so they must be cleared here in case there was
              //FREQ_RX tag or OPERATOR-tag with value in previously received record.
              edtRXFreq.Text := '';
              sbNewQSO.Panels[2].Text :=''; Op:='';

              buf:=copy(buf,6,length(buf)); //cut eof away.
             end; // has tag call
           end; //here check if several qsos in block
          until Buf = '';
       end; //lasterror=0
    end;  // while waiting data
  end;  //if waiting data
  tmrADIF.Enabled:=true;
end;

procedure TfrmNewQSO.tmrRadioTimer(Sender: TObject);
var
  mode, freq, band, tmp : String;
  dfreq : Double;
  actTab  : TTabSheet;
  p :currency;
begin
  mode := '';
  freq := '';
  band := '';
  if Running then
   exit;
  Running := True;
  try
    if (not (fViewQSO or fEditQSO)) then
    begin
      if cbOffline.Checked and (not AnyRemoteOn) then
        exit;   //offline, but not remote mode
    
      if (cqrini.ReadBool('NewQSO', 'UseRigPwr', False) and frmTRXControl.GetRigPower(tmp)) then
         if tryStrToCurr(tmp,p) then  //conversion str->int->str is needed to allow power factor usage
            edtPWR.Text:=FloatToStrF(p,ffFixed,3,1);

      if cbOffline.Checked
        and ((mnuRemoteMode.Checked and (cqrini.ReadInteger('fldigi','freq',0) > 0))
              or (mnuRemoteModeWsjt.Checked and (cqrini.ReadInteger('wsjt','freq',0) > 0))
            ) then
                  exit; //frequency from fldigi/wsjtx or their defaults

      if (frmTRXControl.GetModeFreqNewQSO(mode,freq)) then
      begin
        if( mode <> '') and chkAutoMode.Checked then
          cmbMode.Text := RigCmd2DataMode(mode);
        if (freq <> empty_freq) then
        begin
          cmbFreq.Text := freq;
          if frmTRXControl.GetModeBand(mode,band) then
            Begin
             if (edtCall.Text<>'') and (edtCall.Text+mode+band <> DetailsCMBColorDone) then
             //this sets statistic grid to have right coloring, specially when NewQSO from DXCluster spot click
               begin
                 actTab:=pgDetails.ActivePage;
                 pgDetails.ActivePage:=tabCallStat;
                 pgDetails.ActivePage:=tabDXCCStat;
                 pgDetails.ActivePage:=actTab;
                 DetailsCMBColorDone := edtCall.Text+mode+band;
               end;
           end;
          if ClearAfterFreqChange and sbtnHamQTH.Visible then
          begin
            dfreq := frmTRXControl.GetFreqMHz;
            if (FreqBefChange<>0) and ((dfreq < (FreqBefChange-ChangeFreqLimit)) or
               (dfreq > (FreqBefChange+ChangeFreqLimit))) then
               ClearAll
          end
          else
            FreqBefChange := frmTRXControl.GetFreqMHz
        end;
        if (mode <> '') and (freq <> empty_freq) then
        begin
          band := dmUtils.GetBandFromFreq(freq);
          if (band <> old_t_band) then btnClearSatelliteClick(nil); //if band changes sat and prop cleared
          if (mode <> old_t_mode) or (band <> old_t_band) then
          begin
            old_t_mode := mode;
            old_t_band := band
          end;
        end
      end
    end
  finally
    Running := False
  end;

end;

procedure TfrmNewQSO.tmrStartStartTimer(Sender: TObject);
begin
  tmrStartTimer(nil)
end;

procedure TfrmNewQSO.tmrStartTimer(Sender: TObject);
begin
  if not cbOffline.Checked then
  begin
    FillDateTimeFields;
    StartUpRemote;
  end
end;

procedure TfrmNewQSO.tmrUploadAllTimer(Sender: TObject);
begin
  if (not frmLogUploadStatus.thRunning) then
  begin
    case WhatUpNext of
      upHamQTH :  begin
                    if UploadAll then
                      frmLogUploadStatus.UploadDataToHamQTH(UploadAll)
                    else begin
                      if cqrini.ReadBool('OnlineLog','HaUpOnline',False) then
                        frmLogUploadStatus.UploadDataToHamQTH
                    end;
                    WhatUpNext := upClubLog
                  end;
      upClubLog : begin
                    if UploadAll then
                      frmLogUploadStatus.UploadDataToClubLog(UploadAll)
                    else begin
                      if cqrini.ReadBool('OnlineLog','ClUpOnline',False) then
                        frmLogUploadStatus.UploadDataToClubLog
                    end;
                    WhatUpNext := upHrdLog
                  end;
      upHrdLog  : begin
                    if UploadAll then
                      frmLogUploadStatus.UploadDataToHrdLog(UploadAll)
                    else begin
                      if cqrini.ReadBool('OnlineLog','HrUpOnline',False) then
                        frmLogUploadStatus.UploadDataToHrdLog
                    end;
                    WhatUpNext           := upUDPLog
                  end;
      upUDPLog  : begin
                    if UploadAll then
                      frmLogUploadStatus.UploadDataToUDPLog(UploadAll)
                    else begin
                      if cqrini.ReadBool('OnlineLog','UdUpOnline',False) then
                        frmLogUploadStatus.UploadDataToUDPLog
                    end;
                    tmrUploadAll.Enabled := False;
                    UploadAll            := False;
                    WhatUpNext           := upHamQTH
                  end
    end //case
  end
end;
procedure TfrmNewQSO.tmrWsjtxTimer(Sender: TObject);
const
  ContestName : array [0..6] of string = ( '','NA VHF','EU VHF','FIELD DAY','RTTY RU','FOX','HOUND' );

var

  Buf      : String;
  Fdes     : Currency;
  ParStr   : String;
  Par2Str  : String;
  Fox2Line: integer;
  ParDou   : Double;
  ParBool  : Boolean;
  ParNum   : Integer;
  TimeLine : String;
  Repbuf   : String;
  index    : Integer;
  tmpindex : Integer;
  MsgType  : Integer;
  Sec      : Integer;
  Min      : Integer;
  Hour     : Integer;
  RepStart : integer;
  Snr      : integer;
  Dtim     : TDateTime;
  Dfreq    : Integer;
  new      : Boolean;
  newstart : Boolean;
  TXEna    : Boolean;
  TXOn     : Boolean;
  i        : word;
  TXmode   : String;
  BufEnd     : Boolean;

  call  : String;
  sname : String;
  qth   : String;
  loc   : String;
  mhz   : String;
  mode  : String;
  pwr   : String;
  rstS  : String;
  rstR  : String;
  note  : String;
  date  : TDateTime;
  sDate : String='';
  Mask  : String='';
  FirstWord: String;
  MyCall : String;
  OpCall : String;
  ExchR  : String;
  ExchS  : String;
  propmode  : String;
//...................................................................
  Procedure MoveIndex(m:integer);    //within Buf limits
  Begin
     index := index+m;
     if (index >= length(Buf) ) then
      Begin
       //we can not find anything from Buf any more
       index := length(Buf);
       BufEnd :=true;
      end
     else BufEnd := false;
  end;
//...................................................................
  function ui32Buf(var index:integer):uint32;
  begin
    if BufEnd then
      Begin
       Result := 0;
       exit;
      end;
    Result := $01000000*ord(Buf[index])
              + $00010000*ord(Buf[index+1])
              + $00000100*ord(Buf[index+2])
              + ord(Buf[index+3]);         // 32-bit unsigned int BigEndian
    MoveIndex(4);                 //point to next element
  end;
//...................................................................
  function StrBuf(var index:integer):String;
  var
    P : uint32;
  begin
    if BufEnd then
      Begin
       Result := '';
       exit;
      end;
    P := ui32Buf(index);                 //string length;   4bytes
    if P = $FFFFFFFF then               //exeption: empty Qstring len: $FFFF FFFF content: empty
    begin
      Result := ''
    end
    else begin
      Result := copy(Buf,index,P);        //string content
      MoveIndex(P);              //point to next element
    end
  end;
//...................................................................
 function ui64Buf(var index:integer):uint64;
 var
    lo,hi    :uint32;
 begin
    hi :=  ui32Buf(index);
    lo :=  ui32Buf(index);
    Result := $100000000 * hi + lo
 end;
//...................................................................
  function DoubleBuf(var index:integer):Double; //this does not work either but moves index right amount!!
   Begin
     Result := ui64Buf(index);
   end;

  function int64Buf(var index:integer):int64;
  begin
     Result := ui64Buf(index)
  end;

  function int32Buf(var index:integer):int32;
  begin
    Result := ui32Buf(index)
  end;
//...................................................................
  function ui8Buf(var index:integer):uint8;
  begin
    if BufEnd then
      Begin
       Result := 0;
       exit;
      end;
    Result := ord(Buf[index]);
    MoveIndex(1)
  end;
//...................................................................
  function BoolBuf(var index:integer):Boolean;
  begin
    if BufEnd then
      Begin
       Result := false;
       exit;
      end;
    Result := ord(Buf[index]) = 1;
    MoveIndex(1)
  end;
//...................................................................
  procedure DupeInContest;
  var
     ContestDupe : integer;
     begin
       if frmContest.Showing
          and ( not frmContest.rbIgnoreDupes.Checked )
          and frmContest.chkMarkDupe.Checked then
           Begin
             ContestDupe:=frmWorkedGrids.WkdCall(edtCall.Text, dmUtils.GetBandFromFreq(frmNewQSO.cmbFreq.Text) ,frmNewQSO.cmbMode.Text);
             if frmContest.rbNoMode4Dupe.Checked and ( ContestDupe=2) then
                                                  ContestDupe:=0;
             if (ContestDupe=1) or (ContestDupe=2)  then
                                                  edtHisRST.Text := edtHisRST.Text+'/Dupe';
           end;
  end;
//...................................................................
//-------------------------------------------------------------------
begin
  if WsjtxDecodeRunning then
   begin
     if dmData.DebugLevel>=1 then Writeln('WsjtDecode already running!');
     Exit;
   end
     else
     Begin
       WsjtxDecodeRunning := true;   //do not jump here if already running
       tmrWsjtx.Enabled:= false;
     end;
  if Wsjtxsock.WaitingData > 0 then
  Begin
  MyCall := UpperCase(cqrini.ReadString('Station', 'Call', ''));
  while Wsjtxsock.WaitingData > 0 do     //test for clear all datagrams ready at one go
  begin
  Buf := Wsjtxsock.RecvPacket(1000);
  if WsjtxSock.lasterror=0 then
  begin
    Fox2Line := 0;
    BufEnd := false;
    index := pos(#$ad+#$bc+#$cb+#$da,Buf); //QTheader: magic number 0xadbccbda
    if index < 1 then
             begin
              if dmData.DebugLevel>=1 then Writeln(index,':--------Not wjst message!!------------');
              lblCall.Caption:= 'Not wjst msg!';
              break;
             end;
    RepStart := index; //for possibly reply creation

    if dmData.DebugLevel>=1 then Writeln('-----------------------decode start---------------------------------');
    if dmData.DebugLevel>=1 then Write('Header position:',index);
    MoveIndex(4);  // skip QT header

    ParNum :=  ui32Buf(index);
    if dmData.DebugLevel>=1 then Write(' Schema number:',ParNum);

    MsgType :=  ui32Buf(index);
    if dmData.DebugLevel>=1 then Write(' Message type:', MsgType,' ');
    lblCall.Caption       := 'Wsjt-x remote #'+intToStr(MsgType);   //changed to see last received msgtype

    tmpindex := index;
    RemoteName := StrBuf(index);       //read remote name to get index point to RepHead end
    RepHead := copy(Buf,1,index-1);
    RepHead[12] := #0;             //Ready made reply header with #0 command (lobyte of uint32)
    index := tmpindex;             //return pointer back

    case MsgType of


    0 : begin //Heartbeat
          ParStr := StrBuf(index);
          if dmData.DebugLevel>=1 then Writeln('HeartBeat Id:', ParStr);

          if lblCall.Font.Color = clRed then
            lblCall.Font.Color    := clBlue
          else
            lblCall.Font.Color    := clRed;

          if WsjtxMode = '' then
          begin
            Repbuf := copy(Buf,RepStart,length(Buf));  //Reply is copy of heartbeat
            if (length(RepBuf) > 11 ) and (RepBuf[12] = #$00) then //we should have proper reply
            begin
              RepBuf[12] := #$07;    //quick hack: change message type from 0 to 7
              if dmData.DebugLevel>=1 then Writeln('Changed message type from 0 to 7. Sending...')
            end;
            if multicast then
               WsjtxsockS.SendString(RepBuf)
             else
               Wsjtxsock.SendString(RepBuf);
          end
        end; // Heartbeat

    1 : begin //Status
          new := false;
          newstart := false;
          ParStr := StrBuf(index);
          if dmData.DebugLevel>=1 then Writeln('Status Id:', ParStr);
          //----------------------------------------------------
          mhz := IntToStr(ui64Buf(index));
          case cqrini.ReadInteger('wsjt','freq',0) of
            0 : begin
                  if not frmTRXControl.GetModeFreqNewQSO(mode,mhz) then
                    mhz := ''
                end;
            1 : begin
                  if TryStrToCurr(mhz,Fdes) then
                     Begin
                       Fdes :=Fdes/1000000.0;
                       mhz:=FloatToStrF(Fdes,ffFixed,8,5);
                     end;
                  if dmData.DebugLevel>=1 then Writeln('Qrg :', mhz);
                  mhz := Trim(mhz)
                end;
            2 : mhz := cqrini.ReadString('wsjt','deffreq','3.600')
          end;

          ParStr := dmUtils.GetBandFromFreq(mhz);
          if (ParStr<>WsjtxBand) then
          begin
            new := true;
            newstart:= WsjtxBand=''; //clean start do not use for wsjtx cleaning
            WsjtxBand := ParStr
          end;
          if dmData.DebugLevel>=1 then Writeln('Band :', WsjtxBand);
          //----------------------------------------------------
          ParStr := StrBuf(index);
          if (ParStr<>WsjtxMode) then
          begin
            new :=true;
            newstart:= Wsjtxmode=''; //clean start do not use for wsjtx cleaning
            WsjtxMode := ParStr;
          end;
          if dmData.DebugLevel>=1 then Writeln('Mode:', WsjtxMode);
           //----------------------------------------------------
          call := trim(StrBuf(index)); //to be sure...
          if dmData.DebugLevel>=1 then Writeln('Call :', call);
         //----------------------------------------------------
          rstS:= StrBuf(index);    //report
          if dmData.DebugLevel>=1 then Writeln('Report: ',rstS);
          //----------------------------------------------------
          case cqrini.ReadInteger('wsjt','mode',1) of
            0 : begin
                  if not frmTRXControl.GetModeFreqNewQSO(TXmode,mhz) then
                    TXmode :='';
                end;
            1 : TXmode := trim(StrBuf(index));
            2 : TXmode := cqrini.ReadString('wsjt','defmode','JT65')
          end;
          if dmData.DebugLevel>=1 then Writeln('TXmode: ',Txmode);
          //----------------------------------------------------
          TXEna := BoolBuf(index);
          if dmData.DebugLevel>=1 then Writeln('TXEnabled: ',TXEna);
          //----------------------------------------------------
          TXOn := BoolBuf(index);
          if dmData.DebugLevel>=1 then Writeln('Transmitting: ',TXOn);
          //----------------------------------------------------
          ParBool:= BoolBuf(index);
          if dmData.DebugLevel>=1 then Writeln('Decoding: ', ParBool);
          Parnum := int32Buf(index);
          if dmData.DebugLevel>=1 then Writeln('Rx DF: ',Parnum);
          Parnum := int32Buf(index);
          if dmData.DebugLevel>=1 then Writeln('Tx DF: ',Parnum);
          Parstr := StrBuf(index);
          if dmData.DebugLevel>=1 then Writeln('DE call: ',Parstr);
          Parstr := StrBuf(index);
          if dmData.DebugLevel>=1 then Writeln('DE grid: ',Parstr);
          Parstr := StrBuf(index);
          if dmData.DebugLevel>=1 then Writeln('DX grid: ',Parstr);
          ParBool:= BoolBuf(index);
          if dmData.DebugLevel>=1 then Writeln('Tx Watchdog: ', ParBool);
          Parstr := StrBuf(index);
          if dmData.DebugLevel>=1 then Writeln('Sub-mode: ',Parstr);
          ParBool:= BoolBuf(index);
          if dmData.DebugLevel>=1 then Writeln('Fast mode: ', ParBool);
          ContestNr := ui8Buf(index);
          if dmData.DebugLevel>=1 then Writeln('Contest nr: ', ContestNr);

          //----------------------------------------------------
          if TXEna and TXOn then
          begin
            if dmData.DebugLevel>=1 then Writeln('Status: TxEna, TxOn, DXCall is:',call);
            if (frmMonWsjtx <> nil) then   //CQ-monitor exist
               if (frmMonWsjtx.DblClickCall <> call) then   //this works now also when calling started from wsjt-x main screen 2click
                                            begin    //we do not try to work same station any more as with 2click before
                                              if frmMonWsjtx.chkStopTx.Checked then frmMonWsjtx.DblClickCall := call
                                                else frmMonWsjtx.DblClickCall :='';
                                              if dmData.DebugLevel>=1 then Writeln('Change 2click call to:',frmMonWsjtx.DblClickCall);
                                            end;
          end;
          //these can be altered always
          if dmUtils.GetBandFromFreq(mhz) <> '' then   //then add new values from status msg
           begin
            cmbFreq.Text := mhz;
            cmbMode.Text := TXmode;
           end;

          //callsign can be changed during RX or TX if band does not change
          if not new then
            begin
             if (call <> edtCall.Text) then
              Begin
               if (DiffCalls < 3) then
                  inc( DiffCalls )
                else
                 Begin
                  GetCallInfo(call,WsjtxMode,rstS);
                  DiffCalls := 0;
                 end;
              end
             else //same calls
                 DiffCalls := 0;
            end
          else //band changes
           begin
            new := False;
            if (frmNewQSO.RepHead <> '') and (not CallFromSpot) and (not newstart) then
             //clean wsjtx's DXCall and DXGrid and do GenStdMsg(to clean it too)
               Begin
                 frmMonWsjtx.SendConfigure('','',' ',' ',$7FFFFFFF,$7FFFFFFF,$7FFFFFFF,False,True);
               end;
            if not CallFromSpot then
               Begin
                  edtCall.Text := '';//clean grid like double ESC does
                  Sleep(200); //to be sure edtCallChange has time to run;
                  old_ccall := '';
                  old_cfreq := '';
                  old_cmode := '';
               end
            else
              CallFromSpot:=False;

            if (frmMonWsjtx <> nil) and frmMonWsjtx.Showing then
              Begin
               frmMonWsjtx.NewBandMode(WsjtxBand,WsjtxMode);
               cmbFreq.Text :=mhz;
               cmbMode.Text := WsjtxMode;
               if (dmUtils.GetBandFromFreq(cmbFreq.Text) <> old_t_band) then
                 Begin
                  old_t_band := dmUtils.GetBandFromFreq(cmbFreq.Text);
                  btnClearSatelliteClick(nil); //if band changes sat and prop cleared
                 end;
              end;
           end  //band changes
        end; //Status


    2 : begin //Decode
          ParStr := StrBuf(index);
          if dmData.DebugLevel>=1 then Writeln('Decode Id:', ParStr);
          Repbuf := copy(Buf,RepStart,index-RepStart);  //Reply str head part
          new:= BoolBuf(index);
          RepStart := index;     //Reply new/old skip. Str tail start
          if not new then
          begin
            if dmData.DebugLevel>=1 then Writeln('Old decode!')
          end
          else
           begin
            if dmData.DebugLevel>=1 then Writeln('New decode:') ;
         //----------------------------------------------------
          ParNum := ui32Buf(index);
          Min := ParNum div 60000;  //minutes from 00:00    UTC
          Sec := (ParNum - Min * 60000 ) div 1000;
          Hour := Min div 60;
          Min := Min - Hour * 60;
          TimeLine :='';
          if length(intToStr(Hour)) = 1 then
            TimeLine := TimeLine + '0'+ intToStr(Hour)
          else
            TimeLine :=TimeLine + intToStr(Hour);
          if length(intToStr(Min)) = 1 then
            TimeLine := TimeLine + '0' + intToStr(Min)
          else
            TimeLine := TimeLine + intToStr(Min);
          if length(intToStr(Sec)) = 1 then
            TimeLine := TimeLine + '0' + intToStr(Sec)
          else
            TimeLine := TimeLine + intToStr(Sec);
          if dmData.DebugLevel>=1 then Writeln(TimeLine);
          //----------------------------------------------------
          Snr :=  int32Buf(index);
          if dmData.DebugLevel>=1 then Writeln('snr:',ParNum );
          //----------------------------------------------------
          ParDou := DoubleBuf(index);
          if dmData.DebugLevel>=1 then Writeln('delta time:',ParDou);
          //----------------------------------------------------
          Dfreq :=  ui32Buf(index);
          if dmData.DebugLevel>=1 then Writeln('DeltaFreq:', ParNum);
          //----------------------------------------------------
          mode := StrBuf(index);    //mode as letter: # @ & etc...
          if dmData.DebugLevel>=1 then Writeln(mode);
          //----------------------------------------------------
          ParStr := trim(StrBuf(index));    //message          //MSK144 CQ has one space before CQ, need trim
          if dmData.DebugLevel>=1 then Writeln(ParStr);
          //----------------------------------------------------
          if (pos('; ',ParStr)>0) then  //fox decode has 2 items per line separated by '; '
            Begin
             Fox2Line :=2;
             Par2Str := copy(ParStr,pos(';',ParStr)+2,length(ParStr));
             ParStr := copy(ParStr,1,pos(';',ParStr)-1);
            end;
           repeat
            Begin
              if (Fox2Line = 0) then Repbuf := Repbuf+copy(Buf,RepStart,index-RepStart)  //Reply str tail part
                else  Repbuf := '';  //only if it is not Fox 2 line
              FirstWord := copy(ParStr,1,pos(' ',ParStr)-1);
              if dmData.DebugLevel>=1 then Writeln('Origin:',length(Buf),' Reply:',length(RepBuf),' FirstWd>',FirstWord,'<');//should be 1 less
               //if monitor runs ok
               if ( new and (frmMonWsjtx <> nil) and frmMonWsjtx.Showing and (WsjtxBand <>'')  and (WsjtxMode <>'')) then
                 Begin
                   //if CQ or Mycall    (Message is in ParStr)
                   if (FirstWord = 'CQ') then
                                frmMonWsjtx.AddCqCallMessage(Timeline,mode,WsjtxBand,ParStr,Repbuf,Dfreq,Snr)
                      else if (pos (MyCall,FirstWord) > 0) then  //this order passes '<MyCall>' and MyCall
                                 frmMonWsjtx.AddMyCallMessage(Timeline,mode,WsjtxBand,ParStr,Repbuf,Dfreq,Snr)

                       else  //if followed call
                       Begin
                          if dmData.DebugLevel>=1 then Writeln('Other Decode');
                          frmMonWsjtx.AddOtherMessage(Timeline,ParStr,Repbuf,DFreq,Snr);
                       end;
                 end;
               if (Fox2Line = 2) then  ParStr := Par2Str; //run again with 2nd part of line
               dec(Fox2Line);
             end;
            until (Fox2line < 1);
         //----------------------------------------------------
         end; // New decode
       end; //Decode

    3 : begin //Clear
          ParStr := StrBuf(index);
          if dmData.DebugLevel>=1 then Writeln('Clear Id:', ParStr);
          if (frmMonWsjtx <> nil) and frmMonWsjtx.Showing then
           Begin
             frmMonWsjtx.clearSgMonitor;
             frmMonWsjtx.edtFollow.Text := '';
           end;
        end; //Clear

    5 : begin  //qso logged
          ParStr := StrBuf(index);
          if dmData.DebugLevel>=1 then Writeln('Qso Logging Id:', ParStr);
          if dmData.DebugLevel>=1 then Writeln('edtCall before started logging #5:',edtCall.Text );
          //----------------------------------------------------
          //ClearAll;          THis removes QRZ data, not accepted!
          cbOffline.Checked := True;
          call     := '';
          sname    := '';
          qth      := '';
          loc      := '';
          mhz      := '';
          mode     := '';
          rstS     := '';
          rstR     := '';
          note     := '';
          pwr      := '';
          propmode := '';
          edtDate.Clear;
          //----------------------------------------------------
           if TryJulianDateToDateTime(int64Buf(index),DTim)  then  //date
             if dmData.DebugLevel>=1 then Writeln('End Date :',FormatDateTime('YYYY-MM-DD',DTim));
           // we use end date here because dmData.QSLMgrFound() needs date.
           //if not set causes  "'' is not valid date error" sometimes (usually at first logged qso)
           //edtDate.Text is reset later below to be real qso start date
           edtDate.Text := FormatDateTime('YYYY-MM-DD',DTim);
          //-----------------------------------------TIME-----------
           ParNum := ui32Buf(index);    //set qso end time
           Min  := ParNum div 60000;  //minutes from 00:00    UTC
           Hour := Min div 60;
           Min  := Min - Hour * 60;
           TimeLine :='';
           if length(intToStr(Hour)) = 1 then
             TimeLine := TimeLine + '0'+ intToStr(Hour) +':'
           else
             TimeLine :=TimeLine + intToStr(Hour) +':';
           if length(intToStr(Min)) = 1 then
             TimeLine := TimeLine + '0' + intToStr(Min)
           else
             TimeLine := TimeLine + intToStr(Min);
           if dmData.DebugLevel>=1 then Writeln('End Time: ',TimeLine);
           edtEndTime.Text := TimeLine;
           //----------------------------------------------------
           ParNum := ui8Buf(index);  //timespec local/utc   (not used in cqrlog)
           if dmData.DebugLevel>=1 then Writeln('timespec: ', ParNum);
           //----------------------------------------------------
           if ParNum = 2 then  // time offset  (not used in cqrlog)
           begin
             ParNum := int32Buf(index);
             if dmData.DebugLevel>=1 then Writeln('offset :', int32Buf(index))
           end;
          //--------------------------------------------CALL--------
          call:= trim(StrBuf(index)); //to be sure...
          if dmData.DebugLevel>=1 then Writeln('Call decoded #5:', call,'  edtCall:',edtCall.Text );
          if  edtCall.Text <> call then  //call (and web info) maybe there already ok from status packet
                           Begin
                             edtCall.Text := '';
                             Sleep(200); //to be sure edtCallChange has time to run;
                             edtCall.Text := call;
                             c_lock:=False;
                             edtCallExit(nil);    //<--------this will fetch web info
                             if dmData.DebugLevel>=1 then Writeln('Call was not there already');
                             WaitWeb(2); // give time for web
                           end;
          //---------------------------------------------LOCATOR-------
          loc:= trim(StrBuf(index));
          if dmData.DebugLevel>=1 then Writeln('Grid :', loc);
          if dmUtils.IsLocOK(loc) then
              if pos(loc,edtGrid.Text)=0  then   //if qso loc does not fit to QRZ loc , or qrz loc is empty
                             edtGrid.Text := loc; //replace qrz loc, otherwise keep it

          //----------------------------------------------------
          mhz := IntToStr(ui64Buf(index));   // in Hz here from wsjtx
          case cqrini.ReadInteger('wsjt','freq',0) of
            0 : begin
                  if  frmTRXControl.GetModeFreqNewQSO(mode,mhz) then
                    cmbFreq.Text := mhz
                end;
            1 : begin
                 if TryStrToCurr(mhz,Fdes) then
                     Begin
                       Fdes :=Fdes/1000000;
                       mhz:=FloatToStrF(Fdes,ffFixed,8,5);
                     end;
                  if dmData.DebugLevel>=1 then Writeln('Qrg :', mhz);
                  mhz := Trim(mhz);
                  if dmUtils.GetBandFromFreq(mhz) <> '' then
                    cmbFreq.Text := mhz
                end;
            2 : cmbFreq.Text := cqrini.ReadString('wsjt','deffreq','3.600')
          end;

          ParStr := dmUtils.GetBandFromFreq(mhz);
          if ParStr<>WsjtxBand then
          begin
            new := true;
            WsjtxBand := ParStr
          end;
          if dmData.DebugLevel>=1 then Writeln('Band :', WsjtxBand);
          //----------------------------------------------------
          case cqrini.ReadInteger('wsjt','mode',1) of
            0 : begin
                  if frmTRXControl.GetModeFreqNewQSO(mode,mhz) then
                    cmbMode.Text := mode
                end;
            1 : begin
                  mode:= trim(StrBuf(index));
                  if dmData.DebugLevel>=1 then Writeln('Mode :', mode);
                  cmbMode.Text := mode
                end;
            2 : cmbMode.Text := cqrini.ReadString('wsjt','defmode','JT65')
           end;
           //----------------------------------------------------
           rstS:= trim(StrBuf(index));
           if dmData.DebugLevel>=1 then Writeln('RSTs :', rstS);
           edtHisRST.Text := rstS;
           //----------------------------------------------------
           rstR:= trim(StrBuf(index));
           if dmData.DebugLevel>=1 then Writeln('RSTr :', rstR);
           edtMyRST.Text := rstR;
           //----------------------------------------------------
           pwr:= trim(StrBuf(index));
           if dmData.DebugLevel>=1 then Writeln('Pwr :', pwr);
           if pwr<>'' then edtPWR.Text := pwr;   //empty value leaves NewQSO/pwr valid
           //----------------------------------------------------
           note:= trim(StrBuf(index));
           if dmData.DebugLevel>=1 then Writeln('Comments :', note);
           edtRemQSO.Text := note;
           //--------------------------------------------------
           sname:= trim(StrBuf(index));
           if dmData.DebugLevel>=1 then Writeln('Name :', sname,'  edtName :',edtName.Text);
           if sname <>'' then  //if user gives name edtName from qrz.com get replaced
            Begin
              edtName.Text := sname;
            end;
           if dmData.DebugLevel>=1 then Writeln('edtName before pressing save:',edtName.Text );
          //----------------------------------------------------
           if TryJulianDateToDateTime(int64Buf(index),DTim)  then
           //start date used
           dmUtils.DateInRightFormat(DTim,Mask,sDate);
           edtDate.Text:=sDate;
           if dmData.DebugLevel>=1 then Writeln('Start Date :',sDate);
          //-----------------------------------------TIME-----------
           ParNum := ui32Buf(index);    //set qso start time
           Min  := ParNum div 60000;  //minutes from 00:00    UTC
           Hour := Min div 60;
           Min  := Min - Hour * 60;
           TimeLine :='';
           if length(intToStr(Hour)) = 1 then
             TimeLine := TimeLine + '0'+ intToStr(Hour) +':'
           else
             TimeLine :=TimeLine + intToStr(Hour) +':';
           if length(intToStr(Min)) = 1 then
             TimeLine := TimeLine + '0' + intToStr(Min)
           else
             TimeLine := TimeLine + intToStr(Min);
           if dmData.DebugLevel>=1 then Writeln('Start Time: ',TimeLine);
           edtStartTime.Text := TimeLine;
            //----------------------------------------------------
           ParNum := ui8Buf(index);  //timespec local/utc   (not used in cqrlog)
           if dmData.DebugLevel>=1 then Writeln('timespec: ', ParNum);
           //----------------------------------------------------
           if dmData.DebugLevel>=1 then Writeln('Remote name: ', RemoteName);
           if Pos('WSJT',RemoteName)>0 then   //no contest in JTDX
            begin
                 if dmData.DebugLevel>=1 then Writeln('Tail logging part entered');
                 OpCall := UpperCase(trim(StrBuf(index)));  //operator callsign (in contest, club etc.)
                 if ((OpCall<>'') and (Op <> OpCall)) then
                  Begin           //wsjt-x operator setting wins cqrlog operator setting
                   Op := OpCall;  //for this qso only as it is currently used operation mode
                   ShowOperator;  //This only flashes wsjt-x operator during save
                  end;
                 ExchR :=  trim(StrBuf(index));  //fake, this is actually "My call". Not used
                 ExchR :=  trim(StrBuf(index));  //fake, this is actually "My grid". Not used
                 ExchS :=  trim(StrBuf(index));  //contest exchange sent. report + others
                 ExchR :=  trim(StrBuf(index));  //contest exchange received. report + others
                 //----------------------------------------------------
                 {
                 These wsjt-x will return as contest number:
                   *       0 -> NONE
                   *       1 -> NA VHF
                   *       2 -> EU VHF
                   *       3 -> FIELD DAY
                   *       4 -> RTTY RU
                   *       5 -> FOX
                   *       6 -> HOUND
                   }

                 case ContestNr of
                      1         :Begin //NA VHF  EX:locator-4chr
                                  edtContestName.Text := ContestName[ContestNr];
                                  edtContestExchangeMessageReceived.Text := ExchR;
                                  edtContestExchangeMessageSent.Text := ExchS;
                                  edtHisRST.Text := ' '; // NA-VHF has no proper reports (!?!)
                                  DupeInContest;
                                  edtMyRST.Text := ' ';  // fake space here. Otherwise qso edit sets 599 for reports
                                 end;
                      2         :Begin  //EU VHF    EX:RS-2chr/serial-4chr/ /locator
                                   edtContestName.Text := ContestName[ContestNr];
                                   edtContestSerialReceived.Text := copy(ExchR,3,4);  //serialNr
                                   edtContestExchangeMessageReceived.Text:= copy(ExchR,8,6); //exMsg=locator
                                   edtGrid.Text:=copy(ExchR,8,6);
                                   edtContestSerialSent.Text := copy(ExchS,3,4);  //serialNr
                                   edtContestExchangeMessageSent.Text:= copy(ExchS,8,6); //exMsg=locator
                                   DupeInContest;
                                   edtHisRST.Text := edtHisRST.Text+' '; // fake space here. Otherwise qso edit sets xx9 for reports
                                   edtMyRST.Text := edtMyRST.Text+' ';
                                 end;
                      3         :Begin  //FIELD DAY EX:TXnrClass/ /state
                                  edtContestName.Text := ContestName[ContestNr];
                                  edtContestExchangeMessageReceived.Text := ExchR;
                                  edtContestExchangeMessageSent.Text := ExchS;
                                  edtHisRST.Text := ' '; // FD has no proper reports (!?!)
                                  DupeInContest;
                                  edtMyRST.Text := ' ';  // fake space here. Otherwise qso edit sets 599 for reports
                                 end;
                      4         :Begin  //RTTY RU   EX:RST-3chr/ /serial-4chr[or] state(not numbers)
                                  edtContestName.Text := ContestName[ContestNr];
                                  if  (ExchS[5] in [ 'A' .. 'Z' ]) then
                                    edtContestExchangeMessageSent.Text:= copy(ExchS,5,length(ExchS)) //exMsg=state
                                   else
                                    edtContestSerialSent.Text := copy(ExchS,5,length(ExchS)); //serialNr
                                  if  (ExchR[5] in [ 'A' .. 'Z' ]) then
                                    edtContestExchangeMessageReceived.Text:= copy(ExchR,5,length(ExchR)) //exMsg=state
                                   else
                                    edtContestSerialReceived.Text := copy(ExchR,5,length(ExchR)); //serialNr
                                  DupeInContest;
                                 end;
                      5,6       : Begin
                                   edtContestName.Text := ContestName[ContestNr]+'-QSO';
                                   DupeInContest;
                                  end;
                 end;
                 case ContestNr of
                      1,2,3,4   : Begin
                                       edtContestSerialReceived.Text := copy( edtContestSerialReceived.Text,1,6); //Max Db length=6
                                       if (frmContest.Showing and (frmContest.cmbContestName.Text<>'')) then
                                            edtContestName.Text :=frmContest.cmbContestName.Text;
                                  end;
                 end;
           end;
           //----------this is not yet in wsjt-x 2.2.2 and JTDX 2.1.0rc151------------------
           propmode:= trim(StrBuf(index));
           if dmData.DebugLevel>=1 then Writeln('Prop Mode :', propmode);
           if (cmbPropagation.Text='') then
                 Begin
                  cmbPropagation.Text := dmSatellite.GetPropLongName(propmode);
                  if dmData.DebugLevel>=1 then Writeln('Prop Mode added!');
                 end;
           //----------------------------------------------------
           if dmData.DebugLevel>=1 then Writeln(' WSJTX decode #5 logging: press save');
           SaveRemote;
           if dmData.DebugLevel>=1 then Writeln(' WSJTX decode #5 logging now ended');
           if ((frmMonWsjtx <> nil) and (frmMonWsjtx.DblClickCall <> '')) then //CQ-monitor exist
                                    begin
                                      if dmData.DebugLevel>=1 then Writeln('Reset 2click call:',frmMonWsjtx.DblClickCall,' QSO logged');
                                      frmMonWsjtx.DblClickCall :='';
                                    end;
         end; //QSO logged in

     6 : begin //Close
           ParStr := StrBuf(index);
           if dmData.DebugLevel>=1 then Writeln('Close Id:', ParStr);
           //wsjtx closed maybe need to disable remote mode  ?
           WsjtxDecodeRunning :=false;
           DisableRemoteMode;
           Exit;
         end; //Close

     10 : Begin   //WSPRDecode. Not implemented
            if dmData.DebugLevel>=1 then Writeln(' WSPRDecode. Not implemented');
          end;    //WSPRDecode

     12 : Begin   //Logged ADIF. Not implemented
            if dmData.DebugLevel>=1 then Writeln(' Logged ADIF. Not implemented');
          end;    //Logged ADIF

    end; //case
     if mnuRemoteModeWsjt.Checked then         // must do this check. Otherwise at decode 6 ://Close  calling DisableRemoteMode
                   tmrWsjtx.Enabled  := True;  // causes exception if wsjt-x is closed but cqrlog still running.
                                               // Now end of decode and wsjt-x still running: Allow timer run again.
     if dmData.DebugLevel>=1 then Writeln('-----------------------decode end-----------------------------------');
     end;  //if WsjtxSock.lasterror=0 then
   end;  // while datagrams in buffer
  end; //waiting data
  WsjtxDecodeRunning := false;
  tmrWsjtx.Enabled:=true;

end;
{
  The latest UDP message protocol as always is documented in the latest revision of the NetworkMessage.hpp header file:
  https://sourceforge.net/p/wsjt/wsjtx/ci/master/tree/Network/NetworkMessage.hpp

  The reference implementations, particularly message_aggregator, can always be used to verify behaviour or
  to construct a recipe to replicate an issue.
   }

procedure TfrmNewQSO.FormCreate(Sender: TObject);
begin
  StartRun := false;
  CWint := nil;
  tmrRadio.Enabled := False;
  fViewQSO := False;
  fEditQSO := False;
  FromDXC  := False;
  ShowWin  := False;
  old_t_band := '';
  old_t_mode := '';
  old_prof   := -1;
  old_prop   := '';
  old_sat    := '';
  old_rxfreq := '';
  WhatUpNext := upHamQTH;
  UploadAll  := False;
  was_call   := '';
  AnyRemoteOn := False;
end;

procedure TfrmNewQSO.btnSaveClick(Sender: TObject);
var
  tmp    : Integer;
  myloc  : String;
  id     : LongInt = 0;
  Delete : Boolean = False;
  ShowMain : Boolean = False;
  date     : TDate;
  RxFreq   : Double = 0;
  key      : word = $24; //Home-key
begin
  ShowMain := (fEditQSO or fViewQSO) and (not fromNewQSO);
  if not cbOffline.Checked then
  begin
    edtStartTimeExit(nil);
    edtEndTimeExit(nil)
  end;
  if fViewQSO then
    exit;
  if edtCall.Text = '' then
    exit;

  if edtITU.Text = '' then
    edtITU.Text := '0';
  if edtWAZ.Text = '' then
    edtWAZ.Text := '0';
  if edtDOK.Text <> '' then
  begin
    // DF2ET, 10.06.2020: Replace special char Ø by 0
    edtDOK.Text := ReplaceRegExpr('Ø', edtDOK.Text, '0', True);
    //DL7OAP: DOK can be 'H24', 'h 24' or 'H-24', etc.
    //thats why we clean it with RegExp so only letters and figures are left
    edtDOK.Text := UpperCase(ReplaceRegExpr('[^a-zA-Z0-9]', edtDOK.Text, '', True)); //ARegExpr, AInputStr, AReplaceStr
  end;

  if not dmUtils.IsDateOK(edtDate.Text) then
  begin
    Application.MessageBox('You must enter correct date!', 'Error', mb_ok + mb_IconError);
    edtDate.SetFocus;
    exit
  end;

  if not dmUtils.IsTimeOK(edtStartTime.Text) then
  begin
    Application.MessageBox('You must enter correct time!', 'Error', mb_ok + mb_IconError);
    edtStartTime.SetFocus;
    exit
  end;

  if not dmUtils.IsTimeOK(edtEndTime.Text) then
  begin
    Application.MessageBox('You must enter correct time!', 'Error', mb_ok + mb_IconError);
    edtEndTime.SetFocus;
    exit
  end;

  tmp := 0;
  if NOT TryStrToInt(edtWAZ.Text,tmp) then
  begin
    Application.MessageBox('You must enter correct WAZ zone!','Error', MB_ICONERROR + MB_OK);
    edtWAZ.SetFocus;
    exit
  end;

  if NOT TryStrToInt(edtITU.Text,tmp) then
  begin
    Application.MessageBox('You must enter correct ITU zone!','Error', MB_ICONERROR + MB_OK);
    edtITU.SetFocus;
    exit
  end;

  if (dmUtils.GetBandFromFreq(cmbFreq.Text) = '') then
  begin
    Application.MessageBox('You must enter correct frequency (in MHz)', 'Error', MB_ICONERROR + MB_OK);
    cmbFreq.SetFocus;
    exit
  end;

  dmData.SaveComment(edtCall.Text,mComment.Text);

  if fEditQSO then
    myloc := copy(sbNewQSO.Panels[0].Text,Length(cMyLoc)+1,6)
   else
    myloc := CurrentMyLoc;

  if NOT dmUtils.IsLocOK(myloc) then
    myloc := '';

  //Writeln('OldCall:',old_call);
  //Writeln('OldPfx:',old_pfx);
  //Writeln('ChangeDXCC:',ChangeDXCC);

  {
  if (old_call = edtCall.Text) and (old_adif <> adif) then
    ChangeDXCC := True; //if user chooses another country by direct enter to the edtDXCCref
                     //without clicking to btnDXCCRef

   OH1KH 2022.12.30

    Above does not work as EDITQSO does not properly set adif and old_adif from qso data from database.
    Force changes always via btnDXCCRef.
    Otherwise EditQSO changes to DXCCref are not saved. (because old_adf & adif values are false set)
    }
  if not TryStrToFloat(edtRXFreq.Text, RxFreq) then
    RxFreq := 0;

  if fEditQSO then
  begin
    if fromNewQSO then
      id := dmData.qQSOBefore.FieldByName('id_cqrlog_main').AsInteger
    else
      id := dmData.qCQRLOG.FieldByName('id_cqrlog_main').AsInteger;
    dmData.EditQSO(dmUtils.StrToDateFormat(edtDate.Text),
                   edtStartTime.Text,
                   edtEndTime.Text,
                   edtCall.Text,
                   StrToCurr(cmbFreq.Text),
                   cmbMode.Text,
                   edtHisRST.Text,
                   edtMyRST.Text,
                   edtName.Text,
                   edtQTH.Text,
                   cmbQSL_S.Text,
                   cmbQSL_R.Text,
                   edtQSL_VIA.Text,
                   cmbIOTA.Text,
                   edtPWR.Text,
                   StrToInt(edtITU.Text),
                   StrToInt(edtWAZ.Text),
                   edtGrid.Text,
                   myloc,
                   edtCounty.Text,
                   edtAward.Text,
                   edtRemQSO.Text,
                   adif,
                   idcall,
                   edtState.Text,
                   edtDOK.Text,
                   lblCont.Caption,
                   ChangeDXCC,
                   dmData.GetNRFromProfile(cmbProfiles.Text),
                   dmSatellite.GetPropShortName(cmbPropagation.Text),
                   dmSatellite.GetSatShortName(cmbSatellite.Text),
                   RxFreq,
                   Editid,
                   edtContestSerialReceived.Text,
                   edtContestSerialSent.Text,
                   edtContestExchangeMessageReceived.Text,
                   edtContestExchangeMessageSent.Text,
                   edtContestName.Text,
                   Op);
    if (old_call<>edtCall.Text) or (old_mode<>cmbMode.Text) or (StrToFloat(old_freq)<>StrToFloat(cmbFreq.Text)) or
       (old_date<>StrToDate(edtDate.Text)) or (old_time<>edtStartTime.Text) or (old_rsts<>edtHisRST.Text) or
       (old_rstr<>edtMyRST.Text) then
    begin
      dmData.RemoveeQSLUploadedFlag(id);
      dmData.RemoveLoTWUploadedFlag(id)
    end
  end
  else
   begin
     if (not AnyRemoteOn) and edtCall.Focused then
                                               edtCallExit(nil);

    old_prof   := dmData.GetNRFromProfile(cmbProfiles.Text);
    old_sat    := dmSatellite.GetSatShortName(cmbSatellite.Text);
    old_prop   := dmSatellite.GetPropShortName(cmbPropagation.Text);
    old_rxfreq := edtRXFreq.Text;
    date := StrToDate(edtDate.Text);
    {
    if (not cbOffline.Checked) or (mnuRemoteMode.Checked) then
    begin
      stmp    := edtStartTime.Text;
      stmp[3] := char('');
      ton     := StrToInt(stmp);

      stmp    := edtEndTime.Text;
      stmp[3] := char('');
      toff    := StrToInt(stmp);

      if (ton > toff) then
        date := date-1
    end;
    }
    cqrini.WriteString('TMPQSO','FREQ',cmbFreq.Text);
    cqrini.WriteString('TMPQSO','Mode',cmbMode.Text);
    cqrini.WriteString('TMPQSO','PWR',edtPWR.Text);
    cqrini.WriteBool('TMPQSO','OFF',cbOffline.Checked);
    delete := cqrini.ReadBool('BandMap','DeleteAfterQSO',True);
    if edtITU.Text = '' then
      edtITU.Text := '0';
    if edtWAZ.Text = '' then
      edtWAZ.Text := '0';
    if not cbOffline.Checked then
    begin
      if cqrini.ReadBool('BandMap','AddAfterQSO',False) then
        acAddToBandMap.Execute;
      if Delete then
        frmBandMap.DeleteFromBandMap(edtCall.Text,cmbMode.Text,dmUtils.GetBandFromFreq(cmbFreq.Text))
    end;
    dmData.SaveQSO(date,
                   edtStartTime.Text,
                   edtEndTime.Text,
                   edtCall.Text,
                   StrToCurr(cmbFreq.Text),
                   cmbMode.Text,
                   edtHisRST.Text,
                   edtMyRST.Text,
                   edtName.Text,
                   edtQTH.Text,
                   cmbQSL_S.Text,
                   cmbQSL_R.Text,
                   edtQSL_VIA.Text,
                   cmbIOTA.Text,
                   edtPWR.Text,
                   StrToInt(edtITU.Text),
                   StrToInt(edtWAZ.Text),
                   edtGrid.Text,
                   myloc,
                   edtCounty.Text,
                   edtAward.Text,
                   edtRemQSO.Text,
                   adif,
                   idcall,
                   edtState.Text,
                   edtDOK.Text,
                   lblCont.Caption,
                   ChangeDXCC,
                   dmData.GetNRFromProfile(cmbProfiles.Text),
                   frmQSODetails.ClubNR1,
                   frmQSODetails.ClubNR2,
                   frmQSODetails.ClubNR3,
                   frmQSODetails.ClubNR4,
                   frmQSODetails.ClubNR5,
                   dmSatellite.GetPropShortName(cmbPropagation.Text),
                   dmSatellite.GetSatShortName(cmbSatellite.Text),
                   RxFreq,
                   edtContestSerialReceived.Text,
                   edtContestSerialSent.Text,
                   edtContestExchangeMessageReceived.Text,
                   edtContestExchangeMessageSent.Text,
                   edtContestName.Text,
                   Op
                   )
   end;
  if (cmbPropagation.Text = 'SAT|Satellite') then
  begin
     if (cqrini.ReadBool('NewQSO','UpdateAMSATstatus',False)) then
        dmSatellite.UpdateAMSATStatusPage(edtDate.Text, edtStartTime.Text, cmbSatellite.Text, cmbFreq.Text, edtRXFreq.Text, cmbMode.Text);
  end;
  if fEditQSO and (not fromNewQSO) then
  begin
    dmData.RefreshMainDatabase(id);
    if cqrini.ReadBool('OnlineLog','IgnoreEdit',False) then
     Begin
       dmLogUpload.DisableOnlineLogSupport;
       dmLogUpload.EnableOnlineLogSupport;
     end;
  end;
  if not AnyRemoteOn then
                       UnsetEditLabel;
  dmData.qQSOBefore.Close;

  was_call := edtCall.Text;
  edtCall.Text := ''; //calls ClearAll  (except when EDITQSO to be sure that callsign changes do not clear all)
  Sleep(200); //to be sure edtCallChange has time to run;

  if (cqrini.ReadBool('NewQSO','RefreshAfterSave', True) and frmMain.Showing) then
    begin
     frmMain.acRefresh.Execute;
     if not fEditQso then
       begin
            if frmContest.Showing and frmContest.chkSetFilter.Checked then
              frmContest.chkSetFilterClick(nil) //shows last logged qso
            else
             frmMain.dbgrdMainKeyUp(nil,key,[ssCtrl]); //shows last logged qso
       end

    end;
  if fEditQso then
             ClearAll;
  old_ccall := '';
  old_cfreq := '';
  old_cmode := '';

  if cqrini.ReadBool('NewQSO','ClearRIT',False) then
    frmTRXControl.ClearRIT;

  fEditQSO := False; //this should be cleared by clearAll. Needed here ???
  UploadAllQSOOnline;
  if frmWorkedGrids.Showing then frmWorkedGrids.UpdateMap;
  Op := cqrini.ReadString('TMPQSO','OP','');
  ShowOperator;

  if AnyRemoteOn then
     frmNewQSO.SendToBack
    else
     begin
      if ShowMain and frmMain.Showing then
        begin
          frmMain.BringToFront;
          frmMain.BringToFront;
          frmMain.dbgrdMain.SetFocus
        end
        else
         Begin
          if cbOffline.Checked then edtDate.SetFocus
                               else ReturnToNewQSO;
         end;
     end;

end;

procedure TfrmNewQSO.btnCancelClick(Sender: TObject);
begin
  if (edtCall.Text<>'') and FirstClose and (Sender<>nil) then
   Begin
    btnCancel.Caption:='Unsaved qso?';
    btnCancel.Hint:='Do you have unsaved qso?'+LineEnding+'2nd click will close anyway';
    btnCancel.ShowHint:=True;
    btnCancel.Font.Color:=clFuchsia;
    btnCancel.Font.Style:=[fsBold];
    btnCancel.Repaint;
    Application.ProcessMessages;
    FirstClose:=false;
   end
  else
   Begin
    Application.ProcessMessages;
    sleep(100);
    acClose.Execute
   end;
end;

procedure TfrmNewQSO.edtCallKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  tmp  : Extended = 0;
  mode : String  = '';
  Skip : Boolean = False;
begin
  if ((key = 40) or ((key = VK_SPACE) and UseSpaceBar)) then  //down arrow
  begin
     skip :=  cqrini.ReadBool('NewQSO','SkipModeFreq',True);
    if (not skip) or fEditQSO or fViewQSO or cbOffline.Checked then
      cmbFreq.SetFocus
    else begin
      edtHisRST.SetFocus;
      edtHisRST.SelStart  := 1;
      edtHisRST.SelLength := 1;
    end;
    key := 0;
    exit
  end;
  if (key = 38) then //up arrow
  begin
    mComment.SetFocus;
    key := 0;
    exit
  end;
  if key = 13 then  //enter
  begin
    key := 0;
    if TryStrToFloat(edtCall.Text,tmp) then   //if call is number then set frequency
    begin
      mode := dmUtils.GetModeFromFreq(FloatToStr(tmp/1000));
      frmTRXControl.SetModeFreq(mode,FloatToStr(tmp));
      key := 0;
      edtCall.Text := '';
      exit
    end
    else
      btnSave.Click
  end;
  if key = VK_TAB then
    TabUsed := True
end;


procedure TfrmNewQSO.edtCallKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if not ((chr(key) in AllowedCallChars)) then
    exit;
  if (edtCall.Text='') or (Length(edtCall.Text) < 2) then
  begin
    lblQSLMgr.Visible := False;
    edtQSL_VIA.Text   :=  '';
    frmSCP.mSCP.Clear;
    exit
  end;
  if (not (fViewQSO or fEditQSO or cbOffline.Checked or lblQSOTakes.Visible)) then
  begin
    SetDateTime();
    ShowDXCCInfo
  end
  else begin
    if ChangeDXCC then
      ShowDXCCInfo(adif)
    else
      ShowDXCCInfo
  end;
  if old_adif <> adif then
  begin
    old_adif := adif;
    ShowCountryInfo;
    ChangeReports;
    dmUtils.ShowStatistic(adif,old_stat_adif,sgrdStatistic);
  end;

  CalculateDistanceEtc;
  if (lblDXCC.Caption <> '!') and (lblDXCC.Caption <> '#') then
  begin
    if frmGrayline.Showing then
    begin
      DrawGrayline
    end
  end;
  if NOT (old_call = '') then
  begin
    if (old_call <> edtCall.Text) and (QTHfromCb) then
    begin
      edtName.Text := '';
      edtQTH.Text  := ''
    end
  end
end;

procedure TfrmNewQSO.edtCountyEnter(Sender: TObject);
begin
  if (dmUtils.IsIOTAOK(cmbIOTA.Text)) then
  begin
    frmQSODetails.iota := cmbIOTA.Text
  end;
  edtCounty.SelectAll
end;

procedure TfrmNewQSO.edtCountyExit(Sender: TObject);
begin
  CheckCountyClub
end;

procedure TfrmNewQSO.edtCountyKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = 40) then  //down arrow
  begin
    edtAward.SetFocus;
    key := 0
  end;
  if (key = 38) then //up arrow
  begin
    if edtState.IsVisible then
      edtState.SetFocus
    else
      edtDOK.SetFocus;
    key := 0
  end
end;

procedure TfrmNewQSO.edtCQKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = 40) then  //down arrow
  begin
    cmbIOTA.SetFocus;
    key := 0;
  end;
  if (key = 38) then //up arrow
  begin
    edtITU.SetFocus;
    key := 0;
  end;
  if ((key = VK_SPACE) and UseSpaceBar) then
  begin
    cmbIOTA.SetFocus;
    key := 0
  end
end;

procedure TfrmNewQSO.edtDateExit(Sender: TObject);
var
  tmp : String;
begin
  if fViewQSO then
    exit;
  if ((Length(edtDate.Text)<>10) or (not dmUtils.IsDateOK(edtDate.Text))) then
  begin
    edtDate.SetFocus;
    edtDate.SelectAll;
    exit;
  end;
  if not ChangeDXCC then
  begin
    ShowDXCCInfo;
    ShowCountryInfo;
  end;
  CheckCallsignClub;
  CheckQTHClub;
  CheckAwardClub;
  CheckCountyClub;
end;

procedure TfrmNewQSO.edtDateKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = 40) then  //down arrow
  begin
    edtStartTime.SetFocus;
    key := 0;
  end;
  if (key = 38) then //up arrow
  begin
    edtQSL_VIA.SetFocus;
    key := 0;
  end;
  if ((key = VK_SPACE) and UseSpaceBar) then
  begin
    edtStartTime.SetFocus;
    key := 0
  end;
end;


procedure TfrmNewQSO.edtAwardKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = 40) then  //down arrow
  begin
    edtDXCCRef.SetFocus;
    key := 0
  end;
  if (key = 38) then //up arrow
  begin
    edtCounty.SetFocus;
    key := 0
  end
end;

procedure TfrmNewQSO.edtDXCCRefExit(Sender: TObject);
begin
  if lblDXCC.Caption <> edtDXCCRef.Text then
  begin
    ShowCountryInfo;
    ShowCountryInfo;
  end;
end;

procedure TfrmNewQSO.edtDXCCRefKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = 40) then  //down arrow
  begin
    edtRemQSO.SetFocus;
    key := 0;
  end;
  if (key = 38) then //up arrow
  begin
    edtAward.SetFocus;
    key := 0;
  end;
  if ((key = VK_SPACE) and UseSpaceBar) then
  begin
    edtRemQSO.SetFocus;
    key := 0
  end
end;

procedure TfrmNewQSO.edtDateKeyPress(Sender: TObject; var Key: char);
begin
  if not (key in ['0'..'9','-',#24,#3,#22,#8,#127]) then   //CtrlX,CtrlC,CtrlV,BackSpace,DEL
    key := #0
end;

procedure TfrmNewQSO.edtEndTimeExit(Sender: TObject);
var
   f:integer;
   s:String;
begin
 s:= edtEndTime.Text;
 ModifyTimeFormat(s);
 edtEndTime.Text:=s;
 if not dmUtils.IsTimeOK(edtEndTime.Text) then
   begin
    edtEndTime.SetFocus;
    edtEndTime.SelectAll;
    exit;
  end;
 if (cbOffline.Checked) and (not AnyremoteOn) then
                                               edtCall.SetFocus;
end;
procedure TfrmNewQSO.edtEndTimeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = 40) then  //down arrow
  begin
    mComment.SetFocus;
    key := 0;
  end;
  if (key = 38) then //up arrow
  begin
    edtStartTime.SetFocus;
    key := 0;
  end;
  if ((key = VK_SPACE) and UseSpaceBar) then
  begin
    mComment.SetFocus;
    key := 0
  end;
  if ((key = VK_TAB) and cbOffline.Checked and (edtCall.Text='') and (not AnyRemoteOn)) then
   Begin
     ReturnToNewQSO;
     key := 0
   end;
end;


procedure TfrmNewQSO.edtHisRSTEnter(Sender: TObject);
begin
  cmbModeChange(nil);
  if TabUsed then
  begin
    edtHisRST.SelectAll;
    TabUsed := False
  end
  else begin
    edtHisRST.SelStart  := 1;
    edtHisRST.SelLength := 1
  end
end;

procedure TfrmNewQSO.edtHisRSTKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = 40) then  //down arrow
  begin
    edtMyRST.SetFocus;
    //edtMyRST.SelStart  := 1;
    //edtMyRST.SelLength := 1;
    key := 0;
  end;
  if (key = 38) then //up arrow
  begin
    cmbMode.SetFocus;
    key := 0;
  end;
  if ((key = VK_SPACE) and UseSpaceBar) then
  begin
    edtMyRST.SetFocus;
    edtMyRST.SelStart  := 1;
    edtMyRST.SelLength := 1;
    key := 0;
  end;
  if key = VK_TAB then
    TabUsed := True
end;

procedure TfrmNewQSO.edtITUExit(Sender: TObject);
begin
  frmQSODetails.itu := edtITU.Text
end;

procedure TfrmNewQSO.edtITUKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = 40) then  //down arrow
  begin
    edtWAZ.SetFocus;
    key := 0;
  end;
  if (key = 38) then //up arrow
  begin
    cmbQSL_R.SetFocus;
    key := 0;
  end;
  if ((key = VK_SPACE) and UseSpaceBar) then
  begin
    edtWAZ.SetFocus;
    key := 0
  end
end;

procedure TfrmNewQSO.edtMyRSTEnter(Sender: TObject);
begin
  if not (fViewQSO or fEditQSO or cbOffline.Checked or (edtCall.Text='') or lblQSOTakes.Visible ) then
  begin
    SetDateTime(False);
    tmrStart.Enabled := True;
    tmrStartTimer(nil);
    tmrEnd.Enabled   := False;
    tmrStart.Enabled := False;
    tmrEnd.Enabled := True;
    tmrEndTimer(nil);
  end;
  if TabUsed then
  begin
    edtMyRST.SelectAll;
    TabUsed := False
  end
  else begin
    edtMyRST.SelStart  := 1;
    edtMyRST.SelLength := 1
  end
end;

procedure TfrmNewQSO.edtMyRSTKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = 40) then  //down arrow
  begin
    edtName.SetFocus;
    key := 0;
  end;
  if (key = 38) then //up arrow
  begin
    key := 0;
    edtHisRST.SetFocus;
  end;
  if ((key = VK_SPACE) and UseSpaceBar) then
  begin
    edtName.SetFocus;
    key := 0;
  end;
end;

procedure TfrmNewQSO.edtNameChange(Sender: TObject);
var
  tmp : String;
begin
  if (UTF8length(edtName.Text)=1) and cqrini.ReadBool('NewQSO','CapFirstQTHLetter',True) then
  begin
    tmp := edtName.Text;
    tmp:=dmUtils.UTF8UpperFirst(tmp);
    edtName.Text := tmp;
    edtName.SelStart:=1;
  end
end;

procedure TfrmNewQSO.edtNameKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = 40) then  //down arrow
  begin
    edtQTH.SetFocus;
    key := 0;
  end;
  if (key = 38) then //up arrow
  begin
    edtMyRST.SetFocus;
    edtMyRST.SelStart  := 1;
    edtMyRST.SelLength := 1;
    key := 0;
  end;
  if ((key = VK_SPACE) and UseSpaceBar) then
  begin
    edtQTH.SetFocus;
    key := 0;
  end;
  if ((key = VK_A) and (Shift=[ssAlt])) then
     Begin
      edtName.SelectAll;
      key:=0;
     end;
end;

procedure TfrmNewQSO.edtPWRKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = 40) then  //down arrow
  begin
    cmbQSL_S.SetFocus;
    key := 0;
  end;
  if (key = 38) then //up arrow
  begin
    edtGrid.SetFocus;
    key := 0;
  end;
  if ((key = VK_SPACE) and UseSpaceBar) then
  begin
    cmbQSL_S.SetFocus;
    key := 0
  end
end;

procedure TfrmNewQSO.edtQSL_VIAKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = 40) then  //down arrow
  begin
    edtDate.SetFocus;
    key := 0;
  end;
  if (key = 38) then //up arrow
  begin
    edtRemQSO.SetFocus;
    key := 0;
  end;
  if ((key = VK_SPACE) and UseSpaceBar) then
  begin
    edtDate.SetFocus;
    key := 0
  end
end;

procedure TfrmNewQSO.edtQTHChange(Sender: TObject);
var
  tmp : String;
begin
  if (UTF8length(edtQTH.Text)=1) and cqrini.ReadBool('NewQSO','CapFirstQTHLetter',True) then
  begin
    tmp := edtQTH.Text;
    tmp:=dmUtils.UTF8UpperFirst(tmp);
    edtQTH.Text := tmp;
    edtQTH.SelStart:=1;
  end;
end;
procedure TfrmNewQSO.edtQTHExit(Sender: TObject);
Begin
  CheckQTHClub
end;

procedure TfrmNewQSO.edtQTHKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = 40) then  //down arrow
  begin
    edtGrid.SetFocus;
    key := 0;
  end;
  if (key = 38) then //up arrow
  begin
    edtName.SetFocus;
    key := 0;
  end;
end;

procedure TfrmNewQSO.edtRemQSOKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = 40) then  //down arrow
  begin
    edtQSL_VIA.SetFocus;
    key := 0;
  end;
  if (key = 38) then //up arrow
  begin
    edtDXCCRef.SetFocus;
    key := 0;
  end;
end;
procedure TfrmNewQSO.ModifyTimeFormat( var time:string);
var f:integer;
begin
 if length(time)=4 then  //auto insert ':' if there are 4 numbers
  begin
    for f:=1 to 4 do
     Begin
      if not ord(time[f]) in [ 48..57 ] then
                                           exit;
     end;
    time:=copy(time,1,2)+':'+copy(time,3,2);
  end;
end;
procedure TfrmNewQSO.edtStartTimeExit(Sender: TObject);
var s:String;
Begin
 s:= edtStartTime.Text;
 ModifyTimeFormat(s);
 edtStartTime.Text:=s;
 if not dmUtils.IsTimeOK(edtStartTime.Text) then
   begin
    edtStartTime.SetFocus;
    edtStartTime.SelectAll;
    exit;
  end;
  if cbOffline.Checked then
    edtEndTime.Text := edtStartTime.Text;
end;

procedure TfrmNewQSO.edtStartTimeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = 40) then  //down arrow
  begin
    edtEndTime.SetFocus;
    key := 0
  end;
  if (key = 38) then //up arrow
  begin
    edtDate.SetFocus;
    key := 0
  end;
  if ((key = VK_SPACE) and UseSpaceBar) then
  begin
    edtEndTime.SetFocus;
    key := 0
  end;
end;

procedure TfrmNewQSO.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  btnCancel.Caption:=' Closing... ';
  btnCancel.Font.Color:=clRed;
  btnCancel.Font.Style:=[fsBold];
  btnCancel.Repaint;
  sleep(10);
  Application.ProcessMessages;
  sleep(10);
  if cqrini.ReadBool('Backup','Enable',False) then
  begin
    if cqrini.ReadBool('Backup','AskFirst',False) then
    begin
      case Application.MessageBox('Do you want to backup your log data?'+#13+#13+'("Cancel" = Do not exit cqrlog)','Exit & backup',mb_YesNoCancel+mb_IconQuestion) of
        idCancel : begin
                     CloseAction := TCloseAction(caNone);
                     exit
                   end;
        idYes : CreateAutoBackup()
      end //case
    end
    else
      CreateAutoBackup()
  end;
  frmTRXControl.StopPwrUpdate:=-254; //prevent rig power polling while Cqrlog is closing
  RunST('stop.sh'); //run "when cqrlog is closing" -script
  sleep(1000); //give scirpt time to use rigctld if that is needed
  if  AnyRemoteOn then DisableRemoteMode;
  CloseAllWindows;
  SaveSettings;
  dmData.CloseDatabases
end;

procedure TfrmNewQSO.cmbFreqKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = 40) then  //down arrow
  begin
    cmbMode.SetFocus;
    key := 0
  end;
  if (key = 38) then //up arrow
  begin
    ReturnToNewQSO;
    key := 0
  end;
  if ((key = VK_SPACE) and UseSpaceBar) then
  begin
    cmbMode.SetFocus;
    key := 0
  end;
  if key = VK_TAB then
  begin
    key := 0;
    cmbMode.SetFocus;
    TabUsed := True
  end;
end;

procedure TfrmNewQSO.cmbIOTAChange(Sender: TObject);
begin
  if (dmUtils.IsIOTAOK(cmbIOTA.Text)) then
  begin
    frmQSODetails.iota := cmbIOTA.Text;
  end;
end;

procedure TfrmNewQSO.cmbIOTAExit(Sender: TObject);
begin
  if (dmUtils.IsIOTAOK(cmbIOTA.Text)) then
  begin
    frmQSODetails.iota := cmbIOTA.Text
  end
end;

procedure TfrmNewQSO.cmbIOTAKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = 40) then  //down arrow
  begin
    if edtState.IsVisible then
      edtState.SetFocus
    else
      edtDOK.SetFocus;

    key := 0
  end;
  if (key = 38) then //up arrow
  begin
    edtWAZ.SetFocus;
    key := 0
  end;
  if ((key = VK_SPACE) and UseSpaceBar) then
  begin
    if edtState.IsVisible then
      edtState.SetFocus
    else
      edtDOK.SetFocus;
    key := 0
  end
end;

procedure TfrmNewQSO.cmbModeChange(Sender: TObject);
begin
  ShowCountryInfo;
  ChangeReports;

  if (ModeBeforeChange = 'CW') and (cmbMode.Text <> 'CW') then
  begin
    //flush CW buffer when entering to CW (specially HamLib keyer)
    if (Assigned(CWint)) then
      CWint.StopSending;
  end;

  ModeBeforeChange := cmbMode.Text;
end;

procedure TfrmNewQSO.cmbModeEnter(Sender: TObject);
begin
  ModeBeforeChange := cmbMode.Text;
  cmbMode.SelectAll
end;

procedure TfrmNewQSO.cmbModeExit(Sender: TObject);
begin
  if (not (fViewQSO or fEditQSO)) then
    cmbQSL_S.Text := dmData.SendQSL(edtCall.Text,cmbMode.Text,cmbFreq.Text,adif);

  if cmbMode.Text <> old_mode then
  begin
    ShowCountryInfo;
    ChangeReports;
    CheckCallsignClub
  end
end;

procedure TfrmNewQSO.cmbFreqEnter(Sender: TObject);
begin
  cmbFreq.SelectAll
end;

procedure TfrmNewQSO.btnDXCCRefClick(Sender: TObject);
var
  waz,itu,cont,lat,long,cname : String;
  old : String;
  q : TSQLQuery;
begin
  if fViewQSO then
    exit;
  frmSelectDXCC := TfrmSelectDXCC.Create(self);
  try
    frmSelectDXCC.edtPrefix.Text := edtDXCCRef.Text;
    old := edtDXCCRef.Text;
    frmSelectDXCC.pgDXCC.PageIndex := 0;
    frmSelectDXCC.ShowModal;
    if frmSelectDXCC.ModalResult = mrOK then
    begin
      if Pos('*',frmSelectDXCC.edtPrefix.Text) = 0 then
      begin
        q := dmDXCC.qValid;
      end
      else begin
        q := dmDXCC.qDeleted;
      end;
      if old = q.Fields[1].AsString then
        exit;

      ChangeDXCC         := True;
      edtDXCCRef.Text    := q.Fields[1].AsString;
      lblDXCC.Caption    := q.Fields[1].AsString;
      mCountry.Clear;
      mCountry.Text      := q.Fields[2].AsString;
      lblCont.Caption    := q.Fields[3].AsString;
      lblLat.Caption     := q.Fields[5].AsString;
      lblLong.Caption    := q.Fields[6].AsString;

      waz := q.Fields[8].AsString;
      itu := q.Fields[7].AsString;
      adif:= q.Fields[9].AsInteger;
      dmUtils.ModifyWAZITU(waz,itu);
      edtWAZ.Text        := waz;
      edtITU.Text        := itu;

      lblHisTime.Caption := dmUtils.HisDateTime(edtDXCCRef.Text);
      ShowCountryInfo;
      dmUtils.ShowStatistic(q.FieldByName('ADIF').AsInteger,old_stat_adif,sgrdStatistic);
      if dmData.GetIOTAForDXCC(edtCall.Text, lblDXCC.Caption, cmbIOTA, dmUtils.MyStrToDate(edtDate.Text)) then
        lblIOTA.Font.Color := clRed
      else
        lblIOTA.Font.Color := clDefault
    end
  finally
    frmSelectDXCC.Free
  end
end;

procedure TfrmNewQSO.btnQSLMgrClick(Sender: TObject);
begin
  frmQSLMgr := TfrmQSLMgr.Create(self);
  try
    dmData.qQSLMgr.SQL.Text := 'select callsign,qsl_via,fromdate from cqrlog_common.qslmgr order by callsign,fromDate';
    if dmData.trQSLMgr.Active then
      dmData.trQSLMgr.Rollback;
    dmData.trQSLMgr.StartTransaction;
    dmData.qQSLMgr.Open;
    frmQSLMgr.edtCallsign.Text := edtCall.Text;
    frmQSLMgr.btnFind.Click;
    frmQSLMgr.ShowModal;
    if frmQSLMgr.ModalResult = mrOK then
      edtQSL_VIA.Text := dmData.qQSLMgr.Fields[1].AsString
  finally
    dmData.qQSLMgr.Close;
    dmData.trQSLMgr.Rollback;
    frmQSLMgr.Free
  end
end;

procedure TfrmNewQSO.acCloseExecute(Sender: TObject);
begin
  Close
end;

procedure TfrmNewQSO.acDXCCCfmExecute(Sender: TObject);
begin
  with TfrmDXCCStat.Create(self) do
  try
    ShowModal
  finally
    Free
  end
end;

procedure TfrmNewQSO.acDXClusterExecute(Sender: TObject);
begin
  if frmDXCluster.Showing then
    frmDXCluster.BringToFront
  else
    frmDXCluster.Show;
end;

procedure TfrmNewQSO.acDetailsExecute(Sender: TObject);
begin
  frmQSODetails.Show;
  frmQSODetails.BringToFront;
end;

procedure TfrmNewQSO.acEditQSOExecute(Sender: TObject);
begin
  if (dmData.qQSOBefore.RecordCount > 0) and (not AnyRemoteOn)  then
  begin
    Caption := dmUtils.GetNewQSOCaption('Edit QSO');
    EditQSO := True;
    ViewQSO := False;
    SetEditLabel;
    fromNewQSO := true;
    ShowQSO
  end
end;

procedure TfrmNewQSO.acGraylineExecute(Sender: TObject);
begin
  if frmGrayline.Showing then
    frmGrayline.BringToFront
  else
    frmGrayline.Show;
end;

procedure TfrmNewQSO.acITUCfmExecute(Sender: TObject);
begin
  with TfrmWAZITUStat.Create(self) do
  try
    StatType := tsITU;
    ShowModal
  finally
    Free
  end
end;

procedure TfrmNewQSO.acLongNoteExecute(Sender: TObject);
var
  new : Boolean = False;
begin
  with TfrmLongNote.Create(self) do
  try
    dmData.qLongNote.Close();
    if dmData.trLongNote.Active then dmData.trLongNote.Rollback;
    dmData.qLongNote.SQL.Text := 'SELECT id_long_note, note FROM long_note';
    dmData.trLongNote.StartTransaction;
    try
      dmData.qLongNote.Open();
      if dmData.qLongNote.Fields[0].IsNull then
        new := True;
      mNote.Lines.Text := dmData.qLongNote.Fields[1].AsString;
    finally
      dmData.qLongNote.Close();
      dmData.trLongNote.Rollback
    end;
    ShowModal;
    if ModalResult = mrOK then
    begin
      if new then
        dmData.qLongNote.SQL.Text := 'insert into long_note(id_long_note,note) values (1,:note)'
      else
        dmData.qLongNote.SQL.Text := 'UPDATE long_note set note = :note where id_long_note = 1';
      try try
        dmData.qLongNote.Params[0].AsString := mNote.Text;
        dmData.trLongNote.StartTransaction;
        dmData.qLongNote.ExecSQL;
      dmData.trLongNote.Commit;
      dmData.qLongNote.Close();
      except
        dmData.trLongNote.Rollback
      end
      finally
        if dmData.trLongNote.Active then
          dmData.trLongNote.Commit;
        dmData.qLongNote.Close()
      end
    end
  finally
    Free
  end
end;

procedure TfrmNewQSO.MenuItem9Click(Sender: TObject);
begin
  with TfrmAbout.Create(Application) do
  try
    ShowModal
  finally
    Free
  end
end;

procedure TfrmNewQSO.acRemoteModeExecute(Sender: TObject);
var
  run    : Boolean = False;
  path   : String = '';
begin
  if mnuRemoteMode.Checked then
    DisableRemoteMode
  else
    GoToRemoteMode(rmtFldigi)
end;

procedure TfrmNewQSO.acWASCfmExecute(Sender: TObject);
begin
  with TfrmWAZITUStat.Create(self) do
  try
    StatType := tsWAS;
    ShowModal
  finally
    Free
  end
end;

procedure TfrmNewQSO.acDOKCfmExecute(Sender: TObject);
begin
  if FileExistsUTF8(dmData.HomeDir+'dok_data'+PathDelim+'dok.csv') and FileExistsUTF8(dmData.HomeDir+'dok_data'+PathDelim+'sdok.csv') then
  begin
    with TfrmDOKStat.Create(self) do
    try
      StatType := tsDOK;
      ShowModal
    finally
      Free
    end
  end
  else
  begin
    Application.MessageBox(PChar('DOK table is empty. Please ensure that the folder '+dmData.HomeDir+'dok_data exists and the files dok.csv and sdok.csv therein.'+sLineBreak+'You might also consider enabling the automatic update function in preferences.'),'Problem');
  end;
end;

procedure TfrmNewQSO.acAddToBandMapExecute(Sender: TObject);
var
  f : Double;
  lat, lng : Currency;
begin
  f := frmTRXControl.GetFreqMHz;
  if (f = 0.0) and  (cmbFreq.Text<>'') then
        f := StrToFloat(cmbFreq.Text);
  dmUtils.GetRealCoordinate(lblLat.Caption,lblLong.Caption,lat,lng);
  frmBandMap.AddToBandMap(f*1000,edtCall.Text,cmbMode.Text,dmUtils.GetBandFromFreq(cmbFreq.Text),'',lat,
                          lng,cqrini.ReadInteger('BandMap', 'NewQSOColor', clBlack),clWhite,True,sbtnLoTW.Visible,sbtneQSL.Visible)
end;

procedure TfrmNewQSO.acCWMessagesExecute(Sender: TObject);
begin
  frmKeyTexts := TfrmKeyTexts.Create(self);
  try
    frmKeyTexts.ShowModal;
    if frmKeyTexts.ModalResult = mrOK then
      UpdateFKeyLabels
  finally
    frmKeyTexts.Free
  end
end;

procedure TfrmNewQSO.acCWTypeExecute(Sender: TObject);
begin
  frmCWType.Show;
  if (CWint=nil) then
     ShowMessage('CW interface:  No keyer defined for current radio!');
end;

procedure TfrmNewQSO.FormActivate(Sender: TObject);
begin
  if minimalize then
  begin
    minimalize := False;
    if MinTRXControl then
    begin
       frmTRXControl.BringToFront;
       MinTRXControl := False
    end;
    if MinDXCluster then
    begin
      frmDXCluster.BringToFront;
      MinDXCluster := False;
    end;
    if MinGrayLine then
    begin
      frmGrayline.BringToFront;
      MinGrayLine := False;
    end;
    if MinQSODetails then
    begin
      frmQSODetails.BringToFront;
      MinQSODetails := False;
    end;
  end;
  if ShowWin then
  begin
    ShowWin := False;
    ShowWindows
  end
end;


procedure TfrmNewQSO.edtCallChange(Sender: TObject);
begin
  edtcall.text:=dmUtils.CallTrim(edtCall.text);
  if not EditQSO then
    if edtCall.Text = '' then
      ClearAll;
  if frmSCP.Showing and (Length(edtCall.Text)>2) then
    frmSCP.mSCP.Text := dmData.GetSCPCalls(edtCall.Text)
  else
    frmSCP.mSCP.Clear;
  lblGrid.Font.Style:=[];
  lblGrid.Font.Color:=clDefault;
end;


procedure TfrmNewQSO.edtCountyChange(Sender: TObject);   //works for all columns
var
  tmp, tmp1 :String;
  caret     :longint;
begin
  if (sender is Tedit) then
   begin
    tmp:= (Sender as Tedit).Text;
    caret:=(Sender as Tedit).CaretPos.x;
    tmp1:= dmUtils.NoNonAsciiChrs(tmp,true);
    (Sender as Tedit).Text := tmp1;
    if tmp <> tmp1 then
      Begin
        if caret<1 then caret:=1;
       (Sender as Tedit).SelStart:= caret-1;
      end;
   end;
end;

procedure TfrmNewQSO.edtDateEnter(Sender: TObject);
begin
  edtDate.SelectAll
end;
procedure TfrmNewQSO.edtDXCCRefEnter(Sender: TObject);
begin
  edtDXCCRef.SelectAll
end;

procedure TfrmNewQSO.edtEndTimeEnter(Sender: TObject);
begin
  edtEndTime.SelectAll
end;

procedure TfrmNewQSO.edtGridChange(Sender: TObject);
begin
  // this check is mainly for exports from remote.
  // keying has own checking
  edtGrid.Text := dmUtils.StdFormatLocator(edtGrid.Text);
  edtGrid.SelStart := Length(edtGrid.Text);
  edtGrid.SelLength:=0;
end;

procedure TfrmNewQSO.edtGridEnter(Sender: TObject);
begin
  edtGrid.SelectAll
end;

procedure TfrmNewQSO.edtGridExit(Sender: TObject);
begin
  if dmUtils.isLocOK(edtGrid.Text) then
    begin
     CalculateDistanceEtc;
     if (edtCall.Text='') then
       Begin
        //no need here // dmUtils.HamClockSetNewDE(CurrentMyloc,'','',UpperCase(cqrini.ReadString('Station', 'Call', '')));
         dmUtils.HamClockSetNewDX('','',edtGrid.Text);
       end;
     sbtnLocatorMap.Visible := True;
     lblGrid.Font.Style:=[];
     lblGrid.Font.Color:=clDefault;
    end
   else
    Begin
     lblGrid.Font.Style:=[fsBold];
     lblGrid.Font.Color:=clRed;
    end;
end;

procedure TfrmNewQSO.edtGridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = 40) then  //down arrow
  begin
    edtPWR.SetFocus;
    key := 0;
  end;
  if (key = 38) then //up arrow
  begin
    edtQTH.SetFocus;
    key := 0;
  end;
  if ((key = VK_SPACE) and UseSpaceBar) then
  begin
    edtPWR.SetFocus;
    key := 0
  end
end;
procedure TfrmNewQSO.edtGridKeyPress(Sender: TObject; var Key: char);
begin
  //pass only format AB12cd34ef and BS/DEL keys
  dmUtils.KeyInLoc(edtGrid.Text,Key);
end;

procedure TfrmNewQSO.acQSOListExecute(Sender: TObject);
begin
  frmMain.Show
end;

procedure TfrmNewQSO.acRBNMonitorExecute(Sender: TObject);
begin
  frmRBNMonitor.Show
end;

procedure TfrmNewQSO.acRefreshTimeExecute(Sender: TObject);
begin
  FillDateTimeFields
end;

procedure TfrmNewQSO.acRefreshTRXExecute(Sender: TObject);
begin
  frmTRXControl.InitializeRig;
  tmrRadio.Enabled := True;
  frmRotControl.InicializeRot;
  tmrRotor.Enabled := True
end;

procedure TfrmNewQSO.acReloadCWExecute(Sender: TObject);
begin
  InitializeCW
end;

procedure TfrmNewQSO.acReminderExecute(Sender: TObject);
begin
  frmReminder.OpenReminder;
end;

procedure TfrmNewQSO.acRemoteWsjtExecute(Sender: TObject);
begin
  if mnuRemoteModeWsjt.Checked then
    DisableRemoteMode
  else
    GoToRemoteMode(rmtWsjt)
end;

procedure TfrmNewQSO.acRotControlExecute(Sender: TObject);
begin
  frmRotControl.Show
end;

procedure TfrmNewQSO.acSCPExecute(Sender : TObject);
begin
  frmSCP.Show
end;

procedure TfrmNewQSO.acSendSpotExecute(Sender : TObject);
begin
  SendSpot
end;

procedure TfrmNewQSO.acShowStatBarExecute(Sender: TObject);
begin
  if sbNewQSO.Visible then
  begin
    sbNewQSO.Visible := False;
    acShowStatBar.Checked := False
  end
  else begin
    sbNewQSO.Visible := True;
    acShowStatBar.Checked := False
  end
end;

procedure TfrmNewQSO.acRemoteModeADIFExecute(Sender: TObject);
begin
   if mnuRemoteModeADIF.Checked then
    DisableRemoteMode
  else
    GoToRemoteMode(rmtADIF)
end;

procedure TfrmNewQSO.acTuneExecute(Sender : TObject);
begin
  if Assigned(CWint) then
  begin
    CWint.TuneStart;
    dmUtils.ShowTheMessage('Message','Tuning started... '+LineEnding+LineEnding+'OK to abort',10000);
    CWint.TuneStop
  end
  else
   begin
    frmTRXControl.HLTune(true);
    dmUtils.ShowTheMessage('Message','Tuning started... '+LineEnding+LineEnding+'OK to abort',10000);
    frmTRXControl.HLTune(false);
  end
end;

procedure TfrmNewQSO.acUploadToAllExecute(Sender: TObject);
begin
  if not tmrUploadAll.Enabled then
  begin
    UploadAll            := True;
    tmrUploadAll.Enabled := True
  end
end;

procedure TfrmNewQSO.acUploadToClubLogExecute(Sender: TObject);
begin
  frmLogUploadStatus.UploadDataToClubLog
end;

procedure TfrmNewQSO.acUploadToHamQTHExecute(Sender: TObject);
begin
  frmLogUploadStatus.UploadDataToHamQTH
end;

procedure TfrmNewQSO.acUploadToHrdLogExecute(Sender: TObject);
begin
  frmLogUploadStatus.UploadDataToHrdLog
end;

procedure TfrmNewQSO.acUploadToUDPLogExecute(Sender: TObject);
begin
  frmLogUploadStatus.UploadDataToUDPLog
end;

procedure TfrmNewQSO.acPropExecute(Sender: TObject);
begin
   frmPropagation.Show
end;

procedure TfrmNewQSO.btnClearSatelliteClick(Sender : TObject);
begin
  cmbPropagation.ItemIndex := 0;
  cmbSatellite.ItemIndex   := 0;
  edtRXFreq.Clear;
  old_sat:='';
  old_prop:='';
  cmbSatelliteChange(nil)
end;

procedure TfrmNewQSO.cbRxLoChange(Sender: TObject);
begin
  cqrini.WriteBool('NewQSO', 'UseRXLO', cbRxLo.Checked);
  if not (cbRxLo.Checked) then
    edtRXFreq.Text := '';
end;

procedure TfrmNewQSO.cbSplitTXChange(Sender: TObject);
begin
  cqrini.WriteBool('NewQSO', 'UseSplitTX', cbSplitTX.Checked);
  cbRxLo.Checked:=cbSplitTX.Checked;
  frmTRXControl.SetSplitTXRead(cbSplitTX.Checked);
end;

procedure TfrmNewQSO.cbTxLoChange(Sender: TObject);
begin
  cqrini.WriteBool('NewQSO', 'UseTXLO', cbTxLo.Checked);
end;

procedure TfrmNewQSO.cbSpotRXChange(Sender: TObject);
begin
  cqrini.WriteBool('DXCluster', 'SpotRX', cbSpotRX.Checked);
end;

procedure TfrmNewQSO.acCWFKeyExecute(Sender: TObject);
begin
  UpdateFKeyLabels;
  frmCWKeys.Show
end;

procedure TfrmNewQSO.acHotkeysExecute(Sender: TObject);
begin
  dmUtils.OpenInApp(dmData.HelpDir+'h20.html')
end;

procedure TfrmNewQSO.acLocatorMapExecute(Sender: TObject);
begin
  frmWorkedGrids.Show
end;

procedure TfrmNewQSO.acLogUploadStatusExecute(Sender: TObject);
begin
  frmLogUploadStatus.Show
end;

procedure TfrmNewQSO.acMonitorWsjtxExecute(Sender: TObject);
begin
  if (frmMonWsjtx = nil) then  Application.CreateForm(TfrmMonWsjtx, frmMonWsjtx);
  frmMonWsjtx.Show;
  cqrini.WriteBool('Window','MonWsjtx',true);
end;

procedure TfrmNewQSO.acBigSquareExecute(Sender: TObject);
begin
  frmBigSquareStat := TfrmBigSquareStat.Create(frmNewQSO);
  try
    frmBigSquareStat.ShowModal
  finally
    FreeAndNil(frmBigSquareStat)
  end
end;

procedure TfrmNewQSO.acCommentToCallsignExecute(Sender : TObject);
begin
  frmCommentToCall := TfrmCommentToCall.Create(frmNewQSO);
  try
    frmCommentToCall.ShowModal
  finally
    frmCommentToCall.Free
  end
end;

procedure TfrmNewQSO.acContestExecute(Sender: TObject);
begin
  frmContest.Show;
end;

procedure TfrmNewQSO.acCountyExecute(Sender: TObject);
begin
    frmCountyStat := TfrmCountyStat.Create(frmNewQSO);
  try
    frmCountyStat.ShowModal
  finally
    FreeAndNil(frmCountyStat)
  end
end;

procedure TfrmNewQSO.acOpenLogExecute(Sender: TObject);
var
  old : String;
  LogId   : Integer;
  LogName : String;
begin
  with TfrmDBConnect.Create(self) do
  try
    old := dmData.LogName;
    OpenFromMenu := True;
    ShowModal;
    if ModalResult = mrOK then
    begin
      if old = dmData.qLogList.Fields[1].AsString then exit;

      LogId   := dmData.qLogList.Fields[0].AsInteger;
      LogName := dmData.qLogList.Fields[1].AsString;

      frmDXCluster.StopAllConnections;
      CloseAllWindows;         //fixes issue #163
      SaveSettings;
      dmData.CloseDatabases;

      dmData.OpenDatabase(LogId);
      dmData.RefreshLogList(LogId);

      dmData.LogName := LogName;

      frmNewQSO.Caption := dmUtils.GetNewQSOCaption('New QSO');
      LoadSettings;
      ShowFields
    end
  finally
    Free
  end
end;

procedure TfrmNewQSO.acpDK0WCYExecute(Sender: TObject);
begin
   frmPropDK0WCY.Show
end;

procedure TfrmNewQSO.chkAutoModeChange(Sender: TObject);
begin
  frmTRXControl.AutoMode := chkAutoMode.Checked
end;


procedure TfrmNewQSO.cmbFreqExit(Sender: TObject);
var
    band :String;
begin
  if (not (fViewQSO or fEditQSO)) then
    cmbQSL_S.Text := dmData.SendQSL(edtCall.Text,cmbMode.Text,cmbFreq.Text,adif);
  CheckCallsignClub;
  CheckQTHClub;
  CheckAwardClub;
  CheckCountyClub;
  CheckStateClub;

  band := dmUtils.GetBandFromFreq(cmbFreq.Text);
  if (band <> old_t_band) then
     Begin
      btnClearSatelliteClick(nil); //if band changes sat and prop cleared
       old_t_band := band;
     end;
end;

procedure TfrmNewQSO.cmbIOTAEnter(Sender: TObject);
begin
  cmbIOTA.SelectAll
end;

procedure TfrmNewQSO.cmbPropagationChange(Sender : TObject);
begin
  if (cmbPropagation.Text <> '') or (cmbSatellite.Text <> '') or (edtRXFreq.Text <> '') then
    tabSatellite.Font.Color := clRed
  else
    tabSatellite.Font.Color := clDefault;
  old_prop   := dmSatellite.GetPropShortName(cmbPropagation.Text); //keep prop mode even when no qsos saved yet
end;

procedure TfrmNewQSO.cmbQSL_REnter(Sender: TObject);
begin
  cmbQSL_R.SelectAll
end;

procedure TfrmNewQSO.cmbQSL_RExit(Sender: TObject);
begin
  cmbQSL_R.Text := trim(cmbQSL_R.Text);
end;

procedure TfrmNewQSO.cmbQSL_SEnter(Sender: TObject);
begin
  cmbQSL_S.SelectAll
end;

procedure TfrmNewQSO.cmbQSL_SExit(Sender: TObject);
begin
  cmbQSL_S.Text := trim(cmbQSL_S.Text);
end;

procedure TfrmNewQSO.cmbSatelliteChange(Sender : TObject);
begin
  if (cmbSatellite.Text <> '') then // and (cmbPropagation.Text = '')) then
    cmbPropagation.Text := 'SAT|Satellite';

  old_sat := dmSatellite.GetSatShortName(cmbSatellite.Text);  //old_sat is now selected value
end;

procedure TfrmNewQSO.dbgrdQSOBeforeColumnSized(Sender: TObject);
begin
 dmUtils.SaveDBGridInForm(frmNewQSO)
end;

procedure TfrmNewQSO.dbgrdQSOBeforeExit(Sender: TObject);
//saving at OnColumnMoved procedure  saves column order (before move) so saving right order must be done here.
begin
  dmUtils.SaveDBGridInForm(frmNewQSO)
end;

procedure TfrmNewQSO.edtAwardEnter(Sender: TObject);
begin
  edtAward.SelectAll
end;

procedure TfrmNewQSO.edtHisRSTExit(Sender: TObject);
begin
  edtHisRST.SelStart  := 0;
  edtHisRST.SelLength := 0
end;

procedure TfrmNewQSO.edtHisRSTKeyPress(Sender : TObject; var Key : char);
begin
  SelTextFix(edtHisRST, Key)
end;
procedure TfrmNewQSO.edtITUEnter(Sender: TObject);
begin
  edtITU.SelectAll
end;

procedure TfrmNewQSO.edtMyRSTExit(Sender: TObject);
begin
  edtMyRST.SelStart  := 0;
  edtMyRST.SelLength := 0
end;

procedure TfrmNewQSO.edtMyRSTKeyPress(Sender : TObject; var Key : char);
begin
  SelTextFix(edtMyRST, Key)
end;

procedure TfrmNewQSO.edtNameEnter(Sender: TObject);
var
  tmp : String;
begin
  edtName.SelectAll
end;

procedure TfrmNewQSO.edtPWRChange(Sender: TObject);
begin

end;

procedure TfrmNewQSO.edtPWREnter(Sender: TObject);
begin
  edtPWR.SelectAll
end;

procedure TfrmNewQSO.edtQSL_VIAChange(Sender: TObject);
begin

end;

procedure TfrmNewQSO.edtQSL_VIAEnter(Sender: TObject);
begin
  edtQSL_VIA.SelectAll
end;

procedure TfrmNewQSO.edtQTHEnter(Sender: TObject);
begin
  edtQTH.SelectAll
end;

procedure TfrmNewQSO.edtRemQSOEnter(Sender: TObject);
begin
  edtRemQSO.SelectAll
end;

procedure TfrmNewQSO.edtRXFreqChange(Sender: TObject);
begin
  //prevents typing in too large number value for database
  if (length(edtRXFreq.Text)>6) then
    if ( (pos(',',edtRXFreq.Text) = 0) and (pos('.',edtRXFreq.Text) = 0) )then
     begin
         edtRXFreq.Text:= copy(edtRXFreq.Text,1,6);
         edtRXFreq.SelStart := Length(edtRXFreq.Text);
     end;
  //no jokes...
  if (pos('999999.9999',edtRXFreq.Text)>0) or (pos('999999,9999',edtRXFreq.Text)>0) then
    edtRXFreq.Text:= '';
end;

procedure TfrmNewQSO.edtRXFreqExit(Sender: TObject);
begin
  edtRXFreq.Text := CheckFreq(edtRXFreq.Text);
  old_rxfreq:=edtRXFreq.Text
end;

procedure TfrmNewQSO.edtRXLOExit(Sender: TObject);
var
  tmp: double = 0.0;
begin
  begin
    if not TryStrToFloat(edtRXLO.Text, tmp) then
      edtRXLO.Text := '0.0';
  end;
  cqrini.WriteString('NewQSO', 'RXLO', edtRXLO.Text);
end;

procedure TfrmNewQSO.edtStartTimeEnter(Sender: TObject);
begin
  edtStartTime.SelectAll
end;

procedure TfrmNewQSO.edtStateChange(Sender: TObject);
begin

end;

procedure TfrmNewQSO.edtStateEnter(Sender: TObject);
begin
  edtState.SelectAll
end;

procedure TfrmNewQSO.edtTXLOExit(Sender: TObject);
var
  tmp: double = 0.0;
begin
  begin
    if not TryStrToFloat(edtTXLO.Text, tmp) then
      edtTXLO.Text := '0.0';
  end;
  cqrini.WriteString('NewQSO', 'TXLO', edtTXLO.Text);
end;

procedure TfrmNewQSO.edtWAZEnter(Sender: TObject);
begin
  edtWAZ.SelectAll
end;

procedure TfrmNewQSO.FormWindowStateChange(Sender: TObject);
begin
  if WindowState = wsMinimized then //because of bug in Lazarus, I have to do it myself
  begin
    minimalize := True;
    if frmDXCluster.Showing then
    begin
      MinDXCluster := True
    end;
    if frmGrayline.Showing then
    begin
      frmGrayline.SavePosition;
      MinGrayLine := True;
    end;
    if frmTRXControl.Showing then
    begin
      frmTRXControl.SavePosition;
      MinTRXControl := True;
    end;
    if frmQSODetails.Showing then
    begin
      MinQSODetails := True
    end
  end
end;

procedure TfrmNewQSO.lblAziChangeBounds(Sender: TObject);
begin
  RefreshInfoLabels
end;

procedure TfrmNewQSO.lblDOKClick(Sender: TObject);
begin
 showDOK(false);
end;

procedure TfrmNewQSO.lblModeClick(Sender: TObject);

begin
  frmFreq := TfrmFreq.Create(frmNewQSO);
  try
    frmFreq.ShowModal
  finally
    frmFreq.Free
  end;
  //init user defined bands vs frequencies
  dmUtils.BandFromDbase;
end;

procedure TfrmNewQSO.lblStateClick(Sender: TObject);
begin
  showDOK(true);
end;
procedure TfrmNewQSO.showDOK(stat:boolean);
Begin
   lblDOK.Visible:= stat;
   edtDOK.Visible:= stat;
   lblState.Visible:= not stat;
   edtState.Visible:= not stat;
   if (stat) then
   begin
        edtDOK.TabOrder := 14;
        edtState.TabOrder := 30;
   end
   else
   begin
        edtDOK.TabOrder := 30;
        edtState.TabOrder := 14;
   end;
end;

procedure TfrmNewQSO.lblQRAChangeBounds(Sender: TObject);
begin
  RefreshInfoLabels
end;

procedure TfrmNewQSO.MenuItem11Click(Sender: TObject);
begin
  with TfrmWAZITUStat.Create(self) do
  try
    StatType := tsWAZ;
    ShowModal;
  finally
    Free
  end;
end;

procedure TfrmNewQSO.MenuItem12Click(Sender: TObject);
begin
  with TfrmWAZITUStat.Create(self) do
  try
    StatType := tsITU;
    ShowModal
  finally
    Free
  end;
end;

procedure TfrmNewQSO.MenuItem17Click(Sender: TObject);
begin
  ShowHelp
end;

procedure TfrmNewQSO.MenuItem46Click(Sender: TObject);
begin

end;

procedure TfrmNewQSO.MenuItem45Click(Sender: TObject);
var
  S: string;
begin
  //message box here for commands
  if not assigned(CWint) then exit;
  if InputQuery('Send hex commands to Win/K3NG keyer','Type in comma separated hex bytes 00-ff (can be: 0xff, xff or ff)',False,S) then
   CWint.SendHex(Uppercase(s));
end;

procedure TfrmNewQSO.mnuQrzClick(Sender: TObject);
begin
  dmUtils.ShowQRZInBrowser(dmData.qQSOBefore.Fields[4].AsString)
end;

procedure TfrmNewQSO.mnuIK3QARClick(Sender: TObject);
var
   AProcess: TProcess;
begin
  AProcess := TProcess.Create(nil);
  try
    AProcess.Executable := cqrini.ReadString('Program','WebBrowser',dmUtils.MyDefaultBrowser);
    AProcess.Parameters.Add('http://www.ik3qar.it/manager/man_result.php?call='+
                            dmData.qQSOBefore.Fields[4].AsString);
    if dmData.DebugLevel>=1 then Writeln('AProcess.Executable: ',AProcess.Executable,' Parameters: ',AProcess.Parameters.Text);
    AProcess.Execute
  finally
    AProcess.Free
  end
end;

procedure TfrmNewQSO.mnuHamQthClick(Sender : TObject);
begin
  dmUtils.ShowHamQTHInBrowser(dmData.qQSOBefore.Fields[4].AsString)
end;

procedure TfrmNewQSO.MenuItem95Click(Sender: TObject);
begin
     chkAutoMode.Font.Color:=clDefault;
     cqrini.WriteBool('Modes', 'Rig2Data', False);
end;

procedure TfrmNewQSO.MenuItem96Click(Sender: TObject);
begin
    chkAutoMode.Font.Color:=clRed;
    cqrini.WriteBool('Modes', 'Rig2Data', True);
end;

procedure TfrmNewQSO.acNewQSOExecute(Sender: TObject);
begin
  ClearAll;
end;

procedure TfrmNewQSO.acPreferencesExecute(Sender: TObject);
begin
  with TfrmPreferences.Create(self) do
  try
    ShowModal;
    if ModalResult = mrOK then
    begin
      if frmMain.Showing then
        dmUtils.LoadFontSettings(frmMain);
      dmUtils.LoadFontSettings(frmNewQSO);
      if frmTRXControl.Showing then
        dmUtils.LoadFontSettings(frmTRXControl);
      if frmQSODetails.Showing then
        frmQSODetails.LoadFonts;
      if frmRbnMonitor.Showing then
        dmUtils.LoadFontSettings(frmRbnMonitor);
      if frmPropDK0WCY.Showing then
        dmUtils.LoadFontSettings(frmPropDK0WCY);
      if (frmMonWsjtx <> nil) and frmMonWsjtx.Showing then
                         dmUtils.LoadFontSettings(frmMonWsjtx);
      dmData.LoadQSODateColorSettings;
    end;
    ChangeCallBookCaption
  finally
    Free
  end
end;

procedure TfrmNewQSO.acQSOperModeExecute(Sender: TObject);
begin
  with TfrmGraphStat.Create(self) do
  try
    chrtStat.Title.Text.Text := 'QSO per mode';
    chrtStat.Title.Alignment := taCenter;
    QSOperMode;
    ShowModal;
  finally
    Free
  end;
end;

procedure TfrmNewQSO.acShowBandMapExecute(Sender: TObject);
begin
  if frmBandMap.Showing then
    frmBandMap.BringToFront
  else
    frmBandMap.Show;
end;

procedure TfrmNewQSO.acTRXControlExecute(Sender: TObject);
begin
  if frmTRXControl.Showing then
    frmTRXControl.BringToFront
  else
    frmTRXControl.Show;
end;

procedure TfrmNewQSO.acViewQSOExecute(Sender: TObject);
begin
  if (dmData.qQSOBefore.RecordCount > 0) and (not AnyRemoteOn) then
  begin
    ViewQSO := True;
    Caption := dmUtils.GetNewQSOCaption('View QSO');
    BringToFront;
    EditQSO := False;
    fromNewQSO := True;
    ShowQSO
  end
end;

procedure TfrmNewQSO.acWACCfmExecute(Sender: TObject);
begin
  with TfrmWAZITUStat.Create(self) do
  try
    StatType := tsWAC;
    ShowModal
  finally
    Free
  end
end;


procedure TfrmNewQSO.acWASLoTWExecute(Sender: TObject);
begin
  with TfrmWAZITUStat.Create(self) do
  try
    StatType := tsWAS;
    ShowModal
  finally
    Free
  end
end;

procedure TfrmNewQSO.acWAZCfmExecute(Sender: TObject);
begin
  with TfrmWAZITUStat.Create(self) do
  try
    StatType := tsWAZ;
    ShowModal
  finally
    Free
  end
end;


procedure TfrmNewQSO.acXplanetExecute(Sender: TObject);
begin
  dmUtils.RunXplanet;
end;

procedure TfrmNewQSO.cbOfflineChange(Sender: TObject);
begin
  if not (fViewQSO or fEditQSO) then
    cqrini.WriteBool('TMPQSO','OFF',cbOffline.Checked);
  if cbOffline.Checked then
  begin
    pnlOffline.Color := clRed;
  end
  else begin
    SetDateTime();
    pnlOffline.Color := ColorToRGB(clBtnFace);
  end;
  lblQSOTakes.Visible := not cbOffline.Checked;
  if not AnyRemoteOn then
  Begin
   lblDateFormat.Visible:=cbOffline.Checked;
   lblStimeFormat.Visible:=cbOffline.Checked;
   lblEtimeFormat.Visible:=cbOffline.Checked;
  end;
end;

procedure TfrmNewQSO.cmbFreqChange(Sender: TObject);
Begin
  //note this procedure does NOT run if rig CAT changes cmbFreq text value !! (why?)
  cmbFreq.Text := CheckFreq(cmbFreq.Text);
  ShowCountryInfo;
  ChangeReports
end;

procedure TfrmNewQSO.cmbModeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = 40) then  //down arrow
  begin
    key := 0;
    edtHisRST.SetFocus;
    edtHisRST.SelStart  := 1;
    edtHisRST.SelLength := 1;
  end;
  if (key = 38) then //up arrow
  begin
    cmbFreq.SetFocus;
    key := 0;
  end;
  if ((key = VK_SPACE) and UseSpaceBar) then
  begin
    edtHisRST.SetFocus;
    edtHisRST.SelStart  := 1;
    edtHisRST.SelLength := 1;
    key := 0;
  end;
  if key = VK_TAB then
  begin
    key := 0;
    edtHisRST.SetFocus;
    TabUsed := True
  end
end;

procedure TfrmNewQSO.cmbProfilesChange(Sender: TObject);

begin
   if cmbProfiles.Text = '' then
   CurrentMyLoc :=  cqrini.ReadString('Station','LOC','')
  else
   CurrentMyLoc := dmData.GetMyLocFromProfile(cmbProfiles.Text);
  if CurrentMyloc <> '' then
     sbNewQSO.Panels[0].Text := cMyLoc + CurrentMyLoc;

  UsrAssignedProfile:= cmbProfiles.Text;   //this is only place for change value
  if dmData.DebugLevel >=1 then Writeln('Set profile: ',cmbProfiles.Text)
end;

procedure TfrmNewQSO.cmbQSL_RKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = 40) then  //down arrow
  begin
    edtItu.SetFocus;
    key := 0;
  end;
  if (key = 38) then //up arrow
  begin
    cmbQSL_S.SetFocus;
    key := 0;
  end;
  if ((key = VK_SPACE) and UseSpaceBar) then
  begin
    edtITU.SetFocus;
    key := 0
  end
end;

procedure TfrmNewQSO.cmbQSL_SKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = 40) then  //down arrow
  begin
    cmbQSL_R.SetFocus;
    key := 0;
  end;
  if (key = 38) then //up arrow
  begin
    edtPWR.SetFocus;
    key := 0;
  end;
  if ((key = VK_SPACE) and UseSpaceBar) then
  begin
    cmbQSL_R.SetFocus;
    key := 0
  end
end;


procedure TfrmNewQSO.dbgrdQSOBeforeDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if dmData.qQSOBefore.FieldByName('QSL_R').AsString = 'Q' then
  begin
    dbgrdQSOBefore.Canvas.Font.Color := clRed
  end;

  if dmData.UseQSOColor then
  begin
    if dmData.qQSOBefore.FieldByName('qsodate').AsDateTime < dmData.QSOColorDate then
      dbgrdQSOBefore.Canvas.Font.Color := dmData.QSOColor
  end;

  dbgrdQSOBefore.DefaultDrawColumnCell(Rect,DataCol,Column,State)
end;

procedure TfrmNewQSO.edtAwardExit(Sender: TObject);
begin
  CheckAwardClub
end;

procedure TfrmNewQSO.edtCallEnter(Sender: TObject);
begin
  if not EditQSO then
    old_call := edtCall.Text;
end;

procedure TfrmNewQSO.edtCallExit(Sender: TObject);
var
  mode, freq : String;
  QRZ        : TQRZThread;
  SearchQRZ  : Boolean = False;
  qsl_via    : String = '';
  i          : integer;
  tmp        : string;
  p          : currency;
begin
  mode := '';
  freq := '';
  if edtCall.Text='' then
    exit;
  sbtnQRZ.Visible    := True;
  sbtnHamQTH.Visible := True;
  sbtnUsrBtn.Visible := True;
  if cqrini.ReadBool('LoTW','ShowInfo',True) then
  begin
    sbtneQSL.Visible := dmData.UseseQSL(edtCall.Text);
    sbtnLoTW.Visible := dmData.UsesLotw(edtCall.Text)
  end;
  if old_adif = 0 then
    old_adif := adif;
  if (old_call = edtCall.Text) and (not fEditQSO) then
    exit;
  if not (fViewQSO or fEditQSO) then
  begin
    if old_call = '' then
    begin
      old_call := edtCall.Text;
      old_mode := cmbMode.Text
    end
    else begin
      if edtCall.Text = old_call then
        exit
    end;
    cqrini.WriteBool('TMPQSO','OFF',cbOffline.Checked);
    SearchQRZ := cqrini.ReadBool('NewQSO','AutoSearch',False)
  end;
  {
  if (not (fViewQSO or fEditQSO or cbOffline.Checked or lblQSOTakes.Visible)) or
     ((fEditQSO or fViewQSO) and (old_call <> edtCall.Text))  then
  begin
    if not fEditQSO then
      SetDateTime();
    ShowDXCCInfo
  end
  else begin
    if ChangeDXCC then
      ShowDXCCInfo(adif)
    else
      ShowDXCCInfo
  end;
  }

  if not fromNewQSO then
  begin
    dmData.qQSOBefore.Close;
    if cqrini.ReadBool('NewQSO','AllVariants',False) then
      dmData.qQSOBefore.SQL.Text := 'SELECT * FROM view_cqrlog_main_by_qsodate WHERE idcall = '+
                                    QuotedStr(dmUtils.GetIDCall(edtCall.Text))+' ORDER BY qsodate,time_on'
    else
      dmData.qQSOBefore.SQL.Text := 'SELECT * FROM view_cqrlog_main_by_qsodate WHERE callsign = '+
                                    QuotedStr(edtCall.Text)+' ORDER BY qsodate,time_on';

    if dmData.DebugLevel >=1 then Writeln(dmData.qQSOBefore.SQL.Text);
    if dmData.trQSOBefore.Active then
      dmData.trQSOBefore.Rollback;
    dmData.trQSOBefore.StartTransaction;
    dmData.qQSOBefore.Open;
    ShowFields;
    dmData.qQSOBefore.Last;
    dmUtils.LoadFontSettings(frmNewQSO)
  end;

// setting the  "NewQSO/QSO#:"
  if (fViewQSO or fEditQSO) then
   Begin
    if dmData.IsFilter then                                             //filtered from "Qso list"
      //this sets "NewQSO/QSO Nr:" to show selected qsos "grid row/qso rows total" in QSOlist/Filtered qsos
      lblQSONr.Caption :=  frmMain.dbgrdMain.DataSource.DataSet.RecNo.ToString +'/'+ frmMain.dbgrdMain.DataSource.DataSet.RecordCount.ToString+'-F';

    if FromNewQSO then                                                  //selected from NewQSO/WB4 grid
        //this sets "NewQSO/QSO Nr:" to show selected qsos "grid row/qso rows total" in NewQSO/WB4grid
        lblQSONr.Caption :=  dbgrdQSOBefore.DataSource.DataSet.RecNo.ToString +'/'+ dbgrdQSOBefore.DataSource.DataSet.RecordCount.ToString+'-W'
     else
      Begin //set WB4 grid RecNr point to same qso that was selected from QSO list for edit (without filtering)
         for i:=1 to dbgrdQSOBefore.DataSource.DataSet.RecordCount do
          Begin
             dbgrdQSOBefore.DataSource.DataSet.RecNo:=i;
             if dbgrdQSOBefore.DataSource.DataSet.FieldValues['id_cqrlog_main']= EditId then
              Begin
               if pos('-F', lblQSONr.Caption)=0 then
               lblQSONr.Caption :=  dbgrdQSOBefore.DataSource.DataSet.RecNo.ToString +'/'+ dbgrdQSOBefore.DataSource.DataSet.RecordCount.ToString+'-W';
               break;
              end;
         end;
      end;
   end
 else                                                                  //total NewQSO entered
  Begin
     //this sets "NewQSO/QSO Nr:" to show the new qsos orderNr in log using currently entered callsign
     dmData.qQSOBefore.Last; // to be sure the total count from log is proper
     lblQSONr.Caption := IntToStr(dmData.qQSOBefore.RecordCount+1)+'-N';
  end;


  if (not (fViewQSO or fEditQSO)) then
  begin
    InsertNameQTH;
    cmbQSL_S.Text := dmData.SendQSL(edtCall.Text,cmbMode.Text,cmbFreq.Text,adif);
  end;


  if ChangeDXCC then
    ShowDXCCInfo(adif)
  else
    ShowDXCCInfo();



  ShowCountryInfo;
  ChangeReports;
  dmUtils.ShowStatistic(adif,old_stat_adif,sgrdStatistic);
  dmUtils.ShowStatistic(adif,old_stat_adif,sgrdCallStatistic,edtCall.Text);
  tabDXCCStat.Caption:=edtDXCCRef.Text+' statistic';
  tabCallStat.Caption:=edtCall.Text+' statistic';
  CalculateDistanceEtc;
  mComment.Text := dmData.GetComment(edtCall.Text);
  if (lblDXCC.Caption <> '!') and (lblDXCC.Caption <> '#') then
  begin
    if frmGrayline.Showing then
    begin
      DrawGrayline
    end
  end;
  if NOT (old_call = '') then
  begin
    if (old_call <> edtCall.Text) and (QTHfromCb) then
    begin
      edtName.Text := '';
      edtQTH.Text  := ''
    end
  end;
  if not FromDXC then
  begin
    if (not (fViewQSO or fEditQSO or cbOffline.Checked)) and (frmTRXControl.GetModeFreqNewQSO(mode,freq)) then
    begin
      if chkAutoMode.Checked then
        cmbMode.Text := RigCmd2DataMode(mode);
      cmbFreq.Text := freq;
      edtHisRST.SetFocus;
      edtHisRST.SelStart  := 1;
      edtHisRST.SelLength := 1
    end
  end;
  lblAmbiguous.Visible := dmDXCC.IsAmbiguous(edtCall.Text);
  if dmData.QSLMgrFound(edtCall.Text,edtDate.Text,qsl_via) then
  begin
    lblQSLMgr.Visible := True;
    if (edtQSL_VIA.Text = '') then
      edtQSL_VIA.Text   := qsl_via
  end;
  frmQSODetails.iota := cmbIOTA.Text;
  if dmData.GetIOTAForDXCC(edtCall.Text,lblDXCC.Caption,cmbIOTA,dmUtils.MyStrToDate(edtDate.Text)) then
    lblIOTA.Font.Color := clRed
  else
    lblIOTA.Font.Color := clDefault;
  frmQSODetails.freq := cmbFreq.Text;
  frmQSODetails.waz  := edtWAZ.Text;
  frmQSODetails.itu  := edtITU.Text;
  frmQSODetails.iota := cmbIOTA.Text;

  if (not (fEditQSO or fViewQSO)) and (edtQSL_VIA.Text<>'') then
  begin
    if cmbQSL_S.Text = 'SB' then
      cmbQSL_S.Text := 'SMB';
    if cmbQSL_S.Text = 'B' then
      cmbQSL_S.Text := 'MD'
  end;

  idcall := dmUtils.GetIDCall(edtCall.Text);
  sbNewQSO.Panels[1].Text := cRefCall + idcall;

  if (not(fEditQSO or fViewQSO)) then
  begin
    if SearchQRZ then
    begin
      if NOT c_running then
      begin
        c_callsign := edtCall.Text;
        QRZ := TQRZThread.Create(True);
        QRZ.FreeOnTerminate := True;
        QRZ.Start
      end
    end;
     edtGridExit(nil); //enables LocMap button if grid ok
     FreqBefChange := frmTRXControl.GetFreqMHz;
  end;


  //no need here //dmUtils.HamClockSetNewDE(CurrentMyloc,'','',UpperCase(cqrini.ReadString('Station', 'Call', '')));
  dmUtils.HamClockSetNewDX(lblLat.Caption,lblLong.Caption,edtGrid.Text);
  CheckCallsignClub;
  CheckAwardClub;
  CheckCountyClub;
  CheckQTHClub;
  CheckStateClub;
  CheckAttachment;
  CheckQSLImage;
  FirstClose:=True;
end;

procedure TfrmNewQSO.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key >= VK_F1) and (Key <= VK_F10) and (Shift = []) then LastFKey := 0;
end;
procedure TfrmNewQSO.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  QRZ : TQRZThread;
  tmp : String;
  speed : Integer = 0;
  i     : Integer = 0;
  n     : String;
  ShowMain : Boolean = False;
begin

  //key ESC definitions
  if (Shift = [ssShift]) and (key = VK_ESCAPE) then                 //emulates Ctrl+F2
       Begin
         Shift := [ssCtrl];
         key   := VK_F2;
       end;

  if key = VK_ESCAPE then                                           //VK_ESCAPE
  begin
    if not (fViewQSO or fEditQSO) then
    begin
      if EscFirstPressDone then
      begin
        dmUtils.SaveDBGridInForm(frmNewQSO) ;
        if edtCall.Text = '' then
        begin
          if edtCall.Enabled then
            ReturnToNewQSO
        end
        else
         edtCall.Text := ''; // OnChange calls ClearAll;
        EscFirstPressDone := False;
        old_ccall := '';
        old_cfreq := '';
        old_cmode := '';
      end
      else
      begin
        case cmbMode.Text of
         'CW'  : if (Assigned(CWint)) then
                                    CWint.StopSending;
         'SSB',
         'FM',
         'AM'  : frmTRXControl.StopVoice;
        end;
        EscFirstPressDone   := True;
        tmrESC.Enabled := True
      end
    end
    else begin
      if fViewQSO then
      begin
        if (not (fViewQSO or fEditQSO or cbOffline.Checked)) then
        tmrRadio.Enabled := True;
        btnSave.Enabled  := True;
        for i:=0 to ComponentCount-1 do
        begin
          if (frmNewQSO.Components[i] is TEdit) then
             (frmNewQSO.Components[i] As TEdit).ReadOnly := False;
        end;
        edtDate.ReadOnly  := False;
        mComment.ReadOnly := False;
        edtDXCCRef.ReadOnly:=True;  //we allow only DXCCs from list, no free type
      end;
      ShowMain := (fEditQSO or fViewQSO) and (not fromNewQSO);
      ClearAll;
      UnsetEditLabel;

      if ShowMain then
      begin
        frmMain.BringToFront;
        frmMain.SetFocus
      end;
      Caption := dmUtils.GetNewQSOCaption('New QSO');
      fViewQSO := False;
      fEditQSO := False;
    end
  end
  else
    EscFirstPressDone := False;

  //Function keys 1-10
  if (key in [VK_F1..VK_F10]) and (Shift = []) then                      //VK_F1..VK_F10
  Begin
   if LastFkey = 0 then
    begin
      if (Sender <> nil ) then LastFKey := Key;   //LastKey resets by  KeyUp. Nil sender is a mouse click on button
      if ( frmContest.Showing and (key = VK_F1)) then  //set the "lastCqFreq" @contest window
        Begin
          frmContest.lblCqMode.Caption:=frmTRXControl.GetRawMode;
          frmContest.lblCqFreq.Caption := FormatFloat('0.00',frmTRXControl.GetFreqkHz);
        end;
      case cmbMode.Text of
         'SSB',
         'FM',
         'AM'  : RunVK(dmUtils.GetDescKeyFromCode(Key));
         'CW'  : if Assigned(CWint) then
          CWint.SendText(dmUtils.GetCWMessage(dmUtils.GetDescKeyFromCode(Key),frmNewQSO.edtCall.Text,
            frmNewQSO.edtHisRST.Text, frmNewQSO.edtContestSerialSent.Text,frmNewQSO.edtContestExchangeMessageSent.Text,
            frmNewQSO.edtContestSerialReceived.Text,frmNewQSO.edtContestExchangeMessageReceived.Text,
            frmNewQSO.edtName.Text,frmNewQSO.lblGreeting.Caption,''))
            else ShowMessage('CW interface:  No keyer defined for current radio!');
       end;
      end;
    key := 0
  end;

  if (Key = VK_F11) then                                            //VK_11
  begin
    if NOT c_running then
    begin
      c_callsign := edtCall.Text;
      mCallBook.Clear;
      QRZ := TQRZThread.Create(True);
      QRZ.FreeOnTerminate := True;
      QRZ.Start
    end
  end;

  // keys for CW speed up / down
  n:=IntToStr(frmTRXControl.cmbRig.ItemIndex);
  if( (key in [33,34]) and (not dbgrdQSOBefore.Focused) and (Assigned(CWint)) )then
  begin
    case key of
       33 : speed := frmNewQSO.CWint.GetSpeed+ cqrini.ReadInteger('CW','SpeedStep', 2);
       34 : speed := frmNewQSO.CWint.GetSpeed+ -1*cqrini.ReadInteger('CW','SpeedStep', 2);
     end;
    CWint.SetSpeed(speed);
    if (cqrini.ReadInteger('CW'+n,'Type',0)=1) and cqrini.ReadBool('CW'+n,'PotSpeed',False) then
        sbNewQSO.Panels[4].Text := 'Pot WPM'
       else
        sbNewQSO.Panels[4].Text := IntToStr(CWint.GetSpeed) + 'WPM';
    if (frmCWType <> nil ) then
         frmCWType.UpdateTop;
    key:=0;
  end;

  // CTRL-Key > Keyboard Shortcuts for NewQSO with CTRL
 if (Shift = [ssCtrl]) then
  begin
      if (key = VK_F2) then                                         //VK_F2
      begin
        if fViewQSO then
          begin
            if (not (fViewQSO or fEditQSO or cbOffline.Checked)) then
            tmrRadio.Enabled := True;
            btnSave.Enabled  := True;
            for i:=0 to ComponentCount-1 do
            begin
              if (frmNewQSO.Components[i] is TEdit) then
                 (frmNewQSO.Components[i] As TEdit).ReadOnly := False;
            end;
            edtDate.ReadOnly  := False;
            mComment.ReadOnly := False;
            edtDXCCRef.ReadOnly:=True;  //we allow only DXCCs from list, no free type
          end;
        Caption := dmUtils.GetNewQSOCaption('New QSO');
        fViewQSO := False;
        fEditQSO := False;
        NewQSO;
        ClearAll;
        key := 0
      end;
      if (Key = VK_F8) then                                         //VK_F8
      begin
        if not (fEditQSO or fViewQSO) then
          edtCall.Text:= '';
        ReturnToNewQSO;
        key := 0
      end;
      if (key = VK_A) then                                          //VK_A
      begin
        acAddToBandMap.Execute;
        key := 0
      end;
      if (key = VK_D) then                                          //VK_D
      begin
        acDXCCCfm.Execute;
        key := 0;
      end;
      if (key = VK_I) then                                          //VK_I
      begin
        acDetails.Execute;
        key := 0
      end;
      if (key = VK_H) then                                          //VK_H
      begin
        ShowHelp;
        key := 0
      end;
      if (key = VK_M) then                                          //VK_M
      begin
        acRemoteMode.Execute;
        key := 0
      end;
      if (key = VK_N) then                                          //VK_N
      begin
        acLongNote.Execute;
        key := 0
      end;
      if(key = VK_P) then                                           //VK_P
      begin
        acPreferences.Execute;
        key := 0;
      end;
      if (key = VK_Q) then                                          //VK_Q
      begin
        btnCancelClick(nil);
        key := 0;
        exit
      end;
      if (key = VK_R) then                                          //VK_R
      begin
        if edtCall.Text <> '' then
        begin
          tmp := idcall;
          with TfrmRefCall.Create(self) do
          try
            edtIdCall.Text := idcall;
            ShowModal;
            if ModalResult = mrOK then
              idcall := edtIdCall.Text;
          finally
            Free;
            if tmp <> idcall then
              CheckCallsignClub;
          end;
        end;
        key := 0
      end;
      if (key = VK_W) then                                          //VK_W
        Begin
         acSendSpot.Execute;
         key := 0;
        end;
      if key in [VK_1..VK_9] then                                   //VK_1..VK_9
         Begin
          SetSplit(chr(key));
         end;
      if (key = VK_0) then                                          //VK_0
        begin
         frmTRXControl.DisableSplit;
         key:=0;
        end;
 end;


 //three cases of VK_O
   if (key = VK_O) then                                             //VK_O
   Begin
   if (Shift = [ssCtrl,ssShift]) then
    begin
     cbOffline.Checked:= not cbOffline.Checked;
     if  cbOffline.Checked then
         edtDate.SetFocus
       else
         edtCall.SetFocus;
     key := 0;
    end;
   if (Shift = [ssCtrl]) then
    begin
      mnuQSOList.Click;
      key := 0;
    end;
   if (Shift = [ssAlt]) then
    begin
      with TfrmChangeOperator.Create(self) do
      try
        edtOperator.Text := Op;
        ShowModal;
        if ModalResult = mrOk then
        begin
         if UpperCase(edtOperator.Text)<>'' then
            Op := UpperCase(edtOperator.Text)
           else
            Op:= '';
          if dmData.DebugLevel>=1 then writeln('Operator changed: '+Op);
          cqrini.WriteString('TMPQSO','OP',Op);
          ShowOperator;
        end;
      finally
        Free;
      end;
    end;
  end; //end VK_O



  // ALT-keys by label focus control (not visible in source, only in lfm)
  // jump to Comment to QSO                                        //VK_C
  // jump to Date                                                  //VK_D
  // jump to End Time                                              //VK_E
  // jump to Grid                                                  //VK_G
  // jump to IOTA                                                  //VK_I
  // jump to Name                                                  //VK_M
  // jump to QTH                                                   //VK_Q
  // jump to RSTsent                                               //VK_R
  // jump to Start Time                                            //VK_S
  // jump to RST rcvd                                              //VK_T
  // jump to County                                                //VK_U


  // ALT-Key > Keyboard Shortcuts for NewQSO with ALT
  // note above source about 3 cases of VK_O                       //VK_O
 if (Shift = [ssAlt]) then
  Begin
      if (key = VK_B) then                                         //VK_B
        begin
         frmTRXControl.btnMemUp.Click;
         key:=0;
        end;
      if (key = VK_F) then                                         //VK_F
        begin
          dmUtils.EnterFreq;
          key:=0;
        end;
      if (key = VK_V) then                                         //Alt+V
        Begin
         frmTRXControl.btnMemDwn.Click;
         key:=0;
        end;
      if (key = VK_W) then                                         //Alt+W
        Begin
         cmbQSL_S.text:='SB';
         key:=0;
        end;
      if (key = VK_N) then                                         //Alt+N
        Begin
         cmbQSL_S.text:='N';
         key:=0;
        end;
      if (key = VK_H) then                                         //VK_H
        begin
         ShowHelp;
         key:=0;
        end;
      if (key = VK_F2) then                                        //VK_F2
        begin
         acNewQSOExecute(nil);
         key:= 0;
        end;
  end;
end;

procedure TfrmNewQSO.FormKeyPress(Sender: TObject; var Key: char);
begin
  case key of
    #13 : begin                                                   //enter
            if not AnyRemoteOn then btnSave.Click;
            dmUtils.SaveDBGridInForm(frmNewQSO) ;
            key := #0;
          end;
    #12 : begin                                                   //CTRL+L
            with TfrmChangeLocator.Create(self) do
            try
              edtLocator.Text := CurrentMyLoc;
              ShowModal;
              if ModalResult = mrOk then
              begin
                CurrentMyLoc := edtLocator.Text;
                sbNewQSO.Panels[0].Text := cMyLoc + CurrentMyLoc;
                // We don't want the temporary locator to be saved permanently
                // cqrini.WriteString('Station','LOC',edtLocator.Text)
                ClearGrayLineMapLine; //set myqth position to new locator
              end;
            finally
              Free;
            end;
            key := #0
          end;
    #96 : begin                                                   //CTRL+W
            acSendSpot.Execute;
            Key := #0
          end;
    #43 : begin                                                   //+ key
            if cqrini.ReadBool('BandMap','PlusToBandMap',False) then
            begin
              acAddToBandMap.Execute;
              key := #0
            end
          end
  end; //case
end;

procedure TfrmNewQSO.edtStartTimeKeyPress(Sender: TObject; var Key: char);
begin
  if not (key in ['0'..'9','-',':',#24,#3,#22,#8,#127]) then   //CtrlX,CtrlC,CtrlV,BackSpace,DEL
    key := #0
end;

procedure TfrmNewQSO.edtStateExit(Sender: TObject);
begin
  ShowDXCCInfo();
  ShowCountryInfo;
  dmUtils.ShowStatistic(adif,old_stat_adif,sgrdStatistic);
  CalculateDistanceEtc;
  if (( frmGrayline.Showing ) and (edtCall.Text<>'')) then
    DrawGrayline;
  CheckStateClub
end;

procedure TfrmNewQSO.edtStateKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = 40) then  //down arrow
  begin
    edtCounty.SetFocus;
    key := 0
  end;
  if (key = 38) then //up arrow
  begin
    cmbIOTA.SetFocus;
    key := 0
  end;
  if ((key = VK_SPACE) and UseSpaceBar) then
  begin
    edtCounty.SetFocus;
    key := 0
  end
end;

procedure TfrmNewQSO.edtWAZExit(Sender: TObject);
begin
  frmQSODetails.waz := edtWAZ.Text
end;

procedure TfrmNewQSO.mCommentKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ((key = VK_TAB) and (not AnyRemoteOn)) then
    Begin
     ReturnToNewQSO;
     key := 0
    end;
  if (key = VK_RETURN) then
    Begin
     mComment.Text:=mComment.Text+LineEnding;
     mComment.SelStart:=length(mComment.Text);
     mComment.SelLength:=0;
     key:=0;
    end;
end;

procedure TfrmNewQSO.mCommentKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = VK_UP then
  begin
    mComment.SelStart :=1;
    mComment.SelLength := 10;
    if (Pos(mComment.SelText,mComment.Lines.Strings[0]) > 0) or (mComment.Lines.Text = '') then
    begin
      mComment.SelLength := 0;
      key := 0;
      edtEndTime.SetFocus;
    end;
  end;
end;

procedure TfrmNewQSO.mnueQSLViewClick(Sender: TObject);
var
  QSOmode:String;
begin
    QSOMode :=       dmData.qQSOBefore.FieldByName('mode').AsString;
    if  ((upcase(QSOMode) = 'JS8')
      or (upcase(QSOMode) = 'FT4')
      or (upcase(QSOMode) = 'FST4')) then QSOMode := 'MFSK';

    frmMain.eQSLView( dmData.qQSOBefore.FieldByName('qsodate').AsString,
                      dmData.qQSOBefore.FieldByName('time_on').AsString,
                      dmData.qQSOBefore.FieldByName('callsign').AsString,
                      dmData.qQSOBefore.FieldByName('band').AsString,
                      QSOMode);
end;


procedure TfrmNewQSO.mnuIOTAClick(Sender: TObject);
begin
  with TfrmIOTAStat.Create(self) do
  try
    ShowModal;
  finally
    Free
  end;
end;

procedure TfrmNewQSO.mnuQSOBeforeClick(Sender: TObject);
begin
  dbgrdQSOBefore.Visible := not dbgrdQSOBefore.Visible;
  if dbgrdQSOBefore.Visible then
    mnuQSOBefore.Caption := 'Disable QSO before grid'
  else
    mnuQSOBefore.Caption := 'Enable QSO before grid'
end;

procedure TfrmNewQSO.mnuQSOListClick(Sender: TObject);
begin
  if frmMain.WindowState = wsMinimized then
    frmMain.WindowState := wsNormal;
  frmMain.Show;
  frmMain.BringToFront;
end;

procedure TfrmNewQSO.pgDetailsChange(Sender: TObject);
begin
  cqrini.WriteInteger('NewQSO','DetailsTabIndex', pgDetails.TabIndex);
end;


procedure TfrmNewQSO.popEditQSOPopup(Sender: TObject);
var
   v:boolean;
begin
    v := dmData.qQSOBefore.RecordCount>0;
    mnuViewQso.Enabled:=v;
    mnuEditQso.Enabled:=v;
    mnuHamQth.Enabled:=v;
    mnuQrz.Enabled:=v;
    mnuIK3QAR.Enabled:=v;
    mnueQSLView.Enabled:=v;
    if not v then exit;

    mnueQSLView.Visible :=  pos('E',dmData.qQSOBefore.FieldByName('eqsl_qsl_rcvd').AsString)>0;
    if dmData.DebugLevel>=1 then writeln(dmData.qQSOBefore.FieldByName('callsign').AsString,' ',
                                         dmData.qQSOBefore.FieldByName('eqsl_qsl_rcvd').AsString )
end;



procedure TfrmNewQSO.sbtnAttachClick(Sender: TObject);
begin
  frmCallAttachment := TfrmCallAttachment.Create(self);
  try
    frmCallAttachment.flAttach.Directory := dmUtils.GetCallAttachDir(edtCall.Text);
    frmCallAttachment.ShowModal
  finally
    frmCallAttachment.Free
  end
end;

procedure TfrmNewQSO.sbtnQSLClick(Sender: TObject);
begin
  if not cqrini.ReadBool('ExtView','QSL',True) then
    dmUtils.ShowQSLWithExtViewer(edtCall.Text)
  else begin
    frmQSLViewer := TfrmQSLViewer.Create(self);
    try
      frmQSLViewer.Call := edtCall.Text;
      frmQSLViewer.ShowModal
    finally
      frmQSLViewer.Free
    end
  end
end;

procedure TfrmNewQSO.sbtnQRZClick(Sender: TObject);
begin
  dmUtils.ShowQRZInBrowser(edtCall.Text)
end;

procedure TfrmNewQSO.sbtnHamQTHClick(Sender : TObject);
begin
  dmUtils.ShowHamQTHInBrowser(edtCall.Text)
end;

procedure TfrmNewQSO.sbtnUsrbtnClick(Sender: TObject);
begin
  dmUtils.ShowUsrUrl;
end;

//this is used for both DXCC- and Callstatistics grid painting
procedure TfrmNewQSO.sgrdCallStatisticPrepareCanvas(Sender: TObject; aCol,
  aRow: Integer; aState: TGridDrawState);
var
  c:integer;
  BandColor,ModeColor:TColor;
  gr:TStringGrid;
begin
   if edtCall.Text='' then exit;
   gr:=TStringGrid(Sender);
   //BandColor:=$CCFEFF;
   //ModeColor:=$CCFECD;
   if ((Red(ColorToRGB(GetDefaultColor(dctBrush))))>$77) then
    Begin             //this is selected if background is light
      if cqrini.ReadBool('Fonts', 'GridGreenBar', False) then
        Begin
         BandColor:=$E1A3A1;
          ModeColor:=$A1E1A7;
        end
      else
        Begin
         ModeColor:=$CCFECD;
         BandColor:=$CCFEFF;
        end;
    end
   else  //this is selected if background is dark
    if cqrini.ReadBool('Fonts', 'GridGreenBar', False) then
        Begin
          BandColor:=$054445; //these may need fixing !!!!
          ModeColor:=$074505;
        end
      else
        Begin
          BandColor:=$054445;
          ModeColor:=$074505;
        end;

   c:=dmUtils.GetBandPos(dmUtils.GetBandFromFreq(cmbFreq.Text))+1;
   if c<1 then exit; //error, should not happen.
    if (aCol=c) then
         Begin
         case aRow of
           0: gr.Canvas.Brush.Color:=BandColor;
           1: if (cmbMode.Text='SSB') then
              gr.Canvas.Brush.Color:=ModeColor
              else
               gr.Canvas.Brush.Color:=BandColor;
           2: if (cmbMode.Text='CW') then
              gr.Canvas.Brush.Color:=ModeColor
              else
              gr.Canvas.Brush.Color:=BandColor;
           3: case cmbMode.Text of
                   'SSB',
                   'CW',
                   'AM',
                   'FM' : gr.Canvas.Brush.Color:=BandColor;
                   else
                     //must be some of digital modes
                     gr.Canvas.Brush.Color:=ModeColor;
               end;
           end;
          end;
end;

procedure TfrmNewQSO.sbtnLocatorMapClick(Sender: TObject);
begin
  if dmUtils.isLocOK(edtGrid.Text) then  //there may be case where Grid is empty and button is visible
    dmUtils.ShowLocatorMapInBrowser(dmUtils.CompleteLoc(edtGrid.Text))
end;

procedure TfrmNewQSO.tmrESCTimer(Sender: TObject);
begin
  EscFirstPressDone   := False;
  tmrESC.Enabled := False
end;

procedure TfrmNewQSO.ShowFields;
var
  aColumns : TColumnVisibleArray;
  i : Integer;
  y : Integer;

  fQsoGr  : String;
  fqSize  : Integer;
  isAdded : Boolean = False;
  fDefault : Boolean;
  ColExists : Boolean = False;
begin
  dbgrdQSOBefore.DataSource := dmData.dsrQSOBefore;
  dbgrdQSOBefore.ResetColWidths;
  dmUtils.LoadDBGridInForm(frmNewQSO);
  aColumns := dmUtils.LoadVisibleColumnsConfiguration();

  fQsoGr   := cqrini.ReadString('Fonts','QGrids','Sans 10');
  fqSize   := cqrini.ReadInteger('Fonts','qSize',10);
  fDefault := cqrini.ReadBool('Fonts','UseDefault',True);

  try
    //it's strange but disable grid browsing speed up this much more
    //then code refactoring before
    dbgrdQSOBefore.DataSource.DataSet.DisableControls;

    for i:=0 to dbgrdQSOBefore.Columns.Count-1 do
    begin
      if UpperCase(dbgrdQSOBefore.Columns[i].DisplayName) = 'BAND' then
        dbgrdQSOBefore.Columns[i].Visible := False;
      if UpperCase(dbgrdQSOBefore.Columns[i].DisplayName) = 'QSO_DXCC' then
        dbgrdQSOBefore.Columns[i].Visible := False;
      if UpperCase(dbgrdQSOBefore.Columns[i].DisplayName) = 'PROFILE' then
        dbgrdQSOBefore.Columns[i].Visible := False;
      if UpperCase(dbgrdQSOBefore.Columns[i].DisplayName) = 'ID_CQRLOG_MAIN' then
        dbgrdQSOBefore.Columns[i].Visible := False;
      if UpperCase(dbgrdQSOBefore.Columns[i].DisplayName) = 'IDCALL' then
        dbgrdQSOBefore.Columns[i].Visible := False;
      if UpperCase(dbgrdQSOBefore.Columns[i].DisplayName) = 'CLUB_NR1' then
        dbgrdQSOBefore.Columns[i].Visible := False;
      if UpperCase(dbgrdQSOBefore.Columns[i].DisplayName) = 'CLUB_NR2' then
        dbgrdQSOBefore.Columns[i].Visible := False;
      if UpperCase(dbgrdQSOBefore.Columns[i].DisplayName) = 'CLUB_NR3' then
        dbgrdQSOBefore.Columns[i].Visible := False;
      if UpperCase(dbgrdQSOBefore.Columns[i].DisplayName) = 'CLUB_NR4' then
        dbgrdQSOBefore.Columns[i].Visible := False;
      if UpperCase(dbgrdQSOBefore.Columns[i].DisplayName) = 'CLUB_NR5' then
        dbgrdQSOBefore.Columns[i].Visible := False;
      if (UpperCase(dbgrdQSOBefore.Columns[i].DisplayName) = 'STATE') then
      begin
        dbgrdQSOBefore.Columns[i].Alignment := taCenter;
        dbgrdQSOBefore.Columns[i].Title.Alignment := taCenter
      end;
      if (UpperCase(dbgrdQSOBefore.Columns[i].DisplayName) = 'LOTW_QSLS') then
      begin
        dbgrdQSOBefore.Columns[i].Alignment := taCenter;
        dbgrdQSOBefore.Columns[i].Title.Alignment := taCenter
      end;
      if (UpperCase(dbgrdQSOBefore.Columns[i].DisplayName) = 'LOTW_QSLR') then
      begin
        dbgrdQSOBefore.Columns[i].Alignment := taCenter;
        dbgrdQSOBefore.Columns[i].Title.Alignment := taCenter
      end;

      if (UpperCase(dbgrdQSOBefore.Columns[i].DisplayName) = 'EQSL_QSL_SENT') then
      begin
        dbgrdQSOBefore.Columns[i].Alignment := taCenter;
        dbgrdQSOBefore.Columns[i].Title.Alignment := taCenter
      end;
      if (UpperCase(dbgrdQSOBefore.Columns[i].DisplayName) = 'EQSL_QSL_RCVD') then
      begin
        dbgrdQSOBefore.Columns[i].Alignment := taCenter;
        dbgrdQSOBefore.Columns[i].Title.Alignment := taCenter
      end;

      if (UpperCase(dbgrdQSOBefore.Columns[i].DisplayName) = 'QSLR') then
      begin
        dbgrdQSOBefore.Columns[i].Alignment := taCenter;
        dbgrdQSOBefore.Columns[i].Title.Alignment := taCenter
      end;

      if (UpperCase(dbgrdQSOBefore.Columns[i].DisplayName) = 'FREQ') then
      begin
        dbgrdQSOBefore.Columns[i].Alignment       := taRightJustify;
        dbgrdQSOBefore.Columns[i].DisplayFormat   := '####0.000;;';
        dbgrdQSOBefore.Columns[i].Title.Alignment := taCenter
      end;

      for y:=0 to Length(aColumns)-1 do
      begin
        if UpperCase(dbgrdQSOBefore.Columns[i].DisplayName) = aColumns[y].FieldName then
        begin
          dbgrdQSOBefore.Columns[i].Visible := aColumns[y].Visible;
          aColumns[y].Exists := True;
          if aColumns[y].Visible and (dbgrdQSOBefore.Columns[i].Width = 0) then
            dbgrdQSOBefore.Columns[i].Width := 60
        end
      end
    end;

    for i:=0 to Length(aColumns) do
    begin
      if (aColumns[i].Visible) and (not aColumns[i].Exists) then
      begin
        dbgrdQSOBefore.Columns.Add;
        dbgrdQSOBefore.Columns[dbgrdQSOBefore.Columns.Count-1].FieldName   := aColumns[i].FieldName;
        dbgrdQSOBefore.Columns[dbgrdQSOBefore.Columns.Count-1].DisplayName := aColumns[i].FieldName;
        dbgrdQSOBefore.Columns[dbgrdQSOBefore.Columns.Count-1].Width       := 60
      end
    end;

    for i:=0 to dbgrdQSOBefore.Columns.Count-1 do
    begin
      if fDefault then
      begin
        dbgrdQSOBefore.Columns[i].Title.Font.Name := 'default';
        dbgrdQSOBefore.Columns[i].Title.Font.Size := 0
      end
      else begin
        dbgrdQSOBefore.Columns[i].Title.Font.Name := fQsoGr;
        dbgrdQSOBefore.Columns[i].Title.Font.Size := fqSize
      end
    end

  finally
    dbgrdQSOBefore.DataSource.DataSet.EnableControls
  end
end;

procedure TfrmNewQSO.ChangeReports;
var
  tmp : String;
begin
  if not chkAutoMode.Checked then
    exit;
  //if user set own mode by hand, he also can change report as he need
  if cmbMode.Text = 'SSB' then
    tmp := '59'
  else
    if cmbMode.Text = 'CW' then
      tmp := '599'
    else
      if cmbMode.Text = 'STTV' then
        tmp := '595'
      else
        tmp := '599';

  if edtHisRST.Text = '' then
    edtHisRST.Text := tmp;
  if edtMyRST.Text = '' then
    edtMyRST.Text := tmp;

  if (cmbMode.Text = 'SSB') or (cmbMode.Text = 'AM') or (cmbMode.Text = 'FM') then
  begin
    if Length(edtHisRST.Text) = 3 then
      edtHisRST.Text := copy(edtHisRST.Text,1,2);
    if Length(edtMyRST.Text) = 3 then
      edtMyRST.Text := copy(edtMyRST.Text,1,2);
  end
  else begin
    if Length(edtHisRST.Text) = 2 then
      edtHisRST.Text := edtHisRST.Text + '9';
    if Length(edtMyRST.Text) = 2 then
      edtMyRST.Text := edtMyRST.Text + '9'
  end;
end;

procedure TfrmNewQSO.CalculateDistanceEtc;
var
  azim, qra, myloc : String;
  lat,long : Currency;
  SunRise,SunSet : TDateTime;
  //delta : Currency;
  inUTC : Boolean;
  SunDelta : Currency = 0;

begin
  inUTC := cqrini.ReadBool('Program','SunUTC',False);
  //delta := cqrini.ReadFloat('Program','offset',0);

  if dmUtils.SysUTC then
    SunDelta := dmUtils.GetLocalUTCDelta
  else
    SunDelta := cqrini.ReadFloat('Program','SunOffset',0);

  //SunDelta := cqrini.ReadFloat('Program','SunOffset',0);

  myloc := CurrentMyLoc;
  if lblDXCC.Caption = '!' then
  begin
    lblQRA.Caption := '';
    lblAzi.Caption := '';
    ClearGrayLineMapLine; //case entered loc for /MM is wiped or changed after first entry
    if not (dmUtils.IsLocOK(edtGrid.Text) and dmUtils.IsLocOK(myloc)) then exit;
  end;
  qra   := '';
  azim  := '';
  if (dmUtils.IsLocOK(edtGrid.Text) and dmUtils.IsLocOK(myloc)) then
  begin
    dmUtils.DistanceFromLocator(dmUtils.CompleteLoc(myloc),dmUtils.CompleteLoc(edtGrid.Text), qra, azim);
    dmUtils.CoordinateFromLocator(dmUtils.CompleteLoc(edtGrid.Text),lat,long);
    dmUtils.CalcSunRiseSunSet(lat,long,SunRise,SunSet);
    if not inUTC then
    begin
      SunRise := SunRise + (SunDelta/24);
      SunSet  := SunSet + (SunDelta/24)
    end;

    DisplayCoordinates(lat,long);
    DrawGrayline;

    {
    if SunDelta <> 0 then
    begin
      SunRise := SunRise + (SunDelta/24);
      SunSet  := SunSet + (SunDelta/24)
    end;
    if inUTC then
    begin
      SunRise := SunRise - (delta/24);
      SunSet  := SunSet - (delta/24)
    end;
    }
    lblTarSunRise.Caption := TimeToStr(SunRise);
    lblTarSunSet.Caption  := TimeToStr(SunSet)
  end
  else begin
    if (lblLat.Caption <> '') and (lblLong.Caption <> '') then
    begin
      dmUtils.GetRealCoordinate(lblLat.Caption,lblLong.Caption,lat,long);
      dmUtils.CalcSunRiseSunSet(lat,long,SunRise,SunSet);
      {
      if inUTC then
      begin
        SunRise := SunRise - (delta/24);
        SunSet  := SunSet - (delta/24)
      end;
      }
      if not inUTC then
      begin
        SunRise := SunRise + (SunDelta/24);
        SunSet  := SunSet + (SunDelta/24)
      end;
      lblTarSunRise.Caption := TimeToStr(SunRise);
      lblTarSunSet.Caption  := TimeToStr(SunSet);
      dmUtils.DistanceFromCoordinate(dmUtils.CompleteLoc(myloc),lat,long,qra,azim)
    end
    else
      dmUtils.DistanceFromPrefixMyLoc(dmUtils.CompleteLoc(myloc),edtDXCCRef.Text, qra, azim)
  end;
  if ((qra <>'') and (azim<>'')) then
  begin
    if cqrini.ReadBool('Program','ShowMiles',False) then
      lblQRA.Caption := FloatToStr(dmUtils.KmToMiles(StrToFloat(qra))) + 'mi'
    else
      lblQRA.Caption := qra + 'km';
    lblAzi.Caption := azim;
    Azimuth := azim
  end;
  RefreshInfoLabels;
end;

procedure TfrmNewQSO.ShowQSO;
var
  i : Integer;
begin
  tmrRadio.Enabled := False;
  tmrEnd.Enabled   := False;
  tmrStart.Enabled := False;

  Running      := False;
  EscFirstPressDone := False;
  ChangeDXCC   := False;
  dmData.InsertProfiles(cmbProfiles,true);
  EditViewMyLoc :='';

  if fromNewQSO then
  begin
    EditId            := dmData.qQSOBefore.FieldByName('id_cqrlog_main').AsLongInt;
    cmbProfiles.Text  := dmData.GetProfileText(dmData.qQSOBefore.FieldByName('profile').AsInteger);
    edtDate.Text      := dmData.qQSOBefore.FieldByName('qsodate').AsString;
    edtStartTime.Text := dmData.qQSOBefore.FieldByName('time_on').AsString;
    edtEndTime.Text   := dmData.qQSOBefore.FieldByName('time_off').AsString;
    edtCall.Text      := dmData.qQSOBefore.FieldByName('callsign').AsString;
    cmbFreq.Text      := FloatToStrF(dmData.qQSOBefore.FieldByName('freq').AsFloat,ffFixed,8,4);
    cmbMode.Text      := dmData.qQSOBefore.FieldByName('mode').AsString;
    edtHisRST.Text    := dmData.qQSOBefore.FieldByName('rst_s').AsString;
    edtMyRST.Text     := dmData.qQSOBefore.FieldByName('rst_r').AsString;
    edtName.Text      := Trim(dmData.qQSOBefore.FieldByName('name').AsString);
    edtQTH.Text       := Trim(dmData.qQSOBefore.FieldByName('qth').AsString);
    cmbQSL_S.Text     := dmData.qQSOBefore.FieldByName('qsl_s').AsString;
    cmbQSL_R.Text     := dmData.qQSOBefore.FieldByName('qsl_r').AsString;
    edtQSL_VIA.Text   := dmData.qQSOBefore.FieldByName('qsl_via').AsString;
    cmbIOTA.Text      := dmData.qQSOBefore.FieldByName('iota').AsString;
    edtPWR.Text       := dmData.qQSOBefore.FieldByName('pwr').AsString;
    if NOT dmData.qQSOBefore.FieldByName('itu').IsNull then
      edtITU.Text     := IntToStr(dmData.qQSOBefore.FieldByName('itu').AsInteger);
    if NOT dmData.qQSOBefore.FieldByName('waz').IsNull then
      edtWAZ.Text     := IntToStr(dmData.qQSOBefore.FieldByName('waz').AsInteger);
    edtGrid.Text      := dmData.qQSOBefore.FieldByName('loc').AsString;
    sbNewQSO.Panels[0].Text := cMyLoc + dmData.qQSOBefore.FieldByName('my_loc').AsString;
    edtCounty.Text    := Trim(dmData.qQSOBefore.FieldByName('county').AsString);
    edtRemQSO.Text    := Trim(dmData.qQSOBefore.FieldByName('remarks').AsString);
    edtDXCCRef.Text   := dmData.qQSOBefore.FieldByName('dxcc_ref').AsString;
    ChangeDXCC        := dmData.qQSOBefore.FieldByName('qso_dxcc').AsInteger > 0;
    idcall            := dmData.qQSOBefore.FieldByName('idcall').AsString;
    edtAward.Text     := Trim(dmData.qQSOBefore.FieldByName('award').AsString);
    edtState.Text     := Trim(dmData.qQSOBefore.FieldByName('state').AsString);
    edtDOK.Text       := Trim(dmData.qQSOBefore.FieldByName('dok').AsString);
    lotw_qslr         := dmData.qQSOBefore.FieldByName('lotw_qslr').AsString;

    if lotw_qslr = 'L' then
          LoTWcfm:= dmData.qQSOBefore.FieldByName('lotw_qslrdate').AsString + '  '+
                    dmData.qQSOBefore.FieldByName('band').AsString +'  LoTW cfmd';
    if not dmData.qQSOBefore.FieldByName('qslr_date').IsNull then
          QSLcfm := dmData.qQSOBefore.FieldByName('qslr_date').AsString + '  '+
                    dmData.qQSOBefore.FieldByName('band').AsString +'  QSL rcvd';
    if not dmData.qQSOBefore.FieldByName('eqsl_qslrdate').IsNull then
          eQSLcfm := dmData.qQSOBefore.FieldByName('eqsl_qslrdate').AsString + '  '+
                     dmData.qQSOBefore.FieldByName('band').AsString +'  eQSL rcvd';

    dmSatellite.GetListOfSatellites(cmbSatellite, dmData.qQSOBefore.FieldByName('satellite').AsString);
    dmSatellite.GetListOfPropModes(cmbPropagation, dmData.qQSOBefore.FieldByName('prop_mode').AsString);
    edtRXFreq.Text := FloatToStr(dmData.qQSOBefore.FieldByName('rxfreq').AsFloat);
    edtContestName.Text := dmData.qQSOBefore.FieldByName('contestname').AsString;
    edtContestSerialSent.Text := dmData.qQSOBefore.FieldByName('stx').AsString;
    edtContestSerialReceived.Text := dmData.qQSOBefore.FieldByName('srx').AsString;
    edtContestExchangeMessageSent.Text := dmData.qQSOBefore.FieldByName('stx_string').AsString;
    edtContestExchangeMessageReceived.Text := dmData.qQSOBefore.FieldByName('srx_string').AsString;
    Op := dmData.qQSOBefore.FieldByName('operator').AsString;
    ShowOperator;
    EditViewMyLoc :=  dmData.qQSOBefore.FieldByName('my_loc').AsString;
  end
  else begin
    EditId            := dmData.qCQRLOG.FieldByName('id_cqrlog_main').AsLongInt;
    cmbProfiles.Text  := dmData.GetProfileText(dmData.qCQRLOG.FieldByName('profile').AsInteger);
    edtDate.Text      := dmData.qCQRLOG.FieldByName('qsodate').AsString;
    edtStartTime.Text := dmData.qCQRLOG.FieldByName('time_on').AsString;
    edtEndTime.Text   := dmData.qCQRLOG.FieldByName('time_off').AsString;
    edtCall.Text      := dmData.qCQRLOG.FieldByName('callsign').AsString;
    cmbFreq.Text      := FloatToStrF(dmData.qCQRLOG.FieldByName('freq').AsFloat,ffFixed,8,4);
    cmbMode.Text      := dmData.qCQRLOG.FieldByName('mode').AsString;
    edtHisRST.Text    := dmData.qCQRLOG.FieldByName('rst_s').AsString;
    edtMyRST.Text     := dmData.qCQRLOG.FieldByName('rst_r').AsString;
    edtName.Text      := dmData.qCQRLOG.FieldByName('name').AsString;
    edtQTH.Text       := dmData.qCQRLOG.FieldByName('qth').AsString;
    cmbQSL_S.Text     := dmData.qCQRLOG.FieldByName('qsl_s').AsString;
    cmbQSL_R.Text     := dmData.qCQRLOG.FieldByName('qsl_r').AsString;
    edtQSL_VIA.Text   := dmData.qCQRLOG.FieldByName('qsl_via').AsString;
    cmbIOTA.Text      := dmData.qCQRLOG.FieldByName('iota').AsString;
    edtPWR.Text       := dmData.qCQRLOG.FieldByName('pwr').AsString;
    if NOT dmData.qCQRLOG.FieldByName('itu').IsNull then
      edtITU.Text     := IntToStr(dmData.qCQRLOG.FieldByName('itu').AsInteger);
    if NOT dmData.qCQRLOG.FieldByName('waz').IsNull then
      edtWAZ.Text     := IntToStr(dmData.qCQRLOG.FieldByName('waz').AsInteger);
    edtGrid.Text      := dmData.qCQRLOG.FieldByName('loc').AsString;
    sbNewQSO.Panels[0].Text := cMyLoc + dmData.qCQRLOG.FieldByName('my_loc').AsString;
    edtCounty.Text    := dmData.qCQRLOG.FieldByName('county').AsString;
    edtRemQSO.Text    := dmData.qCQRLOG.FieldByName('remarks').AsString;
    edtDXCCRef.Text   := dmData.qCQRLOG.FieldByName('dxcc_ref').AsString;
    ChangeDXCC        := dmData.qCQRLOG.FieldByName('qso_dxcc').AsInteger > 0;
    idcall            := dmData.qCQRLOG.FieldByName('idcall').AsString;
    edtAward.Text     := dmData.qCQRLOG.FieldByName('award').AsString;
    edtState.Text     := dmData.qCQRLOG.FieldByName('state').AsString;
    edtDOK.Text       := dmData.qCQRLOG.FieldByName('dok').AsString;
    lotw_qslr         := dmData.qCQRLOG.FieldByName('lotw_qslr').AsString;
    edtContestName.Text := dmData.qCQRLOG.FieldByName('contestname').AsString;
    edtContestSerialSent.Text := dmData.qCQRLOG.FieldByName('stx').AsString;
    edtContestSerialReceived.Text := dmData.qCQRLOG.FieldByName('srx').AsString;
    edtContestExchangeMessageSent.Text := dmData.qCQRLOG.FieldByName('stx_string').AsString;
    edtContestExchangeMessageReceived.Text := dmData.qCQRLOG.FieldByName('srx_string').AsString;


    if lotw_qslr = 'L' then
           LoTWcfm := dmData.qCQRLOG.FieldByName('lotw_qslrdate').AsString + '  '+
                      dmData.qCQRLOG.FieldByName('band').AsString +'  LoTW cfmd' ;
    if not dmData.qCQRLOG.FieldByName('qslr_date').IsNull then
           QSLcfm := dmData.qCQRLOG.FieldByName('qslr_date').AsString + '  '+
                     dmData.qCQRLOG.FieldByName('band').AsString +'  QSL rcvd ';
    if not dmData.qCQRLOG.FieldByName('eqsl_qslrdate').IsNull then
      eQSLcfm := dmData.qCQRLOG.FieldByName('eqsl_qslrdate').AsString + '  '+
                 dmData.qCQRLOG.FieldByName('band').AsString +'  eQSL rcvd';

    dmSatellite.GetListOfSatellites(cmbSatellite, dmData.qCQRLOG.FieldByName('satellite').AsString);
    dmSatellite.GetListOfPropModes(cmbPropagation, dmData.qCQRLOG.FieldByName('prop_mode').AsString);
    edtRXFreq.Text := FloatToStr(dmData.qCQRLOG.FieldByName('rxfreq').AsFloat);
    Op := dmData.qCQRLOG.FieldByName('operator').AsString;
    ShowOperator;
    EditViewMyLoc :=  dmData.qCQRLOG.FieldByName('my_loc').AsString;
  end;
  if (edtRXFreq.Text = '0') then
    edtRXFreq.Text := '';
  sbNewQSO.Panels[1].Text := cRefCall + idcall;
  adif := dmDXCC.AdifFromPfx(edtDXCCRef.Text);
  if fromNewQSO then
  begin
    old_date := dmUtils.MyStrToDate(dmData.qQSOBefore.FieldByName('qsodate').AsString);
    old_freq := dmData.qQSOBefore.FieldByName('freq').AsString;
    old_mode := dmData.qQSOBefore.FieldByName('mode').AsString;
    old_adif := dmDXCC.AdifFromPfx(dmData.qQSOBefore.FieldByName('dxcc_ref').AsString);
    old_qslr := dmData.qQSOBefore.FieldByName('qsl_r').AsString;
    old_call := dmData.qQSOBefore.FieldByName('callsign').AsString;
    old_time := dmData.qQSOBefore.FieldByName('time_on').AsString;
    old_rsts := dmData.qQSOBefore.FieldByName('rst_s').AsString;
    old_rstr := dmData.qQSOBefore.FieldByName('rst_r').AsString
  end
  else begin
    old_date := dmUtils.MyStrToDate(dmData.qCQRLOG.FieldByName('qsodate').AsString);
    old_freq := dmData.qCQRLOG.FieldByName('freq').AsString;
    old_mode := dmData.qCQRLOG.FieldByName('mode').AsString;
    old_adif := dmDXCC.AdifFromPfx(dmData.qCQRLOG.FieldByName('dxcc_ref').AsString);
    old_qslr := dmData.qCQRLOG.FieldByName('qsl_r').AsString;
    old_call := dmData.qCQRLOG.FieldByName('callsign').AsString;
    old_time := dmData.qCQRLOG.FieldByName('time_on').AsString;
    old_rsts := dmData.qCQRLOG.FieldByName('rst_s').AsString;
    old_rstr := dmData.qCQRLOG.FieldByName('rst_r').AsString
  end;
  if fViewQSO then
    old_call := '';
  edtCallExit(nil);
  edtGridExit(nil);
  lblWAZ.Caption := edtWAZ.Text;
  lblITU.Caption := edtITU.Text;
  btnSave.Enabled := not fViewQSO;
  for i:=0 to ComponentCount-1 do
  begin
    if (frmNewQSO.Components[i] is TEdit) then
      (frmNewQSO.Components[i] As TEdit).ReadOnly := fViewQSO
  end;
  edtDate.ReadOnly  := fViewQSO;
  mComment.ReadOnly := fViewQSO;
  edtDXCCRef.ReadOnly:=True;  //we allow only DXCCs from list, no free type
  ReturnToNewQSO
end;

procedure TfrmNewQSO.NewQSO;
begin
  edtCall.Text := '';
  UnsetEditLabel;
  ShowWin := True;
  ShowWindows
end;

procedure TfrmNewQSO.SavePosition;
begin
  dmUtils.SaveWindowPos(frmNewQSO);
  if frmContest.Showing then  frmContest.SaveSettings;
  cqrini.WriteBool('NewQSO','StatBar',sbNewQSO.Visible);
  cqrini.SaveToDisk
end;

procedure TfrmNewQSO.SynCallBook;
var
  County  : String = '';
  StoreTo : String = '';
  IgnoreQRZ : Boolean = False;
  MvToRem   : Boolean = False;
  AlwaysReplace : Boolean;
  ReplaceZonesEtc : Boolean;
  tmp : String;
begin
  if c_ErrMsg <> '' then
  begin
    mCallBook.Text := c_ErrMsg;
    exit
  end;
  if c_SyncText = '' then //we should have data from callbook
  begin
    c_callsign := dmUtils.GetIDCall(c_callsign);
    mCallBook.Lines.Add(c_callsign);
    mCallBook.Lines.Add(c_address);
    mCallBook.SelStart := 1;

    IgnoreQRZ     := cqrini.ReadBool('NewQSO','IgnoreQRZ',False);
    MvToRem       := cqrini.ReadBool('NewQSO','MvToRem',True);
    AlwaysReplace := cqrini.ReadBool('NewQSO','UseCallBookData',False);
    ReplaceZonesEtc := cqrini.ReadBool('NewQSO','UseCallbookZonesEtc',True);


    if (not IgnoreQRZ) and (c_qsl<>'') then
    begin
      if (edtQSL_VIA.Text = '') then
      begin
        tmp := dmUtils.GetQSLVia(c_qsl);
        if dmUtils.IsQSLViaValid(dmUtils.CallTrim(tmp)) then
          edtQSL_VIA.Text := dmUtils.CallTrim(tmp)
      end;
      if MvToRem then
      begin
        if (Pos(LowerCase(c_qsl),LowerCase(edtRemQSO.Text))=0) then
        begin
          if edtRemQSO.Text= '' then
            edtRemQSO.Text := c_qsl
          else
            edtRemQSO.Text := edtRemQSO.Text + ', '+c_qsl
        end
      end
    end;

    if (edtName.Text = '') or AlwaysReplace then
      edtName.Text := c_nick; //operator's name
    if ((edtQTH.Text = '') or AlwaysReplace) and (c_callsign = edtCall.Text) then
      edtQTH.Text := c_qth;  //qth

    if ((edtGrid.Text='') or AlwaysReplace) and dmUtils.IsLocOK(c_grid) and (c_callsign = edtCall.Text) then
    begin
      edtGrid.Text := c_grid;
      edtGridExit(nil)
    end;  //grid

    if (cmbIOTA.Text='') or AlwaysReplace then
    begin
      cmbIOTA.Text := c_iota;
      cmbIOTAExit(nil)
    end;

    if ((c_state <> '') and (edtState.Text = '') or AlwaysReplace or ReplaceZonesEtc) and (c_callsign = edtCall.Text) then
    begin
      edtState.Text := c_state;
      if ((c_county <> '') and (edtCounty.Text='')) or AlwaysReplace or ReplaceZonesEtc then
      begin
        if ((edtState.Text<>'') and (c_county <> '')) then //chk c_county.Might be empty because above if-and-or-or  passes it wnen empty
          edtCounty.Text := edtState.Text+','+c_county
          else
          edtCounty.Text := c_county
      end
    end;  //county

    if (c_itu<>'') and ReplaceZonesEtc and (c_callsign = edtCall.Text) and (c_itu<>'0')then
    begin
      edtITU.Text    := c_itu;
      lblITU.Caption := c_itu
    end;

    if (c_waz<>'') and ReplaceZonesEtc and (c_callsign = edtCall.Text) and (c_waz<>'0') then
    begin
      edtWAZ.Text    := c_waz;
      lblWAZ.Caption := c_waz
    end;

    if (edtGrid.Text <> '') then
    begin
      CalculateDistanceEtc
    end;

    if c_zip <> '' then
    begin
      County := dmData.FindCounty1(c_zip,lblDXCC.Caption,StoreTo);
      if County <> '' then
      begin
        if (StoreTo = 'county') and (edtCounty.Text='') then
          edtCounty.Text := County
        else if (StoreTo = 'QTH') and (edtQTH.Text='') then
          edtQTH.Text := County
        else if (StoreTo = 'award') and (edtAward.Text='') then
          edtAward.Text := County
        else if (StoreTo = 'state') and (edtState.Text='') then
          edtState.Text := County
      end;

      County := dmData.FindCounty2(c_zip,lblDXCC.Caption,StoreTo);
      if County <> '' then
      begin
        if (StoreTo = 'county') and (edtCounty.Text='') then
          edtCounty.Text := County
        else if (StoreTo = 'QTH') and (edtQTH.Text='') then
          edtQTH.Text := County
        else if (StoreTo = 'award') and (edtAward.Text='') then
          edtAward.Text := County
        else if (StoreTo = 'state') and (edtState.Text='') then
          edtState.Text := County
      end;
      County := dmData.FindCounty3(c_zip,lblDXCC.Caption,StoreTo);
      if County <> '' then
      begin
        if (StoreTo = 'county') and (edtCounty.Text='') then
          edtCounty.Text := County
        else if (StoreTo = 'QTH') and (edtQTH.Text='') then
          edtQTH.Text := County
        else if (StoreTo = 'award') and (edtAward.Text='') then
          edtAward.Text := County
        else if (StoreTo = 'state') and (edtState.Text='') then
          edtState.Text := County
      end
    end; //zip code

    if c_dok <> '' then
    begin
      edtDok.Text := c_dok
    end;

  end;
  if edtState.Text<>'' then
    edtStateExit(nil);
  CheckAwardClub;
  CheckQTHClub;
  CheckCountyClub;
  CheckStateClub
end;

procedure TfrmNewQSO.AppIdle(Sender: TObject; var Handled: Boolean);
begin
  Handled := True
end;

procedure TfrmNewQSO.NewQSOFromSpot(call,freq,mode : String;FromRbn : Boolean = False);
var
  etmp : Extended;
begin
  if (old_ccall <> call) or (old_cmode<>mode) or (old_cfreq<>freq) then
  begin
    old_ccall := call;
    old_cmode := mode;
    old_cfreq := freq;

    edtCall.Text := '';
    cbOffline.Checked := False;
    etmp := dmUtils.MyStrToFloat(freq);
    etmp := etmp/1000;
    freq := FloatToStrF(etmp,ffFixed,10,8);
    FromDXC      := True;
    edtCall.Text := call;
    cmbFreq.Text := freq;
    if chkAutoMode.Checked then
      cmbMode.Text := RigCmd2DataMode(mode);
    freq := FloatToStr(etmp);
    //if not FromRbn then
         mode := dmUtils.GetModeFromFreq(freq);
    etmp := etmp*1000;
    freq := FloatToStr(etmp);
    frmTRXControl.SetModeFreq(mode,freq);
    edtCallExit(nil);
    if AnyRemoteOn then
                   begin
                    if RemoteActive='wsjtx' then
                     Begin
                      CallFromSpot:=True;
                      frmMonWsjtx.SendConfigure('','',call,' ',$7FFFFFFF,$7FFFFFFF,$7FFFFFFF,False,True);
                     end;
                    SendToBack;
                   end
                 else
                   BringToFront;
    if frmContest.Showing then
     Begin
     //this makes "double round" setting new qso but works with minimal code
     frmContest.edtCall.Text:=frmNewQSO.edtCall.Text;
     frmContest.edtCallExit(nil);
     end
  end
end;

procedure TfrmNewQSO.SetEditLabel;
begin
  lblCall.Caption    := 'Call (edit mode):';
  lblCall.Font.Color := clRed;
  Caption := dmUtils.GetNewQSOCaption('Edit QSO');
  cbOffline.Checked :=true;
end;

procedure TfrmNewQSO.UnsetEditLabel;
begin
  lblCall.Caption    := 'Call:';
  lblCall.Font.Color := clDefault;
  Caption := dmUtils.GetNewQSOCaption('New QSO');
  cbOffline.Checked := cqrini.ReadBool('TMPQSO','OFF',False);
  sbNewQSO.Panels[0].Text := cMyLoc + CurrentMyLoc;
  cmbProfiles.Text := UsrAssignedProfile;
  Op := cqrini.ReadString('TMPQSO','OP','');
end;

procedure TfrmNewQSO.CheckCallsignClub;
begin
  frmQSODetails.mode     := cmbMode.Text;
  frmQSODetails.freq     := cmbFreq.Text;
  frmQSODetails.ClubDate := edtDate.Text;
  if dmMembership.Club1.MainFieled = 'idcall' then
    frmQSODetails.ClubData1 := idcall;

  if dmMembership.Club2.MainFieled = 'idcall' then
    frmQSODetails.ClubData2 := idcall;

  if dmMembership.Club3.MainFieled = 'idcall' then
    frmQSODetails.ClubData3 := idcall;

  if dmMembership.Club4.MainFieled = 'idcall' then
    frmQSODetails.ClubData4 := idcall;

  if dmMembership.Club5.MainFieled = 'idcall' then
    frmQSODetails.ClubData5 := idcall;
end;

procedure TfrmNewQSO.CheckQTHClub;
begin
  frmQSODetails.mode     := cmbMode.Text;
  frmQSODetails.freq     := cmbFreq.Text;
  frmQSODetails.ClubDate := edtDate.Text;
  if dmMembership.Club1.MainFieled = 'qth' then
    frmQSODetails.ClubData1 := edtQTH.Text;

  if dmMembership.Club2.MainFieled = 'qth' then
    frmQSODetails.ClubData2 := edtQTH.Text;

  if dmMembership.Club3.MainFieled = 'qth' then
    frmQSODetails.ClubData3 := edtQTH.Text;

  if dmMembership.Club4.MainFieled = 'qth' then
    frmQSODetails.ClubData4 := edtQTH.Text;

  if dmMembership.Club5.MainFieled = 'qth' then
    frmQSODetails.ClubData5 := edtQTH.Text;
end;

procedure TfrmNewQSO.CheckAwardClub;
begin
  frmQSODetails.mode     := cmbMode.Text;
  frmQSODetails.freq     := cmbFreq.Text;
  frmQSODetails.ClubDate := edtDate.Text;
  if dmMembership.Club1.MainFieled = 'award' then
    frmQSODetails.ClubData1 := edtAward.Text;

  if dmMembership.Club2.MainFieled = 'award' then
    frmQSODetails.ClubData2 := edtAward.Text;

  if dmMembership.Club3.MainFieled = 'award' then
    frmQSODetails.ClubData3 := edtAward.Text;

  if dmMembership.Club4.MainFieled = 'award' then
    frmQSODetails.ClubData4 := edtAward.Text;

  if dmMembership.Club5.MainFieled = 'award' then
    frmQSODetails.ClubData5 := edtAward.Text;
end;

procedure TfrmNewQSO.CheckCountyClub;
begin
  frmQSODetails.mode     := cmbMode.Text;
  frmQSODetails.freq     := cmbFreq.Text;
  frmQSODetails.ClubDate := edtDate.Text;
  if dmMembership.Club1.MainFieled = 'county' then
    frmQSODetails.ClubData1 := edtCounty.Text;

  if dmMembership.Club2.MainFieled = 'county' then
    frmQSODetails.ClubData2 := edtCounty.Text;

  if dmMembership.Club3.MainFieled = 'county' then
    frmQSODetails.ClubData3 := edtCounty.Text;

  if dmMembership.Club4.MainFieled = 'county' then
    frmQSODetails.ClubData4 := edtCounty.Text;

  if dmMembership.Club5.MainFieled = 'county' then
    frmQSODetails.ClubData5 := edtCounty.Text;
end;

procedure TfrmNewQSO.StoreClubInfo(where,StoreText : String);
begin
  StoreText := trim(StoreText);
  if (where = 'award') and (Pos(LowerCase(StoreText),LowerCase(edtAward.text))=0) then
  begin
    if edtAward.Text <> '' then
      edtAward.Text := edtAward.Text + ' ' + StoreText
    else
      edtAward.Text := StoreText;
    edtAwardExit(nil);
  end;
  if (where = 'qth') and (Pos(UpperCase(StoreText),UpperCase(edtQTH.text))=0) then
  begin
    if edtQTH.Text <> ''then
      edtQTH.Text := edtQTH.Text + ' ' + StoreText
    else
      edtQTH.Text := StoreText;
    edtQTHExit(nil);
  end;
  if (where = 'remarks') and (Pos(LowerCase(StoreText),LowerCase(edtRemQSO.text))=0) then
  begin
    if edtRemQSO.Text <> ''  then
      edtRemQSO.Text := edtRemQSO.Text + ' ' + StoreText
    else
      edtRemQSO.Text := StoreText;
  end;
  if (where = 'name') and (Pos(LowerCase(StoreText),LowerCase(edtName.text))=0) then
  begin
    if edtName.Text <> '' then
      edtName.Text := edtName.Text + ' ' + StoreText
    else
      edtName.Text := StoreText;
  end;
  if (where = 'county') and (Pos(LowerCase(StoreText),LowerCase(edtCounty.text))=0) and (edtCounty.Text <> '') then
  begin
    edtCounty.Text := StoreText;
    edtCountyExit(nil);
  end;
  if (where = 'grid') and (edtGrid.Text='') then
    edtGrid.Text := StoreText;
  if (where = 'state') and (edtState.Text='') then
    edtState.Text := StoreText
end;


procedure TfrmNewQSO.CheckStateClub;
begin
  frmQSODetails.mode     := cmbMode.Text;
  frmQSODetails.freq     := cmbFreq.Text;
  frmQSODetails.ClubDate := edtDate.Text;
  if dmMembership.Club1.MainFieled = 'state' then
    frmQSODetails.ClubData1 := edtState.Text;

  if dmMembership.Club2.MainFieled = 'state' then
    frmQSODetails.ClubData2 := edtState.Text;

  if dmMembership.Club3.MainFieled = 'state' then
    frmQSODetails.ClubData3 := edtState.Text;

  if dmMembership.Club4.MainFieled = 'state' then
    frmQSODetails.ClubData4 := edtState.Text;

  if dmMembership.Club5.MainFieled = 'state' then
    frmQSODetails.ClubData5 := edtState.Text;
end;

procedure TfrmNewQSO.SetSplit(s : String);
var
   d:integer;
begin
  if s='9' then
   Begin
    d := cqrini.ReadInteger('Split','9',0);
    if d<0 then
      frmTRXControl.Split(d-Random(100)*10)
     else
      frmTRXControl.Split(d+Random(100)*10)
   end
  else
    frmTRXControl.Split(cqrini.ReadInteger('Split',s,0));
end;

procedure TfrmNewQSO.ShowWindows;
begin
  if frmTRXControl.Showing then
    frmTRXControl.BringToFront;
  if frmBandMap.Showing then
    frmBandMap.BringToFront;
  if frmDXCluster.Showing then
    frmDXCluster.BringToFront;
  if frmQSODetails.Showing then
    frmQSODetails.BringToFront;
  frmNewQSO.BringToFront
end;

procedure TfrmNewQSO.CheckAttachment;
begin
  if DirectoryExists(dmUtils.GetCallAttachDir(edtCall.Text)) then
    sbtnAttach.Visible := True
  else
    sbtnAttach.Visible := False
end;

procedure TfrmNewQSO.CheckQSLImage;
begin
  if dmUtils.QSLFrontImageExists(dmUtils.GetCallForAttach(edtCall.Text)) <> '' then
    sbtnQSL.Visible := True
  else
    sbtnQSL.Visible := False
end;

procedure TfrmNewQSO.UpdateFKeyLabels;
begin
  frmCWType.fraCWKeys1.UpdateFKeyLabels;
  frmCWKeys.fraCWKeys.UpdateFKeyLabels
end;

procedure TfrmNewQSO.ChangeCallBookCaption;
begin
  if cqrini.ReadBool('Callbook','HamQTH',True) then
    lblCallbookInformation.Caption := 'Callbook (HamQTH.com):';
  if cqrini.ReadBool('Callbook','QRZ',True) then
    lblCallbookInformation.Caption := 'Callbook (qrz.com):';
  if cqrini.ReadBool('Callbook','QRZCQ',True) then
    lblCallbookInformation.Caption := 'Callbook (qrzCQ.com):';
end;

procedure TfrmNewQSO.CalculateLocalSunRiseSunSet;
var
  myloc : String;
  Lat, Long : Currency;
  SunRise, SunSet : TDateTime;
  SunDelta : Currency = 0;
  inUTC : Boolean = False;
begin
  myloc := cqrini.ReadString('Station','LOC','');
  inUTC := cqrini.ReadBool('Program','SunUTC',False);
  if dmUtils.SysUTC then
    SunDelta := dmUtils.GetLocalUTCDelta
  else
    SunDelta := cqrini.ReadFloat('Program','SunOffset',0);
  chkAutoMode.Checked := cqrini.ReadBool('NewQSO','AutoMode',True);
  if dmUtils.IsLocOK(myloc) then
  begin
    dmUtils.CoordinateFromLocator(dmUtils.CompleteLoc(myloc) ,lat,long);
    dmUtils.CalcSunRiseSunSet(lat,long,SunRise,SunSet);
    if not inUTC then
    begin
      SunRise := SunRise + (SunDelta/24);
      SunSet  := SunSet + (SunDelta/24)
    end;
    lblLocSunRise.Caption := TimeToStr(SunRise);
    lblLocSunSet.Caption  := TimeToStr(SunSet)
  end
  else begin
    lblLocSunRise.Caption := '';
    lblLocSunSet.Caption  := ''
  end
end;

procedure TfrmNewQSO.SendSpot;
var
  call,rst_s,stx,stx_str,srx,srx_str,HisName,HelloMsg : String;
  tmp  : String;
  ModRst,
  HMLoc :String;
  f    : Currency;
  freq : String;
begin
  HelloMsg:='';
  if edtCall.Text <> '' then
  begin
    if TryStrToCurr(cmbFreq.Text,f) then
    begin
      if (cqrini.ReadBool('DXCluster','SpotRX',False)) then
        f := StrToCurr(edtRXFreq.Text);
      f := f*1000;
      call:=  edtCall.Text;
      rst_s := edtHisRST.Text;
      stx :=  edtContestSerialSent.Text;
      stx_str:=edtContestExchangeMessageSent.Text;
      srx :=  edtContestSerialReceived.Text;
      srx_str:=edtContestExchangeMessageReceived.Text;
      HisName:= edtName.Text;
      tmp := 'DX ' + FloatToStrF(f,ffFixed,8,1) + ' ' + call;
      ModRst := cmbMode.Text+' '+ rst_s;
      HMLoc := CurrentMyLoc+'<'+dmSatellite.GetPropShortName(cmbPropagation.Text)+'>'+edtGrid.Text;

    end;
  end
  else begin
    dmData.Q.Close;
    if dmData.trQ.Active then dmData.trQ.Rollback;
    dmData.Q.SQL.Text := 'SELECT callsign,freq,rxfreq FROM cqrlog_main ORDER BY qsodate DESC, time_on DESC LIMIT 1';
    dmData.trQ.StartTransaction;
    if dmData.DebugLevel >=1 then
      Writeln(dmData.Q.SQL.Text);
    dmData.Q.Open();
    call := dmData.Q.Fields[0].AsString;
    freq := FloatToStrF(dmData.Q.Fields[1].AsCurrency*1000,ffFixed,8,1);
    if (cqrini.ReadBool('DXCluster','SpotRX',False)) then
      freq := FloatToStrF(dmData.Q.Fields[2].AsCurrency*1000,ffFixed,8,1);
    dmData.Q.Close();
    dmData.trQ.Rollback;
    tmp  := 'DX ' + freq + ' ' + call;

    dmData.Q.SQL.Text := 'SELECT mode,rst_s,loc,prop_mode,my_loc,stx,stx_string,srx,srx_string,name FROM cqrlog_main ORDER BY qsodate DESC, time_on DESC LIMIT 1';
    dmData.trQ.StartTransaction;
    if dmData.DebugLevel >=1 then
      Writeln(dmData.Q.SQL.Text);
    dmData.Q.Open();
    ModRst  := dmData.Q.Fields[0].AsString+' '+dmData.Q.Fields[1].AsString;
    HMLoc   := dmData.Q.Fields[4].AsString+'<'+dmData.Q.Fields[3].AsString+'>'+dmData.Q.Fields[2].AsString;
    rst_s := dmData.Q.Fields[1].AsString;
    stx :=  dmData.Q.Fields[5].AsString;
    stx_str:=dmData.Q.Fields[6].AsString;
    srx :=  dmData.Q.Fields[7].AsString;
    srx_str:=dmData.Q.Fields[8].AsString;
    HisName:= dmData.Q.Fields[9].AsString;
    dmData.Q.Close();
    dmData.trQ.Rollback;

  end;
  if (call = '') then
  exit;

  with TfrmSendSpot.Create(self) do
  try
    edtSpot.Text := tmp + ' ';
    ModeRst      :=' '+ModRst;
    HisMyLoc     :=' '+HMLoc;
    Scall := call;
    Srst_s := rst_s;
    Sstx := stx ;
    Sstx_str:=stx_str;
    Ssrx := srx ;
    Ssrx_str:=srx_str;
    SHisName:= HisName;
    SHelloMsg:=HelloMsg;
    ShowModal;
    if ModalResult = mrOK then
    begin
      frmDXCluster.edtCommand.Text := trim(edtSpot.Text);
      if frmDXCluster.ConTelnet then
        frmDXCluster.SendCommand(frmDXCluster.edtCommand.Text);
      frmDXCluster.edtCommand.Clear
    end
  finally
    Free
  end
end;

procedure TfrmNewQSO.RunST(script: String);   //run start stop script
var
   AProcess: TProcess;
   index     : integer;
   paramList : TStringList;
begin
  if not FileExists(dmData.HomeDir + script) then
  exit;
  AProcess := TProcess.Create(nil);
  try
    AProcess.Executable := 'bash';
    index:=0;
    paramList := TStringList.Create;
    paramList.Delimiter := ' ';
    paramList.DelimitedText := dmData.HomeDir + script;
    AProcess.Parameters.Clear;
    while index < paramList.Count do
    begin
      AProcess.Parameters.Add(paramList[index]);
      inc(index);
    end;
    paramList.Free;
    if dmData.DebugLevel>=1 then Writeln('AProcess.Executable: ',AProcess.Executable,' Parameters: ',AProcess.Parameters.Text);
    AProcess.Options:=[poWaitOnExit];
    AProcess.Execute;
    while AProcess.Running do
          Application.ProcessMessages;
  finally
    AProcess.Free
  end
end;

procedure TfrmNewQSO.RunVK(key_pressed: String);
const
  cVoiceKeyer = 'voice_keyer/voice_keyer.sh';
var
   AProcess: TProcess;
begin
  if cqrini.ReadBool('TRX' + frmTRXControl.RigInUse, 'RigVoice', False) then ///use Hamlib's \send_voice command instead.
  Begin
    frmTRXControl.SendVoice(Copy(key_pressed,2,length(key_pressed)-1));
    exit;
  end;

  if not FileExists(dmData.HomeDir + cVoiceKeyer) then 
  exit;
  
  AProcess := TProcess.Create(nil);
  try
    AProcess.Executable := dmData.HomeDir + cVoiceKeyer;
    AProcess.Parameters.Clear;
    AProcess.Parameters.Add(key_pressed);
    if dmData.DebugLevel>=1 then Writeln('AProcess.Executable: ',AProcess.Executable,' Parameters: ',AProcess.Parameters.Text);
    AProcess.Options:=[poWaitOnExit];
    AProcess.Execute;
    While AProcess.Running do
          Application.ProcessMessages;
  finally
    AProcess.Terminate(0);
    AProcess.Free
  end
end;

procedure TfrmNewQSO.InitializeCW;
var
  KeyType    : TKeyType;
  UseSpeed   : integer;
  KeyerType  : integer;
  n,i        : String;
begin
  i:='';
  if (CWint<>nil) then
   Begin
    sbNewQSO.Panels[2].Text := '';
    CWint.Close;
    FreeAndNil(CWint)
   end;
  UseSpeed:=0; //show zero when pot speed  or no keyer
  n:=intToStr(frmTRXControl.cmbRig.ItemIndex);
  if ((dmData.DebugLevel>=1 ) or ((abs(dmData.DebugLevel) and 8) = 8 )) then Writeln('Radio'+n+' CW settings:');
  KeyerType :=  cqrini.ReadInteger('CW'+n,'Type',0);
  if ((dmData.DebugLevel>=1 ) or ((abs(dmData.DebugLevel) and 8) = 8 )) then Writeln('CW init keyer type:',KeyerType);
  Menuitem45.Visible:=False;  //send hex commands to win/k3ng keyer
  case  KeyerType of
    1 : begin
          CWint := TCWWinKeyerUSB.Create;
          CWint.DebugMode := dmData.DebugLevel>=1;
          if dmData.DebugLevel < 0 then
                  CWint.DebugMode  :=  CWint.DebugMode  or ((abs(dmData.DebugLevel) and 8) = 8 );
          CWint.Port      := cqrini.ReadString('CW'+n,'wk_port','');
          CWint.Device    := cqrini.ReadString('CW'+n,'wk_port','');
          CWint.MinSpeed  := cqrini.ReadInteger('CW'+n, 'wk_min', 5);
          CWint.MaxSpeed  := cqrini.ReadInteger('CW'+n, 'wk_max', 60);
          CWint.PortSpeed := 1200;
          if not  cqrini.ReadBool('CW'+n,'PotSpeed',False) then
            UseSpeed := cqrini.ReadInteger('CW'+n,'wk_speed',30)
           else
            UseSpeed:=-1;
          Menuitem45.Visible:=True;
          if cqrini.ReadString('CW'+n,'wk_hex','')<>'' then    //additional init values
             i:=Uppercase(cqrini.ReadString('CW'+n,'wk_hex',''));
        end;
    2 : begin
          CWint    := TCWDaemon.Create;
          CWint.DebugMode := dmData.DebugLevel>=1;
          if dmData.DebugLevel < 0 then
                 CWint.DebugMode  :=  CWint.DebugMode  or ((abs(dmData.DebugLevel) and 8) = 8 );
          CWint.Port      := cqrini.ReadString('CW'+n,'cw_port','');
          CWint.Device    := cqrini.ReadString('CW'+n,'cw_address','');
          CWint.MinSpeed  := cqrini.ReadInteger('CW'+n, 'cw_min', 5);
          CWint.MaxSpeed  := cqrini.ReadInteger('CW'+n, 'cw_max', 60);
          CWint.SetMinMaxSpeed(CWint.MinSpeed,CWint.MaxSpeed-CWint.MinSpeed);
          CWint.PortSpeed := 0;
          UseSpeed := cqrini.ReadInteger('CW'+n,'cw_speed',30);
          Menuitem45.Visible:=True;
          writeln( cqrini.ReadString('CW'+n,'cw_hex',''));
          if cqrini.ReadString('CW'+n,'cw_hex','')<>'' then    //additional init values
            i:=Uppercase(cqrini.ReadString('CW'+n,'cw_hex',''));
        end;
    3 : begin
          CWint := TCWK3NG.Create;
          CWint.DebugMode := dmData.DebugLevel>=1;
          if dmData.DebugLevel < 0 then
                 CWint.DebugMode  :=  CWint.DebugMode  or ((abs(dmData.DebugLevel) and 8) = 8 );
          CWint.Port      := cqrini.ReadString('CW'+n,'K3NGPort'+n,'');
          CWint.Device    := cqrini.ReadString('CW'+n,'K3NGPort'+n,'');
          CWint.MinSpeed  := cqrini.ReadInteger('CW'+n, 'K3NG_min', 5);
          CWint.MaxSpeed  := cqrini.ReadInteger('CW'+n, 'K3NG_max', 60);
          CWint.PortSpeed := cqrini.ReadInteger('CW'+n,'K3NGSerSpeed',115200);
          UseSpeed        := cqrini.ReadInteger('CW'+n,'K3NGSpeed',30);
          Menuitem45.Visible:=True;
          if cqrini.ReadString('CW'+n,'K3NG_hex','')<>'' then    //additional init values
            i:=Uppercase(cqrini.ReadString('CW'+n,'K3NG_hex',''));
        end;
    4 : begin
          CWint        := TCWHamLib.Create;
          CWint.DebugMode := dmData.DebugLevel>=1;
          if dmData.DebugLevel < 0 then
                 CWint.DebugMode  :=  CWint.DebugMode  or ((abs(dmData.DebugLevel) and 8) = 8 );
          CWint.Port         := cqrini.ReadString('TRX'+n,'RigCtldPort','4532');
          CWint.Device       := cqrini.ReadString('TRX'+n,'host','localhost');
          CWint.MinSpeed     := cqrini.ReadInteger('CW'+n, 'HamLib_min', 5);
          CWint.MaxSpeed     := cqrini.ReadInteger('CW'+n, 'HamLib_max', 60);
          CWint.HamlibBuffer := cqrini.ReadBool('CW'+n, 'UseHamlibBuffer', False);
          UseSpeed := cqrini.ReadInteger('CW'+n,'HamLibSpeed',30);
        end;
  end; //case
  if KeyerType > 0 then
   Begin
     CWint.Open;
     if UseSpeed>0 then CWint.SetSpeed(UseSpeed);

   if (cqrini.ReadInteger('CW'+n,'Type',0)=1) and cqrini.ReadBool('CW'+n,'PotSpeed',False) then
    Begin
     sbNewQSO.Panels[4].Text := 'Pot WPM';
     if frmCWType.Showing then frmCWType.Caption:='CW Type: Pot WPM';
    end
    else
     begin
      sbNewQSO.Panels[4].Text := IntToStr(CWint.GetSpeed) + 'WPM';
      if frmCWType.Showing then frmCWType.Caption:='CW Type: '+ IntToStr(CWint.GetSpeed)+'WPM';
     end;
    if i<>'' then
             Begin
              sleep(300);
              CWint.SendHex(i);
             end;
   end;
end;

procedure TfrmNewQSO.OnBandMapClick(Sender:TObject;Call,Mode: String;Freq:Currency);
begin
  NewQSOFromSpot(Call,FloatToStr(Freq),Mode)
end;

procedure TfrmNewQSO.CreateAutoBackup;
var
  call, path1, path2 : String;
  backupType1, backupType2 : integer;
begin
  path1 := cqrini.ReadString('Backup','Path',dmData.DataDir);
  path2 := cqrini.ReadString('Backup','Path1','');
  call  := StringReplace(cqrini.ReadString('Station', 'Call', ''), '/', '_', [rfReplaceAll, rfIgnoreCase]);
  if not DirectoryExists(path1) then
    exit;

  if (path2<>'') and (not DirectoryExists(path2)) then
    exit;

  with TfrmExportProgress.Create(self) do
  try
    AutoBackup       := True;
    SecondBackupPath := Path2;

    backupType1      := cqrini.ReadInteger('Backup', 'BackupType', 0);
    backupType2      := cqrini.ReadInteger('Backup', 'BackupType1', 0);

    FileName         := Path1;

    if backupType1 = 1 then
      FileName := FileName + call + '_backup.adi'
    else if backupType1 = 2 then   // custom file name over-writes default
      FileName := FileName + cqrini.ReadString('Backup', 'FileName1', 'fileName1.adi')
    else
      FileName := FileName + call + '_'+FormatDateTime('yyyy-mm-dd_hh-mm-ss',now)+'.adi';

    FileName2         := Path2;
    if backupType2 = 1 then
      FileName2 := FileName2 + call + '_backup.adi'
    else if backupType2 = 2 then // custom file name over-writes default
      FileName2 := FileName2 + cqrini.ReadString('Backup', 'FileName2', 'fileName2.adi')
    else
      FileName2 := FileName2 + call + '_'+FormatDateTime('yyyy-mm-dd_hh-mm-ss',now)+'.adi';

    ExportType := 2;

    ShowModal
  finally
    Free
  end
end;

procedure TfrmNewQSO.UploadAllQSOOnline;
begin
  if not tmrUploadAll.Enabled then
  begin
    UploadAll            := False;
    tmrUploadAll.Enabled := True
  end
end;

function TfrmNewQSO.CheckFreq(freq : String) : String;
begin
  if (Pos(',',freq) > 0) then
    freq[Pos(',',freq)] := FormatSettings.DecimalSeparator;
  Result := freq;
end;

procedure TfrmNewQSO.ReturnToNewQSO;
begin
  if frmContest.Showing  and frmContest.ContestReady then
      frmContest.edtCall.SetFocus
    else
      if edtCall.Enabled then
         edtCall.SetFocus
end;

procedure TfrmNewQSO.RefreshInfoLabels;
begin
  lblHisTime.Refresh;
  lblGreeting.Refresh;
  lblTarSunRise.Refresh;
  lblTarSunSet.Refresh;
  lblHisTime.Refresh
end;

procedure TfrmNewQSO.FillDateTimeFields;
var
  Date : TDateTime;
  sDate : String='';
  Mask  : String='';
begin
  date := dmUtils.GetDateTime(0);
  StartTime := date;
  edtDate.Clear;
  dmUtils.DateInRightFormat(date,Mask,sDate);
  edtDate.Text      := sDate;
  edtStartTime.Text := FormatDateTime('hh:mm',date);
  edtEndTime.Text   := FormatDateTime('hh:mm',date)
end;
procedure TfrmNewQSO.StartUpRemote;
var
  StartKey:String;
Begin
    if StartUpCount > 10 then exit; //done already
    inc(StartUpCount);
    if StartUpCount = 10 then
     Begin
       inc(StartUpCount); //to be 11
       if not Application.HasOption('r','remote') then exit
        else
         Begin
           StartKey:= Application.GetOptionValue('r','remote');
           if length(StartKey)>1 then  exit; //must be one letter
           case UpperCase(StartKey[1]) of
               'J' :  GoToRemoteMode(rmtWsjt);
               'M' :  GoToRemoteMode(rmtFldigi);
               'K' :  GoToRemoteMode(rmtADIF);
           end;
         end;
     end;
end;
procedure TfrmNewQSO.GoToRemoteMode(RemoteType : TRemoteModeType);
var
  run  : Boolean = False;
  path : String = '';
  tries: integer = 10;

begin
  cqrini.WriteInteger('Pref', 'ActPageIdx', 20);  //set fldigi/wsjt tab active.
  dmUtils.SaveDBGridInForm(frmNewQSO) ;
  case RemoteType of
    rmtFldigi : begin
                  RememberAutoMode := chkAutoMode.Checked;
                  chkAutoMode.Checked   := False;
                  if mnuRemoteModeWsjt.Checked then       //not both on at same time
                     DisableRemoteMode;
                  if mnuRemoteModeADIF.Checked then          //not both on at same time
                        DisableRemoteMode;
                  mnuRemoteMode.Checked := True;
                  AnyRemoteOn := True;
                  lblCall.Caption       := 'Fldigi remote';
                  tmrFldigi.Interval    := cqrini.ReadInteger('fldigi','interval',2)*1000;
                  run                   := cqrini.ReadBool('fldigi','run',False);
                  path                  := cqrini.ReadString('fldigi','path','');
                  FldigiXmlRpc          := cqrini.ReadBool('fldigi','xmlrpc',False);
                  tmrFldigi.Enabled     := true;
                  if FldigiXmlRpc then
                     frmxfldigi.Visible := true;
                  RemoteActive := 'fldigi';
                end;
    rmtWsjt   : begin
                  RememberAutoMode := chkAutoMode.Checked;
                  chkAutoMode.Checked   := False;
                  if mnuRemoteMode.Checked then          //not both on at same time
                  DisableRemoteMode;
                  if mnuRemoteModeADIF.Checked then          //not both on at same time
                        DisableRemoteMode;
                  mnuRemoteModeWsjt.Checked := True;
                  AnyRemoteOn := True;
                  WsjtxDecodeRunning        := false;
                  lblCall.Caption           := 'Wsjtx remote';
                  path                      := cqrini.ReadString('wsjt','path','');
                  run                       := cqrini.ReadBool('wsjt','run',False);

                  WsjtxMode := '';    //will be set by type1 'status'-message
                  WsjtxBand := '';
                  wSpeed    := 10;    //mS polling speed of wsjt remote
                  tmrWsjtx.Interval := wSpeed;

                  frmTRXControl.DisableRitXit; //wsjtx does not do this, so we have to ...

                  //multicast is 239.0.0.0/8
                  multicast:=pos('239.',cqrini.ReadString('wsjt','ip','127.0.0.1'))=1; //check multicast
                  if multicast then
                   Begin
                      WsjtxSockS := TUDPBlockSocket.Create;
                      if dmData.DebugLevel>=1 then Writeln('Multicast sendsocket created!');
                      WsjtxSockS.EnableReuse(true);
                      if dmData.DebugLevel>=1 then Writeln('Reuse enabled!');
                   end;

                  // start UDP server  http://synapse.ararat.cz/doc/help/blcksock.TBlockSocket.html
                  WsjtxSock := TUDPBlockSocket.Create;
                  if dmData.DebugLevel>=1 then Writeln('Socket created!');
                  WsjtxSock.EnableReuse(true);
                  if dmData.DebugLevel>=1 then Writeln('Reuse enabled!');
                  try
                    if multicast then
                     begin
                        WsjtxSock.createsocket;
                        WsjtxSock.Bind('0.0.0.0',cqrini.ReadString('wsjt','port','2237'));
                        WsjtxSock.AddMulticast(cqrini.ReadString('wsjt','ip','239.255.0.0'));
                        Assert(WsjtxSock.LastError = 0);
                        if dmData.DebugLevel>=1 then Writeln('Bind multicast RX '+cqrini.ReadString('wsjt','ip','239.255.0.0')+
                                                                        ':'+cqrini.ReadString('wsjt','port','2237'));
                        WsjtxSockS.createsocket;
                        WsjtxSockS.Bind('0.0.0.0','0');
                        WsjtxSockS.MulticastTTL := 1;
                        WsjtxSockS.connect(cqrini.ReadString('wsjt','ip','239.255.0.0'),cqrini.ReadString('wsjt','port','2237'));
                        Assert(WsjtxSockS.LastError = 0);
                        if dmData.DebugLevel>=1 then Writeln('Bind multicast TX '+cqrini.ReadString('wsjt','ip','239.255.0.0')+
                                                                        ':'+cqrini.ReadString('wsjt','port','2237'));
                     end
                    else
                     Begin
                        WsjtxSock.bind(cqrini.ReadString('wsjt','ip','127.0.0.1'),cqrini.ReadString('wsjt','port','2237'));

                        if dmData.DebugLevel>=1 then Writeln('Bind issued '+cqrini.ReadString('wsjt','ip','127.0.0.1')+
                                                                        ':'+cqrini.ReadString('wsjt','port','2237'));
                       // On bind failure try to rebind every second
                       while ((WsjtxSock.LastError <> 0) and (tries > 0 )) do
                         begin
                           dec(tries);
                           sleep(1000);
                           WsjtxSock.bind(cqrini.ReadString('wsjt','ip','127.0.0.1'),cqrini.ReadString('wsjt','port','2237'));
                         end;

                      end;
                     tmrWsjtx.Enabled  := True;
                  except
                      {if dmData.DebugLevel>=1 then} Writeln('Could not bind socket for wsjtx!');
                      edtRemQSO.Text := 'Could not bind socket for wsjtx!';
                     DisableRemoteMode;
                     exit
                  end;
                  mnuWsjtxmonitor.Visible := True; //we show "monitor" in view-submenu when active
                  if cqrini.ReadBool('Window','MonWsjtx',true) then acMonitorWsjtxExecute(nil);
                  RemoteActive := 'wsjtx';
                end;

    rmtADIF   : begin
                  RememberAutoMode := chkAutoMode.Checked;
                  chkAutoMode.Checked   := False;
                  if mnuRemoteModeWsjt.Checked then       //not both on at same time  wsjt
                     DisableRemoteMode;
                  if mnuRemoteMode.Checked then          //not both on at same time   fldigi
                        DisableRemoteMode;

                  mnuRemoteModeADIF.Checked := True;
                  AnyRemoteOn := True;

                  lblCall.Caption           := 'remote ADIF';
                  IsJS8Callrmt              := false;

                  // start UDP server  http://synapse.ararat.cz/doc/help/blcksock.TBlockSocket.html
                  //use lot of wsjtx stuff as it can not be running at same time
                  ADIFSock := TUDPBlockSocket.Create;
                  if dmData.DebugLevel>=1 then Writeln('Socket created!');
                  ADIFSock.EnableReuse(true);
                  if dmData.DebugLevel>=1 then Writeln('Reuse enabled!');
                  try
                    //fix these in preferences
                    ADIFSock.bind(cqrini.ReadString('n1mm','ip','127.0.0.1'),cqrini.ReadString('n1mm','port','2333'));
                    if dmData.DebugLevel>=1 then Writeln('Bind issued '+cqrini.ReadString('n1mm','ip','127.0.0.1')+
                                                                        ':'+cqrini.ReadString('n1mm','port','2333'));
                     // On bind failure try to rebind every second
                     while ((ADIFSock.LastError <> 0) and (tries > 0 )) do
                       begin
                         dec(tries);
                         sleep(1000);
                         ADIFSock.bind(cqrini.ReadString('n1mm','ip','127.0.0.1'),cqrini.ReadString('n1mm','port','2333'));
                       end;
                     tmrADIF.Enabled  := True;
                  except
                      {if dmData.DebugLevel>=1 then} Writeln('Could not bind socket for ADIF!');
                      edtRemQSO.Text := 'Could not bind socket for ADIF!';
                     DisableRemoteMode;
                     exit
                  end;
                  RemoteActive := 'adif';
                end;
           end; //case remote type

  ClearAll;
  lblCall.Font.Color    := clRed;
  edtCall.Enabled       := False;
  cbOffline.Checked     := True;
  cbOffline.Enabled     := False;
  btnSave.Enabled       := False;  //disable manual saving when remote is on
  tmrADIF.Interval      := 250;    //rate to read qsos from UDP (msec)
  if run and FileExists(ExtractWord(1,path,[' '])) then
    dmUtils.RunOnBackground(AnsiQuotedStr(path, '"'))
end;


procedure TfrmNewQSO.DisableRemoteMode;
var
  tries : integer = 10;
begin

  if  mnuRemoteModeWsjt.Checked then
  begin
      tmrWsjtx.Enabled := False;
      while ((WsjtxDecodeRunning) and (tries > 0)) do
      begin
        dec(tries);
        sleep(100); //flush running decode
        if dmData.DebugLevel>=1 then Writeln('Waiting WsjtDecode to end/Disableremotemode');
      end;
      mnuWsjtxmonitor.Visible := False;    //we do not show "monitor" in view-submenu when not active
      if (frmMonWsjtx <> nil) then
       begin
        if frmMonWsjtx.Showing then frmMonWsjtx.hide // and close monitor
         else cqrini.WriteBool('Window','MonWsjtx',false);
        FreeAndNil(frmMonWsjtx); //to release flooding richmemo
       end;
      if Assigned(WsjtxSock) then FreeAndNil(WsjtxSock);  // to release UDP socket
      if multicast then if Assigned(WsjtxSockS) then FreeAndNil(WsjtxSockS);  // to release UDP multicast TX socket
      mnuRemoteModeWsjt.Checked:= False;
  end;

  if mnuRemoteMode.Checked then
  begin
     tmrFldigi.Enabled         := False;
     if FldigiXmlRpc then frmxfldigi.Visible := false;
     mnuRemoteMode.Checked     := False;
  end ;

  if  mnuRemoteModeADIF.Checked then
  begin
      tmrADIF.Enabled:=false;
      if Assigned(ADIFSock) then FreeAndNil(ADIFSock);  // to release UDP socket
      mnuRemoteModeADIF.Checked:= False;
  end;

  AnyRemoteOn := False;
  RemoteActive := '';
  chkAutoMode.Checked:= RememberAutoMode;
  lblCall.Caption           := 'Call:';
  lblCall.Font.Color        := clDefault;
  edtCall.Enabled           := True;
  cbOffline.Checked         := False;
  cbOffline.Enabled         := True;
  btnSave.Enabled           := True;
  ReturnToNewQSO;
  //clear TMPQSO mode on close. Otherwise it shows up on next remote mode (procedure ClearAll makes it)
  cqrini.WriteString('TMPQSO','Mode','');
end;
procedure  TfrmNewQSO.SaveRemote;
Begin
     old_call:='';
     old_adif:=adif; // to prevent ChangeDXCC going True on qso save (a sort of fix ??? hooo...)
     btnSave.Click;
end;

procedure TfrmNewQSO.onExcept(Sender: TObject; E: Exception);
begin
  with TfrmException.Create(self) do
  try
    memErrorMessage.Lines.Add('Error in ' + E.UnitName);
    memErrorMessage.Lines.Add(E.Message);
    ShowModal
  finally
    Free
  end
end;

procedure TfrmNewQSO.DisplayCoordinates(latitude, Longitude : Currency);
var
  lat,long : String;
begin
  dmUtils.GetShorterCoordinates(latitude,longitude,lat,long);

  lblLat.Caption  := lat;
  lblLong.Caption := long
end;

procedure TfrmNewQSO.DrawGrayLine;

begin
  frmGrayline.s   := lblLat.Caption;
  frmGrayline.d   := lblLong.Caption;
  frmGrayline.pfx := lblDXCC.Caption;
  dmUtils.ModifyXplanetQso;
  frmGrayline.kresli
end;

procedure TfrmNewQSO.CheckForExternalTablesUpdate;
begin
  //when the callsign is not filled in, the iformation window appears
  //without this, the info about new dxcctables appeard first and was
  //covered by information window. Program looked like frozen
  if cqrini.ReadString('Station','Call','') = '' then
    exit;

  CheckForDXCCTablesUpdate;
  CheckForDOKTablesUpdate;
  CheckForQslManagersUpdate;
  CheckForMembershipUpdate;
  CheckForAlphaVersion
end;

procedure TfrmNewQSO.CheckForDXCCTablesUpdate;
var
  Tab   : TDXCCTabThread;
begin
  if cqrini.ReadBool('Program','CheckDXCCTabs',True) then
  begin
    Tab := TDXCCTabThread.Create(True);
    Tab.FreeOnTerminate := True;
    Tab.Start
  end
end;

procedure TfrmNewQSO.CheckForDOKTablesUpdate;
var
  Tab   : TDOKTabThread;
begin
  if cqrini.ReadBool('Program','CheckDOKTabs',False) then
  begin
    Tab := TDOKTabThread.Create(True);
    Tab.FreeOnTerminate := True;
    Tab.Start
  end
end;

procedure TfrmNewQSO.CheckForQslManagersUpdate;
var
  thqsl : TQSLTabThread;
begin
  if cqrini.ReadBool('Program','CheckQSLTabs',True) then
  begin
    thqsl := TQSLTabThread.Create(True);
    thqsl.FreeOnTerminate := True;
    thqsl.Start
  end
end;

procedure TfrmNewQSO.CheckForMembershipUpdate;
begin
  if cqrini.ReadBool('Clubs', 'CheckForUpdate', False) then
    dmMembership.CheckForMembershipUpdate
end;
procedure TfrmNewQSO.CheckForAlphaVersion;
var
  VerNr,
  VerAvailNr : integer;
  data:string;
Begin
  if not cqrini.ReadBool('Program', 'CheckAlpha', True) then exit;
  if not (TryStrToInt(ExtractWord(2,cVersionBase,['(',')']),VerNr)) then exit;
  VerAvailNr:=0;
   if dmUtils.GetDataFromHttp('https://raw.githubusercontent.com/OH1KH/CqrlogAlpha/refs/heads/main/compiled/version.txt', data) then
  begin
    if (pos('NOT FOUND',upcase(data))<>0) then exit;
    if not (TryStrToInt(ExtractWord(2,data,['(',')']),VerAvailNr)) then exit;
    if VerNr < VerAvailNr then
    begin
      try
        frmAbout:= TfrmAbout.Create(Application);
        frmAbout.PageControl1.ActivePage := frmAbout.tabUpgrade;
        frmAbout.lblVerze1.Caption := cVERSION + '  ' + cBUILD_DATE;
        frmAbout.Label8.Caption:='There is CqrlogAlpha version '+IntToStr(VerAvailNr)+' available!';
        frmAbout.IsNewVersion:=True;
        frmAbout.btnChangelog1.Font.Color:=clRed;
        frmAbout.btnChangelog1.Font.Style:=[fsBold];
        frmAbout.ShowModal
      finally
        frmAbout.Free;
      end
    end;
  end;
end;

//at least in Ubuntu 18.04 when user wanted to rewrite the second auto-selected
//number in a report, it wrote the number to the end of the report
//it worked fine in Ubuntu Gnome but doesn't in Debian, probably someting
//with GTK versions
procedure TfrmNewQSO.SelTextFix(Edit : TEdit; var Key : Char);
var
  ch : Char;
begin
  if Edit.SelText <> '' then
  begin
    ch := upcase(Key);
    if (ch in ['A'..'Z']) or (ch in ['0'..'9']) then
    begin
      Edit.SelText := Key;
      Key := #0
    end
  end
end;

procedure TfrmNewQSO.ShowOperator;
Begin
  if (Op<>UpperCase(cqrini.ReadString('Station', 'Call', ''))) and (Op<>'') then
    sbNewQSO.Panels[2].Text := cOperator+Op
  else
    sbNewQSO.Panels[2].Text := '';
end;

procedure TfrmNewQSO.NewLogSplash;
Begin
   with TfrmChangelog.Create(Application) do
    try
      ViewEmptylog;
      ShowModal
    finally
      Free
    end
end;
function TfrmNewQSO.RigCmd2DataMode(mode:String):String;
var
   DatCmd,
   n      :String;
Begin
   n:=IntToStr(frmTRXControl.cmbRig.ItemIndex);
   DatCmd :=  upcase(cqrini.ReadString('Band'+n, 'Datacmd', 'RTTY'));
   if (DatCmd = 'USB') or (DatCmd = 'LSB') then DatCmd := 'SSB'; //this is what RigControl responses

   if cqrini.ReadBool('Band'+n, 'UseReverse', False)  and (mode = DatCmd) then
            Result := cqrini.ReadString('Band'+n, 'Datamode', 'RTTY')
     else   Result := mode;
end;

end.


