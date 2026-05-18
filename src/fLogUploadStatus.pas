unit fLogUploadStatus;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs, StrUtils,
  Menus, ActnList, ExtCtrls, uColorMemo, lcltype,  dLogUpload, lclintf, lmessages;

const
  CRLF = #13#10;
type

  { TfrmLogUploadStatus }

  TfrmLogUploadStatus = class(TForm)
    acLogUploadStatus: TActionList;
    acClearMessages: TAction;
    acFontSettings: TAction;
    dlgFont: TFontDialog;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    mnuStatus: TMenuItem;
    pnlLogStatus: TPanel;
    tmrClose: TTimer;
    procedure acClearMessagesExecute(Sender: TObject);
    procedure acFontSettingsExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure tmrCloseTimer(Sender: TObject);
  private
    mFont     : TFont;
    mStatus   : TColorMemo;
    debug     : Boolean;
    procedure LoadFonts;
    procedure UploadDataToOnlineLogs(where : TWhereToUpload; ToAll : Boolean = False);
  public
    SyncMsg    : String;
    SyncColor  : TColor;
    SyncUpdate : String;
    thRunning  : Boolean;

    procedure UploadDataToHamQTH(ToAll : Boolean = False);
    procedure UploadDataToClubLog(ToAll : Boolean = False);
    procedure UploadDataToHrdLog(ToAll : Boolean = False);
    procedure UploadDataToUDPLog(ToAll : Boolean = False);
    procedure UploadDataToQrzLog(ToAll : Boolean = False);
    //procedure UploadDataToAll;
    procedure SyncUploadInformation;
    procedure DoAutoCleanup;
  end; 

type
  TUploadThread = class(TThread)
  private
    debug:Boolean;
    function CheckEnabledOnlineLogs : Boolean;
    function GetLogName : String;
    procedure RemoveQrzLogId(id:string);
    procedure AddQrzLogId(cqr_id,qrz_id:string);
    procedure ToMainThread(Message,Update : String);
  protected
    procedure Execute; override;
  public
    WhereToUpload : TWhereToUpload;
    ToAll         : Boolean;
  end;



var
  frmLogUploadStatus: TfrmLogUploadStatus;

implementation
{$R *.lfm}

uses dData, dUtils, uMyIni, fNewQSO;

function TUploadThread.CheckEnabledOnlineLogs : Boolean;
const
  C_IS_NOT_ENABLED = 'Upload to %s is not enabled! Go to Preferences and change settings.';
begin
  Result := True;
  case WhereToUpload of
    upHamQTH :  begin
                  if not cqrini.ReadBool('OnlineLog','HaUP',False) then
                  begin
                    if (not ToAll) then
                    begin
                      frmLogUploadStatus.SyncMsg := Format(C_IS_NOT_ENABLED,['HamQTH']);
                      Synchronize(@frmLogUploadStatus.SyncUploadInformation)
                    end;
                    Result := False
                  end
                end;
    upClubLog : begin
                  if not cqrini.ReadBool('OnlineLog','ClUP',False) then
                  begin
                    if (not ToAll) then
                    begin
                      frmLogUploadStatus.SyncMsg := Format(C_IS_NOT_ENABLED,['ClubLog']);
                      Synchronize(@frmLogUploadStatus.SyncUploadInformation)
                    end;
                    Result := False
                  end
                end;
    upHrdLog : begin
                  if not cqrini.ReadBool('OnlineLog','HrUP',False) then
                  begin
                    if (not ToAll) then
                    begin
                      frmLogUploadStatus.SyncMsg := Format(C_IS_NOT_ENABLED,['HRDLog']);
                      Synchronize(@frmLogUploadStatus.SyncUploadInformation)
                    end;
                    Result := False
                  end
                end;
    upUDPLog : begin
                  if not cqrini.ReadBool('OnlineLog','UdUP',False) then
                  begin
                    if (not ToAll) then
                    begin
                      frmLogUploadStatus.SyncMsg := Format(C_IS_NOT_ENABLED,['UDPLog']);
                      Synchronize(@frmLogUploadStatus.SyncUploadInformation)
                    end;
                    Result := False
                  end
                end;
    upQrzLog : begin
                  if not cqrini.ReadBool('OnlineLog','QrzUP',False) then
                  begin
                    if (not ToAll) then
                    begin
                      frmLogUploadStatus.SyncMsg := Format(C_IS_NOT_ENABLED,['QRZLog']);
                      Synchronize(@frmLogUploadStatus.SyncUploadInformation)
                    end;
                    Result := False
                  end
                end
  end //case
