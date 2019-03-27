function [pflux,P3p,P10p,P14p,P26p,P36Cap,P36Kp,P36Tip,P36Fep] = Protons(h,Rct,s,consts)

% Sato et al. (2008) Neutron Spectrum
% Analytical Function Approximation (PARMA)
% Implemented in MATLAB by Nat Lifton, 2013
% Purdue University, nlifton@purdue.edu

% Copyright 2013, Purdue University
% All rights reserved
% Developed in part with funding from the National Science Foundation.
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License, version 3,
% as published by the Free Software Foundation (www.fsf.org).

Rc=Rct';

x = h.*1.019716; % Convert pressure (hPa) to atm depth (g/cm2)

E = logspace(0,5.3010,200);
% E = [1.1295 11.295 112.95 1129.5 11295];

A = 1;
Z = 1;
Ep = 938.27; % Rest mass of a proton
U = (4-1.675).*pi.*A./Z.*1e-7; % Unit conversion factor

% Flatten low rigidities. 

lowRc = find(Rc < 1.0);
Rc(lowRc) = 1.0 + zeros(size(lowRc));

% Primary spectrum

smin = 400; %units of MV
smax = 1200; %units of MV

a1 = 2.1153;
a2 = 4.4511e-1;
a3 = 1.0064e-2;
a4 = 3.9564e-2;
a5 = 2.9236;
a6 = 2.7076;
a7 = 1.2663e4;
a8 = 4.8288e3;
a9 = 3.2822e4;
a10 = 7.4378e3;
a11 = 3.4643;
a12 = 1.6752;
a13 = 1.3691;
a14 = 2.0665;
a15 = 1.0833e2;
a16 = 2.3013e3;

Etoa = E + a1.*x;         %  length of E
Rtoa = 0.001.*sqrt((A.*Etoa).^2 + 2.*A.*Ep.*Etoa)./Z;      %  length of E

% Elis = zeros(1,length(E));
% Beta = zeros(1,length(E));
% Rlis = zeros(1,length(E));
% phiTOA = zeros(1,length(E));
% phiLIS = zeros(1,length(E));
% phiSec = zeros(1,length(E));
% phiPtot = zeros(1,length(E));
% p10p = zeros(1,length(E));

% Secondary Spectrum

c11 = 1.2560;
c12 = 3.2260e-3;
c13 = -4.8077e-6;
c14 = 2.2825e-9;
c21 = 4.3783e-1;
c22 = -5.5759e-4;
c23 = 7.8388e-7;
c24 = -3.8671e-10;
c31 = 1.8102e-4;
c32 = -5.1754e-7;
c33 = 7.5876e-10;
c34 = -3.8220e-13;
c41 = 1.7065;
c42 = 7.1608e-4;
c43 = -9.3220e-7;
c44 = 5.2665e-10;

b1 = c11 + c12.*x + c13.*x.^2 + c14.*x.^3;
b2 = c21 + c22.*x + c23.*x.^2 + c24.*x.^3;
b3 = c31 + c32.*x + c33.*x.^2 + c34.*x.^3;
b4 = c41 + c42.*x + c43.*x.^2 + c44.*x.^3;

h11min = 2.4354e-3;
h11max = 2.5450e-3;
h12min = -6.0339e-5;
h12max = -7.1807e-5;
h13min= 2.1951e-3;
h13max = 1.4580e-3;
h14min = 6.6767;
h14max = 6.9150;
h15min = 9.3228e-1;
h15max = 9.9366e-1;
h21min = 7.7872e-3;
h21max = 7.6828e-3;
h22min = -9.5771e-6;
h22max = -2.4119e-6;
h23min = 6.2229e-4;
h23max = 6.6411e-4;
h24min = 7.7842;
h24max = 7.7461;
h25min = 1.8502;
h25max = 1.9431;
h31min = 9.6340e-1;
h31max = 9.7353e-1;
h32min = 1.5974e-3;
h32max = 1.0577e-3;
h33min = -7.1179e-2;
h33max = -2.1383e-2;
h34min = 2.2320;
h34max = 3.0058;
h35min = 7.8800e-1;
h35max = 9.1845e-1;
h41min = 7.8132e-3;
h41max = 7.3482e-3;
h42min = 9.7085e-11;
h42max = 2.5598e-5;
h43min = 8.2392e-4;
h43max = 1.2457e-3;
h44min = 8.5138;
h44max = 8.1896;
h45min = 2.3125;
h45max = 2.9368;

h51 = 1.9100e-1;
h52 = 7.0300e-2;
h53 = -6.4500e-1;
h54 = 2.0300;
h55 = 1.3000;
h61 = 5.7100e-4;
h62 = 6.1300e-6;
h63 = 5.4700e-4;
h64 = 1.1100;
h65 = 8.3700e-1;

% Combine primary and secondary spectra

Inrc=ones(length(Rc),1);   % vecteur colonne unit?
Ine=ones(1,length(E));  % vecteur ligne unit? de taille E

