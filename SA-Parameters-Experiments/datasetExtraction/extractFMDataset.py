import random
males = {}
females = {}

min_outdeg = 200
min_indeg = 200


def examineDataset(datafile):
    with open(datafile) as inf:
        for line in inf:
            parts = line.split('\t')
            u1 = parts[0]
            u2 = parts[1]
            if u1 in females:
                females[u1] += 1
            else:
                females[u1] = 1
            if u2 in males:
                males[u2] += 1
            else:
                males[u2] = 1


def selectUsers():
    selectedFemales = set([])
    for u in females:
        if females[u] > min_outdeg:
            selectedFemales.add(u)

    selectedMales = set([])
    for u in males:
        if males[u] > min_indeg:
            selectedMales.add(u)

    return selectedFemales, selectedMales


def cmpF(u1, u2):
    if females[u1] < females[u2]:
        return -1
    elif females[u1] == females[u2]:
        return 0
    else:
        return 1


def cmpM(u1, u2):
    if males[u1] < males[u2]:
        return -1
    elif males[u1] == males[u2]:
        return 0
    else:
        return 1


def selectTopUsers(frac):
    topF = females.keys()
    topF.sort(cmp = cmpF, reverse = True)
    topM = males.keys()
    topM.sort(cmp = cmpM, reverse = True)
    return set(topF[:int(frac * len(females))]), set(topM[:int(frac * len(males))])


def extractSubset(infile, outfile, frac):
    if(len(females) == 0):
        examineDataset(infile)
    selF, selM = selectUsers()
    # selF, selM = selectTopUsers(frac)
    k = 0
    females.clear()
    males.clear()
    with open(infile) as inf:
        with open(outfile, 'w+') as outf:
            for line in inf:
                parts = line.split('\t')
                u1 = parts[0]
                u2 = parts[1]
                if(u1 in selF and u2 in selM):
                    outf.write(line)
                    if u1 in females:
                        females[u1] += 1
                    else:
                        females[u1] = 1
                    if u2 in males:
                        males[u2] += 1
                    else:
                        males[u2] = 1
                    k += 1
    return k


def splitDataset(infile, trainfile, valfile, testfile, valfrac, testfrac):
    with open(infile) as f:
        data = f.readlines()
    random.shuffle(data)
    m = len(data)
    valdata = data[:int(valfrac * float(m))]
    testdata = data[int(valfrac * float(m)) + 1: int((valfrac + testfrac) * float(m))]
    traindata = data[int((valfrac + testfrac) * float(m)) + 1:]
    userIds = {}
    with open(trainfile, 'w+') as trainf:
        for line in traindata:
            parts = line.split('\t')
            u1 = parts[0]
            u2 = parts[1]
            a = parts[2]
            if u1 not in userIds:
                userIds[u1] = str(len(userIds) + 1)
            if u2 not in userIds:
                userIds[u2] = str(len(userIds) + 1)

            if a == 'like':
                trainf.write(userIds[u1] + ',' + userIds[u2] + ',1,0,1,' + u1 + ',' + u2 + '\n')
            else:
                trainf.write(userIds[u1] + ',' + userIds[u2] + ',0,0,1,' + u1 + ',' + u2 + '\n')
    with open(valfile, 'w+') as valf:
        for line in valdata:
            parts = line.split('\t')
            u1 = parts[0]
            u2 = parts[1]
            a = parts[2]
            if u1 not in userIds:
                userIds[u1] = str(len(userIds) + 1)
            if u2 not in userIds:
                userIds[u2] = str(len(userIds) + 1)

            if a == 'like':
                valf.write(userIds[u1] + ',' + userIds[u2] + ',1,0,1,' + u1 + ',' + u2 + '\n')
            else:
                valf.write(userIds[u1] + ',' + userIds[u2] + ',0,0,1,' + u1 + ',' + u2 + '\n')
    with open(testfile, 'w+') as testf:
        for line in testdata:
            parts = line.split('\t')
            u1 = parts[0]
            u2 = parts[1]
            a = parts[2]
            if u1 not in userIds:
                userIds[u1] = str(len(userIds) + 1)
            if u2 not in userIds:
                userIds[u2] = str(len(userIds) + 1)

            if a == 'like':
                testf.write(userIds[u1] + ',' + userIds[u2] + ',1,0,1,' + u1 + ',' + u2 + '\n')
            else:
                testf.write(userIds[u1] + ',' + userIds[u2] + ',0,0,1,' + u1 + ',' + u2 + '\n')