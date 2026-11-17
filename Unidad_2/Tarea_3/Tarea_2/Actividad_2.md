# actv 2
## Ejercicio 1: Enlista los archivos plink que hay en `data`.  ¿Qué tipos de archivos son cada uno?

Primero se usó el siguiente comando para ver qué archivos estaban disponibles:

```
ls -lh /datos/compartido/ChileGenomico/chilean_all48_hg19*
```

Se encontraron cuatro archivos:

```
chilean_all48_hg19.bed
chilean_all48_hg19.bim
chilean_all48_hg19.fam
chilean_all48_hg19_popinfo.csv
```

Los archivos `.bed`, `.bim` y `.fam` corresponden al formato binario de PLINK. El archivo `.csv` contiene información adicional de las muestras.

## Ejercicio 2.a. Transforma de formato bed a formato ped. El nombre del output debe ser igual, solo cambiando la extensión.

En esta parte se usó PLINK para convertir los archivos binarios al formato de texto PED/MAP, manteniendo el nombre original.

```
plink --bfile ../../../Sesion2/code/chilean_all48_hg19 --recode --out chilean_all48_hg19
```

La conversión se realizó correctamente con PLINK v1.90b7.2. Se trabajó con **813.366 variantes y 48 individuos**, de los cuales 27 son hombres y 21 mujeres. La tasa de genotipificación fue de 98,9751 %.

Se generaron los siguientes archivos:

- `chilean_all48_hg19.ped` (149 MB)
- `chilean_all48_hg19.map` (19 MB)
- `chilean_all48_hg19.log` (1,2 KB)
- `chilean_all48_hg19.hh` (301 KB)

Durante el proceso también aparecieron advertencias por **11.824 genotipos heterocigotos en regiones haploides** y por genotipos del cromosoma Y en personas que no estaban registradas como hombres.

## Ejercicio 2.b. Crea otro archivo ped (ojo PPPPed) pero esta vez filtrando los SNPs cuya frecuencia del alelo menor sea menor a 0.05 Y filtrando los individuos con más de 10% missing data. Tu output debe llamarse `chilean_all48_hg19_maf05_missing10` ¿Cuántos SNPs y cuántos individuos fueron removidos por los filtros?


Para este ejercicio se aplicaron dos filtros: uno para filtrar las variantes con frecuencia del alelo menor inferior a 0,05 y otro para quitar a las personas con más del 10 % de genotipos faltantes.

```
plink --bfile ../../../Sesion2/code/chilean_all48_hg19 --recode --maf 0.05 --mind 0.1 --out chilean_all48_hg19_maf05_missing10
```

Al inicio habían **813.366 variantes y 48 individuos**. Con `--mind 0.1` se eliminaron 2 personas por tener demasiados datos faltantes. Luego, con `--maf 0.05`, se eliminaron 347.070 variantes.

Después de aplicar los filtros quedaron **466.296 variantes y 46 individuos**, con una tasa de genotipificación de 99,4669 %.

Los principales archivos que se generaron fueron:

- `chilean_all48_hg19_maf05_missing10.ped` (82 MB)
- `chilean_all48_hg19_maf05_missing10.map` (11 MB)
- `chilean_all48_hg19_maf05_missing10.log` (1,5 KB)

También aparecieron los archivos `.irem`, donde quedaron registrados los individuos excluidos, y `.hh`, relacionado con las advertencias de genotipos heterocigotos en regiones haploides.

## Ejercicio 2.c. reporte de equilibrio de Hardy-Weinberg sobre el archivo `chilean_all48_hg19_maf05_missing10` creado en el ejercicio anterior. El nombre del archivo de tu output debe contener chilean_all48_hg19_maf05_missing10

En esta parte se usaron los archivos PED/MAP que quedaron después del filtrado para revisar el equilibrio de Hardy-Weinberg.

```
plink --file chilean_all48_hg19_maf05_missing10 --hardy --out chilean_all48_hg19_maf05_missing10
```

Para ver las primeras filas del resultado se utilizó:

```
head chilean_all48_hg19_maf05_missing10.hwe
```

