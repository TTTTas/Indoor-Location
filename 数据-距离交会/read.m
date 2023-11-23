%% 从文本文件中导入数据
% 用于从以下文本文件中导入数据的脚本:
%
%    filename: E:\文件\复习\室内定位\数据-距离交会\range.txt
%
% 由 MATLAB 于 2023-10-24 16:56:19 自动生成

%% 设置导入选项并导入数据
opts = delimitedTextImportOptions("NumVariables", 6);

% 指定范围和分隔符
opts.DataLines = [1, Inf];
opts.Delimiter = " ";

% 指定列名称和类型
opts.VariableNames = ["time", "D2", "D4", "D6", "D8", "H"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double"];

% 指定文件级属性
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
opts.ConsecutiveDelimitersRule = "join";
opts.LeadingDelimitersRule = "ignore";

% 导入数据
tbl = readtable("range-with-height.txt", opts);

%% 转换为输出类型
time = tbl.time;
D2 = tbl.D2;
D4 = tbl.D4;
D6 = tbl.D6;
D8 = tbl.D8;
H = tbl.H;

%% 清除临时变量
clear opts tbl
%% 设置导入选项并导入数据
opts = delimitedTextImportOptions("NumVariables", 6);

% 指定范围和分隔符
opts.DataLines = [1, Inf];
opts.Delimiter = " ";

% 指定列名称和类型
opts.VariableNames = ["VarName1", "VarName2", "VarName3", "VarName4", "VarName5", "VarName6"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double"];

% 指定文件级属性
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
opts.ConsecutiveDelimitersRule = "join";
opts.LeadingDelimitersRule = "ignore";

% 导入数据
basestationlocation = readtable("base-station-location.txt", opts);

%% 转换为输出类型
basestationlocation = table2array(basestationlocation);

%% 清除临时变量
clear opts