end;

procedure TUploadThread.RemoveQrzLogId(id:string);
Begin
  dmLogUpload.Q2.Close;
  if dmLogUpload.trQ2.Active then dmLogUpload.trQ2.RollBack;
  dmLogUpload.trQ2.StartTransaction;
  dmLogUpload.Q2.SQL.Text := 'delete from id_store where id_cqrlog_main='+id;
  if debug then
       writeln(dmLogUpload.Q2.SQL.Text );
  dmLogUpload.Q2.ExecSQL;
  dmLogUpload.trQ2.Commit;
end;

procedure TUploadThread.AddQrzLogId(cqr_id,qrz_id:string);
Begin
  dmLogUpload.Q2.Close;
  if dmLogUpload.trQ2.Active then dmLogUpload.trQ2.RollBack;
  dmLogUpload.trQ2.StartTransaction;
  dmLogUpload.Q2.SQL.Text := 'replace into id_store set qrz_logid='+QuotedStr(qrz_id)+',id_cqrlog_main='+cqr_id;
  if debug then
     writeln(dmLogUpload.Q2.SQL.Text );
  dmLogUpload.Q2.ExecSQL;
  dmLogUpload.trQ2.Commit;
  if debug then
    Writeln('QRZ LOGID saved: ', qrz_id, ' for id_cqrlog_main=', cqr_id)
end;


procedure TUploadThread.Execute;

// test upload with command console server (put 60006 to port settings):
//clear;while true; do printf '' | nc -lu localhost 60006; done

const
  C_SEL_UPLOAD_STATUS = 'select * from upload_status where logname=%s';
  C_SEL_LOG_CHANGES   = 'select * from log_changes where id > %d order by id';
  C_COUNT_CLUBLOG_ACTIONS = 'select ((select count(id) from log_changes where id > (select id_log_changes from upload_status where logname="ClubLog"))-'+
                                    '(select count(cmd) from log_changes where ((LOCATE("LogDONE",cmd)>0) or (LOCATE("HamQTHDONE",cmd)>0)) and '+
                                    '(id > (select id_log_changes from upload_status where logname="ClubLog")))) as act_count';

var
  data,
  tmpdata    : TStringList;
  tmp        : String;
  filepart   : Text;
  err        : String = '';
  LastId     : Integer = 0;
  Response   : String;
  ResultCode : Integer;
  Command    : String;
  UpSuccess  : Boolean = False;
  ErrorCode  : Integer = 0;
  qrzLogId   : String = '';
  cqrlogId   : String = '';
  AlreadyDel : Boolean = False;
  ClubCount  : integer;
  ClubBulk   : boolean;
  StreamFile : String;
  BulkResp1,
  BulkResp2  : String;


