u1counts = {}
u2counts = {}


if __name__ == '__main__':
    with open('~/Downloads/user_like.csv', 'r') as likef:
        for line in likef:
            parts = line.split(';')
            u1 = int(parts[0][1:-1])
            u2 = int(parts[1][1:-1])
            if u1 in u1counts:
                u1counts[u1] += 1
            else:
                u1counts[u1] = 1

            if u2 in u2counts:
                u2counts[u2] += 1
            else:
                u2counts[u2] = 1
            