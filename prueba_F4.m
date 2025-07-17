%% Algoritmo de optimización de ubicación de antenas en telecomunicaciones

% Número de zonas objetivos: 6 (A, B, C, D, E, F)
% Posibles ubicaciones de antenas: 5 puntos
% Antenas disponibles: 3
% 3 genes por cromosoma

% Primera generación
% L1/AB, L2/BCD, L3/DE, L4/EF, L5/ACF

% Se inicializa la población de la siguiente manera:
% 1) Población de 6 individuos
% a) Individuo 1: [L1, L3, L4]
% a) Individuo 2: [L2, L4, L5]
% a) Individuo 3: [L1, L2, L5]
% a) Individuo 4: [L3, L4, L5]
% a) Individuo 5: [L1, L2, L3]
% a) Individuo 6: [L2, L3, L4]

% 2a) Evaluación de aptitud: Número de zonas cubiertas
% Evaluación para el individuo 1:
% El individuo 1 cubre a las zonas AB, DE, EF
% El individuo 2 cubre a las zonas BCD, EF, ACF
% El individuo 3 cubre a las zonas AB, BCD, ACF
% El individuo 4 cubre a las zonas DE, EF, ACF
% El individuo 5 cubre a las zonas AB, BCD, DE
% El individuo 6 cubre a las zonas BCD, DE, EF

% Se considerará como función de aptitud lo siguiente:
% f(x) = num_ciudades_cubiertas

% Para el individuo 1: Se cubren las ciudades A, B, D, E, F = 5
% Aptitud total: 5

% Para el individuo 2: Se cubren las ciudades A, B, C, D, E, F = 6
% Aptitud total: 6

% Para el individuo 3: Se cubren las ciudades A, B, C, D, F = 5
% Aptitud total: 5

% Para el individuo 4: Se cubren las ciudades A, C, D, E, F = 5
% Aptitud total: 5

% Para el individuo 5: Se cubren las ciudades A, B, C, D, E = 5
% Aptitud total: 5

% Para el individuo 6: Se cubren las ciudades B, C, D, E, F = 5
% Aptitud total: 5

% 2b) Tabla resumen indicando el fitness
%-------------------------
% Individuo 1 | Fitness: 5
% Individuo 2 | Fitness: 6
% Individuo 3 | Fitness: 5
% Individuo 4 | Fitness: 5
% Individuo 5 | Fitness: 5
% Individuo 6 | Fitness: 5

% 3) Selección por torneo binario
% Se desean hacer 6 torneos en total
% Los participantes del torneo aleatoriamente son:

% Individuo 1 (5) - Individuo 6 (5)
% Individuo 2 (6) - Individuo 4 (5)
% Individuo 3 (5) - Individuo 5 (5)
% Individuo 2 (6) - Individuo 1 (5)
% Individuo 4 (5) - Individuo 6 (5)
% Individuo 2 (6) - Individuo 3 (5)

% Por lo que los ganadores del torneo son:
% T1: I1 (empate, se selecciona aleatoriamente)
% T2: I2 
% T3: I3 (empate, se selecciona aleatoriamente)
% T4: I2
% T5: I4 (empate, se selecciona aleatoriamente)
% T6: I2

% Entonces los seleccionados actuales son:
% a) Seleccionado 1: [L1, L3, L4]
% a) Seleccionado 2: [L2, L4, L5]
% a) Seleccionado 3: [L1, L2, L5]
% a) Seleccionado 4: [L2, L4, L5]
% a) Seleccionado 5: [L3, L4, L5]
% a) Seleccionado 6: [L2, L4, L5]

% 4) Cruce de un punto (Intercambio de ubicaciones)
% Entre el S1 y el S2 hacemos cruce en el punto 2
% Hijo 1 = [L1, L3, L5]
% Hijo 2 = [L2, L4, L4] -> [L2, L4, L1] (se corrige el duplicado)

% Entre el S3 y S4 hacemos cruce en el punto 1
% Hijo 1 = [L1, L4, L5]
% Hijo 2 = [L2, L2, L5] -> [L2, L3, L5] (se corrige el duplicado)

% En los otros no se realiza cruce
% Con lo que los hijos quedarían de la forma
% a) Hijo 1: [L1, L3, L5]
% a) Hijo 2: [L2, L4, L1]
% a) Hijo 3: [L1, L4, L5]
% a) Hijo 4: [L2, L3, L5]
% a) Hijo 5: [L3, L4, L5]
% a) Hijo 6: [L2, L4, L5]

% 5) Mutación del 0.1 por gen (Se cambia a otra ubicación no usada)
% Suponemos que los que mutan en este caso son los hijos 
% H1 (Gen 2)
% [L1, L3, L5] -> [L1, L2, L5]
% H3 (Gen 3)
% [L1, L4, L5] -> [L1, L4, L2]
% H5 (Gen 1)
% [L3, L4, L5] -> [L1, L4, L5]

% 6) Con lo que la nueva población resultante sería
% a) Individuo 1: [L1, L2, L5]
% a) Individuo 2: [L2, L4, L1]
% a) Individuo 3: [L1, L4, L2]
% a) Individuo 4: [L2, L3, L5]
% a) Individuo 5: [L1, L4, L5]
% a) Individuo 6: [L2, L4, L5]

%% Segunda generación
% L1/AB, L2/BCD, L3/DE, L4/EF, L5/ACF
% 1) Población de 6 individuos
% a) Individuo 1: [L1, L2, L5]
% a) Individuo 2: [L2, L4, L1]
% a) Individuo 3: [L1, L4, L2]
% a) Individuo 4: [L2, L3, L5]
% a) Individuo 5: [L1, L4, L5]
% a) Individuo 6: [L2, L4, L5]

% 2a) Evaluación de aptitud: Número de zonas cubiertas
% Evaluación para el individuo 1:
% El individuo 1 cubre a las zonas AB, BCD, ACF
% El individuo 2 cubre a las zonas BCD, EF, AB
% El individuo 3 cubre a las zonas AB, EF, BCD
% El individuo 4 cubre a las zonas BCD, DE, ACF
% El individuo 5 cubre a las zonas AB, EF, ACF
% El individuo 6 cubre a las zonas BCD, EF, ACF

% Se considerará como función de aptitud lo siguiente:
% f(x) = num_ciudades_cubiertas

% Para el individuo 1: Se cubren las ciudades A, B, C, D, F = 5
% Aptitud total: 5

% Para el individuo 2: Se cubren las ciudades A, B, C, D, E, F = 6
% Aptitud total: 6

% Para el individuo 3: Se cubren las ciudades A, B, C, D, E, F = 6
% Aptitud total: 6

% Para el individuo 4: Se cubren las ciudades A, B, C, D, E, F = 6
% Aptitud total: 6

% Para el individuo 5: Se cubren las ciudades A, B, C, E, F = 5
% Aptitud total: 5

% Para el individuo 6: Se cubren las ciudades A, B, C, D, E, F = 6
% Aptitud total: 6

% 2b) Tabla resumen indicando el fitness
%-------------------------
% Individuo 1 | Fitness: 5
% Individuo 2 | Fitness: 6
% Individuo 3 | Fitness: 6
% Individuo 4 | Fitness: 6
% Individuo 5 | Fitness: 5
% Individuo 6 | Fitness: 6

% 3) Selección por torneo binario
% Se desean hacer 6 torneos en total
% Los participantes del torneo aleatoriamente son:

% Individuo 1 (5) - Individuo 6 (6)
% Individuo 2 (6) - Individuo 4 (6)
% Individuo 3 (6) - Individuo 5 (5)
% Individuo 2 (6) - Individuo 1 (5)
% Individuo 4 (6) - Individuo 6 (6)
% Individuo 3 (6) - Individuo 5 (5)

% Por lo que los ganadores del torneo son:
% T1: I6
% T2: I2 (empate, se selecciona aleatoriamente)
% T3: I3
% T4: I2
% T5: I4 (empate, se selecciona aleatoriamente)
% T6: I3

% Entonces los seleccionados actuales son:
% a) Seleccionado 1: [L2, L4, L5]
% a) Seleccionado 2: [L2, L4, L1]
% a) Seleccionado 3: [L1, L4, L2]
% a) Seleccionado 4: [L2, L4, L1]
% a) Seleccionado 5: [L2, L3, L5]
% a) Seleccionado 6: [L1, L4, L2]

% 4) Cruce de un punto (Intercambio de ubicaciones)
% Entre el S1 y el S2 hacemos cruce en el punto 2
% Hijo 1 = [L2, L4, L1]
% Hijo 2 = [L2, L4, L5]

% Entre el S3 y S4 hacemos cruce en el punto 1
% Hijo 1 = [L1, L4, L1] -> [L1, L4, L3] (se corrige duplicado)
% Hijo 2 = [L2, L4, L2] -> [L2, L4, L5] (se corrige duplicado)

% En los otros no se realiza cruce
% Con lo que los hijos quedarían de la forma
% a) Hijo 1: [L2, L4, L1]
% a) Hijo 2: [L2, L4, L5]
% a) Hijo 3: [L1, L4, L3]
% a) Hijo 4: [L2, L4, L5]
% a) Hijo 5: [L2, L3, L5]
% a) Hijo 6: [L1, L4, L2]

% 5) Mutación del 0.1 por gen (Se cambia a otra ubicación no usada)
% Suponemos que los que mutan en este caso son los hijos 
% H2 (Gen 1)
% [L2, L4, L5] -> [L1, L4, L5]
% H4 (Gen 2)
% [L2, L4, L5] -> [L2, L3, L5]
% H6 (Gen 3)
% [L1, L4, L2] -> [L1, L4, L5]

% 6) Con lo que la nueva población resultante sería
% a) Individuo 1: [L2, L4, L1]
% a) Individuo 2: [L1, L4, L5]
% a) Individuo 3: [L1, L4, L3]
% a) Individuo 4: [L2, L3, L5]
% a) Individuo 5: [L2, L3, L5]
% a) Individuo 6: [L1, L4, L5]

%% Tercera generación
% L1/AB, L2/BCD, L3/DE, L4/EF, L5/ACF

% 1) Población de 6 individuos
% a) Individuo 1: [L2, L4, L1]
% a) Individuo 2: [L1, L4, L5]
% a) Individuo 3: [L1, L4, L3]
% a) Individuo 4: [L2, L3, L5]
% a) Individuo 5: [L2, L3, L5]
% a) Individuo 6: [L1, L4, L5]

% 2a) Evaluación de aptitud: Número de zonas cubiertas
% Evaluación para el individuo 1:
% El individuo 1 cubre a las zonas BCD, EF, AB
% El individuo 2 cubre a las zonas AB, EF, ACF
% El individuo 3 cubre a las zonas AB, EF, DE
% El individuo 4 cubre a las zonas BCD, DE, ACF
% El individuo 5 cubre a las zonas BCD, DE, ACF
% El individuo 6 cubre a las zonas AB, EF, ACF

% Se considerará como función de aptitud lo siguiente:
% f(x) = num_ciudades_cubiertas

% Para el individuo 1: Se cubren las ciudades A, B, C, D, E, F = 6
% Aptitud total: 6

% Para el individuo 2: Se cubren las ciudades A, B, C, E, F = 5
% Aptitud total: 5

% Para el individuo 3: Se cubren las ciudades A, B, D, E, F = 5
% Aptitud total: 5

% Para el individuo 4: Se cubren las ciudades A, B, C, D, E, F = 6
% Aptitud total: 6

