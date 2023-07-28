# CarMaker file reader and plotting scripts

Python scripts that read CM ERG files and plot graphs of selected data. Work in conjunction with time-distance data that are displayed in the session log.

**How to get necessary data**

- In CarMaker, in go to *File -> Output Quantities -> select the desired data*. Remember to change the folder path in top right (I recommend using /%D/%T, this way it will create a folder for the day and time tested) and then rename them after the file is created. Change buffer size and file size limit to max.
- Once the car is run, open the session log *Simulation -Session Log* or *Ctrl+i* and copy the data from the run. The data should contain times and distances and they are critical for the script to work.
- Create a text file (preferably in the same folder as the ERG files) and **name it the same as a corresponding ERG run file**. The script may work without it, but it is very much recommended to do so.
- If the session log is glitched (f.e. laps are 0.001s long, etc), check the *laptime text file reader* analyse_data function and add 