begin
   if dmData.DebugLevel < 0 then
        debug := ((abs(dmData.DebugLevel) and 256) = 256 )
       else
        debug := dmData.DebugLevel >= 1 ;

  data := TStringList.Create;
  tmpdata := TStringList.Create;
  StreamFile := dmUtils.GetHomeDirectory+'.config/cqrlog/Clublog_BulkUp.adi';
  try
    frmLogUploadStatus.thRunning := True;
    FreeOnTerminate := True;
    frmLogUploadStatus.SyncMsg    := '';
    frmLogUploadStatus.SyncUpdate := '';
    frmLogUploadStatus.SyncColor  := dmLogUpload.GetLogUploadColor(WhereToUpload);

    if not CheckEnabledOnlineLogs then
      exit;

    err :=  dmLogUpload.CheckUserUploadSettings(WhereToUpload);
    if (err<>'') then
    begin
      frmLogUploadStatus.SyncMsg := err;
      Synchronize(@frmLogUploadStatus.SyncUploadInformation);
      exit
    end;

    if dmLogUpload.trQ.Active then dmLogUpload.trQ.RollBack;
    dmLogUpload.trQ.StartTransaction;

    if (WhereToUpload=upClubLog) then
       begin
         dmLogUpload.Q.Close;
         dmLogUpload.Q.SQL.Text := C_COUNT_CLUBLOG_ACTIONS;
         dmLogUpload.Q.Open;
         ClubCount:=  dmLogUpload.Q.FieldByName('act_count').AsInteger;
         ClubBulk:=  (ClubCount > 3);  //How many actions cause putlogs.php usage
         dmLogUpload.Q.Close;
       end;

      //CLubBulk:=true; //debug for testing, comment out for production

     if debug and CLubBulk then
      writeln('Bulk upload:',ClubBulk,'    ',CLubCount,' changes');

      if dmLogUpload.trQ.Active then dmLogUpload.trQ.RollBack;
      dmLogUpload.trQ.StartTransaction;

  if not ClubBulk then   //not ClubBulk  --------------------------------------------------------------------------------------------------------
   Begin
    try try
      dmLogUpload.Q.Close;
      dmLogUpload.Q.SQL.Text := Format(C_SEL_UPLOAD_STATUS,[QuotedStr(GetLogName)]);
      dmLogUpload.Q.Open;
      LastId := dmLogUpload.Q.FieldByName('id_log_changes').AsInteger;

      dmLogUpload.Q.Close;
      dmLogUpload.Q.SQL.Text := Format(C_SEL_LOG_CHANGES,[LastId]);
      dmLogUpload.Q.Open;
      if dmLogUpload.Q.Fields[0].IsNull then
      begin
        ToMainThread('All QSO already uploaded','');
        exit
      end;
      while not dmLogUpload.Q.Eof do
      begin
        AlreadyDel := False;
        Command := dmLogUpload.Q.FieldByName('cmd').AsString;

        data.Clear;
        dmLogUpload.PrepareUserInfoHeader(WhereToUpload,data);

        case Command of
             'INSERT' :  begin
                            ToMainThread('Uploading '+dmLogUpload.Q.FieldByName('callsign').AsString,'');
                            dmLogUpload.PrepareInsertHeader(WhereToUpload,dmLogUpload.Q.Fields[0].AsInteger,dmLogUpload.Q.FieldByName('id_cqrlog_main').AsInteger,data);
                            UpSuccess := dmLogUpload.UploadLogData(WhereToUpload,Command,data,Response,ResultCode);
                         end; //INSERT

             'UPDATE' : begin
                          if (WhereToUpload=upQrzLog) then
                           Begin
                            ToMainThread('Deleting original '+dmLogUpload.Q.FieldByName('callsign').AsString,'');
                            dmLogUpload.PrepareDeleteHeader(WhereToUpload,dmLogUpload.Q.Fields[0].AsInteger,dmLogUpload.Q.FieldByName('id_cqrlog_main').AsInteger,data);
                            UpSuccess := dmLogUpload.UploadLogData(WhereToUpload,Command,data,Response,ResultCode);
                            if (ResultCode=200) and (pos('OK',Response)>0) then
                               Begin
                                 ToMainThread('','OK');
                                 AlreadyDel:=True;
                                 RemoveQrzLogId(dmLogUpload.Q.FieldByName('id_cqrlog_main').AsString);
                                 Sleep(500);
                                 ToMainThread('Uploading updated '+dmLogUpload.Q.FieldByName('callsign').AsString,'');
                                 data.Clear;
                                 dmLogUpload.PrepareUserInfoHeader(WhereToUpload,data);
                                 dmLogUpload.PrepareInsertHeader(WhereToUpload,dmLogUpload.Q.Fields[0].AsInteger,dmLogUpload.Q.FieldByName('id_cqrlog_main').AsInteger,data);
                                 UpSuccess := dmLogUpload.UploadLogData(WhereToUpload,Command,data,Response,ResultCode);
                               end
                             else
                               begin
                                 UpSuccess  := False;
                                 ErrorCode:=1;
                               end;
                           end
                          else
                           Begin
                              if (WhereToUpload=upUDPLog) then
                                  begin
                                    UpSuccess  := True;
                                    Response   := '';
                                    ResultCode := 200
                                  end
                              else if dmLogUpload.Q.FieldByName('upddeleted').asInteger = 1 then
                                  begin
                                    ToMainThread('Deleting original '+dmLogUpload.Q.FieldByName('old_callsign').AsString,'');
                                    dmLogUpload.PrepareDeleteHeader(WhereToUpload,dmLogUpload.Q.Fields[0].AsInteger,dmLogUpload.Q.FieldByName('id_cqrlog_main').AsInteger,data);

                                    if debug then
                                        begin
                                          Writeln('data.Text:');
                                          Writeln(data.Text)
                                        end;

                                    UpSuccess := dmLogUpload.UploadLogData(WhereToUpload,'DELETE',data,Response,ResultCode);

                                    if debug then
                                        begin
                                          Writeln('Response  : ',Response);
                                          Writeln('ResultCode: ',ResultCode)
                                        end
                                  end
                              else begin
                                ToMainThread('Already deleted '+dmLogUpload.Q.FieldByName('old_callsign').AsString,'');
                                UpSuccess  := True;
                                Response   := '';
                                ResultCode := 200
                              end;

                              if UpSuccess then
                                  begin
                                    Response := dmLogUpload.GetResultMessage(WhereToUpload,Response,ResultCode,ErrorCode);
                                    if (ErrorCode = 1) then
                                        begin
                                          ToMainThread('Could not delete original QSO data!','');
                                          Break
                                        end
                                    else if (ErrorCode = 2) then
                                        begin
                                          ToMainThread('Could not delete original QSO data. Reason: ' + Response,'');
                                        end
                                    else if (WhereToUpload<>upUDPLog) then
                                       ToMainThread('','OK');

                                    AlreadyDel := True;
                                    data.Clear;
                                    dmLogUpload.PrepareUserInfoHeader(WhereToUpload,data);
                                    ToMainThread('Uploading updated '+dmLogUpload.Q.FieldByName('callsign').AsString,'');
                                    dmLogUpload.PrepareInsertHeader(WhereToUpload,dmLogUpload.Q.Fields[0].AsInteger,dmLogUpload.Q.FieldByName('id_cqrlog_main').AsInteger,data);
                                    UpSuccess := dmLogUpload.UploadLogData(WhereToUpload,Command,data,Response,ResultCode)
                                  end
                              else
                                ToMainThread('Update failed! Check Internet connection','')
                           end;
                        end; //UPDATE


             'DELETE' : begin
                          ToMainThread('Deleting '+dmLogUpload.Q.FieldByName('old_callsign').AsString,'');
                          dmLogUpload.PrepareDeleteHeader(WhereToUpload,dmLogUpload.Q.Fields[0].AsInteger,dmLogUpload.Q.FieldByName('id_cqrlog_main').AsInteger,data);
                          UpSuccess := dmLogUpload.UploadLogData(WhereToUpload,Command,data,Response,ResultCode)
                        end;

             else
                         begin
                           if debug then
                              Writeln('Unknown command:',Command);
                           dmLogUpload.MarkOneAsUploaded(GetLogName,dmLogUpload.Q.FieldByName('id').AsInteger);
                           dmLogUpload.Q.Next;
                           Continue
                         end;

           end; //Case Command


       if debug then
        begin
          Writeln('Past Case Command:');
          Writeln('-----------');
          Writeln('data.Text:');
          Writeln(data.Text);
          Writeln('Response  : ',Response);
          Writeln('ResultCode: ',ResultCode);
          Writeln('ErrorCode: ',ErrorCode);
          Writeln('-----------')
        end;

       //parsing responses is a big mess. Online logs should provide clear list of all possible errorcodes
       //I guess this does not work in real life if errors happen

        Response := dmLogUpload.GetResultMessage(WhereToUpload,Response,ResultCode,ErrorCode);

        if UpSuccess then  //UpSucces means connect to HTTP server was ok
          begin
            if debug then
              begin
                Writeln('UpSUccess:');
                Writeln('-----------');
                Writeln('Response  : ',Response);
                Writeln('ResultCode: ',ResultCode);
                Writeln('ErrorCode: ',ErrorCode);
                Writeln('-----------')
              end;

           if (pos('OK',Response)>0) and (ErrorCode=0) then
             Begin
               if (WhereToUpload = upQrzLog) then
                Begin
                  cqrlogId := dmLogUpload.Q.FieldByName('id_cqrlog_main').AsString;
                  if (Command = 'INSERT') or (Command = 'UPDATE')then
                    begin
                      // Parse and save QRZ LOGID after successful INSERT
                      qrzLogId := ExtractWord(2,Response,[' ']);
                      AddQrzLogId(cqrlogId,qrzLogId);
                    end;
                if (Command = 'DELETE') then
                  begin
                   RemoveQrzLogId(cqrlogId);
                  end;
                end;
                ToMainThread('','OK');
                dmLogUpload.MarkOneAsUploaded(GetLogName,dmLogUpload.Q.FieldByName('id').AsInteger);
             end
           else
             Begin     //no success with HTTP connect
               ToMainThread('',Response);
               case ErrorCode of

                    1   :  Begin
                             if AlreadyDel then  //if cmd was update, delete was successful but new insert was not
                               begin
                                dmLogUpload.MarkAsUpDeleted(dmLogUpload.Q.Fields[0].AsInteger);
                                Break //cannot continue when fatal error
                               end
                              else
                               begin
                                Break;
                               end;
                             {     //this below is not a good idea! It does not let user to try again with same qso.
                             else
                               begin   //this will pass by QSO and forget it for new tries
                                 dmLogUpload.MarkOneAsUploaded(GetLogName,dmLogUpload.Q.FieldByName('id').AsInteger);
                                 ErrorCode := 0  //reset duplicate/warning codes so Done... is shown
                               end;
                               }
                           end;

                    2   :  Begin
                             dmLogUpload.MarkOneAsUploaded(GetLogName,dmLogUpload.Q.FieldByName('id').AsInteger);
                             ErrorCode:=0;
                           End;
                    3   :  Begin
                             Break;
                           End;
                    4   :  Begin
                             Break;
                           End;
                    5   :  Begin
                             Break;
                           End;

             end; //case ErrorCode
            end
          end   //UPsuccess  (network ok)
        else
            begin //not UPsuccess (network fail)
              if AlreadyDel then  //if cmd was update, delete was successful but new insert was not
                begin
                  dmLogUpload.MarkAsUpDeleted(dmLogUpload.Q.Fields[0].AsInteger)
                end;
              ToMainThread('Upload failed! Check Internet connection','');
              ToMainThread(Response,'');
              ErrorCode := 1;
              Break
            end;

        Sleep(800+Random(800)); //we don't want to make small DDOS attack to server
        dmLogUpload.Q.Next
      end; //while not dmLogUpload.Q.Eof do

        if (ErrorCode > 0) then
          ToMainThread('Failed - check reason! (maybe start with --debug=-256)','')
        else
          Begin
           ToMainThread('Done ...','');
           dmLogUpload.MarkAsUploaded(GetLogName);
          end;

      finally
        dmLogUpload.Q.Close;
        dmLogUpload.trQ.RollBack
      end;
      Sleep(500)
    except
      on E : Exception do
        Writeln(E.Message)
    end
   end //not ClubBulk --------------------------------------------------------------------------------------------------------
  else
   Begin  // ClubBulk --------------------------------------------------------------------------------------------------------
     try try
         dmLogUpload.Q.Close;
         dmLogUpload.Q.SQL.Text := Format(C_SEL_UPLOAD_STATUS,[QuotedStr(GetLogName)]);
         dmLogUpload.Q.Open;
         LastId := dmLogUpload.Q.FieldByName('id_log_changes').AsInteger;

         dmLogUpload.Q.Close;
         dmLogUpload.Q.SQL.Text := Format(C_SEL_LOG_CHANGES,[LastId]);
         dmLogUpload.Q.Open;
         if dmLogUpload.Q.Fields[0].IsNull then
         begin
           ToMainThread('All QSO already uploaded','');
           exit
         end;
         ToMainThread('Using bulk upload for '+IntToStr(CLubCount)+' changes','');
         tmpdata.clear;

         AssignFile(filepart,StreamFile);
         ReWrite(filepart);

         while not dmLogUpload.Q.Eof do
         begin
           if debug then
              writeln('id:',dmLogUpload.Q.FieldByName('id').AsString);
           AlreadyDel := False;
           Command := dmLogUpload.Q.FieldByName('cmd').AsString;

           data.Clear;

           if (pos('DONE',Command)>0) then
             begin
               if debug then
                  Writeln('xxxDONE not command:',Command);
               dmLogUpload.Q.Next;
               Continue
             end;

           if (Command = 'DELETE') then
                ToMainThread(Command+' '+dmLogUpload.Q.FieldByName('old_callsign').AsString,'')
              else
                ToMainThread(Command+' '+dmLogUpload.Q.FieldByName('callsign').AsString,'');

           case Command of
             'INSERT'   :  begin
                             dmLogUpload.PrepareInsertHeader(WhereToUpload,dmLogUpload.Q.Fields[0].AsInteger,dmLogUpload.Q.FieldByName('id_cqrlog_main').AsInteger,data);
                             tmp:=data[0];
                             Write(filepart,copy(tmp,pos('=<',tmp)+1,length(tmp))+CRLF);
                           end;

             'UPDATE'   : Begin
                            //we get better format from modified HamQth-delete
                            dmLogUpload.PrepareDeleteHeader(upHamQth,dmLogUpload.Q.Fields[0].AsInteger,dmLogUpload.Q.FieldByName('id_cqrlog_main').AsInteger,data);
                            tmp:=copy(data[0],6,length(data[0]));
                            tmp:=StringReplace(tmp,'OLD_','',[rfReplaceAll,rfIgnoreCase]);
                            tmp:=tmp+'<'+dmUtils.StringToADIF('QSLCALL',UpperCase(cqrini.ReadString('Station', 'Call', '')))+'<EOR>'+LineEnding; //station call as QSLCALL will delete qso
                            Write(filepart,tmp+CRLF);
                            AlreadyDel := true;
                            data.Clear;
                            dmLogUpload.PrepareInsertHeader(WhereToUpload,dmLogUpload.Q.Fields[0].AsInteger,dmLogUpload.Q.FieldByName('id_cqrlog_main').AsInteger,data);
                            tmp:=data[0];
                            Write(filepart,copy(tmp,pos('=<',tmp)+1,length(tmp))+CRLF);
                          end;

             'DELETE'   : Begin
                            //we get better format from modified HamQth-delete
                            dmLogUpload.PrepareDeleteHeader(upHamQth,dmLogUpload.Q.Fields[0].AsInteger,dmLogUpload.Q.FieldByName('id_cqrlog_main').AsInteger,data);
                            tmp:=copy(data[0],6,length(data[0]));
                            tmp:=StringReplace(tmp,'OLD_','',[rfReplaceAll,rfIgnoreCase]);
                            tmp:=tmp+'<'+dmUtils.StringToADIF('QSLCALL',UpperCase(cqrini.ReadString('Station', 'Call', '')))+'<EOR>'+LineEnding; //station call as QSLCALL will delete qso
                            Write(filepart,tmp+CRLF);
                            AlreadyDel := true;
                          end;

             else
                         begin
                           if debug then
                              Writeln('Unknown command:',Command);
                           dmLogUpload.Q.Next;
                           Continue
                         end;

           end;

         dmLogUpload.Q.Next
         end; //combine bulk while dmLogUpload.Q.Eof do

         close(filepart);
         tmpdata.Add('file='+StreamFile);
         dmLogUpload.PrepareUserInfoHeader(WhereToUpload,tmpdata);

         if debug then
         begin
           writeln('*Next to upload bulk data:',LineEnding,'tmpdata:',LineEnding,tmpdata.text);
         end;

         UpSuccess := dmLogUpload.UploadLogData(WhereToUpload,'BULK',tmpdata,Response,ResultCode);

         if debug then
           begin
             Writeln('-----------');
             Writeln('Response  : ',Response);
             Writeln('ResultCode: ',ResultCode);
             Writeln('-----------')
           end;

         if UpSuccess then
           begin
              BulkResp1 := trim(ExtractWord(1,Response,[':']));
              BulkResp2 := trim(ExtractWord(2,Response,[':']));
              Response := dmLogUpload.GetResultMessage(WhereToUpload,Response,ResultCode,ErrorCode);
              if debug then
               begin
                 Writeln('-----------');
                 Writeln('Response  : ',Response);
                 Writeln('ResultCode: ',ResultCode);
                 Writeln('ErrorCode: ',ErrorCode);
                 Writeln('-----------')
               end;
              if (pos('OK',Response)>0) and (ErrorCode=0) then
               ToMainThread('','OK')
             else
               begin
                ToMainThread(Response,'');
               end;
           end
          else
           begin //not UPsuccess (network fail)
              ToMainThread('Upload failed! Check Internet connection','');
              ErrorCode := 1;
           end;

         if (ErrorCode = 0) then
           Begin
            ToMainThread(BulkResp1,'');
            ToMainThread(BulkResp2,'');
            dmLogUpload.MarkAsUploaded(GetLogName);
            ToMainThread('Done ...','')
           end
         else
            ToMainThread('Failed - check reason with debug!','');

       finally
         dmLogUpload.Q.Close;
         dmLogUpload.trQ.RollBack
       end;
     except
       on E : Exception do
         Writeln(E.Message)
     end
   end;//ClubBulk --------------------------------------------------------------------------------------------------------

  finally
    FreeAndNil(tmpdata);
    FreeAndNil(data);
    frmLogUploadStatus.thRunning := False
  end