% Para el individuo 5: Se cubren las ciudades A, B, C, D, E, F = 6
% Aptitud total: 6

% Para el individuo 6: Se cubren las ciudades A, B, C, E, F = 5
% Aptitud total: 5

% 2b) Tabla resumen indicando el fitness
%-------------------------
% Individuo 1 | Fitness: 6
% Individuo 2 | Fitness: 5
% Individuo 3 | Fitness: 5
% Individuo 4 | Fitness: 6
% Individuo 5 | Fitness: 6
% Individuo 6 | Fitness: 5

% 3) Selección por torneo binario
% Se desean hacer 6 torneos en total
% Los participantes del torneo aleatoriamente son:

% Individuo 1 (6) - Individuo 6 (5)
% Individuo 2 (5) - Individuo 4 (6)
% Individuo 3 (5) - Individuo 5 (6)
% Individuo 1 (6) - Individuo 2 (5)
% Individuo 4 (6) - Individuo 6 (5)
% Individuo 5 (6) - Individuo 3 (5)

% Por lo que los ganadores del torneo son:
% T1: I1
% T2: I4
% T3: I5
% T4: I1
% T5: I4
% T6: I5

% Entonces los seleccionados actuales son:
% a) Seleccionado 1: [L2, L4, L1]
% a) Seleccionado 2: [L2, L3, L5]
% a) Seleccionado 3: [L2, L3, L5]
% a) Seleccionado 4: [L2, L4, L1]
% a) Seleccionado 5: [L2, L3, L5]
% a) Seleccionado 6: [L2, L3, L5]

% 4) Cruce de un punto (Intercambio de ubicaciones)
% Entre el S1 y el S2 hacemos cruce en el punto 2
% Hijo 1 = [L2, L4, L5]
% Hijo 2 = [L2, L3, L1]

% Entre el S3 y S4 hacemos cruce en el punto 1
% Hijo 1 = [L2, L4, L1]
% Hijo 2 = [L2, L3, L5]

% En los otros no se realiza cruce
% Con lo que los hijos quedarían de la forma
% a) Hijo 1: [L2, L4, L5]
% a) Hijo 2: [L2, L3, L1]
% a) Hijo 3: [L2, L4, L1]
% a) Hijo 4: [L2, L3, L5]
% a) Hijo 5: [L2, L3, L5]
% a) Hijo 6: [L2, L3, L5]

% 5) Mutación del 0.1 por gen (Se cambia a otra ubicación no usada)
% Suponemos que los que mutan en este caso son los hijos 
% H1 (Gen 1)
% [L2, L4, L5] -> [L1, L4, L5]
% H2 (Gen 2)
% [L2, L3, L1] -> [L2, L4, L1]
% H3 (Gen 3)
% [L2, L4, L1] -> [L2, L4, L3]

% 6) Con lo que la nueva población resultante sería
% a) Individuo 1: [L1, L4, L5]
% a) Individuo 2: [L2, L4, L1]
% a) Individuo 3: [L2, L4, L3]
% a) Individuo 4: [L2, L3, L5]
% a) Individuo 5: [L2, L3, L5]
% a) Individuo 6: [L2, L3, L5]

%% Evaluación de la nueva población
% L1/AB, L2/BCD, L3/DE, L4/EF, L5/ACF

% 1) Población de 6 individuos
% a) Individuo 1: [L1, L4, L5]
% a) Individuo 2: [L2, L4, L1]
% a) Individuo 3: [L2, L4, L3]
% a) Individuo 4: [L2, L3, L5]
% a) Individuo 5: [L2, L3, L5]
% a) Individuo 6: [L2, L3, L5]

% 2a) Evaluación de aptitud: Número de zonas cubiertas
% Evaluación para el individuo 1:
% El individuo 1 cubre a las zonas AB, EF, ACF
% El individuo 2 cubre a las zonas BCD, EF, AB
% El individuo 3 cubre a las zonas BCD, EF, DE
% El individuo 4 cubre a las zonas BCD, DE, ACF
% El individuo 5 cubre a las zonas BCD, DE, ACF
% El individuo 6 cubre a las zonas BCD, DE, ACF

% Se considerará como función de aptitud lo siguiente:
% f(x) = num_ciudades_cubiertas

% Para el individuo 1: Se cubren las ciudades A, B, C, E, F = 5
% Aptitud total: 5

% Para el individuo 2: Se cubren las ciudades A, B, C, D, E, F = 6
% Aptitud total: 6

% Para el individuo 3: Se cubren las ciudades B, C, D, E, F = 5
% Aptitud total: 5

% Para el individuo 4: Se cubren las ciudades A, B, C, D, E, F = 6
% Aptitud total: 6

% Para el individuo 5: Se cubren las ciudades A, B, C, D, E, F = 6
% Aptitud total: 6

% Para el individuo 6: Se cubren las ciudades A, B, C, D, E, F = 6
% Aptitud total: 6

% 2b) Tabla resumen indicando el fitness
%-------------------------
% Individuo 1 | Fitness: 5
% Individuo 2 | Fitness: 6
% Individuo 3 | Fitness: 5
% Individuo 4 | Fitness: 6
% Individuo 5 | Fitness: 6
% Individuo 6 | Fitness: 6

%% Conclusiones
% Se puede ver que el algoritmo genético mostró una convergencia rápida hacia
% soluciones que cubren las 6 zonas objetivo (A, B, C, D, E, F).

% Las mejores soluciones encontradas incluyen combinaciones como:
% [L2, L4, L1], [L2, L3, L5], las cuales logran cobertura completa de las 6 zonas.

%%


%%


%%



%%

%% Algoritmo genético para optimización de distribución de canales en redes de telecomunicaciones celulares.

% Parámetros del algoritmo genético
% Cantidad de celdas: 4
% Identificación de celdas: C1, C2, C3, C4
% Canales disponibles: [1, 2, 3, 4, 5, 6]
% Estructura del cromosoma: 4 genes 
% Conectividad: C1 conecta con C2 y C3; C2 conecta con C1 y C4; C3 conecta con C1 y C4; C4 conecta con C2 y C3
% Criterios de penalización:
% 1) Canal idéntico -> penalización de +2
% 2) Canales consecutivos (diferencia de 1) -> penalización de +1
% Fitness = valor máximo alcanzable - penalización acumulada

% Generación inicial
% Inicialización de la población con:
% 1) Conjunto de 6 individuos
% a) Individuo 1: [3, 1, 4, 5] 
% a) Individuo 2: [2, 5, 1, 3] (C1 utiliza canal 2, C2 utiliza canal 5, C3 utiliza canal 1, C4 utiliza canal 3)
% a) Individuo 3: [1, 4, 6, 2] 
% a) Individuo 4: [5, 3, 2, 6] 
% a) Individuo 5: [4, 6, 3, 1] 
% a) Individuo 6: [1, 2, 5, 4] 

% 2a) Cálculo de aptitud: Análisis de interferencia entre celdas vecinas
% Para el individuo 1: [3, 1, 4, 5]
% C1-C2: 3 vs 1 -> diferencia de 2, sin penalización
% C1-C3: 3 vs 4 -> diferencia de 1, penalización de 1
% C2-C4: 1 vs 5 -> diferencia de 4, sin penalización
% C3-C4: 4 vs 5 -> diferencia de 1, penalización de 1
% Penalización acumulada: 2
% Fitness = 10 - 2 = 8

% Para el individuo 2: [2, 5, 1, 3]
% C1-C2: 2 vs 5 -> diferencia de 3, sin penalización
% C1-C3: 2 vs 1 -> diferencia de 1, penalización de 1
% C2-C4: 5 vs 3 -> diferencia de 2, sin penalización
% C3-C4: 1 vs 3 -> diferencia de 2, sin penalización
% Penalización acumulada: 1
% Fitness = 10 - 1 = 9

% Para el individuo 3: [1, 4, 6, 2]
% C1-C2: 1 vs 4 -> diferencia de 3, sin penalización
% C1-C3: 1 vs 6 -> diferencia de 5, sin penalización
% C2-C4: 4 vs 2 -> diferencia de 2, sin penalización
% C3-C4: 6 vs 2 -> diferencia de 4, sin penalización
% Penalización acumulada: 0
% Fitness = 10 - 0 = 10

% Para el individuo 4: [5, 3, 2, 6]
% C1-C2: 5 vs 3 -> diferencia de 2, sin penalización
% C1-C3: 5 vs 2 -> diferencia de 3, sin penalización
% C2-C4: 3 vs 6 -> diferencia de 3, sin penalización
% C3-C4: 2 vs 6 -> diferencia de 4, sin penalización
% Penalización acumulada: 0
% Fitness = 10 - 0 = 10

% Para el individuo 5: [4, 6, 3, 1]
% C1-C2: 4 vs 6 -> diferencia de 2, sin penalización
% C1-C3: 4 vs 3 -> diferencia de 1, penalización de 1
% C2-C4: 6 vs 1 -> diferencia de 5, sin penalización
% C3-C4: 3 vs 1 -> diferencia de 2, sin penalización
% Penalización acumulada: 1
% Fitness = 10 - 1 = 9

% Para el individuo 6: [1, 2, 5, 4]
% C1-C2: 1 vs 2 -> diferencia de 1, penalización de 1
% C1-C3: 1 vs 5 -> diferencia de 4, sin penalización
% C2-C4: 2 vs 4 -> diferencia de 2, sin penalización
% C3-C4: 5 vs 4 -> diferencia de 1, penalización de 1
% Penalización acumulada: 2
% Fitness = 10 - 2 = 8

% 2b) Resumen de resultados
%---------------------------------------------------------------------
% Individuo 1 | Cromosoma: [3, 1, 4, 5] | Penalización: 2 | Fitness: 8
% Individuo 2 | Cromosoma: [2, 5, 1, 3] | Penalización: 1 | Fitness: 9
% Individuo 3 | Cromosoma: [1, 4, 6, 2] | Penalización: 0 | Fitness: 10
% Individuo 4 | Cromosoma: [5, 3, 2, 6] | Penalización: 0 | Fitness: 10
% Individuo 5 | Cromosoma: [4, 6, 3, 1] | Penalización: 1 | Fitness: 9
% Individuo 6 | Cromosoma: [1, 2, 5, 4] | Penalización: 2 | Fitness: 8

% 3) Proceso de selección mediante torneo binario
% Se realizan 5 competencias para obtener 5 descendientes, aplicando
% estrategia elitista

% Los emparejamientos aleatorios son:
% Individuo 3 (10) - Individuo 1 (8)
% Individuo 4 (10) - Individuo 6 (8)
% Individuo 2 (9) - Individuo 5 (9)
% Individuo 3 (10) - Individuo 4 (10)
% Individuo 5 (9) - Individuo 1 (8)

% Los victoriosos en cada torneo son:
% T1: I3
% T2: I4
% T3: I2
% T4: I3
% T5: I5

% Los individuos seleccionados resultan:
% a) Seleccionado 1: [1, 4, 6, 2]
% a) Seleccionado 2: [5, 3, 2, 6]
% a) Seleccionado 3: [2, 5, 1, 3]
% a) Seleccionado 4: [1, 4, 6, 2]
% a) Seleccionado 5: [4, 6, 3, 1]

% 4) Operación de cruce en un punto
% Entre S1 y S2 ejecutamos cruce después del índice 2
% Padre 1: [1, 4, 6, 2] -> Hijo 1: [1, 4, 2, 6]
% Padre 2: [5, 3, 2, 6] -> Hijo 2: [5, 3, 6, 2]

