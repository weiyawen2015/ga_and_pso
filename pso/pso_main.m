clear;
clc
close all
nvar = 2;
xmin = -1;
xmax = 1;
vmin = -0.08*(xmax-xmin);
vmax = -vmin;
% ϵ��
phi1 = 2.5;
phi2 = 2.5;
phi = phi1+phi2;
   if phi>4
     K = 2/abs(2-(phi)-sqrt(phi.^2-4*phi));%chiΪ����ϵ��
   else
      K = 1;  
   end
itermax = 2000;
num_part = 50;
    a1 = 1;%history
    a2 = 1;%global

    varsize = [1 nvar]; 
    globest.cost = inf;
    particle = repmat([], num_part, 1);
   %% ��ʼ��
    for i = 1:num_part
        particle(i).loc = unifrnd(xmin, xmax, varsize);%�����ʼ
        particle(i).vel = zeros(varsize);
        particle(i).cost = my_obj(particle(i).loc);
        particle(i).best.loc = particle(i).loc;
        particle(i).best.cost = particle(i).cost;   
        if particle(i).best.cost < globest.cost
            globest = particle(i).best;
        end
    end
    bestcost = zeros(itermax,1);
    s_cost_iter = zeros(num_part,1);
    globest_cost_old = 10;
    dert_globest_cost  = 1;
%     for iter = 1:itermax
iter = 1;
while(dert_globest_cost>1e-10&&iter<=itermax)
       %% ����
        for i = 1:num_part
            % �ٶ� ���ϵ�v_min to v_max֮��
          particle(i).vel =  max(min(K*(particle(i).vel + phi1*unifrnd(0,a1,varsize).*(particle(i).best.loc ...
                            - particle(i).loc) + phi2*unifrnd(0,a2,varsize).*(globest.loc - particle(i).loc)),vmax),vmin);
          % �Ա��� ���ϵ�x_min to x_max֮��
            particle(i).loc = min(max(particle(i).loc + particle(i).vel, xmin),xmax);
            %����
            s_cost_iter(i,1) = my_obj(particle(i).loc);  
            particle(i).cost = s_cost_iter(i,1);
            if particle(i).cost < particle(i).best.cost %��������ֵ
                particle(i).best.loc = particle(i).loc; %���µ������ӵ���ʷ����ֵ��Ӧ��x
                particle(i).best.cost = particle(i).cost; %���µ������ӵ���ʷ����ֵcost
                if particle(i).best.cost < globest.cost %����ȫ������ֵcost
                    globest = particle(i).best;
                end
            end
        end 
    meancost(iter) = mean(s_cost_iter);
      %% �����ٶ�������cost 
        bestcost(iter) = globest.cost;
        disp(['Iteration ' num2str(iter) '| mean cost ' num2str(meancost(iter)) '| global_cost ' num2str(bestcost(iter))]);
     if  iter==1
        dert_globest_cost = 1;
     else
          dert_globest_cost = abs(meancost(iter) - meancost(iter-1));
     end
        iter = iter + 1;
end

  disp('ƽ������ֵ')
 meanobj = meancost(iter-1)
  disp('ȫ������ֵ')
 bestobj = globest.cost
 disp('����ֵ��Ӧ�Ա���')
 x_obj = globest.loc
 %% ���Ż�����
   figure(2)
    plot(1:iter-1,bestcost(1:iter-1));
    title('���Ÿ�������ֵ����');
   figure(3)

    plot(1:iter-1,meancost(1:iter-1));
     title('ƽ������ֵ����');


figure(4)
[X,Y] = meshgrid(xmin:0.01:xmax, xmin:0.01:xmax);
Z = X.^2 + Y.^2-0.3*cos(3*pi*X) - 0.4*cos(4*pi*Y)+0.7;
mesh(X,Y,Z);
view(45,55); 