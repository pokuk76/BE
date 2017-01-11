% Initial housekeeping
clear; close all; clc
addpath('C:\jinwork\BE\matlab')
addpath('C:\jinwork\BE\matlab\addaxis5')
%Control parameters
qPlot = 0;
dcPlot = 0;
tempExpFit = 0;
hpExpFit = 0;
qpulseLen = 0;
processYes = 1;
errorBarPlot = 0;
coreRes = 0.5;
%plot bounds setting
startOffset = 0;
endOffset = 0;
hp1 = 0;
hp2 = 40; 
qpow1 = 5;
qpow2 = 55;
cqp1 = 0;
cqp2 = 12;
%list reactors and cores
reactors = {'ipb1-29',...
            'ipb1-30'...
            'sri-ipb2-27'...
            'ipb3-32'...
            'google'...
            'ipb3-36b'};
reactor = 4;
switch (reactor)
case 1
    [startOffset,endOffset,hp1,hp2,cqp1,cqp2,Directory,Experiment,dataFile,whichDate] = ipb1_29(startOffset,endOffset,hp1,hp2,cqp1,cqp2);
case 2
    [startOffset,endOffset,hp1,hp2,cqp1,cqp2,Directory,Experiment,dataFile,whichDate] = ipb1_30(startOffset,endOffset,hp1,hp2,cqp1,cqp2); 
case 3
    [startOffset,endOffset,hp1,hp2,cqp1,cqp2,Directory,Experiment,dataFile,whichDate] = sri_ipb2_27(startOffset,endOffset,hp1,hp2,cqp1,cqp2);
case 4
    [startOffset,endOffset,hp1,hp2,cqp1,cqp2,Directory,Experiment,dataFile,whichDate] = ipb3_32(startOffset,endOffset,hp1,hp2,cqp1,cqp2); 
case 5
    [startOffset,endOffset,hp1,hp2,cqp1,cqp2,Directory,Experiment,dataFile,whichDate] = google(startOffset,endOffset,hp1,hp2,cqp1,cqp2);     
end
Experiment'
loadHHT 
%change a few messy variable names
QOccurred = QOccurred0x3F; clear QPulseOccurred0x3F
%SeqStepNum = SeqStep0x23; clear SeqStep0x23
QPulseLengthns = QPulseLength0x28ns0x29; clear QPulseLength0x28ns0x29
QPulseDelays = QPulseDelay0x28s0x29; clear QPulseDelay0x28s0x29
QkHz = QKHz; clear QKHz;

%change datetime to number
dateN=datenum(DateTime,'mm/dd/yyyy HH:MM:SS');
rawData = horzcat(dateN,...
     SeqStepNum,...
     HeaterPower,...
     CoreTemp,...
     InnerBlockTemp1,...
     OuterBlockTemp1,...
     QPulseLengthns,...
     CoreQPower,...
     CoreQV1Rms,...
     CoreQV2Rms,...
     QSupplyPower,...
     QCur,...
     QSupplyVolt,...
     QSetV,...
     QkHz,...
     QPow,...
     TerminationHeatsinkPower,...
     QPulsePCBHeatsinkPower,...
     CalorimeterJacketFlowrateLPM,...
     QPCBHeatsinkFlowrateLPM,...
     TerminationHeatsinkFlowrateLPM,...
     CalorimeterJacketPower,...
     CalorimeterJacketH2OInT,...
     CalorimeterJacketH2OOutT,...
     QPCBHeatsinkH2OInT,...
     QPCBHeatsinkH2OOutT,...
     TerminationHeatsinkH2OInT,...
     TerminationHeatsinkH2OOutT,...
     QPulseVolt,...
     PressureSensorPSI,...
     HydrogenValves);
%asignColumn name 
dataset({rawData,'dateN',...
     'SeqStepNum',...
     'HeaterPower',...
     'CoreTemp',...
     'InnerBlockTemp1',...
     'OuterBlockTemp1',...
     'QPulseLengthns',...
     'CoreQPower',...
     'CoreQV1Rms',...
     'CoreQV2Rms',...
     'QSupplyPower',...
     'QCur',...
     'QSupplyVolt',...
     'QSetV',...
     'QkHz',...
     'QPow',...
     'TerminationHeatsinkPower',...
     'QPulsePCBHeatsinkPower',...
     'CalorimeterJacketFlowrateLPM',...
     'QPCBHeatsinkFlowrateLPM',...
     'TerminationHeatsinkFlowrateLPM',...
     'CalorimeterJacketPower',...
     'CalorimeterJacketH2OInT',...
     'CalorimeterJacketH2OOutT',...
     'QPCBHeatsinkH2OInT',...
     'QPCBHeatsinkH2OOutT',...
     'TerminationHeatsinkH2OInT',...
     'TerminationHeatsinkH2OOutT',...
     'QPulseVolt',...
     'PressureSensorPSI'...
     'HydrogenValves'}); 
