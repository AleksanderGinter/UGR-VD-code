# UGRacing Asseto Corsa MoTeC -> MATLAB graphs code

This folder contains MATLAB scripts that allow to plot graphs based on ACTI collected data from Asseto Corsa, and compare ingame car setups.

To get the data ready, go to MoTeC and do the following:

-Create a new workbook (right click on the driver tab and select *Create new workbook* <br>
-Right click on the background -> properties -> Add channel -> Add **Corr distance**, **Ground speed**, all **Tire slip angles**, all **Tire Load**, all **Tire pressure**, **Throttle** and **Brake** positions <br>
-Once the investigated lap data file is loaded, right click on the background again, select *Export data* <br>
-Change *Output File Format* to MATLAB <br>
-Change output sample rate to custom -> 1000Hz <br>
-Save the file to the folder you want - I suggest creating folder just for the data<br>

**CRITICAL: CHANGE THE FILE NAME SO IT HAS NO DASHES - I recommend using a SURNAME_STINT_NO**

Once you get the data, specify the path to to the folder with data in matlab script. You can do that by going to that folder in the Windows file explorer -> right click the folder address (bar above the the files) and copy it as a text. Paste that into the MATLAB script.

Adjustments in the scripts that will affect the graph plot.
- Legend captions can be done manually of automatically (defaults to the run name). The legend handle in the last part of the script needs to be changed from strings(manual_legens) to string(runs) or vice versa.
Remember to change axes range (around) on line 97, otherwise the graph may be clipped.


All should be ready to get some graphs :)
