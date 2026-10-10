# Informe de ejercicios con VCFtools y PLINK

## Ejercicio 1.¿Cuántos individuos y variantes (SNPs) tiene el archivo?

SE usó VCFtools para revisar el archivo VCF original, sin tener que copiarlo a la carpeta de trabajo.


```
vcftools --vcf /datos/compartido/ChileGenomico/GATK_ChGdb_recalibrated.autosomes.12262013.snps.known.vcf
```
Se obtuvo lo siguiente: 

```
After filtering, kept 18 out of 18 Individuals
After filtering, kept 4450360 out of a possible 4450360 Sites
Run Time = 27.00 seconds
```

Con esto se pudo ver que el archivo contiene **18 individuos y 4.450.360 sitios**, sin aplicar filtros adicionales.

## Ejercicio 2. ¿Cuántos sitios del archivo no tienen datos perdidos?

Se usó `--max-missing 1` para ver cuántos sitios tenían datos disponibles en todas las personas.


```
vcftools --vcf /datos/compartido/ChileGenomico/GATK_ChGdb_recalibrated.autosomes.12262013.snps.known.vcf --max-missing 1
```

se obtuvo lo siguiente:

```
After filtering, kept 18 out of 18 Individuals
After filtering, kept 382626 out of a possible 4450360 Sites
```

Se obtuvieron **382.626 sitios sin datos faltantes**, manteniendo los 18 individuos del archivo.

## Ejercicio 3. Genera un archivo en tu carpeta de trabajo `Sesion2/VCF/data` que contenga solo SNPs en una ventana de 2Mb en cualquier cromosoma. Nombra el archivo`CLG_Chr<X>_<Start>-<End>Mb.vcf` donde <X> es número del cromosoma, <Start> es el inicio de la ventana genómica y <End> es el final en megabases.

Para este ejercicio se seleccionó una región de **2 Mb del cromosoma 1**, desde la posición 1.000.000 hasta la 3.000.000.

```
vcftools --vcf /datos/compartido/ChileGenomico/GATK_ChGdb_recalibrated.autosomes.12262013.snps.known.vcf --chr 1 --from-bp 1000000 --to-bp 3000000 --recode --out CLG_Chr1_1-3Mb
```

Con este comando se generó un archivo VCF con las variantes presentes en la región seleccionada.

## Ejercicio 4. Reporta cuántas variantes tienen el archivo generado

Después de seleccionar la región del cromosoma 1, se revisó el resultado que mostró VCFtools.

```
After filtering, kept 2378 out of a possible 4450360 Sites
```

Con esto se comprobó que quedaron **2.378 variantes**.

## Ejercicio 5. Reporta la cobertura promedio para todos los individuos del set de datos

Para revisar la profundidad promedio de las lecturas por individuo se utilizó la opción `--depth` de VCFtools.

```
vcftools --vcf CLG_Chr1_1-3Mb.vcf --depth
```

Este comando permite obtener la profundidad media por individuo. En los resultados compartidos no se incluyeron los valores de cobertura, por lo que aquí se deja registrado el procedimiento utilizado.

## Ejercicio 6. Calcula la frecuencia de cada alelo para todos los individuos dentro del archivo y guarda el resultado en un archivo

En este ejercicio se utilizó `--freq` para calcular la frecuencia de los alelos de las variantes que quedaron en la región del cromosoma 1.

```
vcftools --vcf CLG_Chr1_1-3Mb.vcf --freq
head out.frq
```

VCFtools indicó que trabajó con los **18 individuos y 2.378 sitios**.

```
After filtering, kept 18 out of 18 Individuals
Outputting Frequency Statistics...
After filtering, kept 2378 out of a possible 2378 Sites
```

Los resultados se guardaron en `out.frq`. Al revisar las primeras líneas, se obtuvo lo siguiente:

```
CHROM  POS      N_ALLELES  N_CHR  {ALLELE:FREQ}
1      1000156  2          6      C:0         T:1
1      1001177  2          20     G:0         C:1
1      1002434  2          22     C:0.272727  T:0.727273
1      1002539  2          30     G:0.933333  A:0.0666667
1      1002932  2          12     C:0         G:1
1      1003053  2          10     C:0         T:1
1      1003629  2          28     C:0         T:1
1      1006223  2          18     G:0.166667  A:0.833333
1      1006990  2          18     G:0         A:1
```

Las columnas muestran el cromosoma (`CHROM`), la posición (`POS`), la cantidad de alelos (`N_ALLELES`), los cromosomas considerados en el cálculo (`N_CHR`) y la frecuencia de cada alelo (`ALLELE:FREQ`).

Ej: En la posición **1002434**, el alelo C tiene una frecuencia de **0,272727** y el alelo T de **0,727273**.

