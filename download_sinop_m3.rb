require 'daru'
require 'fileutils'
require_relative 'dga'

# Parametros de tiempo
d = 1
m = 30*d
m3 = 3*m
today = DateTime.now
year = today.year
month = today.month

# stations.csv todas las estaciones con datos disponibles
df = Daru::DataFrame.from_csv 'stations.csv'
db = DgaData.new
db.inicio()
# Espera 1 seg en caso marcar_datos retorne nil
db.a0.conf.timeout = 3
# Lista indices datos
a = (1..18).to_a
a = a.zip(['a'] * a.size)
b = (1..17).to_a
b = b.zip(['b'] * b.size)
lista = a + b

descargas = Dir.pwd + '/' + db.a0.conf.outdir + '/'
rawdata = Dir.pwd + '/rawdata/'

#Crea directorio rawdata si no existe
FileUtils.mkdir(rawdata) if not File.exist?(rawdata)
# Descarga datos para todas las estaciones
all = df.index.entries
lastrow = 1
lastrowfile = 'tmp/lastrow.txt'
# Si existe lastrow.txt empieza desde ultima estacion descargada
lastrow = (File.open(lastrowfile, 'rb') { |f| f.read }).to_i if File.exist?(lastrowfile)
for i in all[lastrow..-1]
    # Guarda indice fila ultima estacion descargada
    File.open(lastrowfile, 'w') { |f| f.write(i.to_s) }
    name = df['VALUE'][i].force_encoding('utf-8')
    # Indica problema si marcar_estacion falla
    db.marcar_estacion(name)
    puts "Estacion  #{name} en fila #{i}"
    for j,ind in lista
        if df["#{ind}#{j}"][i] == 1
            ok = db.marcar_datos(ind,j)
            puts "Problema #{ind}#{j} en #{name} fila #{i}" if ok == nil
            db.marcar_tipo('sinop')
            db.marcar_periodo('m3')
            db.bajar_excel()
            db.a0.wait.time 3
            id = df['KEY'][i]
            file = "sinop_#{id}_#{ind}#{j}_m3.xls"
            FileUtils.mv(descargas + "reporte_sinoptico.xls", rawdata + file)
            #Desmarca datos
            db.marcar_datos(ind,j)
        end
    end
end
File.delete(lastrowfile)
