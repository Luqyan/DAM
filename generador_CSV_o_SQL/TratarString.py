class TratarString:
    @staticmethod
    def quitarUnidad( frase:str): 
        frase=frase.replace("€","")
        frase=frase.replace("KG","")
        frase=frase.replace("V","")
        frase=frase.replace("g","")
        frase=frase.replace("G","")
        frase=frase.replace("LITRO","")
        return str(frase)
        
    
    @staticmethod
    def eliminarEspacios( frase:str):
        return str(frase.replace(" ", ""))


  
    @staticmethod
    def quitarUnidadesEspacios( frase:str):
        if frase==None:
            return None
        
        if frase=="":
            frase="0"
        
        resultado = TratarString.quitarUnidad(frase)
        print("Despues de quitarUnidad %s"%resultado)
        resultado=float(TratarString.eliminarEspacios(resultado))
        print(f"Despues de eliminarEspacios{resultado}")
        return resultado 
    
    
  
    @staticmethod
    def sustituirComasPorPuntos( frase:str):
        if frase==None:
            return ""
        return frase.replace(',', '.')
    
        
    @staticmethod
    def detectarSiTieneRutaHttp( frase:str):
        #frase.startsWith(RegExp("http"))
        return frase.startswith('http')
    
