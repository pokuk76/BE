% Initial housekeeping
clear; close all; clc
addpath('C:\jinwork\BE\matlab')
addpath('C:\jinwork\BE\matlab\addaxis5')
addpath('C:\jinwork\BE\matlab\export_fig\altmany-export_fig-2763b78')
%Control parameters
qPlot = false; dcPlot = false; debugPlot = false; tempExpFit = false; hpExpFit = false;
postProcess = true; writeOutput = true; plotOutput = true; detailPlot = true;
errorBarPlot = false;findDuplicates = false;
%plot bounds setting
startOffset = 0;endOffset = 0;hp1 = 0;hp2 = 60; qp1 = 5;qp2 = 55;cqp1 = 0;cqp2 = 12;
%read data in
ipb1_30 = readtable('ipb1-30.xlsx');
ipb3_32 = readtable('ipb3-32.xlsx');
sri_ipb2_27 = readtable('sri-ipb2-27.xlsx');
ipb3_37 = readtable('ipb3-37.xlsx');
%analysis set
aSetMap = containers.Map(...
{'1-ipb1-30b-he-dc-q',...
 '2-sri-ipb2-27b-h2-dc-q',...
 '3-ipb3-32b-he-h2-dc-q',...
 '4-ipb3-37b-he-dc-q',...
 '5-all-dcs',...
 '6-ipb1-30b-sri-ipb2-he-h2-dc-q',...
 '7-test',...
  },...
 {[ipb1_30(4:5,:);ipb1_30(17,:);ipb1_30(10,:);ipb1_30(14,:)],...
  [sri_ipb2_27(4:6,:);sri_ipb2_27(9:10,:)],...
  [ipb3_32(2,:);ipb3_32(5:6,:);ipb3_32(9:10,:)],...
  [ipb3_37(3:4,:);ipb3_37(1,:)],...
  [ipb1_30(4:5,:);ipb1_30(17,:);ipb3_32(2,:);ipb3_32(5:6,:);ipb3_37(3,:);sri_ipb2_27(4:5,:)],...
  [ipb1_30(4,:);sri_ipb2_27(4,:);ipb1_30(10,:);ipb1_30(14,:);sri_ipb2_27(9,:);sri_ipb2_27(10,:)],...
  ipb3_37(4,:),...
  });
