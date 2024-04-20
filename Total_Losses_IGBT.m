function out = Total_Losses_IGBT(param,paramext,Corrente,Vds_in,Fsw1)
% Desencapsulando os parâmetros externos
Vds = Vds_in;
Tj = paramext.Tj;
Ta = paramext.Ta;


%% Desencapsulando os parametros do transistor
Uce0 = param.IGBT.Uce0;
rc = param.IGBT.rc;
Vds_Max = param.IGBT.Vds_Max;
I_100 =param.IGBT.I_100;

kVce = paramext.kVce; %%%%%%%%
kRg = paramext.kRg; %%%%%%%%%%
% Pmax=param.Pmax;

Ids = abs(Corrente);
%Obtenção da corrente média e rms no transistor
Icav = mean(Ids);
Icrms = rms(Ids);

%Frequency
Fsw = Fsw1;
Frede = paramext.Frede;

%período da rede
Tseno = 1/Frede;%periodo de rede
  

Tsw = 1/Fsw; %periodo de cada comutação
%Criando um contador de período de comutação
Amostras = floor(Tseno*Fsw); %numero de comutações em um ciclo
VETOR_Tsw = floor(Tsw*(length(Ids))/Tseno); %numero de amostras em uma comutação

%Laço da frequência
 for a=1:1:Amostras %Pegando 1 comutação de cada vez
        if a==1
            inicial(a)=a;
        end
        if a>1
            inicial(a)=(a-1)*VETOR_Tsw+1;
        end
        final(a)=a*VETOR_Tsw;
        
        Ids1 = Ids;
     
        Cont(:,a)=Ids1(inicial(a):final(a));%Alocando os valores de cada comutação em colunas
        M1(:,a) = abs(Cont(:,a));%valores positivos
        
        I = find (M1(:,a)>0.1);
        J(:,a) = numel(I);
        K(:,a) = sum(M1(:,a));
        I_Med(a) = K(:,a)/J(:,a);
                      
Eon(a) = 1/2*I_Med(a)*Vds*((param.IGBT.tr+param.IGBT.tf)*kVce*kRg);


 end
Psw1 = (nansum(Eon))*60;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if I_100>Icrms && Vds_Max<700 && I_100<40
    PC_IGBT = Uce0*Icav + rc*Icrms^2;
else
    PC_IGBT = NaN;
end

P_Tot = PC_IGBT+Psw1;   
    
out.Totais = P_Tot;        %PERDAS TOTAIS
out.I_Med=I_Med;
out.PC_IGBT=PC_IGBT;
out.Psw1=Psw1;
end