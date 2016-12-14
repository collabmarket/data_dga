require 'webdrone'
require 'daru'
require 'fileutils'

profile = Selenium::WebDriver::Firefox::Profile.new
profile['startup.homepage_welcome_url.additional'] = 'about:blank'
profile['browser.download.folderList'] = 2
profile['browser.download.manager.showWhenStarting'] = false
profile['browser.helperApps.neverAsk.saveToDisk'] = "images/jpeg, application/pdf, application/octet-stream, application/download, application/vnd.ms-excel"
   

$a0 = Webdrone.create timeout: 3, error: :ignore, browser: :firefox, firefox_profile: profile

reportes = {'calidad' => 28, 'fluvio' => 32, 
            'meteo' => 42, 'pozos' => 61, 'sedimentos' => 65
           }

calidad = { 'Parámetros Físico-Químicos (Mensual)' => 30} 
fluvio  = { 'Caudales Medios Mensuales' =>  34, 
            'Altura y Caudal Instantáneo (Diario)' => 37,
            'Caudales Medios Diarios' =>  40} 
meteo   = { 'Temperaturas Medias Mensuales' => 44, 
            'Temperaturas Medias Diarias de Valores Sinópticos' => 47, 
            'Temperaturas Diarias Extremas' => 50, 
            'Precipitaciones Mensuales' => 53,
            'Precipitaciones Máximas Anuales en 24 horas' => 56, 
            'Precipitaciones Diarias' => 59}
pozos       = { 'Niveles Estáticos en Pozos (Mensual)' =>  63} 
sedimentos  = { 'Muestreo Rutinario (Diario)' => 67}

variables = {   'calidad' => calidad, 'fluvio' => fluvio, 
                'meteo' => meteo, 'pozos' => pozos, 
                'sedimentos' => sedimentos}

def inicio
    $a0.open.url     'http://snia.dga.cl/BNAConsultas/reportes'
    $a0.wait.time        3
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

#~ a0.clic.xpath   '//*[@id="filtroscirhform:j_idt28:header"]'
#~ a0.wait.time        3
#~ a0.clic.id      'filtroscirhform:j_idt30'

regiones = [ '', 'DE TARAPACA', 'DE ANTOFAGASTA', 'DE ATACAMA', 
             'DE COQUIMBO', 'DE VALPARAISO', "DEL LIB.BDO.O'HIGGINS", 
             'DEL MAULE', 'DEL BIOBIO', 'DE LA ARAUCANIA', 'DE LOS LAGOS', 
             'DE AISEN DEL GRAL.CARLOS IBAÑEZ', 
             'DE MAGALLANES Y DE LA ANTARTICA', 'METROPOLITANA', 
             'DE LOS RIOS', 'DE ARICA Y PARINACOTA']
 
cuencas1 = ['ALTIPLANICAS', 'QUEBRADA DE LA CONCORDIA', 'RIO LLUTA', 
            'RIO SAN JOSE', 'COSTERAS R.SAN JOSE-Q.CAMARONES', 
            'Q. RIO CAMARONES', 'COSTERAS R.CAMARONES-PAMPA DEL TAMARUGAL', 
            'PAMPA DEL TAMARUGAL', 'COSTERAS TILVICHE-LOA']
cuencas2 = ['FRONTERIZAS SALAR MICHINCHA-R.LOA', 'RIO LOA', 
            'COSTERAS R.LOA-Q.CARACOLES', 
            'FRONTERIZAS SALARES ATACAMA-SOCOMPA', 
            'ENDORREICA ENTRE FORNTERIZAS Y SALAR ATACAMA', 'SALAR DE ATACAMA', 
            'ENDORREICAS SALAR ATACAMA-VERTENTE PACIFICO', 
            'QUEBRADA CARACOLES', 'QUEBRADA LA NEGRA', 
            'QS.ENTRE Q. LA NEGRA Y Q. PAN DE AZUCAR']
cuencas3 = ['ENDORREICAS ENTRE FRONTERA Y VERTIENTE', 
            'COSTERAS Q.PAN DE AZUCAR-R.SALADO', 
            'RIO SALADO', 'COSTERAS E ISLAS R.SALADO-R.COPIAPO', 
            'RIO COPIAPO', 'COSTERAS R.COPIAPO-Q.TOTORAL', 
            'Q.TOTORAL Y COSTERAS HASTA Q.CARRIZAL', 
            'Q.CARRIZAL Y COSTERAS HASTA R.HUASCO', 
            'RIO HUASCO', 'COSTERAS E ISLAS R.HUASCO-CUARTA REGION']
cuencas4 = ['COSTERAS E ISLAS TERCERA REGION-Q.LOS CHOROS', 
            'RIO LOS CHOROS', 'COSTERAS R.LOS CHOROS-R. ELQUI', 
            'RIO ELQUI', 'COSTERAS R.ELQUI-R.LIMARI', 
            'RIO LIMARI', 'COSTERAS R.LIMARI-R.CHOAPA', 
            'RIO CHOAPA', 'COSTERAS R.CHOAPA-R.QUILIMARI', 
            'RIO QUILIMARI']