% Entre S3 y S4 ejecutamos cruce después del índice 2
% Padre 3: [2, 5, 1, 3] -> Hijo 3: [2, 5, 6, 2]
% Padre 4: [1, 4, 6, 2] -> Hijo 4: [1, 4, 1, 3]

% S5 permanece sin alteración
% Hijo 5: [4, 6, 3, 1]

% Los descendientes obtenidos son:
% a) Hijo 1: [1, 4, 2, 6]
% a) Hijo 2: [5, 3, 6, 2]
% a) Hijo 3: [2, 5, 6, 2]
% a) Hijo 4: [1, 4, 1, 3]
% a) Hijo 5: [4, 6, 3, 1]

% 5) Proceso de mutación (10% de probabilidad: H1; C3 a C5 y H4: C4 a C6)
% Asumiendo que ambas mutaciones especificadas ocurren, entonces:
% H1: [1, 4, 2, 6] -> [1, 4, 5, 6] (C3 cambia de 2 a 5)
% H4: [1, 4, 1, 3] -> [1, 4, 1, 6] (C4 cambia de 3 a 6)

% 6) Nueva población aplicando elitismo: El mejor individuo y 5 descendientes
% El mejor de la generación previa fue el individuo 3 [1, 4, 6, 2] (fitness de 10)
% Los 5 hijos con mutaciones:
% a) Hijo 1: [1, 4, 5, 6]
% a) Hijo 2: [5, 3, 6, 2]
% a) Hijo 3: [2, 5, 6, 2]
% a) Hijo 4: [1, 4, 1, 6]
% a) Hijo 5: [4, 6, 3, 1]

%% Segunda generación
% 1) Conjunto de 6 individuos
% a) Individuo 1: [1, 4, 6, 2]
% a) Individuo 2: [1, 4, 5, 6]
% a) Individuo 3: [5, 3, 6, 2]
% a) Individuo 4: [2, 5, 6, 2]
% a) Individuo 5: [1, 4, 1, 6]
% a) Individuo 6: [4, 6, 3, 1]

% 2a) Cálculo de aptitud: Análisis de interferencia entre celdas vecinas
% Para el individuo 1: [1, 4, 6, 2] 
% Ya calculado anteriormente
% Penalización acumulada: 0, Fitness: 10

% Para el individuo 2: [1, 4, 5, 6]
% C1-C2: 1 vs 4 -> diferencia de 3, sin penalización
% C1-C3: 1 vs 5 -> diferencia de 4, sin penalización
% C2-C4: 4 vs 6 -> diferencia de 2, sin penalización
% C3-C4: 5 vs 6 -> diferencia de 1, penalización de 1
% Penalización acumulada: 1
% Fitness = 10 - 1 = 9

% Para el individuo 3: [5, 3, 6, 2]
% C1-C2: 5 vs 3 -> diferencia de 2, sin penalización
% C1-C3: 5 vs 6 -> diferencia de 1, penalización de 1
% C2-C4: 3 vs 2 -> diferencia de 1, penalización de 1
% C3-C4: 6 vs 2 -> diferencia de 4, sin penalización
% Penalización acumulada: 2
% Fitness = 10 - 2 = 8

% Para el individuo 4: [2, 5, 6, 2]
% C1-C2: 2 vs 5 -> diferencia de 3, sin penalización
% C1-C3: 2 vs 6 -> diferencia de 4, sin penalización
% C2-C4: 5 vs 2 -> diferencia de 3, sin penalización
% C3-C4: 6 vs 2 -> diferencia de 4, sin penalización
% Penalización acumulada: 0
% Fitness = 10 - 0 = 10

% Para el individuo 5: [1, 4, 1, 6]
% C1-C2: 1 vs 4 -> diferencia de 3, sin penalización
% C1-C3: 1 vs 1 -> canal idéntico, penalización de 2
% C2-C4: 4 vs 6 -> diferencia de 2, sin penalización
% C3-C4: 1 vs 6 -> diferencia de 5, sin penalización
% Penalización acumulada: 2
% Fitness = 10 - 2 = 8

% Para el individuo 6: [4, 6, 3, 1]
% C1-C2: 4 vs 6 -> diferencia de 2, sin penalización
% C1-C3: 4 vs 3 -> diferencia de 1, penalización de 1
% C2-C4: 6 vs 1 -> diferencia de 5, sin penalización
% C3-C4: 3 vs 1 -> diferencia de 2, sin penalización
% Penalización acumulada: 1
% Fitness = 10 - 1 = 9

% 2b) Resumen de resultados con valores de fitness
%---------------------------------------------------------------------
% Individuo 1 | Cromosoma: [1, 4, 6, 2] | Penalización: 0 | Fitness: 10
% Individuo 2 | Cromosoma: [1, 4, 5, 6] | Penalización: 1 | Fitness: 9
% Individuo 3 | Cromosoma: [5, 3, 6, 2] | Penalización: 2 | Fitness: 8
% Individuo 4 | Cromosoma: [2, 5, 6, 2] | Penalización: 0 | Fitness: 10
% Individuo 5 | Cromosoma: [1, 4, 1, 6] | Penalización: 2 | Fitness: 8
% Individuo 6 | Cromosoma: [4, 6, 3, 1] | Penalización: 1 | Fitness: 9

% 3) Proceso de selección mediante torneo binario
% Se ejecutan 5 competencias
% Los emparejamientos aleatorios son:

% Individuo 1 (10) - Individuo 5 (8)
% Individuo 4 (10) - Individuo 3 (8)
% Individuo 2 (9) - Individuo 6 (9)
% Individuo 1 (10) - Individuo 4 (10)
% Individuo 2 (9) - Individuo 5 (8)

% Los victoriosos en cada torneo son:
% T1: I1
% T2: I4
% T3: I2
% T4: I1
% T5: I2

% Los individuos seleccionados resultan:
% a) Seleccionado 1: [1, 4, 6, 2]
% a) Seleccionado 2: [2, 5, 6, 2]
% a) Seleccionado 3: [1, 4, 5, 6]
% a) Seleccionado 4: [1, 4, 6, 2]
% a) Seleccionado 5: [1, 4, 5, 6]

% 4) Operación de cruce en un punto
% Entre S1 y S2 ejecutamos cruce después del índice 2
% Padre 1: [1, 4, 6, 2] -> Hijo 1: [1, 4, 6, 2]
% Padre 2: [2, 5, 6, 2] -> Hijo 2: [2, 5, 6, 2]

% Entre S3 y S4 ejecutamos cruce después del índice 1
% Padre 3: [1, 4, 5, 6] -> Hijo 3: [1, 4, 6, 2]
% Padre 4: [1, 4, 6, 2] -> Hijo 4: [1, 4, 5, 6]

% S5 permanece sin alteración
% Hijo 5: [1, 4, 5, 6]

% Los descendientes obtenidos son:
% a) Hijo 1: [1, 4, 6, 2]
% a) Hijo 2: [2, 5, 6, 2]
% a) Hijo 3: [1, 4, 6, 2]
% a) Hijo 4: [1, 4, 5, 6]
% a) Hijo 5: [1, 4, 5, 6]

% 5) Proceso de mutación (10% de probabilidad)
% En este caso se producen las siguientes mutaciones:
% H2: [2, 5, 6, 2] -> [2, 1, 6, 2] (C2 cambia del canal 5 al canal 1)
% H5: [1, 4, 5, 6] -> [1, 4, 5, 3] (C4 cambia del canal 6 al canal 3)

% 6) Nueva población aplicando elitismo: El mejor individuo y 5 descendientes
% El mejor de la generación previa: Individuo 1 [1, 4, 6, 2] (fitness de 10)
% Los 5 hijos con mutaciones:
% a) Hijo 1: [1, 4, 6, 2]
% a) Hijo 2: [2, 1, 6, 2]
% a) Hijo 3: [1, 4, 6, 2]
% a) Hijo 4: [1, 4, 5, 6]
% a) Hijo 5: [1, 4, 5, 3]

%% Tercera generación
% 1) Conjunto de 6 individuos
% a) Individuo 1: [1, 4, 6, 2]
% a) Individuo 2: [1, 4, 6, 2]
% a) Individuo 3: [2, 1, 6, 2]
% a) Individuo 4: [1, 4, 6, 2]
% a) Individuo 5: [1, 4, 5, 6]
% a) Individuo 6: [1, 4, 5, 3]

% 2a) Cálculo de aptitud: Análisis de interferencia entre celdas vecinas
% Para el individuo 1: [1, 4, 6, 2]
% Ya calculado anteriormente
% Penalización acumulada: 0, Fitness: 10

% Para el individuo 2: [1, 4, 6, 2]
% Ya calculado anteriormente
% Penalización acumulada: 0, Fitness: 10

% Para el individuo 3: [2, 1, 6, 2]
% C1-C2: 2 vs 1 -> diferencia de 1, penalización de 1
% C1-C3: 2 vs 6 -> diferencia de 4, sin penalización
% C2-C4: 1 vs 2 -> diferencia de 1, penalización de 1
% C3-C4: 6 vs 2 -> diferencia de 4, sin penalización
% Penalización acumulada: 2
% Fitness = 10 - 2 = 8

% Para el individuo 4: [1, 4, 6, 2]
% Ya calculado anteriormente
% Penalización acumulada: 0, Fitness: 10

% Para el individuo 5: [1, 4, 5, 6]
% Ya calculado anteriormente
% Penalización acumulada: 1, Fitness: 9

% Para el individuo 6: [1, 4, 5, 3]
% C1-C2: 1 vs 4 -> diferencia de 3, sin penalización
% C1-C3: 1 vs 5 -> diferencia de 4, sin penalización
% C2-C4: 4 vs 3 -> diferencia de 1, penalización de 1
% C3-C4: 5 vs 3 -> diferencia de 2, sin penalización
% Penalización acumulada: 1
% Fitness = 10 - 1 = 9

% 2b) Resumen de resultados con valores de fitness
%---------------------------------------------------------------------
% Individuo 1 | Cromosoma: [1, 4, 6, 2] | Penalización: 0 | Fitness: 10
% Individuo 2 | Cromosoma: [1, 4, 6, 2] | Penalización: 0 | Fitness: 10
% Individuo 3 | Cromosoma: [2, 1, 6, 2] | Penalización: 2 | Fitness: 8
% Individuo 4 | Cromosoma: [1, 4, 6, 2] | Penalización: 0 | Fitness: 10
% Individuo 5 | Cromosoma: [1, 4, 5, 6] | Penalización: 1 | Fitness: 9
% Individuo 6 | Cromosoma: [1, 4, 5, 3] | Penalización: 1 | Fitness: 9

% 3) Proceso de selección mediante torneo binario
% Se ejecutan 5 competencias
% Los emparejamientos aleatorios son:

% Individuo 1 (10) - Individuo 3 (8)
% Individuo 2 (10) - Individuo 6 (9)
% Individuo 4 (10) - Individuo 5 (9)
% Individuo 1 (10) - Individuo 2 (10)
% Individuo 4 (10) - Individuo 6 (9)

% Los victoriosos en cada torneo son:
% T1: I1
% T2: I2
% T3: I4
% T4: I1
% T5: I4

% Los individuos seleccionados resultan:
% a) Seleccionado 1: [1, 4, 6, 2]
% a) Seleccionado 2: [1, 4, 6, 2]
% a) Seleccionado 3: [1, 4, 6, 2]
% a) Seleccionado 4: [1, 4, 6, 2]
% a) Seleccionado 5: [1, 4, 6, 2]

