function Losses = Total_Losses_Diode(param,paramext,Corrente,Vds_in,Fsw1)
% Desencapsulando os parâmetros externos
%%
n_diode = param.Diode(end,end);
Qrr = param.Diode(:,8);
Ud0 = param.Diode(:,3); 
rd = (param.Diode(:,7)-param.Diode(:,6))./((param.Diode(:,5)+param.Diode(:,5))/2);
I_100 = param.Diode(:,2);
Vds_Max = param.Diode(:,1);

%Frequency
Fsw = Fsw1;

%Parameters
Vds = Vds_in;
Ids = Corrente;

%Obtenção da corrente média e rms no transistor
Imed = mean(abs(Ids));
Idrms = rms(Ids);
Imax = max(Ids);

for n=1:1:n_diode %Laço n_diode

    
%Conduction losses  

    
%Reverse recovery losses

% Qrr = Imed* Trr(n)/2;
Err = Qrr(n)*(1/4)*Vds;

 
if I_100(n)>Imax && Vds_Max(n)<700 %25% de margem de erro
        PC_Diodo(n) = Ud0(n)*Imed + rd(n)*Idrms^2;
        Prr1(n) = nansum(Err)*Fsw;
else
        PC_Diodo(n) = NaN;
        Prr1(n)=NaN;
end
       
P_Tot(n) = PC_Diodo(n)+Prr1(n);

end

%Buscando o # de menores perdas
    minimo = min(P_Tot);
    if isnan(minimo(1))==0
    Loss_Min = minimo(1);
    %buscando pelo #
    loc1 = find(P_Tot==Loss_Min);
    loc = loc1(1);
%     Loss_Min_PCD(a,b,c)=PC_Diodo(loc1(1),a,b);
%     Loss_Min_Prr(a,b,c)=Prr1(loc1(1),a,b);
    else
        Loss_Min=NaN;
        loc = NaN;
    end
    
    
Losses.loc = loc;
Losses.Loss_Min = Loss_Min;



%%

% Losses.loc = loc;
% Losses.di = di1;
% Losses.Loss_Min = Loss_Min;
Losses.loc = loc;
Losses.Loss_Min = Loss_Min;
Losses.PCD = PC_Diodo;
Losses.Prr = Prr1;
Losses.Totais = P_Tot;
Losses.Imed = Imed;
end