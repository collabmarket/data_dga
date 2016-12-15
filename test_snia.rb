require 'webdrone'
require 'daru'
require 'fileutils'


mime =  "images/jpeg, application/pdf, application/octet-stream, "\
        "application/download , application/vnd.ms-excel, "\
        "application/xls"

profile = Selenium::WebDriver::Firefox::Profile.new
profile['startup.homepage_welcome_url.additional'] = 'about:blank'
profile['browser.download.folderList'] = 2
profile['browser.download.manager.showWhenStarting'] = false
profile['browser.helperApps.neverAsk.saveToDisk'] = mime
profile['browser.helperApps.neverAsk.openFile'] = mime

$a0 = Webdrone.create timeout: 3, error: :ignore, browser: :firefox, firefox_profile: profile

reportes = {'calidad' => 28, 'fluvio' => 32, 'meteo' => 42, 
            'pozos' => 61, 'sedimentos' => 65
           }

calidad = { 'Parámetros Físico-Químicos (Mensual)' => 30 }
fluvio  = { 'Caudales Medios Mensuales' =>  34, 
            'Altura y Caudal Instantáneo (Diario)' => 37,
            'Caudales Medios Diarios' =>  40
          }
meteo   = { 'Temperaturas Medias Mensuales' => 44, 
            'Temperaturas Medias Diarias de Valores Sinópticos' => 47,
            'Temperaturas Diarias Extremas' => 50,
            'Precipitaciones Mensuales' => 53,
            'Precipitaciones Máximas Anuales en 24 horas' => 56,
            'Precipitaciones Diarias' => 59
          }
pozos       = { 'Niveles Estáticos en Pozos (Mensual)' =>  63 } 
sedimentos  = { 'Muestreo Rutinario (Diario)' => 67 }

variables = { 'calidad' => calidad, 'fluvio' => fluvio, 
              'meteo' => meteo, 'pozos' => pozos, 
              'sedimentos' => sedimentos
            }

def inicio
    $a0.open.url     'http://snia.dga.cl/BNAConsultas/reportes'
    $a0.wait.time        3
end

def salir
    $a0.quit
    exit
end

def buscar
    $a0.clic.on      'filtroscirhform:buscar'
    $a0.wait.time        3
    error = ($a0.find.id "popupInfoMessage_container") != nil
    $a0.clic.xpath '//*[@id="popupInfoMessage_header_controls"]' if error
end

def limpiar
    $a0.clic.on      'filtroscirhform:limpiar'
    $a0.wait.time        3
end

def marcar_reporte(rep)
    $a0.exec.script "window.scrollTo(0,0)"
    $a0.clic.xpath   "//*[@id=\"filtroscirhform:j_idt#{rep}:header\"]"
    $a0.wait.time        3
end

def marcar_variable(var)
    $a0.clic.id      "filtroscirhform:j_idt#{var}"
    $a0.wait.time        3
end

def buscar_por(value)
    aux = {'cuenca' => 0, 'region' => 1}
    $a0.clic.id      "filtroscirhform:selectBusqForEstacion:#{aux[value]}"
    $a0.wait.time        3
end

def marcar_region(reg)
    $a0.form.set         'filtroscirhform:region', reg
    $a0.wait.time        3
end

def marcar_cuenca(cuenca)
    $a0.form.set         'filtroscirhform:cuenca', cuenca
    $a0.wait.time        3
end

def marcar_estacion(i,j)
    $a0.exec.script "window.scrollTo(0,700)"
    step = (i/4)*100
    $a0.exec.script "document.getElementById(\"filtroscirhform:j_idt98:content\").scrollTo(0, #{step})"
    $a0.wait.time        1
    $a0.clic.xpath   "//*[@id=\"filtroscirhform:j_idt98:content\"]/table/tbody/tr[#{i}]/td[#{j}]/table/tbody/tr/td[1]/input"
end

