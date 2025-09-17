unit fQSLViewer;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  ComCtrls, ExtCtrls, StdCtrls;

type

  { TfrmQSLViewer }

  TfrmQSLViewer = class(TForm)
    btnCancel: TButton;
    imgBack: TImage;
    imgFront: TImage;
    pgQSL: TPageControl;
    Panel1: TPanel;
    tabFront: TTabSheet;
    tabBack: TTabSheet;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure pgQSLPageChanged(Sender: TObject);
  private
    fCall    : String;
    fAltImg  : String;
  public
    property Call   : String write fCall;
    property AltImg : String write fAltImg;
    { public declarations }
  end; 

var
  frmQSLViewer: TfrmQSLViewer;

implementation
{$R *.lfm}

uses dData, dUtils;


{ TfrmQSLViewer }

procedure TfrmQSLViewer.FormShow(Sender: TObject);
var
  a : String;
begin
  dmUtils.LoadWindowPos(Self);
  if fAltImg<>'' then
   Begin
     a:=dmUtils.sImageExists(fAltImg);
     if a <> '' then
      begin
       imgFront.Picture.LoadFromFile(a);
       pgQSLPageChanged(Self);
       Self.Caption:='eQSL card';
      end;
   end
  else
   begin
    fCall := LowerCase(StringReplace(fCall,'/','_',[rfReplaceAll, rfIgnoreCase]));

    a := dmUtils.QSLFrontImageExists(fCall);
    if a <> '' then
      begin
        imgFront.Picture.LoadFromFile(a);
        pgQSLPageChanged(Self);
      end;

    a := dmUtils.QSLBackImageExists(fCall);
    if a <> '' then
     begin
       imgBack.Picture.LoadFromFile(a);
     end;
   end;
end;

procedure TfrmQSLViewer.pgQSLPageChanged(Sender: TObject);
begin
  if pgQSL.ActivePageIndex = 0 then
  begin
    Self.Height := imgFront.Picture.Height+Panel1.Height+35;
    Self.Width  := imgFront.Picture.Width+10;
  end
  else begin
    if dmUtils.QSLBackImageExists(fCall) <> '' then
    begin
      Self.Height := imgBack.Picture.Height+Panel1.Height+35;
      Self.Width  := imgBack.Picture.Width+10;
    end
  end
end;

procedure TfrmQSLViewer.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
  dmUtils.SaveWindowPos(Self)
end;

procedure TfrmQSLViewer.FormCreate(Sender: TObject);
begin
  fAltImg:='';
  fCall:='';
  pgQSL.ActivePageIndex := 0;
  Self.Caption:='QSL card';
end;

end.