## Ejercicio 7. Filtra el archivo de frecuencias para solo incluir variantes bialélicas (tip: awk puede ser útil para realizar esta tarea, tip2:  puedes usar bcftools para filtrar variantes con más de dos alelos antes de calcular las frecuencias)

Para este ejercicio se utilizó `awk` para dejar solamente las variantes que tenían dos alelos, según la columna `N_ALLELES` del archivo de frecuencias.

```
awk 'NR==1 || $3==2' out.frq > out_biallelic.frq
head out_biallelic.frq
```

En este comando, `NR==1` permite conservar el encabezado y `$3==2` deja solamente las filas donde `N_ALLELES` es igual a 2.

Esto se obtuvo como resultado: 

```
CHROM  POS      N_ALLELES  N_CHR  {ALLELE:FREQ}
1      1000156  2          6      C:0         T:1
1      1001177  2          20     G:0         C:1
1      1002434  2          22     C:0.272727  T:0.727273
1      1002539  2          30     G:0.933333  A:0.0666667
1      1002932  2          12     C:0         G:1
1      1003053  2          10     C:0         T:1
1      1003629  2          28     C:0         T:1
1      1006223  2          18     G:0.166667  A:0.833333
1      1006990  2          18     G:0         A:1
```

Después se utilizó este codigo para revisar nuevamente la tercera columna:

```
awk 'NR>1 {print $3}' out_biallelic.frq | head
```

El resultado mostró valores `2`, por lo que las primeras filas revisadas correspondían a variantes bialélicas.

## Ejercicio 8. Llama a un script escrito en lenguaje R que lee el archivo de frecuencias de variantes bialélicas y guarda un histograma con el espectro de MAF para las variantes bialélicas

Para este ejercicio se utilizó R para leer las frecuencias de los alelos, calcular la frecuencia del alelo menor (MAF) y generar un histograma.

```
Con esto se lee el archivo de frecuencias bialelicas

datos <- read.table("out_biallelic.frq",
                header = FALSE,
                    skip = 1,
                    stringsAsFactors = FALSE)               

Se le dan nombres a las columnas;

colnames(datos) <- c("CHROM", "POS", "N_ALLELES", "N_CHR",
                     "ALELO1", "ALELO2")

Se obtienen las frecuencias de los alelos

freq1 <- as.numeric(sub(".*:", "", datos$ALELO1))
freq2 <- as.numeric(sub(".*:", "", datos$ALELO2))

Con esto se calcula la frecuencia del alelo menor

MAF <- pmin(freq1, freq2)

Se crea y guarda el histograma

png("histograma_MAF2.png")

hist(MAF,
     main = "Espectro de frecuencia del alelo menor",
     xlab = "Frecuencia del alelo menor",
     ylab = "Frecuencia")

dev.off()
```

Con esto se generó el archivo `histograma_MAF2.png`. Según el resultado descrito en la actividad, el histograma muestra valores de MAF entre **0 y 0,5**, con una mayor cantidad de variantes de frecuencia baja y otras distribuidas en el resto del rango.

## Ejercicio 9. ¿Cuántos sitios tienen una frecuencia del alelo menor <0.05?

Utilizando los valores de MAF del ejercicio anterior, se buscó cuáles eran menores a **0,05**.
Primero se revisó qué valores cumplían esa condición:

```
MAF < 0.05
```

Se contaron utilizando:

```
sum(MAF < 0.05)
```

El resultado obtenido fue de **315 sitios con MAF menor a 0,05** dentro del conjunto analizado en R.

## Ejercicio 10. Calcula la heterocigosidad de cada individuo

Para este ejercicio se utilizó `--het` de VCFtools para revisar los datos de heterocigosidad de los individuos.

```
vcftools --vcf CLG_Chr1_1-3Mb.vcf --het
cat out.het
```

El programa generó el archivo `out.het`, con los siguientes resultados:

| Individuo | O(HOM) | E(HOM) | N_SITES | F |
|---|---:|---:|---:|---:|
| ARI-008 | 1303 | 973.9 | 1548 | 0.57324 |
| ARI-014 | 1271 | 910.7 | 1428 | 0.69653 |
| ARI-1 | 1400 | 1000.8 | 1591 | 0.67636 |
| ARI-15 | 1250 | 1010.2 | 1606 | 0.40246 |
| ARI-9 | 1386 | 1058.8 | 1684 | 0.52338 |
| ARI_018 | 1312 | 987.6 | 1562 | 0.56477 |
| Ari_006 | 1379 | 1012.7 | 1610 | 0.61325 |
| Ari_021 | 1268 | 886.7 | 1412 | 0.72586 |
| Ari_023 | 1363 | 978.5 | 1553 | 0.66927 |
| CD5J-106 | 1012 | 751.0 | 1174 | 0.61701 |
| CD5J-108 | 786 | 503.5 | 793 | 0.97582 |
| CD5J-471 | 591 | 391.7 | 613 | 0.90057 |
| CDSJ_167 | 1424 | 1050.0 | 1672 | 0.60126 |
| CDSJ_297 | 1564 | 1207.0 | 1922 | 0.49927 |
| Cdsj_283 | 1254 | 878.1 | 1393 | 0.73003 |
| L19_CDSJ_321 | 1416 | 966.8 | 1542 | 0.78095 |
| L20_CDSJ_344 | 1360 | 961.0 | 1529 | 0.70244 |
| L21_CDSJ_472 | 1218 | 894.2 | 1421 | 0.61469 |

