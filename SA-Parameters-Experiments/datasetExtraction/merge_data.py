import numpy as np
n_likes = 31208834
n_hides = 57754949
n_actions = n_likes + n_hides
# data = np.zeros([n_actions, 3], )
if __name__ == '__main__':
    with open('user_like.csv', 'r') as likef:
        with open('user_hide.csv', 'r') as hidef:
            with open('actions.csv', 'w+') as actionsf:
                likeline = likef.readline()
                hideline = hidef.readline()
                for i in range(n_actions):
                    if likeline == '' or hideline == '':
                        break

                    like_args = likeline.split(';')
                    hide_args = hideline.split(';')
                    if(like_args[2] <= hide_args[2]):
                        u1 = like_args[0][1:-1]
                        u2 = like_args[1][1:-1]
                        # data[i] = [u1, u2, '1']
                        actionsf.write(','.join([u1, u2, '1']) + '\n')
                        likeline = likef.readline()
                    else:
                        u1 = hide_args[0][1:-1]
                        u2 = hide_args[1][1:-1]
                        # data[i] = [u1, u2, '0']
                        actionsf.write(','.join([u1, u2, '0']) + '\n')
                        hideline = hidef.readline()

                while likeline != '':
                    like_args = likeline.split(';')
                    u1 = like_args[0][1:-1]
                    u2 = like_args[1][1:-1]
                    # data[i] = [u1, u2, '1']
                    actionsf.write(','.join([u1, u2, '1']) + '\n')
                    likeline = likef.readline()

                while hideline != '':
                    hide_args = hideline.split(';')
                    u1 = hide_args[0][1:-1]
                    u2 = hide_args[1][1:-1]
                    # data[i] = [u1, u2, '0']
                    actionsf.write(','.join([u1, u2, '0']) + '\n')
                    hideline = hidef.readline()
