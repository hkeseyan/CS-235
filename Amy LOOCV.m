function UCR_time_series_test
TRAIN = load('Strawberry_TRAIN');  
%TEST = load('50words_TEST');


TRAIN_class_labels = TRAIN(:,1);    %Pull out the class labels
TRAIN(:,1) = [];    % Remove class labels from training set
%TEST_class_labels = TEST(:,1);  %Pull out the class labels
%TEST(:,1)=[];   %Remove class labels from testing set
correct=0;  % Initialize the number we got correct
for i= 1 : length(TRAIN_class_labels)    %Loop over every instance in the test set
classify_this_object = TRAIN(i,:);
this_objects_actual_class = TRAIN_class_labels(i);
predicted_class = LOO_Classification_Algorithm(i, TRAIN,TRAIN_class_labels,classify_this_object);
if predicted_class == this_objects_actual_class
correct = correct +1; %We got one more correct
end;
disp([int2str(i), ' out of ', int2str(length(TRAIN_class_labels)), ' done'])
end;

disp(['The dataset you tested has ', int2str(length(unique(TRAIN_class_labels))), ' classes'])
%disp(['The training set is of size ', int2str(size(TRAIN,1)),', and the test set is of size ',int2str(size(TRAIN,1)),'.'])
disp(['The training set is of size ', int2str(size(TRAIN,1)),'.'])
disp(['The time series are of length ', int2str(size(TRAIN,2))])
disp(['The error rate was ', num2str((length(TRAIN_class_labels)-correct )/length(TRAIN_class_labels))])

%Here is a sample classification algorithm, it is one-nearest neighbor
%using the Euclidean distance

function predicted_class = LOO_Classification_Algorithm(LO_no, TRAIN,TRAIN_class_labels,unknown_object)
best_so_far = inf;
for i = 1 : length(TRAIN_class_labels)
    if i ~= LO_no
     compare_to_this_object = TRAIN(i,:);
     distance = sqrt(sum((compare_to_this_object - unknown_object).^2)); %Euclidean distance
     if distance < best_so_far
         predicted_class = TRAIN_class_labels(i);
      best_so_far = distance;
     end
    end
end;
