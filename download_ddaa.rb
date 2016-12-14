require 'daru'
require 'fileutils'
require_relative 'dga'

df = Daru::DataFrame.from_csv 'ddaa.csv'
db = DgaData.new logger: false

tmpdir = Dir.pwd + '/tmp/'
descargas = Dir.pwd + '/' + db.a0.conf.outdir + '/'
rawdata = Dir.pwd + '/rawdata/www.dga.cl/'

#Crea directorio tmp si no existe
FileUtils.mkdir(tmpdir) if not File.exist?(tmpdir)
#Crea directorio rawdata si no existe
FileUtils.mkdir(rawdata) if not File.exist?(rawdata)
# Descarga datos para todas las estaciones
all = df.index.entries

# Espera 3 seg
db.a0.conf.timeout = 3

# Descarga archivos
for i in all
    db.a0.open.url          df['url'][i]
    db.a0.wait.time         3
end

# Mueve archivos descargados
for i in all
    filename = df['filename'][i]
    if File.exist?(descargas + filename)
        FileUtils.mv(descargas + filename, rawdata + filename)
    end
end

# Close Browser
db.a0.quit
