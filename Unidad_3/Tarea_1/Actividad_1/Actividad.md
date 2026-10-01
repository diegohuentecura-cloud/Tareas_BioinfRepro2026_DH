Para determinar el número de reads se utilizó el comando `wc -l`, que permite contar el número de líneas de cada archivo.

```
wc -l S3_R1.txt
wc -l S3_R2.txt
wc -l S3_R1_filter.txt
wc -l S3_R2_filter.txt
```

## Se obtuvieron los siguientes valores:

```
| Archivo          | Número de líneas | Número de reads |
| ---------------- | ---------------- | --------------- |
| S3_R1.txt        | 167700           | 41925           |
| S3_R2.txt        | 167700           | 41925           |
| S3_R1_filter.txt | 122648           | 30662           |
| S3_R2_filter.txt | 122648           | 30662           |
```
Debido a que se muestran 4 líneas, estas se deben dividir en 4 para obtener la cantidad real de reads.
Nos quedarían de la siguiente manera
```
167700 / 4 = 41925 reads  
122648 / 4 = 30662 reads  

Después del proceso de filtrado, quedaron 30662 de los 41925 reads originales, correspondientes aproximadamente al 73,1 % de las lecturas.
```

## Previsualización de las primeras 40 líneas
Para este caso, usé `head` y `less` para poder mostrar las 40 líneas y no llenar la consola de toda la info

```
head -n 40 S3_R1.txt | less
head -n 40 S3_R2.txt | less
head -n 40 S3_R1_filter.txt | less
head -n 40 S3_R2_filter.txt | less
```
A continuación se muestran las imágenes de cada código previsualizado en su parte inicial

aaaaaa

## Visualizar el tercer read
Ya que cada read tiene 4 líneas, se debe considerar que vienen en paquetes de "4", es decir, el primer read es de la linea 1-4, el segundo de 5-8 y el tercero de 9-12.
Considerando esta información se usó el siguiente script
```
head -n 12 S3_R1.txt | tail -n 4
```
### Visualización del tercer read crudo 
```
@M03564:2:000000000-D29D3:1:1101:16551:1405 1:N:0:ATCACGAC+TAAGACAC
AAGCTGACAGCTACTCCAACACCTTTGGGTGGTATGACTGGTTTCCACATGCAAACTGAAGATCGAACTATGAAAAGTGTTAATGACCAGCCATCTGGAAATCTTCCATTTTTAAAACCTGATGATATTCAATACTTTGATAAACTATTGGTAAGTGATACTAGCAGAAATAAACTATTAATTGTGTTCCAGAATTATAAATCATAACATTTCAACTTCCCTTAACAGCGAATTTCGACGATCGTTGCATT
+
CCBCCFFFFFCFGGGGGGGGGGGHHHHHGEFGGHHHHHHHHHHHHHHHHHHHHHHHHHGHHHHHHGHHHHHHHHHHHHHHHHHHHHHHHHHGHHHHHHHHHHHHHHHHHHHHHHHHHHGHHHHHHHIHHHHHIHHHHHHHHHHGHHHHHHHHHHHHHHHHHHHHHHHGHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHGHHHHHHHHHHHHHHGHHHHGHDFGGGGHHHFEGFGFGGFGGGGG0
```
### Analisis del tercer read 

```
| Campo              | Valor             |
| ------------------ | ----------------- |
| Identificador      | M03564            |
| Corrida            | 2                 |
| Flow cell          | 000000000-D29D3   |
| Lane               | 1                 |
| Tile               | 1101              |
| Coordenada X       | 16551             |
| Coordenada Y       | 1405              |
| Read               | 1                 |
| Filtro             | N                 |
| Control            | 0                 |
| Secuencia          | ATCACGAC+TAAGACAC |
```
La información de la calidad se puede visualizar en la cuarta línea del read. De acuerdo con el carácter, nos indicará la calidad de la muestra.

## Traducción del código de calidad para las 10 primeras bases del tercer read a valores numéricos

### bases
```
AAGCTGACAG
```
### Caracteres
```
CCBCCFFFFF
```
En este caso se usó la codificación phred+33 ya que es la que mejor se ajusta a la muestra
```
Bases:   A  A  G  C  T  G  A  C  A  G
Calidad: C  C  B  C  C  F  F  F  F  F
Q:      34 34 33 34 34 37 37 37 37 37
```
Se identifica que estas bases son superiores a Q30

## Regiones en blanco del panel

Se examinó el archivo con el siguiente script 
```
head ../181004_curso_calidad_datos_NGS/regiones_blanco.bed
```

Las primeras líneas correspondieron a regiones genómicas
```
chr2    198264773    198265665    chr2:198264773:198265665:SF3B1+SF3B1+SF3B1:UserDefined
```
Luego se contó el número de líneas según lo siguiente
```
wc -l ../181004_curso_calidad_datos_NGS/regiones_blanco.bed
```
obteniendo como resultado
```
369 ../181004_curso_calidad_datos_NGS/regiones_blanco.bed
```
identificándose 369 regiones blanco

## Lista de símbolos de genes distintos

Para poder analizar la cantidad de genes presentes en BED, se utilizó la función `grep - oe` y finalmente `sort-u` para eliminar los patrones repetidos 
```
grep -oE ':[A-Za-z][A-Za-z0-9._-]*(\+[A-Za-z][A-Za-z0-9._-]*)*:' ../181004_curso_calidad_datos_NGS/regiones_blanco.bed | grep -oE '[A-Za-z][A-Za-z0-9._-]*' | sort -u

Se obtuvo la siguiente lista de genes
## Genes identificados

1. ABL1
2. BRAF
3. BRCA1
4. BRCA2
5. CALR
6. CBL
7. CEBPA
8. CRLF2
9. EZH2
10. FLT3
11. IKZF1
12. IL7
13. JAK2
14. JAK3
15. KIT
16. KRAS
17. MLL
18. MPL
19. P2RY8
20. PAX5
21. PDGFRA
22. PDGFRB
23. PTEN
24. RB1
25. SF3B1
26. TP53
27. WT1
```
Se añadió el número al inicio para facilitar el análisis, pudiéndose identificar 27 genes posterior al análisis









