#Ejercicio 3: ¿cuántos números son mayores a 20 en el vector -13432:234?
rango<- -13432:234
#la siguiente linea nos muestra todos los números mayores a 20
rango [rango>20]
#Esta linea nos indica la cantidad de números que existe en este rango
length(rango)
#esta linea nos indicará la cantidad de números mayores a 20
length(rango [rango>20])

#otra forma de hacerlo mucho mas simplificada
sum((-13432:234)>20)