cuencas5 = ['COSTERA QUILIMARI-PETORCA', 'RIO PETORCA', 
            'RIO LIGUA', 'COSTERAS LIGUA-ACONCAGUA', 
            'RIO ACONCAGUA', 'COSTERAS ACONCAGUA-MAIPO', 
            'ISLAS DEL PACIFICO', 'RIO MAIPO', 
            'COSTERAS MAIPO-RAPEL']
cuencas6 = ['RIO RAPEL', 'COSTERAS RAPEL-E. NILAHUE']
cuencas7 = ['COSTERAS LIMITE SEPTIMA R.-RIO MATAQUITO', 'RIO MATAQUITO', 
            'COSTERAS MATAQUITO-MAULE', 'RIO MAULE', 
            'COSTERAS MAULE-LIMITE OCTAVA R.', 
            'RIO MATAQUITO', 'RIO MAULE']
cuencas8 = ['COSTERAS LIMITE OCTAVA R.-RIO ITATA', 'RIO ITATA', 
            'COSTERAS E ISLAS ENTRE RIO ITATA Y RIO BIO-BIO', 
            'RIO BIO-BIO', 
            'COSTERAS E ISLAS ENTRE RIOS BIO-BIO Y CARAMPANGUE', 
            'RIO CARAMPANGUE', 'COSTERAS CARAMPANGUE-LEBU', 
            'RIO LEBU', 'COSTERAS LEBU-PAICAVI', 
            'COSTERAS E ISLAS ENTRE R. PAICAVI Y LIMITE REG.']
cuencas9 = ['COSTERAS LIMITE REGION-R IMPERIAL', 'RIO IMPERIAL', 
            'RIO BUDI', 'COSTERAS R.BUDI-R.TOLTEN', 'RIO TOLTEN', 
            'RIO QUEULE']
cuencas10 = ['COSTERAS LIMITE REGION - R. VALDIVIA', 'RIO VALDIVIA', 
             'COSTERAS R. VALDIVIA - R. BUENO', 'RIO BUENO', 
             'CUENCAS E ISLAS R. BUENO - R. PUELO', 'RIO PUELO', 
             'COSTERAS R. PUELO - R. YELCHO', 'RIO YELCHO', 
             'COSTERAS R. YELCHO - LIMITE REGIONAL', 
             'ISLAS CHILOE Y CIRCUNDANTES']
cuencas11 = ['RIO PALENA Y COSTERAS LIMITE DECIMA REGION', 
             'COSTERAS E ISLAS R. PALENA - R. AISEN', 
             'ARCHIPIELAGOS DE LAS GUAITECAS Y DE LOS CHONOS', 
             'RIO AISEN', 
             'COSTERAS E ISLAS R AISEN R BAKER C. GRAL. MARTINEZ',  
             'RIO BAKER', 'COSTERAS E ISLAS R BAKER R PASCUA', 
             'RIO PASCUA', 'COSTERAS R PASCUA LIMITE REGION A GUAYECO', 
             'CUENCA DEL PACIFICO']
cuencas12 = ['COSTERAS LIMITE REGION - SENO ANDREW', 
             'ISLAS LIMITE REGION, CANAL ANCHO, E LA CONCEPCION', 
             'COSTERAS SENO ANDREW  R HOLLEMBERG', 
             'ISLAS C CONCEPCION, C SARMIENTO, E DE MAGALLANES', 
             'COSTERAS E ISLAS R HOLLEMBERG  LAGUNA BLANCA', 
             'COSTERAS L BLANCA E MAGALLANES', 
             'VERTIENTE DEL ATLANTICO', 
             'ISLAS AL SUR ESTRECHO DE MAGALLANES', 
             'TIERRA DEL FUEGO', 'TERRITORIO ANTARTICO']
cuencas13 = ['RIO MAIPO']
cuencas14 = cuencas10
cuencas15 = cuencas1

cuencas = [[], cuencas1, cuencas2, cuencas3, cuencas4, cuencas5, 
           cuencas6, cuencas7, cuencas8, cuencas9, cuencas10, cuencas11, 
           cuencas12, cuencas13, cuencas14, cuencas15]

inicio
#~ # Listar tipos de reporte
#~ reportes.each_key do |key, value|
    #~ puts "#{key}:#{value}"
#~ end
#~ # Marcar todos los reportes y variables
#~ reportes.each do |key, value|
    #~ puts "#{key}"
    #~ marcar_reporte(value)
    #~ variables[key].each_value do |value_|
        #~ marcar_variable(value_)
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

# Marcar todas las regiones
limpiar
marcar_reporte(reportes['pozos'])
marcar_variable(variables['pozos'].each_value.to_a[0])
buscar_por('region')
regiones[1..-1].each do |reg|
    marcar_region(reg)
    buscar
end

Webdrone.irb_console
