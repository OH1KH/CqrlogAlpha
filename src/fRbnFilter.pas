unit fRbnFilter;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Buttons, lclType;

type

  { TfrmRbnFilter }

  TfrmRbnFilter = class(TForm)
    Bevel1: TBevel;
    btnCancel: TButton;
    btnDxBandsAll: TButton;
    btnDXCCnty: TButton;
    btnDXCNotCnty: TButton;
    btnDxContAll: TButton;
    btnDxModeAll: TButton;
    btnOK: TButton;
    btnSrcContAll: TButton;
    btnSrcCallAll: TButton;
    chkDupFilt: TCheckBox;
    chkToBandMap: TCheckBox;
    chkNewDXConly: TCheckBox;
    chkOnlyeQSL: TCheckBox;
    chkOnlyLoTW: TCheckBox;
    edtDate: TEdit;
    edtLastHours: TEdit;
    edtSrcCall: TEdit;
    edtDXBand: TEdit;
    edtDXCNotCnty: TEdit;
    edtDXCnty: TEdit;
    edtDXCont: TEdit;
    edtDXMode: TEdit;
    edtDXOnlyCall: TEdit;
    edtDXOnlyExpres: TEdit;
    edtSrcCont: TEdit;
    edtTime: TEdit;
    grpCallsignFrom: TGroupBox;
    grpDXStation: TGroupBox;
    grpCallisgn: TGroupBox;
    grpSource: TGroupBox;
    lblDateTimeFormat: TLabel;
    lblIgnoreHours: TLabel;
    Label10: TLabel;
    lblCallExample: TLabel;
    lblSrcCall: TLabel;
    Label8: TLabel;
    lblBandExFrom: TLabel;
    lblBandFrom: TLabel;
    lblContExample: TLabel;
    lblContExFrom: TLabel;
    lblContinentFrom: TLabel;
    lblCountryFrom: TLabel;
    lblContent: TLabel;
    Label9: TLabel;
    lblModeFrom: TLabel;
    lblNotCountry: TLabel;
    rgIgnore: TRadioGroup;
    rgDupe: TRadioGroup;
    rbAllDx: TRadioButton;
    rbOnlyCall: TRadioButton;
    rbOnlyCallReg: TRadioButton;
    procedure btnDxBandsAllClick(Sender: TObject);
    procedure btnDXCCntyClick(Sender: TObject);
    procedure btnDXCNotCntyClick(Sender: TObject);
    procedure btnDxContAllClick(Sender: TObject);
    procedure btnDxModeAllClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnSrcCallAllClick(Sender: TObject);
    procedure btnSrcContAllClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmRbnFilter: TfrmRbnFilter;

implementation

uses uMyIni, dUtils, dDXCC, fSelectDXCC;

{$R *.lfm}

{ TfrmRbnFilter }

procedure TfrmRbnFilter.FormShow(Sender: TObject);
begin
  dmUtils.LoadFontSettings(self);

  edtSrcCont.Text      := cqrini.ReadString('RBNFilter','SrcCont',C_RBN_CONT);
  edtSrcCall.Text      := cqrini.ReadString('RBNFilter','SrcCall','');
  rgIgnore.ItemIndex   := cqrini.ReadInteger('RBNFilter','Ignore',0);
  edtLastHours.Text    := IntToStr(cqrini.ReadInteger('RBNFilter','IgnHourValue',48));
  edtDate.Text         := cqrini.ReadString('RBNFilter','IgnDateValue','');
  edtTime.Text         := cqrini.ReadString('RBNFilter','IgnTimeValue','');

  rbAllDx.Checked       := cqrini.ReadBool('RBNFilter','AllowAllCall',True);
  rbOnlyCall.Checked    := cqrini.ReadBool('RBNFilter','AllowOnlyCall',False);
  edtDXOnlyCall.Text    := cqrini.ReadString('RBNFilter','AllowOnlyCallValue','');
  rbOnlyCallReg.Checked := cqrini.ReadBool('RBNFilter','AllowOnlyCallReg',False);
  edtDXOnlyExpres.Text  := cqrini.ReadString('RBNFilter','AllowOnlyCallRegValue','');

  edtDXCont.Text     := cqrini.ReadString('RBNFilter','AllowCont',C_RBN_CONT);
  edtDXBand.Text     := cqrini.ReadString('RBNFilter','AllowBands',C_RBN_BANDS);
  edtDXMode.Text     := cqrini.ReadString('RBNFilter','AllowModes',C_RBN_MODES);
  edtDXCnty.Text     := cqrini.ReadString('RBNFilter','AllowCnty','');
  edtDXCNotCnty.Text := cqrini.ReadString('RBNFilter','NotCnty','');

  chkOnlyLoTW.Checked := cqrini.ReadBool('RBNFilter','LoTWOnly',False);
  chkOnlyeQSL.Checked := cqrini.ReadBool('RBNFilter','eQSLOnly',False);

  chkNewDXConly.Checked := cqrini.ReadBool('RBNFilter','NewDXCOnly',False);
  chkToBandMap.Checked  :=cqrini.ReadBool('RBNMonitor','ToBandMap',false);

  rgDupe.ItemIndex:= cqrini.ReadInteger('RBNMonitor','DupeRes',1);
  chkDupFilt.Checked:= cqrini.ReadBool('RBNMonitor','DupeFiltUsed', true);

end;

procedure TfrmRbnFilter.btnOKClick(Sender: TObject);
  function RmSp(what : String) : String;
  begin
    Result := StringReplace(what,' ','',[rfReplaceAll, rfIgnoreCase])
  end;

var
  i : Integer;
