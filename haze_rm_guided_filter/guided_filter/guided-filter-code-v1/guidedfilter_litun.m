function q = guidedfilter_litun(L, P, r, epsilon)
% L为guided image
% P为待处理的image
% r为filter的半径
% epsilon为最小二乘法中的惩罚参数

sizeOfFilter = boxfilter(ones(size(L)), r);
%% 1st
meanOfL = boxfilter(L, r) ./ sizeOfFilter;
meanOfP = boxfilter(P, r) ./ sizeOfFilter;
meanOfLtimeL = boxfilter(L .* L, r) ./ sizeOfFilter;
meanOfLtimeP = boxfilter(L .*P, r) ./ sizeOfFilter;

%% 2nd
% 在协方差计算公式中, 如果两个变量下相同, 计算结果便是该变量的方差
varOfL = meanOfLtimeL - meanOfL .* meanOfL;
% 协方差计算
covOfLP = meanOfLtimeP - meanOfL .* meanOfP;

%% 3rd
% 计算a的值
a = covOfLP ./ (varOfL + epsilon);
% 计算b的值
b = meanOfP - a .* meanOfL;

%% 4th
% a中每个filter的平均值
meanOfA = boxfilter(a, r) ./ sizeOfFilter;
% b中每个filter的平均值
meanOfB = boxfilter(b, r) ./ sizeOfFilter;

%% 5th
q = meanOfA .* L + meanOfB;

end