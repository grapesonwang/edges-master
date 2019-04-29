function BW = funcMask(Img, Col, Row)
    mask = Img(:, :, 1);
%     Col = [393,  551, 725, 125]; 
%     Row = [69,  69, 761, 761];

    BW = roipoly(mask, Col, Row);
%     figure, imshow(BW);
end