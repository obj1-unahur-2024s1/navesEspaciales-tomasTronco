class NaveEspacial{
	var velocidad = 0
	var direccionAlSol = 0
	var combustible = 0
	
	method combustible() = combustible
	method velocidad() = velocidad
	method direccionAlSol() = direccionAlSol
	
	method cargarCombustible(cantidad){
		combustible = combustible + cantidad
	}
	method descargarCombustible(cantidad){
		combustible = (combustible - cantidad).max(0)
	}
	
	method acelerar(cuanto){
		velocidad = (velocidad + cuanto).min(100000)
	}
	method desacelerar(cuanto){
		velocidad = (velocidad - cuanto).max(0)
	}
	
	method irHaciaElSol(){direccionAlSol = 10}
	method escaparDelSol(){direccionAlSol = -10}
	method ponerParaleloAlSol(){direccionAlSol = 0}
	
	method acercarseUnPocoAlSol(){
		direccionAlSol = (direccionAlSol + 1).min(10)
	}
	method alejarseUnPocoAlSol(){
		direccionAlSol = (direccionAlSol - 1).max(-10)
	}
	
	method prepararViaje(){
		self.cargarCombustible(30000)
		self.acelerar(5000)
	}
	
	method estaTranquila() = self.combustible() > 4000 && self.velocidad() < 12000
	
	method recibirAmenaza(){
		self.escapar()
		self.avisar()
	}
	
	method escapar(){}
	method avisar(){}
	
	method relajo() = self.estaTranquila()
}

class NaveBaliza inherits NaveEspacial{
	var colorBaliza
	var cambioColor = false
	
	method colorBaliza() = colorBaliza
	
	method cambiarColorDeBaliza(colorNuevo){
		colorBaliza = colorNuevo
		cambioColor = true
	}
	
	override method prepararViaje(){
		super()
		self.cambiarColorDeBaliza("Verde")
		self.ponerParaleloAlSol()
	}
	
	override method estaTranquila() = super() && self.colorBaliza() != "Rojo"
	
	override method escapar(){
		self.irHaciaElSol()
	}
	
	override method avisar(){
		self.cambiarColorDeBaliza("Rojo")
	}
	
	override method relajo() = super() && not cambioColor
}

class NavePasajeros inherits NaveEspacial{
	var property pasajeros
	var racionesComida
	var racionesBebida
	var racionesComidaServida
	
	method racionesComida() = racionesComida
	method racionesBebida() = racionesBebida
	
	method cargarComida(cantidad){
		racionesComida = racionesComida + cantidad
	}
	method descargarComida(cantidad){
		racionesComida = (racionesComida - cantidad).max(0)
		racionesComidaServida = racionesComidaServida + cantidad
	}
	
	method cargarBebida(cantidad){
		racionesBebida = racionesBebida + cantidad
	}
	method descargarBebida(cantidad){
		racionesBebida = (racionesBebida - cantidad).max(0)
	}
	
	override method prepararViaje(){
		self.cargarComida(4)
		self.cargarBebida(6)
		super()
		self.acercarseUnPocoAlSol()
	}
	
	override method escapar(){
		self.acelerar(self.velocidad())
	}
	
	override method avisar(){
		self.descargarComida(pasajeros)
		self.descargarBebida(pasajeros * 2)
	}
	
	override method relajo() = super() && racionesComidaServida < 50
}

class NaveCombate inherits NaveEspacial{
	var invisible = false
	var misilesDesplegados = false
	const property mensajes = []
	
	method invisible() = invisible
	method misilesDesplegados() = misilesDesplegados
	
	method ponerseVisible(){invisible = false}
	method ponerseInvisible(){invisible = true}
	
	method desplegarMisiles(){misilesDesplegados = true}
	method replegarMisiles(){misilesDesplegados = false}
	
	method emitirMensaje(mensaje){
		mensajes.add(mensaje)
	}
	method mensajesEmitidos() = mensajes
	
	method primerMensajeEmitido() = mensajes.first()
	method ultimoMensajeEmitido() = mensajes.last()
	
	method esEscueta() = mensajes.all({mensajeX => mensajeX.size()<30})
	
	method emitioMensaje(mensaje) = mensajes.contains({mensajeX => mensajeX == mensaje})
	
	override method prepararViaje(){
		super()
		self.ponerseVisible()
		self.replegarMisiles()
		self.acelerar(15000)
		self.emitirMensaje("Saliendo en misiones")
	}
	
	override method estaTranquila() = super() && not self.misilesDesplegados()
	
	override method escapar(){
		self.acercarseUnPocoAlSol()
		self.acercarseUnPocoAlSol()
	}
	
	override method avisar(){
		self.emitirMensaje("Amenaza Recibida")
	}
	
	override method relajo() = super() && self.esEscueta()
}

class NaveHospital inherits NavePasajeros{
	var property quirofanoPreparado
	
	override method estaTranquila() = super() && not self.quirofanoPreparado()
	
	override method recibirAmenaza(){
		super()
		self.quirofanoPreparado(true)
	}
}

class NaveCombateSigilosa inherits NaveCombate{
	override method estaTranquila() = super() && not self.invisible()
	
	override method escapar(){
		super()
		self.desplegarMisiles()
		self.ponerseInvisible()
	}
}