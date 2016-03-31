require 'daru'
require 'fileutils'
require_relative 'dga'

# stations_zero.csv todas las estaciones con datos cero
df = Daru::DataFrame.from_csv 'stations_zero.csv'
db = DgaData.new
db.inicio()
# Espera 2 seg en caso marcar_datos retorne nil
db.a0.conf.timeout = 1
# Lista indices datos
a = (1..18).to_a
b = (1..17).to_a

# Revisa si datos existen para todas las estaciones
for name,i in df['VALUE'].each_with_index()
    # Pasa siguiente estacion si estacion no existe
    # Indica encode utf-8
    next if not db.marcar_estacion(name.force_encoding('utf-8')) == 'ok'
    error_a = false
    error_b = false
    for j in a
        # Detiene si ultimo dato da error
        break if error_a
        ok_a = db.marcar_datos('a',j) == 'ok'
        df["a#{j}"][i] = 1 if  ok_a
        # Marcar error si dato no existe
        error_a = true if not ok_a
    end
    for j in b
        # Detiene si ultimo dato da error
        break if error_b
        ok_b = db.marcar_datos('b',j) == 'ok'
        df["b#{j}"][i] = 1 if  ok_b
        # Marcar error si dato no existe
        error_b = true if not ok_b
    end
end
# stations.csv todas las estaciones con datos revisado
df.write_csv('stations.csv')

