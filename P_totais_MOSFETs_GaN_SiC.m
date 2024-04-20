clear
clc
format shorteng
set(0,'DefaultFigureWindowStyle','docked')
warning off
% C:\Users\eopra\AppData\Roaming\MathWorks\MATLAB Add-Ons\Functions\digitize2.m
% close all

%% Parametros das simulação
%Ganho boost  = Vo/Vi = 1/(1-D)

%Carregando as formas de onda

Formas_onda

Parametros

%% Calculo de perdas lado CC
%Carregando o banco de dados
param.Data = xlsread('Banco_dados/Banco_de_dados_MOSFET_LV.xlsx');
Vds_in = paramext.Vds4;
Fsw1 = paramext.Fsw1;
Losses_S4 = Total_Losses_Mosfet_CC(param,paramext,param.Is4,Vds_in,Fsw1);
%Calculo de perdas e identificação
Vds_in = paramext.Vds1_3;
Fsw1 = paramext.Fsw1;
Losses_S1 = Total_Losses_Mosfet_CC(param,paramext,param.Is1,Vds_in,Fsw1);
Losses_S2 = Total_Losses_Mosfet_CC(param,paramext,param.Is2,Vds_in,Fsw1);
Losses_S3 = Total_Losses_Mosfet_CC(param,paramext,param.Is3,Vds_in,Fsw1);
Vds_in = paramext.Vds5_6;
Fsw1 = paramext.Fsw2;
clear param.Data
param.Data = xlsread('Banco_dados/Banco_de_dados_SiC.xlsx');
Losses_S5 = Total_Losses_Mosfet_CC(param,paramext,param.Is5,Vds_in,Fsw1);
Losses_S6 = Total_Losses_Mosfet_CC(param,paramext,param.Is6,Vds_in,Fsw1);
%IGBT
Losses_I7 = Total_Losses_IGBT(param,paramext,param.Is7,Vds_in,Fsw1); %IGBT
%% Plot das figuras e busca pelo pelo ponto de interesse
%% Calculo de perdas SiC
param.Diode = xlsread('Banco_dados/Banco_de_dados_Diode.xlsx');
sp = param.Is7;
sp(sp<=0)=0;
Losses_D7 = Total_Losses_Diode(param,paramext,sp,Vds_in,Fsw1);
Losses_D2 = Total_Losses_Diode(param,paramext,param.Id2,Vds_in,Fsw1);
Losses_D3 = Total_Losses_Diode(param,paramext,param.Id3,Vds_in,Fsw1);

%% O que fazer, trocar banco de dados S1-S4, Incluir IGBT


Perdas = ["S1",Losses_S1.Loss_Min,Losses_S1.loc;
"S2",Losses_S2.Loss_Min,Losses_S2.loc;
"S3",Losses_S3.Loss_Min,Losses_S3.loc;
"S4",Losses_S4.Loss_Min,Losses_S4.loc;
"S5",Losses_S5.Loss_Min,Losses_S5.loc;
"S6",Losses_S6.Loss_Min,Losses_S6.loc;
"D7",Losses_D7.Loss_Min,Losses_D7.loc;
"D1",Losses_D2.Loss_Min,Losses_D2.loc;
"D2",Losses_D3.Loss_Min,Losses_D3.loc;
"S7",Losses_I7.Totais,"NGB15N41ACL"]

Perdas1 = [1,Losses_S1.Loss_Min;
2,Losses_S2.Loss_Min;
3,Losses_S3.Loss_Min;
4,Losses_S4.Loss_Min;
5,Losses_S5.Loss_Min;
6,Losses_S6.Loss_Min;
7,Losses_D7.Loss_Min;
8,Losses_D2.Loss_Min;
9,Losses_D3.Loss_Min;
10,Losses_I7.Totais];

figure
grid on
bar(Perdas1(:,1),Perdas1(:,2))
ylabel('Pedas (W)')
grid on