% 4) Operación de cruce en un punto

% Considerando que entre S2 y S3 ejecutamos cruce después del índice 1
% Padre 2: [1, 4, 6, 2] -> Hijo 2: [1, 4, 6, 2]
% Padre 3: [1, 4, 6, 2] -> Hijo 3: [1, 4, 6, 2]

% S1, S4 y S5 permanecen sin alteración
% Hijo 5: [1, 4, 6, 2]

% Los descendientes obtenidos son:
% a) Hijo 1: [1, 4, 6, 2]
% a) Hijo 2: [1, 4, 6, 2]
% a) Hijo 3: [1, 4, 6, 2]
% a) Hijo 4: [1, 4, 6, 2]
% a) Hijo 5: [1, 4, 6, 2]

% 5) Proceso de mutación (10% de probabilidad)
% Considerando que se produce esta mutación específicamente:
% H3: [1, 4, 6, 2] -> [1, 3, 6, 2] (C2 cambia del canal 4 al canal 3)

% 6) Nueva población aplicando elitismo: El mejor individuo y 5 descendientes
% El mejor de la generación previa: Individuo 1 [1, 4, 6, 2] (fitness 10)
% Los 5 hijos con mutaciones:
% a) Hijo 1: [1, 4, 6, 2]
% a) Hijo 2: [1, 4, 6, 2]
% a) Hijo 3: [1, 3, 6, 2]
% a) Hijo 4: [1, 4, 6, 2]
% a) Hijo 5: [1, 4, 6, 2]

%% Evaluación de la población resultante
% 1) Conjunto de 6 individuos
% a) Individuo 1: [1, 4, 6, 2] 
% a) Individuo 2: [1, 4, 6, 2]
% a) Individuo 3: [1, 4, 6, 2]
% a) Individuo 4: [1, 3, 6, 2]
% a) Individuo 5: [1, 4, 6, 2]
% a) Individuo 6: [1, 4, 6, 2]

% 2a) Cálculo de aptitud: Análisis de interferencia entre celdas vecinas
% Para el individuo 1: [1, 4, 6, 2] (ya calculado)
% Penalización acumulada: 0, Fitness: 10

% Para el individuo 2: [1, 4, 6, 2] (ya calculado)
% Penalización acumulada: 0, Fitness: 10

% Para el individuo 3: [1, 4, 6, 2] (ya calculado)
% Penalización acumulada: 0, Fitness: 10

% Para el individuo 4: [1, 3, 6, 2]
% C1-C2: 1 vs 3 -> diferencia de 2, sin penalización
% C1-C3: 1 vs 6 -> diferencia de 5, sin penalización
% C2-C4: 3 vs 2 -> diferencia de 1, penalización de 1
% C3-C4: 6 vs 2 -> diferencia de 4, sin penalización
% Penalización acumulada: 1
% Fitness = 10 - 1 = 9

% Para el individuo 5: [1, 4, 6, 2] (ya calculado)
% Penalización acumulada: 0, Fitness: 10

% Para el individuo 6: [1, 4, 6, 2] (ya calculado)
% Penalización acumulada: 0, Fitness: 10

% 2b) Resumen de resultados con valores de fitness
%----------------------------------------------------------------------
% Individuo 1 | Cromosoma: [1, 4, 6, 2] | Penalización: 0 | Fitness: 10
% Individuo 2 | Cromosoma: [1, 4, 6, 2] | Penalización: 0 | Fitness: 10
% Individuo 3 | Cromosoma: [1, 4, 6, 2] | Penalización: 0 | Fitness: 10
% Individuo 4 | Cromosoma: [1, 3, 6, 2] | Penalización: 1 | Fitness: 9
% Individuo 5 | Cromosoma: [1, 4, 6, 2] | Penalización: 0 | Fitness: 10
% Individuo 6 | Cromosoma: [1, 4, 6, 2] | Penalización: 0 | Fitness: 10

%% Observaciones finales

% Es evidente que el algoritmo logró identificar una solución óptima desde la primera generación.

% El individuo [1, 4, 6, 2] alcanzó el fitness máximo de 10, representando
% la distribución perfecta de canales sin interferencia.

% La estrategia elitista resultó fundamental para preservar la mejor solución
% a través de las generaciones sucesivas.

% El proceso de mutación facilitó la exploración de nuevas configuraciones
% en el espacio de búsqueda.

% Este algoritmo demuestra ser efectivo para determinar la distribución
% óptima de canales que elimina la interferencia en sistemas celulares de telecomunicaciones.

%% 

%%

%%

%%

%% Algoritmo de optimización para el problema de las 4 reinas usando algoritmo genético

% Tablero de 4x4
% 4 reinas a colocar
% 4 genes por cromosoma (cada gen representa la fila donde va la reina de cada columna)
% Cada gen puede tomar valores de 1 a 4

% Primera generación
% Se inicializa la población de la siguiente manera:
% 1) Población de 6 individuos
% a) Individuo 1: [1, 3, 2, 4] (reina col1 en fila1, col2 en fila3, col3 en fila2, col4 en fila4)
% a) Individuo 2: [2, 4, 1, 3]
% a) Individuo 3: [3, 1, 4, 2]
% a) Individuo 4: [4, 2, 3, 1]
% a) Individuo 5: [1, 4, 2, 3]
% a) Individuo 6: [2, 1, 3, 4]

% 2a) Evaluación de aptitud: Número de conflictos entre reinas
% Se cuenta cuántas reinas se atacan entre sí (misma fila, columna o diagonal)
% Como ya están en columnas diferentes, solo checamos filas y diagonales

% Evaluación para el individuo 1: [1, 3, 2, 4]
% Conflictos de fila: ninguno (todas en filas diferentes)
% Conflictos diagonales: 
% - Reina en (1,1) vs Reina en (2,3): |1-2| = 1, |1-3| = 2, no diagonal
% - Reina en (1,1) vs Reina en (3,2): |1-3| = 2, |1-2| = 1, no diagonal  
% - Reina en (1,1) vs Reina en (4,4): |1-4| = 3, |1-4| = 3, SÍ diagonal
% - Reina en (3,2) vs Reina en (2,3): |3-2| = 1, |2-3| = 1, SÍ diagonal
% - Reina en (3,2) vs Reina en (4,4): |3-4| = 1, |2-4| = 2, no diagonal
% - Reina en (2,3) vs Reina en (4,4): |2-4| = 2, |3-4| = 1, no diagonal
% Total conflictos: 2

% Evaluación para el individuo 2: [2, 4, 1, 3]
% Conflictos de fila: ninguno
% Conflictos diagonales:
% - Reina en (2,1) vs Reina en (4,2): |2-4| = 2, |1-2| = 1, no diagonal
% - Reina en (2,1) vs Reina en (1,3): |2-1| = 1, |1-3| = 2, no diagonal
% - Reina en (2,1) vs Reina en (3,4): |2-3| = 1, |1-4| = 3, no diagonal
% - Reina en (4,2) vs Reina en (1,3): |4-1| = 3, |2-3| = 1, no diagonal
% - Reina en (4,2) vs Reina en (3,4): |4-3| = 1, |2-4| = 2, no diagonal
% - Reina en (1,3) vs Reina en (3,4): |1-3| = 2, |3-4| = 1, no diagonal
% Total conflictos: 0

% Evaluación para el individuo 3: [3, 1, 4, 2]
% Conflictos de fila: ninguno
% Conflictos diagonales:
% - Reina en (3,1) vs Reina en (1,2): |3-1| = 2, |1-2| = 1, no diagonal
% - Reina en (3,1) vs Reina en (4,3): |3-4| = 1, |1-3| = 2, no diagonal
% - Reina en (3,1) vs Reina en (2,4): |3-2| = 1, |1-4| = 3, no diagonal
% - Reina en (1,2) vs Reina en (4,3): |1-4| = 3, |2-3| = 1, no diagonal
% - Reina en (1,2) vs Reina en (2,4): |1-2| = 1, |2-4| = 2, no diagonal
% - Reina en (4,3) vs Reina en (2,4): |4-2| = 2, |3-4| = 1, no diagonal
% Total conflictos: 0

% Evaluación para el individuo 4: [4, 2, 3, 1]
% Conflictos de fila: ninguno
% Conflictos diagonales:
% - Reina en (4,1) vs Reina en (2,2): |4-2| = 2, |1-2| = 1, no diagonal
% - Reina en (4,1) vs Reina en (3,3): |4-3| = 1, |1-3| = 2, no diagonal
% - Reina en (4,1) vs Reina en (1,4): |4-1| = 3, |1-4| = 3, SÍ diagonal
% - Reina en (2,2) vs Reina en (3,3): |2-3| = 1, |2-3| = 1, SÍ diagonal
% - Reina en (2,2) vs Reina en (1,4): |2-1| = 1, |2-4| = 2, no diagonal
% - Reina en (3,3) vs Reina en (1,4): |3-1| = 2, |3-4| = 1, no diagonal
% Total conflictos: 2

% Evaluación para el individuo 5: [1, 4, 2, 3]
% Conflictos de fila: ninguno
% Conflictos diagonales:
% - Reina en (1,1) vs Reina en (4,2): |1-4| = 3, |1-2| = 1, no diagonal
% - Reina en (1,1) vs Reina en (2,3): |1-2| = 1, |1-3| = 2, no diagonal
% - Reina en (1,1) vs Reina en (3,4): |1-3| = 2, |1-4| = 3, no diagonal
% - Reina en (4,2) vs Reina en (2,3): |4-2| = 2, |2-3| = 1, no diagonal
% - Reina en (4,2) vs Reina en (3,4): |4-3| = 1, |2-4| = 2, no diagonal
% - Reina en (2,3) vs Reina en (3,4): |2-3| = 1, |3-4| = 1, SÍ diagonal
% Total conflictos: 1

% Evaluación para el individuo 6: [2, 1, 3, 4]
% Conflictos de fila: ninguno
% Conflictos diagonales:
% - Reina en (2,1) vs Reina en (1,2): |2-1| = 1, |1-2| = 1, SÍ diagonal
% - Reina en (2,1) vs Reina en (3,3): |2-3| = 1, |1-3| = 2, no diagonal
% - Reina en (2,1) vs Reina en (4,4): |2-4| = 2, |1-4| = 3, no diagonal
% - Reina en (1,2) vs Reina en (3,3): |1-3| = 2, |2-3| = 1, no diagonal
% - Reina en (1,2) vs Reina en (4,4): |1-4| = 3, |2-4| = 2, no diagonal
% - Reina en (3,3) vs Reina en (4,4): |3-4| = 1, |3-4| = 1, SÍ diagonal
% Total conflictos: 2

% Se considerará como función de aptitud:
% f(x) = 10 - num_conflictos (mientras menos conflictos, mejor aptitud)

% Para el individuo 1: 2 conflictos -> Aptitud = 10 - 2 = 8
% Para el individuo 2: 0 conflictos -> Aptitud = 10 - 0 = 10
% Para el individuo 3: 0 conflictos -> Aptitud = 10 - 0 = 10
% Para el individuo 4: 2 conflictos -> Aptitud = 10 - 2 = 8
% Para el individuo 5: 1 conflicto -> Aptitud = 10 - 1 = 9
% Para el individuo 6: 2 conflictos -> Aptitud = 10 - 2 = 8

