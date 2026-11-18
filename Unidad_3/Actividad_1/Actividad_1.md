## 3 Tarea
---
### Sección N°1: Realizar el alineamiento contra el genoma humano hg19 de las lecturas R1 y R2 del paciente seleccionado para la tarea de control de calidad de lecturas de secuencia.
---

- Durante la elaboración del ejercicio, se consideró la misma muestra utilizada en ejercicios anteriores utilizando los archivos FASTQ originales de la muestra S3 y el genoma humano de referencia hg19 disponible en el servidor.
- Se verificó la disponibilidad de los archivos S3_R1.fastq.gz, S3_R2.fastq.gz y hg19.fasta
- Se utilizó BBDuk, siguiendo las observaciones originales del tutorial. El archivo adapters.fa contiene secuencias de adaptadores conocidas y se emplearon las opciones tpe y tbo indicadas en el protocolo para las lecturas pareadas.

```
module load BBMap

bbduk.sh -Xmx2g threads=1 \
in1=~/181004_curso_calidad_datos_NGS/fastq_raw/S3_R1.fastq.gz \
in2=~/181004_curso_calidad_datos_NGS/fastq_raw/S3_R2.fastq.gz \
out1=S3_R1_filter1.fastq.gz \
out2=S3_R2_filter1.fastq.gz \
ref=~/resources/bbmap/adapters.fa tpe tbo
```
En este proceso se obtuvieron los archivos `S3_R1_filter1.fastq.gz` y `S3_R2_filter1.fastq.gz`.


Las lecturas obtenidas en el paso anterior se filtraron con a la secuencia de referencia del bacteriófago PhiX, utilizado como control en la secuenciación, para descartar las lecturas que presentaran coincidencias detectables con esta secuencia y se generaron los archivos `S3_R1_filter2.fastq.gz` y `S3_R2_filter2.fastq.gz`.

```
bbduk.sh -Xmx2g threads=1 \
in1=S3_R1_filter1.fastq.gz \
in2=S3_R2_filter1.fastq.gz \
out1=S3_R1_filter2.fastq.gz \
out2=S3_R2_filter2.fastq.gz \
ref=~/resources/bbmap/phix174_ill.ref.fa.gz
```
- Se realizó el recorte y filtrado por calidad empleando una ventana deslizante (`qtrim=w`), un umbral de calidad Phred de 20 (`trimq=20`), una longitud mínima de 30 pb (`minlength=30`) y una calidad promedio mínima de 20 (`minavgquality=20`).

```
bbduk.sh -Xmx2g threads=1 \
in1=S3_R1_filter2.fastq.gz \
in2=S3_R2_filter2.fastq.gz \
out1=S3_R1_filter3.fastq.gz \
out2=S3_R2_filter3.fastq.gz \
qtrim=w trimq=20 minlength=30 minavgquality=20
```

- Luego se obtuvo el código de salida `0` al aplicar el comando `echo $?` y se obtuvieron los archivos `S3_R1_filter3.fastq.gz` y `S3_R2_filter3.fastq.gz`.

- Las lecturas filtradas de la muestra S3 se alinearon contra el genoma humano hg19 con BWA-MEM. Se utilizaron cuatro hilos de procesamiento (`-t 4`) y la opción `-M`, que marca los alineamientos divididos más cortos como secundarios y facilita la compatibilidad con Picard

```
module load bwa

bwa mem -t 4 -M /datos/reference/genomes/hg19_reference/hg19.fasta \
S3_R1_filter3.fastq.gz \
S3_R2_filter3.fastq.gz \
> S3.sam
```

- Se verificó la finalización del alineamiento mediante:

```
echo $?
```

### Sección N°2: Utilizando una línea de comando, encuentre la primera lectura en el archivo SAM que contenga bases enmascaradas (secuencias suavizadas por soft-clipping)
---------

Para identificar el primer registro que presenta esta operación, se utilizó la siguiente línea de comando:

```
awk '!/^@/ && $6 ~ /S/ {print; exit}' S3.sam
```

Esta se explica a contunuación

