#Ejercicio N°9
#Cargar la base de datos de maíz

meta_maiz <- read.delim("../meta/maizteocintle_SNP50k_meta_extended.txt")
meta_maiz

#¿Qué tipo de objeto creamos al cargar la base?
class(meta_maiz)
#RESPUESTA
#Se creó un "data.frame"


#¿Cómo se ven las primeras 6 líneas del archivo?
head(meta_maiz)
#RESPUESTAs
#se ven así:
# OrderColecta NSiembra          Origen                  Raza     Estado   Num_Colecta
# 1            2        3  INIFAP-2009-16              Apachito  Chihuahua            16
# 2            1       68         2009-72              Chalque̱o   Tlaxcala            22
# 3            1       91         2007-33 Dulcillo del Noroeste     Sonora   SON2007-033
# 4            2       39    Chis-2009-18            Dzit-Bacal    Chiapas   Repetida 18
# 5            2       12 Celaya-2009-114                Celaya Guanajuato 2009-REPO-114
# 6            2       41   Celaya-2009-2   Elotes Occidentales Guanajuato 2009-REPO-002
# Nombre_comun         Raza_Primaria Raza_Secundaria A.o._de_colecta              Localidad
# 1    Ocho carreras              Apachito              NA            2009     Santo Tom\xcc\xc1s
# 2 Chalque̱o Criollo              Chalque̱o              NA            2008       Ignacio Zaragoza
# 3   Ma\xcc_z Dulce Dulcillo del Noroeste              NA            2007            Agua Blanca
# 4   Olotillo crema            Dzit-Bacal              NA            2009 Nuevo Vicente Guerrero
# 5 Ma\xcc_z Criollo                Celaya              NA            2009            El Ahuacate
# 6 Ma\xcc_z Criollo   Elotes Occidentales              NA            2009              Comonfort
# Municipio   Estado.1   Longitud  Latitud Altitud                         Ruizetal2008_grupo
# 1   Guerrero  Chihuahua -107.58300 28.68578    1975                       1A_templado540-640mm
# 2 Cuapiaxtla   Tlaxcala  -97.92944 19.29083    2497                                           
# 3      Y̩cora     Sonora -108.92467 28.53703    1435                     2A_semicalido500-870mm
# 4 Villacorzo    Chiapas  -92.97972 16.03225     618                     3A_muycalido990-1360mm
# 5  Uriangato Guanajuato -101.11889 20.09111    1877 2A_semicalido500-870mm y 1B_templado>650mm
# 6  Comonfort Guanajuato -100.76583 20.74417    1800 2C_semicalido740-855mm y 1B_templado>650mm
# Sanchezetal_grupo Categ.Altitud                 Rbiogeo            DivFloristic
# 1       Sierra de Chihuahua           mid Sierra Madre Occidental Sierra Madre Occidental
# 2                C\xcc_nico          high           Eje Volcanico  Serranias Meridionales
# 3                 Chapalote           mid Sierra Madre Occidental Sierra Madre Occidental
# 4 Maduraci\xcc_n tard\xcc_a           low      Costa del Pacifico  Serranias Transismicas
# 5       Dentados tropicales           mid           Eje Volcanico            Altiplanicie
# 6              Ocho Hileras           mid           Eje Volcanico            Altiplanicie
# PeralesBiog
# 1 Ca\xe5_ones Chi
# 2     Mesa Centra
# 3     Sierras del
# 4         Chiapas
# 5    Baj\xe5\xc1o
# 6    Baj\xe5\xc1o
#mucho bulto :c

#¿Cuántas muestras hay?
nrow(meta_maiz)
#RESPUESTA
#Se ven 165 muestras

#¿De cuántos estados se tienen muestras?
names(meta_maiz)
#la linea anterior permitió ver si existe la columna de estados
unique(meta_maiz$Estado)
#al ejecutar la linea anterior, se identificaron 19 estados
length(unique(meta_maiz$Estado))
#con la linea anterior se puede corroborar la cantidad de estados

#¿Cuántas muestras fueron colectadas antes de 1980?
meta_maiz$A.o._de_colecta < 1980
#aqui podemos identificar cuales son recolectadas antes de 1980
sum(meta_maiz$A.o._de_colecta < 1980, na.rm = TRUE)
#esto sumariza la cantidad de muestras (8 muestras)


#¿Cuántas muestras hay de cada raza?
table(meta_maiz$Raza)
#Son muchas muestras por cada raza, pero como ejemplo, los primeros son: conico: 16, oloton 4, conico norteno 3, ancho 3, elotes conicos 14
sum(table(meta_maiz$Raza))
#en total hay 165 razas

#En promedio ¿a qué altitud fueron colectadas las muestras?
mean(meta_maiz$Altitud, na.rm = TRUE)
#en promedio fueron recolectadas a aprox 1519.243

#¿Y a qué altitud máxima y mínima fueron colectadas?
max(meta_maiz$Altitud, na.rm = TRUE)
#la altitud máxima fue de 2769
min(meta_maiz$Altitud, na.rm = TRUE)
#la altitud mínima fue de 5

#Crea una nueva df de datos sólo con las muestras de la raza Olotillo
olotillo <- meta_maiz[meta_maiz$Raza == "Olotillo", ]
olotillo
#nos indica los datos que tiene el nuevo data.frame de olotillo 
nrow(olotillo)
#nos indica la cantidad de muestras que tiene 

#Crea una nueva df de datos sólo con las muestras de la raza Reventador, Jala y Ancho
submat <- meta_maiz[
  meta_maiz$Raza == "Reventador" |
    meta_maiz$Raza == "Jala" |
    meta_maiz$Raza == "Ancho",
]
#la line anterior crea el dataframe llamado submat y deja solo las muestras de jala, ancho y reventador 
table(submat$Raza)
#esto nos indica que hay 3 muestras de ancho, 4 de Jala y 2 de reventador 

#Escribe la matriz anterior a un archivo llamado "submat.cvs" en /meta.
write.csv(submat, "../meta/submat.cvs", row.names = FALSE)
#esto creó otro archivo :D
