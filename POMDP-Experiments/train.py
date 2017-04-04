import numpy as np

# to be set
n_females = 100
n_males = 1000

female_features = np.zeros(n_females, 2)
male_features = np.zeros(n_males, 2)

lrate = 0.0001


# if using sigmoid(s*a)
def sigma(s, a):
    return 1 / (1.0 + exp(- s * a))

def grad_sigma_a(s, a):
    temp = sigma(s, a)
    return s * temp * (1 - temp)

def grad_sigma_s(s, a):
    return a * temp * (1 - temp)

# female user, male profile
# action = 1 if like and 0 if hide
def doDescentFM(f, m, action):
    s = female_features[f][0]
    a = male_features[m][1]
    pred_action = sigma(s, a)
    err = lrate * (action - sigma(s, a))
    female_features[f][0] += err * grad_sigma_s(s, a)
    male_features[m][1] += err * grad_sigma_a(s, a)

# male user, female profile
# action = 1 if like and 0 if hide
def doDescentMF(m, f, action):
    s = male_features[m][0]
    a = female_features[f][1]
    pred_action = sigma(s, a)
    err = lrate * (action - sigma(s, a))
    male_features[m][0] += err * grad_sigma_s(s, a)
    female_features[f][1] += err * grad_sigma_a(s, a)


if __name__ == '__main__':
    # read the file.