end;

function TUploadThread.GetLogName : String;
begin
  Result := '';
  case WhereToUpload of
    upHamQTH  : Result := C_HAMQTH;
    upClubLog : Result := C_CLUBLOG;
    upHrdlog  : Result := C_HRDLOG;
    upUDPLog  : Result := C_UDPLOG;
    upQrzLog  : Result := C_QRZLOG
  end //case
end;

procedure TUploadThread.ToMainThread(Message,Update : String);
begin
  Update:=StringReplace(Update,LineEnding,' ',[rfReplaceAll]);
  Message:=StringReplace(Message,LineEnding,' ',[rfReplaceAll]);
  frmLogUploadStatus.SyncUpdate := Update;
  frmLogUploadStatus.SyncMsg    := GetLogName + ': ' + Message;
  Synchronize(@frmLogUploadStatus.SyncUploadInformation);
  frmLogUploadStatus.SyncUpdate := '';
  frmLogUploadStatus.SyncMsg    := ''
end;

procedure TfrmLogUploadStatus.SyncUploadInformation;
var
  item : String;
  tmp  : LongInt;
  c    : TColor;
begin
  if debug then
   begin
        Writeln('SyncUpdate:',SyncUpdate);
        Writeln('SyncMsg   :',SyncMsg);
   end;
   if ((SyncUpdate<>'') or (SyncMsg<>'')) then
      tmrClose.Enabled:=False;

  if (SyncUpdate<>'') then
   begin
    //cti_vetu(var te:string;var bpi,bpo:Tcolor;var pom:longint;kam:longint):boolean;
    mStatus.ReadLine(item,c,c,tmp,mStatus.LastLineNumber);
    item := item + ' ... ' + SyncUpdate;
    if debug then
       Writeln('Item:',item);
    //prepis_vetu(te:string;bpi,bpo:Tcolor;pom:longint;kam:longint;msk:longint):boolean;
    mStatus.ReplaceLine(item,SyncColor,clWhite,0,mStatus.LastLineNumber,0)
   end
  else
   mStatus.AddLine(SyncMsg,SyncColor,clWhite,0);

  if (Pos('Done ...',SyncMsg)>0) or (Pos('All QSO already uploaded',SyncMsg)>0) then
    begin
     if cqrini.ReadBool('OnlineLog','CloseAfterUpload',False) then
       tmrClose.Enabled:=True; //tmr to prevent window close/open while several immediate uploads still running
    end