% 2b) Tabla resumen indicando el fitness
% Individuo 1 Fitness: 8
% Individuo 2 Fitness: 10
% Individuo 3 Fitness: 10
% Individuo 4 Fitness: 8
% Individuo 5 Fitness: 9
% Individuo 6 Fitness: 8

% 3) Selección por torneo binario
% Se desean hacer 6 torneos en total
% Los participantes del torneo aleatoriamente son:

% Individuo 1 (8) - Individuo 6 (8)
% Individuo 2 (10) - Individuo 4 (8)
% Individuo 3 (10) - Individuo 5 (9)
% Individuo 1 (8) - Individuo 2 (10)
% Individuo 4 (8) - Individuo 3 (10)
% Individuo 5 (9) - Individuo 6 (8)

% Por lo que los ganadores del torneo son:
% T1: I1 (empate, se elige al azar)
% T2: I2
% T3: I3
% T4: I2
% T5: I3
% T6: I5

% Entonces los seleccionados actuales son:
% a) Seleccionado 1: [1, 3, 2, 4]
% a) Seleccionado 2: [2, 4, 1, 3]
% a) Seleccionado 3: [3, 1, 4, 2]
% a) Seleccionado 4: [2, 4, 1, 3]
% a) Seleccionado 5: [3, 1, 4, 2]
% a) Seleccionado 6: [1, 4, 2, 3]

% 4) Cruce de un punto
% Entre el S1 y el S2 hacemos cruce en el punto 2
% Hijo 1 = [1, 3, 1, 3]
% Hijo 2 = [2, 4, 2, 4]

% Entre el S3 y S4 hacemos cruce en el punto 1
% Hijo 1 = [3, 4, 1, 3]
% Hijo 2 = [2, 1, 4, 2]

% Entre el S5 y S6 hacemos cruce en el punto 3
% Hijo 1 = [3, 1, 4, 3]
% Hijo 2 = [1, 4, 2, 2]

% Con lo que los hijos quedarían de la forma:
% a) Hijo 1: [1, 3, 1, 3]
% a) Hijo 2: [2, 4, 2, 4]
% a) Hijo 3: [3, 4, 1, 3]
% a) Hijo 4: [2, 1, 4, 2]
% a) Hijo 5: [3, 1, 4, 3]
% a) Hijo 6: [1, 4, 2, 2]

% 5) Mutación del 0.1 por gen (Se cambia a un valor aleatorio entre 1 y 4)
% Suponemos que los que mutan en este caso son los hijos:
% H1 (Gen 3)
% [1, 3, 1, 3] -> [1, 3, 4, 3]
% H4 (Gen 2)
% [2, 1, 4, 2] -> [2, 3, 4, 2]
% H6 (Gen 1 y 4)
% [1, 4, 2, 2] -> [4, 4, 2, 1]

% 6) Con lo que la nueva población resultante sería:
% a) Individuo 1: [1, 3, 4, 3]
% a) Individuo 2: [2, 4, 2, 4]
% a) Individuo 3: [3, 4, 1, 3]
% a) Individuo 4: [2, 3, 4, 2]
% a) Individuo 5: [3, 1, 4, 3]
% a) Individuo 6: [4, 4, 2, 1]

%% Segunda generación
% 1) Población de 6 individuos
% a) Individuo 1: [1, 3, 4, 3]
% a) Individuo 2: [2, 4, 2, 4]
% a) Individuo 3: [3, 4, 1, 3]
% a) Individuo 4: [2, 3, 4, 2]
% a) Individuo 5: [3, 1, 4, 3]
% a) Individuo 6: [4, 4, 2, 1]

% 2a) Evaluación de aptitud: Número de conflictos entre reinas

% Evaluación para el individuo 1: [1, 3, 4, 3]
% Conflictos de fila: Reina col2 y col4 ambas en fila 3 -> 1 conflicto
% Conflictos diagonales:
% - Reina en (1,1) vs Reina en (3,2): |1-3| = 2, |1-2| = 1, no diagonal
% - Reina en (1,1) vs Reina en (4,3): |1-4| = 3, |1-3| = 2, no diagonal
% - Reina en (1,1) vs Reina en (3,4): |1-3| = 2, |1-4| = 3, no diagonal
% - Reina en (3,2) vs Reina en (4,3): |3-4| = 1, |2-3| = 1, SÍ diagonal
% - Reina en (3,2) vs Reina en (3,4): mismo fila, ya contado
% - Reina en (4,3) vs Reina en (3,4): |4-3| = 1, |3-4| = 1, SÍ diagonal
% Total conflictos: 1 (fila) + 2 (diagonales) = 3

% Evaluación para el individuo 2: [2, 4, 2, 4]
% Conflictos de fila: Reina col1 y col3 ambas en fila 2 -> 1 conflicto
%                    Reina col2 y col4 ambas en fila 4 -> 1 conflicto
% Conflictos diagonales:
% - Reina en (2,1) vs Reina en (4,2): |2-4| = 2, |1-2| = 1, no diagonal
% - Reina en (2,1) vs Reina en (2,3): misma fila, ya contado
% - Reina en (2,1) vs Reina en (4,4): |2-4| = 2, |1-4| = 3, no diagonal
% - Reina en (4,2) vs Reina en (2,3): |4-2| = 2, |2-3| = 1, no diagonal
% - Reina en (4,2) vs Reina en (4,4): misma fila, ya contado
% - Reina en (2,3) vs Reina en (4,4): |2-4| = 2, |3-4| = 1, no diagonal
% Total conflictos: 2 (filas) + 0 (diagonales) = 2

% Evaluación para el individuo 3: [3, 4, 1, 3]
% Conflictos de fila: Reina col1 y col4 ambas en fila 3 -> 1 conflicto
% Conflictos diagonales:
% - Reina en (3,1) vs Reina en (4,2): |3-4| = 1, |1-2| = 1, SÍ diagonal
% - Reina en (3,1) vs Reina en (1,3): |3-1| = 2, |1-3| = 2, SÍ diagonal
% - Reina en (3,1) vs Reina en (3,4): misma fila, ya contado
% - Reina en (4,2) vs Reina en (1,3): |4-1| = 3, |2-3| = 1, no diagonal
% - Reina en (4,2) vs Reina en (3,4): |4-3| = 1, |2-4| = 2, no diagonal
% - Reina en (1,3) vs Reina en (3,4): |1-3| = 2, |3-4| = 1, no diagonal
% Total conflictos: 1 (fila) + 2 (diagonales) = 3

% Evaluación para el individuo 4: [2, 3, 4, 2]
% Conflictos de fila: Reina col1 y col4 ambas en fila 2 -> 1 conflicto
% Conflictos diagonales:
% - Reina en (2,1) vs Reina en (3,2): |2-3| = 1, |1-2| = 1, SÍ diagonal
% - Reina en (2,1) vs Reina en (4,3): |2-4| = 2, |1-3| = 2, SÍ diagonal
% - Reina en (2,1) vs Reina en (2,4): misma fila, ya contado
% - Reina en (3,2) vs Reina en (4,3): |3-4| = 1, |2-3| = 1, SÍ diagonal
% - Reina en (3,2) vs Reina en (2,4): |3-2| = 1, |2-4| = 2, no diagonal
% - Reina en (4,3) vs Reina en (2,4): |4-2| = 2, |3-4| = 1, no diagonal
% Total conflictos: 1 (fila) + 3 (diagonales) = 4

% Evaluación para el individuo 5: [3, 1, 4, 3]
% Conflictos de fila: Reina col1 y col4 ambas en fila 3 -> 1 conflicto
% Conflictos diagonales:
% - Reina en (3,1) vs Reina en (1,2): |3-1| = 2, |1-2| = 1, no diagonal
% - Reina en (3,1) vs Reina en (4,3): |3-4| = 1, |1-3| = 2, no diagonal
% - Reina en (3,1) vs Reina en (3,4): misma fila, ya contado
% - Reina en (1,2) vs Reina en (4,3): |1-4| = 3, |2-3| = 1, no diagonal
% - Reina en (1,2) vs Reina en (3,4): |1-3| = 2, |2-4| = 2, SÍ diagonal
% - Reina en (4,3) vs Reina en (3,4): |4-3| = 1, |3-4| = 1, SÍ diagonal
% Total conflictos: 1 (fila) + 2 (diagonales) = 3

% Evaluación para el individuo 6: [4, 4, 2, 1]
% Conflictos de fila: Reina col1 y col2 ambas en fila 4 -> 1 conflicto
% Conflictos diagonales:
% - Reina en (4,1) vs Reina en (4,2): misma fila, ya contado
% - Reina en (4,1) vs Reina en (2,3): |4-2| = 2, |1-3| = 2, SÍ diagonal
% - Reina en (4,1) vs Reina en (1,4): |4-1| = 3, |1-4| = 3, SÍ diagonal
% - Reina en (4,2) vs Reina en (2,3): |4-2| = 2, |2-3| = 1, no diagonal
% - Reina en (4,2) vs Reina en (1,4): |4-1| = 3, |2-4| = 2, no diagonal
% - Reina en (2,3) vs Reina en (1,4): |2-1| = 1, |3-4| = 1, SÍ diagonal
% Total conflictos: 1 (fila) + 3 (diagonales) = 4

% Aptitudes:
% Para el individuo 1: 3 conflictos -> Aptitud = 10 - 3 = 7
% Para el individuo 2: 2 conflictos -> Aptitud = 10 - 2 = 8
% Para el individuo 3: 3 conflictos -> Aptitud = 10 - 3 = 7
% Para el individuo 4: 4 conflictos -> Aptitud = 10 - 4 = 6
% Para el individuo 5: 3 conflictos -> Aptitud = 10 - 3 = 7
% Para el individuo 6: 4 conflictos -> Aptitud = 10 - 4 = 6

% 2b) Tabla resumen indicando el fitness
% Individuo 1 Fitness: 7
% Individuo 2 Fitness: 8
% Individuo 3 Fitness: 7
% Individuo 4 Fitness: 6
% Individuo 5 Fitness: 7
% Individuo 6 Fitness: 6

% 3) Selección por torneo binario
% Se desean hacer 6 torneos en total
% Los participantes del torneo aleatoriamente son:

% Individuo 1 (7) - Individuo 2 (8)
% Individuo 3 (7) - Individuo 4 (6)
% Individuo 5 (7) - Individuo 6 (6)
% Individuo 2 (8) - Individuo 3 (7)
% Individuo 1 (7) - Individuo 5 (7)
% Individuo 4 (6) - Individuo 2 (8)

% Por lo que los ganadores del torneo son:
% T1: I2
% T2: I3
% T3: I5
% T4: I2
% T5: I1 (empate, se elige al azar)
% T6: I2

% Entonces los seleccionados actuales son:
% a) Seleccionado 1: [2, 4, 2, 4]
% a) Seleccionado 2: [3, 4, 1, 3]
% a) Seleccionado 3: [3, 1, 4, 3]
% a) Seleccionado 4: [2, 4, 2, 4]
% a) Seleccionado 5: [1, 3, 4, 3]
% a) Seleccionado 6: [2, 4, 2, 4]

% 4) Cruce de un punto
% Entre el S1 y el S2 hacemos cruce en el punto 2
% Hijo 1 = [2, 4, 1, 3]
% Hijo 2 = [3, 4, 2, 4]

% Entre el S3 y S4 hacemos cruce en el punto 3
% Hijo 1 = [3, 1, 4, 4]
% Hijo 2 = [2, 4, 2, 3]

