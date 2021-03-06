% Create palette
%palette = hsv(K + 1);
%colors = palette(idx, :);
%set dc vs.q and he vs.h2
%get unique coreT
uniqCT = unique(int16(pdata(:,1)));
%tt=[];hpdrop=[];qp=[];tp=[];pp=[];v12=[];v122=[];
i = 0;
for ti = 1:numel(uniqCT)
  tdata = pdata(int16(pdata(:,1)) == uniqCT(ti),:);
  %exception 
  %we have to have at least 4 data points the first row needs to be no powerfor 
  if size(tdata,1) > 4 && tdata(1,9) < 5
  i = i + 1;
  tt(i,ai) = uniqCT(ti);
  %condition is pdata.coreQPow = 0
 % if tdata(1,9) < 5
 % assume the first row in the temperature mode is no q and dc power.
    hp0 = tdata(1,6);
    qp0 = tdata(1,9);
    termP0 = tdata(1,10);
    pcbP0 = tdata(1,11);
 % else   
    %hp0=tdata(end,6));
    %qp0=tdata(end,9);
    %termP0=tdata(end,10);
    %pcbP0 = tdata(end,11);
%  end  
  if isDC 
    qtdata = tdata(2:end-1,:);
    hpdrop(1:3,i,ai) = hp0-qtdata(:,6);
    v12(1:3,i,ai)= qtdata(:,13);%qsupplyPower
    corep(1:3,i,ai) = qtdata(:,12); %power    
  else    
    qtdata = tdata(2:end-1,:);
    hpdrop(:,i,ai) = hp0-qtdata(:,6);
    v12(:,i,ai)= qtdata(:,7)-qtdata(:,8) ;
    qp(:,i) = qtdata(:,9) - qp0;
    termp(:,i,ai) = qtdata(:,10) - termP0;
    pcbp(:,i,ai) = qtdata(:,11) - pcbP0;
    corep(:,i,ai) = qp(:,i)-(termp(:,i,ai)+pcbp(:,i,ai))/efficiency;
  end  
  end
end
%stripout zeros
v12_1=v12
v122=v12.*v12;
  hv = hpdrop./v122;
  res = v122./corep;
  hv0(i,ai) = v122(:,i,ai)\hpdrop(:,i,ai);  
  hqp0(i,ai) = corep(:,i,ai)\hpdrop(:,i,ai);   
  res0(i,ai) = corep(:,i,ai)\v122(:,i,ai);
  

