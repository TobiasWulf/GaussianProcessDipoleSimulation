%===============================================================================
% [nullPositions, Nulls] = getZero2(f,x)
% Description: Calculate the zeros of a 2D-function. 
%             
% Input:    
%           f   : 2D-function
%           x   : grid
% Output:
%           Zeros   : Array [nx6] 
%                       [xPosMainPixel yPosMainPixel xPosNeighbourPixel yPosNeighbourPixel ... zero
%                       ...             ...         ...                 ...                 ... ...]
% author  : Hauke J. Pape
% email   : hauke.pape@haw-hamburg.de
% date    : 01.03.2017
%===============================================================================
function [nullPositions, Nulls] = getZero2(f,x)
    unit = abs(x(1,1)-x(1,2));
    pixelX = 1;
    pixelY = 1;
    right           = 1;                    % case: null between the main pixel and the pixel right to the main pixel
    upper           = 2;                    % case: null between the main pixel and the pixel upper to the main pixel
    diagonalRight   = 3;                    % case: null between the main pixel and the pixel diagonal right to the main pixel
    diagonalLeft    = 4;                    % case: null between the main pixel and the pixel diangonal left to the main pixel
    onPoint         = 0;                    % case: null on the main pixel
    nullCase        = 5;                    % array postion
    maxNumNulls     = length(f(:))*4;       % max numbers of nulls, cause every pixel can have 4 nulls 
    nullPositions = zeros(maxNumNulls,6);   % array with the positions of the nulls and wich case of null. first two columns are the pixel coordinates (x,y) of the first pixel, second two columns are the coordinates 
    
    %loop to determine between which pixels are a null
    for ii=1:4:((length(f(:))-length(f(:,1)))*4)
        if f(pixelY,pixelX) == 0
                 nullPositions(ii,1:4) = [pixelX pixelY pixelX pixelY];
                 nullPositions(ii,nullCase) = onPoint;
        end
        % right
        if pixelX < length(f(1,:))
            if f(pixelY,pixelX) > 0 && f(pixelY,pixelX+1) < 0 || f(pixelY,pixelX) < 0 && f(pixelY,pixelX+1) > 0
                nullPositions(ii,1:4) = [pixelX pixelY pixelX+1 pixelY]; 
                nullPositions(ii,nullCase) = right;
            end
        end
        % upper
        if pixelY < length(f(:,1))
            if f(pixelY,pixelX) > 0 && f(pixelY+1,pixelX) < 0 || f(pixelY,pixelX) < 0 && f(pixelY+1,pixelX) > 0
                nullPositions(ii+1,1:4) = [pixelX pixelY pixelX pixelY+1]; 
                nullPositions(ii+1,nullCase) = upper;
            end
        end
        % diagonalRight
        if pixelX < length(f(1,:)) && pixelY < length(f(:,1)) 
            if f(pixelY,pixelX) > 0 && f(pixelY+1,pixelX+1) < 0 || f(pixelY,pixelX) < 0 && f(pixelY+1,pixelX+1) > 0
                nullPositions(ii+2,1:4) = [pixelX pixelY pixelX+1 pixelY+1];
                nullPositions(ii+2,nullCase) = diagonalRight;
            end
        end
        % diagonal left
        if pixelX > 1 && pixelY < length(f(:,1)) 
            if f(pixelY,pixelX) > 0 && f(pixelY+1,pixelX-1) < 0 || f(pixelY,pixelX) < 0 && f(pixelY+1,pixelX-1) > 0
                nullPositions(ii+3,1:4) = [pixelX pixelY pixelX-1 pixelY+1];
                nullPositions(ii+3,nullCase) = diagonalLeft;
            end
        end
        pixelX = pixelX + 1;
        if pixelX >=length(f(1,:))
            pixelX = 1;
            pixelY = pixelY +1;
        end
    end
    
    nullPositions(nullPositions(:,1)==0,:)=[];
    % linear regression
    for ii = 1 : length(nullPositions(:,1))
        % Fallunterscheidung zwischen: Nullstelle liegt zwischen zwei pixeln(horizontal/vertikal oder diagonal
        % zwischen zwei pixeln oder die Nullstelle liegt genau auf einem
        % Pixel
        % Berechnung von m = y1-y2/(x1-x2)  Fall 1: x1-x2 = Abstand zwischen
        %                                   zwei Pixeln
        %                                   Fall 2: x1-x2 = Diagonal Abstand
        %                                   zwischen zwei Pixeln
        if nullPositions(ii,nullCase) == right || nullPositions(ii,nullCase) == upper 
            m = (f(nullPositions(ii,2),nullPositions(ii,1)) - f(nullPositions(ii,4),nullPositions(ii,3))) / (-unit);
        elseif nullPositions(ii,nullCase) == diagonalRight || nullPositions(ii,nullCase) == diagonalLeft
            m = (f(nullPositions(ii,2),nullPositions(ii,1)) - f(nullPositions(ii,4),nullPositions(ii,3))) / -sqrt(unit^2+unit^2);
        elseif nullPositions(ii,5) == onPoint
            m = 0;
        end
        % b = y1
        b = f(nullPositions(ii,2),nullPositions(ii,1)); 
        % Bestimmung der Nullstelle der Geraden
        nullPositions(ii,6) = -b/m;
    end
    % Berechnung der genauen Position der Nullstellen
    Nulls = zeros(length(nullPositions(:,1)),2);
    for ii = 1 : length(nullPositions(:,1))
        % right
        if nullPositions(ii,nullCase) == right 
            Nulls(ii,:) = [nullPositions(ii,1)*unit+nullPositions(ii,6) nullPositions(ii,2)*unit];
        % upper
        elseif nullPositions(ii,nullCase) == upper 
            Nulls(ii,:) = [nullPositions(ii,1)*unit nullPositions(ii,2)*unit+nullPositions(ii,6)];
        % diagonal right
        elseif nullPositions(ii,nullCase) == diagonalRight 
            Nulls(ii,:) = [nullPositions(ii,1)*unit+nullPositions(ii,6)*sin(pi/4) nullPositions(ii,2)*unit+nullPositions(ii,6)*sin(pi/4)];
        % diagonal left
        elseif nullPositions(ii,nullCase) == diagonalLeft 
            Nulls(ii,:) = [nullPositions(ii,1)*unit-nullPositions(ii,6)*sin(pi/4) nullPositions(ii,2)*unit+nullPositions(ii,6)*sin(pi/4)];
        elseif nullPositions(ii,nullCase) == onPoint 
            Nulls(ii,:) = [nullPositions(ii,1)*unit nullPositions(ii,2)*unit];
        end   
    end
    Nulls   = sortrows(Nulls);
    if isempty(Nulls) == 1
       Nulls = NaN;
       warning('keine Nullstellen gefunden!');
    end
end