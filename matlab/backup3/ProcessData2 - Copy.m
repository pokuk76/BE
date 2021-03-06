% Initial housekeeping
clear; close all; clc
addpath('C:\jinwork\BE\matlab')
addpath('C:\jinwork\BE\matlab\addaxis5')
addpath('C:\jinwork\BE\matlab\export_fig\altmany-export_fig-2763b78')
%Control parameters
qPlot = false; dcPlot = false; debugPlot = false; tempExpFit = false; hpExpFit = false;
postProcess = true; writeOutput = false; plotOutput = true; detailPlot = true;
errorBarPlot = false;findDuplicates = false;
%plot bounds setting
coreRes = 0.5;startOffset = 0;endOffset = 0;hp1 = 0;hp2 = 40; qp1 = 5;qp2 = 55;cqp1 = 0;cqp2 = 12;

ipb1_30 = readtable('ipb1-30.xlsx');
ipb3_32 = readtable('ipb3-32.xlsx');
sri_ipb2_27 = readtable('sri-ipb2-27.xlsx');
ipb3_37 = readtable('ipb3-37.xlsx');
%aySet = struct('1',{[sri_ipb2_27(3,:);ipb3_37]; 'ipb1-30b-he-dc-g'});

aSet = [sri_ipb2_27(3,:);ipb3_37];

aSetdesc = 'ipb1-30b-he-dc-q';
aSet = [ipb1_30(4,:);ipb1_30(9,:)];

aSetdesc = 'sri-ipb2-27b-h2-dc-q';
aSet  =[sri_ipb2_27(4,:);sri_ipb2_27(9,:)];

aSetdesc = 'ipb1-30b-he-dc-q';
aSet = [ipb1_30(4,:);ipb1_30(9,:)];

aSetdesc = 'ipb1-30b-q-excitation';
aSet = [ipb1_30(12,:)];

aSetdesc = 'sri-ipb2-27b-h2-dc-q';
aSet  =[sri_ipb2_27(4,:);sri_ipb2_27(9,:)];

aSetdesc = 'ipb1-30b-he-dc-q';
aSet = [ipb1_30(4,:);ipb1_30(10,:)];

