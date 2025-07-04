unit fDatabaseUpdate;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ComCtrls,
  ExtCtrls, StdCtrls, httpsend, inifiles, process, lcltype;

type

  { TfrmDatabaseUpdate }

  TfrmDatabaseUpdate = class(TForm)
    btnCancel        : TButton;
    pnlQRZ           : TPanel;
    tmrQRZ           : TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure tmrQRZTimer(Sender: TObject);
  private
    found             : boolean; //found interrupted previous update's last id
    procedure QRZupdate;
  public
    id_cqrlog_main    : LongInt;
    Selected          : boolean;
    NameFromLog       : Boolean;
    procedure SynCallBook;
  end;

type
  TQRZThread = class(TThread)
  protected
    procedure Execute; override;
  end;


var
  frmDatabaseUpdate: TfrmDatabaseUpdate;

implementation
{$R *.lfm}

{ TfrmDatabaseUpdate }
uses dUtils, dData, uMyIni, fMain;

var
  CanCancelAtStart  : boolean;
  CancelUpdate: boolean;
  CloseW:  boolean;

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
  c_ErrMsg    : String;
  c_SyncText  : String;
  c_waz       : String;
  c_itu       : String;
  c_dok       : String;
  c_running   : Boolean = False;

procedure TQRZThread.Execute;
var
  dbCall    : string = '';
  dbName    : string = '';
  dbQTH     : string = '';
  dbQSLVia  : string = '';
  dbCounty  : string = '';
  dbAward   : string = '';
  dbDXCC    : string = '';
  dbGrid    : string = '';
  dbId      : int64 = 0;
  dbState   : string = '';
  StoreTo   : string = '';
  dbRemQSO  : string = '';
  dbIota    : String = '';
  dbWAZ     : String = '';
  dbITU     : String = '';
  IgnoreQRZ : boolean = False;
  MvToRem   : boolean = True;
  County    : String;
  tmp       : String;
  CallCount : integer;

  procedure DoUpgrade;
  begin
    dbCall   := dmData.qCallBook.FieldByName('callsign').AsString;
    dbName   := dmData.qCallBook.FieldByName('name').AsString;
    dbQTH    := dmData.qCallBook.FieldByName('qth').AsString;
    dbQSLVia := dmData.qCallBook.FieldByName('qsl_via').AsString;
    dbCounty := dmData.qCallBook.FieldByName('county').AsString;
    dbAward  := dmData.qCallBook.FieldByName('award').AsString;
    dbId     := dmData.qCallBook.FieldByName('id_cqrlog_main').AsInteger;
    dbState  := dmData.qCallBook.FieldByName('state').AsString;
    dbRemQSO := dmData.qCallBook.FieldByName('remarks').AsString;
    dbGrid   := dmData.qCallBook.FieldByName('loc').AsString;
    dbIota   := dmData.qCallBook.FieldByName('iota').AsString;
    dbWAZ    := dmData.qCallbook.FieldByName('waz').AsString;
    dbITU    := dmdata.qCallbook.FieldByName('itu').AsString;

    c_nick    := '';
    c_qth     := '';
    c_address := '';
    c_zip     := '';
    c_grid    := '';
    c_state   := '';
    c_county  := '';
    c_qsl     := '';
    c_waz     := '';
    c_itu     := '';
    c_dok     := '';
    c_ErrMsg  := '';

    if frmDatabaseUpdate.NameFromLog then
    begin
      dmData.Q.Close;
      dmData.Q.SQL.Text := 'select max(id_cqrlog_main),callsign,name from cqrlog_main where name <> '+QuotedStr('')+
                           ' and callsign = '+QuotedStr(dbCall)+' group by callsign,name';
      if dmData.DebugLevel>=1 then Writeln(dmData.Q.SQL.Text);
      dmData.trQ.StartTransaction;
      dmData.Q.Open();
      dbName := dmData.Q.Fields[2].AsString;
      dmData.trQ.RollBack
    end;

    if dmData.DebugLevel >= 1 then
    begin
      Writeln('----');
      Writeln('dbCall:   ', dbCall);
      Writeln('dbName:   ', dbName);
      Writeln('dbQTH:    ', dbQTH);
      Writeln('dbQSLVIA: ', dbQSLVia);
      Writeln('dbAward:  ', trim(dbAward));
      Writeln('County:   ', c_county);
      Writeln('dbCounty: ', dbCounty);
      Writeln('dbState:  ', dbState);
      Writeln('dbRemQSO: ', dbRemQSO);
      Writeln('dbGrid:   ', dbGrid);
      Writeln('dbIota:   ', dbIota);
      Writeln('----');
    end;

    if CancelUpdate then
    begin
      cqrini.WriteInteger('CallBook', 'LastId', dbId);
      CloseW := True;
      Synchronize(@frmDatabaseUpdate.SynCallBook);
    end;

    c_ErrMsg   := '';
    c_SyncText := IntToStr(CallCount)+': '+dbCall;
    Synchronize(@frmDatabaseUpdate.SynCallBook);
    c_callsign := dmUtils.GetIDCall(dbCall);
    dmUtils.GetCallBookData(c_callsign,c_nick,c_qth,c_address,c_zip,c_grid,c_state,c_county,c_qsl,c_iota,c_waz,c_itu,c_dok,c_ErrMsg);

    if c_ErrMsg <> '' then
    begin
      Writeln(c_ErrMsg)
    end;

    if (dbQTH = '') then
      dbQTH := c_qth;

    if (dbState = '') and (c_state <> '') then
    begin
      dbState := dmUtils.GetShortState(c_state);
      if (dbCounty = '') and (c_county <> '') then
        dbCounty := dbState + ',' + c_county;
    end;
    //After ARRL DX we have dbState field filled but not county
    if (dbState <> '') and (dbCounty = '') and (c_state <> '') then
      dbCounty := dmUtils.GetShortState(c_state)+','+c_county;

    if (dbGrid = '') and dmUtils.IsLocOK(c_grid) then
      dbGrid := c_grid;

    if (dbIota = '') and dmUtils.IsIOTAOK(c_iota) then
      dbIota := c_iota;

    if c_zip <> '' then
    begin
      County := dmData.FindCounty1(c_zip, dbDXCC, StoreTo);
      if County <> '' then
      begin
        if (StoreTo = 'county') and (dbCounty = '') then
          dbCounty := County
        else if (StoreTo = 'QTH') and (dbQTH = '') then
          dbQTH := County
        else if (StoreTo = 'award') and (dbAward = '') then
          dbAward := County
        else if (StoreTo = 'state') and (dbState = '') then
          dbState := County;
      end;

      County := dmData.FindCounty2(c_zip, dbDXCC, StoreTo);
      if County <> '' then
      begin
        if (StoreTo = 'county') and (dbCounty = '') then
          dbCounty := County
        else if (StoreTo = 'QTH') and (dbQTH = '') then
          dbQTH := County
        else if (StoreTo = 'award') and (dbAward = '') then
          dbAward := County
        else if (StoreTo = 'state') and (dbState = '') then
          dbState := County;
      end;

      County := dmData.FindCounty3(c_zip, dbDXCC, StoreTo);
      if County <> '' then
      begin
        if (StoreTo = 'county') and (dbCounty = '') then
          dbCounty := County
        else if (StoreTo = 'QTH') and (dbQTH = '') then
          dbQTH := County
        else if (StoreTo = 'award') and (dbAward = '') then
          dbAward := County
        else if (StoreTo = 'state') and (dbState = '') then
          dbState := County;
      end;
    end;
    if dbName = '' then
      dbName := c_nick;

    if (dbQSLVia = '') and (not IgnoreQRZ) then
    begin
      dbRemQSO := Trim(dbRemQSO);
      c_qsl    := dmUtils.GetQSLVia(c_qsl);
      c_qsl    := Trim(c_qsl);
      if dmUtils.IsQSLViaValid(c_qsl) then
        dbQSLVia := dmUtils.CallTrim(c_qsl)
      else
      begin
        if c_qsl <> '' then
        begin
          if MvToRem then
            if dbRemQSO = '' then
              dbRemQSO := c_qsl
            else
              dbRemQSO := dbRemQSO + ', ' + c_qsl
        end
      end
    end;

    dbName   := copy(dbName, 1, 40);
    dbQTH    := copy(dbQTH, 1, 60);
    dbQSLVia := copy(dbQSLVia, 1, 30);
    dbAward  := copy(dbAward, 1, 50);
    dbCounty := copy(dbCounty, 1, 30);
    dbState  := copy(dbState, 1, 4);
    dbRemQSO := copy(dbRemQSO, 1, 200);

    if (c_waz<>'') then
      dbWAZ := c_waz;

    if (c_itu<>'') then
      dbITU := c_itu;

    tmp:='';
    if   dbName      <>'' then tmp:='name='+QuotedStr(dbName);
    if   dbQTH       <>'' then tmp:=tmp+',qth='+ QuotedStr(dbQTH);
    if   dbQSLVia    <>'' then tmp:=tmp+',qsl_via='+ QuotedStr(dbQSLVia);
    if   dbCounty    <>'' then tmp:=tmp+',county='+ QuotedStr(dbCounty);
    if   dbAward     <>'' then tmp:=tmp+',award='+ QuotedStr(dbAward);
    if   dbState     <>'' then tmp:=tmp+',state ='+ QuotedStr(dbState);
    if   dbRemQSO    <>'' then tmp:=tmp+',remarks='+ QuotedStr(dbRemQSO);
    if   dbIota      <>'' then tmp:=tmp+',iota='+QuotedStr(dbIota);
    if   dbWAZ       <>'' then tmp:=tmp+',waz='+QuotedStr(dbWAZ);
    if   dbITU       <>'' then tmp:=tmp+',itu='+QuotedStr(dbITU);

    if tmp<>'' then
     Begin
      if tmp[1]=',' then tmp:=copy(tmp,2,length(tmp));  //starts always without comma
      dmData.Q1.SQL.Text := 'update cqrlog_main set '
      +tmp
      +' where id_cqrlog_main = ' + IntToStr(dbId);
      dmData.trQ1.StartTransaction;
      if dmData.DebugLevel >= 1 then
          Writeln(dmData.Q1.SQL.Text);
      dmData.Q1.ExecSQL;
      dmData.trQ1.Commit;
      dmData.trQ1.Rollback;
    end;
  end;

