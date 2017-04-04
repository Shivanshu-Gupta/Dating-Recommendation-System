from random import *
import numpy as np
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

# pi_overall = np.array([0.07309065, 0.06941332, 0.06988857, 0.07249424, 0.07534926])

n_male = 5
n_female = 5

a = 0
s = 0.01
m = -1
a_b = 0.1
e = np.array([
    [0, 0, 0, 0, 0],
    [0.1 + a + m * s, 0, 0, 0, 0],
    [0.2 + a + m * s, 0.1 + a + m * s, 0, 0, 0],
    [0.3 + a + m * s, 0.2 + a + m * s, 0.1 + a + m * s, 0, 0],
    [0.4 + a + m * s, 0.3 + a + m * s, 0.2 + a + m * s, 0.1 + a + m * s, 0]])

num_trials = 1000
num_steps = 500
result_file_name = 'simulation/entropy-model2.csv'
sim_file_name = 'simulation/entropy-model2.sim'

def getFemaleToShow(belief):
    female = 0
    minEntropy = float('Inf')

    for f in range(n_female):
        # print('F' + repr(f + 1))
        like_prob = pi[f].dot(belief)
        beliefIfLike = pi[f] * belief / like_prob
        idx = beliefIfLike > 0
        entropyIfLike = - (np.log(beliefIfLike[idx]) * beliefIfLike[idx]).sum()
        # print(
        #     'Like: ' +
        #     'probability: ' + repr(like_prob) + ', ' +
        #     'belief: ' + repr(beliefIfLike) + ', ' +
        #     'entropy: ' + repr(entropyIfLike))

        hide_prob = (1 - pi[f]).dot(belief)
        beliefIfHide = (1 - pi[f]) * belief / hide_prob
        idx = beliefIfHide > 0
        entropyIfHide = - (np.log(beliefIfHide[idx]) * beliefIfHide[idx]).sum()
        # print(
        #     'Hide: ' +
        #     'probability: ' + repr(hide_prob) + ', ' +
        #     'belief: ' + repr(beliefIfHide) + ', ' +
        #     'entropy: ' + repr(entropyIfHide))

        entropy = entropyIfLike * like_prob + entropyIfHide * hide_prob
        # print('Expected entropy: ' + repr(entropy))
        if entropy < minEntropy:
            female = f
            minEntropy = entropy

    return female


def getObs(prob):
    x = random()
    if(x > prob):
        return 'Hide'
    else:
        return 'Like'


def output(out_file, op):
    print(op)
    out_file.write(op + '\n')


def runSimulation(sim_out_file, result_out_file):
    true_m = randint(0, 4)
    result_out_file.write(repr(true_m + 1) + ', ')
    output(sim_out_file, 'TRUE MALE BUCKET: M' + repr(true_m + 1))
    belief = np.array([0.2, 0.2, 0.2, 0.2, 0.2])
    output(sim_out_file, 'INITIAL BELIEF: ' + repr(belief))
    for i in range(num_steps):
        output(sim_out_file, '')
        f = getFemaleToShow(belief)
        output(sim_out_file, 'ACTION: F' + repr(f + 1))

        if getObs(pi[f][true_m]) == 'Like':
            output(sim_out_file, 'OBSERVATION: LIKE')
            # like probability vector
            lpv = pi[f]
            belief = lpv * belief / lpv.dot(belief)
        else:
            output(sim_out_file, 'OBSERVATION: HIDE')
            # hide probability vector
            hpv = 1 - pi[f]
            belief = hpv * belief / hpv.dot(belief)
        output(sim_out_file, 'NEW BELIEF: ' + repr(belief))

        exp_m = belief.dot([0, 1, 2, 3, 4])
        pred_m = int(exp_m / 0.8);
        output(sim_out_file, 'CURRENT PRED: M' + repr(pred_m + 1))

        if pred_m == true_m:
            result_out_file.write('1, ')
        else:
            result_out_file.write('0, ')

    result_out_file.write('\n')
    output(sim_out_file, '*********************** END OF SIMULATION ***********************')


if __name__ == '__main__':
    with open(sim_file_name, 'w+') as sim_file:
        with open(result_file_name, 'w+') as result_file:
            for i in range(num_trials):
                runSimulation(sim_file, result_file)
