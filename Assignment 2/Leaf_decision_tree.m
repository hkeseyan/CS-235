function  LeafDT()
 
LEAF = load('leaf.csv')                            % Load the data
LEAF(:,2) = [];                 % do not need column 2
meas = LEAF(:,2:15);
species = LEAF(:,1);

n = size(meas,1);                          % How many instances do we have? 
%rng(1)                                     % Seed the random number generator for reproducibility
idxTrn = false(n,1);                       % Initialize a vector of indices to a train subset
idxTrn(randsample(n,round(0.5*n))) = true; % Training set logical indices
idxVal = idxTrn == false;                  % Validation set logical indices
 
% Learn a tree ONLY on the idxTrn subset: Call it Md1, as in Model 1
Mdl = fitctree(meas(idxTrn,:),species(idxTrn),'PredictorNames',{'Eccentricity', 'Aspect Ratio', 'Elongation', 'Solidity', 'Stochastic Convexity', 'Isoperimetric Factor', 'Maximal Indentation Depth', 'Lobedness', 'Average Intensity', 'Average Contrast', 'Smoothness', 'Third moment', 'Uniformity', 'Entropy'});
 
view(Mdl,'Mode','graph')                   % Let us see the tree we learned
 
for i = 1:30
    % Classify ONLY the idxVal subset
    label = predict(Mdl,meas(idxVal,:));       % Predict (classify) the test data, on the trained model
    [label,species(idxVal)]                    % Echo the predicted and then true labels side by side
    numMisclass(i) = sum(~strcmp(label,species(idxVal)))  % How many did we get wrong?
end;
disp(sum(numMisclass)/30/n)
histogram(species)
title('Decision Tree for Leaf Species')
end
