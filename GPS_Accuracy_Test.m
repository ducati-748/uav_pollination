% This script takes the latitude and longitude positions found by the GPS
% on the UAV. These coordinates will each be saved in their own excel file
% and will be converted to the UTM coordinate system to be in terms of
% meters. The Circular Error Probability (CEP) and two times the distance
% root mean squared (2DRMS) will be calculated and plotted with the
% coordinates to show the GPS accuracy.
% Last edited: March 2021
% UTM conversion reference: https://www.mathworks.com/matlabcentral/fileexchange/10915-deg2utm

%Pull coordinates into variables
format long
lat = readtable('CEP_Lat_data2.xlsx');
lon = readtable('CEP_Lon_data2.xlsx');
lat_array = table2array(lat);
lon_array = table2array(lon);
%Convert to UTM, store new lat into x and lon into y
[x,y,utmzone] = deg2utm(lat_array(:,1),lon_array(:,1));
%Caluclating average x and y values
x_sum = sum(x(:,1));
[col,row] = size(x);
x_avg = x_sum ./ col;       % average value of lat values
y_sum = sum(y(:,1));
y_avg = y_sum ./ col;       % average value of lon values
%Calculate delta x and delta y 
x_delta(:,1) = x(:,1) - x_avg;
y_delta(:,1) = y(:,1) - y_avg;
%Calculate the standard deviation of delta x and delta y
x_Stdev = std(x_delta);
y_Stdev = std(y_delta);
CEP_50 = 0.59*(x_Stdev + y_Stdev);   %50% radius
DRMS_95 = 2*sqrt(x_Stdev^2 + y_Stdev^2);   %2DRMS (95%) radius

x_delta_5 = x_delta(1:5:end,1);
y_delta_5 = y_delta(1:5:end,1);

figure(1)
%Create Scatter plot. Lon = X, Lat = Y, data mark size, color
scatter(x_delta_5,y_delta_5,50,'red', 'x')
hold on  
 %Plot CEP_50 radius circle
th = 0:pi/50:2*pi;
r = CEP_50;     
xunit = r * cos(th);
yunit = r * sin(th);
plot(xunit,yunit,'blue')
 %Plot 2DRMS, DRMS_95 (95%) radius circle
th = 0:pi/50:2*pi;
r = DRMS_95;     
xunit = r * cos(th);
yunit = r * sin(th);
plot(xunit,yunit,'red')
%Plot a line to mark as the average/origin axes
xline(0,'black')
yline(0,'black')
%Set axes range
xlim([-5 5])
ylim([-5 5])
%Title and axes
title('GPS Position')
xlabel('Delta X (meters)')
ylabel('Delta Y (meters)')
%Legend
legend({'Position','CEP (50%)','2DRMS (97%)'})
legend('Location','best')



% Reference: https://www.mathworks.com/matlabcentral/fileexchange/10915-deg2utm 
function  [x,y,utmzone] = deg2utm(Lat,Lon)
% -------------------------------------------------------------------------
% [x,y,utmzone] = deg2utm(Lat,Lon)
%
% Description: Function to convert lat/lon vectors into UTM coordinates (WGS84).
% Some code has been extracted from UTM.m function by Gabriel Ruiz Martinez.
%
% Inputs:
%    Lat: Latitude vector.   Degrees.  +ddd.ddddd  WGS84
%    Lon: Longitude vector.  Degrees.  +ddd.ddddd  WGS84
%
% Outputs:
%    x, y , utmzone.   See example
%
% Example 1:
%    Lat=[40.3154333; 46.283900; 37.577833; 28.645650; 38.855550; 25.061783];
%    Lon=[-3.4857166; 7.8012333; -119.95525; -17.759533; -94.7990166; 121.640266];
%    [x,y,utmzone] = deg2utm(Lat,Lon);
%    fprintf('%7.0f ',x)
%       458731  407653  239027  230253  343898  362850
%    fprintf('%7.0f ',y)
%      4462881 5126290 4163083 3171843 4302285 2772478
%    utmzone =
%       30 T
%       32 T
%       11 S
%       28 R
%       15 S
%       51 R
%
% Example 2: If you have Lat/Lon coordinates in Degrees, Minutes and Seconds
%    LatDMS=[40 18 55.56; 46 17 2.04];
%    LonDMS=[-3 29  8.58;  7 48 4.44];
%    Lat=dms2deg(mat2dms(LatDMS)); %convert into degrees
%    Lon=dms2deg(mat2dms(LonDMS)); %convert into degrees
%    [x,y,utmzone] = deg2utm(Lat,Lon)
%
% Author: 
%   Rafael Palacios
%   Universidad Pontificia Comillas
%   Madrid, Spain
% Version: Apr/06, Jun/06, Aug/06, Aug/06
% Aug/06: fixed a problem (found by Rodolphe Dewarrat) related to southern 
%    hemisphere coordinates. 
% Aug/06: corrected m-Lint warnings
%-------------------------------------------------------------------------
% Argument checking
%
error(nargchk(2, 2, nargin));  %2 arguments required
n1=length(Lat);
n2=length(Lon);
if (n1~=n2)
   error('Lat and Lon vectors should have the same length');
