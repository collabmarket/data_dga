require 'daru'
require 'fileutils'
require_relative 'dga'

db = DgaData.new
db.inicio()
print "db list of methods: " + (db.methods - Object.methods).to_s + "\n"
print "db.a0 list of methods: " + (db.a0.methods - Object.methods).to_s + "\n"
puts "db.marcar_estacion('NOMBREESTACION')"
puts "db.marcar_datos('a|b',[1..18]|[1..17])"
puts "db.marcar_periodo('d1|w1|m1|m3')"
puts "db.marcar_rango('%d/%m/%Y', DateTime.now.strftime('%d/%m/%Y'))"
puts "db.marcar_tipo('sinop|insta')"
puts "db.bajar_excel()"
df = Daru::DataFrame.from_csv 'stations.csv'
# df['VALUE'][1] -> "Chungara Ajata"
db.marcar_estacion(df['VALUE'][1].force_encoding('utf-8'))
db.marcar_datos('a',1)
db.marcar_periodo('w1')
db.marcar_tipo('sinop')
db.bajar_excel()
#~ db.marcar_datos('b',1)
#~ db.marcar_rango('11/3/2016', '14/3/2016')

Webdrone.irb_console
