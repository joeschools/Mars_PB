file='/Users/jschools/Documents/MATLAB/output_1/Bulk_comp_tbl.txt';
A1 = importdata(file,' ',4);

Pa=A1.data(:,1); % record adiabatic melting path
Ta=A1.data(:,2);

n=length(A1.data(:,1));

Pa=Pa(101:n);
Ta=Ta(101:n); % Trim to start at 2 GPa in MELTS run
n=length(Pa);

Pi=Pa(n);
Ti=Ta(n); % Starting point of lithosphere temperature curve

Pf=0;
Tf=-60;

Zstep=100; % Sets the step size in meters. Melts will calculate every ____m.

Pl=Pi:-Zstep*0.1076:0;
a=Ti+60;
b=Pi;
t=asin((Pl-Pi)/b);
%Tl=Tf+a*cos(t).^1;
Tl=Tf+a*cos(t).^2;   %best curve found for approximating lithosphere geotherm
%Tl=Tf+a*cos(t).^3;

Dl=Pl./107.62;
Da=Pa./107.62; %For depth plot check

fileID = fopen('/Users/jschools/Documents/MATLAB/LithDepth.txt','w');
fprintf(fileID,'%12.8f %12.8f\n',Dl);
fclose(fileID);

nl=length(Dl);
Tgrad=(Tl(nl)-Tl(nl-100))/(Dl(nl)-Dl(nl-100));
str = sprintf('Surface Geothermal Gradient: %f K/km',Tgrad);

figure
plot(Tl,-Dl,Ta,-Da,'linewidth',6) % Plots temp/depth profile for sanity check
xlabel('Temperature (C)')
ylabel('Depth (km)')
%title(str)
legend('Lithosphere Geotherm','Mantle Adiabat','location','southwest')
set(gca,'FontSize',24)
box on
savefig('/Users/jschools/Desktop/PBOutput/Areotherm.fig');

print -dpdf /Users/jschools/Desktop/PBOutput/Areotherm.pdf

lowerlimit=find(Tl < 600); %MELTS should not run below 500C
n2=lowerlimit(1);

n3=length(Pa)+n2;
P=zeros(1,n3);
P(1:n)=Pa;
P(n+1:n3)=Pl(1:n2);
T=zeros(1,n3);
T(1:n)=Ta;
T(n+1:n3)=Tl(1:n2);
PT=[P; T];

fileID = fopen('/Users/jschools/Documents/MATLAB/PTpath.txt','w');
fprintf(fileID,'%12.8f %12.8f\n',PT);  % writes PTpath file for MELTS crystallization calculation
fclose(fileID);

copyfile('/Users/jschools/Documents/MATLAB/PTPath.txt','/Users/jschools/Desktop/PBOutput')