begin
  FreeOnTerminate:= True;
  c_running := True;
  CallCount:=0;
  try
    c_nick     := '';
    c_qth      := '';
    c_address  := '';
    c_zip      := '';
    c_grid     := '';
    c_state    := '';
    c_county   := '';
    c_qsl      := '';
    c_ErrMsg   := '';
    IgnoreQRZ  := cqrini.ReadBool('NewQSO', 'IgnoreQRZ', False);
    MvToRem    := cqrini.ReadBool('NewQSO', 'MvToRem', True);
    c_SyncText := 'Working ...';
    Synchronize(@frmDatabaseUpdate.SynCallBook);
    sleep(5100);
    while not dmData.qCallBook.EOF do
    begin
      inc(CallCount);
      DoUpgrade;
      Sleep(1000);
      dmData.qCallBook.Next
    end;
    CloseW := True;
    c_SyncText := 'Done!';
    Synchronize(@frmDatabaseUpdate.SynCallBook)
  finally
    c_running := False
  end
end;

procedure TfrmDatabaseUpdate.FormCreate(Sender: TObject);
begin
  c_running := False;
  found:=false;
end;

procedure TfrmDatabaseUpdate.FormDestroy(Sender: TObject);
begin
  dmData.qCallBook.Close;
  dmData.qCallBook.SQL.Clear;