% Entre el S5 y S6 hacemos cruce en el punto 1
% Hijo 1 = [1, 4, 2, 4]
% Hijo 2 = [2, 3, 4, 3]

% Con lo que los hijos quedarían de la forma:
% a) Hijo 1: [2, 4, 1, 3]
% a) Hijo 2: [3, 4, 2, 4]
% a) Hijo 3: [3, 1, 4, 4]
% a) Hijo 4: [2, 4, 2, 3]
% a) Hijo 5: [1, 4, 2, 4]
% a) Hijo 6: [2, 3, 4, 3]

% 5) Mutación del 0.1 por gen
% Suponemos que los que mutan en este caso son los hijos:
% H2 (Gen 4)
% [3, 4, 2, 4] -> [3, 4, 2, 1]
% H3 (Gen 1 y 4)
% [3, 1, 4, 4] -> [1, 1, 4, 2]
% H5 (Gen 2)
% [1, 4, 2, 4] -> [1, 2, 2, 4]

% 6) Con lo que la nueva población resultante sería:
% a) Individuo 1: [2, 4, 1, 3]
% a) Individuo 2: [3, 4, 2, 1]
% a) Individuo 3: [1, 1, 4, 2]
% a) Individuo 4: [2, 4, 2, 3]
% a) Individuo 5: [1, 2, 2, 4]
% a) Individuo 6: [2, 3, 4, 3]

%% Tercera generación
% 1) Población de 6 individuos
% a) Individuo 1: [2, 4, 1, 3]
% a) Individuo 2: [3, 4, 2, 1]
% a) Individuo 3: [1, 1, 4, 2]
% a) Individuo 4: [2, 4, 2, 3]
% a) Individuo 5: [1, 2, 2, 4]
% a) Individuo 6: [2, 3, 4, 3]

% 2a) Evaluación de aptitud: Número de conflictos entre reinas

% Evaluación para el individuo 1: [2, 4, 1, 3]
% Conflictos de fila: ninguno (todas en filas diferentes)
% Conflictos diagonales:
% - Reina en (2,1) vs Reina en (4,2): |2-4| = 2, |1-2| = 1, no diagonal
% - Reina en (2,1) vs Reina en (1,3): |2-1| = 1, |1-3| = 2, no diagonal
% - Reina en (2,1) vs Reina en (3,4): |2-3| = 1, |1-4| = 3, no diagonal
% - Reina en (4,2) vs Reina en (1,3): |4-1| = 3, |2-3| = 1, no diagonal
% - Reina en (4,2) vs Reina en (3,4): |4-3| = 1, |2-4| = 2, no diagonal
% - Reina en (1,3) vs Reina en (3,4): |1-3| = 2, |3-4| = 1, no diagonal
% Total conflictos: 0 (¡Solución perfecta!)

% Evaluación para el individuo 2: [3, 4, 2, 1]
% Conflictos de fila: ninguno
% Conflictos diagonales:
% - Reina en (3,1) vs Reina en (4,2): |3-4| = 1, |1-2| = 1, SÍ diagonal
% - Reina en (3,1) vs Reina en (2,3): |3-2| = 1, |1-3| = 2, no diagonal
% - Reina en (3,1) vs Reina en (1,4): |3-1| = 2, |1-4| = 3, no diagonal
% - Reina en (4,2) vs Reina en (2,3): |4-2| = 2, |2-3| = 1, no diagonal
% - Reina en (4,2) vs Reina en (1,4): |4-1| = 3, |2-4| = 2, no diagonal
% - Reina en (2,3) vs Reina en (1,4): |2-1| = 1, |3-4| = 1, SÍ diagonal
% Total conflictos: 2

% Evaluación para el individuo 3: [1, 1, 4, 2]
% Conflictos de fila: Reina col1 y col2 ambas en fila 1 -> 1 conflicto
% Conflictos diagonales:
% - Reina en (1,1) vs Reina en (1,2): misma fila, ya contado
% - Reina en (1,1) vs Reina en (4,3): |1-4| = 3, |1-3| = 2, no diagonal
% - Reina en (1,1) vs Reina en (2,4): |1-2| = 1, |1-4| = 3, no diagonal
% - Reina en (1,2) vs Reina en (4,3): |1-4| = 3, |2-3| = 1, no diagonal
% - Reina en (1,2) vs Reina en (2,4): |1-2| = 1, |2-4| = 2, no diagonal
% - Reina en (4,3) vs Reina en (2,4): |4-2| = 2, |3-4| = 1, no diagonal
% Total conflictos: 1

% Evaluación para el individuo 4: [2, 4, 2, 3]
% Conflictos de fila: Reina col1 y col3 ambas en fila 2 -> 1 conflicto
% Conflictos diagonales:
% - Reina en (2,1) vs Reina en (4,2): |2-4| = 2, |1-2| = 1, no diagonal
% - Reina en (2,1) vs Reina en (2,3): misma fila, ya contado
% - Reina en (2,1) vs Reina en (3,4): |2-3| = 1, |1-4| = 3, no diagonal
% - Reina en (4,2) vs Reina en (2,3): |4-2| = 2, |2-3| = 1, no diagonal
% - Reina en (4,2) vs Reina en (3,4): |4-3| = 1, |2-4| = 2, no diagonal
% - Reina en (2,3) vs Reina en (3,4): |2-3| = 1, |3-4| = 1, SÍ diagonal
% Total conflictos: 1 (fila) + 1 (diagonal) = 2

% Evaluación para el individuo 5: [1, 2, 2, 4]
% Conflictos de fila: Reina col2 y col3 ambas en fila 2 -> 1 conflicto
% Conflictos diagonales:
% - Reina en (1,1) vs Reina en (2,2): |1-2| = 1, |1-2| = 1, SÍ diagonal
% - Reina en (1,1) vs Reina en (2,3): |1-2| = 1, |1-3| = 2, no diagonal
% - Reina en (1,1) vs Reina en (4,4): |1-4| = 3, |1-4| = 3, SÍ diagonal
% - Reina en (2,2) vs Reina en (2,3): misma fila, ya contado
% - Reina en (2,2) vs Reina en (4,4): |2-4| = 2, |2-4| = 2, SÍ diagonal
% - Reina en (2,3) vs Reina en (4,4): |2-4| = 2, |3-4| = 1, no diagonal
% Total conflictos: 1 (fila) + 3 (diagonales) = 4

% Evaluación para el individuo 6: [2, 3, 4, 3]
% Conflictos de fila: Reina col2 y col4 ambas en fila 3 -> 1 conflicto
% Conflictos diagonales:
% - Reina en (2,1) vs Reina en (3,2): |2-3| = 1, |1-2| = 1, SÍ diagonal
% - Reina en (2,1) vs Reina en (4,3): |2-4| = 2, |1-3| = 2, SÍ diagonal
% - Reina en (2,1) vs Reina en (3,4): |2-3| = 1, |1-4| = 3, no diagonal
% - Reina en (3,2) vs Reina en (4,3): |3-4| = 1, |2-3| = 1, SÍ diagonal
% - Reina en (3,2) vs Reina en (3,4): misma fila, ya contado
% - Reina en (4,3) vs Reina en (3,4): |4-3| = 1, |3-4| = 1, SÍ diagonal
% Total conflictos: 1 (fila) + 4 (diagonales) = 5

% Aptitudes:
% Para el individuo 1: 0 conflictos -> Aptitud = 10 - 0 = 10 (¡Solución perfecta!)
% Para el individuo 2: 2 conflictos -> Aptitud = 10 - 2 = 8
% Para el individuo 3: 1 conflicto -> Aptitud = 10 - 1 = 9
% Para el individuo 4: 2 conflictos -> Aptitud = 10 - 2 = 8
% Para el individuo 5: 4 conflictos -> Aptitud = 10 - 4 = 6
% Para el individuo 6: 5 conflictos -> Aptitud = 10 - 5 = 5

% 2b) Tabla resumen indicando el fitness
% Individuo 1 Fitness: 10
% Individuo 2 Fitness: 8
% Individuo 3 Fitness: 9
% Individuo 4 Fitness: 8
% Individuo 5 Fitness: 6
% Individuo 6 Fitness: 5

% 3) Selección por torneo binario
% Se desean hacer 6 torneos en total
% Los participantes del torneo aleatoriamente son:

% Individuo 1 (10) - Individuo 2 (8)
% Individuo 3 (9) - Individuo 4 (8)
% Individuo 5 (6) - Individuo 6 (5)
% Individuo 1 (10) - Individuo 3 (9)
% Individuo 2 (8) - Individuo 4 (8)
% Individuo 1 (10) - Individuo 5 (6)

% Por lo que los ganadores del torneo son:
% T1: I1
% T2: I3
% T3: I5
% T4: I1
% T5: I2 (empate, se elige al azar)
% T6: I1

% Entonces los seleccionados actuales son:
% a) Seleccionado 1: [2, 4, 1, 3]
% a) Seleccionado 2: [1, 1, 4, 2]
% a) Seleccionado 3: [1, 2, 2, 4]
% a) Seleccionado 4: [2, 4, 1, 3]
% a) Seleccionado 5: [3, 4, 2, 1]
% a) Seleccionado 6: [2, 4, 1, 3]

% 4) Cruce de un punto
% Entre el S1 y el S2 hacemos cruce en el punto 2
% Hijo 1 = [2, 4, 4, 2]
% Hijo 2 = [1, 1, 1, 3]

% Entre el S3 y S4 hacemos cruce en el punto 3
% Hijo 1 = [1, 2, 2, 3]
% Hijo 2 = [2, 4, 1, 4]

% Entre el S5 y S6 hacemos cruce en el punto 1
% Hijo 1 = [3, 4, 1, 3]
% Hijo 2 = [2, 4, 2, 1]

% Con lo que los hijos quedarían de la forma:
% a) Hijo 1: [2, 4, 4, 2]
% a) Hijo 2: [1, 1, 1, 3]
% a) Hijo 3: [1, 2, 2, 3]
% a) Hijo 4: [2, 4, 1, 4]
% a) Hijo 5: [3, 4, 1, 3]
% a) Hijo 6: [2, 4, 2, 1]

% 5) Mutación del 0.1 por gen
% Suponemos que los que mutan en este caso son los hijos:
% H1 (Gen 3)
% [2, 4, 4, 2] -> [2, 4, 1, 2]
% H2 (Gen 1 y 3)
% [1, 1, 1, 3] -> [3, 1, 4, 3]
% H4 (Gen 4)
% [2, 4, 1, 4] -> [2, 4, 1, 3]

% 6) Con lo que la nueva población resultante sería:
% a) Individuo 1: [2, 4, 1, 2]
% a) Individuo 2: [3, 1, 4, 3]
% a) Individuo 3: [1, 2, 2, 3]
% a) Individuo 4: [2, 4, 1, 3]
% a) Individuo 5: [3, 4, 1, 3]
% a) Individuo 6: [2, 4, 2, 1]

%% Evaluación de la nueva población
% 1) Población de 6 individuos
% a) Individuo 1: [2, 4, 1, 2]
% a) Individuo 2: [3, 1, 4, 3]
% a) Individuo 3: [1, 2, 2, 3]
% a) Individuo 4: [2, 4, 1, 3]
% a) Individuo 5: [3, 4, 1, 3]
% a) Individuo 6: [2, 4, 2, 1]

% 2a) Evaluación de aptitud: Número de conflictos entre reinas

