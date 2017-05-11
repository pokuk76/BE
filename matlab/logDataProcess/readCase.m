%% read cases from excel files

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ipb1_13 = readtable('ipb1-13.xlsx');
ipb1_29 = readtable('ipb1-29.xlsx');
ipb1_30 = readtable('ipb1-30.xlsx');
ipb1_40 = readtable('ipb1-40.xlsx');
ipb1_41 = readtable('ipb1-41.xlsx');

sri_ipb1_41 = readtable('sri-ipb1-41.xlsx');

sri_ipb2_27 = readtable('sri-ipb2-27.xlsx');
sri_ipb2_33 = readtable('sri-ipb2-33.xlsx');

ipb3_32 = readtable('ipb3-32.xlsx');
ipb3_37 = readtable('ipb3-37.xlsx');
ipb3_42 = readtable('ipb3-42.xlsx');

ipb4_44 = readtable('ipb4-44.xlsx');

sri_conflat_45 = readtable('sri-conflat-45.xlsx');
%analysis set
%[ipb1_30(4:5,:);ipb1_30(17:18,:);ipb1_30(22,:);ipb1_30(10,:);ipb1_30(14,:)],...
%[sri_ipb2_27(4:6,:);sri_ipb2_27(9:11,:)],...
%[ipb1_30(4:5,:);ipb1_30(17,:);ipb1_30(22,:);ipb3_32(2,:);ipb3_32(5:6,:);ipb3_37(3,:);ipb3_37(8:9,:);sri_ipb2_27(4:5,:);sri_ipb2_33(1,:)],...
%[ipb3_37(3,:);ipb3_37(8:10,:);ipb3_37(4:6,:);ipb3_37(11,:)],...
%[sri_ipb2_33(1,:);sri_ipb2_33(9:11,:);sri_ipb2_33(13:14,:)],...
aSetMap = containers.Map(...
{'10-ipb1-30-040317',...
 '11-ipb1-30',...
 '12-ipb1-13',...
 '13-ipb1-40-033117',...
 '14-ipb1-41-041717',...
 '20-sri-ipb2-27-032217',...
 '21-sri-ipb2-33-041717',...
 '30-ipb3-32',...
 '31-ipb3-37-033117',...
 '32-ipb3-42-0511-cal',...
 '40-ipb4-44-0511-cal',...
 '50-sri-conflat-45-050817',...
 '51-all-dcs-032317',...
 '6-ipb1-30-sri-ipb2-27',...
 '8-sri-ipb2-33-041817',...
 '9-ipb1',...
 '91-ipb1-29',...
 '92-ipb1-40-sri-sri-ipb1-4',...
  },...
 {[ipb1_30(5,:);ipb1_30(22,:);ipb1_30(14,:);ipb1_30(26:27,:)],...
  [ipb1_30(22,:);ipb1_30(26,:)],...
  ipb1_13(1:2,:),...
  [ipb1_40(1,:);ipb1_40(6,:);ipb1_40(11,:)],...
  [ipb1_41(1,:);sri_ipb1_41(1,:)],...
  [sri_ipb2_27(4:6,:);sri_ipb2_27(9:11,:)],...
  [sri_ipb2_33(1,:);sri_ipb2_33(9:11,:);sri_ipb2_33(14:15,:)],...
  [ipb3_32(2,:);ipb3_32(5:6,:);ipb3_32(9:11,:)],...
  [ipb3_37(8,:);ipb3_37(10,:);ipb3_37(6,:);ipb3_37(22:26,:);ipb3_37(29,:)],...
  [ipb3_42(8,:)],...
  [ipb4_44(5,:)],...
  [sri_conflat_45(1,:)],...
  [ipb1_30(5,:);ipb1_30(22,:);ipb3_37(8,:);ipb3_37(10,:);sri_ipb2_33(1,:);sri_ipb2_33(10,:);sri_ipb2_27(4,:);ipb1_40(5,:)],...
  [ipb1_30(4,:);ipb1_30(22,:);sri_ipb2_27(4,:);ipb1_30(10,:);ipb1_30(14,:);sri_ipb2_27(9,:);sri_ipb2_27(10,:)],...
  [sri_ipb2_33(14:15,:)],...
  [ipb1_30(5,:);ipb1_30(22,:);ipb1_30(14,:);ipb1_30(26,:)],...
  ipb1_29(3:4,:),...
  [ipb1_40(1:11,:);ipb1_40(14:15,:)]
  });
descSet = keys(aSetMap);
aSetdesc = char(descSet(11));
aSet = aSetMap(aSetdesc);
