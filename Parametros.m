%Frequencia de comutação
paramext.Fsw1=50e3;
paramext.Fsw2=10e3;
%Tensão de Bloqueio
paramext.Vds1_3=80;
paramext.Vds4=48;
paramext.Vds5_6=200;
%Rede
paramext.Frede = 60;
paramext.Ta = 25;
%Parametros Gate driver
paramext.Rg = 15;
paramext.Vdr = 18;
paramext.Tj = 125;

%% % PARTNUMBER DO IGBT
%NGB15N41ACL, to-220

param.IGBT.Vds_Max=410;       %Tensão de bloqueio maxima
param.IGBT.I_100 = 15;        %Corrente maxima a 100 °C
param.IGBT.RJC = 1.4;         
%parâmetro constante Uce0
param.IGBT.Uce0 = 1;
%para determinar rc um ponto x de corrente e tensão devem ser extraídos
param.IGBT.rc = (2.7-1.9)/((15-5));
param.IGBT.tr = 5e-6;
param.IGBT.tf = 12e-6;

%Correções das curvas
paramext.kVce = 200/300;
paramext.kRg = 15/1000;