%filter rawData out 
dataSize = size(rawData,1)
%show startOffset and endOffset
DateTime(1+int16(startOffset*360))
DateTime(end - int16(endOffset*360))
rawData = rawData(1+int16(startOffset*360):end-int16(endOffset*360),:);
dataSize = size(rawData,1)
%rawData(any(isnan(rawData)),:)=[]; %take out rows with Nan
dataSize = size(rawData,1)
%(isnan(j1)) = -2 ;
rawData = rawData(rawData(:,2) > 0,:); %only process data with seq
dataSize = size(rawData,1)
dt = datetime(dateN, 'ConvertFrom', 'datenum') ;
if (dcPlot == 1)
figure
hold on
aa_splot(dt,HeaterPower,'black','linewidth',1.5);
ylim([hp1, hp2]);
addaxis(dt,CoreTemp,'linewidth',1.5);
addaxis(dt,InnerBlockTemp1);
addaxis(dt,QSupplyVolt);
addaxis(dt,QSupplyPower) ;
addaxis(dt,QSetV);
%addaxis(dt,QCur); 
title(dataFile,'fontsize',11);
addaxislabel(1,'HeaterPower');
addaxislabel(2,'CoreT');
addaxislabel(3,'InnerT');
addaxislabel(4,'QSupply');
addaxislabel(5,'QSupplyVolt'); 
addaxislabel(6,'QSetV'); 
end 
if (qPlot == 1)
figure
hold on
aa_splot(dt,HeaterPower,'black','linewidth',1.5); 
ylim([hp1, hp2]);
addaxis(dt,CoreTemp,'linewidth',1.5); 
addaxis(dt,QPow,[qpow1,qpow2]); 
addaxis(dt,CoreQPower,[cqp1,cqp2]) ;
addaxis(dt,CoreQV1Rms,[0,12]); 
addaxis(dt,CoreQV2Rms,[0,12]) ;
addaxis(dt,(CoreQV1Rms-CoreQV2Rms).*(CoreQV1Rms-CoreQV2Rms)/coreRes,[cqp1,cqp2]) ;
title(dataFile,'fontsize',11);
addaxislabel(1,'Heater Power(W)');
addaxislabel(2,'CoreTemp(C)');
addaxislabel(3,'QPow(W)');
addaxislabel(4,'CoreQPow(W)'); 
addaxislabel(5,'V1Rms(Volt)');
addaxislabel(6,'V2Rms(Volt)'); 
addaxislabel(7,strcat('(V1-V2)^2/',num2str(coreRes))); 
end 
if (processYes == 1) 
ctFit = [];
itFit = [];
i=0;
i1 = 1;
trim = 10; %10% outliers throw away.
ii = 30; %30*10=300 seconds before to next seq.
if ii > 5;
  trim1 = round(200/ii); %k = ii*(trim/100)/2 through away one highset/lowest point trim = 200/ii
else
  trim1 = 0;