end;

procedure TfrmLogUploadStatus.acClearMessagesExecute(Sender: TObject);
begin
  mStatus.RemoveAllLines
end;

procedure TfrmLogUploadStatus.acFontSettingsExecute(Sender: TObject);
begin
  dlgFont.Font.Name := cqrini.ReadString('LogUploadStatus','FontName','Monospace');
  dlgFont.Font.Size := cqrini.ReadInteger('LogUploadStatus','FontSize',8);
  if dlgFont.Execute then
  begin
    cqrini.WriteString('LogUploadStatus','FontName',dlgFont.Font.Name);
    cqrini.WriteInteger('LogUploadStatus','FontSize',dlgFont.Font.Size);
    LoadFonts
  end
end;

procedure TfrmLogUploadStatus.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  if cqrini.ReadBool('OnlineLog','AutoClean',False) then
                                                    DoAutoCleanup;
  dmUtils.SaveWindowPos(Self);
end;

procedure TfrmLogUploadStatus.FormCloseQuery(Sender: TObject;
  var CanClose: boolean);
begin
  FreeAndNil(mStatus);
  FreeAndNil(mFont)
end;

procedure TfrmLogUploadStatus.FormCreate(Sender: TObject);
begin
  if dmData.DebugLevel < 0 then
        debug := ((abs(dmData.DebugLevel) and 256) = 256 )
       else
        debug := dmData.DebugLevel >= 1 ;
  thRunning := False
