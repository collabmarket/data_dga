require 'daru'
require 'fileutils'
require_relative 'dga'

db = DgaData.new
db.inicio()
print "db list of methods: " + (db.methods - Object.methods).to_s + "\n"
print "db.a0 list of methods: " + (db.a0.methods - Object.methods).to_s + "\n"

db.marcar_estacion('Chungara Ajata')
db.marcar_datos('a',1)
db.marcar_periodo('w1')
db.marcar_tipo('sinop')
db.bajar_excel()
#~ db.marcar_datos('b',1)
#~ db.marcar_rango('11/3/2016', '14/3/2016')

Webdrone.irb_console