Se analizaron **466.296 variantes y 46 individuos** (26 hombres y 20 mujeres). PLINK generó el archivo `chilean_all48_hg19_maf05_missing10.hwe`, de aproximadamente 141 MB.

El archivo contiene las siguientes columnas:

| Columna | Qué indica |
|---|---|
| `CHR` | Cromosoma donde está la variante. |
| `SNP` | Nombre o identificador de la variante. |
| `TEST` | Grupo analizado: `ALL`, `AFF` o `UNAFF`. |
| `A1` y `A2` | Alelos de la variante. |
| `GENO` | Cantidad de individuos con cada genotipo. |
| `O(HET)` | Frecuencia observada de heterocigotos. |
| `E(HET)` | Frecuencia esperada de heterocigotos. |
| `P` | Valor p de la prueba de Hardy-Weinberg. |

Al revisar las primeras filas, en la primera aparición de `rs9701055` la frecuencia observada de heterocigotos fue **0** y la esperada fue **0,4764**. Su valor p fue **5,994 × 10⁻¹⁴**, por lo que en esa fila se observa una diferencia estadísticamente significativa respecto del equilibrio de Hardy-Weinberg.

En otras filas de `rs9701055` y `rs2073813` aparecieron valores p de **0,3137** y **0,3197**, respectivamente. Como son mayores a 0,05, esas filas no muestran una desviación estadísticamente significativa.

También se observó que `rs9701055` aparece más de una vez con distintos resultados, por lo que sería necesario revisar los identificadores de las variantes. En las filas del grupo `AFF` aparecieron valores `nan`, ya que no había individuos registrados como casos.

## Ejercicio 2.d. Observa el archivo `chilean_all48_hg19.fam`. Consulta la documentación de plink para determinar que es cada columna. ¿Qué información hay y no hay en este archivo?

Para ver la información del archivo FAM se utilizó:

```
head ../../../Sesion2/code/chilean_all48_hg19.fam
```

Este archivo tiene seis columnas:

| Columna | Qué contiene |
|---|---|
| `FID` | Identificador familiar. |
| `IID` | Identificador de cada persona. |
| `PAT` | Identificador del padre. |
| `MAT` | Identificador de la madre. |
| `SEX` | Sexo: `1` hombre, `2` mujer y `0` desconocido. |
| `PHENOTYPE` | Fenotipo: `1` control, `2` caso y `0` o `-9` dato faltante en fenotipos de tipo caso-control. |


En las primeras diez filas se encontraron **8 hombres y 2 mujeres**. También se pudo ver que el `FID` y el `IID` eran iguales para cada persona. En las columnas de los padres aparecía `0` y todos tenían el fenotipo registrado como `1`.

Con este archivo podemos ver la identificación de las personas, el sexo y el fenotipo. En las filas revisadas no se encontró información de los padres. Tampoco aparecen datos como la edad, la región o la ancestría, ya que eso se encuentra en otros archivos.

## Ejercicio 4. Utiliza la info el archivo `data/chilean_all48_hg19_popinfo.csv` y el comando `update-ids` de plink para cambiar los nombres de las muestras de `data/chilean_all48_hg19.fam` de tal forma que el family ID corresponda a la info de la columna `Ancestry` en `chilean_all48_hg19_popinfo.csv`. Pista: este ejercicio requiere varias operaciones, puedes dividirlas en diferentes scripts de bash o de R y bash.

Para este ejercicio se usó R para relacionar el archivo `chilean_all48_hg19.fam` con `chilean_all48_hg19_popinfo.csv`.

Primero se revisaron los identificadores de ambos archivos. Al comienzo aparecieron duplicados cuando se quitaron los guiones, porque algunos códigos del CSV existían con y sin guion e incluso podían tener distintas ancestrías. Por eso, finalmente se compararon **los identificadores tal como aparecían en los archivos**, sin quitar los guiones.

Después se usó la columna `Ancestry` para obtener la ancestría de cada persona. Con esos datos se creó un archivo de texto con el `FID` y el `IID` originales, el nuevo `FID` y el `IID` sin cambios.

Luego se creó un script de Bash para ejecutar el comando `--update-ids` de PLINK. El programa mostró:

```
--update-ids: 48 people updated.
```

