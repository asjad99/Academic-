% Image Segmentation Using K-Means Clustering
%---------------------------------------------------

% Read Image
input_img = imread('path22.jpg');

% Convert the input image from RGB Color Space to Lab Color Space
cform = makecform('srgb2lab');

trans_val = applycform(input_img,cform);


temp_val = double(trans_val(:,:,2:3));
Total_rows = size(temp_val,1);
total_columns = size(temp_val,2);
temp_val = reshape(temp_val,Total_rows*total_columns,2);

Total_colors = 2;

%---------------------------------------------------
%In this step we perform Classification of the pixcel values(based on their Colors) in Using K-Means Clustering
% using using the Euclidean distance metric. All objects in the input image will belong to a certain cluster determined
%by K-Means. Objects can be distinguished using cluter index value returned
%by kmeans algorithm.
%---------------------------------------------------
[cluster_index, cluster_index_value] = kmeans(temp_val,Total_colors,'distance','sqEuclidean', ...
                                      'Replicates',3);
                              

%in this step pixels are labeled using results from previous step
%---------------------------------------------------
pixel_labels = reshape(cluster_index,Total_rows,total_columns);


% we use the pixel label info to separate object in given path image(Note: label info is based
% on color variations)
%---------------------------------------------------

segmented_images_array = cell(1,3);
rgb_label = repmat(pixel_labels,[1 1 3]);

%to whiten other objects in the image 
for k = 1:Total_colors
    color = input_img;
    color(rgb_label ~= k) = 255; 
    segmented_images_array{k} = color;
end


%Display the results 
%---------------------------------------------------
subplot(1,2,1), imshow(segmented_images_array{1}), title('Extracted Object 1 (Cluster 1)') 
subplot(1,2,2), imshow(segmented_images_array{2}), title('Extracted Object 2 (Cluster 2)')
