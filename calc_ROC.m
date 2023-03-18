function [far,frr] = calc_ROC(mass,n,num)
    threshold = 0.5;
    far = 0;
    frr = 0;
    for i=1:num
        if i==n && mass(i)<threshold
        frr = frr+1;
        end
        if i~=n && mass(i)>=threshold
        far = far+1;
        end
    end
    far=far/num;
    frr=frr/num;
end
