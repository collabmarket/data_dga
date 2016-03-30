require 'webdrone'

class DgaData  
  attr_accessor :a0
  
  def initialize
    @a0 = Webdrone.create browser: :firefox, timeout: 10, error: :ignore
  end
  
  def inicio
    @a0.open.url       'http://dgasatel.mop.cl/'
    @a0.clic.on        'Ingrese Aquí'
    @a0.clic.on        'Entrar'
  end
  
  def marcar_estacion(nombre)
    @a0.form.set       "estacion1", nombre
    @a0.wait.time        1
  end
  
  def marcar_datos(letra,num)
    @a0.clic.css       "input[name='chk_estacion1#{letra}']", n: num
  end
  
  def marcar_periodo(period)
    aux = {'d1' => 1, 'm3' => 2, 'w1' => 3, 'm1' => 5}
    @a0.clic.css       "input[name='period']", n: aux[period]
  end
  
  def marcar_rango(ini, fin)
    @a0.clic.css       "input[name='period']", n:4
    @a0.form.set         'fecha_ini', ini
    @a0.form.set         'fecha_finP', fin
  end
  
  def marcar_tipo(tipo)
    aux = {'insta' => 1, 'sinop' => 2}
    @a0.clic.css       "input[name='tiporep']", n: aux[tipo]
  end
  
  def bajar_excel
    @a0.clic.on        'Ver Tabla'
    @a0.clic.on        'Excel'
    @a0.clic.on        '« Volver'
  end
  
end
