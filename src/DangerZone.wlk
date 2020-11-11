
// EMPLEADO

class Empleado{
	var puesto
	var salud = 100
	const habilidades= #{}
	
	method perderSalud(cantidad){
		salud -= cantidad
	}
	method puedeUsarHabilidad(habilidad)
		= !self.estaIncapacitado() and self.poseeHabilidad(habilidad)
	method estaIncapacitado()
		= salud <= puesto.saludCritica()
	method poseeHabilidad(habilidad)
		= habilidades.contains(habilidad)
	method puedeHacerMision(mision)
		= self.cumpleConLasHabilidades(mision)
	method cumpleConLasHabilidades(mision)
		= mision.habilidadesRequeridas().all({habilidad => self.puedeUsarHabilidad(habilidad)}) 
	method sobrevivio()
		= salud >= 0	
	method realizarMision(mision){
		if(!self.puedeHacerMision(mision))
		self.error(self.toString() + " no puede hacer " + mision.toString())
		self.recibirDanio(mision)
		self.obtenerRecompensasMision(mision)
	}
	method obtenerRecompensasMision(mision){
		if(self.sobrevivio()){
			puesto.cumplioMision(self,mision)
		}
	}
	method recibirDanio(mision){
		self.perderSalud(mision.peligrosidad())
	}
	method aprenderHabilidad(habilidad){
		habilidades.add(habilidad)
	}
	method ascender(puestoNuevo){puesto = puestoNuevo}
}

class Jefe inherits Empleado{
	const subordinados= #{}
	
	override method puedeUsarHabilidad(habilidad)
		= super(habilidad) or self.susSubordinadosPoseenLaHabilidad(habilidad)	
	method susSubordinadosPoseenLaHabilidad(habilidad)
		= subordinados.any({subordinado => subordinado.puedeUsarHabilidad()})
}

object espia{
	method saludCritica()= 15
	method cumplioMision(espia,mision){
		mision.habilidadesRequeridas().forEach({
			habilidad => 
			if(!espia.poseeHabilidad(habilidad)) 
			espia.aprenderHabilidad(habilidad)
		})	
	}
}

class Oficinista{
	var estrellas 
	
	method sumarEstrella(){estrellas += 1}
	method saludCritica()= 0.max(40-5*estrellas)
	method cumplioMision(oficinista,mision){
		oficinista.sumarEstrella()
		if(self.puedeAscender())
		oficinista.ascender(espia)
	}
	method puedeAscender()= estrellas >= 3
}

// EQUIPOS

class Equipo{
	const miembros= #{}
	
	method puedeHacerMision(mision)= miembros.any({miembro => miembro.cumpleConLasHabilidades(mision)}) 
	method recibirDanioDeGrupo(mision){
		const danioIndividual = mision.peligrosidad()/3
		miembros.forEach({miembro => miembro.perderSalud(danioIndividual)})
	}
	method realizarMision(mision){
		if(!self.puedeHacerMision(mision))
		self.error(self.toString()+ " no puede realizar la mision " + mision.toString())
		self.recibirDanioDeGrupo(mision)
		miembros.forEach({miembro => 
			miembro.obtenerRecompensasMision(mision)
		})
	}
}

// HABILIDAD

class Habilidad{
}

// MISIONES

class Misiones{
	const habilidadesRequeridas= #{}
	var peligrosidad
	
	method peligrosidad()= peligrosidad
	method habilidadesRequeridas()= habilidadesRequeridas
}