function imDist = boxfilter_w_h(imSrc, r_w, r_h)
% imSrc 是待boxfilter处理的矩阵
% r_w, r_h 分别是窗口的x, y方向的半径
[hei, wid] = size(imSrc);
imCum = zeros(size(imSrc));
imDist = zeros(size(imSrc));

% 对y方向求窗口中心值累加
imCum = cumsum(imSrc, 1);
imDist(1: r_h + 1, :) = imCum(r_h + 1: 2 * r_h + 1, :);
imDist(r_h + 2: hei - r_h, :) = imCum(2 * r_h + 2: hei, :) - imCum(1: hei - 2 * r_h - 1, :);
imDist(hei - r_h + 1: hei, :) = repmat(imCum(hei, :), [r_h, 1]) - imCum(hei - 2 * r_h: hei - r_h - 1, :);

% 对x方向求窗口中心值累加
imCum = cumsum(imDist, 2);
imDist(:, 1: r_w + 1) = imCum(:, r_w + 1: 2 * r_w + 1);
imDist(:, r_w + 2: wid - r_w) = imCum(:, 2 * r_w + 2: wid) - imCum(:, 1: wid - 2 * r_w - 1);
imDist(:, wid - r_w + 1: wid) = repmat(imCum(:, wid), [1, r_w]) - imCum(:, wid - 2 * r_w: wid - r_w - 1);

end