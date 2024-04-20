function out = Total_Losses_Mosfet_CC(param,paramext,Corrente,Vds_in,Fsw1)
% Desencapsulando os parâmetros externos
Vds_Max=param.Data(:,1);
I_25=param.Data(:,2);
I_100=param.Data(:,3);
Rds_25 = param.Data(:,4)*1e-3;
Rds_Temp = param.Data(:,5)*1e-3;
Temp_Rds = param.Data(:,6);
Rg_open_drain=param.Data(:,7);
Ciss=param.Data(:,8)*10^-12;
V_Th=param.Data(:,9);
V_Plateau=param.Data(:,10);
Cgd_Vds=param.Data(:,11)*10^-12;
Cgd_20=param.Data(:,12)*10^-12; 
TJC=param.Data(:,13); 
Pmax=param.Data(:,15); 
n_Mosfets=param.Data(:,16);
n_Mos = max(n_Mosfets);


%Frequency
Fsw = Fsw1;

%Parameters
Vds = Vds_in;
Rg = paramext.Rg;
Vdr = paramext.Vdr;
Tj = paramext.Tj;
Ids = Corrente;

%Frequency
Frede = paramext.Frede;
%período da rede
Tseno = 1/Frede;%periodo de rede
Ta = paramext.Ta;
    
sp = Ids;
sp(sp<=0)=0;
sn = Ids;
sn(sn>=0)=0;
Sp = sp;
Sn = sn;
Irms= rms(Ids);
Imax=max(Ids);

for n=1:1:n_Mos %Laço em função da quantidade de transistores no banco de dados
Ids2 = abs(Ids);

%Conduction losses  Adapted from Graovac2006
Alpha=100*(((Rds_Temp(n)/Rds_25(n))^(1/(Temp_Rds(n)-25)))-1);%Coeficiente de temperatura
%Rds_On=Rds_25*((1+Alpha/100)^(Tj-25));%Resistência de condução
% Switching losses
Ig_On = (Vdr-V_Plateau(n))/(Rg+Rg_open_drain(n)); %Gate current
Ig_Off = V_Plateau(n)/(Rg+Rg_open_drain(n)); %Gate current
Cg = Ciss(n);
Q = (Cgd_Vds(n)*Vds+Cgd_20(n)*(0.135*Vds))/2 + Cg*(V_Plateau(n)-V_Th(n));


Tsw = 1/Fsw; %periodo de cada comutação
%Criando um contador de período de comutação
Amostras = floor(Tseno*Fsw); %numero de comutações em um ciclo
VETOR_Tsw = floor(Tsw*(length(Ids2))/Tseno); %numero de amostras em uma comutação

%Laço da frequência
 for a=1:1:Amostras %Pegando 1 comutação de cada vez
        if a==1
            inicial(a)=a;
        end
        if a>1
            inicial(a)=(a-1)*VETOR_Tsw+1;
        end
        final(a)=a*VETOR_Tsw;
        
        Ids1 = Ids2;
     
        Cont(:,a)=Ids1(inicial(a):final(a));%Alocando os valores de cada comutação em colunas
        M1(:,a) = abs(Cont(:,a));%valores positivos
        
        I = find (M1(:,a)>0.1);
        J(:,a) = numel(I);
        K(:,a) = sum(M1(:,a));
        I_Med(a) = K(:,a)/J(:,a);
                      
Esw(a) =(1/2)*((Q/Ig_On)*Vds*I_Med(a)+ (Q/Ig_Off)*Vds*I_Med(a));
% clear('Cont','J','K','M1')
%  end
% Psw(n,MaxIt) = sum(Esw(~isnan(Esw)))*Frede;
% else
%    Psw(n,MaxIt) = Psw(n,1)*(Fsw(MaxIt)/Fsw(1)); 
% end

% %           RECUPERAÇÃO
%         Cont1(:,a)=Sn(inicial(a):final(a));%Alocando os valores de cada comutação em colunas
%         M11(:,a) = abs(Cont1(:,a));%valores positivos
%         I1 = find (M11(:,a)>0);
%         J1(:,a) = numel(I1);
%         K1(:,a) = sum(M11(:,a));
%         I_Med_(a) = K1(:,a)/J1(:,a); 
%         
% Qrr(a) = I_Med_(a)* Trr/2;
% Err(a) = Qrr(a)*(1/4)*430;

 end
%   Prr(n,MaxIt) = nansum(Err)*60;
   Esw(isinf(Esw))=0;
   Psw(n) = (nansum(Esw))*Frede;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Conduction losses  Adapted from Graovac2006
Rds_On(n)=Rds_25(n)*((1+Alpha/100)^(Tj-25));%Resistência de condução

if I_100(n)>Irms && Vds_Max(n)<700 && I_100(n)< 40
    PCM(n) = Irms.^2*Rds_On(n);
else
    PCM(n) = NaN;
end

P_Tot(n) = PCM(n)+Psw(n);
end
%Buscando o # de menores perdas
Pmax=param.Data(:,15); 

    minimo = min(P_Tot);
    if isnan(minimo(1))==0
    Loss_Min = minimo(1);
    %buscando pelo #
    loc1 = find(P_Tot==Loss_Min);
    loc = loc1(1);
%     Loss_Min_PCD(a,b,c)=PC_Diodo(loc1(1),a,b);
%     Loss_Min_Prr(a,b,c)=Prr1(loc1(1),a,b);
    if Loss_Min>Pmax(loc)
       Loss_Min=NaN;
    end  
    else
        Loss_Min=NaN;
        loc = NaN;
    end
    
    
out.loc = loc;
out.Loss_Min = Loss_Min;
out.PCM = PCM;            %PERDAS POR CONDUÇÃO
out.Psw = Psw;            %PERDAS POR COMUTAÇÃO
out.Totais = P_Tot;        %PERDAS TOTAIS
out.I_Med=I_Med;
end