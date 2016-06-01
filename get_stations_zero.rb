require 'daru'
require 'fileutils'
require 'hpricot'
require_relative 'dga'

# stations_zero.csv todas las estaciones con datos cero
db = DgaData.new
db.inicio()
# Get page source
page = db.a0.exec.script 'return document.documentElement.innerHTML'
# Close Browser
db.a0.quit

# HTML parser
doc = Hpricot(page)
# Listado estaciones repetido tres veces
stations3 = (doc/"select/option").map {|i| i.to_plain_text}

#~ File.open('page.txt', "w:ISO-8859-1") { |f| f.write(page) }
#~ page = File.open('page.txt', "rb:ISO-8859-1") { |f| f.read }

# Lista indices datos
a = (1..18).to_a
b = (1..17).to_a
col_a = a.map { |i| 'a'+ i.to_s }
col_b = a.map { |i| 'b'+ i.to_s }
col = col_a + col_b

# Ultimo indice primer listado estaciones
last = stations3.index("- Seleccione Estación 2 -") - 1
# Primer listado estaciones
stations = stations3[1..last]
# Array con id, nombre, indice
key = stations.map { |i| /(\d+-[\dK])/.match(i)[1].to_s }
value = stations.map { |i| /\s+(.*)/.match(i)[1].to_s }
index = (0..last-1).to_a
# Matriz con ceros
zeros = [Array.new(last, 0)]*col.length
# Crea y combina DataFrames
df = Daru::DataFrame.new({KEY: key, VALUE: value})
df_zero = Daru::DataFrame.new(zeros, order: col, index: index)
df = df.merge(df_zero)

df.write_csv('stations_zero.csv')
