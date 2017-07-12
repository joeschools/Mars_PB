%% Load Files

copyfile('/Users/jschools/Documents/MATLAB/output_2','/Users/jschools/Desktop/PBOutput2/output_2')

file1='/Users/jschools/Documents/MATLAB/output_2/Solid_comp_tbl.txt';
file2='/Users/jschools/Documents/MATLAB/output_2/Bulk_comp_tbl.txt';
file3='/Users/jschools/Documents/MATLAB/output_2/Phase_mass_tbl.txt';

delimiterIn=' ';

A = importdata(file1,delimiterIn,4);
B = importdata(file2,delimiterIn,4);
mass = B.data(1,3);

Dl = i;

%% Bulk Crystalization Rate

figure 
hold on
try
Temp = (A.data(:,2));
Depth = (A.data(:,1))/107.62; %For Mars
%Depth = (A.data(:,1))/284.20; %For Earth
n1=length(Depth);
MinPeakHeight = 0.01;
Threshold = 3e-5;
start=6; %Start of calculation

    Pressure = A.data(n1-2,1)-(A.data(n1-1,1));

    for l=start:n1
        Percent(l) =(A.data(l,3)-A.data(l-1,3)).*(100./mass);
        Rate1(l) = (Percent(l)./Pressure);
    end
    [pks,loc] = findpeaks(Rate1,'MinPeakHeight',MinPeakHeight,'Threshold',Threshold);
    plot(Depth,Rate1,Depth(loc),pks,'ro','linewidth',5)
    xlabel('Depth (km)')
    ylabel('Crystallization Rate (%/bar)')
    axis([0,Dl,0,inf])
    set(gca,'FontSize',24)
    box on
    savefig('/Users/jschools/Desktop/PBOutput2/BulkComp.fig');
    PBRate=[Depth'; Rate1];

    print -dpdf /Users/jschools/Desktop/PBOutput2/BulkComp.pdf
catch
    %disp('Failure in Displaying Bulk Cyrstallization')
end

%% Mineral Crystalization Rates

figure 
hold on
C = importdata(file3,delimiterIn,4);
Clength=length(C.colheaders);
Depth2 = (C.data(:,1))/107.62;

try
    n=length(C.data(:,1));
    for l=5:Clength
        for m=start:n
            Percent(m) = (C.data(m,l)-C.data(m-1,l))*(100/mass);
            Rate2(m) = Percent(m)/Pressure;
        end
        Line(l)=plot(Depth2,Rate2,'linewidth',2);
        legendinfo(l)=C.colheaders(l);
    end
    legendinfo(4)=[];
    legendinfo(3)=[];
    legendinfo(2)=[];
    legendinfo(1)=[];
    legend(legendinfo,'location','southwest','fontsize',18)
    set(gca,'FontSize',24)
    xlabel('Depth (km)')
    ylabel('Crystallization Rate (%/bar)')
    axis([0,Dl,-inf,inf])
    set(gca,'FontSize',24)
    box on
    savefig('/Users/jschools/Desktop/PBOutput2/MineralComp.fig');

    print -dpdf /Users/jschools/Desktop/PBOutput2/MineralComp.pdf
catch
    %disp('Mineral Crystallization Failed')
end





