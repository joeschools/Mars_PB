function [ output ] = PB(Comp,Temp,Thick,Fug)
%Performs permeability barrier formation calculation
%
%   Comp: Composition text file
%       Accepted options:
%           W&D1994: Wanke and Dreibus 1994
%           L&F1997: Lodders and Fegley 1997
%           K&C2008: Khan and Connolly 2008
%           Taylor2013: Taylor 2013
%   Temp: mantle potential temperature
%   Thick: lithsophere thickness
%   Fug: Oxygen fugacity (in log units from FMQ)

%% File Manipulation 

mkdir('/Users/jschools/Desktop/PBOutput')

formatSpec = '/Users/jschools/Desktop/Mars_PB_Results/%s/FMQ%d/%d_km/%d_C'; %Creates destination path for results storage

output_str = sprintf(formatSpec,Comp,Fug,Thick,Temp); 

save('output_str'); %Saves destination point to call later

f='/Users/jschools/Documents/MATLAB/isentropic.txt';
p='/Users/jschools/Documents/MATLAB/output_1';
b='/Users/jschools/Documents/MATLAB/batchfile_1.txt'; %For Mars
%b='/Users/jschools/Documents/MATLAB/batchfile_Earth.txt'; %For Earth

%Adjust batchfile_1 for input oxygen fugacity and composition file
%Open batchfile_1
fid = fopen(b,'r');
i = 1;
tline = fgetl(fid);
A{i} = tline;
while ischar(tline)
    i = i+1;
    tline = fgetl(fid);
    A{i} = tline;
end
fclose(fid);

%Edit batchfile_1
formatSpec = '/Users/jschools/Documents/MATLAB/%s.melts';
str = sprintf(formatSpec,Comp);
A{2} = sprintf('%s',str);
A{8} = sprintf('%d',Fug);

%Close batchfile_1
fid = fopen(b, 'w');
for i = 1:numel(A)
    if A{i+1} == -1
        fprintf(fid,'%s', A{i});
        break
    else
        fprintf(fid,'%s\n', A{i});
    end
end
fclose(fid);

%Adjust isentrpoic.txt for input Lithosphere thickness
%Open isentropic
fid = fopen(f,'r');
i = 1;
tline = fgetl(fid);
A{i} = tline;
while ischar(tline)
    i = i+1;
    tline = fgetl(fid);
    A{i} = tline;
end
fclose(fid);

%Edit isentropic
ThickP = 106.72*Thick; %For Mars, Thickness to pressure conversion

formatSpec = 'ALPHAMELTS_MINP          %d';
str = sprintf(formatSpec,ThickP);
A{31} = sprintf('%s',str);

%Close isentropic
fid = fopen(f, 'w');
for i = 1:numel(A)
    if A{i+1} == -1
        fprintf(fid,'%s', A{i});
        break
    else
        fprintf(fid,'%s\n', A{i});
    end
end
fclose(fid);

%Open user chosen composition file and change user input temperature
%Open composition file
formatSpec = '/Users/jschools/Documents/MATLAB/%s.melts';
str = sprintf(formatSpec,Comp);
fid = fopen(str,'r');
i = 1;
tline = fgetl(fid);
A{i} = tline;
while ischar(tline)
    i = i+1;
    tline = fgetl(fid);
    A{i} = tline;
end
fclose(fid);

%Edit composition file
formatSpec = '/Users/jschools/Documents/MATLAB/%s.melts';
str = sprintf(formatSpec,Comp);
fid = fopen(str, 'r');
C = textscan(fid, '%s', 'Delimiter', '\n');
fclose(fid);

%Line number varies depending on file
%Search for correct line to change
C = strfind(C{1}, 'Initial Temperature:');
rows = find(~cellfun('isempty', C));

formatSpec = 'Initial Temperature: %d';
str = sprintf(formatSpec,Temp);
A{rows} = sprintf('%s',str);

%Close composition file
formatSpec = '/Users/jschools/Documents/MATLAB/%s.melts';
str = sprintf(formatSpec,Comp);
fid = fopen(str, 'w');
for i = 1:numel(A)
    if A{i+1} == -1
        fprintf(fid,'%s', A{i});
        break
    else
        fprintf(fid,'%s\n', A{i});
    end
end
fclose(fid);

%% MELTS computations

disp('Starting Adiabatic Melting')
MELTS(f,p,b) %Adiabatic melting calculation

PTPath %Creation of Areotherm P-T path 
disp('Finished Adiabatic Melting')

Total_Melt2 %Determine aggregate melt composition

f='/Users/jschools/Documents/MATLAB/PTGeotherm.txt';
p='/Users/jschools/Documents/MATLAB/output_2';         %Load Crystallization files
b='/Users/jschools/Documents/MATLAB/batchfile_2.txt';

disp('Starting Batch Crystallization')
disp(datetime('now','TimeZone','America/New_York','Format','eeee, MMMM d, yyyy h:mm a'))
MELTS(f,p,b) %Crystallization in lithosphere calculation, may stall at this point
disp('Finished Batch Crystallization')
mkdir(output_str);
%copyfile('/Users/jschools/Desktop/PBOutput',output_str); %saves outputs to directory

%% Visulizations

PBVisBatch %creates figures to locate permeability barrier location

end