Con esto se generaron nuevos archivos `.bed`, `.bim` y `.fam`. Finalmente, se usó `head` para comprobar que la primera columna del nuevo FAM tenía valores como `Mapuche` o `Aymara`, mientras que los identificadores individuales seguían iguales.

## Ejercicio 5. Realiza un una comparación entre el sexo y archivo `fam`y el `popinfo` y calcula la proporción de discordancias

En este ejercicio se utilizó R para comparar el sexo registrado en `chilean_all48_hg19.fam` con el de `chilean_all48_hg19_popinfo.csv`.

Primero se cargaron los archivos y se relacionaron las personas mediante sus identificadores. Después se cambió la codificación del sexo del FAM para que se pudiera comparar con el CSV: se usó `M` para hombres y `F` para mujeres.

| Resultado | Cantidad |
|---|---:|
| Personas comparadas | 48 |
| Mujeres | 21 |
| Hombres | 27 |
| Discordancias | 0 |
| Proporción de discordancias | 0 |
| Porcentaje de discordancias | 0 % |

## Ejercicio 6. Realiza un test de estimación de sexo usando plink y reporta los resultados en formato de tabla para todos los individuos con discordancia entre el sexto reportado en `fam` y el calculado con plink.

En esta parte se utilizó PLINK con el comando `--check-sex` para estimar el sexo a partir de los datos genéticos y compararlo con el sexo registrado en el archivo FAM.

Después se usó `awk` para buscar las personas donde el sexo registrado fuera distinto del estimado por PLINK.


De los 48 individuos, **47 tuvieron resultados concordantes y 1 presentó una discordancia**:

| Individuo | Sexo en FAM | Sexo estimado por PLINK | Estado | Coeficiente F |
|---|---|---|---|---:|
| `ARI022` | Mujer | Hombre | `PROBLEM` | 0,9998 |

También se revisó si PLINK había dejado alguna persona con sexo indeterminado (`SNPSEX = 0`), pero no se encontraron casos.

## Ejercicio 7. Genera una tabla de contingencia de individuos por sexo y ancestría (hint: ver columna Ancestry en el archivo `popinfo`)

Para este ejercicio se utilizó R para ver cuántas personas había de cada sexo según su ancestría. Se trabajó con los archivos `chilean_all48_hg19.fam` y `chilean_all48_hg19_popinfo.csv`.

Primero se cargaron los archivos y se relacionaron los identificadores para trabajar con las mismas 48 personas. Después se utilizaron las columnas `Sex` y `Ancestry` del CSV para crear la tabla mediante `table()`. También se usó `addmargins()` para agregar los totales.


| Sexo | Aymara | Mapuche | No | Total |
|---|---:|---:|---:|---:|
| Mujer (F) | 8 | 11 | 2 | 21 |
| Hombre (M) | 9 | 16 | 2 | 27 |
| **Total** | **17** | **27** | **4** | **48** |

Se compararon **48 personas: 21 mujeres y 27 hombres**. La categoría que más apareció fue `Mapuche`, con 27 personas, seguida de `Aymara`, con 17. También hubo 4 personas con el valor `No` en la columna `Ancestry`; se dejó ese nombre tal como aparece en los datos.

## Conclusión 

Con estos ejercicios pude trabajar con los archivos de PLINK y conocer mejor la información de las muestras. Primero se revisaron los archivos y se convirtieron los datos al formato PED/MAP. Después se aplicaron filtros, con los que se pasó de 813.366 variantes y 48 individuos a 466.296 variantes y 46 individuos, y se revisaron algunos resultados del equilibrio de Hardy-Weinberg.

También se utilizó R junto con PLINK para relacionar los datos del archivo FAM con el CSV y actualizar los identificadores familiares de las 48 personas según su ancestría. Al comparar el sexo registrado en ambos archivos no se encontraron diferencias. Sin embargo, al estimar el sexo con PLINK apareció una diferencia en la muestra `ARI022`.

Por último, se creó una tabla de contingencia para ver la distribución de las 48 personas según el sexo y la ancestría. En general, estos ejercicios me permitieron practicar el uso de comandos de Bash, R y PLINK, además de aprender a revisar los resultados y detectar posibles diferencias en los datos.
