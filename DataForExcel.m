%% Import Data

ColumnIndices = []

% Extract data from structure

Data1 = data{1, 1}.experimentData.realFeedbackShown %% extract data from structure (1x1 cell) - change nr if other structure
Data2 = data{1, 1}.experimentData.visualFeedbackShown
Data3 = data{1, 1}.experimentData.realFeedbackPercentageShown
Data4 = data{1, 1}.experimentData.visualFeedbackPercentageShown

% Remove columns with bad data (ColumnIndices)

Data1(:,ColumnIndices)=[] %% Remove columns without values, replace X with # column (e.g. (1,1) if column 1 is missing. 
                       %%If mulitple, then add them as vector, e.g. (:,[1 3])
Data2(:,ColumnIndices)=[] %% Remove columns without values, replace X with # column (e.g. (1,1) if column 1 is missing. 
                       %%If mulitple, then add them as vector, e.g. (:,[1 3])
Data3(:,ColumnIndices)=[] %% Remove columns without values, replace X with # column (e.g. (1,1) if column 1 is missing. 
                       %%If mulitple, then add them as vector, e.g. (:,[1 3])
Data4(:,ColumnIndices)=[] %% Remove columns without values, replace X with # column (e.g. (1,1) if column 1 is missing. 
                       %%If mulitple, then add them as vector, e.g. (:,[1 3])
                       

% Convert data to cell format and transpose                   

Data1Converted = cell2mat(Data1) %% Extract as cells - not structure
Data2Converted = cell2mat(Data2)
Data3Converted = cell2mat(Data3)' %% 'transpose 
Data4Converted = cell2mat(Data4)'

% Extract specific values and transpose 

Dat1_1 = Data1Converted(1:2:end)'   %% Convert data, starting at cell 1, jumps 2 each time, finish at the End of data. The ' transposes the data
Dat1_2 = Data1Converted(2:2:end)'
Dat2_1 = Data2Converted(1:2:end)'
Dat2_2 = Data2Converted(2:2:end)'
Dat3 = Data3Converted
Dat4 = Data4Converted


DataAll = [Dat1_1 Dat1_2 Dat2_1 Dat2_2 Dat3 Dat4]
AsTable = Table(DataAll)