end;

procedure TfrmLogUploadStatus.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_ESCAPE   :begin
                  frmNewQSO.ReturnToNewQSO;
                  key := 0;
                  Exit;
                 end;
    VK_DELETE,
    VK_BACK    :begin
                  acClearMessagesExecute(nil);
                  key := 0;
                  Exit;
                 end;
  end;
end;

procedure TfrmLogUploadStatus.FormShow(Sender: TObject);
begin
  mFont              := TFont.Create;
  mStatus            := TColorMemo.Create(pnlLogStatus);
  mStatus.parent     := pnlLogStatus;
  mStatus.AutoScroll := True;
  mStatus.Align      := alClient;
  dmUtils.LoadWindowPos(Self);
  LoadFonts;
  tmrClose.Enabled:=False;
end;

procedure TfrmLogUploadStatus.tmrCloseTimer(Sender: TObject);
begin
  tmrClose.Enabled:=False;
  Self.Close;
end;

procedure TfrmLogUploadStatus.LoadFonts;
begin
  dmUtils.LoadFontSettings(self);
  mFont.Name := cqrini.ReadString('LogUploadStatus','FontName','Monospace');
  mFont.Size := cqrini.ReadInteger('LogUploadStatus','FontSize',8);
  mStatus.SetFont(mFont)
