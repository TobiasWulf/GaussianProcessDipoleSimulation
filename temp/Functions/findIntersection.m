%===============================================================================
% [intersectionOut,intersectionTemp,tol] = findIntersection(f,g,tol,tolIter)
% Description:  Calculate the intersection between two functions
%             
% Input:    
%           f       : Coordinates of the first null-function
%           g       : Coordinates of the second null-function
%           tol     : Tolerance if the funcntion intersect
%           tolIter : About this value the tolerance will be reduced with
%                      each loop
% Output:
%           intersectionOut     : Coordinates of the intersection
%           intersectionTemp    : Coordinates of the precalculated
%                                   intersection
% author  : Hauke J. Pape
% email   : hauke.pape@haw-hamburg.de
% date    : 17.03.2017
%===============================================================================
function [intersectionOut,intersectionTemp] = findIntersection(f,g,tol,tolIter)
    cancleValue = 100;       % maximum iterations to find intersections
    stopValue = 8;          % defines how many 
    % precalculation for the intersection
    
    % Determine the length of the array
    if length(f(:,1))>=length(g(:,1))
        intersection    = zeros(length(f(:,1)),2);
    elseif length(g(:,1))>length(f(:,1))
        intersection    = zeros(length(g(:,1)),2);
    end
    
    while(length(intersection(:,1))>stopValue && cancleValue>0)
        a = 1; % count value
        % Determine the length of the array, this has to be done at every loop
        if length(f(:,1))>length(g(:,1)) 
            intersection    = zeros(length(f(:,1)),2);
        elseif length(g(:,1))>length(f(:,1))
            intersection    = zeros(length(g(:,1)),2);
        end
        % the idea to calculate the intersection of the null curves is, to find the
        % point where the difference between coordinates of the curves are in a
        % tolerance ribbon to zero
        for ii = 1:length(f(:,1))
           for kk = 1:length(g(:,1))
                     if (abs(f(ii,1)-g(kk,1)) + abs(f(ii,2)-g(kk,2)))<tol
                        meanX   = (f(ii,1) + g(kk,1))/2;
                        meanY   = (f(ii,2) + g(kk,2))/2;
                        intersection(a,:)  = [meanX meanY];
                        a = a + 1;
                     end
           end
        end
        
        intersection(intersection(:,1)==0,:)  = []; % there are many rows whith zeros, so they can be deleted

        cancleValue     = cancleValue-1;
        tol = tol-tolIter;
        if cancleValue == 0;
            warning('');
            break
        end
        % 
        if length(intersection(:,1))<stopValue
            break;
        end
        intersectionTemp = 0;
        intersectionTemp = intersection;
    end
    
    % calc the mean of the intersection points, so there is only one x- and
    % y-coordinate
    intersectionTemp = [sum(intersectionTemp(:,1))/length(intersectionTemp(:,1)) sum(intersectionTemp(:,2))/length(intersectionTemp(:,2))];
    
    % main calculation
    % find the nearest two values around the precalculted intersection of
    % each condition. And then interpolate between this values to find the
    % intersection 
    % calculate the difference 
    nullDiffInter1 = (f-intersectionTemp(1,:));
    nullDiffInter2 = (g-intersectionTemp(1,:));
    % search the minimum of the difference to find the nearest values to
    % the precalculated intersection
    [min1, row1] = min(abs(nullDiffInter1(:,1)) + abs(nullDiffInter1(:,2)));
    [min2, row2] = min(abs(nullDiffInter2(:,1)) + abs(nullDiffInter2(:,2)));
    if row1==length(nullDiffInter1(:,1))
        row1B = row1 - 1;
    else
        row1B = row1 + 1;
    end
    if row2==length(nullDiffInter2(:,1))
        row2B = row2 - 1;
    else
        row2B = row2 + 1;
    end
    % searching a signchange so the precalculated intersection is between
    % two values
    if row1 <= 3
        n = row1-1;
    else
        n = 3;
    end
        for jj=1:n
            if (sign(nullDiffInter1(row1,1)) + sign(nullDiffInter1(row1-jj,1))) == 0 ||...
               (sign(nullDiffInter1(row1,2)) + sign(nullDiffInter1(row1-jj,2))) == 0
                row1B = row1-jj;
                break;
            end
        end
        
    if row1 >= length(nullDiffInter1(:,1))-3
        n = length(nullDiffInter1(:,1)) - row1;
    else
        n = 3;
    end
    
    for jj=1:n
                if  (sign(nullDiffInter1(row1,1)) + sign(nullDiffInter1(row1+jj,1))) == 0 ||...
                        (sign(nullDiffInter1(row1,2)) + sign(nullDiffInter1(row1+jj,2))) == 0
                    row1B = row1+jj;
                    break;
                end
    end
    if row2 <= 3
        n = row2-1;
    else
        n = 3;
    end        

        for jj=1:n
            if ((sign(nullDiffInter2(row2,1)) + sign(nullDiffInter2(row2-jj,1))) == 0 ||...
               (sign(nullDiffInter2(row2,2)) + sign(nullDiffInter2(row2-jj,2))) == 0) 
                row2B = row2-jj;
                break;
            end
        end
    if row2 >= (length(nullDiffInter2(:,1))-3)
        n = length(nullDiffInter2(:,1)) - row2; 
    else
        n= 3;
    end
        for jj=1:n
            if  ((sign(nullDiffInter2(row2,1)) + sign(nullDiffInter2(row2+jj,1))) == 0 ||...
                    (sign(nullDiffInter2(row2,2)) + sign(nullDiffInter2(row2+jj,2))) == 0) 
                row2B = row2+jj;
                break;
            end
        end
    
    % linear interpolation
    % m = (y1-y2)/(x1-x2)
    m1 = (f(row1,2)-f(row1B,2))/(f(row1,1)-f(row1B,1)+1e-10);
    % b = y1 - m1 * x1
    b1 = f(row1,2)-m1 * f(row1,1);

    m2 = (g(row2,2)-g(row2B,2))/(g(row2,1)-g(row2B,1)+1e-10);
    b2 = g(row2,2)-m2 * g(row2,1);
    
    intersectionX = (b1-b2)/(m2-m1);
    intersectionY = m1 * intersectionX + b1;
    
    intersectionOut = [intersectionX intersectionY m1 m2];
end





