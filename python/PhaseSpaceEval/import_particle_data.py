"""
Contains Functions to import CST Particle Data for later processing
"""

import io
import pandas as pd


DELIMITER = ";" # Delimiter used in all files (by convention in the CST export script)

def import_particle_constants(filename):
    """
    Imports the time invariant particle properties
    Returns pandas dataframe with columns
    [particleID, mass, macroCharge, sourceID]
    particleID is index_col of dataframe

    Keyword arguments:
    filename -- path of the file to be imported
    """

    # Column Names for the dataframe
    col_names = ["particleID", "mass", "macroCharge", "sourceID"]

    # Import CSV with pandas, assigning new column names, using particleID as index_col, skip last line (EOF marker)
    constants = pd.read_csv(filename, sep=DELIMITER, names=col_names, header=0, index_col=0)
    # Drop Last Row (EOF)
    constants.drop(constants.tail(1).index,inplace=True)
    return constants


def import_particle_trajectories(filename):
    """
    Imports the particle trajectory data
    Returns a dictionary of pandas dataframes where the key is the particleID
    I.e. the dict contains one dataframe per particleID where each frame has the shape below
    [time, x, y, x, px, py, pz]

    Keyword arguments:
    filename -- path of the file to be imported
    """

    def datablock_to_df(datablock):
        """
        Internal function that converts the current block of data to a pandas
        dataframe with the right properties.
        Returns a tuple with the particleID and the dataframe
        (pID (int), df (pandas df))
        """
        # Column Names for the dataframe
        col_names = ["particleID", "time", "x", "y", "z", "px", "py", "pz"]

        # Covert datablock to IO Stream
        datastream = io.StringIO('\n'.join(datablock))

        # Use pandas read csv to read the data stream and prepare a frame
        df = pd.read_csv(datastream, sep=DELIMITER, names=col_names, usecols=col_names[1:],
                         header=None, index_col=None)
        pID = int(datablock[0].split(DELIMITER)[0])
        return (pID,df)


    #Initialise dictionary of dataframes
    frames = dict()
    data = list()
    # Read  trajectory file
    with open(filename) as f:

        # Skip first line
        f.readline()
        # Read second line
        line = f.readline()
        # Save first char (particleID)
        prior_first_block = line.split(DELIMITER)[0]
        # Save second line (i.e. first line of data)
        data.append(line)
        print("Imported particle trajectory:")
        for line in f: # Crawl through rest of the file
            
            # If particleID on current line is same as before
            if line.split(DELIMITER)[0] != prior_first_block or line == "EOF":
                # Convert the current data into a dataframe and update the dictionary
                (pID, df) = datablock_to_df(data)
                frames.update({pID:df})
                # Print status
                print(str(pID),end=", ")
                if pID % 20 == 0:
                    print()
                
                #break if end of file
                if line == "EOF":
                    print()
                    print("Reached EOF")
                    break
            
                # Clear the buffered data
                data = list()

            # Save current line
            data.append(line)
            prior_first_block = line.split(DELIMITER)[0]
    
    return frames


def import_source_names(filename):
    """
    Returns a dictionary with sourceIDs and their corresponding names

    Keyword arguments:
    filename -- path of the file to be imported
    """

    # Read File
    with open(filename, "r") as f:
        data = f.readlines()

    # Delete Header Line
    del data[0]

    # Create dictionary
    names = dict()
    for line in data:
        if line == "EOF":
            break
        temp = line.split(DELIMITER)
        names.update({int(temp[0]):temp[1].strip('\n')})

    return names