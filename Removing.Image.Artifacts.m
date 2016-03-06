%read given compressed image image

f = imread('portrait_compressed_10.jpg');
input = f;
ref = imread('portrait.bmp');

f = double(f);
img_size = size(f);

%Declare Thresholds

Threshold_1 = 350;
Threshold_2 = 120;
Threshold_3 = 60;

%---------------------------------------------------------- 
%PHASE 1: iterating through input image using Horizontally Adjacent Blocks 
%---------------------------------------------------------- 

for row_pixel = 1:8:(img_size(1) - 16)
    
   for column_pixel = 1:8:(img_size(2) - 16)
        
       % Extract 8x8 Blocks A,B,C. Blocks C is an overlap of Block A and B 
       % and contains boundry pixels of both blocks. 
       f_blockA = f(row_pixel:row_pixel + 7,column_pixel: column_pixel + 7);  
       f_blockC = f(row_pixel:row_pixel+7,column_pixel + 4 : column_pixel + 11);
       f_blockB = f(row_pixel :row_pixel +7,column_pixel + 8:  column_pixel + 15);
        
       %calculate two-dimensional discrete cosine transform of Blocks A,B,C
       DCT_blockA = dct2(f_blockA);
       DCT_blockB = dct2(f_blockB);
       DCT_blockC = dct2(f_blockC);
       
      %Condition 1: checks if Block A has a similar horizontal frequency property as block B.
      %in the if condition we check if first row of the DCT matrix block A
      %and of block B are close in values or not 
      
      %Condition 2: boundary between block A and block B belongs to a relatively smooth region.
      % we check if block C is of low frequency content. if textures and other strong diagonal edges are present then it
      % would result in relatively high values of DCT co-efficients 
       
       diff1 = (DCT_blockA(1,1) - DCT_blockB(1,1));
       diff2 =  (DCT_blockA(1,2) - DCT_blockB(1,2));
       diff3 =  (DCT_blockC(4,4));   
      
      if (diff1 < Threshold_1 && diff2 < Threshold_2 && diff3 < Threshold_3) 
           
      %calculating the modified DCT coefficient of block C.
      %New values for column 0,1,3,5,7 would be calculated using weighted average of blocks A,B,C 
      %alpha = 0.6, Beta = 0.2 for case v=0, v=1. 
      
      %case v=0    
        DCT_blockC(1,1) = 0.6 *  DCT_blockC(1,1) + 0.2 * (DCT_blockA(1,1) +  DCT_blockB(1,1));
        
      %case v=1 
        DCT_blockC(1,2) = 0.6 *  DCT_blockC(1,2) + 0.2 * (DCT_blockA(1,2) +  DCT_blockB(1,2));
        
       %0.5 and 0.25 are the values of alpha and beta are used for columns 3,5,7 
       %case v=3 
         DCT_blockC(1,4) = 0.5 *  DCT_blockC(1,4) + 0.25 * (DCT_blockA(1,4) +  DCT_blockB(1,4));
        
       %case v=5
         DCT_blockC(1,6) = 0.5 *  DCT_blockC(1,6) + 0.25 * (DCT_blockA(1,6) +  DCT_blockB(1,6));
       
       %calculate inverse dct of modified block C 
       %case v=7 
        DCT_blockC(1,8) = 0.5 *  DCT_blockC(1,8) + 0.25 * (DCT_blockA(1,8) +  DCT_blockB(1,8));         
        
        %calculate inverse dct
       inv_DCT_blockC = idct2(DCT_blockC);
       
       %replace f_blockC with inverse dct of modified block C   
       f(row_pixel : row_pixel + 7,column_pixel + 4: column_pixel + 11) = inv_DCT_blockC(:,:);
       
       end    
   end
end


%---------------------------------------------------------- 
%PHASE 2: iterating through image using Vertically Adjacent Blocks 
%---------------------------------------------------------- 

for column_pixel2 = 1:8:(img_size(2) - 16)
    
     for row_pixel2 = 1:8:(img_size(1) - 16)
     
       % Extract 8x8 Blocks A,B,C. Blocks C is an overlap of Block A and B 
       % and contains boundry pixels of both blocks. 
       f_blockA = f(row_pixel2:row_pixel2 + 7,column_pixel2: column_pixel2 + 7); 
       f_blockC = f(row_pixel2 + 4:row_pixel2 + 11,column_pixel2 : column_pixel2 + 7);
       f_blockB = f(row_pixel2 + 8 :row_pixel2 +15,column_pixel2:  column_pixel2 + 7);

       %calculate two-dimensional discrete cosine transform of Blocks A,B,C
       DCT_blockA = dct2(f_blockA);
       DCT_blockB = dct2(f_blockB);
       DCT_blockC = dct2(f_blockC);
       
      %Condition 1: checks if Block A has a similar horizontal frequency property as block B.
      %in the if condition we check if first row of the DCT matrix block A
      %and of block B are close in values or not 
      
      %Condition 2: boundary between block A and block B belongs to a relatively smooth region.
      % we check if block C is of low frequency content. if textures and other strong diagonal edges are present then it
      % would result in relatively high values of DCT co-efficients 
       
     
       diff1 = (DCT_blockA(1,1) - DCT_blockB(1,1));
       diff2 =  (DCT_blockA(2,1) - DCT_blockB(2,1));
       diff3 =  (DCT_blockC(4,4));   
      
      if (diff1 < Threshold_1 && diff2 < Threshold_2 && diff3 < Threshold_3) 
      
                 
      %calculating the modified DCT coefficient of block C.
      %New values for column 0,1,3,5,7 would be calculated using weighted average of blocks A,B,C 
      
      %alpha = 0.6, Beta = 0.2 for case v=0, v=1. 
             
      %case v=0    
        DCT_blockC(1,1) = 0.6 *  DCT_blockC(1,1) + 0.2 * ( DCT_blockA(1,1) +  DCT_blockB(1,1));
        
      %case v=1 
        DCT_blockC(2,1) = 0.6 *  DCT_blockC(2,1) + 0.2 * (DCT_blockA(2,1) +  DCT_blockB(2,1));
        
      %0.5 and 0.25 are the values of alpha and beta are used for columns 3,5,7 
      %case v=3 
        DCT_blockC(4,1) = 0.5 *  DCT_blockC(4,1) + 0.25 * (DCT_blockA(4,1) +  DCT_blockB(4,1));
        
       %case v=5
       DCT_blockC(6,1) = 0.5 *  DCT_blockC(6,1) + 0.25 * (DCT_blockA(6,1) +  DCT_blockB(6,1));
          
        %case v=7 
       DCT_blockC(8,1) = 0.5 *  DCT_blockC(8,1) + 0.25 * (DCT_blockA(8,1) +  DCT_blockB(8,1));         
        
       %calculate inverse dct of modified block C 
       inv_DCT_blockC = idct2(DCT_blockC);
       
       %replace the corresponding original image pixels with inverse dct of modified block C       
        f(row_pixel2 + 4:row_pixel2 + 11,column_pixel2 : column_pixel2 + 7) = inv_DCT_blockC(:,:);
       
       end    
   end
end

%---------------------------------------------------------- 
%Display and Compare input/output images
%---------------------------------------------------------- 

subplot(1,2,1), imshow(input), title('Original image') 
subplot(1,2,2), imshow(uint8(f)), title('Filtered image')
 
%---------------------------------------------------------- 
%Calculate PeakSNR values 
%---------------------------------------------------------- 
[peaksnr, snr] = psnr(uint8(f), ref);
fprintf('\n The Peak-SNR value is %0.4f', peaksnr);
fprintf('\n The SNR value is %0.4f \n', snr);

