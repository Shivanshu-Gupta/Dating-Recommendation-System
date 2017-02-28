import numpy as np
from random import *
from pprint import PrettyPrinter

pp = PrettyPrinter()
pi = np.array([
    [0.025243733, 0.045782111, 0.063459570, 0.096678369, 0.193405846],
    [0.018001565, 0.035001175, 0.056133056, 0.081325301, 0.162897146],
    [0.004072135, 0.027573529, 0.040943789, 0.061082955, 0.154015133],
    [0.002338270, 0.022201228, 0.041695147, 0.068577277, 0.139406028],
    [0.000000000, 0.023220974, 0.044173328, 0.067079463, 0.122183171]])
# log_like = np.log(pi)
# log_hide = np.log(1 - pi)

pi_overall = np.array([0.07309065, 0.06941332, 0.06988857, 0.07249424, 0.07534926])

n_male = 5
n_female = 5

num_trials = 1000
policy_file_name = 'policy/model6.policy'
result_file_name = 'simulation/pomdp-model6.csv'
sim_file_name = 'simulation/pomdp-model6.sim'


class Plane:

    def __init__(self, action, alpha):
        self.action = action
        self.alpha = alpha

    def isApplicable(self, belief):
        for i in range(len(belief)):
            if belief[i] != 0 and self.alpha[i] == 0:
                return False
        return True

    def __str__(self):
        return '(' + str(self.action) + ',' + str(self.alpha) + ')'

    def __repr__(self):
        return '(' + repr(self.action) + ',' + repr(self.alpha) + ')'


def read_policy(policy_file_name):
    with open(policy_file_name) as policy_file:
        line = policy_file.readline().strip()
        # print(line)
        while not line.startswith('numPlanes'):
            line = policy_file.readline().strip()
            # print(line)
        numPlanes = int(line.split('=>')[1].replace(',', ''))
        planes = []
        line = policy_file.readline().strip()
        # print(line)
        for i in range(numPlanes):
            while not line.startswith('action'):
                line = policy_file.readline().strip()
                # print(line)
            # print(line)
            action = int(line.split('=>')[1].replace(',', ''))
            # pp.pprint(plane.action)

            line = policy_file.readline().strip()
            numEntries = int(line.split('=>')[1].replace(',', ''))
            policy_file.readline().strip()
            alpha = np.zeros(n_female + 1)
            for j in range(numEntries):
                entry = policy_file.readline().strip().split(',')
                s = int(entry[0])
                v = float(entry[1])
                alpha[s] = v
            plane = Plane(action, alpha)

            planes.append(plane)
    return planes


def getBestAction(planes, belief):
    a = 0
    lbValue = float('-Inf')
    for plane in planes:
        if plane.isApplicable(belief):
            value = plane.alpha.dot(belief)
            # print(value)
            if(value > lbValue):
                lbValue = value
                a = plane.action
    return a


def getObs(prob):
    x = random()
    if(x > prob):
        return 'Hide'
    else:
        return 'Like'


def output(out_file, op):
    print(op)
    out_file.write(op + '\n')


def runSimulation(planes, sim_out_file, result_out_file):
    true_m = randint(0, 4)
    result_out_file.write(repr(true_m + 1) + ', ')
    output(sim_out_file, 'TRUE MALE BUCKET: M' + repr(true_m + 1))
    belief = np.array([0.2, 0.2, 0.2, 0.2, 0.2, 0.0])
    output(sim_out_file, 'INITIAL BELIEF: ' + repr(belief))
    submitted = False
    for i in range(50):
        if not submitted:
            output(sim_out_file, '')
            action = getBestAction(planes, belief)
            if action < n_female:
                f = action
                output(sim_out_file, 'ACTION: F' + repr(f + 1))

                if getObs(pi[f][true_m]) == 'Like':
                    output(sim_out_file, 'OBSERVATION: LIKE')
                    # like probability vector
                    lpv = np.append(pi[f], 0.5)
                    belief = lpv * belief / lpv.dot(belief)
                else:
                    output(sim_out_file, 'OBSERVATION: HIDE')
                    # hide probability vector
                    hpv = np.append(1 - pi[f], 0.5)
                    belief = hpv * belief / hpv.dot(belief)
                output(sim_out_file, 'NEW BELIEF: ' + repr(belief))

                pred_m = np.argmax(belief)
                output(sim_out_file, 'CURRENT PRED: M' + repr(pred_m + 1))

                if pred_m == true_m:
                    result_out_file.write('1, ')
                else:
                    result_out_file.write('0, ')
            else:
                sub_m = action - 5
                output(sim_out_file, 'ACTION: Submit M' + repr(sub_m + 1))
                submitted = True

        if submitted:
            if sub_m == true_m:
                result_out_file.write('1, ')
            else:
                result_out_file.write('0, ')

            # break

    result_out_file.write('\n')
    output(sim_out_file, '*********************** END OF SIMULATION ***********************')


if __name__ == '__main__':
    planes = read_policy(policy_file_name)
    with open(sim_file_name, 'w+') as sim_file:
        with open(result_file_name, 'w+') as result_file:
            for i in range(num_trials):
                runSimulation(planes, sim_file, result_file)
