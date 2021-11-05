clear all
clc
close all
%% ����
parameter.nvar = 2;
parameter.xmin = -1;
parameter.xmax = 1;
parameter.m = 50; 
parameter.k = 15;%��������ֵ֮�����ĳ���
parameter.num_part =10;
itermax = 2000;
crossover_probability = 0.5;
mutation_probability = 0.001;
num_part = parameter.num_part;
nvar = parameter.nvar; 
xmin = parameter.xmin;
xmax = parameter.xmax;
m = parameter.m;

   %% ��ʼ��
    generation = repmat([], num_part, 1);
    for i = 1:num_part
        generation(i).x_bi = randi([0,1],1,parameter.nvar*parameter.m);%�����ʼ
        generation(i).cost = my_obj(generation(i).x_bi,parameter);
    end
   
   generation_new =generation;   
   dert_mean_cost = 1;
    
iter = 1;
while(dert_mean_cost>1e-10&&iter<=itermax)
generation = generation_new;
%% ����ѡ��
[cost_sort index] = sort([generation.cost]');
generation_sort = generation(index);%��С���� ��Ӧ
   for i = 1:num_part
      fitness(i) = parameter.k*(num_part-i)/num_part;
   end 
fitness_percent = fitness/sum(fitness);
[generation_selet] = percent_select(generation_sort,fitness,parameter); 
%% ����
 [generation_cross] = crossover(generation_selet,crossover_probability,parameter);
%% ���죬                     
[generation_new] = mutation(generation_cross,mutation_probability,parameter);

best(iter).cost = 10;
 
for i = 1:num_part
    generation_new(i).cost = my_obj(generation_new(i).x_bi,parameter);
    if generation_new(i).cost< best(iter).cost
        best(iter).cost = generation_new(i).cost;
        best(iter).x_bi = generation_new(i).x_bi;
    end
    %-------------------------------
    x_obj =generation_new(i).x_bi;
    b(1) = bi2de(x_obj(1:m));
    b(2) = bi2de(x_obj(m+1:nvar*m));
    x = xmin + b*(xmax-xmin)/(2^m-1);
    tempX(iter,i) =x(1);
    tempY(iter,i) =x(2);
    %-------------------
end
    meancost(iter) = mean([generation_new.cost]);
        disp(['Iteration ' num2str(iter) '| mean cost ' num2str(meancost(iter)) '| best_cost ' num2str(best(iter).cost)]);
     if  iter==1
        dert_mean_cost = 1;
     else
          dert_mean_cost = abs(meancost(iter) - meancost(iter-1));
     end
    iter = iter + 1;
end

  disp('ƽ������ֵ')
 meanobj = meancost(iter-1)
  disp('ȫ������ֵ')
 bestobj =  best(iter-1).cost
 disp('����ֵ��Ӧ�Ա���')
nvar = parameter.nvar; 
xmin = parameter.xmin;
xmax = parameter.xmax;
m = parameter.m;
 x_obj = best(iter-1).x_bi;
b(1) = bi2de(x_obj(1:m));
b(2) = bi2de(x_obj(m+1:nvar*m));
x = xmin + b*(xmax-xmin)/(2^m-1)

 %% ���Ż�����
   figure(2)
    plot(1:iter-1,[best.cost]);
    title('���Ÿ�������ֵ����');
   figure(3)
    plot(1:iter-1,meancost(1:iter-1));
     title('ƽ������ֵ����');


