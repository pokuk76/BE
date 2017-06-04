function plotCNs(posArray,negArray,pos,figname,tt,visible)
  f5 = figure('Position',pos,'visible',visible);
   %if (v2s > 0 && v3s > 0)
   subplot(2,1,1)
   %hold on;
   suptitle(tt); 
   plot(posArray(:,1),posArray(:,2),'-x')
   grid on;
   grid minor;
   yyaxis left
   ylabel('c');
   yyaxis right
   plot(posArray(:,1),posArray(:,3),'-o');
   grid on;
   grid minor;
   ylabel('RiseTime');
   
   subplot(2,1,2)
   grid on;
   grid minor;
   %hold on; 
   plot(negArray(:,1),negArray(:,2),'-x')
   grid on;
   grid minor;
   yyaxis left
   ylabel('c');
   yyaxis right
   plot(negArray(:,1),negArray(:,3),'-o');
   grid on;
   grid minor;
   ylabel('RiseTime');
   export_fig(f5,figname,'-append');

end
