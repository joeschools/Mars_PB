file1 = '/Users/jschools/Documents/MATLAB/W&D1994.melts'; % Mars
file2 = '/Users/jschools/Desktop/PBOutput/Residue.melts';
file3 = '/Users/jschools/Desktop/PBOutput/Liquid.melts';


fid = fopen(file1, 'r');
% with water (rename Initial Trace or Initial Composition as needed):
%C = textscan(fid, 'Title: %s Initial Composition: SiO2 %f Initial Composition: TiO2 %f Initial Composition: Al2O3 %f Initial Composition: Fe2O3 %f Initial Composition: Cr2O3 %f Initial Composition: FeO %f Initial Composition: MgO %f Initial Composition: CaO %f Initial Composition: Na2O %f Initial Trace: H2O %f Initial Mass: %f Initial Temperature: %f Initial Pressure: %f', 'Delimiter','\n');
% no water:
C = textscan(fid, 'Title: %s Initial Composition: SiO2 %f Initial Composition: TiO2 %f Initial Composition: Al2O3 %f Initial Composition: Fe2O3 %f Initial Composition: Cr2O3 %f Initial Composition: FeO %f Initial Composition: MgO %f Initial Composition: CaO %f Initial Composition: Na2O %f Initial Mass: %f Initial Temperature: %f Initial Pressure: %f', 'Delimiter','\n');
fclose(fid);

fid = fopen(file2, 'r');
% with water:
%D = textscan(fid, '%s %s Initial Composition: SiO2 %f Initial Composition: TiO2 %f Initial Composition: Al2O3 %f Initial Composition: Fe2O3 %f Initial Composition: Cr2O3 %f Initial Composition: FeO %f Initial Composition: MgO %f Initial Composition: CaO %f Initial Composition: Na2O %f Initial Composition: H2O %f Initial Trace: H2O %f Initial Mass: %f Initial Temperature: %f Initial Pressure: %f %s %s %s %s %s', 'Delimiter','\n');
% no water:
D = textscan(fid, '%s %s Initial Composition: SiO2 %f Initial Composition: TiO2 %f Initial Composition: Al2O3 %f Initial Composition: Fe2O3 %f Initial Composition: Cr2O3 %f Initial Composition: FeO %f Initial Composition: MgO %f Initial Composition: CaO %f Initial Composition: Na2O %f Initial Composition: H2O %f Initial Mass: %f Initial Temperature: %f Initial Pressure: %f %s %s %s %s %s', 'Delimiter','\n');
fclose(fid);

%% The following indices for D will need to be changed to 13 if water added
SiO2 = C{2}-((D{3}/100)*D{12});     % Determines SiO2 content of total produced melt by taking difference between SiO2 content of initial solid and remaining solid (scaled for mass)
TiO2 = C{3}-((D{4}/100)*D{12});     % See SiO2
Al2O3 = C{4}-((D{5}/100)*D{12});    % See SiO2
Fe2O3 = 0.001;                      % recalculated in MELTS calculation according to oxygen fugacity, just set to a small initial value here as required by MELTS
Cr2O3 = C{6}-((D{7}/100)*D{12});    % See SiO2
FeO = C{7}-(((D{6}/100)*D{12})+((D{8}/100)*D{12})); % Detetermines total iron content as FeO, see Fe2O3 above
MgO = C{8}-((D{9}/100)*D{12});      % See SiO2
CaO = C{9}-((D{10}/100)*D{12});     % See SiO2
Na2O = C{10}-((D{11}/100)*D{12});   % See SiO2
%H2O = (C{11}-D{13})/(10^4);         % Calculates water content of melt if needed, here set for water as a trace element
mass = C{11}-D{12};                 
Initial_Temp = D{13};
Initial_Press = D{14};
%%
fid = fopen(file3, 'r');
E = textscan(fid, '%s %s Initial Composition: SiO2 %f Initial Composition: TiO2 %f Initial Composition: Al2O3 %f Initial Composition: Fe2O3 %f Initial Composition: Cr2O3 %f Initial Composition: FeO %f Initial Composition: MgO %f Initial Composition: CaO %f Initial Composition: Na2O Initial Composition: H2O %f Initial Mass: %f Initial Temperature: %f Initial Pressure: %f %s %s %s %s %s', 'Delimiter','\n');
fclose(fid);

E{1} = 'Title: Wanke and Dreibus 1994';
E{2} = 'Title: Calculated liquid composition';

strfind(E{3}, 'Initial Composition: SiO2');
formatSpec = 'Initial Composition: SiO2 %f';
str = sprintf(formatSpec,SiO2);
E{3} = sprintf('%s',str);

strfind(E{4}, 'Initial Composition: TiO2');
formatSpec = 'Initial Composition: TiO2 %f';
str = sprintf(formatSpec,TiO2);
E{4} = sprintf('%s',str);

strfind(E{5}, 'Initial Composition: Al2O3');
formatSpec = 'Initial Composition: Al2O3 %f';
str = sprintf(formatSpec,Al2O3);
E{5} = sprintf('%s',str);

strfind(E{6}, 'Initial Composition: Fe2O3');
formatSpec = 'Initial Composition: Fe2O3 %f';
str = sprintf(formatSpec,Fe2O3);
E{6} = sprintf('%s',str);

strfind(E{7}, 'Initial Composition: Cr2O3');
formatSpec = 'Initial Composition: Cr2O3 %f';
str = sprintf(formatSpec,Cr2O3);
E{7} = sprintf('%s',str);

strfind(E{8}, 'Initial Composition: FeO');
formatSpec = 'Initial Composition: FeO %f';
str = sprintf(formatSpec,FeO);
E{8} = sprintf('%s',str);

strfind(E{9}, 'Initial Composition: MgO');
formatSpec = 'Initial Composition: MgO %f';
str = sprintf(formatSpec,MgO);
E{9} = sprintf('%s',str);

strfind(E{10}, 'Initial Composition: CaO');
formatSpec = 'Initial Composition: CaO %f';
str = sprintf(formatSpec,CaO);
E{10} = sprintf('%s',str);

strfind(E{11}, 'Initial Composition: Na2O');
formatSpec = 'Initial Composition: Na2O %f';
str = sprintf(formatSpec,Na2O);
E{11} = sprintf('%s',str);

% strfind(E{12}, 'Initial Composition: H2O');
% formatSpec = 'Initial Composition: H2O %f';
% str = sprintf(formatSpec,H2O);
% E{12} = sprintf('%s',str);

strfind(E{12}, 'Initial Mass:'); % Set following indices to E{n+1} if water added
formatSpec = 'Initial Mass: %f';
str = sprintf(formatSpec,mass);
E{12} = sprintf('%s',str);

strfind(E{13}, 'Initial Temperature:');
formatSpec = 'Initial Temperature: %f';
str = sprintf(formatSpec,Initial_Temp);
E{13} = sprintf('%s',str);

strfind(E{14}, 'Initial Pressure:');
formatSpec = 'Initial Pressure: %f';
str = sprintf(formatSpec,Initial_Press);
E{14} = sprintf('%s',str);

E{15} = 'Log fO2 Path: FMQ';
E{16} = 'Log fO2 Delta: -2.50';
E{17} = 'Suppress: orthoamphibole';
E{18} = 'Suppress: chlorite';
E{19} = 'Suppress: knorringite';

E=E.'; % Transpose necessary for file writing
F = cell2table(E);
writetable(F,file3,'WriteVariableNames',false,'FileType','text')
