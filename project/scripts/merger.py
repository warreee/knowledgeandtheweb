import csv

with open('../data/mergedDBpediaNobel.csv', 'rt') as f:
    reader = csv.reader(f, delimiter=';')
    dbpedia = list(reader)


with open('../data/almaMaterOfPersonDBPedia.csv', 'rt') as f2:
    reader2 = csv.reader(f2, delimiter=';')
    alma = list(reader2)


info = set()
# Extract usable info
def getInfo():
    for lines in dbpedia:
        for unis in alma:
            if lines[0] == unis[0]:
                info.add((lines[0],lines[1],lines[2],lines[4]))

getInfo()

print(len(dbpedia))

def removeOverlaps():
    for unis in info:
        for lines in dbpedia:
            if lines[0] == unis[0]:
                    dbpedia.remove(lines)

removeOverlaps()
print(len(dbpedia))

print(len(info))

merged = list()
def mergeInfo():
    for i in info:
        for uni in alma:
            if i[0] == uni[0]:

                merged.append([i[0], i[1], i[2], uni[1], i[3]])
mergeInfo()



ofile  = open('ttest.csv', "wt")
writer = csv.writer(ofile, delimiter=';')

for i in merged:
    writer.writerow(i)
for j in dbpedia:
    writer.writerow(j)