# CarMaker file reader and plotting scripts

Python scripts that read CM ERG files and plot graphs of selected data. Work in conjunction with time-distance data that are displayed in the session log.

**How to get necessary data**
- Install Pandas, NumPy and CMERG python packages
- In CarMaker, in go to *File -> Output Quantities -> select the desired data*. Remember to change the folder path in top right (I recommend using /%D/%T, this way it will create a folder for the day and time tested) and then rename them after the file is created. Change buffer size and file size limit to max. **Make sure the ERG and ERG.info files have the same name!**
- Once the car is run, open the session log *Simulation -> Session Log* or *Ctrl+i* and copy the data from the run. The data should contain times and distances and they are critical for the script to work.
- Create a text file (preferably in the same folder as the ERG files) and **name it the same as a corresponding ERG run file**. The script may work without them being the same name, but it is very much recommended to do so.
- If the session log is glitched (f.e. laps are 0.001s long, etc), or there is a need to combine laps, check the **_laptime text file reader_** analyse_data function and add a line that groups the data from the dataframe (just use the group_data function).
- The **_CarMaker ERG file reader_** is the master script, but it imports function from the **_laptime text file reader_**. Make sure it is in the same directory or the text file reader is imported correctly.  In the master file, it is named as **_script.text_** so change it or be aware of that!
- To access the quantity needed, the following structure must be used:
- get_dataframe(link to ERG file, quantity desired, link to time-dist text file)['Mean'] (It's recommended to use ['Mean']) or ['Time'] -> this refers to the time-distance text file reader, use this for mainly laptime boxplots

The ERG file reader *get_dataframe* rounds down the logged sample's distance to the nearest metre and then averages values in this distance window. The dataframe created has an index of a lap distance and columns (series) of data from all laps, named with the lap number. Data in columns are normalised to the start of the lap.
The dataframe also has statistics series, such as Mean, Median, Standard Deviation and Standard Error. These values are calculated from the last 5 laps by default and can be changed in the get_dataframe function.

Data I used for the research are available on Teams and the link is provided in the _Data used for research_ file.
