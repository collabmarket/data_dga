require 'daru'
require_relative 'dga'

df = Daru::DataFrame.from_excel('data.xls')
db = DgaData.new

for r in df.each_index()
    db.inicio()
    name = df[:VALUE][r]
    db.marcar_estacion(name)
    db.marcar_datos(a1: true)
    db.marcar_periodo(m3: true)
    db.marcar_tipo(sinop: true)
    db.bajar_excel()
end

print "db list of methods: " + (db.methods - Object.methods).to_s + "\n"
print "db.a0 list of methods: " + (db.a0.methods - Object.methods).to_s + "\n"

Webdrone.irb_console
