import argparse
import os
#import num as np
import pandas as pd
import time

def cst_split_output_by_source(targetfile, idfile='', reduce_particle_id=True):
    print('targetfile = ' + targetfile)
    print('idfile = ' + idfile)

    targetpath = os.path.dirname(targetfile)
    targetname = os.path.basename(targetfile)
    

    #Read in PIC file using pandas library
    colnames = ['posX', 'posY', 'posZ', 'momX', 'momY', 'momZ', 'mass',
                'charge', 'macro-charge', 'time', 'particleID', 'sourceID']
    colwidths = [20, 18, 18, 18, 18, 18, 18, 18, 18, 18, 13, 13]
    print('Reading Data')
    data = pd.read_fwf(targetfile, header=7, widths=colwidths, names=colnames)
    print('Finished Reading')
    
    #Find all existing sources in file
    sourceIDs = list(data['sourceID'].unique())

    # Load Dictionary with source names
    sourceDict = create_source_name_dictionary(idfile,sourceIDs)
    # print('Dictionary entries')
    # print(sourceDict)

    #create folder
    destination = targetpath + ("/split_" + targetname + time.strftime("%Y-%m-%d-%H-%M-%S") + "/")
    os.makedirs(destination)
    print('Split files will be located in ' + destination)

    for sourceID in sourceIDs:
        temp = data[data["sourceID"]==sourceID].copy() #Copy content not reference
        pidoffset = temp['particleID'].min()
        if reduce_particle_id:
            temp.loc[:,'particleID'] = temp['particleID'] - pidoffset
        if sourceDict[sourceID] == "unknown":
            fname = str(sourceID) + ".txt"
        else:
            fname = sourceDict[sourceID] + ".txt"
        destfile = destination + fname
        headerline = '% sourceID = ' + str(sourceID) + ' | sourceName = ' + sourceDict[sourceID] + ' | original ID of first particle = ' + str(pidoffset) +'\n'

        f = open(destfile, 'a')
        f.write(headerline)
        temp.to_csv(f, sep='\t', index=False)
        f.close()
        print('saved ' + os.path.basename(destfile))

def create_source_name_dictionary(idfile, sourceIDs): #optimise to allow for missing sources and still write all known entries
    sourceDict = dict()
    #If available read in Source name file
    if idfile is not '':
        iddata = pd.read_csv(idfile, sep='\t')
        iddata = iddata.set_index('sourceID')
    else:
        iddata = None

    for sourceID in sourceIDs:
        if (iddata is not None):
            if(sourceID in iddata.index): #read known sources from file info
                sourceDict[sourceID] = iddata.loc[sourceID, 'sourceName']
            else:
                 sourceDict[sourceID] = "unknown"
        else:#or generate unknown
            sourceDict[sourceID] = "unknown"

    return sourceDict


if __name__ == '__main__':
    #CommandLine Argument Parsing
    parser = argparse.ArgumentParser(description='''Split a PIC-style Trajectory Output from CST into several files for each source.''')
    parser.add_argument('targetfile', metavar='targetfile', help='The file to be split.')
    parser.add_argument('idfile', metavar='idfile', nargs='?', default='', help='The file containing IDs and names of the sources.')
    parser.add_argument('--no-index-reduction','-n', action='store_false', default=True, dest='redind', help='If set particles will keep their original IDs.')

    args = parser.parse_args()

    cst_split_output_by_source(args.targetfile, args.idfile, args.redind)
    #split_cst_pic_style_output("args.targetfile", "args.idfile")