% Evaluación para el individuo 1: [2, 4, 1, 2]
% Conflictos de fila: Reina col1 y col4 ambas en fila 2 -> 1 conflicto
% Conflictos diagonales:
% - Reina en (2,1) vs Reina en (4,2): |2-4| = 2, |1-2| = 1, no diagonal
% - Reina en (2,1) vs Reina en (1,3): |2-1| = 1, |1-3| = 2, no diagonal
% - Reina en (2,1) vs Reina en (2,4): misma fila, ya contado
% - Reina en (4,2) vs Reina en (1,3): |4-1| = 3, |2-3| = 1, no diagonal
% - Reina en (4,2) vs Reina en (2,4): |4-2| = 2, |2-4| = 2, SÍ diagonal
% - Reina en (1,3) vs Reina en (2,4): |1-2| = 1, |3-4| = 1, SÍ diagonal
% Total conflictos: 1 (fila) + 2 (diagonales) = 3

% Evaluación para el individuo 2: [3, 1, 4, 3]
% Conflictos de fila: Reina col1 y col4 ambas en fila 3 -> 1 conflicto
% Conflictos diagonales:
% - Reina en (3,1) vs Reina en (1,2): |3-1| = 2, |1-2| = 1, no diagonal
% - Reina en (3,1) vs Reina en (4,3): |3-4| = 1, |1-3| = 2, no diagonal
% - Reina en (3,1) vs Reina en (3,4): misma fila, ya contado
% - Reina en (1,2) vs Reina en (4,3): |1-4| = 3, |2-3| = 1, no diagonal
% - Reina en (1,2) vs Reina en (3,4): |1-3| = 2, |2-4| = 2, SÍ diagonal
% - Reina en (4,3) vs Reina en (3,4): |4-3| = 1, |3-4| = 1, SÍ diagonal
% Total conflictos: 1 (fila) + 2 (diagonales) = 3

% Evaluación para el individuo 3: [1, 2, 2, 3]
% Conflictos de fila: Reina col2 y col3 ambas en fila 2 -> 1 conflicto
% Conflictos diagonales:
% - Reina en (1,1) vs Reina en (2,2): |1-2| = 1, |1-2| = 1, SÍ diagonal
% - Reina en (1,1) vs Reina en (2,3): |1-2| = 1, |1-3| = 2, no diagonal
% - Reina en (1,1) vs Reina en (3,4): |1-3| = 2, |1-4| = 3, no diagonal
% - Reina en (2,2) vs Reina en (2,3): misma fila, ya contado
% - Reina en (2,2) vs Reina en (3,4): |2-3| = 1, |2-4| = 2, no diagonal
% - Reina en (2,3) vs Reina en (3,4): |2-3| = 1, |3-4| = 1, SÍ diagonal
% Total conflictos: 1 (fila) + 2 (diagonales) = 3

% Evaluación para el individuo 4: [2, 4, 1, 3]
% Ya sabemos que este individuo tiene 0 conflictos (¡Solución perfecta!)

% Evaluación para el individuo 5: [3, 4, 1, 3]
% Conflictos de fila: Reina col1 y col4 ambas en fila 3 -> 1 conflicto
% Conflictos diagonales:
% - Reina en (3,1) vs Reina en (4,2): |3-4| = 1, |1-2| = 1, SÍ diagonal
% - Reina en (3,1) vs Reina en (1,3): |3-1| = 2, |1-3| = 2, SÍ diagonal
% - Reina en (3,1) vs Reina en (3,4): misma fila, ya contado
% - Reina en (4,2) vs Reina en (1,3): |4-1| = 3, |2-3| = 1, no diagonal
% - Reina en (4,2) vs Reina en (3,4): |4-3| = 1, |2-4| = 2, no diagonal
% - Reina en (1,3) vs Reina en (3,4): |1-3| = 2, |3-4| = 1, no diagonal
% Total conflictos: 1 (fila) + 2 (diagonales) = 3

% Evaluación para el individuo 6: [2, 4, 2, 1]
% Conflictos de fila: Reina col1 y col3 ambas en fila 2 -> 1 conflicto
% Conflictos diagonales:
% - Reina en (2,1) vs Reina en (4,2): |2-4| = 2, |1-2| = 1, no diagonal
% - Reina en (2,1) vs Reina en (2,3): misma fila, ya contado
% - Reina en (2,1) vs Reina en (1,4): |2-1| = 1, |1-4| = 3, no diagonal
% - Reina en (4,2) vs Reina en (2,3): |4-2| = 2, |2-3| = 1, no diagonal
% - Reina en (4,2) vs Reina en (1,4): |4-1| = 3, |2-4| = 2, no diagonal
% - Reina en (2,3) vs Reina en (1,4): |2-1| = 1, |3-4| = 1, SÍ diagonal
% Total conflictos: 1 (fila) + 1 (diagonal) = 2

% Aptitudes:
% Para el individuo 1: 3 conflictos -> Aptitud = 10 - 3 = 7
% Para el individuo 2: 3 conflictos -> Aptitud = 10 - 3 = 7
% Para el individuo 3: 3 conflictos -> Aptitud = 10 - 3 = 7
% Para el individuo 4: 0 conflictos -> Aptitud = 10 - 0 = 10 (¡Solución perfecta!)
% Para el individuo 5: 3 conflictos -> Aptitud = 10 - 3 = 7
% Para el individuo 6: 2 conflictos -> Aptitud = 10 - 2 = 8

% 2b) Tabla resumen indicando el fitness final
% Individuo 1 Fitness: 7
% Individuo 2 Fitness: 7
% Individuo 3 Fitness: 7
% Individuo 4 Fitness: 10
% Individuo 5 Fitness: 7
% Individuo 6 Fitness: 8

%% Conclusiones
% El algoritmo encontró una solución perfecta para el problema de las 4 reinas!
% La solución es: [2, 4, 1, 3] que significa:
% - Reina en columna 1, fila 2
% - Reina en columna 2, fila 4
% - Reina en columna 3, fila 1
% - Reina en columna 4, fila 3
% 
% El tablero quedaría así:
% [0, 0, 1, 0]  (fila 1)
% [1, 0, 0, 0]  (fila 2)
% [0, 0, 0, 1]  (fila 3)
% [0, 1, 0, 0]  (fila 4)
%
% Donde 1 representa una reina y 0 una casilla vacía.
% 
% Se puede ver que el algoritmo genético funcionó bien para este problema.
% Los operadores de selección, cruce y mutación permitieron explorar el 
% espacio de soluciones y encontrar una configuración donde las 4 reinas
% no se atacan entre sí. Con más generaciones se podrían encontrar más
% soluciones óptimas o mejorar la convergencia hacia la solución perfecta.

%%

%%

%%

%%

%%

%%

%%

%% Algoritmo de optimización para el problema de la mochila con algoritmo genético

% Problema: Mochila con capacidad de 10 kg
% Elementos disponibles: 5 objetos
% Peso de cada objeto: [2, 3, 4, 5, 1] kg
% Valor de cada objeto: [3, 4, 5, 6, 2] puntos
% Cromosoma: 5 genes binarios (1 = incluir objeto, 0 = no incluir)

% Primera generación
% Se inicializa la población de la siguiente manera:
% 1) Población de 6 individuos
% a) Individuo 1: [1, 0, 1, 0, 1] -> objetos 1, 3, 5
% b) Individuo 2: [0, 1, 0, 1, 0] -> objetos 2, 4
% c) Individuo 3: [1, 1, 0, 0, 1] -> objetos 1, 2, 5
% d) Individuo 4: [0, 0, 1, 1, 0] -> objetos 3, 4
% e) Individuo 5: [1, 0, 0, 1, 1] -> objetos 1, 4, 5
% f) Individuo 6: [0, 1, 1, 0, 0] -> objetos 2, 3

% Donde:
% Objeto 1: peso=2, valor=3
% Objeto 2: peso=3, valor=4
% Objeto 3: peso=4, valor=5
% Objeto 4: peso=5, valor=6
% Objeto 5: peso=1, valor=2

% 2a) Evaluación de aptitud: Valor total si no excede capacidad
% Función de aptitud: f(x) = valor_total si peso_total <= 10, sino 0

% Para el individuo 1: Objetos [1,3,5] -> peso=2+4+1=7, valor=3+5+2=10
% Aptitud total: 10 (válido)

% Para el individuo 2: Objetos [2,4] -> peso=3+5=8, valor=4+6=10
% Aptitud total: 10 (válido)

% Para el individuo 3: Objetos [1,2,5] -> peso=2+3+1=6, valor=3+4+2=9
% Aptitud total: 9 (válido)

% Para el individuo 4: Objetos [3,4] -> peso=4+5=9, valor=5+6=11
% Aptitud total: 11 (válido)

% Para el individuo 5: Objetos [1,4,5] -> peso=2+5+1=8, valor=3+6+2=11
% Aptitud total: 11 (válido)

% Para el individuo 6: Objetos [2,3] -> peso=3+4=7, valor=4+5=9
% Aptitud total: 9 (válido)

% 2b) Tabla resumen indicando el fitness
% Individuo 1 Fitness: 10
% Individuo 2 Fitness: 10
% Individuo 3 Fitness: 9
% Individuo 4 Fitness: 11
% Individuo 5 Fitness: 11
% Individuo 6 Fitness: 9

% 3) Selección por torneo binario
% Se desean hacer 6 torneos en total
% Los participantes del torneo aleatoriamente son:

% Individuo 1 (10) - Individuo 6 (9)
% Individuo 4 (11) - Individuo 2 (10)
% Individuo 6 (9) - Individuo 3 (9)
% Individuo 1 (10) - Individuo 5 (11)
% Individuo 4 (11) - Individuo 6 (9)
% Individuo 2 (10) - Individuo 5 (11)

% Por lo que los ganadores del torneo son:
% T1: I1
% T2: I4
% T3: I6
% T4: I5
% T5: I4
% T6: I5

% Entonces los seleccionados actuales son:
% a) Seleccionado 1: [1, 0, 1, 0, 1]
% b) Seleccionado 2: [0, 0, 1, 1, 0]
% c) Seleccionado 3: [0, 1, 1, 0, 0]
% d) Seleccionado 4: [1, 0, 0, 1, 1]
% e) Seleccionado 5: [0, 0, 1, 1, 0]
% f) Seleccionado 6: [1, 0, 0, 1, 1]

% 4) Cruce de un punto
% Entre el S1 y el S2 hacemos cruce en el punto 2
% Hijo 1 = [1, 0, 1, 1, 0]
% Hijo 2 = [0, 0, 1, 0, 1]

% Entre el S5 y S6 hacemos cruce en el punto 3
% Hijo 1 = [0, 0, 1, 1, 1]
% Hijo 2 = [1, 0, 0, 1, 0]

% En los otros no se realiza cruce
% Con lo que los hijos quedarían de la forma
% a) Hijo 1: [1, 0, 1, 1, 0]
% b) Hijo 2: [0, 0, 1, 0, 1]
% c) Hijo 3: [0, 1, 1, 0, 0]
% d) Hijo 4: [1, 0, 0, 1, 1]
% e) Hijo 5: [0, 0, 1, 1, 1]
% f) Hijo 6: [1, 0, 0, 1, 0]

% 5) Mutación del 0.1 por gen (Se cambia de 0 a 1 o viceversa)
% Suponemos que los que mutan en este caso son los hijos
% H1 (Gen 2)
% [1, 0, 1, 1, 0] -> [1, 1, 1, 1, 0]
% H3 (Gen 5)
% [0, 1, 1, 0, 0] -> [0, 1, 1, 0, 1]
% H5 (Gen 1)
% [0, 0, 1, 1, 1] -> [1, 0, 1, 1, 1]

