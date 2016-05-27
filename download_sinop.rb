require 'daru'
require 'fileutils'
require_relative 'dga'

# Parametros de tiempo
today = DateTime.now

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

tmpdir = Dir.pwd + '/tmp/'
descargas = Dir.pwd + '/' + db.a0.conf.outdir + '/'
rawdata = Dir.pwd + '/rawdata/'

#Crea directorio tmp si no existe
FileUtils.mkdir(tmpdir) if not File.exist?(tmpdir)
#Crea directorio rawdata si no existe
FileUtils.mkdir(rawdata) if not File.exist?(rawdata)
lastrowfile = tmpdir + 'lastrow_sinop.txt'
errorfile = tmpdir + 'error_sinop.txt'
# Descarga datos para todas las estaciones
all = df.index.entries
lastrow = 1
# Si existe lastrow.txt empieza desde ultima estacion descargada
lastrow = (File.open(lastrowfile, 'rb') { |f| f.read }).to_i if File.exist?(lastrowfile)
for i in all[lastrow..-1]
    # Guarda indice fila ultima estacion descargada
    File.open(lastrowfile, 'w') { |f| f.write(i.to_s) }
    name = df['VALUE'][i].force_encoding('utf-8')
    # Indica problema si marcar_estacion falla
    db.marcar_estacion(name)
    puts "Estacion #{name} en fila #{i}"
    for j,ind in lista
        if df["#{ind}#{j}"][i] == 1
            ok = db.marcar_datos(ind,j)
            puts "Selecciona #{ind}#{j} en #{name} fila #{i}"
            if ok == nil
                error_msg = "Problema #{ind}#{j} en #{name} fila #{i}"
                puts error_msg
                File.open(errorfile, 'a') { |f| f.write(error_msg + "\n") }
                break
            end
            db.marcar_tipo('sinop')
            id = df['KEY'][i]
            aux = today
            descarga = true
            while descarga do
                dfin = aux.strftime("%d/%m/%Y")
                if aux == today
                    # Presente agno
                    aux = DateTime.new(aux.year, 1, 1)
                else
                    # Restricciones DGA
                    # Maximo 3 agnos, datos hasta 1999
                    iniyear = aux.year - 3
                    iniyear = 1999 if iniyear < 1999
                    aux = DateTime.new(iniyear, 1, 1)
                end
                dini = aux.strftime("%d/%m/%Y")
                yearini = aux.year.to_s
                file = "sinop_#{id}_#{ind}#{j}_#{yearini}.xls"
                db.marcar_rango(dini, dfin)
                db.bajar_excel()
                db.a0.wait.time 3
                if File.exist?(descargas + "reporte_sinoptico.xls")
                    FileUtils.mv(descargas + "reporte_sinoptico.xls", rawdata + file)
                    # Datos hasta 1999
                    descarga = false if aux.year == 1999
                    puts "Descarga #{aux.year} en  #{ind}#{j} en #{name} fila #{i}"
                else
                    # Error DGA timed out
                    descarga = false
                    puts "Error en  #{ind}#{j} en #{name} fila #{i}"
                end
            end
            #Desmarca datos
            db.marcar_datos(ind,j)
        end
    end
end
File.delete(lastrowfile)
