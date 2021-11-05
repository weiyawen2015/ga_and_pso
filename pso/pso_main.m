clear;
clc
close all
nvar = 2;
xmin = -1;
xmax = 1;
vmin = -0.08*(xmax-xmin);
vmax = -vmin;
% 系数
phi1 = 2.5;
phi2 = 2.5;
phi = phi1+phi2;
   if phi>4
     K = 2/abs(2-(phi)-sqrt(phi.^2-4*phi));%chi为收缩系数
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
   %% 初始化
    for i = 1:num_part
        particle(i).loc = unifrnd(xmin, xmax, varsize);%随机初始
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
       %% 更新
        for i = 1:num_part
            % 速度 驱赶到v_min to v_max之间
          particle(i).vel =  max(min(K*(particle(i).vel + phi1*unifrnd(0,a1,varsize).*(particle(i).best.loc ...
                            - particle(i).loc) + phi2*unifrnd(0,a2,varsize).*(globest.loc - particle(i).loc)),vmax),vmin);
          % 自变量 驱赶到x_min to x_max之间
            particle(i).loc = min(max(particle(i).loc + particle(i).vel, xmin),xmax);
            %函数
            s_cost_iter(i,1) = my_obj(particle(i).loc);  
            particle(i).cost = s_cost_iter(i,1);
            if particle(i).cost < particle(i).best.cost %更新最优值
                particle(i).best.loc = particle(i).loc; %更新单个粒子的历史最优值对应的x
                particle(i).best.cost = particle(i).cost; %更新单个粒子的历史最优值cost
                if particle(i).best.cost < globest.cost %更新全局最优值cost
                    globest = particle(i).best;
                end
            end
        end 
    meancost(iter) = mean(s_cost_iter);
      %% 更新速度向量与cost 
        bestcost(iter) = globest.cost;
        disp(['Iteration ' num2str(iter) '| mean cost ' num2str(meancost(iter)) '| global_cost ' num2str(bestcost(iter))]);
     if  iter==1
        dert_globest_cost = 1;
     else
          dert_globest_cost = abs(meancost(iter) - meancost(iter-1));
     end
        iter = iter + 1;
end

  disp('平均最优值')
 meanobj = meancost(iter-1)
  disp('全局最优值')
 bestobj = globest.cost
 disp('最优值对应自变量')
 x_obj = globest.loc
 %% 画优化曲线
   figure(2)
    plot(1:iter-1,bestcost(1:iter-1));
    title('最优个体适配值曲线');
   figure(3)

    plot(1:iter-1,meancost(1:iter-1));
     title('平均适配值曲线');


figure(4)
[X,Y] = meshgrid(xmin:0.01:xmax, xmin:0.01:xmax);
Z = X.^2 + Y.^2-0.3*cos(3*pi*X) - 0.4*cos(4*pi*Y)+0.7;
mesh(X,Y,Z);
view(45,55); 