% 6) Con lo que la nueva población resultante sería
% a) Individuo 1: [1, 1, 1, 1, 0]
% b) Individuo 2: [0, 0, 1, 0, 1]
% c) Individuo 3: [0, 1, 1, 0, 1]
% d) Individuo 4: [1, 0, 0, 1, 1]
% e) Individuo 5: [1, 0, 1, 1, 1]
% f) Individuo 6: [1, 0, 0, 1, 0]

%% Segunda generación
% 1) Población de 6 individuos
% a) Individuo 1: [1, 1, 1, 1, 0]
% b) Individuo 2: [0, 0, 1, 0, 1]
% c) Individuo 3: [0, 1, 1, 0, 1]
% d) Individuo 4: [1, 0, 0, 1, 1]
% e) Individuo 5: [1, 0, 1, 1, 1]
% f) Individuo 6: [1, 0, 0, 1, 0]

% 2a) Evaluación de aptitud
% Para el individuo 1: Objetos [1,2,3,4] -> peso=2+3+4+5=14, valor=0
% Aptitud total: 0 (inválido, excede capacidad)

% Para el individuo 2: Objetos [3,5] -> peso=4+1=5, valor=5+2=7
% Aptitud total: 7 (válido)

% Para el individuo 3: Objetos [2,3,5] -> peso=3+4+1=8, valor=4+5+2=11
% Aptitud total: 11 (válido)

% Para el individuo 4: Objetos [1,4,5] -> peso=2+5+1=8, valor=3+6+2=11
% Aptitud total: 11 (válido)

% Para el individuo 5: Objetos [1,3,4,5] -> peso=2+4+5+1=12, valor=0
% Aptitud total: 0 (inválido, excede capacidad)

% Para el individuo 6: Objetos [1,4] -> peso=2+5=7, valor=3+6=9
% Aptitud total: 9 (válido)

% 2b) Tabla resumen indicando el fitness
% Individuo 1 Fitness: 0
% Individuo 2 Fitness: 7
% Individuo 3 Fitness: 11
% Individuo 4 Fitness: 11
% Individuo 5 Fitness: 0
% Individuo 6 Fitness: 9

% 3) Selección por torneo binario
% Los participantes del torneo aleatoriamente son:

% Individuo 1 (0) - Individuo 6 (9)
% Individuo 3 (11) - Individuo 2 (7)
% Individuo 6 (9) - Individuo 4 (11)
% Individuo 1 (0) - Individuo 3 (11)
% Individuo 4 (11) - Individuo 5 (0)
% Individuo 2 (7) - Individuo 6 (9)

% Por lo que los ganadores del torneo son:
% T1: I6
% T2: I3
% T3: I4
% T4: I3
% T5: I4
% T6: I6

% Entonces los seleccionados actuales son:
% a) Seleccionado 1: [1, 0, 0, 1, 0]
% b) Seleccionado 2: [0, 1, 1, 0, 1]
% c) Seleccionado 3: [1, 0, 0, 1, 1]
% d) Seleccionado 4: [0, 1, 1, 0, 1]
% e) Seleccionado 5: [1, 0, 0, 1, 1]
% f) Seleccionado 6: [1, 0, 0, 1, 0]

% 4) Cruce de un punto
% Entre el S1 y el S2 hacemos cruce en el punto 3
% Hijo 1 = [1, 0, 0, 0, 1]
% Hijo 2 = [0, 1, 1, 1, 0]

% Entre el S3 y S4 hacemos cruce en el punto 1
% Hijo 1 = [1, 1, 1, 0, 1]
% Hijo 2 = [0, 0, 0, 1, 1]

% En los otros no se realiza cruce
% Con lo que los hijos quedarían de la forma
% a) Hijo 1: [1, 0, 0, 0, 1]
% b) Hijo 2: [0, 1, 1, 1, 0]
% c) Hijo 3: [1, 1, 1, 0, 1]
% d) Hijo 4: [0, 0, 0, 1, 1]
% e) Hijo 5: [1, 0, 0, 1, 1]
% f) Hijo 6: [1, 0, 0, 1, 0]

% 5) Mutación del 0.1 por gen
% Suponemos que los que mutan en este caso son los hijos
% H2 (Gen 4)
% [0, 1, 1, 1, 0] -> [0, 1, 1, 0, 0]
% H4 (Gen 2)
% [0, 0, 0, 1, 1] -> [0, 1, 0, 1, 1]

% 6) Con lo que la nueva población resultante sería
% a) Individuo 1: [1, 0, 0, 0, 1]
% b) Individuo 2: [0, 1, 1, 0, 0]
% c) Individuo 3: [1, 1, 1, 0, 1]
% d) Individuo 4: [0, 1, 0, 1, 1]
% e) Individuo 5: [1, 0, 0, 1, 1]
% f) Individuo 6: [1, 0, 0, 1, 0]

%% Tercera generación
% 1) Población de 6 individuos
% a) Individuo 1: [1, 0, 0, 0, 1]
% b) Individuo 2: [0, 1, 1, 0, 0]
% c) Individuo 3: [1, 1, 1, 0, 1]
% d) Individuo 4: [0, 1, 0, 1, 1]
% e) Individuo 5: [1, 0, 0, 1, 1]
% f) Individuo 6: [1, 0, 0, 1, 0]

% 2a) Evaluación de aptitud
% Para el individuo 1: Objetos [1,5] -> peso=2+1=3, valor=3+2=5
% Aptitud total: 5 (válido)

% Para el individuo 2: Objetos [2,3] -> peso=3+4=7, valor=4+5=9
% Aptitud total: 9 (válido)

% Para el individuo 3: Objetos [1,2,3,5] -> peso=2+3+4+1=10, valor=3+4+5+2=14
% Aptitud total: 14 (válido)

% Para el individuo 4: Objetos [2,4,5] -> peso=3+5+1=9, valor=4+6+2=12
% Aptitud total: 12 (válido)

% Para el individuo 5: Objetos [1,4,5] -> peso=2+5+1=8, valor=3+6+2=11
% Aptitud total: 11 (válido)

% Para el individuo 6: Objetos [1,4] -> peso=2+5=7, valor=3+6=9
% Aptitud total: 9 (válido)

% 2b) Tabla resumen indicando el fitness
% Individuo 1 Fitness: 5
% Individuo 2 Fitness: 9
% Individuo 3 Fitness: 14
% Individuo 4 Fitness: 12
% Individuo 5 Fitness: 11
% Individuo 6 Fitness: 9

% 3) Selección por torneo binario
% Los participantes del torneo aleatoriamente son:

% Individuo 1 (5) - Individuo 3 (14)
% Individuo 4 (12) - Individuo 2 (9)
% Individuo 3 (14) - Individuo 6 (9)
% Individuo 2 (9) - Individuo 5 (11)
% Individuo 5 (11) - Individuo 6 (9)
% Individuo 3 (14) - Individuo 4 (12)

% Por lo que los ganadores del torneo son:
% T1: I3
% T2: I4
% T3: I3
% T4: I5
% T5: I5
% T6: I3

% Entonces los seleccionados actuales son:
% a) Seleccionado 1: [1, 1, 1, 0, 1]
% b) Seleccionado 2: [0, 1, 0, 1, 1]
% c) Seleccionado 3: [1, 1, 1, 0, 1]
% d) Seleccionado 4: [1, 0, 0, 1, 1]
% e) Seleccionado 5: [1, 0, 0, 1, 1]
% f) Seleccionado 6: [1, 1, 1, 0, 1]

% 4) Cruce de un punto
% Entre el S1 y el S2 hacemos cruce en el punto 2
% Hijo 1 = [1, 1, 0, 1, 1]
% Hijo 2 = [0, 1, 1, 0, 1]

% Entre el S4 y S5 hacemos cruce en el punto 4
% Hijo 1 = [1, 0, 0, 1, 1]
% Hijo 2 = [1, 0, 0, 1, 1]

% En los otros no se realiza cruce
% Con lo que los hijos quedarían de la forma
% a) Hijo 1: [1, 1, 0, 1, 1]
% b) Hijo 2: [0, 1, 1, 0, 1]
% c) Hijo 3: [1, 1, 1, 0, 1]
% d) Hijo 4: [1, 0, 0, 1, 1]
% e) Hijo 5: [1, 0, 0, 1, 1]
% f) Hijo 6: [1, 1, 1, 0, 1]

% 5) Mutación del 0.1 por gen
% Suponemos que los que mutan en este caso son los hijos
% H1 (Gen 3)
% [1, 1, 0, 1, 1] -> [1, 1, 1, 1, 1]
% H2 (Gen 1)
% [0, 1, 1, 0, 1] -> [1, 1, 1, 0, 1]

% 6) Con lo que la nueva población resultante sería
% a) Individuo 1: [1, 1, 1, 1, 1]
% b) Individuo 2: [1, 1, 1, 0, 1]
% c) Individuo 3: [1, 1, 1, 0, 1]
% d) Individuo 4: [1, 0, 0, 1, 1]
% e) Individuo 5: [1, 0, 0, 1, 1]
% f) Individuo 6: [1, 1, 1, 0, 1]

%% Evaluación de la nueva población
% 1) Población de 6 individuos
% a) Individuo 1: [1, 1, 1, 1, 1]
% b) Individuo 2: [1, 1, 1, 0, 1]
% c) Individuo 3: [1, 1, 1, 0, 1]
% d) Individuo 4: [1, 0, 0, 1, 1]
% e) Individuo 5: [1, 0, 0, 1, 1]
% f) Individuo 6: [1, 1, 1, 0, 1]

% 2a) Evaluación de aptitud
% Para el individuo 1: Objetos [1,2,3,4,5] -> peso=2+3+4+5+1=15, valor=0
% Aptitud total: 0 (inválido, excede capacidad)

% Para el individuo 2: Objetos [1,2,3,5] -> peso=2+3+4+1=10, valor=3+4+5+2=14
% Aptitud total: 14 (válido)

% Para el individuo 3: Objetos [1,2,3,5] -> peso=2+3+4+1=10, valor=3+4+5+2=14
% Aptitud total: 14 (válido)

% Para el individuo 4: Objetos [1,4,5] -> peso=2+5+1=8, valor=3+6+2=11
% Aptitud total: 11 (válido)

% Para el individuo 5: Objetos [1,4,5] -> peso=2+5+1=8, valor=3+6+2=11
% Aptitud total: 11 (válido)

% Para el individuo 6: Objetos [1,2,3,5] -> peso=2+3+4+1=10, valor=3+4+5+2=14
% Aptitud total: 14 (válido)

% 2b) Tabla resumen indicando el fitness
% Individuo 1 Fitness: 0
% Individuo 2 Fitness: 14
% Individuo 3 Fitness: 14
% Individuo 4 Fitness: 11
% Individuo 5 Fitness: 11
% Individuo 6 Fitness: 14

%% Conclusiones
% Se puede ver que el algoritmo convergió hacia la solución óptima.
% La mejor combinación encontrada es [1,2,3,5] con peso=10kg y valor=14.
% Este algoritmo sirve para encontrar la mejor combinación de objetos para maximizar valor.
% Con más generaciones se puede refinar aún más la búsqueda.
% Los operadores genéticos permitieron explorar diferentes combinaciones,
% logrando converger hacia una población que maximiza el valor de la mochila.