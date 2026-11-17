#Ejercicio 6: Abre en RStudio el script PracUni1Ses3/mantel/bin/1.IBR_testing.r. Este script realiza un análisis de aislamiento por resistencia con Fst calculadas con ddRAD en Berberis alpina.
#Lee el código del script y determina:

#  ¿qué hacen los dos for loops del script?
##RESPUESTA
#El primer loop diseña un archivo con la informacion solicitada (ej: present, miroc, flat, 1800, etc.), lo renombra y luego identifica las distancias efectivas a través de "read.effdist()" y luego calcula las distancias efectivas con "apply(eff.dist, 2, mean)" y finalmente guarda estos datos a traves de "assign()"
#El segundo loop igualmente diseña un archivo con la información solicitada, tal cual el primer loop, pero este luego realiza un test de Mentel, luego genera un grafico y obtiene el valor p del test y luego guarda los resultados como "IBRresult"

#  ¿qué paquetes necesitas para correr el script?
##RESPUESTA
##se necesitan los paquetes de ade4, ggplot2 y sp

#  ¿qué archivos necesitas para correr el script?
##RESPUESTA
#los archivos necesarios son "read.fst_summary_fix.R",  "read.effdist.R" y "DistPlot.R"
