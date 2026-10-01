## 2 Generación de informes de calidad con FastQC

Para evaluar la calidad de las secuencias se utilizó el programa FastQC sobre la muestra S3.

Se generaron informes independientes para las lecturas R1 y R2. Además, se analizaron ambas condiciones.

### 2.1 Secuencias crudas

Para R1 y R2 se usó respectivamente:

```
fastqc ../181004_curso_calidad_datos_NGS/fastq_raw/S3_R1.fastq.gz -o .

fastqc ../181004_curso_calidad_datos_NGS/fastq_raw/S3_R2.fastq.gz -o .

```
Posterior a esto se obtuvieron los siguientes archivos
```
S3_R1_fastqc.html
S3_R1_fastqc.zip
S3_R2_fastqc.html
S3_R2_fastqc.zip
```
### 2.2 Secuencias podadas

Para R1 y R2 se usó respectivamente:

```
fastqc ../181004_curso_calidad_datos_NGS/fastq_filter/S3_R1_filter.fastq.gz -o .

fastqc ../181004_curso_calidad_datos_NGS/fastq_filter/S3_R2_filter.fastq.gz -o .
```

Posterior a esto se obtuvieron los siguientes archivos
```
S3_R1_filter_fastqc.html
S3_R1_filter_fastqc.zip
S3_R2_filter_fastqc.html
S3_R2_filter_fastqc.zip
```

### 2.3 descarga de los archivos

Los informes HTML generados por FastQC fueron transferidos desde el servidor al computador mediante el siguiente script
```
scp bioinfo1@genoma.med.uchile.cl:dhuentecura/S3*_fastqc.html .
```