def marcar_agno(inicio,fin)
    $a0.form.set         'filtroscirhform:fechaDesdeInputDate', "01/01/#{inicio}"
    $a0.form.set         'filtroscirhform:fechaHastaInputDate', "31/12/#{fin}"
end

def generarxls
    $a0.clic.on     'filtroscirhform:generarxls'
    $a0.wait.time        3
    error = ($a0.find.id "popupInfoMessage_container") != nil
    $a0.clic.xpath '//*[@id="popupInfoMessage_header_controls"]' if error
    return value = if error then nil else "ok" end
end

def copia_xls(origen, destino)
    FileUtils.mv Dir.glob(origen + '*.xls'), destino
end

def check_error
    error = ($a0.find.id "errorTitle") != nil
    (inicio; $a0.wait.time        3; buscar) if error
    return value = if error then "The connection was reset" else "ok" end
end
#~ a0.clic.xpath   '//*[@id="filtroscirhform:j_idt28:header"]'
#~ a0.wait.time        3
#~ a0.clic.id      'filtroscirhform:j_idt30'

regiones = ['', 'DE TARAPACA', 'DE ANTOFAGASTA', 'DE ATACAMA', 
            'DE COQUIMBO', 'DE VALPARAISO', "DEL LIB.BDO.O'HIGGINS", 
            'DEL MAULE', 'DEL BIOBIO', 'DE LA ARAUCANIA', 'DE LOS LAGOS', 
            'DE AISEN DEL GRAL.CARLOS IBAÑEZ', 
            'DE MAGALLANES Y DE LA ANTARTICA', 'METROPOLITANA', 
            'DE LOS RIOS', 'DE ARICA Y PARINACOTA'
           ]

cuencas1 = ['ALTIPLANICAS', 'QUEBRADA DE LA CONCORDIA', 'RIO LLUTA', 
            'RIO SAN JOSE', 'COSTERAS R.SAN JOSE-Q.CAMARONES', 
            'Q. RIO CAMARONES', 'COSTERAS R.CAMARONES-PAMPA DEL TAMARUGAL', 
            'PAMPA DEL TAMARUGAL', 'COSTERAS TILVICHE-LOA'
           ]
cuencas2 = ['FRONTERIZAS SALAR MICHINCHA-R.LOA', 'RIO LOA', 
            'COSTERAS R.LOA-Q.CARACOLES', 
            'FRONTERIZAS SALARES ATACAMA-SOCOMPA', 
            'ENDORREICA ENTRE FORNTERIZAS Y SALAR ATACAMA', 'SALAR DE ATACAMA', 
            'ENDORREICAS SALAR ATACAMA-VERTENTE PACIFICO', 
            'QUEBRADA CARACOLES', 'QUEBRADA LA NEGRA', 
            'QS.ENTRE Q. LA NEGRA Y Q. PAN DE AZUCAR'
           ]
cuencas3 = ['ENDORREICAS ENTRE FRONTERA Y VERTIENTE', 
            'COSTERAS Q.PAN DE AZUCAR-R.SALADO', 
            'RIO SALADO', 'COSTERAS E ISLAS R.SALADO-R.COPIAPO', 
            'RIO COPIAPO', 'COSTERAS R.COPIAPO-Q.TOTORAL', 
            'Q.TOTORAL Y COSTERAS HASTA Q.CARRIZAL', 
            'Q.CARRIZAL Y COSTERAS HASTA R.HUASCO', 
            'RIO HUASCO', 'COSTERAS E ISLAS R.HUASCO-CUARTA REGION'
           ]
cuencas4 = ['COSTERAS E ISLAS TERCERA REGION-Q.LOS CHOROS', 
            'RIO LOS CHOROS', 'COSTERAS R.LOS CHOROS-R. ELQUI', 
            'RIO ELQUI', 'COSTERAS R.ELQUI-R.LIMARI', 
            'RIO LIMARI', 'COSTERAS R.LIMARI-R.CHOAPA', 
            'RIO CHOAPA', 'COSTERAS R.CHOAPA-R.QUILIMARI', 
            'RIO QUILIMARI'
           ]
