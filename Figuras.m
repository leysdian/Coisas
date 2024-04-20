for a=1:1:10
matriz_di(a,:) = [SLosses.Loss_Min(1,:,a)];
matriz_di1(a,:) = [SLosses.Loss_Min(:,end,a)];
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       Figuras 3D
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure
s = surf(SLosses.Potencia/paramext.Pmppt, SLosses.Fsw/1000, SLosses.Loss_Min(:,:,3));
% s.FaceColor = 'r';
title(['Nps x Fsw, Ripple de corrente: ' num2str(di*100) '%'])
xlabel('Nps')
ylabel('Frequência (kHz)')
zlabel('Perdas (kW)')
grid on
view([-47.9334603644985 20.6291666666668]);
set(gca,'FontName','times new roman','FontSize',8,'GridAlpha',0.25,...
    'GridLineStyle',':','XMinorGrid','on','YMinorGrid','on');

figure
s = surf(SLosses.Potencia/paramext.Pmppt, SLosses.di*100, matriz_di);
% s.FaceColor = 'r';
title(['Nps x Di, ' num2str(Fint/1000) ' kHz'])
xlabel('Nps')
ylabel('Ripple de corrente (%)')
zlabel('Perdas (kW)')
grid on
view([-47.9334603644985 20.6291666666668]);
set(gca,'FontName','times new roman','FontSize',8,'GridAlpha',0.25,...
    'GridLineStyle',':','XMinorGrid','on','YMinorGrid','on');

figure
s = surf(SLosses.Fsw/1000, SLosses.di*100, matriz_di1);
% s.FaceColor = 'r';
title(['Fsw x Di, ' num2str(Nps1) ' painéis em série'])
xlabel('Frequência (kHz)')
ylabel('Ripple de corrente (%)')
zlabel('Perdas (kW)')
grid on
view([-47.9334603644985 20.6291666666668]);
set(gca,'FontName','times new roman','FontSize',8,'GridAlpha',0.25,...
    'GridLineStyle',':','XMinorGrid','on','YMinorGrid','on');


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       Figura 2D
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Nps1 = find(SLosses.Potencia/paramext.Pmppt==Nps1);
Fint = find(SLosses.Fsw==Fint);
di1 = di*10;
%%Figura perdas
partSic = SLosses.loc(Fint,Nps1,di1)
figure
hold on
plot(SLosses.Potencia*Npp/1000,SLosses.Loss_Min(Fint,:,di1),'LineWidth',1,'Marker','o','DisplayName','SiC','Color',[1 0 0])
grid on
set(gca,'FontName','times new roman','FontSize',8,'GridAlpha',0.25,...
    'GridLineStyle',':','XMinorGrid','on','YMinorGrid','on');
xlabel('Potência (kW)')
ylabel('Perdas (W)')
box on