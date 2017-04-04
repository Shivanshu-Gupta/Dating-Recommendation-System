import numpy as np

n_users = 2000000
# to be set
features = np.zeros(n_users, 2)

lrate = 0.001


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
def doDescentFM(u1, u2, action):
    s = features[u1][0]
    a = features[u2][1]
    pred_action = sigma(s, a)
    err = lrate * (action - sigma(s, a))
    features[u1][0] += err * grad_sigma_s(s, a)
    features[u2][1] += err * grad_sigma_a(s, a)

if __name__ == '__main__':
    # read the file.
    with open('actions.csv', 'r') as actionsf:
        actionline = actionsf.readline()
        parts = actionline.split(',')
        u1 = int(parts[0])
        u2 = int(parts[1])
        action = int(parts[3])
        doDescentFM(u1, u2, action)