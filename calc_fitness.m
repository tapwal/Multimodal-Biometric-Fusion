function fitness = calc_fitness(mass)
    for i=1:size(mass,1) 
        [far,frr] = calc_ROC(mass,i,size(mass,1));
        fitness(i,1)= 0.5*far+0.5*frr;
    end
    fitness = mean(fitness);
end
