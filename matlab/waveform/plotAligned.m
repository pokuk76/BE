function plotAligned(v1,v2s,v3s,M,fstMax,delta,zterm,figname,P0,P,c,alignV,alignP,riseTime,pos,tt,y,y1,visible,it1,it2)
  p2 = char(strcat('Pulse Alignment Method: mean((v1-v2)*v3)/Z = ',num2str(P),' Z=', num2str(zterm), ' propagate speed = ',num2str(c),'c rmsP/alignP = ',num2str(P0/P) ));
  
   p4 = ['\leftarrow aligned at ' num2str(alignP*100)  '% pulse amplitude'];
   p5 = ['riseTime = ' num2str(riseTime) 'ns \rightarrow' ];
  
   ifstMax = int32(fstMax);
   t1 = max(1,ifstMax - it1);
   t2 = min(ifstMax + it2,size(M,1));
   f1 = figure('Position',pos,'visible',visible);
   %if (v2s > 0 && v3s > 0)
   subplot(3,1,1);
   
   %hold on;
   suptitle(tt); 
   x = [M(ifstMax,1),M(ifstMax,1)];
   x1=[M(ifstMax-delta+v1,1),M(ifstMax-delta+v1,1)];
   dim = [0.14 0.6 0.1 0.1];
   annotation('textbox',dim,'String',p2,'FitBoxToText','on');
   hold on;
   plot(M(t1:t2,1),M(t1:t2,2),M(t1:t2,1),M(t1:t2,3),M(t1:t2,1),M(t1:t2,4))
   plot(x,y1,'black','linewidth',1);
   plot(x1,y1,'black','linewidth',1);
   grid on;
   grid minor;
   text(x1(1),y, p5,'HorizontalAlignment','right');
   hold off;
   legend('v1','v2','v3');
   set(gca,'XTick',[]);
   subplot(3,1,2);
   grid on;
   grid minor;
   hold on;
   plot(M(t1:t2,1),M(t1:t2,2),M(t1:t2-v2s,1),M(t1+v2s:t2,3),M(t1:t2-v3s-v2s,1),M(t1+v3s+v2s:t2,4))
   plot(x1,y1,'black','linewidth',1);
   grid on;
   grid minor;
   text(x1(1),alignV,p4);
   hold off;
   %dim = [0.14 0.3 0.1 0.1];
   %annotation('textbox',dim,'String',p2,'FitBoxToText','on');
   legend('v1','v2','v3');
   set(gca,'XTick',[]);
   subplot(3,1,3);
   grid on;
   grid minor;
   deltaV = (M(t1:t2-v2s,2)-M(t1+v2s:t2,3));
   P = deltaV(1:end-v3s).*M(t1+v3s+v2s:t2,4)/zterm;
   yyaxis left
   plot(M(t1:t2-v2s,1),deltaV);
   grid on;
   grid minor;
   ylabel('v1-v2');
   yyaxis right
   plot(M(t1:t2-v3s-v2s,1),P);
   ylabel('Instantaneous Pulse Power');
   export_fig(f1,figname,'-append');

end
