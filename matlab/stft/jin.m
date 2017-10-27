clear; close all; clc
addpath('C:\jinwork\BE\matlab\waveform')
addpath('C:\jinwork\BE\matlab\altmany-export_fig-5be2ca4')
addpath('C:\jinwork\BE\matlab\FrequencyAnalysisExample');
outputPath ='C:\jinwork\BEC\tmp\';
home = [getenv('HOMEDRIVE') getenv('HOMEPATH')];
if contains(home,'admin')
  dataPath = 'C:\Users\admin\Dropbox (BEC)\Jin\waveform\';
else
  dataPath = 'D:\DropBox\Dropbox (BEC)\Jin\waveform\';
end  
debug = false;

visible = 'on';
%control parameters
plotSummary = true; plotPos = true; plotNeg = true; plotCN = true; plotErrBar = true;
fftAnalysis = true;

fn = char(strcat(dataPath,'waveform.xlsx'));
waveform = readtable(fn);

input = [waveform(86:86,:)]; 
figname = 'ipb3-39-10us-35v.pdf';
filen1 = strcat(outputPath, strrep(figname, '.pdf', '.csv'));
figname = strcat(outputPath,figname);
numWaveform = size(input,1);
vfactor = 0.94;% off 0.6 seconds for each 10 seconds q-pulse measurement.
nh = 21; %waveform file header lines
s2ns = 1e9; %second to ns
hz2kHz = 1e3; %hz to kHz
Fs = 2.5*1e9; %sampling frequency 2.5 gHz.
inchNs = 0.0847253; %  speed light in unit [inch/ns]
output1 = cell2table(cell(0,34),...
'VariableName',{'folder','date','filename','pulseWidth','frequency','Zterm','CoreQPow','v1rms','v2rms','v3rms',...
'alignPowerPos','cPosM','riseTimePosM','dvdtPosM','riseTime12PosM','dvdt12PosM','cPosCV','riseTimePosCV','dvdtPosCV','riseTime12PosCV','dvdt12PosCV',...
'alignPowerNeg','cNegM','riseTimeNegM','dvdtNegM','riseTime12NegM','dvdt12NegM','cNegCV','riseTimeNegCV','dvdtNegCV','riseTime12NegCV','dvdt12NegCV',...
'noise','type'});
delete(figname);
pos = [10 10 1000 800];
for wi = 1:numWaveform
   folder = input.folder(wi);
   dateN = input.date(wi);
   filename = input.filename(wi)
   voltage = input.voltage(wi);
   
   zterm = input.zterm(wi);
   filterCount = input.filterCount(wi);
   alignP = input.alignP(wi); %where v1,v2 and v3 aligned 0.05 or 0.1
   mFactor = input.mFactor(wi); %where riser time peak 
   input_frequency = input.frequency(wi); %kHz-Hz
   delta = input.delta(wi); %use the range to seach the 
   coreL = input.coreL(wi);  %core length in inch
   pulseWidth = input.pulseWidth(wi); %ns
   panelDivision = input.panelDivision(wi); %vol
   filterValue = filterCount/256 * panelDivision *4; 
   type = input.type(wi); 
   tt = char(strcat(folder,'-',dateN,'-',filename,'-',type));
   fn = char(strcat(dataPath,folder,'\',filename));
   %read in big file  
   M = csvread(fn,nh,0);
   totalTime = M(end,1) - M(1,1);
   numPoint = size(M,1);
   timeInterval = totalTime/(numPoint-1); %sec
   pulseWidthPoint = pulseWidth/timeInterval/s2ns;
   %take out 
   M0 = M(isfinite(M(:,2)),2);
   %if there is inf, there is no sense to align them.   
   if size(M0,1) < numPoint
     msg = strcat('file:',filename,'has inf');  
     disp(msg);  
     continue;
   end   
   max2 = max(M(:,2));
   min2 = min(M(:,2));
   switch char(type)
       case {'square';'Trapezoid'}
        %mVolt = min(max2,-min2); %
        mVolt = 0.5*voltage; %regular pulse causes the over shoot, and max and min actuall 10% higher than desired. 
        it1 = delta;
        it2 = 3*delta; %it2=max(1000,pulseWidthPoint+0.5*delta);
        ift1 = 3*delta;
       case {'square-lpf'} %low pass filter cause the voltage not reach the desired peak
        mVolt = min(max2,-min2);
        it1 = 2*delta;
        it2 = 3*delta; %it2=max(1000,pulseWidthPoint+0.5*delta);  
        ift1 = 6*delta;
       case {'singleNarrow'}
        mVolt = min(max2,-min2);
        it1 = delta;
        it2 = 3*delta;
        ift1 = 3*it1;
       case {'dualNarrow'}
        mVolt = min(max2,-min2);
        it1 = 10*delta; %min(1000,pulseWidthPoint+0.5*delta);
        ift1 = it1;
        it2 = 3*delta;  
   end   
 
   lc10 = []; lc20 = []; lc1 = []; lc2 = [];
   %find the peaks near min and max of the waveform instead intended peaks.
   [pk10,lc10] = findpeaks(M(:,2),'MinPeakHeight',mFactor*max2,'MinPeakDistance',pulseWidthPoint);
   [pk20,lc20] = findpeaks(-M(:,2),'MinPeakHeight',-mFactor*min2,'MinPeakDistance',pulseWidthPoint);
   %eliminate the first peak if it is too close to the edge.
   %eliminate the last peak if it is too close to the edge.
   if lc10(1) < delta 
     lc10(1) = [];
   end
   if lc10(end) > numPoint - delta 
     lc10(end) = [];
   end  
   if lc20(1) < delta
     lc20(1) = [];
   end
   if lc20(end) > numPoint - delta
     lc20(end) = [];
   end 
   
   numOfPulse = size(lc10,1)+size(lc20,1); %count a positive pulse and a negtive pulse as two pulses
   
   frequency = int32(numOfPulse/totalTime/hz2kHz); %kHz as the frequency unit
   
   M0 = M(:,2:3);
   %clean noise at the floor  
   M0(abs(M0) <= filterValue*8)= 0;
  
  
   %pickup one period   
   t1 = int32(lc10(1)-ift1);
     
   t2 = int32(lc10(3)-ift1);
   M1 = horzcat(M(:,1),M0(:,1:2));
    %take out DC
   %M1(t1:t2,2) = M1(t1:t2,2)-mean(M1(t1:t2,2));
   %M1(t1:t2,3) = M1(t1:t2,3)-mean(M1(t1:t2,3));
  
   nfft = length(M1(t1:t2,1));
     bin = Fs/nfft
     segmentLength = int32(nfft/640);
     infft2 = int32(nfft/2);
     F = ((0:1/nfft:1-1/nfft)*Fs).';
     f1 = figure('Position',pos,'visible',visible);
     subplot(2,2,1)
     suptitle(tt); 
     x = M1(t1:t2,1)-M1(t1,1);
     plot(x,M1(t1:t2,2),x,M1(t1:t2,3)); 
     grid on;
     grid minor;
     ylabel('[volt]');
     xlabel('time[s]');
     legend('v1','v2','v3');
    
     %axis tight  
     %nfft = length(M(:,1)); 
     Y1 = fft(M1(t1:t2,2),nfft);
     
     Y2 = fft(M1(t1:t2,3),nfft);
   
     mY1 = abs(Y1);
     
     mY2 = abs(Y2);
   
     pY1 = unwrap(angle(Y1));
     pY2 = unwrap(angle(Y2));
   
    
  
     Y11 = fftshift(Y1);
 
     
     subplot(2,2,2)
      [PSD1,F1]  = pwelch(M1(t1:t2,2),ones(segmentLength,1),0,nfft,Fs,'psd');
      [PSD2,F2]  = pwelch(M1(t1:t2,3),ones(segmentLength,1),0,nfft,Fs,'psd');
      plot(F1/1e6,10*log10(PSD1),F2/1e6,10*log10(PSD2));
           grid on;
     grid minor;
           xlabel('Frequency in MHz');
      ylabel('Power spectrum density (dBW)');
      legend('v1','v2');
      ax = axis;
     axis([0 500 ax(3:4)])
     %%
     %%mY1(1) = 0;% remove the DC component for better visualization
     %%plot(F(1:nfft/2)/1e6, 10*log10(mY1(1:nfft/2)),F(1:nfft/2)/1e6, 10*log10(mY2(1:nfft/2)));
     %%title('magnitude response');
     %%xlabel('Frequency (MHz)');
     %%ylabel('magnitude');
     %%legend('v1','v2');
     %%ax = axis;
     %%
     axis([0 500 ax(3:4)])
     subplot(2,2,3)
     plot(F(1:nfft/2)/1e6,pY1(1:nfft/2),F(1:nfft/2)/1e6,pY2(1:nfft/2));
          grid on;
     grid minor;
     legend('v1','v2');
     xlabel('Frequency in MHz')
     ylabel('radians')
    
     axis tight
     [P1,F1]=periodogram(M1(t1:t2,2),[],nfft,Fs,'power');
     [P2,F2]=periodogram(M1(t1:t2,3),[],nfft,Fs,'power');
     
     P1dBW = 10*log10(P1);
     power_at_DC_dBW1 = P1dBW(F==0)   % dBW
     fp = floor(power_at_DC_dBW1);
     [peakPowers_dBW, peakFreqIdx] = findpeaks(P1dBW,'minpeakheight',fp);
     peakFreqs_Hz = F(peakFreqIdx);
     np = length(peakFreqs_Hz)
     peakPowers_dBW;
    
    
     [P1,F1] = pwelch(M1(t1:t2,2),ones(segmentLength,1),0,nfft,Fs,'power');
     [P2,F2] = pwelch(M1(t1:t2,3),ones(segmentLength,1),0,nfft,Fs,'power');
     
     subplot(2,2,4)
    % plot(F1/1e6,10*log10(P1),F2/1e6,10*log10(P2),F3/1e6,10*log10(P3));
     plot(F1/1e6,10*log10(P1),F1/1e6,10*log10(P2));
          grid on;
     grid minor;
      xlabel('Frequency in MHz');
      ylabel('Power spectrum (dBW)');
      legend('v1','v2');
     ax = axis;
     axis([0 500 ax(3:4)])
     export_fig(f1,figname,'-append');
     
     f2 = figure('Position',pos,'visible',visible);
     subplot(2,2,1)
     plot(F(1:nfft/2)/1e6, 20*log10(mY1(1:nfft/2)));
     title('magnitude FFT');
     xlabel('Frequency (mHz)');
     ylabel('magnitude');
     ax = axis;
     axis([0 300 ax(3:4)])
    %axis([0 peakFreqs_Hz(np)/1e6 ax(3:4)])
  
     win = hamming(nfft/640);
     size(win)
     win = repmat(win,640);
     %takeoff 
     j0 = nfft - size(win,1);
     
      y = M1(t1:t2-j0,2).*win;
     ydft = fft(y);
      subplot(2,2,2)
     plot(F(1:nfft/2)/1e6, 20*log10(abs(ydft(1:nfft/2))));
      title('magnitude FFT-hamming');
    xlabel('Frequency (mHz)');
    ylabel('magnitude');
          ax = axis;
     axis([0 300 ax(3:4)])
     win = hann(nfft);
     %win = barthannwin(nfft);
      y = M1(t1:t2,2).*win;
     ydft = fft(y);
      subplot(2,2,3)
     plot(F(1:nfft/2)/1e6, 20*log10(abs(ydft(1:nfft/2))));
      title('magnitude FFT-hann');
    xlabel('Frequency (mHz)');
    ylabel('magnitude');
          ax = axis;
     axis([0 300 ax(3:4)])
     
     win = gausswin(nfft);
      y = M1(t1:t2,2).*win;
     ydft = fft(y);
          subplot(2,2,4)
          
     plot(F(1:nfft/2)/1e6, 20*log10(abs(ydft(1:nfft/2))));
      title('magnitude FFT-gausswin');
    xlabel('Frequency (mHz)');
    ylabel('magnitude');
          ax = axis;
     axis([0 300 ax(3:4)])
      export_fig(f2,figname,'-append');  
  
  
 % perform STFT
 if false
 wlen = 1024*10;
 hop = wlen/4;
[S, f, t] = stft(M1(t1:t2,2), wlen, hop, nfft, Fs);

% define the coherent amplification of the window
K = sum(hamming(wlen, 'periodic'))/wlen;

% take the amplitude of fft(x) and scale it, so not to be a
% function of the length of the window and its coherent amplification
S = abs(S)/wlen/K;

% correction of the DC & Nyquist component
if rem(nfft, 2)                     % odd nfft excludes Nyquist point
    S(2:end, :) = S(2:end, :).*2;
else                                % even nfft includes Nyquist point
    S(2:end-1, :) = S(2:end-1, :).*2;
end

% convert amplitude spectrum to dB (min = -120 dB)
S = 20*log10(S + 1e-6);

% plot the spectrogram
figure;
surf(t, f, S)
shading interp
axis tight
box on
view(0, 90)
set(gca, 'FontName', 'Times New Roman', 'FontSize', 14)
xlabel('Time, s')
ylabel('Frequency, Hz')
title('Amplitude spectrogram of the signal')

handl = colorbar;
set(handl, 'FontName', 'Times New Roman', 'FontSize', 14)
ylabel(handl, 'Magnitude, dB')
 end
 % 
   
end
     