function [pos_xm, pos_ym, pos_zm, D1, D2, D3, D4, D5, D6, omegax, omegay, omegaz, fx, fy, fz, angle_xdeg, angle_ydeg, angle_zdeg, time] = importfile(workbookFile, sheetName, dataLines)
%IMPORTFILE 导入电子表格中的数据
%  [POS_XM, POS_YM, POS_ZM, D1, D2, D3, D4, D5, D6, OMEGAX, OMEGAY,
%  OMEGAZ, FX, FY, FZ, ANGLE_XDEG, ANGLE_YDEG, ANGLE_ZDEG, TIME] =
%  IMPORTFILE(FILE) 读取名为 FILE 的 Microsoft Excel 电子表格文件的第一张工作表中的数据。
%  以列向量形式返回数据。
%
%  [POS_XM, POS_YM, POS_ZM, D1, D2, D3, D4, D5, D6, OMEGAX, OMEGAY,
%  OMEGAZ, FX, FY, FZ, ANGLE_XDEG, ANGLE_YDEG, ANGLE_ZDEG, TIME] =
%  IMPORTFILE(FILE, SHEET) 从指定的工作表中读取。
%
%  [POS_XM, POS_YM, POS_ZM, D1, D2, D3, D4, D5, D6, OMEGAX, OMEGAY,
%  OMEGAZ, FX, FY, FZ, ANGLE_XDEG, ANGLE_YDEG, ANGLE_ZDEG, TIME] =
%  IMPORTFILE(FILE, SHEET, DATALINES)按指定的行间隔读取指定工作表中的数据。对于不连续的行间隔，请将
%  DATALINES 指定为正整数标量或 N×2 正整数标量数组。
%
%  示例:
%  [pos_xm, pos_ym, pos_zm, D1, D2, D3, D4, D5, D6, omegax, omegay, omegaz, fx, fy, fz, angle_xdeg, angle_ydeg, angle_zdeg, time] = importfile("E:\文件\复习\室内定位\数据采集实习\data2.xlsx", "NLink_LinkTrack_Tag_Frame0", [1, 3159]);
%
%  另请参阅 READTABLE。
%
% 由 MATLAB 于 2023-11-12 16:47:11 自动生成

%% 输入处理

% 如果未指定工作表，则将读取第一张工作表
if nargin == 1 || isempty(sheetName)
    sheetName = 1;
end

% 如果未指定行的起点和终点，则会定义默认值。
if nargin <= 2
    dataLines = [1, 3159];
end

%% 设置导入选项并导入数据
opts = spreadsheetImportOptions("NumVariables", 28);

% 指定工作表和范围
opts.Sheet = sheetName;
opts.DataRange = "A" + dataLines(1, 1) + ":AB" + dataLines(1, 2);

% 指定列名称和类型
opts.VariableNames = ["pos_xm", "pos_ym", "pos_zm", "Var4", "Var5", "Var6", "Var7", "D1", "D2", "D3", "D4", "D5", "D6", "Var14", "omegax", "omegay", "omegaz", "fx", "fy", "fz", "angle_xdeg", "angle_ydeg", "angle_zdeg", "Var24", "Var25", "Var26", "Var27", "time"];
opts.SelectedVariableNames = ["pos_xm", "pos_ym", "pos_zm", "D1", "D2", "D3", "D4", "D5", "D6", "omegax", "omegay", "omegaz", "fx", "fy", "fz", "angle_xdeg", "angle_ydeg", "angle_zdeg", "time"];
opts.VariableTypes = ["double", "double", "double", "char", "char", "char", "char", "double", "double", "double", "double", "double", "double", "char", "double", "double", "double", "double", "double", "double", "double", "double", "double", "char", "char", "char", "char", "double"];

% 指定变量属性
opts = setvaropts(opts, ["Var4", "Var5", "Var6", "Var7", "Var14", "Var24", "Var25", "Var26", "Var27"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var4", "Var5", "Var6", "Var7", "Var14", "Var24", "Var25", "Var26", "Var27"], "EmptyFieldRule", "auto");

% 导入数据
tbl = readtable(workbookFile, opts, "UseExcel", false);

for idx = 2:size(dataLines, 1)
    opts.DataRange = "A" + dataLines(idx, 1) + ":AB" + dataLines(idx, 2);
    tb = readtable(workbookFile, opts, "UseExcel", false);
    tbl = [tbl; tb]; %#ok<AGROW>
end

%% 转换为输出类型
pos_xm = tbl.pos_xm;
pos_ym = tbl.pos_ym;
pos_zm = tbl.pos_zm;
D1 = tbl.D1;
D2 = tbl.D2;
D3 = tbl.D3;
D4 = tbl.D4;
D5 = tbl.D5;
D6 = tbl.D6;
omegax = tbl.omegax;
omegay = tbl.omegay;
omegaz = tbl.omegaz;
fx = tbl.fx;
fy = tbl.fy;
fz = tbl.fz;
angle_xdeg = tbl.angle_xdeg;
angle_ydeg = tbl.angle_ydeg;
angle_zdeg = tbl.angle_zdeg;
time = tbl.time;
pos_xm(1,:)=[];
pos_ym(1,:)=[];
pos_zm(1,:)=[];
D1(1,:)=[];
D2(1,:)=[];
D3(1,:)=[];
D4(1,:)=[];
D5(1,:)=[];
D6(1,:)=[];
omegax(1,:)=[];
omegay(1,:)=[];
omegaz(1,:)=[];
fx(1,:)=[];
fy(1,:)=[];
fz(1,:)=[];
angle_xdeg(1,:)=[];
angle_ydeg(1,:)=[];
angle_zdeg(1,:)=[];
time(1,:)=[];
end