end;

procedure TfrmDatabaseUpdate.FormShow(Sender: TObject);
begin
  CloseW := False;
  CancelUpdate := False;
  CanCancelAtStart:=false;
  dmUtils.LoadFontSettings(self);
  // I have to do this horrible workaround because sometimes window after show
  // doesn't get focus. Why??
  if cqrini.ReadBool('Callbook','HamQTH',True) then
    Caption := 'Updating data from HamQTH.com'
  else
    Caption := 'Updating data from qrz.com';

   if Selected then
       pnlQRZ.Caption := 'Updating selected QSOs'
      else
        if dmData.IsFilter then
          pnlQRZ.Caption := 'Updating filtered QSOs'
         else
             Begin
              pnlQRZ.Caption := 'Really update ALL '+IntToStr(dmData.GetQSOCount)+' QSOs?';
              tmrQRZ.Interval:=5000;
              CanCancelAtStart:=True;
             end;
  pnlQRZ.Repaint;
  tmrQRZ.Enabled := True;
end;

procedure TfrmDatabaseUpdate.btnCancelClick(Sender: TObject);
begin
  if CanCancelAtStart then
   Begin
      c_running := False;
      dmData.RefreshMainDatabase();
      Self.close;
   end
  else
   CancelUpdate := True;
end;

procedure TfrmDatabaseUpdate.tmrQRZTimer(Sender: TObject);
begin
  tmrQRZ.Enabled := False;
  CanCancelAtStart:=false;
  QRZupdate;
  if not found then    //this should close cancelled update
   Begin
      c_running := False;
      dmData.RefreshMainDatabase();
      Self.Close;
   end;
end;

procedure TfrmDatabaseUpdate.SynCallBook;
begin
  try
    pnlQRZ.Caption := 'Updating ' + c_SyncText;
    pnlQRZ.Repaint;
    if CloseW then
    begin
      c_running := False;
      dmData.RefreshMainDatabase();
      Self.Close;
    end
  except
    on E: Exception do
      Writeln(E.Message)
  end
end;

procedure TfrmDatabaseUpdate.QRZupdate;
var
  QRZ     :   TQRZThread;
  i       :   integer;
begin
  if not c_running then
  begin
    c_running := True;
    CloseW  := False;
    CancelUpdate := False;

    //without this update happens only to 500 QSOs loaded in QSO list view
    i:= pos('LIMIT',uppercase (dmData.qCallBook.SQL.Text));
    if i>0 then  dmData.qCallBook.SQL.Text:=copy(dmData.qCallBook.SQL.Text,1,i-1);

    if dmData.DebugLevel >= 1 then
      Writeln(dmData.qCallBook.SQL.Text);
    if not Selected then dmData.qCallBook.Open();
    dmData.qCallBook.First;

    if (id_cqrlog_main > -1) then
    begin
      while not dmData.qCallBook.EOF do
      begin
        if id_cqrlog_main = dmData.qCallBook.FieldByName('id_cqrlog_main').AsInteger then
        begin
          found := True;
          break
        end;
        dmData.qCallBook.Next
      end;

      if not found then
      Begin
        pnlQRZ.Caption := 'Previously canceled update breakpoint not found!';
        pnlQRZ.Repaint;
        Application.ProcessMessages;
        sleep(5000);
        exit  //here returns from QTZupdate, does not return from database update.Goes back to ONtmrQRZ
      end;
    end;

    found:=true;      //if id_cqrlog_main has been -1 make here true
    QRZ := TQRZThread.Create(True);
    QRZ.Start;
  end
end;

end.

