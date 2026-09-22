#Ejercicio 5:

#Ejercicio 5.1: Escribe un for loop para que divida 35 entre 1:10 e imprima el resultado en la consola.
for (i in 1:10) {
  resultado <- 35 / i
  print(resultado)
}

#Ejercicio 5.2: Modifica el loop anterior para que haga las divisiones solo para los números nones (con un comando, NO con c(1,3,...)). Pista: next.
for (i in 1:5){
  print(35 / (2*i - 1))
}

#Ejercicio 5.3: Modifica el loop anterior para que los resultados de correr todo el loop se guarden en una df de dos columnas, la primera debe tener el texto "resultado para x" (donde x es cada uno de los elementos del loop) y la segunda el resultado correspondiente a cada elemento del loop. Pista: el primer paso es crear un vector fuera del loop
resultados <- data.frame()

for (i in (1:5) * 2 - 1){
  resultados <- rbind(resultados,
                      data.frame(
                        texto = paste("El resultado de dividir 35 en", i),
                        resultados = 35 / i
                      ))
}

resultados

