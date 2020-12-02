clear c s sn mn
for i=1:16
c=ds.Data.Vcos(:,:,i);
s = ds.Data.Vsin(:,:,i);
sn(i,:)=sqrt(c(:).^2+s(:).^2);
mn(i)=max(sqrt(c(:).^2+s(:).^2));
end

sn2=max(sn)'*2;
mn2=max(mn)*2;