Code used to temporally downscale daily climate projections and convert to VRE generations (corresponding to a manuscript submitted to Scientific Data).

read_WFDE5_data.m and read_WFDE5_data_adding_pressure.m are used to read 5 meteorological variables from WFDE5 dataset.

downscale.m is used to read ISIMIP projections temporally downscale daily meteorological variables.

analog_extend.m and find_similar_multi_MV3_lag_ahead.m are downscaling function.

convert_to_VRE.m is used to convert meteorological variables to VRE generation.

get_W_consider_Pr.m and get_PV_dc2ac.m are used to convert meteorological variables to wind power / PV generation, respectively. 

getWoutputV3.m and f_convert_to_W_allgrid_another_method.m are functions in get_W_consider_Pr.m.

convert_to_nc_format.m is used to convert .mat to .nc.




