# UGR-VD-code

Welcome to VD data processing!

How to get Tire Slip Angles graph:

To get the data ready, go to MoTeC and do the following:

-Create a new workbook (right click on the driver tab and select *Create new workbook* <br>
-right click on the background -> properties -> Add channel -> Add **Corr distance**, **Ground speed** and all **Tire slip angles** <br>
(For *TSA_Throttle_Brake*, repeat the steps, but instead of adding **ground speed** add **Throttle Pos** and **Brake Pos** in MoTeC) <br>
-right click on the background again, select *Export data* <br>
-change *Output File Format* to MATLAB <br>
-change output sample rate to custom -> 1000Hz <br>
-save the file to the folder you want - I suggest creating folder just for the data<br>

**CRITICAL: CHANGE THE FILE NAME SO IT HAS NO DASHES - I recommend using a SURNAME_STINT_NO**


Once you get the data, specify the path to to the folder in matlab script. You can do that by going to that folder in the Windows file explorer -> right click the folder address (bar above the the files) and copy it as a text. Paste that into the MATLAB script.

Remember to change axes range (around) on line 97, otherwise the graph may be clipped.


All should be ready to get some graphs :)
