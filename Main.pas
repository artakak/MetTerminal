unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, BCPort, ComCtrls, Math, pngimage;

type
  TMainForm = class(TForm)
    Panel1: TPanel;
    cbPort: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    cbBaudRate: TComboBox;
    Memo1: TMemo;
    btnConnect: TButton;
    btnDisconnect: TButton;
    BComPort1: TBComPort;
    Panel2: TPanel;
    Edit1: TEdit;
    btnSend: TButton;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    btnClear: TButton;
    cbCRLF: TCheckBox;
    cbSetRTS: TCheckBox;
    cbSetDTR: TCheckBox;
    lbledt1: TLabeledEdit;
    lbledt2: TLabeledEdit;
    lbledt3: TLabeledEdit;
    lbledt4: TLabeledEdit;
    lbledt5: TLabeledEdit;
    lbledt6: TLabeledEdit;
    lbledt7: TLabeledEdit;
    lbledt8: TLabeledEdit;
    lbledt9: TLabeledEdit;
    pgc1: TPageControl;
    ts1: TTabSheet;
    ts2: TTabSheet;
    img1: TImage;
    lbl1: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    lbl4: TLabel;
    img2: TImage;
    lbl5: TLabel;
    lbl6: TLabel;
    bcmprt1: TBComPort;
    bcmprt2: TBComPort;
    cbb1: TComboBox;
    cbb2: TComboBox;
    cbb3: TComboBox;
    cbb4: TComboBox;
    btn1: TButton;
    btn2: TButton;
    btn3: TButton;
    btn4: TButton;
    lbl7: TLabel;
    lbl8: TLabel;
    edt1: TEdit;
    edt2: TEdit;
    lbl9: TLabel;
    lbl10: TLabel;
    tmr1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure parsing(Sender: TObject);
    procedure btnConnectClick(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure btn3Click(Sender: TObject);
    procedure btn4Click(Sender: TObject);
    procedure btnDisconnectClick(Sender: TObject);
    procedure btnSendClick(Sender: TObject);
    procedure BComPort1RxChar(Sender: TObject; Count: Integer);
    procedure bcmprt1RxChar(Sender: TObject; Count: Integer);
    procedure bcmprt2RxChar(Sender: TObject; Count: Integer);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure cbBaudRateChange(Sender: TObject);
    procedure cbb3Change(Sender: TObject);
    procedure cbb4Change(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure BComPort1CTSChange(Sender: TObject; State: Boolean);
    procedure BComPort1DSRChange(Sender: TObject; State: Boolean);
    procedure BComPort1RLSDChange(Sender: TObject; State: Boolean);
    procedure cbSetRTSClick(Sender: TObject);
    procedure cbSetDTRClick(Sender: TObject);
  private
    // Включение-выключение индикаторов
    procedure SetLedCTS(Value: Boolean);
    procedure SetLedDSR(Value: Boolean);
    procedure SetLedRLSD(Value: Boolean);

  end;

var
  MainForm: TMainForm; S1,S2,S3,sett: String;HDT,RMC,AWS:Real;AWD:Integer;
  f,fset:TextFile;

implementation

{$R *.DFM}
{$R Led.res}

procedure TMainForm.SetLedCTS(Value: Boolean);
begin
  if Value then
    Image1.Picture.Bitmap.Handle := LoadBitmap(HInstance, 'On')
  else
    Image1.Picture.Bitmap.Handle := LoadBitmap(HInstance, 'Off');
end;

procedure TMainForm.SetLedDSR(Value: Boolean);
begin
  if Value then
    Image2.Picture.Bitmap.Handle := LoadBitmap(HInstance, 'On')
  else
    Image2.Picture.Bitmap.Handle := LoadBitmap(HInstance, 'Off');
end;

procedure TMainForm.SetLedRLSD(Value: Boolean);
begin
  if Value then
    Image3.Picture.Bitmap.Handle := LoadBitmap(HInstance, 'On')
  else
    Image3.Picture.Bitmap.Handle := LoadBitmap(HInstance, 'Off');
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  EnumComPorts(cbPort.Items);
  EnumComPorts(cbb1.Items);
  EnumComPorts(cbb2.Items);
   if FileExists('comports.txt') then
     begin
     AssignFile(fset,'comports.txt');
     Reset(fset);
     Read(fset,sett);
     cbPort.ItemIndex := StrToInt(sett[1]);
     cbBaudRate.ItemIndex :=StrToInt(sett[2]);
     cbb1.ItemIndex :=StrToInt(sett[3]);
     cbb3.ItemIndex :=StrToInt(sett[4]);
     cbb2.ItemIndex :=StrToInt(sett[5]);
     cbb4.ItemIndex :=StrToInt(sett[6]);
     end;
 //cbPort.ItemIndex := 0;
 //cbb1.ItemIndex := 0;
 //cbb2.ItemIndex := 0;
 //cbBaudRate.ItemIndex := 6;
 //cbb3.ItemIndex := 6;
 //cbb4.ItemIndex := 6;
  SetLedCTS(False);
  SetLedDSR(False);
  SetLedRLSD(False);
  DecimalSeparator := '.';
  img1.Parent.DoubleBuffered:=True;
  lbl1.Caption:='';lbl2.Caption:='';lbl3.Caption:='';lbl4.Caption:='';lbl5.Caption:='';lbl6.Caption:='';
  lbl1.BringToFront;lbl2.BringToFront;lbl3.BringToFront;lbl4.BringToFront;
  img1.Canvas.Brush.Color := clWhite;
  img1.Canvas.FillRect(img1.Canvas.ClipRect);
  AssignFile(f,'testlog.txt');
  Rewrite(f);
  MainForm.WindowState:=wsMaximized;

end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   sett:=inttostr(cbPort.ItemIndex)+inttostr(cbBaudRate.ItemIndex)+inttostr(cbb1.ItemIndex)+inttostr(cbb3.ItemIndex)+inttostr(cbb2.ItemIndex)+inttostr(cbb4.ItemIndex);
   Rewrite(fset);
   Write(fset,sett);
   CloseFile(fset);
end ;

procedure TMainForm.btnConnectClick(Sender: TObject);
begin
  BComPort1.Port := cbPort.Text;
  BComPort1.BaudRate := TBaudRate(cbBaudRate.ItemIndex);
  if BComPort1.Open then
  begin
    Edit1.Enabled := True; Edit1.Color := clWindow;
    btnConnect.Enabled := False;
    cbPort.Enabled := False;
    btnDisconnect.Enabled := True;
    cbSetDTR.Enabled := True; cbSetDTR.Checked := True;
    cbSetRTS.Enabled := True; cbSetRTS.Checked := True;
    btnSend.Enabled := True;
    cbCRLF.Enabled := True;
    btnClear.Enabled := True;
    Memo1.Enabled := True; Memo1.Color := clWindow;
    SetLedCTS(csCTS in BComPort1.Signals);
    SetLedDSR(csDSR in BComPort1.Signals);
    SetLedRLSD(csRLSD in BComPort1.Signals);
    Edit1.SetFocus;

  end;
end;

procedure TMainForm.btn1Click(Sender: TObject);
begin
  bcmprt1.Port := cbb1.Text;
  bcmprt1.BaudRate := TBaudRate(cbb3.ItemIndex);
  if bcmprt1.Open then
  begin
    btn1.Enabled := False;
    cbb1.Enabled := False;
    btn3.Enabled := True;
  end;
end;

procedure TMainForm.btn2Click(Sender: TObject);
begin
  bcmprt2.Port := cbb2.Text;
  bcmprt2.BaudRate := TBaudRate(cbb2.ItemIndex);
  if bcmprt2.Open then
  begin
    btn2.Enabled := False;
    cbb2.Enabled := False;
    btn4.Enabled := True;
  end;
end;


procedure TMainForm.btnDisconnectClick(Sender: TObject);
begin
  if BComPort1.Close then
  begin
    btnConnect.Enabled := True;
    cbPort.Enabled := True;
    btnDisconnect.Enabled := False;
    cbSetDTR.Enabled := False;
    cbSetRTS.Enabled := False;
    btnSend.Enabled := False;
    cbCRLF.Enabled := False;
    btnClear.Enabled := False;
    Memo1.Enabled := False; Memo1.Color := clBtnFace;
    Edit1.Enabled := False; Edit1.Color := clBtnFace;
    SetLedCTS(False);
    SetLedDSR(False);
    SetLedRLSD(False);
    img1.Canvas.Brush.Color := clWhite;
    img1.Canvas.FillRect(img1.Canvas.ClipRect);
    lbledt1.Text:='';lbledt2.Text:='';lbledt3.Text:='';
    lbledt4.Text:='';lbledt5.Text:='';lbledt6.Text:='';
    lbledt8.Text:='';lbledt9.Text:='';lbl1.Caption:='';
    lbl2.Caption:='';lbl3.Caption:='';lbl4.Caption:='';
    lbl5.Caption:='';lbl6.Caption:='';lbl9.Caption:='';
    lbl10.Caption:='';lbledt7.Text:='';
    tmr1.Enabled:=False;
    CloseFile(f);
  end;
end;

procedure TMainForm.btn3Click(Sender: TObject);
begin
  if bcmprt1.Close then
  begin
    btn1.Enabled := True;
    cbb1.Enabled := True;
    btn3.Enabled := False;
    edt1.Text:='';
  end;
end;

procedure TMainForm.btn4Click(Sender: TObject);
begin
  if bcmprt2.Close then
  begin
    btn2.Enabled := True;
    cbb2.Enabled := True;
    btn4.Enabled := False;
    edt2.Text:='';
  end;
end;


procedure TMainForm.btnSendClick(Sender: TObject);
begin
  if BComPort1.Connected then
  begin
    BComPort1.WriteStr(Edit1.Text);
    Edit1.Text := '';
    Edit1.SetFocus;
  end;
end;

procedure TMainForm.parsing(Sender: TObject);
var
  S,P: String; k,j,i:Integer;TWD,TWS,dk:Real;ks:Char;
  mas,mas1,mas2: array [1..100] of string;
begin
    Append(f);
    write(f,'METEO-START'+#13#10+S1+'METEO-END'+#13#10);
    write(f,'HDT-START'+#13#10+S2+'HDT-END'+#13#10);
    write(f,'RMC-START'+#13#10+S3+'RMC-END'+#13#10);
    j:=1;
    img1.Canvas.Brush.Color := clWhite;
    img1.Canvas.FillRect(img1.Canvas.ClipRect);
  if S1 <> '' then
    begin
      If S1[1] = '$' then                              // Парсим предложение
      begin
      lbledt1.Text := 'NMEA';
      lbledt7.Text:='';               //обнуляем то, что не идет по NMEA
      lbledt8.Text:='';
      lbledt9.Text:='';
      for k:=1 to Length(S1) do
            begin
              if S1[k] <> ',' then
              mas[j]:=mas[j]+S1[k] else inc(j);
            end;
        lbledt2.Text:=mas[2]; try lbl5.Caption:='AWD '+mas[2]+#176; AWD:=StrToInt(mas[2]); except AWD:=0;lbl5.Caption:='';end;
        lbledt3.Text:=mas[4]; try lbl6.Caption:=FloatToStrF(StrToFloat(mas[4]),ffFixed,10,2)+#13#10+FloatToStrF(StrToFloat(mas[4])*0.514,ffFixed,10,2)+' m/s'; AWS:=StrToFloat(mas[4]); except AWS:=0;lbl6.Caption:='';end;
        lbledt5.Text:=mas[8]; try lbl1.Caption:=FloatToStrF(StrToFloat(mas[8]),ffFixed,10,1)+#176+' C'; except lbl1.Caption:=''end;
        lbledt4.Text:=mas[12]; try lbl2.Caption:=FloatToStrF(StrToFloat(mas[12])*750.06,ffFixed,10,0)+#13#10+'mmHg'; except lbl2.Caption:=''end;
        lbledt6.Text:=mas[16]; try lbl3.Caption:=FloatToStrF(StrToFloat(mas[16]),ffFixed,10,1)+' %'; except lbl3.Caption:='' end; lbl4.Caption:='';
      end;

      If S1[1] = #02 then
      begin
      lbledt1.Text := 'GILL';              // Обработка данных по протоколу GILL
      for k:=1 to Length(S1) do
        begin
          if S1[k] <> ',' then
          mas[j]:=mas[j]+S1[k] else inc(j);
        end;
      lbledt2.Text:=mas[2]; try lbl5.Caption:='AWD '+mas[2]+#176; AWD:=StrToInt(mas[2]); except AWD:=0;lbl5.Caption:='';end;
      lbledt3.Text:=mas[3]; try lbl6.Caption:=FloatToStrF(StrToFloat(mas[3]),ffFixed,10,2)+#13#10+FloatToStrF(StrToFloat(mas[3])*0.514,ffFixed,10,2)+' m/s'; AWS:=StrToFloat(mas[3]); except AWS:=0;lbl6.Caption:='';end;
      lbledt4.Text:=mas[5]; lbl2.Caption:=mas[5];
      lbledt6.Text:=mas[6]; try lbl3.Caption:=FloatToStrF(StrToFloat(mas[6]),ffFixed,10,1)+' %'; except lbl3.Caption:='' end;
      lbledt5.Text:=mas[4]; try lbl1.Caption:=FloatToStrF(StrToFloat(mas[4]),ffFixed,10,1)+#176+' C'; except lbl1.Caption:=''end;
      lbledt7.Text:=mas[7]; try lbl4.Caption:=FloatToStrF(StrToFloat(mas[7]),ffFixed,10,1)+#176+' C';except lbl4.Caption:=''end;
      lbledt8.Text:=mas[9];
      lbledt9.Text:=mas[8];
      end;

      if lbl5.Caption <> '' then
      begin
      img1.Canvas.Pen.Width:=30;
      img1.Canvas.Pen.Color:=clLime;
      img1.Picture.Bitmap.Height := img1.Height;
      img1.Picture.Bitmap.Width := img1.Width;
      img1.Canvas.MoveTo(img1.Width div 2,img1.Height div 2);
      img1.Canvas.LineTo(Round(img1.Width div 2+cos(AWD*(pi/180)-pi/2)*(img1.Width div 2)),Round(img1.Height div 2+sin(AWD*(pi/180)-pi/2)*(img1.Width div 2)));
      end;

      j:=1;
      if S2 <> '' then
      begin
      If S2[1] = '$' then                   // Парсим предложение HDT
        begin
         for k:=1 to Length(S2) do
            begin
              if S2[k] <> ',' then
              mas1[j]:=mas1[j]+S2[k] else inc(j);
            end;
         if Char(mas1[1][4])='H' then
        begin
        edt1.Text:=mas1[2]; try HDT:=StrToFloat(mas1[2]); except HDT:=0;end;
        end;
        end;
      S2:='';
      end;

      j:=1;
      if S3 <> '' then
      begin
        If S3[1] = '$' then                   // Парсим предложение RMC
        begin
        for k:=1 to Length(S3) do
            begin
              if S3[k] <> ',' then
              mas2[j]:=mas2[j]+S3[k] else inc(j);
            end;
        if Char(mas2[1][4])='R' then
        begin
        edt2.Text:=mas2[8]; try RMC:=StrToFloat(mas2[8]); except RMC:=0;end;
        end;
        end;
      S3:='';
      end;

    if (edt1.Text <> '') and (edt2.Text <> '') and (lbl5.Caption <> '') then
    begin
     //true wind
    if AWD-HDT<0 then dk:=AWD-HDT+360 else dk:=AWD-HDT;
    TWS:=Sqrt(Sqr(RMC)+Sqr(AWS)-2*RMC*AWS*cos(AWD-HDT));
    if dk<180 then
    TWD:=HDT+dk+arccos((AWS-RMC*cos(AWD-HDT))/TWS)
    else
    TWD:=HDT+dk-arccos((AWS-RMC*cos(AWD-HDT))/TWS);
    if TWD>360 then TWD:=Round(TWD-360);
    if TWD<0 then TWD:=Round(360+TWD);
    img1.Canvas.Pen.Width:=30;
    img1.Canvas.Pen.Color:=clRed;
    img1.Canvas.MoveTo(img1.Width div 2,img1.Height div 2);
    img1.Canvas.LineTo(Round(img1.Width div 2+cos(TWD*(pi/180)-pi/2)*(img1.Width div 2)),Round(img1.Height div 2+sin(TWD*(pi/180)-pi/2)*(img1.Width div 2)));
    lbl9.Caption:='TWD '+FloatToStrF(TWD,ffFixed,10,0)+#176;
    lbl10.Caption:=FloatToStrF(TWS,ffFixed,10,2)+#13#10+FloatToStrF(TWS*0.514,ffFixed,10,2)+' m/s';
    end;
     S1:=''; tmr1.Enabled:=False;
    end;

end;

procedure TMainForm.BComPort1RxChar(Sender: TObject; Count: Integer);
var
  S: String;
begin
  tmr1.Enabled:=True;
  BComPort1.ReadStr(S, Count);
  if cbCRLF.Checked and (S[Length(S)] = #13) then // Добавление перевода строки
    S := S + #10;
    Memo1.Text := Memo1.Text + S;
    S1:=S1+S;
end;

procedure TMainForm.bcmprt1RxChar(Sender: TObject; Count: Integer);
var
  S: String;
begin
  bcmprt1.ReadStr(S, Count);
  S2:=S2+S;
end;

procedure TMainForm.bcmprt2RxChar(Sender: TObject; Count: Integer);
var
  S: String;
begin
  bcmprt2.ReadStr(S, Count);
  S3:=S3+S;
end;

procedure TMainForm.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if BComPort1.Connected and (Key = #13) then
  begin
    BComPort1.WriteStr(Edit1.Text + Key);
    Edit1.Text := '';
  end;
end;

procedure TMainForm.cbBaudRateChange(Sender: TObject);
begin
  BComPort1.BaudRate := TBaudRate(cbBaudRate.ItemIndex);
end;

procedure TMainForm.cbb3Change(Sender: TObject);
begin
  bcmprt1.BaudRate := TBaudRate(cbb3.ItemIndex);
end;

procedure TMainForm.cbb4Change(Sender: TObject);
begin
  bcmprt2.BaudRate := TBaudRate(cbb4.ItemIndex);
end;

procedure TMainForm.btnClearClick(Sender: TObject);
begin
  Memo1.Clear;
  Edit1.SetFocus;
end;

procedure TMainForm.BComPort1CTSChange(Sender: TObject; State: Boolean);
begin
  SetLedCTS(State);  // Изменилось состояние входной линии CTS
end;

procedure TMainForm.BComPort1DSRChange(Sender: TObject; State: Boolean);
begin
  SetLedDSR(State);  // Изменилось состояние входной линии DSR
end;

procedure TMainForm.BComPort1RLSDChange(Sender: TObject; State: Boolean);
begin
  SetLedRLSD(State); // Изменилось состояние входной линии RLSD
end;

procedure TMainForm.cbSetRTSClick(Sender: TObject);
begin
  BComPort1.SetRTS(cbSetRTS.Checked);
  Edit1.SetFocus;
end;

procedure TMainForm.cbSetDTRClick(Sender: TObject);
begin
  BComPort1.SetDTR(cbSetDTR.Checked);
  Edit1.SetFocus;
end;

end.
