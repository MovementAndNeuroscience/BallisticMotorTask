DataForMean = data{1, 1}.experimentData.visualFeedbackShown %% extract data from structure

DataForMean(:,1)=[] %% Remove columns without values, replace X with # column (e.g. (1,1) if column 1 is missing. 
                       %%If mulitple, then add them as vector, e.g. (:,[1 3])

DataConverted = cell2mat(DataForMean) %% Extract as cells - not structure

MeanIs = mean(DataConverted(1:2:end))

