%% 从文本文件中导入数据
% 用于从以下文本文件中导入数据的脚本:
%
%    filename: E:\文件\复习\室内定位\数据-行人航迹推算\sensors_matrix.txt
%
% 由 MATLAB 于 2023-10-25 14:42:08 自动生成

%% 设置导入选项并导入数据
opts = delimitedTextImportOptions("NumVariables", 10);

% 指定范围和分隔符
opts.DataLines = [1, Inf];
opts.Delimiter = ",";

% 指定列名称和类型
opts.VariableNames = ["time", "omegax", "omegay", "omegaz", "fx", "fy", "fz", "Mx", "My", "Mz"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

% 指定文件级属性
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% 导入数据
tbl = readtable("E:\文件\复习\室内定位\数据-行人航迹推算\sensors_matrix.txt", opts);

%% 转换为输出类型
time = tbl.time;
omegax = tbl.omegax;
omegay = tbl.omegay;
omegaz = tbl.omegaz;
fx = tbl.fx;
fy = tbl.fy;
fz = tbl.fz;
Mx = tbl.Mx;
My = tbl.My;
Mz = tbl.Mz;

%% 清除临时变量
clear opts tbl