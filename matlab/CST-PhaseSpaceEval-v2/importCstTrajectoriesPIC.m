%function [p_id, p_time, p_x, p_y, p_z, p_npx, p_npy, p_npz] = importCstTrajectories_v2(filename)
function [p_id, p_sid, p_time, ps_data] = importCstTrajectoriesPIC(filename, varargin)
%% Open File
%filename = 'starbeam_intf.txt';
if ~isempty(varargin)
    filepath = varargin{1};
else
    filepath ='';
end
fileID = fopen([filepath,filename],'r');

%% Read File Header
FileHeader = textscan(fileID,'%s',7,'Delimiter','\n'); %Read Header

%READ WHOLE FILE
formatspec = [repmat('%f',1,10),repmat('%d',1,2)];
DATA = textscan(fileID, formatspec ,'Delimiter',' ','MultipleDelimsAsOne',1);
fclose(fileID);
%ExtractFileIDs
p_id = num2cell(unique(DATA{11},'stable'));
n = length(p_id);

p_sid=cell(n,1);
p_mass=cell(n,1);
p_charge=cell(n,1);
p_time=cell(n,1);
p_x=cell(n,1);
p_y=cell(n,1);
p_z=cell(n,1);
p_npx=cell(n,1);
p_npy=cell(n,1);
p_npz=cell(n,1);

for k =1:n
    mask = (DATA{11} == p_id{k});
    min_ind = find(mask,1);
    
    
     
    p_x{k} = 1000*DATA{1}(mask); %converted to mm
    p_y{k} = 1000*DATA{2}(mask);
    p_z{k} = 1000*DATA{3}(mask);
    
    p_npx{k} = DATA{4}(mask);
    p_npy{k} = DATA{5}(mask);
    p_npz{k} = DATA{6}(mask);
    
    p_mass{k}=DATA{7}(min_ind);
    p_charge{k}=DATA{8}(min_ind);
    %MacroCharge firstline{9}
    
    p_time{k} = DATA{10}(mask);
    
    p_sid{k}=DATA{12}(min_ind); %source ID
    
end

%% Reshape Data
%Generate Cell with 3D-Coordinates
% p_pos = cell(n,1);
% for k=1:n
%     p_pos{k,1}=[p_x{k},p_y{k},p_z{k}];
% end
% 
% %Generate Cell with 3D-normalised momenta
% p_nmom = cell(n,1);
% for k=1:n
%     p_nmom{k,1}=[p_npx{k},p_npy{k},p_npz{k}];
% end
ps_data = struct('p_x', {p_x}, 'p_y', {p_y}, 'p_z', {p_z},...
    'p_npx', {p_npx}, 'p_npy', {p_npy}, 'p_npz', {p_npz});

clear k