%need to put DC in front
descSet = keys(aSetMap);
aSetdesc = char(descSet(6));
aSet = aSetMap(aSetdesc);
figname = strcat('C:\jinwork\BEC\tmp\',aSetdesc,'.pdf');
delete(figname);
filen1 = strcat('C:\jinwork\BEC\tmp\',aSetdesc,'detail.csv');
filen2 = strcat('C:\jinwork\BEC\tmp\',aSetdesc,'.csv');
T1=cell2table(cell(0,18),...
'VariableName',{'coreT','inT','outT','QL','QF','HP','CoreQPower','v1','v2','qPow','qSP','qSV','h2','termP','pcbP','seq','steps','date'});
T2 = cell2table(cell(0,5),'VariableNames',{'coreT','innerT','R','C','M'});
pos = [10 10 1000 800];
f1=figure('Position',pos);

for ai = 1:size(aSet,1)
 reactor  = char(aSet.reactor(ai));
 folder  = char(aSet.folder(ai));
 runDate = char(aSet.runDate(ai));
 file1 = int8(aSet.file1(ai));
 file2 = int8(aSet.file2(ai)); 
 startOffset = aSet.startOffset(ai);
 endOffset = aSet.endOffset(ai);
 gas = char(aSet.gas(ai));
 isDC = aSet.isDC(ai);
 efficiency = aSet.efficiency(ai);
switch (reactor)
case 'ipb1-29'  
  rtFolder='C:\Users\Owner\Dropbox (BEC)\ISOPERIBOLIC_DATA\';    
  SeqStepNum = SeqStep0x23; clear SeqStep0x23         
case 'ipb1-30'
  rtFolder='C:\Users\Owner\Dropbox (BEC)\ISOPERIBOLIC_DATA\';      
case 'sri-ipb2-27'
  rtFolder='C:\Users\Owner\Dropbox (BEC)\SRI-IPB2\';  
case 'ipb3-32'
  rtFolder='C:\Users\Owner\Dropbox (BEC)\IPB3_DATA\';     
case 'ipb3-37'
  rtFolder='C:\Users\Owner\Dropbox (BEC)\IPB3_DATA\';       
case 'google'
  rtFolder='C:\Users\Owner\Dropbox (BEC)\BECteam\Jin\google\';
case 'test'
  rtFolder='C:\Users\Owner\Dropbox (BEC)\BECteam\Jin\google\';  
end %switch
Directory=char(strcat(rtFolder,folder));
AllFiles = getall(Directory); 
Experiment= AllFiles(file1:file2); 
Experiment'
loadHHT 
%clean
QPulseLengthns = QPulseLength0x28ns0x29; clear QPulseLength0x28ns0x29
%SeqStepNum = SeqStep0x23; clear SeqStep0x23      
plotTitle =strcat(Directory,'-',runDate); 
%change datetime to number
dateN=datenum(DateTime,'mm/dd/yyyy HH:MM:SS');
if strcmp(folder,'2016-09-30_SRI_v171-core27b') % we did not have V1 and V2 columns
    SeqStepNum = SeqStep0x23; clear SeqStep0x23  
    rawData = horzcat(dateN,...
     SeqStepNum,...
     HeaterPower,...
     CoreTemp,...
     InnerBlockTemp1,...
     OuterBlockTemp1,...
     OuterBlockTemp2,...
     QPulseLengthns,...
     CoreQPower,...
     CoreQPower,...
     CoreQPower,...
     QSupplyPower,...
     QCur,...
     QSupplyVolt,...
     QSetV,...
     QKHz,...
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
     RoomTemperature);
     %HydrogenValves);
else     
rawData = horzcat(dateN,...
     SeqStepNum,...
     HeaterPower,...
     CoreTemp,...
     InnerBlockTemp1,...
     OuterBlockTemp1,...
     OuterBlockTemp2,...
     QPulseLengthns,...
     CoreQPower,...
     CoreQV1Rms,...
     CoreQV2Rms,...
     QSupplyPower,...
     QCur,...
     QSupplyVolt,...
     QSetV,...
     QKHz,...
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
     RoomTemperature);
end
     %HydrogenValves);
%filter rawData out 
dataSize = size(rawData,1);
%find duplicated
if findDuplicates
  duplicates(coreTemp);
end
%show startOffset and endOffset
%DateTime(1+int16(startOffset*360))
%DateTime(end - int16(endOffset*360))
rawData = rawData(1+int16(startOffset*360):end-int16(endOffset*360),:);

%(isnan(j1)) = -2 ;
rawData = rawData(rawData(:,2) > 0,:); %only process data with seq
dataSize = size(rawData,1)
rawData(any(isnan(rawData)),:)=[]; %take out rows with NaN
dataSize = size(rawData,1)
rawData(any(isnan(rawData),2),:)=[];
dataSize = size(rawData,1)
%rawData(any(isnan(rawData),11),:)=[];
%dataSize = size(rawData,1)

dataSize = size(rawData,1)
%asignColumn name 
rawDataN = dataset({rawData,'dateN',...
     'SeqStepNum',...
     'HeaterPower',...
     'CoreTemp',...
     'InnerBlockTemp1',...
     'OuterBlockTemp1',...
     'OuterBlockTemp2',...
     'QPulseLengthns',...
     'CoreQPower',...
     'CoreQV1Rms',...
     'CoreQV2Rms',...
     'QSupplyPower',...
     'QCur',...
     'QSupplyVolt',...
     'QSetV',...
     'QKHz',...
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
     'PressureSensorPSI',...
     'RoomTemperature'});
     %'HydrogenValves'}); 
dt = datetime(rawDataN.dateN, 'ConvertFrom', 'datenum') ;
if isDC
  if dcPlot
    plotDC(dt,hp1,hp2,rawDataN,plotTitle,pos,figname);   
  end
else  
  if qPlot
    plotQ(dt,hp1,hp2,qp1,qp2,cqp1,cqp2,rawDataN,plotTitle,pos,figname);  
  end
  if debugPlot
    plotQdebug(dt,hp1,hp2,qp1,qp2,cqp1,cqp2,coreRes,rawDataN,plotTitle,pos,figname);  
  end    
