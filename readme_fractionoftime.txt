This procedure is used to analyze the flip rate at different neighbor environment:
1. PEEMXMCD_multi(thresholddiff,thresholdsame,folder,geometry,spacing,lowtemperature,hightemperature,temperaturepoints)
   e.g. PEEMXMCD_multi(6,13,'shakti600','shakti',600,180,220,21)
2. fraction_config_multi(nnp,nnn,nnnp,nnnn,thresholddiff,thresholdsame,folder,geometry,spacing,lowT,highT,points)
   e.g. fraction_config_multi(2,2,0,0,6,13,'tetris600','tetris',600,180,220,21)
3. fraction_average( filename)
   e.g. fraction_average('fraction_tetris600_NN2_2NNN0_0_threshold6_13')