cuencas5 = ['COSTERA QUILIMARI-PETORCA', 'RIO PETORCA', 
            'RIO LIGUA', 'COSTERAS LIGUA-ACONCAGUA', 
            'RIO ACONCAGUA', 'COSTERAS ACONCAGUA-MAIPO', 
            'ISLAS DEL PACIFICO', 'RIO MAIPO', 
            'COSTERAS MAIPO-RAPEL'
           ]
cuencas6 = ['RIO RAPEL', 'COSTERAS RAPEL-E. NILAHUE']
cuencas7 = ['COSTERAS LIMITE SEPTIMA R.-RIO MATAQUITO', 'RIO MATAQUITO', 
            'COSTERAS MATAQUITO-MAULE', 'RIO MAULE', 
            'COSTERAS MAULE-LIMITE OCTAVA R.', 
            'RIO MATAQUITO', 'RIO MAULE'
           ]
cuencas8 = ['COSTERAS LIMITE OCTAVA R.-RIO ITATA', 'RIO ITATA', 
            'COSTERAS E ISLAS ENTRE RIO ITATA Y RIO BIO-BIO', 
            'RIO BIO-BIO', 
            'COSTERAS E ISLAS ENTRE RIOS BIO-BIO Y CARAMPANGUE', 
            'RIO CARAMPANGUE', 'COSTERAS CARAMPANGUE-LEBU', 
            'RIO LEBU', 'COSTERAS LEBU-PAICAVI', 
            'COSTERAS E ISLAS ENTRE R. PAICAVI Y LIMITE REG.'
           ]
cuencas9 = ['COSTERAS LIMITE REGION-R IMPERIAL', 'RIO IMPERIAL', 
            'RIO BUDI', 'COSTERAS R.BUDI-R.TOLTEN', 'RIO TOLTEN', 
            'RIO QUEULE'
           ]
cuencas10 = ['COSTERAS LIMITE REGION - R. VALDIVIA', 'RIO VALDIVIA', 
             'COSTERAS R. VALDIVIA - R. BUENO', 'RIO BUENO', 
             'CUENCAS E ISLAS R. BUENO - R. PUELO', 'RIO PUELO', 
             'COSTERAS R. PUELO - R. YELCHO', 'RIO YELCHO', 
             'COSTERAS R. YELCHO - LIMITE REGIONAL', 
             'ISLAS CHILOE Y CIRCUNDANTES'
            ]
cuencas11 = ['RIO PALENA Y COSTERAS LIMITE DECIMA REGION', 
             'COSTERAS E ISLAS R. PALENA - R. AISEN', 
             'ARCHIPIELAGOS DE LAS GUAITECAS Y DE LOS CHONOS', 
             'RIO AISEN', 
             'COSTERAS E ISLAS R AISEN R BAKER C. GRAL. MARTINEZ',  
             'RIO BAKER', 'COSTERAS E ISLAS R BAKER R PASCUA', 
             'RIO PASCUA', 'COSTERAS R PASCUA LIMITE REGION A GUAYECO', 
             'CUENCA DEL PACIFICO'
            ]
cuencas12 = ['COSTERAS LIMITE REGION - SENO ANDREW', 
             'ISLAS LIMITE REGION, CANAL ANCHO, E LA CONCEPCION', 
             'COSTERAS SENO ANDREW  R HOLLEMBERG', 
             'ISLAS C CONCEPCION, C SARMIENTO, E DE MAGALLANES', 
             'COSTERAS E ISLAS R HOLLEMBERG  LAGUNA BLANCA', 
             'COSTERAS L BLANCA E MAGALLANES', 
             'VERTIENTE DEL ATLANTICO', 
             'ISLAS AL SUR ESTRECHO DE MAGALLANES', 
             'TIERRA DEL FUEGO', 'TERRITORIO ANTARTICO'
            ]
cuencas13 = ['RIO MAIPO']
cuencas14 = cuencas10
cuencas15 = cuencas1