end    
if postProcess
  %fn = char(strcat('C:\jinwork\BEC\tmp\', reactor, '-', runDate, '.csv') );        
  pdata = writeOut(rawDataN,T1,filen1,hpExpFit,tempExpFit,writeOutput);
end 
if (plotOutput)
  %plotData = dataset({pdata,'coreT','inT','outT','ql','qf','hp','v1','v2','qPow','termP','pcbP','qSP','qSV','h2'});
  %getPlotData;
  [tt,innert,hpdrop,v12,dqp,v122,hv,res,hv0,hqp0,res0] = plotSummary(pdata,isDC,efficiency,ai);
end
power = 'q';
if isDC
  power = 'dc';
end  
tStr = strcat(reactor,'-',runDate,'-',gas,'-',power);    
if detailPlot
%if isDC
f2=figure('Position',pos);
grid on;
grid minor;
hold on
for i = 1:size(tt,1)
  ylabel('V^2 / P');
  xlabel('V^2[volt]'); 
  title(tStr);
  plot(v122(:,i,ai),res(:,i,ai),'-x');
  l2{i}=strcat(power,'-',gas,'-CoreTemp=',num2str(tt(i,ai))); 
end  

legend(l2,'Location','northwest');
%ftemp=strcat('C:\jinwork\BEC\tmp\',tStr,'-V2-P.png');
%saveas(gcf,ftemp);
export_fig(f2,figname,'-append');
%end
f3=figure('Position',pos);
grid on;
grid minor;
hold on
for i = 1:size(tt,1) 
  plot(v122(:,i,ai),hpdrop(:,i,ai),'-o');
  ylabel('HpDrop[w]');
  ylim([0 7]);
  xlabel('V^2[volt]'); 
  title(tStr);
  l3{i}=strcat(power,'-',gas,'-CoreTemp=',num2str(tt(i,ai))); 
end  
legend(l3,'Location','northwest');
export_fig(f3,figname,'-append');

f4=figure('Position',pos);
grid on;
grid minor;
hold on
for i = 1:size(tt,1) 
  plot(dqp(:,i,ai),hpdrop(:,i,ai),'-o');
  ylabel('HpDrop[w]');
  ylim([0 7]);
  xlabel('P[w]'); 
  title(tStr);
  l4{i}=strcat(power,'-',gas,'-CoreTemp=',num2str(tt(i,ai))); 
end  
legend(l4,'Location','northwest');
export_fig(f4,figname,'-append');
%ftemp=strcat('C:\jinwork\BEC\tmp\',tStr,'-HpD-V2.png');
%saveas(gcf,ftemp);
end
tailx=0.2;
taily=0.4;
marg=0.05;
y1=0.55;
y2=0.1;
x0=0.02;
v=zeros(4,4);
v(1,:) = [x0  y1 tailx  taily] ; 
for k=2:4
  v(k,1)=v(k-1,1)+tailx+marg;
end
v(:,2)=y1;
v(:,3)=tailx;
v(:,4)=taily;

figure(f1);
h=subplot(2,2,1);

%if isDC
grid on;
grid minor;
hold on;
plot(tt(:,ai),res0(:,ai),'-o');
set(gca,'XTick',[]);
set(gca,'position',v(1,:))
xlim([200 400]);
ytemp = strcat('V^2 / P');
ylabel(ytemp);
l1{ai}=tStr;
%end

subplot(2,2,2);
grid on;
grid minor;
hold on;
plot(tt(:,ai),hv0(:,ai),'-o');
set(gca,'XTick',[]);
set(gca,'position',v(2,:))
xlim([200 400]);
ytemp = strcat('HpDrop / V^2');
ylabel(ytemp);
l1{ai}=tStr;
subplot(2,2,3);
grid on;
grid minor;
hold on;
plot(tt(:,ai),hqp0(:,ai),'-o');
set(gca,'position',v(3,:))
xlim([200 400]);
ytemp = strcat('HpDrop / P');
ylabel(ytemp);
subplot(2,2,4);
grid on;
grid minor;
hold on;
plot(tt(:,ai),innert(:,ai),'-o');
set(gca,'position',v(4,:))
xlim([200 400]);
ytemp = strcat('Inner Temp');
ylabel(ytemp);
l1{ai}=tStr;
T2 =[T2;table(tt(:,ai),innert(:,ai),res0(:,ai),hv0(:,ai),hqp0(:,ai),'VariableNames',{'coreT','innerT','R','C','M'})];
end
%legend(ll,'Location','SouthOutside');
legend(l1,'Location','NorthOutside','Orientation','horizontal');
export_fig(f1,figname,'-append');
writetable(T2,filen2);