end;

procedure TfrmLogUploadStatus.UploadDataToOnlineLogs(where : TWhereToUpload; ToAll : Boolean = False);
var
  UploadThread : TUploadThread;
begin
  if thRunning then
  begin
    Application.MessageBox('Previous job is sill running, please try again later.','Info ...',mb_OK+mb_IconInformation)
  end
  else begin
    if not Showing then  //status window has to be visible when working
      Show;
    UploadThread := TUploadThread.Create(True);
    UploadThread.WhereToUpload := where;
    UploadThread.ToAll         := ToAll;
    UploadThread.Start
  end
end;

procedure TfrmLogUploadStatus.UploadDataToHamQTH(ToAll : Boolean = False);
begin
  UploadDataToOnlineLogs(upHamQTH, ToAll)
end;

procedure TfrmLogUploadStatus.UploadDataToClubLog(ToAll : Boolean = False);
begin
  UploadDataToOnlineLogs(upClubLog, ToAll)
end;

procedure TfrmLogUploadStatus.UploadDataToHrdLog(ToAll : Boolean = False);
begin
  UploadDataToOnlineLogs(upHrdLog, ToAll)
end;

procedure TfrmLogUploadStatus.UploadDataToUDPLog(ToAll : Boolean = False);
begin
  UploadDataToOnlineLogs(upUDPLog, ToAll)
