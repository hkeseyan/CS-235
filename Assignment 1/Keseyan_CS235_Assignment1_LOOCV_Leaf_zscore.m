
%%%%%%%%%%%%%%%%%%%%%% LEAF DATA SET %%%%%%%%%%%%%%%%%%%%%%%%%%%

function Leaf_LOOCV %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% (C) Eamonn Keogh %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
TRAIN = load('leaf.csv'); % Only these two lines need to be changed to test a different dataset. %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    correct = 0; 		   % Initialize the number we got correct
for j = 1 : size(TRAIN,1)-1
    TRAIN = load('leaf.csv');
    TRAIN(:,2) = [];                    % remove column 2 (specimen #) as it does not help with classification
    TEST = TRAIN(j,:);                  % identify the test example
    TRAIN(j,:) = [];                    % remove test example from training set

    TRAIN_class_labels = TRAIN(:,1);     % Pull out the class labels.
    TRAIN(:,1) = [];                    % Remove class labels from training set.
    TEST_class_labels = TEST(:,1);       % Pull out the class labels.
    TEST(:,1) = [];                      % Remove class labels from testing set.

    for i = 1 : size(TRAIN,2)                       % zero-one normalization
        for k = 1 : size(TRAIN,1)
            TRAIN(k,i) = (TRAIN(k,i)-mean(TRAIN(:,i)))/std(TRAIN(:,i));    % subtract each column by the column mean and divide by the column standard deviation
        end   
    end
    
           classify_this_object = TEST(1,:);
           this_objects_actual_class = TEST_class_labels(1);
           predicted_class = Classification_Algorithm(TRAIN,TRAIN_class_labels, classify_this_object);
       if predicted_class == this_objects_actual_class
           correct = correct + 1;         % we got one more correct
       end;
       disp([int2str(j), ' out of ', int2str(size(TRAIN,1)), ' done']) % Report progress

end
%%%%%%%%%%%%%%%%% Create Report %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp(['The dataset you tested has ', int2str(length(unique(TRAIN_class_labels))), ' classes'])
disp(['The training set is of size ', int2str(size(TRAIN,1)),', and the test set is of size ',int2str(size(TEST,1)),'.'])
disp(['The time series are of length ', int2str(size(TRAIN,2))])
disp(['The error rate was ',num2str((size(TRAIN,1)-correct )/size(TRAIN,1))])
%%%%%%%%%%%%%%%%% End Report %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function predicted_class = Classification_Algorithm(TRAIN,TRAIN_class_labels,unknown_object)
best_so_far = inf;
 for i = 1 : length(TRAIN_class_labels)
     compare_to_this_object = TRAIN(i,:);
     distance = sqrt(sum((compare_to_this_object - unknown_object).^2)); % Euclidean distance
        if distance < best_so_far
          predicted_class = TRAIN_class_labels(i);
     best_so_far = distance;
    end
end;

