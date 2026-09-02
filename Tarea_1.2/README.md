# Aquí se subirá la actividad 2
## Actividad *PIPELINES*
---
Bienvenido profesor
---
Considerando el siguiente script se responderán las siguientes preguntas:

```
#!/bin/bash 

src=$HOME/research/project 

files=”sample_01 
sample_02 
sample_03” 

#
# Align with GSnap and convert to BAM
# 
for file in $files
do
    gsnap -t 36 -n 1 -m 5 -i 2 --min-coverage=0.90 \
            -A sam -d gac_gen_broads1_e64 \
            -D ~/research/gsnap/gac_gen_broads1_e64 \
            $src/samples/${file}.fq > $src/aligned/${file}.sam
    samtools view -b -S -o $src/aligned/${file}.bam $src/aligned/${file}.sam 
    rm $src/aligned/${file}.sam 
done

#
# Run Stacks on the gsnap data; the i variable will be our ID for each sample we process.
# 
i=1 
for file in $files 
do 
    pstacks -p 36 -t bam -m 3 -i $i \
              -f $src/aligned/${file}.bam \
              -o $src/stacks/ 
    let "i+=1"; 
done 

# 
# Use a loop to create a list of files to supply to cstacks.
# 
samp="" 
for file in $files 
do 
    samp+="-s $src/stacks/$file "; 
done 

# 
# Build the catalog; the "&>>" will capture all output and append it to the Log file.
# 
cstacks -g -p 36 -b 1 -n 1 -o $src/stacks $samp &>> $src/stacks/Log 

for file in $files 
do 
    sstacks -g -p 36 -b 1 -c $src/stacks/batch_1 \
             -s $src/stacks/${file} \ 
             -o $src/stacks/ &>> $src/stacks/Log 
done 

#
# Calculate population statistics and export several output files.
# 
populations -t 36 -b 1 -P $src/stacks/ -M $src/popmap \
              -p 9 -f p_value -k -r 0.75 -s --structure --phylip --genepop

```
### 1.- ¿Cuántos pasos tiene este script?
Este script tiene 7 pasos:
- 1 se seleccionan las muestras
- 2 se alinean las muestras genómicas con `gsnap` para convertirlo a BAM
- 3 se corre el programa `stacks` para identificar las muestras con ayuda de `pstacks` 
- 4 se usa un loop para crear una lista de archivos para usarlo con `cstacks`
- 5 se construye el catálogo utilizando `cstacks`
- 6 Se ejecuta `sstacks` para cada muestra
- 7 se calcula la población estadística

### 2.- Si quisieras correr este script y que funcionara en tu propio equipo, ¿Qué línea deberías cambiar y a qué?
Para poder correr este script en mi computadora, en vez de utilizar `$HOME` se deberá cambiar por mi ubicación personal, es decir `/home/Diego/research/project` 

### 3.- ¿A qué equivale `$HOME`?
`$HOME` correspondería a mi directorio raíz, en mi caso se podría traducir como: `/home/Diego`, si se quisiera aplicar en mi caso personal, quedaría de la siguiente manera `/home/Diego/research/project` y en esta ubicación se ejecutaría el programa.

### 4.- ¿Qué paso del análisis realiza el programa `gsnap`?
El programa `gsnap` estará alineando las muestras genómicas, los comandos que siguen a gsnap corresponden a las especificaciones que solicita el usuario que correrá el programa. 

### 5.- ¿Qué hace, en términos generales, cada uno de los loops?
Cada uno de los loops hace lo siguiente
- El loop #1
```
for file in $files
do
    gsnap -t 36 -n 1 -m 5 -i 2 --min-coverage=0.90 \
            -A sam -d gac_gen_broads1_e64 \
            -D ~/research/gsnap/gac_gen_broads1_e64 \
            $src/samples/${file}.fq > $src/aligned/${file}.sam
    samtools view -b -S -o $src/aligned/${file}.bam $src/aligned/${file}.sam 
    rm $src/aligned/${file}.sam 
done
```

Alinea a través de `gsnap` las muestras y los convierte a formato BAM y al final elimina el archivo SAM (rm)
- El loop #2
```
for file in $files 
do 
    pstacks -p 36 -t bam -m 3 -i $i \
              -f $src/aligned/${file}.bam \
              -o $src/stacks/ 
    let "i+=1"; 
done
```
a través de `pstacks`  procesa el archivo BAM y permite identificar los archivos con el código `"i+=1"`
- El loop #3
```
for file in $files 
do 
    samp+="-s $src/stacks/$file "; 
done
```
nos entrega una lista con todas las muestras
- El loop #4
```
for file in $files 
do 
    sstacks -g -p 36 -b 1 -c $src/stacks/batch_1 \
             -s $src/stacks/${file} \ 
             -o $src/stacks/ &>> $src/stacks/Log 
done
```
ejecuta `sstacks` para cada muestra 