| Elemento | Función |
| --- | --- |
| `awk` | Procesa el archivo por campos. |
| `!/^@/` | Excluye las líneas del encabezado del SAM. |
| `&&` | Exige el cumplimiento de ambas condiciones. |
| `$6 ~ /S/` | Busca la operación `S` en la sexta columna (CIGAR). |
| `print` | Muestra el registro completo. |
| `exit` | Detiene la búsqueda tras la primera coincidencia. |


### Sección N°3: Muestre el registros de la lecturas en el archivo SAM e identifique y explique el código CIGAR de esa lectura.
---
```
awk '!/^@/ && $6 ~ /S/ {print; exit}' S3.sam
M03564:2:000000000-D29D3:1:1101:15201:1724      83      chr2   198257295        60      2S100M  =       198257146       -249   GGGGGGGGGGGGGAACCTACTAATTACACTGCTCTTAAGCTGCAATGGAAGAGACAAAACTCACTCCCCTGTCACCACACAATTGTTCTACCATATGGCACA   GGGFE>/GGHHHFHHHHHHHHHHHHGHHHHHHHHHHHGHHHHHHHHHHHHHHGHHHHHHHHHGGGGGGHHHHGHGHHHHHGGGGGGGGGGFFFFFFFCCCCC  NM:i:0  MD:Z:100        MC:Z:154M2I88M  AS:i:100XS:i:20
```

Interpretación de los principales campos del registro SAM identificado.

| Campo | Valor | Interpretación |
| --- | --- | --- |
| QNAME | `M03564:2:000000000-D29D3:1:1101:15201:1724` | Identificador de la lectura. |
| FLAG | `83` | Primera lectura de un par marcado como correctamente alineado; esta lectura se alinea en la hebra inversa. |
| RNAME | `chr2` | Cromosoma 2. |
| POS | `198257295` | Primera posición del alineamiento en la referencia. |
| MAPQ | `60` | Alta calidad de mapeo según BWA. |
| CIGAR | `2S100M` | Dos bases con soft-clipping y 100 bases alineadas. |
| RNEXT | `=` | La lectura pareja se encuentra en el mismo cromosoma. |
| PNEXT | `198257146` | Posición de alineamiento de la lectura pareja. |
| TLEN | `-249` | Longitud del fragmento de 249 pb, con signo negativo por su posición relativa. |
| SEQ | 102 nucleótidos | Secuencia de la lectura almacenada en SAM. |
| QUAL | 102 caracteres | Calidades de las bases codificadas en SAM. |
| NM | `0` | Distancia de edición cero en la región alineada. |
| MD | `100` | Las 100 bases alineadas coinciden con la referencia. |


Interpretación del CIGAR `2S100M`

| Operación | Número de bases | Interpretación |
| --- | ---: | --- |
| `2S` | 2 | Bases no alineadas al inicio de la secuencia tal como se representa en el SAM; se conservan en el campo `SEQ`. |
| `100M` | 100 | Bases alineadas contra hg19. La operación `M` puede representar coincidencias o diferencias, pero en este caso las etiquetas `NM:i:0` y `MD:Z:100` indican que todas coinciden con la referencia. |
| **Total** | **102** | **Longitud de la lectura.** |


### Sección N°4: Generar un reporte técnico de calidad del alineamiento con *qualimap*.
----
El archivo SAM se convirtió a BAM con Picard, se ordenó por coordenadas genómicas y se incorporaron los grupos de lecturas. Finalmente, SAMtools generó el índice del BAM.

```
java -jar /opt/picard/picard-2.25.2/picard.jar \
SamFormatConverter -I S3.sam -O S3.bam

java -jar /opt/picard/picard-2.25.2/picard.jar \
SortSam I=S3.bam O=S3_sorted.bam SO=coordinate

java -jar /opt/picard/picard-2.25.2/picard.jar \
AddOrReplaceReadGroups I=S3_sorted.bam O=S3_sorted_RG.bam \
ID=S3 LB=Paired-end PL=Illumina PU=Unknown SM=S3

module load samtools
samtools index S3_sorted_RG.bam
```
Se empleó la sintaxis `clave=valor` para los argumentos de `SortSam` y `AddOrReplaceReadGroups`, compatible con Picard 2.25.2. Este ajuste permitió corregir el error de sintaxis asociado al argumento `-SO=coordinate` presente en el ejemplo del tutorial original, sustituyéndolo por `SO=coordinate`.

