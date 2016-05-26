import pandas as pd
from os import path
df = pd.read_csv('stations.csv')
lastrow = 1
lastrowfile = 'tmp/lastrow.txt'
if path.exists(lastrowfile):
    with open(lastrowfile,'r') as f:
        lastrow = int(f.read())
print "df.loc[lastrow,'a1':] = \n", df.loc[lastrow,'a1':]
print "df.VALUE[lastrow] = ", df.VALUE[lastrow]
print "df.KEY[lastrow]", df.KEY[lastrow]
print "df[df.KEY == df.KEY[lastrow]].index.tolist()", df[df.KEY == df.KEY[lastrow]].index.tolist()
print "df.to_csv('stations.csv', index=False)"
print "lista iloc estaciones error acceso \n", zip(*pd.np.where( df.values == '?'))
