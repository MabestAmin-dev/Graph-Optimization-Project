import numpy as np
import time
import sys
import copy

e = 1

prob = " ".join(sys.argv[1:]).split('.')[0]
fil = prob + '.npz'

npzfile = np.load(fil)
npzfile.files
m = npzfile['m']  # = 3
n = npzfile['n']  # = 5
s = npzfile['s']
d = npzfile['d']
f = npzfile['f']
c = npzfile['c']
# print 'm:',m,' n:',n
# print 's:',s
# print 'd:',d
# print 'f:',f
# print 'c:',c

t1 = time.time()
x = np.zeros((m, n), dtype=int)
y = np.zeros((m), dtype=int)

ss = copy.deepcopy(s)
dd = copy.deepcopy(d)

while sum(dd) > 0:
    total_cost = 0
    current_min = float("inf")
    factory = 0
    road = 0
    for i in range(m):
        if ss[i] <= 0:
            continue
        for j in range(n):
            if dd[j] <= 0:
                continue
            if c[i, j] < current_min:
                current_min = c[i, j]
                factory = i
                road = (i, j)
    x[road[0], road[1]] = 1
    y[factory] = 1
    supply_left = ss[factory]
    demand_left = dd[road[1]]
    if demand_left > supply_left:
        demand_left = demand_left - supply_left
        ss[factory] = 0
        dd[road[1]] = demand_left
    else:
        supply_left = supply_left - demand_left
        ss[factory] = supply_left
        dd[road[1]] = 0

    # find facility, find customer, send, at min cost
    # set x and y
    # deduct from ss and dd,
    # --------

elapsed = time.time() - t1
print('Tid: ' + str('%.4f' % elapsed))

# cost = sum(sum(np.multiply(c, x))) + e*np.dot(f, y)
print('Problem:', prob, ' Totalkostnad: ' + str(cost))
print('y:', y)
print('Antal byggda fabriker:', sum(y), '(av', m, ')')
