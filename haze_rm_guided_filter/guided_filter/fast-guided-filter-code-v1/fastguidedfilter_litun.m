function q = fastguidedfilter_litun(L, P, r, epsilon, s)
% L 是guded image
% P 是输入的图像
% r是filter的半径大小
% epsilon是loss function的惩罚项
% s 是采样度

Ls = imresize(L, 1/s, 'nearest');
Ps = imresize(P, 1/s, 'nearest');
rs = r / s;

% sizeOfFilter保存每个filter的大小
sizeOfFilter = boxfilter(ones(size(Ls)), rs);
% meanOfLs保存L中每个filter的平均值
meanOfLs = boxfilter(Ls, rs) ./ sizeOfFilter;
meanOfPs = boxfilter(Ps, rs) ./ sizeOfFilter;
meanOfLsTimeLs = boxfilter(Ls .* Ls, rs) ./ sizeOfFilter;
meanOfLsTimePs = boxfilter(Ls .* Ps, rs) ./ sizeOfFilter;

% 协方差中两个变量若一样, 所得结果便是方差
varOfLs = meanOfLsTimeLs - meanOfLs .* meanOfLs;
% Ls和Ps的协方差
covOfLsPs = meanOfLsTimePs - meanOfLs .* meanOfPs;

% 最小二乘法求解参数a和b
a = covOfLsPs ./ (varOfLs + epsilon);
b = meanOfPs - a .* meanOfLs;

% 参数a的filter平均值
meanOfA = imresize(boxfilter(a, rs) ./ sizeOfFilter, size(L), 'bilinear');
% 参数b的filter平均值
meanOfB = imresize(boxfilter(b, rs) ./ sizeOfFilter, size(L), 'bilinear');

q = meanOfA .* L + meanOfB;

end