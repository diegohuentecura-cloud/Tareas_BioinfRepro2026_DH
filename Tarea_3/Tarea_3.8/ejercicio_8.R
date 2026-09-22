#Ejercicio 8
#Partial Mantel test
#Posterior a la ejecución del script anterior, se deberá correr este script a continuación 
#el numero de permutations se dejó en 10.000 para que no hubiera problema con analizar el total de las muestras, ya que podría habrer sido un número más alto 
library(vegan)

# Prueba Mantel parcial - Presente
partial_present <- mantel.partial(
  as.dist(B.FstLin),
  as.dist(B.present),
  as.dist(B.flat),
  permutations = 10000
)

partial_present


# Partial Mantel para CCSM
partial_ccsm <- mantel.partial(
  as.dist(B.FstLin),
  as.dist(B.ccsm),
  as.dist(B.flat),
  permutations = 10000
)

partial_ccsm


# Partial Mantel para MIROC
partial_miroc <- mantel.partial(
  as.dist(B.FstLin),
  as.dist(B.miroc),
  as.dist(B.flat),
  permutations = 10000
)

partial_miroc
