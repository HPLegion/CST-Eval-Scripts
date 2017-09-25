import argparse

def split_cst_pic_style_output(targetfile, idfile):
    print targetfile
    print idfile


if __name__ == '__main__':
    #CommandLine Argument Parsing
    parser = argparse.ArgumentParser(description='Split a PIC-style Trajectory Output from CST into several files for each source.')
    parser.add_argument('targetfile', metavar='targetfile', help='The file to be split.')
    parser.add_argument('idfile', metavar = 'idfile', nargs='?', default='' , help='The file containing IDs and names of the sources.')

    args = parser.parse_args()

    split_cst_pic_style_output(args.targetfile, args.idfile)
    #split_cst_pic_style_output("args.targetfile", "args.idfile")


