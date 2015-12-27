require 'webdrone'

class DgaData  
  attr_accessor :a0
  
  def initialize
    profile = Selenium::WebDriver::Firefox::Profile.new
    profile['startup.homepage_welcome_url.additional'] = 'about:blank'
    profile['browser.helperApps.neverAsk.saveToDisk'] = 'images/jpeg, application/pdf, application/octet-stream, application/download, application/vnd.ms-excel'
    @a0 = Webdrone.create browser: :firefox, timeout: 10, firefox_profile: profile
  end
  
  def inicio
    @a0.open.url       'http://dgasatel.mop.cl/'
    @a0.clic.on        'Ingrese Aquí'
    @a0.clic.on        'Entrar'
  end
  
  def marcar_estacion(nombre)
    @a0.form.set       "estacion1", nombre
  end
  
  def marcar_datos(a1: false, a2: false, a3: false, a4: false, 
                   b1: false, b2: false, b3: false, b4: false)
    @a0.clic.css       "input[name='chk_estacion1a']", n:1     if a1
    @a0.clic.css       "input[name='chk_estacion1a']", n:2     if a2
    @a0.clic.css       "input[name='chk_estacion1a']", n:3     if a3
    @a0.clic.css       "input[name='chk_estacion1a']", n:4     if a4
    @a0.clic.css       "input[name='chk_estacion1b']", n:1     if b1
    @a0.clic.css       "input[name='chk_estacion1b']", n:2     if b2
    @a0.clic.css       "input[name='chk_estacion1b']", n:3     if b3
    @a0.clic.css       "input[name='chk_estacion1b']", n:4     if b4
  end
  
  def marcar_periodo(d1: false, w1: false, m1: false, m3: false)
    @a0.clic.css       "input[name='period']", n:1     if d1
    @a0.clic.css       "input[name='period']", n:2     if m3
    @a0.clic.css       "input[name='period']", n:3     if w1
    @a0.clic.css       "input[name='period']", n:5     if m1
  end
  
  def marcar_rango(ini, fin)
    @a0.clic.css       "input[name='period']", n:4
    @a0.form.set         'fecha_ini', ini
    @a0.form.set         'fecha_finP', fin
  end
  
  def marcar_tipo(insta: false, sinop: false)
    @a0.clic.css       "input[name='tiporep']", n:1     if insta
    @a0.clic.css       "input[name='tiporep']", n:2     if sinop
  end
  
  def bajar_excel
    @a0.clic.on        'Ver Tabla'
    @a0.clic.on        'Excel'
    @a0.clic.on        '« Volver'
  end
  
end
