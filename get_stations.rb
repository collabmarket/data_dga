require 'daru'
require 'fileutils'
require_relative 'dga'

# stations_zero.csv todas las estaciones con datos cero
df = Daru::DataFrame.from_csv 'stations_zero.csv'
db = DgaData.new
db.inicio()
# Espera 1 seg en caso marcar_datos retorne nil
db.a0.conf.timeout = 1
# Lista indices datos
a = (1..18).to_a
lista_a = a.zip(['a'] * a.size)
b = (1..17).to_a
lista_b = b.zip(['b'] * b.size)

# Indice para todas las estaciones
all = df.index.entries

for i in all
    name = df['VALUE'][i].force_encoding('utf-8')
    db.marcar_estacion(name)
    puts "Estacion #{name} en fila #{i}"
    ok_a = true
    ok_b = true
    for j,ind in lista_a
        break if not ok_a 
        ok_a = db.marcar_datos(ind,j) == 'ok'
        df["#{ind}#{j}"][i] = 1 if  ok_a
    end
    for j,ind in lista_b
        break if not ok_b 
        ok_b = db.marcar_datos(ind,j) == 'ok'
        df["#{ind}#{j}"][i] = 1 if  ok_b
    end
end

# stations.csv todas las estaciones con datos revisado
df.write_csv('stations.csv')

# Close Browser
db.a0.quit