end    
seq2 = 0;
while (i < dataSize-1)  
  i = i+1;
  if abs(SeqStepNum(i+1) - SeqStepNum(i)) >= 1  %sequence changed or at least sequence has run more than an half hour
    i2 = i;
    if i2-i1 > 30 %only pick up the sequence has more then half hours runs
    seq2=seq2+1;
    %one point
    seq = SeqStepNum(i);
    seq1(seq2)=seq;
    dt1(seq2) = dateN(i2); 
    h2(seq2) = HydrogenValves(i);
    ql(seq2) = QPulseLengthns(i);
    %last few points or exponentialFit
    hp(seq2) = trimmean(HeaterPower(i2-ii:i2),trim1);
    coreT(seq2)=trimmean(CoreTemp(i2-ii:i2),trim1);
    inT(seq2) = trimmean(InnerBlockTemp1(i2-ii:i2),trim1);
    outT(seq2) = trimmean(OuterBlockTemp1(i2-ii:i2),trim1);
    %all points
    qf(seq2) = trimmean(QkHz(ii:i2),trim);
    qPow(seq2) = trimmean(QPow(i1:i2),trim);
    coreQPow(seq2)=trimmean(CoreQPower(i1:i2),trim);
    v1(seq2)=trimmean(CoreQV1Rms(i1:i2),trim);
    v2(seq2)=trimmean(CoreQV2Rms(i1:i2),trim);
    qSP(seq2) = trimmean(QSupplyPower(i1:i2),trim); 
    qSV(seq2) = trimmean(QSupplyVolt(i1:i2),trim);
    qCur(seq2) = trimmean(QCur(ii:i2),trim);
    qSetV(seq2) = trimmean(QSetV(i1:i2),trim);
    termP(seq2)= trimmean(TerminationHeatsinkPower(i1:i2),trim);
    pcbP(seq2)= trimmean(QPulsePCBHeatsinkPower(i1:i2),trim);
    if tempExpFit
      ctFit(seq2,1:4) = expFit(CoreTemp(i1:i2));
      itFit(seq2,1:4) = expFit(InnerBlockTemp1(i1:i2));
    end
    if hpExpFit
      hpFit(seq2,1:4) = expFit(HeaterPower(i1:i2));  
    end  
    end
    i12(seq2)=i2-i1;
    i1 = i2+1; 
  end
end  
dt2 = datetime(dt1, 'ConvertFrom', 'datenum') ;
pdata = horzcat(coreT', inT', outT', ql', qf', hp', v1', v2', qPow', termP', pcbP', qSP', qSV', h2');
dataset({pdata,'coreT','inT','outT','ql','qf','hp','v1','v2','qPow','termP','pcbP','qSP','qSV','h2'});
%get unique ql
uniqQl = unique(ql);
uniqCT = unique(int16(coreT));
%for each ql and temp get hp0
i = 0;
j = 0;
for ti = uniqCT
  i = i + 1;  
  tdata = pdata(int16(pdata(:,1)) == ti,:);
  hp0=tdata(1,6);
  qp0=tdata(1,9);
  termP0=tdata(1,10);
 
  pcbP0 = tdata(1,11);
  for qi = uniqQl
    %q-pusle length only valid when there is q-pulse  
    if tdata(:,9)> 2      
      j = j + 1;  
      disp(ti);
      disp(qi);
      qtdata = tdata((tdata(:,4)) == qi,:);
      hpdrop(i,j) = hp0-qtdata(:,6);
      qp(i,j) = hp0-qtdata(:,9);
      tp(i,j) = hp0-qtdata(:,10);
      pp(i,j) = hp0-qtdata(:,11);
      v12(i,j)=qtdata(:,7)-qtdata(:,8);
      v122(i,j)=v12.*v12;
    end
  end
end    

fn = char(strcat('C:\jinwork\BEC\tmp\', reactors(reactor), '-', whichDate, '.csv') );          
delete(fn);
T=table(coreT(:),inT(:),outT(:),ql(:),qf(:),hp(:),coreQPow(:),v1(:),v2(:),qPow(:),qSP(:),qSV(:),qCur(:),qSetV(:),h2(:),termP(:),pcbP(:),seq1(:),i12(:),dt2(:),...
'VariableName',{'coreT','inT','outT','QL','QF','HP','CoreQPower','v1','v2','qPow','qSP','qSV','qCur','qSetV','h2','termP','pcbP','seq','steps','date'});
writetable(T,fn);
if hpExpFit 
  fileID = fopen(char(strcat('C:\jinwork\BEC\tmp\', reactors(reactor), '-', whichDate, '-hpfit.csv') ),'w');
  %fprintf(fileID,'%4s %12s\n','x','exp(x)');
  fprintf(fileID,'%6.2f %6.2f %6.2f %6.2f\n',hpFit);
  fclose(fileID);
end
if tempExpFit 
  fileID = fopen(char(strcat('C:\jinwork\BEC\tmp\', reactors(reactor), '-', whichDate, '-hpfit.csv') ),'w');
  %fprintf(fileID,'%4s %12s\n','x','exp(x)');
  fprintf(fileID,'%6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f\n',ctFit,itFit);
  fclose(fileID);
end
end
