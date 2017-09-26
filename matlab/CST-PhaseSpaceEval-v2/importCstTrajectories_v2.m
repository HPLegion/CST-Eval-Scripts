%function [p_id, p_time, p_x, p_y, p_z, p_npx, p_npy, p_npz] = importCstTrajectories_v2(filename)
function [p_id, p_time, ps_data] = importCstTrajectories_v2(filename, varargin)
%% Open File
%filename = 'starbeam_intf.txt';
if ~isempty(varargin)
    filepath = varargin{1};
else
    filepath ='';
end
fileID = fopen([filepath,filename],'r');

%% Read File Header
FileHeader = textscan(fileID,'%s',19,'Delimiter','\n'); %Read Header

counter = 0;

%% Read File Content
while ~feof(fileID)
    %Set Counter
    counter = counter+1;
    
    %Read particle metadata
    blockheader = textscan(fileID,'%% particle %d, mass: %f kg, charge: %f C, current: %f A');
    
    %Save particle metadata
    p_id{counter,1}=blockheader{1};
    p_mass{counter,1}=blockheader{2};
    p_charge{counter,1}=blockheader{3};
    p_current{counter,1}=blockheader{4};
    
    %Read trajectory data block
    datablock = textscan(fileID,'%f%f%f%f%f%f%f',...
        'Delimiter',' ','MultipleDelimsAsOne',1);
    
    %Save trajectory data
    p_time{counter,1} = datablock{1};
    p_x{counter,1} = datablock{2};
    p_y{counter,1} = datablock{3};
    p_z{counter,1} = datablock{4};
    p_npx{counter,1} = datablock{5};
    p_npy{counter,1} = datablock{6};
    p_npz{counter,1} = datablock{7};
end

%% Close file and clean up
fclose(fileID);
n = counter;
clear datablock blockheader counter filename fileID

%% Reshape Data
%Generate Cell with 3D-Coordinates
p_pos = cell(n,1);
for k=1:n
    p_pos{k,1}=[p_x{k},p_y{k},p_z{k}];
end

%Generate Cell with 3D-normalised momenta
p_nmom = cell(n,1);
for k=1:n
    p_nmom{k,1}=[p_npx{k},p_npy{k},p_npz{k}];
end
ps_data = struct('p_x', {p_x}, 'p_y', {p_y}, 'p_z', {p_z},...
    'p_npx', {p_npx}, 'p_npy', {p_npy}, 'p_npz', {p_npz});

clear k
% clear p_npx p_npy p_npz p_x p_y p_z % Not needed at the moment
% clear p_charge p_mass p_current % Not needed at the moment