cuencas = [[], cuencas1, cuencas2, cuencas3, cuencas4, cuencas5, 
           cuencas6, cuencas7, cuencas8, cuencas9, cuencas10, cuencas11, 
           cuencas12, cuencas13, cuencas14, cuencas15]

#~ # Listar tipos de reporte
#~ reportes.each_key do |key, value|
    #~ puts "#{key}:#{value}"
#~ end

#~ # Marcar todos los reportes y variables
#~ limpiar
#~ reportes.each do |key_rep, value_rep|
    #~ puts "#{key_rep}"
    #~ marcar_reporte(value_rep)
    #~ variables[key_rep].each_value do |value_var|
        #~ marcar_variable(value_var)
    #~ end
#~ end
#~ 

# Marcar todas las cuencas
#~ limpiar
#~ buscar_por('cuenca')
#~ regiones.each_with_index do |reg,i|
    #~ marcar_region(reg)
    #~ $a0.form.get         'filtroscirhform:region'
    #~ for cuenca in cuencas[i]
        #~ marcar_cuenca(cuenca)
        #~ $a0.form.get         'filtroscirhform:cuenca'
    #~ end
#~ end

# Genera xls especifico
#~ inicio
#~ marcar_reporte(reportes['pozos'])
#~ marcar_variable(variables['pozos'].each_value.to_a[0])
#~ buscar_por('region')
#~ marcar_region(regiones[1])
#~ buscar
#~ marcar_estacion(1,1)
#~ marcar_agno(2010,2019)
#~ generarxls


#~ # Recorre todos los agnos
#~ agnos = (1960..2010).step(10).zip((1969..2019).step(10))
#~ for ini,fin in agnos
    #~ marcar_agno(ini,fin)
    #~ generarxls
#~ end


#~ # Recorre todas las estaciones
#~ for i in (1..35).to_a
    #~ for j in (1..3).to_a
        #~ break if marcar_estacion(i,j) == nil
    #~ end
#~ end

#~ # Recorre todas las regiones
#~ regiones[1..-1].each do |reg|
    #~ marcar_region(reg)
    #~ buscar
#~ end

tmpdir = Dir.pwd + '/tmp/snia/'
descargas = Dir.pwd + '/' + $a0.conf.outdir + '/'
#Crea directorio tmp si no existe
FileUtils.mkdir(tmpdir) if not File.exist?(tmpdir)

# Genera xls pozos, region I todas las estaciones, todos los agnos
agnos = (1960..2010).step(10).zip((1969..2019).step(10))
inicio
key_rep = 'pozos'
value_rep = reportes[key_rep]
marcar_reporte(value_rep)
i_var = 0
value_var = variables[key_rep].each_value.to_a[i_var]
marcar_variable(value_var)
buscar_por('region')
#~ i_reg = 2
#~ reg = regiones[i_reg]

for i_reg in (3..15).to_a
    reg = regiones[i_reg]
    marcar_region(reg)
    buscar
    d_r = tmpdir + "#{i_reg}" + '/'
    (puts "error reg:#{i_reg}") if File.exist?(d_r)
    (FileUtils.mkdir(d_r)) if not File.exist?(d_r)
    for i in (1..35).to_a
        puts "error max reg:#{i_reg} est:#{i}-#{j}" if [i,j] == [35,3]
        for j in (1..3).to_a
            puts check_error + " reg:#{i_reg} est:#{i}-#{j}"
            break if marcar_estacion(i,j) == nil
            d_e = d_r + "#{i}-#{j}" + '/'
            if File.exist?(d_e)
                puts "error reg:#{i_reg} est:#{i}-#{j}" 
                marcar_estacion(i,j)
                next
            end
            for ini,fin in agnos
                marcar_agno(ini,fin)
                generarxls
            end
            marcar_estacion(i,j)
            (FileUtils.mkdir(d_e); copia_xls(descargas, d_e)) if not File.exist?(d_e)
        end
    end
end

Webdrone.irb_console