Esta modificación no alteró los parámetros ni el procedimiento de ordenamiento de las lecturas.

Se utilizó Qualimap en modalidad BAM QC, junto con el archivo BED de regiones blanco proporcionado en el tutorial. Durante la ejecución del comando original se presentó un error de compatibilidad asociado al parámetro obsoleto de Java `MaxPermSize=1024m`.

**Comando original:**

```bash
qualimap bamqc \
-bam S3_sorted_RG.bam \
-gff ~/181004_curso_calidad_datos_NGS/regiones_blanco.bed \
-outdir ./S3_sorted_RG
```

**Mensaje de error obtenido:**

```text
Java memory size is set to 1200M
Launching application...

Unrecognized VM option 'MaxPermSize=1024m'
Error: Could not create the Java Virtual Machine.
Error: A fatal exception has occurred. Program will exit.
```

Este error impidió la ejecución de Qualimap y, en consecuencia, la generación del reporte de calidad.

Mediante una revisión de la documentación técnica asistida por inteligencia artificial, se identificó que la generación permanente de memoria (PermGen) fue eliminada a partir de Java 8. Se verificó que OpenJDK 8 (1.8.0_282), disponible en el servidor, ignoraba dicho parámetro sin interrumpir la ejecución de la máquina virtual.

**Comando modificado:**

```
module load qualimap

JAVA8_HOME=$(dirname "$(dirname "$(readlink -f /usr/bin/java)")")

"$JAVA8_HOME/bin/java" -XX:MaxPermSize=1024m -version

JAVA_HOME="$JAVA8_HOME" PATH="$JAVA8_HOME/bin:$PATH" \
qualimap bamqc \
-bam S3_sorted_RG.bam \
-gff ~/181004_curso_calidad_datos_NGS/regiones_blanco.bed \
-outdir ./S3_sorted_RG
```

El ajuste se limitó al entorno de ejecución, sin alterar el archivo BAM, las regiones blanco ni los parámetros del análisis bioinformático. Como resultado, se obtuvo satisfactoriamente el reporte HTML, el resumen de estadísticas y las 13 figuras de control de calidad.

#### Declaración de uso de inteligencia artificial

Para la resolución del problema de compatibilidad se utilizaron herramientas de inteligencia artificial como apoyo en la búsqueda y síntesis de documentación técnica. La solución propuesta fue verificada experimentalmente en el servidor, permitiendo completar la ejecución de Qualimap sin modificar la metodología original.

###### Referencias

- Oracle. [JDK Migration Guide](https://docs.oracle.com/en/java/javase/17/migrate/migrating-jdk-8-later-jdk-releases.html). Eliminación de PermGen y obsolescencia de `MaxPermSize`.


### Sección N°5: Seleccionar 4 figuras que a su juicio sean las más informativas sobre la calidad de los datos y del ensamble.
----------
Se seleccionó la fracción de cobertura, el histograma de calidad de mapeo, el histograma de duplicación y el perfil de clipping, porque permiten evaluar aspectos complementarios de profundidad, confiabilidad del mapeo, redundancia y exclusión de bases del alineamiento.

### Sección N°6: Incluir las figuras en la sección de Resultados de un reporte técnico. Describir cada figura con una leyenda descriptiva. Adicionalmente, en el texto de la sección, interpretar los resultados y citar cada figura. Debe referirse a la calidad de los datos y del alineamiento. Enfóquese especialmente en los posibles problemas con los datos o alineamientos. Comente potenciales razones que expliquen lo observado. Incluya una sección con las principales *Conclusiones* para la muestra.
----------


### Sección N°7: Incluya el reporte completo generado con *qualimap* como anexo.
------------


### Sección N°8: Comparta el informe en formato markdown a través de github para dar por completada esta tarea.
---------------