end;

procedure TfrmLogUploadStatus.UploadDataToQrzLog(ToAll : Boolean = False);
begin
  UploadDataToOnlineLogs(upQrzLog, ToAll)
end;
Procedure TfrmLogUploadStatus.DoAutoCleanup;        //makes auto cleanup to table log_changes if all selected OnlineLogs are completed and user has selected autoclean
Var
  p       : integer;

Function Pending(where : String):integer;
Begin
  Result:=0;
  dmLogUpload.Q2.Close;
  if dmLogUpload.trQ2.Active then dmLogUpload.trQ2.RollBack;
  dmLogUpload.trQ2.StartTransaction;
  dmLogUpload.Q2.SQL.Text :=  'select (select max(id) from log_changes)-(select id_log_changes  from upload_status where logname='+QuotedStr(where)+') as A';
  if debug then
       writeln(dmLogUpload.Q2.SQL.Text );
  dmLogUpload.Q2.Open;
  Result:=dmLogUpload.Q2.Fields[0].AsInteger;
  dmLogUpload.Q2.Close;
  dmLogUpload.trQ2.Rollback;
end;

Begin
     p:=0;
     if cqrini.ReadBool('OnlineLog','HaUP',False)  then
                                                   p:=p+Pending('HamQTH');
     if cqrini.ReadBool('OnlineLog','ClUP',False)  then
                                                   p:=p+Pending('ClubLog');
     if cqrini.ReadBool('OnlineLog','HrUP',False)  then
                                                   p:=p+Pending('HRDLog');
     if cqrini.ReadBool('OnlineLog','UdUP',False)  then
                                                   p:=p+Pending('UDPLog');
     if cqrini.ReadBool('OnlineLog','QrzUP',False) then
                                                   p:=p+Pending('QRZLog');

     if (p=0) then
              dmLogUpload.MarkAsUploadedToAllOnlineLogs;  //this cleans table log_changes but keeps it's last ID value.

end;

end.

