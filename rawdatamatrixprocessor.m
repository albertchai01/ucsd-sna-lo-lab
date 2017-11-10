%% Clean Workspace Before Starting
% Notifies user to clear their workspace before starting the script.
disp('Workspace should be cleared before any data imports!')
disp('Please note that any variables labeled q or r will be used and overwritten')
disp('Press any key to continue...')
pause

%% Introduction to SNA Script
% Welcome to the Social Network Analysis Computing Script
% The purpose of this script is to assist in automating computating groups based on a set number of
% individuals in a group. There are observed limitations that this script can do and must be considered
% with the interpretation of the final output of the data.
%
% This script is intended to be used in Mathworks MATLAB, but it may be compatible in GNU Octave. There
% is no guarantee that this script will work in other programs other than MATLAB and the author(s) make
% no such warranty to do so.
%
% This script was developed by Albert Chai and Andrew S. Lee
% Principal Investigator of Project: Stanley M. Lo
%
% You will need both the rawdatamatrixprocessor.m and importfile.m
% functions in your MATLAB Working Directory file in order to run this
% script properly without error
disp('====================================================')
disp('Social Network Analysis RAW Data Processing Script')
disp('Developed by Albert Chai, Andrew S. Lee, and et al.')
disp('MIT License')
disp('By using this software, you agree to the terms, limitations, and liability of this script.')
disp("Please ensure that 'rawdatamatrixprocessor.m' and 'importfile.m' are in your MATLAB working directory before continuing.")
disp(' ')

%% Data Import and Initial Processing
% Data in this section are being processed for MATLAB/GNU Octave Reading
% Load the file in MATLAB and right click on the data file. Import the file with each column (such as
% one column is q and one is r). Import using the option 'Create vectors from each column using column names'
% If the variables that are imported do not match 'q' or 'r', use q = {importedqname} or r = {importedrname} to 
% correct for the error.
% Output of the data in the command window is automatically surpressed. To see the output, remove the ';'
% (semicolon) from the code.
disp('Please indicate the file name with extension in single quotes in your MATLAB Workspace Working Directory')
disp("such as 'case3-raw.csv'")
disp('MATLAB will reprompt you for the file if the syntax is incorrect!')
userInput = input('File: ');
[q,r] = importfile(userInput);
disp('Data import has been completed...')

%% Question and Response Matrix Creation
% vs is one matrix containing both q and r data
vs = [q, r];
% q0 and r0 replace the NaN values with zeros for matrix addition in vall
q0 = fillmissing(q,'constant',0);
r0 = fillmissing(r,'constant',0);
% vall function will process all the question and response data into one column in order of sequence
vall = q0+r0;

%% Number of participants in the group
% num_participants_active is the number of active participants in the group (both q and r)
num_participants_active = size(unique(vall(vall ~= 0)),1);
disp('Calculated Number of Active Participants...')
fprintf('STATUS: The total number of ACTIVE participants is %d. \n',num_participants_active)

% prompt user for possible non-participants
disp(' ')
num_participants_inactive = round(input('Number of non-participating members (integer >= 0, decimals are rounded): '));
% number of inactive participants cannot be negative
while num_participants_inactive < 0
    num_participants_inactive = input('Sorry, you entered an invalid value, please enter a valid value: ');
    % If user fails to enter a valid number greater than or equal to 0, the script will reprompt until a valid value has been entered.
end

% num_participants_total is the number of total participants
num_participants_total = num_participants_active + num_participants_inactive; 

% Confirm total number of participants: If value is not correct, script will terminate.
fprintf('STATUS: You have entered %d, as number of non-participating members. \n', num_participants_inactive)
fprintf('STATUS: If the value was not an integer, it has been automatically rounded for you. \n')
fprintf('STATUS: Your total number of participants is %d. Please note that this value will be used for necessary calculations. \n', num_participants_total)
maxconfirm=input('Confirm by entering 1 if the value is correct: ');
    if maxconfirm == 1
        disp('Processing...')
    else
        disp('STATUS: The script has been paused, stop the script before continuing. It is recommended that you clear your workspace.')
        disp('STATUS: Please re-run this section and re-enter the proper value.')
        disp('STATUS: Press CTRL+C for Windows to terminate the script')
        pause
    end
% num_participants_total is the number of total participants in the group
% num_participants_active is the number of ACTIVE participants in the group
% num_participants_inactive is the number of non-participants that the user will enter to the script

%% Total number of interactions 
% intot determines the total number of interactions the members in the group has. Based on the vall matrix grid.
intot = length(vall)-1; % last row doesn't count
disp(' ')
fprintf('STATUS: The total number of interactions is %d. \n',intot)

%% Member Discussion Order
% Determines the order in which members discussed

% Create edges that show who talked to whom
% assume the person in line n talked to person in line n+1
% assume the file has >= 2 lines
% edge case: the person in last line does not talk to anyone
vallm = [vall(1:end-1), vall(2:end)];
disp('Discussion order has been created.')

%% Student Matrix Interactions
% Determines the number of times students interact with one another in a directed manner
% master is an adjacency matrix with weights 
%   (nxn array, where master(i,j) = weight of edge (i,j))
%   where n is the total number of participants
%   weights are initialized to zero

% Make all possible edges, initialize weight to zero
disp('Script is preallocating vector size for all possible combinations...')
    master = zeros(num_participants_total, num_participants_total);
disp('Preallocation is complete')

%% Calculate Weight for Edges
for i = 1: 1: size(vallm)
   source = vallm(i,1);
   target = vallm(i,2);
   master(source, target) = master(source, target) + 1;
end

disp("Hello world!");

%% Export Final Results as .csv Files
% Exports all of the calculated data into 2 .csv files, one with edge list
% and one with weight list corresponding to the edge list.

% Writes Edges List
%edges = master(:,1:2);
%csvwrite('edge_list.csv',edges);
%disp('Edge list has been written, check under edge_list.csv')

% Writes Weighted List
%weight = master(:,3);
%csvwrite('weight_list.csv',weight);
%dips('Weight list has been written, check under weight_list.csv')