% for a = 1:length(Rc)
%  debut de l'ancienne boucle
    Elis = Inrc*Etoa + Z./A.*(s'*Ine);    % size (length(Rc),length(E))
    Beta = sqrt(1-(Ep./(Ep + Elis.*A)).^2); % Particle speed relative to light
    Rlis = 0.001.*sqrt((A.*Elis).^2 + 2.*A.*Ep.*Elis)./Z;
    C = a7 + a8./(1 + exp((Elis - a9)./a10));   % size (length(Rc),length(E))

    phiTOA = (C.*(Beta.^a5)./(Rlis.^a6)).*((Inrc*Rtoa)./Rlis).^2;  % size (length(Rc),length(E))
    phiPri = (U./Beta).*phiTOA.*(a2.*exp(-a3.*x) + (1 - a2).*exp(-a4.*x));
    
    g1min = h11min + h12min.*Rc + h13min./(1 + exp((Rc - h14min)./h15min));
    g1max = h11max + h12max.*Rc + h13max./(1 + exp((Rc - h14max)./h15max));
    g2min = h21min + h22min.*Rc + h23min./(1 + exp((Rc - h24min)./h25min));
    g2max = h21max + h22max.*Rc + h23max./(1 + exp((Rc - h24max)./h25max));
    g3min = h31min + h32min.*Rc + h33min./(1 + exp((Rc - h34min)./h35min));
    g3max = h31max + h32max.*Rc + h33max./(1 + exp((Rc - h34max)./h35max));
    g4min = h41min + h42min.*Rc + h43min./(1 + exp((Rc - h44min)./h45min));
    g4max = h41max + h42max.*Rc + h43max./(1 + exp((Rc - h44max)./h45max));

    phiPmin = g1min.*(exp(-g2min.*x) - g3min.*exp(-g4min.*x)); %length of Rc
    phiPmax = g1max.*(exp(-g2max.*x) - g3max.*exp(-g4max.*x)); %length of Rc

    g5 = h51 + h52.*Rc + h53./(1 + exp((Rc - h54)./h55));   %length of Rc
    g6 = h61 + h62.*Rc + h63./(1 + exp((Rc - h64)./h65));

    f3 = g5 + g6.*x;              %length of Rc
    f2 = (phiPmin - phiPmax)./(smin.^f3 - smax.^f3);
    f1 = phiPmin - f2.*smin.^f3;

    phiP = f1 + f2.*s.^f3;      %length of Rc
    
    phiSec = phiP'*((b1.*E.^b2)./(1 + b3.*E.^b4));  % size (length(Rc),length(E))
    
    Ec = (sqrt((1000.*Rc.*Z).^2 + Ep.^2) - Ep)./A;   %length of Rc
    Es = a13.*(Ec - a14.*x);    
    Es1 = max(a15,Es);
    Es2 = max(a16,Es);          %length of Rc
    
    phiPtot = phiPri.*(tanh(a11.*((1./Es1)'*E - 1)) + 1)./2 + ...
        phiSec.*(tanh(a12.*(1 - (1./Es2)'*E)) + 1)./2;
    
    clipindex = find(E <= 1, 1, 'last' ); %Make sure the clip index is consistent with the definition of E above
    
%    if nuclide == 3
        P3p = (trapz(E,phiPtot.*(Inrc*(consts.OpxHe3T + consts.SipxHe3T./2)),2).*consts.Natoms3.*1e-27.*3.1536e7)';    
%    elseif nuclide == 10
        P10p = (trapz(E,phiPtot.*(Inrc*(consts.O16pxBe10 + consts.SipxBe10./2)),2).*consts.Natoms10.*1e-27.*3.1536e7)';
%    elseif nuclide == 14    
        P14p = (trapz(E,phiPtot.*(Inrc*(consts.O16pxC14 + consts.SipxC14./2)),2).*consts.Natoms14.*1e-27.*3.1536e7)';
%    elseif nuclide == 26
        P26p = (trapz(E,phiPtot.*(Inrc*consts.SipxAl26),2).*consts.Natoms26.*1e-27.*3.1536e7)'; 
%    else
        pflux = (trapz(E(clipindex:end),phiPtot(:,clipindex:end),2))';
%    end
        P36Cap = (trapz(E,phiPtot.*(Inrc*consts.CapxCl36),2).*consts.Natoms36Ca.*1e-27.*3.1536e7)'; 
        P36Kp = (trapz(E,phiPtot.*(Inrc*consts.KpxCl36),2).*consts.Natoms36K.*1e-27.*3.1536e7)';  
        P36Tip = (trapz(E,phiPtot.*(Inrc*consts.TipxCl36),2).*consts.Natoms36Ti.*1e-27.*3.1536e7)'; 
        P36Fep = (trapz(E,phiPtot.*(Inrc*consts.FepxCl36),2).*consts.Natoms36Fe.*1e-27.*3.1536e7)';  
 
% end
%  fin de l'ancienne boucle



% Plot it

%     figure;clf;
%     loglog(E,phiPtot(1,:));hold on;
%     figure;clf;
%     loglog(E,phiSec(1,:));hold on;


