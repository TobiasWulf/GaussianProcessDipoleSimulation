function [alphaVec, alphaDiff] = cossin2Alpha(cosVec, sinVec, alphaOrig)
   % apply atan2
   alphaVec = atan2(sinVec, cosVec);
   m = alphaVec < 0;
   alphaVec(m) = alphaVec(m) + 2*pi;
   alphaDiff = alphaOrig - alphaVec;
   m = alphaDiff > pi;
   alphaDiff(m) = alphaDiff(m) - 2*pi;
   m = alphaDiff < -pi;
   alphaDiff(m) = alphaDiff(m) + 2*pi;

end

