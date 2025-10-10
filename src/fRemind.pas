unit fRemind;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, StdCtrls, maskedit, LCLtype;

type

  { TfrmReminder }

  TfrmReminder = class(TForm)
    btClose: TButton;
    chUTRemi: TCheckBox;
    chRemi: TCheckBox;
    RemindTimeSet: TEdit;
    RemindUThour: TEdit;
    lblRemi1: TLabel;
    lblRemi3: TLabel;
    lblRemi2: TLabel;
    RemiMemo: TMemo;
    tmrRemi: TTimer;
    procedure FormHide(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure RemiMemoLimit(Sender: TObject; var Key: Char);
    procedure btCloseClick(Sender: TObject);
    procedure chRemiChange(Sender: TObject);
    procedure chUTRemiChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure RemindTimeSetEnter(Sender: TObject);
    procedure RemindTimeSetExit(Sender: TObject);
    procedure RemindUThourEnter(Sender: TObject);
    procedure RemindUThourExit(Sender: TObject);
    procedure tmrRemiTimer(Sender: TObject);
  private
    procedure ShowReminder;
    { private declarations }
  public
    procedure OpenReminder;
    { public declarations }
  end;

var
  frmReminder: TfrmReminder;
  date : TDateTime;
  TimerValue: string;

implementation
{$R *.lfm}

{ TfrmReminder }

uses dData,dUtils,uMyini,fNewQSO;

Procedure TfrmReminder.OpenReminder;

Begin //when not entering from timer
  tmrRemi.Enabled :=false;
  frmReminder.ShowOnTop;
  RemiMemo.SetFocus;
end;

procedure TfrmReminder.RemiMemoLimit(Sender: TObject; var Key: Char);
var
  MAX_LINES              : Integer;
  LINE_LENGTH            : Integer;
begin
  MAX_LINES         := 1;
  LINE_LENGTH       := 255;
  if (RemiMemo.Lines.Count = MAX_LINES) then
    if(Key = #13) or (length(RemiMemo.Lines[MAX_LINES-1]) >= LINE_LENGTH ) then
      begin
        if not((Key = #08) or (Key = #127)) then Key := #0;        //del & BS ok
        Exit;
      end;
  if (RemiMemo.Lines.Count > MAX_LINES) and (Key = #13) then  //no new lines
    begin
      Key := #0;
      Exit;
    end;
end;

procedure TfrmReminder.FormShow(Sender: TObject);
begin
  dmUtils.LoadWindowPos(Self);
  lblRemi1.Font.Size:=18;                //this is fixed label
  lblRemi1.Font.Style:=[fsBold,fsItalic];
  chRemi.Checked      := cqrini.ReadBool('Reminder','chRemi',false);
  chUTRemi.Checked    := cqrini.ReadBool('Reminder','chUTRemi',False);
  RemindTimeSet.Text  := cqrini.ReadString('Reminder','RemindTimeSet','');
  RemindUThour.Text   := cqrini.ReadString('Reminder','RemindUThour','');
  RemiMemo.Lines.Text := cqrini.ReadString('Reminder','RemiMemo','');
end;

procedure TfrmReminder.FormKeyUp(Sender : TObject; var Key : Word;
  Shift : TShiftState);
begin
  if (key= VK_ESCAPE) then
  begin
    btCloseClick(nil);
    frmNewQSO.ReturnToNewQSO;
    key := 0
  end
end;

procedure TfrmReminder.FormHide(Sender: TObject);
begin
  
   cqrini.WriteBool('Reminder','chRemi',chRemi.Checked);
   cqrini.WriteBool('Reminder','chUTRemi',chUTRemi.Checked);
   cqrini.WriteString('Reminder','RemindTimeSet',RemindTimeSet.Text);
   cqrini.WriteString('Reminder','RemindUThour',RemindUThour.Text);
   cqrini.WriteString('Reminder','RemiMemo',RemiMemo.Lines.Text);
   dmUtils.SaveWindowPos(Self);

end;

Procedure TfrmReminder.ShowReminder;

var s,i:string;

Begin

   if  chRemi.Checked then
    begin
     TimerValue := IntToStr(tmrRemi.Interval div 60000);
     if dmData.DebugLevel >=1 then writeln('Reminder TimerValue:', tmrRemi.Interval );
     while length(Timervalue)< 3 do TimerValue := '0'+TimerValue;
     RemindTimeSet.Text := TimerValue;
     tmrRemi.Enabled := False;
     frmReminder.ShowOnTop;
    end;

    if chUTRemi.checked then
     Begin
       date := dmUtils.GetDateTime(0);
       i:= FormatDateTime('hhmm',date);
       s:= RemindUThour.Text;
       if dmData.DebugLevel >=1 then
            writeln('UT reminder *',s,'* is nw *',i,'*');
       if i = s  then
        Begin
         tmrRemi.Enabled := False;
         frmReminder.ShowOnTop;
        end;
     end;

end;

procedure TfrmReminder.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
   frmReminder.btCloseClick(nil);
end;

procedure TfrmReminder.RemindTimeSetEnter(Sender: TObject);
begin
    while length(RemindTimeSet.Text)<3 do
               RemindTimeSet.Text:='0'+RemindTimeSet.Text;
    RemindTimeSet.SelectAll;
end;

procedure TfrmReminder.RemindTimeSetExit(Sender: TObject);
begin
  while length(RemindTimeSet.Text)<3 do
               RemindTimeSet.Text:='0'+RemindTimeSet.Text;

  if ((RemindTimeSet.Text = '000') and chRemi.Checked) then
                          RemindTimeSet.Text := '001';
end;



procedure TfrmReminder.RemindUThourEnter(Sender: TObject);
begin
  while length( RemindUThour.Text)<4 do
               RemindUThour.Text:='0'+RemindUThour.Text;
  RemindUThour.SelectAll;
end;

procedure TfrmReminder.RemindUThourExit(Sender: TObject);
var s : string;
    c:boolean = false;

begin
s := RemindUThour.Text;
case s[1] of                      //hour tens just 0,1,2
'3' .. '9' : Begin
              c:=true;
              s[1] := '2';
             end;
end;

if s[1] = '2' then               // hours just up to 23
case s[2] of
  '4' .. '9' : Begin
                c:=true;
                s[2] := '3';
               end;
end;

case s[3] of                      //minute tens just 0,1,2,4,5
'6' .. '9' : Begin
              c:=true;
              s[4] := '5';
             end;
end;

RemindUThour.Text := s;

if c then
ShowMessage ('Check time setting!');
end;

procedure TfrmReminder.btCloseClick(Sender: TObject);
var
   TimerSetting : integer;

begin
  if chRemi.Checked = true then
     Begin
       if TryStrToINt(RemindTimeSet.Text,TimerSetting) then
        TimerSetting := TimerSetting * 60000 //to milliseconds
       else
        begin
           RemindTimeSet.Text :='001';
           TimerSetting := 60000; // on error defaults to minute
        end;
       tmrRemi.Interval:= TimerSetting;
       tmrRemi.Enabled := True;
       if dmData.DebugLevel >=1 then Writeln('Remind timer set to :',tmrRemi.Interval,'ms');
     end;

  if chUTRemi.Checked = true then
     Begin
       TimerSetting := 10000; // 10sec  for UT check
       tmrRemi.Interval:= TimerSetting;
       tmrRemi.Enabled := True;
       if dmData.DebugLevel >=1 then Writeln('UT Remind check timer set to :',tmrRemi.Interval,'ms');
     end;

   if (not  chUTRemi.Checked) and (not chRemi.Checked ) then tmrRemi.Enabled := False;

   if frmReminder.Showing then
                      frmReminder.hide;
end;

procedure TfrmReminder.chRemiChange(Sender: TObject);
begin
  if  chRemi.Checked = true then
   Begin
    chUTRemi.Checked := false;
   end;
end;

procedure TfrmReminder.chUTRemiChange(Sender: TObject);
begin
  if  chUTRemi.Checked = true then
   Begin
    chRemi.Checked := false;
   end;
end;

procedure TfrmReminder.tmrRemiTimer(Sender: TObject);
begin
  ShowReminder;
end;

initialization

end.

