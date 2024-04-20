function out = Total_Losses_IGBT_Senoide(paramext,paramIGBT,Selecao)
if Selecao == 1
Ids_ = paramext.Ids;
% Correntes em cada semiciclo
sp = paramext.Ids;
sp(sp<=0)=0;
sn = paramext.Ids;
sn(sn>=0)=0;
else
Ids_ = paramext.Ids2;
% Correntes em cada semiciclo
sp = paramext.Ids2;
sp(sp<=0)=0;
sn = paramext.Ids2;
sn(sn>=0)=0;
end
Fsw = paramext.Fsw1:paramext.step:paramext.Fsw2;
Loop = length(Fsw);
% Desencapsulando os parâmetros externos
Vds = paramext.Vds;
Tj = paramext.Tj;
Ta = paramext.Ta;
kVce = paramext.kVce;
kRg = paramext.kRg;
%
% Rth = paramext.Rth;%Resistência térmica obtida em regime
% Cth = paramext.Cth;%Capacitância térmica obtida em regime
%Frequency
Frede = paramext.Frede;
%período da rede
Tseno = 1/Frede;%periodo de rede
%% Desencapsulando os parametros do transistor
Uce0 = paramIGBT.Uce0;
rc = paramIGBT.rc;
Vds_Max = paramIGBT.Vds_Max;
I_100 =paramIGBT.I_100;
RJC = paramIGBT.RJC;
% Pmax=param.Pmax;
%% Desencapsulando os parametros do diodo
Ud0 = paramIGBT.Ud0;
rd = paramIGBT.rd;
Trr = paramIGBT.Trr;
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Criando os vetores vazios para alocar os vetores dependentes da quantidade
%de frequencias verificadas
empty_individual = [];
Tsw = repmat(empty_individual,1,Loop);
Amostras = repmat(empty_individual,1,Loop);
VETOR_Tsw = repmat(empty_individual,1,Loop);
% Psw = repmat(empty_individual,1,Loop);
% PCM = repmat(empty_individual,1,Loop);
P_Tot = repmat(empty_individual,1,Loop);
% RCA = repmat(empty_individual,1,Loop);

%Criando os vetores vazios para alocar os vetores dependentes das amostras
%em um ciclo
inicial = repmat(empty_individual,1,length(Amostras));
final = repmat(empty_individual,1,length(Amostras));
Eon = repmat(empty_individual,1,length(Amostras));
Eoff = repmat(empty_individual,1,length(Amostras));
%Criando os vetores vazios para alocar os vetores dependentes das amostras
%em uma comutação e um ciclo
Cont = repmat(empty_individual,length(VETOR_Tsw),length(Amostras));
M1 = repmat(empty_individual,length(VETOR_Tsw),length(Amostras));
J = repmat(empty_individual,length(VETOR_Tsw),length(Amostras));
K = repmat(empty_individual,length(VETOR_Tsw),length(Amostras));
I_Med = repmat(empty_individual,1,length(Amostras));

for Pot=1:1:6
Ids = Ids_(:,Pot);
Sp = sp(:,Pot);
Sn = sn(:,Pot);
%Obtenção da corrente média e rms no transistor
Icav = mean(Sp);
Icrms = rms(Sp);
Imax = max(Ids);
%Obtenção da corrente média e rms no diodo
Idav = mean(Sn);
Idav = Idav*-1;
Idrms = rms(Sn);

Fsw1 = 15e3;
for MaxIt=1:1:Loop
Tsw(MaxIt) = 1/Fsw1; %periodo de cada comutação
%Criando um contador de período de comutação
Amostras(MaxIt) = floor(Tseno*Fsw1); %numero de comutações em um ciclo
VETOR_Tsw(MaxIt) = floor(Tsw(MaxIt)*(length(Ids))/Tseno); %numero de amostras em uma comutação

if MaxIt ==1
%Laço da frequência 
%CALCULA AS PERDAS DE COMUTAÇÃO SOMENTE EM CORRENTES POSITIVAS
 for a=1:1:Amostras(MaxIt) %Pegando 1 comutação de cada vez
        if a==1
            inicial(a)=a;
        end
        if a>1
            inicial(a)=(a-1)*VETOR_Tsw(MaxIt)+1;
        end
        final(a)=a*VETOR_Tsw(MaxIt);
        
        Cont(:,a)=Sp(inicial(a):final(a));%Alocando os valores de cada comutação em colunas
        M1(:,a) = abs(Cont(:,a));%valores positivos
        
        I = find (M1(:,a)>0);
        J(:,a) = numel(I);
        K(:,a) = sum(M1(:,a));
        I_Med(a) = K(:,a)/J(:,a);
                      
Eon(a) = (0.006667*I_Med(a) + 0.1)*1e-3*kVce*kRg;
Eoff(a) = (0.04119*I_Med(a) + 0.8179)*1e-3*kVce*kRg;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           RECUPERAÇÃO
      
        Cont1(:,a)=Sn(inicial(a):final(a));%Alocando os valores de cada comutação em colunas
        M11(:,a) = abs(Cont1(:,a));%valores positivos
        
        I1 = find (M11(:,a)>0);
        J1(:,a) = numel(I1);
        K1(:,a) = sum(M11(:,a));
        I_Med_(a) = K1(:,a)/J1(:,a);                             
% Err(a) = (-0.0001429*I_Med_(a)^2 + 0.03414*I_Med_(a) + 0.12)*1e-3;
Qrr(a) = I_Med_(a)* Trr/2;
Err(a) = Qrr(a)*(1/4)*430;
 end
    Prr1(Pot,MaxIt) = nansum(Err)*60;
    Psw1(Pot,MaxIt) = (nansum(Eon)+nansum(Eoff))*60;
    
    Prr(Pot,MaxIt) = Prr1(Pot,1)*(Fsw(MaxIt)/Fsw1);
    Psw(Pot,MaxIt) = Psw1(Pot,1)*(Fsw(MaxIt)/Fsw1);
else
    Prr(Pot,MaxIt) = Prr1(Pot,1)*(Fsw(MaxIt)/Fsw1);
    Psw(Pot,MaxIt) = Psw1(Pot,1)*(Fsw(MaxIt)/Fsw1);
end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if I_100>Imax && Vds<Vds_Max
    %determinação das perdas
    PC_IGBT(Pot,MaxIt) = Uce0*Icav + rc*Icrms^2;
    PC_Diodo(Pot,MaxIt) = Ud0*Idav + rd*Idrms^2;
else
    PC_IGBT(Pot,MaxIt) = NaN;
    PC_Diodo(Pot,MaxIt) = NaN;
end
Pcond(Pot,MaxIt)=PC_IGBT(Pot,MaxIt)+PC_Diodo(Pot,MaxIt);
%Perdas Totais
P_Tot(Pot,MaxIt) = Pcond(Pot,MaxIt)+Psw(Pot,MaxIt)+Prr(Pot,MaxIt);

%Dimensionamento da resistência témica
RCA(Pot,MaxIt) = ((Tj-RJC*P_Tot(Pot,MaxIt)-Ta)/(P_Tot(Pot,MaxIt)*6));
end
end
out.PCM = Pcond;            %PERDAS POR CONDUÇÃO
out.Psw = Psw;            %PERDAS POR COMUTAÇÃO
out.Prr = Prr;            %PERDAS POR COMUTAÇÃO
out.P_Tot = P_Tot;        %PERDAS TOTAIS
out.RCA = RCA;            %RESISTENCIA TÉRMICA QUE ASEGURA A TJ
out.Fsw = Fsw;            %VETOR FREQUÊNCIA
end