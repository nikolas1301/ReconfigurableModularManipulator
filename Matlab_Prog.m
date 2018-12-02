close all
clear all
clc

%% Building the robot

L(1) = Revolute('d', 18.5, 'a', 0, 'alpha', -pi/2, 'qlim', [-90*pi/180, 90*pi/180], 'offset', -pi/2);
L(2) = Revolute('d', 13.95, 'a', 12.78, 'alpha', -pi, 'qlim', [-50*pi/180, 220*pi/180], 'offset', -pi/2);
L(3) = Revolute('d', 11.8, 'a', 4.8, 'alpha', 0, 'qlim', [-170*pi/180, 170*pi/180]);

Trab = SerialLink(L, 'name', 'Junior');

%%

L(1) = Revolute('d', 18.5, 'a', 0, 'alpha', -pi/2, 'qlim', [-90*pi/180, 90*pi/180], 'offset', -pi/2);
L(2) = Revolute('d', -13.95, 'a', 17.78, 'alpha', -pi, 'qlim', [-50*pi/180, 220*pi/180], 'offset', -pi/2);
L(3) = Revolute('d', 11.8, 'a', 4.8, 'alpha', 0, 'qlim', [-170*pi/180, 170*pi/180]);

Trab1 = SerialLink(L, 'name', 'Deco');

%% Calculating the inverse kinematic

T1 = SE3(10, 6, 20); %Point in cm (x, y, z)
T2 = SE3(12, -11, 17);
T3 = SE3(-10, -11, 15);

Points = [T1, T2, T3];

Qrad = Trab.ikine(Points, 'mask', [1 1 1 0 0 0]); %ang in rad
Qdeg = Qrad*180/pi; %ang in degrees

for j=1:size(Qdeg,1)
    for i=1:size(Qdeg,2)
        if Qdeg(j,i) < 0
            Qdeg(j,i) = Qdeg(j,i)+360;
        end
    end
end

ProxQdeg(1,:) = Qdeg(1,:);

for j=2:size(Qdeg,1)
    for i=1:size(Qdeg,2)
        ProxQdeg(j,i) = Qdeg(j,i)-Qdeg(j-1,i);
    end
end

for j=1:size(ProxQdeg,1)
    for i=1:size(ProxQdeg,2)
        if ProxQdeg(j,i) < 0
            ProxQdeg(j,i) = ProxQdeg(j,i)+360;
        end
    end
end

ProxQdeg(4,:) = [360-Qdeg(size(Qdeg,1),1) 360-Qdeg(size(Qdeg,1),2) 360-Qdeg(size(Qdeg,1),3)];

%% Animating
p1 = 0;
p2 = 0;
p3 = 0;

Qini = [0 0 0];
tj{1} = jtraj(Qini, Qrad(1,:), 20);

for i=1:(size(Qrad,1)-1)
    tj{i+1} = jtraj(Qrad(i,:), Qrad(i+1,:), 20);
end

tj{i+2} = jtraj(Qrad(i+1,:), Qini, 20);

for j=1:size(tj,2)
    for i=1:size(tj{1},1)
        joint(i+size(tj{1},1)*(j-1),1) = [tj{j}(i,1)];
        joint(i+size(tj{1},1)*(j-1),2) = [tj{j}(i,2)];
        joint(i+size(tj{1},1)*(j-1),3) = [tj{j}(i,3)];
    end
end

for q=tj{1}'
    Trab.plot(q');
end

for i=1:(size(Qrad,1))
    for q=tj{i+1}'
        Trab.plot(q');
    end
end

%% Communicating
j = 1;

for i=1:size(ProxQdeg,1)
    
    communication(ProxQdeg(i,:));
    
    pause(4);
    
end

%% Ploting the workspace

n=30000; %number of points
theta1min = -170;
theta1max = 170;
theta2min = -160;
theta2max = 160;
theta3min = -180;
theta3max = 180;


for i=n
    for j=n
        for k=n
            
            b=rand(i,1);
            c=rand(j,1);
            d=rand(k,1);
            
            
            t1=(theta1min+(theta1max-theta1min)*b)*pi/180;
            t2=(theta2min+(theta2max-theta2min)*c)*pi/180;
            t3=(theta3min+(theta3max-theta3min)*d)*pi/180;
        end
    end
end
qh = [t1 t2 t3];

Ta=Trab1.fkine(qh);
h = size(Ta);

for i=1:h(2)
    x(i) = Ta(i).t(1);
    y(i) = Ta(i).t(2);
    z(i) = Ta(i).t(3);
end

pcshow([x(:), y(:), z(:)]);
