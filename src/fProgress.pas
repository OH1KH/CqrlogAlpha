unit fProgress;

//--------------------------------------------------------------
//these procedures do US states download and cqrlog_common.states table update
//--------------------------------------------------------------


{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, ExtCtrls,
  StdCtrls, Types, process, LCLType, FileUtil, StrUtils;

type

  { TfrmProgress }

  TfrmProgress = class(TForm)
    lblInfo: TLabel;
    p: TProgressBar;
    tmrUSDB: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tmrUSDBTimer(Sender: TObject);

  private
   DPstarted : integer;     //fcc states download process status
   DProcess  : TProcess;
   tfIn      : TextFile;
   C_MYZIP   : String;

   procedure USDBdownLoadInit;
   procedure CloseUSDBProcess;
   procedure USDBProcessFailed;
   procedure DoStep(info:string = '');
   procedure DoInit(max,step:integer);
   procedure DoJump(i:integer);
   procedure DoPos(i:integer);
   procedure DoPros(i:integer);

  public
   procedure UpdateUSDBState(SourceFile:String);
   procedure BuildUSDBState;
  end;

const

  C_URL = 'ftp://ftp.w1nr.net/usdbraw.gz';

var
  frmProgress: TfrmProgress;
  i:integer;
  LocalDbg : boolean;

implementation
{$R *.lfm}
{ TfrmProgress }

uses fNewQSO, dData, dUtils, fMonWsjtx, uMyIni;


procedure TfrmProgress.FormShow(Sender: TObject);
begin
  Self.ShowOnTop;
  //set debug rules for this form
  LocalDbg := dmData.DebugLevel >= 1 ;
  if dmData.DebugLevel < 0 then
        LocalDbg :=  LocalDbg or ((abs(dmData.DebugLevel) and 4) = 4 );
  localDbg:=true;
end;

procedure TfrmProgress.FormCreate(Sender: TObject);
begin
  Self.Hide;
end;

procedure TfrmProgress.DoStep(info:string = '');
begin
  lblInfo.Caption:=info;
  p.StepIt;
  repaint;
  Application.ProcessMessages;
  //Self.ShowOnTop;
end;
procedure TfrmProgress.DoJump(i:integer);
begin
  p.Position:=p.Position + i;
  repaint;
  Application.ProcessMessages;
  //Self.ShowOnTop;
end;
procedure TfrmProgress.DoPos(i:integer);
begin
  p.Position:= i;
  repaint;
  Application.ProcessMessages;
  //Self.ShowOnTop;
end;
procedure TfrmProgress.DoPros(i:integer);
begin
  p.Position:= (p.max * i)  div 100;
  repaint;
  Application.ProcessMessages;
  //Self.ShowOnTop;
end;
procedure TfrmProgress.DoInit(max,step:integer);
begin
  p.position:=0;
  p.max:=max;
  p.step:=step;
end;

procedure TfrmProgress.tmrUSDBTimer(Sender: TObject);
Var
  sz : integer;
begin
   tmrUSDB.Enabled:=False;
   frmMonWsjtx.chkUState.Enabled:= false;
          //if DProcess <> nil then if LocalDbg then Writeln('Dprocess running');
case  DPstarted of
          0:exit;

          1: begin
             if FileExists(dmData.HomeDir+C_MYZIP) then
              Begin
                sz:=FileSize(dmData.HomeDir+C_MYZIP) div 1000000;
                lblInfo.Caption:= 'Loading '+IntToStr(sz)+'M';
                DoPos(sz);
                Application.ProcessMessages;
                if LocalDbg then Writeln('Loading file');
                tmrUSDB.Enabled:=True;
              end
          end;

          2: begin
               if LocalDbg then Writeln('Doing gunzip ... ');
               lblInfo.Caption:= 'Gunzip ...';
               DoJump(1);
               Application.ProcessMessages;
               tmrUSDB.Enabled:=True;
              end;

          3: begin
               if LocalDbg then Writeln('Doing DB populate ... ');
               tmrUSDB.Enabled:=True;
             end;


          4: begin
               if LocalDbg then Writeln('DPstarted = 4');
               tmrUSDB.Enabled:=False;
               lblInfo.Caption:= 'Done!';
               for sz:=0 to 100 do
               Begin
                 Self.ShowOnTop;
                 sleep(10);
                 Application.ProcessMessages;
               end;
               CloseUSDBProcess;
              end;
          end;
end;

procedure  TfrmProgress.BuildUSDBState;
var
  s,t,
  tmp  : string;
  r,b  : longint;
  l    : integer;
begin
  r:=0; b:=0; l:=0;
  if not FileExists(dmData.HomeDir+C_STATE_SOURCE) then
   Begin  //failed download
    frmMonWsjtx.CanCloseUSDBProcess:=true;
    CloseUSDBProcess;
    frmMonWsjtx.chkUState.Checked := false;
    exit;
   end;

  Self.ShowOnTop;
  frmMonWsjtx.CanCloseUSDBProcess:=false;
  DPstarted:=3;
  tmrUSDB.Enabled:=True;
  DoInit(350,1);
  DoStep('Writing table takes a while...');
  Application.ProcessMessages;
  sleep(100);
  AssignFile(tfIn,dmData.HomeDir+C_STATE_SOURCE);
   try
    reset(tfIn);
    if LocalDbg then Writeln('Reading ',dmData.HomeDir+C_STATE_SOURCE,' ...');

    try
        try
         //drop old table here
          dmData.Qstate.SQL.Text := 'DROP INDEX IF EXISTS callsign ON cqrlog_common.states';
          if LocalDbg then Writeln(dmData.Qstate.SQL.Text);
          dmData.Qstate.ExecSQL;
          dmData.Qstate.SQL.Text := 'truncate table cqrlog_common.states';
          if LocalDbg then Writeln(dmData.Qstate.SQL.Text);
          dmData.Qstate.ExecSQL;
          dmData.Qstate.SQL.Text := 'CREATE UNIQUE INDEX callsign ON cqrlog_common.states(callsign)';
          if LocalDbg then Writeln(dmData.Qstate.SQL.Text);
          dmData.Qstate.ExecSQL;
          dmData.trQstate.Commit;
        except
         on E : Exception do
                        begin
                          Application.MessageBox(PChar('State table cleanup crashed with this error:'+LineEnding+E.Message),'Error',mb_ok+mb_IconError);
                          USDBProcessFailed;
                          exit;
                        end
        end
    finally
      if dmData.trQstate.Active then dmData.trQstate.Rollback;
    end;
    //unfortunately W1NR data has same duplicates as FCC's file l_amat.zip. We need use "replace" not "insert"

    //if you want also qth to database table release below and comment out other one
    //Adding also qth to table will increase loading time abt 20%
     //tmp := 'replace into cqrlog_common.states (callsign,call_qth,call_state) values ';

    //just callsign and state to table
     tmp := 'replace into cqrlog_common.states (callsign,call_state) values ';

    try
     while not eof(tfIn) do
     begin
      readln(tfIn, s);
      if s<>'' then
      begin
        //if you want also qth to database table release this below and comment out other one
        {
       //unfortunately qth names in file may contain ' or " chars, replace them with space
        s:=StringReplace(s,#39,' ',[rfReplaceAll]);
        s:=StringReplace(s,'"',' ',[rfReplaceAll]);
        s:=StringReplace(s,'|',#39+#44+#39,[rfReplaceAll]);
        try
           tmp := dmData.Qstate.SQL.Text
                                    +'('+#39+s+#39+')';
          }

         //{
        //just callsign and state to table
        try
           tmp := tmp +'('+#39+ExtractWord(1,s,['|'])+#39+','+#39+ExtractWord(3,s,['|'])+#39+')';
         //}

          inc(r);inc(l);
          if l<500 then
                      Begin
                        tmp := tmp +',';
                      end
                else
                      Begin
                        l:=0;
                        dmData.Qstate.SQL.Text := tmp;
                        dmData.Qstate.ExecSQL;
                        //if you want also qth to database table release below and comment out other one
                        //tmp := 'replace into cqrlog_common.states (callsign,call_qth,call_state) values ';
                        dmData.trQstate.Commit;
                        if dmData.trQstate.Active then dmData.trQstate.Rollback;
                        //just callsign and state to table
                        tmp := 'replace into cqrlog_common.states (callsign,call_state) values ';
                        Application.ProcessMessages;
                      end;

        except
          on E : Exception do
          begin
            Application.MessageBox(PChar('Database cqrlog_common.states upgrade crashed with this error:'+LineEnding+E.Message),'Error',mb_ok+mb_IconError);
            if LocalDbg then Writeln(dmData.Qstate.SQL.Text);
            USDBProcessFailed;
            exit;
          end
        end
       end;  // if s
       if r > 4999 then
                    Begin
                     b:=b+r;
                     r:=0;
                     DoStep(IntToStr(b)+' lines read...');
                    end;
      end;   //while
      finally
            if l>0 then
                Begin
                 tmp := copy(tmp,1,length(tmp)-1); //remove last comma
                 if LocalDbg then Writeln('Short block file end:'+lineEnding+tmp);
                 dmData.Qstate.SQL.Text:=tmp;
                 dmData.Qstate.ExecSQL;
                 dmData.trQstate.Commit;
                end
              else
                Begin
                  tmp:='';
                  if LocalDbg then Writeln('Even file end',tmp);
                  dmData.trQstate.Commit;
                end;
            if dmData.trQstate.Active then dmData.trQstate.Rollback;
         end
   except
    on E: EInOutError do
     writeln('File handling error occurred. Details: ', E.Message);
  end;
  frmMonWsjtx.CanCloseUSDBProcess:=true;
  DPstarted:=4;
end;

procedure  TfrmProgress.USDBdownLoadInit;
var
  f   :textfile;
  begin
    frmMonWsjtx.CanCloseUSDBProcess:=false;
    USDB_Address:=cqrini.ReadString('MonWsjtx', 'USDB_Addr', C_URL);

    //wget -qN ftp://ftp.w1nr.net/usdbraw.gz                              -> needed programs: wget and gunzip
    //You can still use also FCC's l_amat.zip (lot bigger download)       -> needed programs: wget, unzip and awk
     ///  https://data.fcc.gov/download/pub/uls/complete/l_amat.zip

    //NOTE: Fedora 40 uses wget symlink to wget2 program. wget2 does not allow prefix "ftp://" on url.
    //      Fortunately "old" wget works also without it,  so we just drop prefix. 2024-12-09 OH1KH

     case QuestionDlg ('Caption','Use download address:'+
                   LineEnding+'ftp.w1nr.net/usdbraw.gz'+ LineEnding
                   +'  (~9M, fast to download)'+ LineEnding
                   +'https://data.fcc.gov/download/pub/uls/complete/l_amat.zip' + LineEnding
                   +'  (~160M, may be more up to date)'
                   ,mtCustom,[20,'w1nr.net', 21, 'fcc.gov',22,'Manual input','IsDefault'],'') of
      20: USDB_Address:= 'ftp.w1nr.net/usdbraw.gz';
      21: USDB_Address:= 'https://data.fcc.gov/download/pub/uls/complete/l_amat.zip';
      22: if not InputQuery('Download address check','Address suggestions:'+
                   LineEnding+'ftp.w1nr.net/usdbraw.gz (~9M, fast to download)'+
                   LineEnding+'https://data.fcc.gov/download/pub/uls/complete/l_amat.zip (~160M, may be more up to date)', USDB_Address) then
                      begin
                       USDBProcessFailed;
                       exit;
                     end;
     end;


    cqrini.WriteString('MonWsjtx', 'USDB_Addr',USDB_Address);
    if LocalDbg then
                begin
                 Writeln('Saved USDB_Address:',USDB_Address);
                 Writeln('USDBdownLoadInit start');
                end;
    Self.Show;
    if pos('l_amat.zip',USDB_Address)>0 then   //FFC data needs different process
                  begin
                     DoInit(160,1);
                     C_MYZIP := 'ctyfiles/l_amat.zip';
                  end
                else
                  begin
                     DoInit(10,1);
                     C_MYZIP := 'ctyfiles/usdbraw.gz';
                  end;

    DoJump(0);
    Application.ProcessMessages;


    DPstarted:=1;
    tmrUSDB.Enabled:=True;

    DProcess := TProcess.Create(nil);

    try
     try
      if LocalDbg then Writeln('Next DProcess run wget');
      DProcess.Executable  := 'wget';
      DProcess.Parameters.Add('-qN');
      DProcess.Parameters.Add('--connect-timeout=10');
      DProcess.Parameters.Add('--dns-timeout=10');
      DProcess.Parameters.Add('--read-timeout=60');
      DProcess.Parameters.Add('--tries=1');
      DProcess.Parameters.Add('-O');
      DProcess.Parameters.Add(dmData.HomeDir+C_MYZIP);
      DProcess.Parameters.Add(trim(USDB_Address));
      if LocalDbg then Writeln('DProcess.Executable: ',DProcess.Executable,' Parameters: ',DProcess.Parameters.Text);
      DProcess.Execute;
      while DProcess.Running do
         Begin
            Application.ProcessMessages;
            sleep(1000);
         end;
    except
    on E :EExternal do
     begin
      ShowMessage('Error Details: '+E.Message);
      USDBProcessFailed;
      exit;
     end;
    end;
   finally
    FreeAndNil(Dprocess);
   end;


    if not FileExists(dmData.HomeDir+C_MYZIP) then //download failed
      Begin
        USDBProcessFailed;
        exit;
      end;

    if LocalDbg then Writeln('Next run gunzip');
    DProcess := TProcess.Create(nil);
    DPstarted:=2;
    DoPos(0);

    try
     try
      if pos('l_amat.zip',USDB_Address)>0 then   //FFC data needs different process
         DProcess.Executable  := 'unzip'
      else
         DProcess.Executable  := 'gunzip';
      if pos('l_amat.zip',USDB_Address)>0 then   //FFC data needs different process
         DProcess.Parameters.Add('-o');
      DProcess.Parameters.Add(dmData.HomeDir+C_MYZIP);
      if pos('l_amat.zip',USDB_Address)>0 then   //FFC data needs different process
        begin
         DProcess.Parameters.Add('EN.dat');
         DProcess.Parameters.Add('-d');
         DProcess.Parameters.Add(dmData.HomeDir+'ctyfiles');
        end;
      if LocalDbg then Writeln('DProcess.Executable: ',DProcess.Executable,' Parameters: ',DProcess.Parameters.Text);
      DProcess.Execute;
      while DProcess.Running do
            Application.ProcessMessages;
     finally
      FreeAndNil(Dprocess);
     end;
    except
    on E :EExternal do
     writeln('Error Details: ', E.Message);
    end;

    if pos('l_amat.zip',USDB_Address)>0 then   //FFC data needs different process
     begin
      DProcess := TProcess.Create(nil);
      try
       try
        DProcess.Executable  := '/bin/bash';
        DProcess.Parameters.Add('-c');
        DProcess.Parameters.Add('awk -F"|" '+#39+'{print$5"|"$17"|"$18}'+#39+' < '+dmData.HomeDir+'ctyfiles/EN.dat >'+dmData.HomeDir+'ctyfiles/usdbraw');
        //DProcess.Parameters.Add(#39+'{print$5"|"$17"|"$18}'+#39);
        //DProcess.Parameters.Add(dmData.HomeDir+'ctyfiles/EN.dat');
        //DProcess.Parameters.Add('>');
        //DProcess.Parameters.Add(dmData.HomeDir+'ctyfiles/usdbraw');

        if LocalDbg then Writeln('DProcess.Executable: ',DProcess.Executable,' Parameters: ',DProcess.Parameters.Text);
        DProcess.Execute;
        while DProcess.Running do
              Application.ProcessMessages;
       finally
        FreeAndNil(Dprocess);
       end;
      except
      on E :EExternal do
       writeln('Error Details: ', E.Message);
      end;
     end;

   Self.Hide;
   Application.ProcessMessages;
   frmMonWsjtx.CanCloseUSDBProcess:=true;
end;
procedure  TfrmProgress.CloseUSDBProcess;
begin
  //here force close threads and others
  if DProcess<>nil then FreeAndNil(DProcess);
       try
         CloseFile(tfin);
       finally
       end;
  DPstarted:=0;
  tmrUSDB.Enabled:=False;
  frmMonWsjtx.chkUState.Enabled:=true;
  frmMonWsjtx.CanCloseUSDBProcess:= true;
  Application.ProcessMessages;
  Self.Close;
end;
procedure  TfrmProgress.USDBProcessFailed;
begin
  frmMonWsjtx.CanCloseUSDBProcess:=true;
  Self.Hide;
  DPstarted:=0;
  tmrUSDB.Enabled:=False;
  frmMonWsjtx.chkUState.Checked:=False;
end;
procedure TfrmProgress.UpdateUSDBState(SourceFile:String);
Begin
   if FileExists(SourceFile) then DeleteFile(SourceFile);
   USDBdownLoadInit;
   if not FileExists(SourceFile) then  //when back here should have new SourceFile
    begin
      frmMonWsjtx.chkUState.Checked := false;
      exit;
    end
    else //populate database
     BuildUSDBState;
end;


end.

