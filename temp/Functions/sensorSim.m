%===============================================================================
% [BxOut, ByOut] = sensorSim(Bx,By)
%             
% Input:
% Output:
% author  : Hauke J. Pape
% email   : hauke.pape@haw-hamburg.de
% date    : 30.03.2017
%===============================================================================
function [BxOut, ByOut] = sensorSim(Bx,By,resolution)
    if max(max(abs(Bx))) > max(max(abs(By)))
        maxValue = max(max(abs(Bx)));
    else
        maxValue = max(max(abs(By)));
    end
    dataReso = 2 * maxValue / 2^resolution;
    BxOut  = round(Bx/dataReso) * dataReso;
    ByOut  = round(By/dataReso) * dataReso;
end