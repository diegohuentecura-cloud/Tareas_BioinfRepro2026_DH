#Ejercicio 4: Carga en R el archivo PracUni1Ses3/maices/meta/maizteocintle_SNP50k_meta_extended.txt y ponlo en un objeto de R llamado meta_maiz.
getwd()
#a continuacion es necesario definir el working directory con este código: "setwd("C:/Users/Paris/Documents/scripts_r")" SOLO EN LA CONSOLA, NO EN ESTE SCRIPT y luego correr la siguiente linea
meta_maiz <- read.delim("maizteocintle_SNP50k_meta_extended.txt")
#esto nos mostrará las primeras lineas
head(meta_maiz)
#esto nos mostrará las últimas lineas
tail(meta_maiz)
