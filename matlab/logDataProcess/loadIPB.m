%clean  
QPulseLengthns = QPulseLength0x28ns0x29; clear QPulseLength0x28ns0x29

%SeqStepNum = SeqStep0x23; clear SeqStep0x23    
power = 'q';
if isDC
  power = 'dc';
end  
plotTitle =strcat(tmpDir,'\',tStr); 
%change datetime to number

%if version < 173  
 % SeqStepNum = SeqStep0x23; clear SeqStep0x23  
%end    
if strcmp(folder,'2016-09-30_SRI_v171-core27b') % we did not have V1 and V2 columns
    SeqStepNum = SeqStep0x23; clear SeqStep0x23  
    rawData = horzcat(dateN,...
     SeqStepNum,...
     HeaterPower,...
     CoreTemp,...
     InnerBlockTemp1,...
     InnerBlockTemp2,...
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
elseif version < 186 %no V3    
rawData = horzcat(dateN,...
     SeqStepNum,...
     HeaterPower,...
     CoreTemp,...
     InnerBlockTemp1,...
     InnerBlockTemp2,...
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
elseif version > 188 %Core T.O.F. ns
    CoreTOFns = CoreT0x2EO0x2EF0x2ENs; clear CoreT0x2EO0x2EF0x2ENs
     rawData = horzcat(dateN,...
     SeqStepNum,...
     HeaterPower,...
     CoreTemp,...
     InnerBlockTemp1,...
     InnerBlockTemp2,...
     OuterBlockTemp1,...
     OuterBlockTemp2,...
     QPulseLengthns,...
     CoreQPower,...
     CoreQV1Rms,...
     CoreQV2Rms,...
     QSupplyPower,...
     QCur,...
     QSupplyVolt,...
     CoreQV3Rms,...
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
     ValvesState,...
     CoreTOFns);
else %we added v3
    rawData = horzcat(dateN,...
     SeqStepNum,...
     HeaterPower,...
     CoreTemp,...
     InnerBlockTemp1,...
     InnerBlockTemp2,...
     OuterBlockTemp1,...
     OuterBlockTemp2,...
     QPulseLengthns,...
     CoreQPower,...
     CoreQV1Rms,...
     CoreQV2Rms,...
     QSupplyPower,...
     QCur,...
     QSupplyVolt,...
     CoreQV3Rms,...
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
%show startOffset and endOffset
DateTime(1+int16(startOffset*360))
DateTime(end - int16(endOffset*360))

n1 = int16(startOffset*360);
n2 =int16(endOffset*360);
if n1 + n2 > 0  %work around
rawData = rawData(1+n1:end-n2,:);
end

%(isnan(j1)) = -2 ;
 rawData = rawData(rawData(:,2) > 0,:); %only process data with seq
%rawData(any(isnan(rawData)),:)=[]; %take out rows with NaN but not a good code
%rawData(any(isnan(rawData),2),:)=[];
%asignColumn name 
rawDataN = dataset({rawData,'dateN',...
     'SeqStepNum',...
     'HeaterPower',...
     'CoreTemp',...
     'InnerBlockTemp1',...
     'InnerBlockTemp2',...
     'OuterBlockTemp1',...
     'OuterBlockTemp2',...
     'QPulseLengthns',...
     'CoreQPower',...
     'CoreQV1Rms',...
     'CoreQV2Rms',...
     'QSupplyPower',...
     'QCur',...
     'QSupplyVolt',...
     'CoreQV3Rms',...
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
     'ValvesState',...
     'CoreTOFns'}); 
dt = datetime(rawDataN.dateN, 'ConvertFrom', 'datenum') ;
cop = 0;
if false && googleCopPlot && strcmp(googleModel,'No') == 0
  tmp = char(strcat(googleModelPath, reactor,'\',googleModel));
  cop = doGoogleModel(rawDataN,tmp,isDC);
end  
if tsPlot
  if contains(reactor,'ipb41-44') || contains(folder,'ipb41-44')
    plotTS_ipb41(dt,hp1,hp2,cqp1,cqp2,rawDataN,plotTitle,pos,figname,cop,isDC,version,coreL,termRes);
  else
    plotTS(dt,hp1,hp2,cqp1,cqp2,temp1,temp2,rawDataN,plotTitle,pos,figname,cop,isDC,version,coreL,termRes);
  end
end 
if isDC == false && debugPlot
  plotQdebug(dt,rawDataN,plotTitle,pos,figname,version);  
end    
if isDC == false && tsMultiPlot
  figure(ftsMulitplot);
  grid on;
  grid minor;
  hold on
  plotMultiTS(dt,hp1,hp2,cqp1,cqp2,rawDataN,plotTitle);
end