end
% Memory pre-allocation
%
x=zeros(n1,1);
y=zeros(n1,1);
utmzone(n1,:)='60 X';
% Main Loop
%
for i=1:n1
   la=Lat(i);
   lo=Lon(i);
   sa = 6378137.000000 ; sb = 6356752.314245;
         
   %e = ( ( ( sa ^ 2 ) - ( sb ^ 2 ) ) ^ 0.5 ) / sa;
   e2 = ( ( ( sa ^ 2 ) - ( sb ^ 2 ) ) ^ 0.5 ) / sb;
   e2cuadrada = e2 ^ 2;
   c = ( sa ^ 2 ) / sb;
   %alpha = ( sa - sb ) / sa;             %f
   %ablandamiento = 1 / alpha;   % 1/f
   lat = la * ( pi / 180 );
   lon = lo * ( pi / 180 );
   Huso = fix( ( lo / 6 ) + 31);
   S = ( ( Huso * 6 ) - 183 );
   deltaS = lon - ( S * ( pi / 180 ) );
   if (la<-72), Letra='C';
   elseif (la<-64), Letra='D';
   elseif (la<-56), Letra='E';
   elseif (la<-48), Letra='F';
   elseif (la<-40), Letra='G';
   elseif (la<-32), Letra='H';
   elseif (la<-24), Letra='J';
   elseif (la<-16), Letra='K';
   elseif (la<-8), Letra='L';
   elseif (la<0), Letra='M';
   elseif (la<8), Letra='N';
   elseif (la<16), Letra='P';
   elseif (la<24), Letra='Q';
   elseif (la<32), Letra='R';
   elseif (la<40), Letra='S';
   elseif (la<48), Letra='T';
   elseif (la<56), Letra='U';
   elseif (la<64), Letra='V';
   elseif (la<72), Letra='W';
   else Letra='X';
   end
   a = cos(lat) * sin(deltaS);
   epsilon = 0.5 * log( ( 1 +  a) / ( 1 - a ) );
   nu = atan( tan(lat) / cos(deltaS) ) - lat;
   v = ( c / ( ( 1 + ( e2cuadrada * ( cos(lat) ) ^ 2 ) ) ) ^ 0.5 ) * 0.9996;
   ta = ( e2cuadrada / 2 ) * epsilon ^ 2 * ( cos(lat) ) ^ 2;
   a1 = sin( 2 * lat );
   a2 = a1 * ( cos(lat) ) ^ 2;
   j2 = lat + ( a1 / 2 );
   j4 = ( ( 3 * j2 ) + a2 ) / 4;
   j6 = ( ( 5 * j4 ) + ( a2 * ( cos(lat) ) ^ 2) ) / 3;
   alfa = ( 3 / 4 ) * e2cuadrada;
   beta = ( 5 / 3 ) * alfa ^ 2;
   gama = ( 35 / 27 ) * alfa ^ 3;
   Bm = 0.9996 * c * ( lat - alfa * j2 + beta * j4 - gama * j6 );
   xx = epsilon * v * ( 1 + ( ta / 3 ) ) + 500000;
   yy = nu * v * ( 1 + ta ) + Bm;
   if (yy<0)
       yy=9999999+yy;
   end
   x(i)=xx;
   y(i)=yy;
   utmzone(i,:)=sprintf('%02d %c',Huso,Letra);
end
end