#!/usr/bin/python
# -*- coding: utf-8 -*-

import pandas as pd
import matplotlib.pyplot as plt
plt.style.use('ggplot')

## Float columns
float_columns = [u'Caudal AnualProm', 
                 u'Enero', u'Febrero', u'Marzo', u'Abril', 
                 u'Mayo', u'Junio', u'Julio', u'Agosto', 
                 u'Septiembre', u'Octubre', u'Noviembre', 
                 u'Diciembre'
                ]

## Not used columns
drop_columns =  [u'Referencia a puntos conocidos de captación', 
                 u'Referencia a puntos conocidos de restitución'
                ]

short = dict(caudal=u'Caudal AnualProm', 
             usuario=u'Nombre Solicitante', 
             tipo=u'Tipo Derecho',
             naturaleza=u'Naturaleza del Agua', 
             ejercicio=u'Ejercicio del Derecho', 
             fuente=u'Clasificación Fuente', 
            )

col_index = u'Fecha de Resolución Envío al Juez Inscripción C.B.R.'

def open_meta(filename='ddaa.csv'):
    return pd.read_csv(filename, index_col='id')

def open_ddaa(filename):
    ## Open file
    karg_xls = dict(skiprows=6)
    df = pd.read_excel(filename, **karg_xls)
    ## Strip columns names
    df.rename(columns=lambda x: x.strip(), inplace=True)
    df.rename(columns=lambda x: x.replace('\n',''), inplace=True)
    df.rename(columns=lambda x: x.replace('/',''), inplace=True)
    ## Drop not used columns
    df.drop(drop_columns, axis=1, inplace=True)
    df.dropna(axis=1, how='all', inplace=True)
    ## Mixed dtype to unicode
    aux = df.select_dtypes(include=['object'])
    f = lambda x: x.astype('unicode')
    df.loc[:, aux.columns] = aux.apply(f, axis=1)
    ## Strip all unicode
    aux = df.select_dtypes(include=['object'])
    df.loc[:, aux.columns] = aux.applymap(lambda x: x.strip())
    ## Replace comma with point then float
    f = lambda x: pd.to_numeric(x.str.replace(',','.'))
    aux = df.loc[:, float_columns]
    df.loc[:, aux.columns] = aux.apply(f, axis=1)
    ## Date to datetime
    f = lambda x: pd.to_datetime(x, dayfirst=True)
    aux = df[[col_index]]
    df.loc[:, aux.columns] = aux.apply(f, axis=1)
    ## Date to index
    df.set_index(col_index, inplace=True)
    return df

def top_ddaa(df, n=25):
    by = short['caudal']
    columns = [short['usuario'],short['caudal']]
    return df.sort_values(by, ascending=False).head(n)[columns]

def busca(df, pattern, column=u'Nombre Solicitante'):
    return df[df.loc[:,column].str.contains(pattern)].loc[:,short.values()]

def zoom(ax, factor=.1):
    yi, yf = ax.get_ylim()
    xi, xf = ax.get_xlim()
    dx = (xf - xi)
    dy = (yf - yi)
    xi -= dx * factor
    xf += dx * factor
    yi -= dy * factor
    yf += dy * factor
    ax.set_xlim([xi,xf])
    ax.set_ylim([yi,yf])

if __name__ == '__main__':
    try:
        get_ipython().magic(u'matplotlib inline')
    except NameError:
        print "IPython console not available."

