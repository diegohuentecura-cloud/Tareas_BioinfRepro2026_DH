#Ejercicio N°1.0
#logaritmo en base 10 de 50 
logaritmo <- log10(50)
logaritmo
variable5 <-5
variable5
logaritmo + variable5

#Ejercicio N°1.1
#crea un vector que contenga los números del 1 al 200 y los números del 300 al 450.
vec1<-c(1:200,300:450)
vec1
length(vec1)

#ejecicio N°1.2
#Ejercicio utiliza una sola líndea de R para averiguar si el logaritmo base de 10 de 20 es menor que la raiz cuadrada de 4
log10(20)<sqrt(4)

#Ejercicio N°1.3
#Ejercicio: crea un vector de caracteres con tres nombres de especies
gatitos<-c("persa","siames","esfinge")
gatitos

#ejercicio N°1.4
#Ejercicio lee la ayuda de `as.factor` para determinar cómo crear un factor "ordenado"
?as.factor
nivel <- ordered(c("bajo", "medio", "alto"),
                 levels = c("bajo", "medio", "alto"))
nivel

#ejercicio N°1.5
#Ejercicio da un ejemplo de cómo convertir un vector integer a uno numérico.
ejemplo<-c(1L,2L,4L,3L)
class(ejemplo)
ejemplo<-as.numeric(ejemplo)
class(ejemplo)
ejemplo


#ejercicio N°1.6
#Ejercicio: Muestra el valor del elemento de la segunda fila, tercera columna.
y <- matrix(1:12, nrow = 4, ncol = 3)
rownames(y) <- c("A","B", "B", "C")
y
dim(y)
nrow(y)
ncol(y)
y
y[2,3]

#ejercicio N°1.7
#Ejercicio muestra las 2 primeras filas de la data.frame del ejercicio anterior
x <- data.frame(sp = c("Homo sapiens", "Homo sapiens", "Homo neanderthalensis", "Homo neanderthalensis"), sexo = c("Male", "Female", "Male", "Female"), edad = c(60,30,10,50), stringsAsFactors=FALSE)
x<- cbind(x, pop=c("Australia", "Mesoamérica", "Europa", "África"))
names(x)
x
x[1:2, ]
