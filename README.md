# UGR-VD-code
For UGRacing Vehicle Dyncamics data processing

Welcome to VD data processing!

To get the data ready, go to MoTeC and do the following:

-select the data you need (depends on the file you run)
-right click on the data -> export -> change output file format to MATLAB
-change output sample rate to custom -> 1000Hz
-save the file to the folder you want

CRITICAL: CHANGE THE FILE NAME SO IT HAS NO DASHES - I recommend using a SURNAME_STINT_NO_L/R

in case of tyres etc. try to use L/R depending on the tyre side

Once you get the data (make sure they are in the same folder as the matlab file and get the path to the folder. 
You can do that by going to that folder in the Windows file explorer -> right click the folder address (bar above the the files)
and copy it as a text. Paste that into the MATLAB script.

All should be ready to get some graphs :)