aSetdesc = 'ipb1-30b-sri-ipb2-27-DC-runs';
aSet = [ipb1_30(4,:);ipb1_30(5,:);sri_ipb2_27(4,:);sri_ipb2_27(5,:)];
aSetdesc = 'ipb1-30b-he-dc-q-sri-ipb2-h2-dc-q';
aSet = [ipb1_30(4,:);ipb1_30(9,:);sri_ipb2_27(4,:);sri_ipb2_27(9,:)];
%ai needs to start with 1 and continues for now.
figname = strcat('C:\jinwork\BEC\tmp\',aSetdesc,'.pdf');
delete(figname);
f1=figure('Position',[10 10 1000 800]);

for ai = [1,2,3,4]
 reactor  = char(aSet.reactor(ai));
 folder  = char(aSet.folder(ai));
 runDate = num2str(aSet.runDate(ai));
 file1 = int8(aSet.file1(ai));
 file2 = int8(aSet.file2(ai));
 startOffset = aSet.startOffset(ai);
 endOffset = aSet.endOffset(ai);
 isHe = aSet.isHe(ai);
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
%rawData(any(isnan(rawData)),:)=[]; %take out rows with NaN
%(isnan(j1)) = -2 ;
rawData = rawData(rawData(:,2) > 0,:); %only process data with seq
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
if dcPlot
  plotDC(dt,hp1,hp2,rawDataN,plotTitle);   
end 
if qPlot
  plotQ(dt,hp1,hp2,qp1,qp2,cqp1,cqp2,coreRes,rawDataN,plotTitle);  
end 
if debugPlot
   plotQdebug(dt,hp1,hp2,qp1,qp2,cqp1,cqp2,coreRes,rawDataN,plotTitle);  
end   
if postProcess
 fn = char(strcat('C:\jinwork\BEC\tmp\', reactor, '-', runDate, '.csv') );        
 pdata = writeOut(rawDataN,fn,hpExpFit,tempExpFit,writeOutput);
end 
if (plotOutput)
  plotData = dataset({pdata,'coreT','inT','outT','ql','qf','hp','v1','v2','qPow','termP','pcbP','qSP','qSV','h2'});
  [tt,hpdrop,v12,dqp,v122,hv,res,termp,pcbp,hv0,hqp0,res0] = plotSummary(pdata,plotData,isDC,isHe,efficiency,ai);
end
power = 'q';
if isDC
  power = 'dc';
end  
gas = 'h2';
if isHe
  gas = 'he';
end 
if detailPlot
tStr = strcat(reactor,'-',power,'-',gas);    
f2=figure('Position',[10 10 1000 800]);
grid on;
grid minor;
hold on
for i = 1:size(tt,1) 
  plot(v122(:,i,ai),hpdrop(:,i,ai),'-o');
  ylabel('HpDrop[w]');
  xlabel('V^2[volt]'); 
  title(tStr);
  labels{i}=strcat(power,'-',gas,'-CoreTemp=',num2str(tt(i,ai))); 
end  
legend(labels,'Location','northwest');
export_fig(f2,figname,'-append');
f3=figure('Position',[10 10 1000 800]);
grid on;
grid minor;
hold on
for i = 1:size(tt,1)
    ylabel('HpDrop[w]');
    xlabel('coreQP[w]');
    title(tStr);
    plot(dqp(:,i,ai),hpdrop(:,i,ai),'-*');
    labels{i}=strcat(power,'-',gas,'-CoreTemp=',num2str(tt(i,ai))); 
end  
legend(labels,'Location','northwest');
export_fig(f3,figname,'-append');
f4=figure('Position',[10 10 1000 800]);
grid on;
grid minor;
hold on
for i = 1:size(tt,1)
  ylabel('V^2 / Power');
  xlabel('V^2[volt]'); 
  title(tStr);
  plot(v122(:,i,ai),res(:,i,ai),'-x');
  labels{i}=strcat(power,'-',gas,'-CoreTemp=',num2str(tt(i,ai))); 
end  
legend(labels,'Location','northwest');
export_fig(f4,figname,'-append');
if ~isHe
f5=figure('Position',[10 10 1000 800]);
grid on;
grid minor;
hold on
for i = 1:size(tt,1)
  ylabel('TermP');
  xlabel('V^2[volt]'); 
  title(tStr);
  plot(v122(:,i,ai),termp(:,i,ai),'-x');
  labels{i}=strcat(power,'-',gas,'-CoreTemp=',num2str(tt(i,ai))); 
end  
legend(labels,'Location','northwest');
export_fig(f5,figname,'-append');
f6=figure('Position',[10 10 1000 800]);
grid on;
grid minor;
hold on
for i = 1:size(tt,1)
  ylabel('pcbP');
  xlabel('V^2[volt]'); 
  title(tStr);
  plot(v122(:,i,ai),pcbp(:,i,ai),'-x');
  labels{i}=strcat(power,'-',gas,'-CoreTemp=',num2str(tt(i,ai))); 
end  
legend(labels,'Location','northwest');
export_fig(f6,figname,'-append');
end
end
figure(f1);
subplot(2,2,1);
grid on;
grid minor;
hold on;
plot(tt(:,ai),hv0(:,ai),'-o');
xlim([150 400]);
ytemp = strcat('HpDrop / V^2');
ylabel(ytemp);
subplot(2,2,2);
grid on;
grid minor;
hold on;
plot(tt(:,ai),hqp0(:,ai),'-o');
xlim([150 400]);
ytemp = strcat('HpDrop / Power');
ylabel(ytemp);
subplot(2,2,3);
grid on;
grid minor;
hold on;
plot(tt(:,ai),res0(:,ai),'-o');
xlim([150 400]);
ytemp = strcat('V^2 / Power');
ylabel(ytemp);
subplot(2,2,4);
grid on;
grid minor;
hold on;
plot(tt(:,ai),hpdrop(end-1,:,ai),'-o');
xlim([150 400]);
ytemp = strcat('HpDrop');
ylabel(ytemp);
ll{ai}=strcat(reactor,'-',power,'-',gas);
legend(ll,'Location','SouthOutside');
export_fig(f1,figname,'-append');
end

