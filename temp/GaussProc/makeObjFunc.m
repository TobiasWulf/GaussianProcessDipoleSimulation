function objFunc = makeObjFunc(Dref, Dpred, alphaPredTrue, Nbit, s2n)
   %MAKEOBJFUNC Make obj. Func. for Bayes Opt.
   
   objFunc = @gpreg;
   function ret = gpreg(optimVars) 
      optimVars.Nbit = Nbit;
      optimVars.s2n = s2n;
     
      if Nbit < 0
         optimVars.castFunc = @single; 
      else
         optimVars.castFunc = @(x) fi(x,1, optimVars.Nbit, optimVars.frac);
      end
      
            
      [cosPred, sinPred] = doGPReg(Dref, Dpred, optimVars);
      [~, alphaDiff] = cossin2Alpha(single(cosPred), single(sinPred), alphaPredTrue);
      ret = max(abs(alphaDiff)); 

   end
   
end

