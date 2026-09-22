#Ejercicio 7: Escribe una función llamada calc.tetha que te permita calcular tetha dados Ne y u como argumentos. Recuerda que tetha =4Neu.
calc.tetha <- function(Ne, u){
  
  tetha <- 4 * Ne * u
  
  return(tetha)
}


calc.tetha(2, 2)
calc.tetha(2, 0)
calc.tetha(-43, 12)

