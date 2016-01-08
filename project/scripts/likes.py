#!/usr/bin/python

import sys
import subprocess
import csv as CSV
from tqdm import tqdm

def main(argv):

    print(argv)
    printCSV(getLikes(getNames(readCSV(argv[0]))))


# Get the likes for one person
def getLikes(persons):
    likes = list()
    n = 0
    for person in tqdm(persons):
        n += 1
        try:
            nbLikes = subprocess.Popen("perl getLikes.pl '{}'".format(person.replace("'","")), shell=True, stdout=subprocess.PIPE).stdout.read()
            nb = nbLikes.decode(encoding="utf-8")
            if nb == 'Invalid access token.\n':
                break #usekey probably expired
            if nb == '':
                nb = '0'
            print([person, nb])
            likes.append([person, nb])
        except Exception as e:
            print("The following error occurred:")
            print(e)
            print("Unable to find {}".format(person))
            likes.append([person, '$$$'])

    return likes


# Read the csv file from path
def readCSV(path):
    with open(path, 'rt') as file:
        reader = CSV.reader(file, delimiter=';')
        return list(reader)


names = list()


def getNames(csv):
    for name in csv:
        names.append(name[0])
    return names


def printCSV(list):
    ofile = open('likes.csv', "at")
    writer = CSV.writer(ofile, delimiter=';')
    for i in list:
        writer.writerow(i)


if __name__ == "__main__":
    main(sys.argv[1:])
