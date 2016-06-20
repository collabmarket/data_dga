import pandas as pd

aux = pd.read_excel('caudalesmediosmensuales.xls', header=None)

ind = [[0,0,0,0], # u'MINISTERIO DE OBRAS PUBLICAS'
       [0,1,0,0], # u'DIRECCION GENERAL DE AGUAS'
       [0,2,0,0], # u'CENTRO DE INFORMACION DE RECURSOS HIDRICOS'
       [0,7,0,2], #u'Estaci\xf3n       :'
       [0,8,0,2], # u'C\xf3digo BNA:'
       [0,9,0,2], # u'Altitud        :'
       [0,10,0,2], # u'Cuenca       :'
       [6,4,6,6], # u'CAUDALES MEDIOS MENSUALES   (m3/s)'
       [7,8,7,8], # u'Latitud S :' 
       [7,9,7,8], # u'Longitud W  :'
       [7,10,7,8], # u'SubCuenca :'
       [14,8,14,17], # u'UTM Norte  :'
       [14,9,14,17], # # u'UTM Este    :'
       [14,10,14,17], # u'\xc1rea de Drenaje:'
       [18,0,18,23], # u'PAGINA'
       [18,1,18,23], # u'FECHA EMISION INFORME'
       [0,40,0,0], # u'INDICADORES MESES INCOMPLETOS:'
       ]

lista = []
for row in ind:
    i,j,m,n = tuple(row)
    s = aux[i][j]
    lista.append((aux[aux[m] == s][n]).reset_index(drop=True))

df_meta = pd.concat(lista, axis=1)

lista = [df_meta]
s = aux[0][40]
a = pd.np.array(aux[aux[0] == s].index.tolist())
ind = [0, # u'*     : 1 - 10 Dias con Informacion en el Mes'
       1, # u'@     : 11 - 20 Dias con Informacion en el Mes'
       2  # u'%     : M\xe1s de 20 Dias con Informacion en el Mes'
      ]
for i in ind:
    lista.append(aux.loc[a + i, 5].reset_index(drop=True))

df_meta = pd.concat(lista, axis=1)


 # u'INDICADORES MESES INCOMPLETOS:'
s = aux[0][40]
end = aux[aux[0] == s].index.tolist()
# u'A\xd1O'
s = aux[0][12]
init = aux[aux[0] == s].index.tolist()

lista_values = []
lista_mask = []
for i,j in zip(init,end):
    df = aux.iloc[init[0]:end[0], :].reset_index(drop=True)
    df.columns = df.iloc[0]
    df = df.reindex(df.index.drop(0))
    # u'A\xd1O' as index
    df.set_index(s, inplace=True)
    df_values = df.iloc[:,range(df.columns.size)[::2]]
    df_mask = df.iloc[:,range(df.columns.size)[1::2]]
    df_mask.columns = df_values.columns
    lista_values.append(df_values)
    lista_mask.append(df_mask)
