This procedure is used to analyze the flip rate at different neighbor environment:
1. PEEMXMCD_multi(thresholddiff,thresholdsame,folder,geometry,spacing,lowtemperature,hightemperature,temperaturepoints)
   e.g. PEEMXMCD_multi(6,13,'shakti600','shakti',600,180,220,21)
2. detect_changed_multi(nnp,nnn,nnnp,nnnn,thresholddiff,thresholdsame,folder,geometry,spacing,lowT,highT,points)
   e.g. detect_changed_multi(1,1,1,0,6,13,'shakti600','shakti',600,180,220,21)
3.  movingaveragebytemperature(filename,spacing)
   e.g. movingaveragebytemperature('shakti600_NN1_1NNN1_0_threshold6_13',2)
4. fliprate_multi(filen1,filen2,fractionfile)
   e.g. fliprate_multi('2fliprate_result_1s.csv','2fliprate_result_6s.csv','shakti600_NN1_1NNN1_0_threshold6_13_movingaverage.csv')