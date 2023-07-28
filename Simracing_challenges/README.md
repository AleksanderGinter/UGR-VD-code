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

**Adjustments in the scripts that will affect the graph plot.**
- *Graphs include averaging* - the value is an average of values from a number of samples. For 1000Hz sampling rate, it is equivalent to ms passed. I recommend keeping it between 200 and 500 for most applications.
- Legend captions can be done manually or automatically (defaults to the run name). The legend handle in the last part of the script needs to be changed from strings(manual_legens) to string(runs) or vice versa.
- The patch object is a 3D object that is used to graph data onto a 2D (x-y) plane. This allows for it to have a colorline, based on an external value (such as speed or throttle/brake).
  Unfortunately, it will create a line connecting the 1st and the last data point. I haven't found solution to that, so it just comes with it.
- Sometimes it is more useful to have a regular 2D plot graph, so in some cases the command is there in the script - just uncomment it.
- Remember to change axes range around line 100, otherwise the graph may be clipped.
- Data series is clipped at the end to match the array sizes (and be possible to graph) so don't be surprised if the laps are slightly shorter.

- GG plots and acceleration-speed plots are based on convex hull shapes. The latter also have the option to clip graphing values below a certain threshold of speed and acceleration to filter sub tyre grip limit data.