begin
  if not TryStrToInt(edtLastHours.Text,i) then
  begin
    if (rgIgnore.ItemIndex=1) then
    begin
      Application.MessageBox('Please enter correct number of hours, please','Error...',mb_OK+mb_IconError);
      edtLastHours.SetFocus;
      exit
    end
    else
      edtLastHours.Text := '48'
  end;

  if not dmUtils.IsDateOK(edtDate.Text) then
  begin
    if (rgIgnore.ItemIndex=2) then
    begin
      Application.MessageBox('Enter date in correct format, please','Error...',mb_Ok+mb_IconError);
      edtDate.SetFocus;
      exit
    end
    else
      edtDate.Text := ''
  end;

  if not (dmUtils.IsTimeOK(edtTime.Text)) then
  begin
    if (rgIgnore.ItemIndex=2) then
    begin
      Application.MessageBox('Enter time in correct format, please','Error...',mb_Ok+mb_IconError);
      edtTime.SetFocus;
      exit
    end
    else
      edtTime.Text := ''
  end;

  if (edtSrcCont.Text='') then
    edtSrcCont.Text := C_RBN_CONT;
  if (edtDXCont.Text='') then
    edtDXCont.Text := C_RBN_CONT;
  if (edtDXBand.Text='') then
    edtDXBand.Text := C_RBN_BANDS;
  if (edtDXMode.Text='') then
    edtDXMode.Text := C_RBN_MODES;

  cqrini.WriteString('RBNFilter','SrcCont',RmSp(edtSrcCont.Text));
  cqrini.WriteString('RBNFilter','SrcCall',RmSp(edtSrcCall.Text));

  cqrini.WriteInteger('RBNFilter','Ignore', rgIgnore.ItemIndex);

  cqrini.WriteInteger('RBNFilter','IgnHourValue',StrToint(edtLastHours.Text));
  cqrini.WriteString('RBNFilter','IgnDateValue',edtDate.Text);
  cqrini.WriteString('RBNFilter','IgnTimeValue',edtTime.Text);

  cqrini.WriteBool('RBNFilter','AllowAllCall',rbAllDx.Checked);
  cqrini.WriteBool('RBNFilter','AllowOnlyCall',rbOnlyCall.Checked);
  cqrini.WriteString('RBNFilter','AllowOnlyCallValue',RmSp(edtDXOnlyCall.Text));
  cqrini.WriteBool('RBNFilter','AllowOnlyCallReg',rbOnlyCallReg.Checked);
  cqrini.WriteString('RBNFilter','AllowOnlyCallRegValue',edtDXOnlyExpres.Text);

  cqrini.WriteString('RBNFilter','AllowCont',RmSp(edtDXCont.Text));
  cqrini.WriteString('RBNFilter','AllowBands',RmSp(edtDXBand.Text));
  cqrini.WriteString('RBNFilter','AllowModes',RmSp(edtDXMode.Text));
  cqrini.WriteString('RBNFilter','AllowCnty',RmSp(edtDXCnty.Text));
  cqrini.WriteString('RBNFilter','NotCnty',RmSp(edtDXCNotCnty.Text));

  cqrini.WriteBool('RBNFilter','LoTWOnly',chkOnlyLoTW.Checked);
  cqrini.WriteBool('RBNFilter','eQSLOnly',chkOnlyeQSL.Checked);

  cqrini.WriteBool('RBNFilter','NewDXCOnly',chkNewDXConly.Checked);
  cqrini.WriteBool('RBNMonitor','ToBandMap',chkToBandMap.Checked );

  cqrini.WriteInteger('RBNMonitor','DupeRes',rgDupe.ItemIndex);
  cqrini.WriteBool('RBNMonitor','DupeFiltUsed', chkDupFilt.Checked);

  cqrini.SaveToDisk;
  ModalResult := mrOK
end;

procedure TfrmRbnFilter.btnSrcCallAllClick(Sender: TObject);
begin
  edtSrcCall.Text:='';
end;

procedure TfrmRbnFilter.btnSrcContAllClick(Sender: TObject);
begin
  edtSrcCont.Text := C_RBN_CONT
end;

procedure TfrmRbnFilter.btnDXCCntyClick(Sender: TObject);
begin
  frmSelectDXCC := TfrmSelectDXCC.Create(self);
  try
    frmSelectDXCC.pgDXCC.PageIndex := 0;
    if frmSelectDXCC.ShowModal = mrOK then
    begin
      if (edtDXCnty.Text='') then
        edtDXCnty.Text := dmDXCC.qValid.Fields[1].AsString
      else
        edtDXCnty.Text := edtDXCnty.Text + ', '+dmDXCC.qValid.Fields[1].AsString
    end
  finally
    FreeAndNil(frmSelectDXCC)
  end
end;

procedure TfrmRbnFilter.btnDxBandsAllClick(Sender: TObject);
begin
  edtDXBand.Text := C_RBN_BANDS
end;

procedure TfrmRbnFilter.btnDXCNotCntyClick(Sender: TObject);
begin
  frmSelectDXCC := TfrmSelectDXCC.Create(self);
  try
    frmSelectDXCC.pgDXCC.PageIndex := 0;
    if frmSelectDXCC.ShowModal = mrOK then
    begin
      if (edtDXCNotCnty.Text='') then
        edtDXCNotCnty.Text := dmDXCC.qValid.Fields[1].AsString
      else
        edtDXCNotCnty.Text := edtDXCNotCnty.Text + ', '+dmDXCC.qValid.Fields[1].AsString
    end
  finally
    FreeAndNil(frmSelectDXCC)
  end
end;

procedure TfrmRbnFilter.btnDxContAllClick(Sender: TObject);
begin
  edtDXCont.Text := C_RBN_CONT
end;

procedure TfrmRbnFilter.btnDxModeAllClick(Sender: TObject);
begin
  edtDXMode.Text := C_RBN_MODES
end;

{ TfrmRbnFilter }

end.