La tabla permite revisar, para cada individuo, los homocigotos observados (`O(HOM)`), los esperados (`E(HOM)`), la cantidad de sitios utilizados (`N_SITES`) y el coeficiente F.

## Ejercicio 11. Calcula la diversidad nucleotídica por sitio

Para revisar la diversidad nucleotídica de cada sitio se utilizó `--site-pi` de VCFtools.

```
vcftools --vcf CLG_Chr1_1-3Mb.vcf --site-pi
head out.sites.pi
```

El archivo generado fue `out.sites.pi`. Al revisar las primeras líneas se obtuvo:

```
CHROM  POS      PI
1      1000156  0
1      1001177  0
1      1002434  0.415584
1      1002539  0.128736
1      1002932  0
1      1003053  0
1      1003629  0
1      1006223  0.294118
1      1006990  0
```

Se observaron sitios con **PI igual a 0** y otros con valores mayores. Por ejemplo, la posición **1002434** presentó un PI de **0,415584**.

## Ejercicio 12. Filtra los sitios que tengan una frecuencia del alelo menor <0.05

En este ejercicio se utilizó `--max-maf 0.05` para conservar los sitios que cumplían el filtro de frecuencia del alelo menor.

```
vcftools --vcf CLG_Chr1_1-3Mb.vcf --max-maf 0.05 --recode --out CLG_Chr1_1-3Mb_maxMAF05
```
Se obtuvo lo siguiente

```
After filtering, kept 18 out of 18 Individuals
Outputting VCF file...
After filtering, kept 330 out of a possible 2378 Sites
```

Con este filtro se conservaron **330 de los 2.378 sitios** y se mantuvieron los 18 individuos.

Este resultado no es igual al del ejercicio 9: allí se contó `MAF < 0.05` en los datos trabajados en R, mientras que aquí se aplicó `--max-maf 0.05` en VCFtools. Se dejan los dos resultados tal como se obtuvieron, sin asumir que representan exactamente el mismo conjunto de sitios.

## Ejercicio 13. Convierte el archivo `GATK_ChGdb_recalibrated.autosomes.12262013.snps.known.vcf` a formato plink. 

Para este ejercicio se convirtió el archivo VCF original a formato binario de PLINK, para poder utilizarlo en otros análisis genéticos.

Primero se guardó la ruta del archivo en una variable llamada `VCF`:

```
VCF=/datos/compartido/ChileGenomico/GATK_ChGdb_recalibrated.autosomes.12262013.snps.known.vcf
```

Después se ejecutó PLINK con el siguiente comando:

```
plink --vcf "$VCF" --make-bed --out GATK_ChGdb_plink --double-id
```

Se utilizó `--double-id` para trabajar con los identificadores de las muestras que tenían guiones bajos (`_`).

Se generó lo siguiente:

- `GATK_ChGdb_plink.bed`
- `GATK_ChGdb_plink.bim`
- `GATK_ChGdb_plink.fam`
- `GATK_ChGdb_plink.log`
- `GATK_ChGdb_plink.nosex`

PLINK confirmó que terminó la conversión con el mensaje `done`.

## Conclusión  

Con estos ejercicios pude trabajar con un archivo VCF y aprender a revisar la información de las muestras utilizando VCFtools, R y PLINK. Primero se comprobó que el archivo original tenía **18 individuos y 4.450.360 sitios**. Después se aplicaron filtros para revisar los datos faltantes y trabajar con una región de **2 Mb del cromosoma 1**, donde quedaron **2.378 variantes**.

También se calcularon las frecuencias de los alelos, se revisaron las variantes bialélicas y se generó un histograma para ver cómo se distribuían los valores de MAF. Además, se trabajó con los resultados de heterocigosidad y diversidad nucleotídica, y se aplicó un filtro de MAF con el que se conservaron **330 sitios**.

Por último, se convirtió el archivo VCF original a formato PLINK. En general, estas actividades me ayudaron a practicar los comandos y a entender mejor cómo revisar, filtrar y preparar los datos genéticos para otros análisis.
