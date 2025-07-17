% Contruir conjuntos borrosos
% Universo de 0 a 20
% 12 elementos
% 5 elementos del discurso iguales

clear; 
close all; 
clc; 

% Universo del discurso
X = 0:0.001:20;

% Conjunto A
% Variable linguística 1: Porcentaje de falsos positivos en un sistema de
% detección de intrusos respecto al total de positivos encontrados.
% Valor linguístico 1: Porcentaje FPR bajo.
fpr_bajo = zmf(X, [0 5]) * 5.55 / 8;
% Valor linguístico 2: Porcentaje FPR medio.
fpr_medio = gaussmf(X, [2 10]) * 5.54 / 8;
% Valor linguístico 3: Porcentaje FPR alto.
fpr_alto = sigmf(X, [2 15]);

fprintf('Variable linguística 1: Porcentaje de falsos positivos en un sistema de\n')
fprintf('detección de intrusos respecto al total de positivos encontrados\n')
fprintf('Valor linguístico 1: Porcentaje FPR bajo\n')
fprintf('Valor linguístico 2: Porcentaje FPR medio\n')
fprintf('Valor linguístico 3: Porcentaje FPR alto\n')

% Conjunto B
% Variable linguística 2: Pérdidas de paquetes IP en una red de conmutación
% de paquetes.
% Valor linguístico 1: Porcentaje de pérdidas bajo.
porcentaje_perdidas_bajo = zmf(X, [0 2]) * 5.8 / 8;
% Valor linguístico 2: Porcentaje de pérdidas medio.
porcentaje_perdidas_medio = gaussmf(X, [3 7]) * 5.8 / 8;
% Valor linguístico 3: Porcentaje de pérdidas alto.
porcentaje_perdidas_alto = sigmf(X, [2 15.5]);

fprintf('\nVariable linguística 2: Pérdidas de paquetes IP en una red de conmutación de paquetes\n')
fprintf('Valor linguístico 1: Porcentaje de pérdidas bajo\n')
fprintf('Valor linguístico 2: Porcentaje de pérdidas medio\n')
fprintf('Valor linguístico 3: Porcentaje de pérdidas alto\n')

% Conjunto C
% Variable linguística 3: Ancho de banda en una red de conmutación de
% paquetes IP
% Valor linguístico 1: Ancho de banda bajo
bw_bajo = zmf(X, [0 4.5]) * 5.3 / 8;
% Valor linguístico 2: Ancho de banda medio
bw_medio = gaussmf(X, [2.5 10.5]) * 5.3 / 8;
% Valor linguístico 3: Ancho de banda alto
bw_alto = sigmf(X, [2 16]);

fprintf('\nVariable linguística 3:Ancho de banda en una red de conmutación de paquetes IP (MBps)\n')
fprintf('Valor linguístico 1: Ancho de banda bajo\n')
fprintf('Valor linguístico 2: Ancho de banda medio\n')
fprintf('Valor linguístico 3: Ancho de banda alto\n\n')

fprintf('Seleccionando puntos de forma adecuada...\n')
% Seleccionar elementos de los conjuntos
puntos = [2, 3, 4, 5, 6, 6.5, 7, 8.5, 9, 16.949, 11, 11.5;
          2, 3, 4, 5, 6, 10.6, 10.9, 11.5, 14.2, 14.5, 19.5, 14.9;
          2, 3, 4, 5, 6, 5.5, 3.29, 7.8, 8.9, 19.8, 11.12, 19.5];
fprintf('Puntos seleccionados exitosamente\n')

% Unión de las funciones de pertenencia
% Para el conjunto A
fpr_union = max([fpr_bajo; fpr_medio; fpr_alto], [], 1);
% Para el conjunto B
perdidas_union = max([porcentaje_perdidas_bajo; porcentaje_perdidas_medio; porcentaje_perdidas_alto], [], 1);
% Para el conjunto C
bw_union = max([bw_bajo; bw_medio; bw_alto], [], 1);

% Encontrar las pertenencias y asignar los puntos
A_puntos = puntos(1, :);
B_puntos = puntos(2, :);
C_puntos = puntos(3, :); 

A_pertenencias = interp1(X, fpr_union, A_puntos);
B_pertenencias = interp1(X, perdidas_union, B_puntos);
C_pertenencias = interp1(X, bw_union, C_puntos);

%% Cardinalidades
card_A = sum(A_pertenencias);
card_B = sum(B_pertenencias); 
card_C = sum(C_pertenencias); 

fprintf('\nLa del conjunto A es: %.2f\n', card_A)
fprintf('\nLa del conjunto B es: %.2f\n', card_B)
fprintf('\nLa del conjunto C es: %.2f\n\n', card_C)

fprintf('A representado de la forma 1\n')
imprimir_conjunto(A_puntos, A_pertenencias, '1')
fprintf('B representado de la forma 2\n')
imprimir_conjunto(B_puntos, B_pertenencias, '2')
fprintf('C representado de la forma 1\n')
imprimir_conjunto(C_puntos, C_pertenencias, '1')

function imprimir_conjunto(conjunto, pertenencias, forma)
    if isequal(forma, '1')
        fprintf('{ ')
        for i = 1:size(conjunto, 2)-1
            fprintf('%.3f/%.3f, ', pertenencias(i), conjunto(i))
        end
        fprintf('%.3f/%.3f }\n', pertenencias(end), conjunto(end))
    elseif isequal(forma, '2')
        for i = 1:size(conjunto, 2)-1
            fprintf('%.3f/%.3f + ', pertenencias(i), conjunto(i))
        end
        fprintf('%.3f/%.3f\n', pertenencias(i), conjunto(i))
    end
end

fprintf('\nAnálisis de los detalles de los conjuntos\n')
fprintf('La altura de A es: %.2f\n', max(A_pertenencias))
fprintf('La altura de B es: %.2f\n', max(B_pertenencias))
fprintf('El conjunto C tiene %d núcleos\n', 2)

%% Gráfica de los conjuntos A, B y C

fprintf('\nMostrando gráficos\n')

% Conjunto A
figure
plot(X, fpr_bajo)
hold on; 
plot(X, fpr_medio)
plot(X, fpr_alto)
grid on;
xlabel('FPR')
ylabel('Pertenencia')
legend('FPR bajo', 'FPR medio', 'FPR alto')
title('Porcentaje de falsos positivos (FPR)')

% Conjunto B
figure
plot(X, porcentaje_perdidas_bajo)
hold on; 
plot(X, porcentaje_perdidas_medio)
plot(X, porcentaje_perdidas_alto)
grid on;
xlabel('Porcentaje de pérdida')
ylabel('Pertenencia')
legend('% de pérdidas bajo', '% de pérdidas medio', '% de pérdidas alto')
title('Pérdidas de paquetes IP en una red de conmutación de paquetes')

% Conjunto C
figure
plot(X, bw_bajo)
hold on; 
plot(X, bw_medio)
plot(X, bw_alto)
grid on;
xlabel('Ancho de banda (MBps)')
ylabel('Pertenencia')
legend('Ancho de banda bajo', 'Ancho de banda medio', 'Ancho de banda alto')
title('Ancho de banda en una red de conmutación de paquetes IP')

fprintf('Gráficos de los 3 conjuntos mostrados en las 3 primeras figuras\n')

% Gráfica de puntos
figure
subplot(1, 3, 1)
plot(X, fpr_union)
hold on; 
scatter(A_puntos, A_pertenencias)
grid on;
xlabel('FPR')
ylabel('Pertenencia')
title('Gráfico de la union del porcentaje de falsos positivos (FPR)')

subplot(1, 3, 2)
plot(X, perdidas_union)
hold on; 
scatter(B_puntos, B_pertenencias)
grid on;
xlabel('Porcentaje')
ylabel('Pertenencia')
title('Gráfico de la union del porcentaje de pérdidas de paquetes')

subplot(1,3,3)
plot(X, bw_union)
hold on; 
scatter(C_puntos, C_pertenencias)
grid on;
xlabel('Ancho de banda')
ylabel('Pertenencia')
title('Gráfico de la union del ancho de banda (MBps)')

fprintf('Gráfica de puntos y conjunto union mostrado en la última figura\n')

%% Concavidades y convexidades en B para lambda
puntos_conjunto = B_puntos; 
pertenencias_conjunto = B_pertenencias;
puntos_analisis = [11.5, 14.9, 10.9, 19.5, 3, 10.6, 2, 11.5]; 
pertenencias_analisis = interp1(X, perdidas_union, puntos_analisis); 
lambda = 0.8; 
fprintf('\nAnálisis de concavidades y convexidades para un labmda %.3f\n', lambda)
analizar_convexidad_concavidad(puntos_analisis, pertenencias_analisis, lambda, perdidas_union, X)

function analizar_convexidad_concavidad(puntos, pertenencias, lambda, union, X)
    for i = 1:2:size(puntos, 2)
        x1 = puntos(i); y1 = pertenencias(i);
        x2 = puntos(i + 1); y2 = pertenencias(i + 1); 
   
        x3 = lambda * x1 + (1-lambda) * x2;
        pertenencia_x3 = interp1(X, union, x3); 

        if pertenencia_x3 <= max(y1, y2)
            fprintf('Entre los puntos %.3f y %.3f hay una concavidad\n', x1, x2)
            fprintf('Esto porque con un labmda %.3f, el punto de análisis x3 es: %.3f\n', lambda, x3)
            fprintf('La función de aptitud en ese punto es: %.3f\n', pertenencia_x3)
            fprintf('Como %.3f <= max(%.3f, %.3f), se justifica la afirmación\n\n', pertenencia_x3, y1, y2)
        end
        if pertenencia_x3 >= min(y1, y2)
            fprintf('Entre los puntos %.3f y %.3f hay una convexidad\n', x1, x2)
            fprintf('Esto porque con un labmda %.3f, el punto de análisis x3 es: %.3f\n', lambda, x3)
            fprintf('La función de aptitud en ese punto es: %.3f\n', pertenencia_x3)
            fprintf('Como %.3f >= min(%.3f, %.3f), se justifica la afirmación\n\n', pertenencia_x3, y1, y2)
        end
    end
end

%% Elegir un conjunto difuso y mostrar el resultado de las operaciones unarias
fprintf('Operaciones unarias\n')
fprintf('El conjunto seleccionado para hacer las operaciones unarias es el conjunto A\n')
puntos_operaciones = A_puntos; 
pertenencias_operaciones = A_pertenencias;

% Normalización
pert_normalizado = pertenencias_operaciones / max(pertenencias_operaciones);
fprintf('Conjunto A normalizado\n')
imprimir_conjunto(puntos_operaciones, pert_normalizado, '1')
fprintf('\n')

% Concentración
p = 2; 
pert_concentra = pertenencias_operaciones .^ p;
fprintf('Conjunto A con la operación concentración\n')
imprimir_conjunto(puntos_operaciones, pert_concentra, '1')
fprintf('\n')

% Dilatación
p = 0.5; 
pert_dilata = pertenencias_operaciones .^ p;
fprintf('Conjunto A con la operación dilatación\n')
imprimir_conjunto(puntos_operaciones, pert_dilata, '1')
fprintf('\n')

% Intensificación del contraste
p = 2;
pert_inten = zeros(size(pertenencias_operaciones));
for i = 1:size(pert_inten, 2)
    if pertenencias_operaciones(i) <= 0.5
        pert_inten(i) = 2^(p-1) * pertenencias_operaciones(i)^p; 
    else
        pert_inten(i) = 1 - (2 ^ (p-1)) * (1 - pertenencias_operaciones(i)^p);
    end
end
fprintf('Conjunto A con la operación intensificación del contraste\n')
imprimir_conjunto(puntos_operaciones, pert_inten, '1')
fprintf('\n')

% Difuminación
pert_dif = zeros(size(pertenencias_operaciones));
for i = 1:size(pert_dif, 2)
    if pertenencias_operaciones(i) <= 0.5
        pert_dif(i) = sqrt(pertenencias_operaciones(i) / 2); 
    else
        pert_dif(i) = 1 - sqrt((1 - pertenencias_operaciones(i))/2);
    end
end
fprintf('Conjunto A con la operación difuminación\n')
imprimir_conjunto(puntos_operaciones, pert_dif, '1')
fprintf('\n')

% Complemento
pert_complemento = 1 - pertenencias_operaciones; 
fprintf('Conjunto A con la operación complemento\n')
imprimir_conjunto(puntos_operaciones, pert_complemento, '1')

%%  Hallar las inclusiones difusas en los 3 conjuntos difusos

% Mostrar nuevos puntos
fprintf('\nCálculo de las inclusiones difusas para los 3 conjuntos difusos\n')
puntos_inclusion = [2, 3, 4, 5, 6]; 
fprintf('Los puntos en común que tienen los conjuntos son: %.3f %.3f %.3f %.3f %.3f\n', puntos_inclusion)

% Mostrar nuevas pertenencias
fprintf('Las pertenencias de los conjuntos son:\n')
pertenencias_A_inclusion = A_pertenencias(1, 1:5);
disp(pertenencias_A_inclusion)
pertenencias_B_inclusion = B_pertenencias(1, 1:5);
disp(pertenencias_B_inclusion)
pertenencias_C_inclusion = C_pertenencias(1, 1:5);
disp(pertenencias_C_inclusion)

% Mostrar nuevos cardinales
cardA_inclusion = sum(pertenencias_A_inclusion); 
cardB_inclusion = sum(pertenencias_B_inclusion);
cardC_inclusion = sum(pertenencias_C_inclusion); 
fprintf('El cardinal de A es: %.3f\n', cardA_inclusion)
fprintf('El cardinal de B es: %.3f\n', cardB_inclusion)
fprintf('El cardinal de C es: %.3f\n', cardC_inclusion)

% Calculo de las inclusiones
fprintf('\nInclusion de A en B\n')
incAB = calcular_inclusion(pertenencias_A_inclusion, pertenencias_B_inclusion, cardA_inclusion);
fprintf('Entonces la inclusión de A en B es de %.3f\n', incAB)
fprintf('Inclusion de B en A\n')
incBA = calcular_inclusion(pertenencias_B_inclusion, pertenencias_A_inclusion, cardB_inclusion);
fprintf('Entonces la inclusión de B en A es de %.3f\n', incBA)
conclusiones(incAB, incBA, 'A', 'B')

fprintf('\nInclusion de A en C\n')
incAC = calcular_inclusion(pertenencias_A_inclusion, pertenencias_C_inclusion, cardA_inclusion);
fprintf('Entonces la inclusión de A en C es de %.3f\n', incAC)
fprintf('Inclusion de C en A\n')
incCA = calcular_inclusion(pertenencias_C_inclusion, pertenencias_A_inclusion, cardC_inclusion);
fprintf('Entonces la inclusión de C en A es de %.3f\n', incCA)
conclusiones(incAC, incCA, 'A', 'C')

fprintf('\nInclusion de B en C\n')
incBC = calcular_inclusion(pertenencias_B_inclusion, pertenencias_C_inclusion, cardB_inclusion);
fprintf('Entonces la inclusión de B en C es de %.3f\n', incBC)
fprintf('Inclusion de C en B\n')
incCB = calcular_inclusion(pertenencias_C_inclusion, pertenencias_B_inclusion, cardC_inclusion);
fprintf('Entonces la inclusión de C en B es de %.3f\n', incCB)
conclusiones(incBC, incCB, 'B', 'C')

function inclusion = calcular_inclusion(A, B, cardA)
    fprintf('Al restar los conjuntos analizados se obtiene: \n')
    C = A - B;
    disp(C)
    sum = 0; 
    fprintf('Se toman solo los valores positivos: ')
    for i = 1:size(C,2)
        if C(i) > 0
            fprintf(' %.3f', C(i))
            sum = sum + C(i); 
        end
    end
    fprintf('\nLa suma de estos valores es: %.3f\n', sum)
    inclusion = (1 / cardA) * (cardA - sum);
end

function conclusiones(incAB, incBA, A, B)
    fprintf('Como la inclusion de %s en %s es de %.3f\n', A, B, incAB)
    fprintf('Y la inclusion de %s en %s es de %.3f\n', B, A, incBA)

    if incAB > incBA
        fprintf('Se puede concluir que %s está más incluido en %s que %s en %s\n', A, B, B, A)
    elseif incAB < incBA
        fprintf('Se puede concluir que %s está más incluido en %s que %s en %s\n', B, A, A, B)
    else
        fprintf('Las inclusiones son iguales, los conjuntos están igualmente incluidos\n')
    end
end

%% Con un alfa corte de 0.3 a los conjuntos A, B y C. 
fprintf('\nComenzando el análisis de la función z - 2x + 2y\n')
alfa = 0.3; 

% Creación de las variables
A_cortado = [];
B_cortado = []; 
C_cortado = []; 

A_cortado_pert = [];
B_cortado_pert = []; 
C_cortado_pert = [];

% Alfa corte
fprintf('Realizando el alfa-corte\n')
for i = 1:size(A_puntos, 2)
    if A_pertenencias(i) > alfa
        A_cortado = [A_cortado, A_puntos(i)]; 
        A_cortado_pert = [A_cortado_pert, A_pertenencias(i)]; 
    end

    if B_pertenencias(i) > alfa
        B_cortado = [B_cortado, B_puntos(i)]; 
        B_cortado_pert = [B_cortado_pert, B_pertenencias(i)]; 
    end

    if C_pertenencias(i) > alfa
        C_cortado = [C_cortado, C_puntos(i)]; 
        C_cortado_pert = [C_cortado_pert, C_pertenencias(i)]; 
    end
end

fprintf('Conjunto A obtenido\n')
disp(A_cortado)
fprintf('Pertenencias del conjunto A obtenido\n')
disp(A_cortado_pert)

fprintf('Conjunto B obtenido\n')
disp(B_cortado)
fprintf('Pertenencias del conjunto B obtenido\n')
disp(B_cortado_pert)

fprintf('Conjunto C obtenido\n')
disp(C_cortado)
fprintf('Pertenencias del conjunto C obtenido\n')
disp(C_cortado_pert)

% Primera operación 

R_intermedio = [];
R_intermedio_pertenencias = []; 

% Obtener todos los valores posibles
fprintf('Realizando la primera operación\n')
for i = 1:size(C_cortado, 2)
    for j = 1:size(A_cortado, 2)
        R_intermedio = [R_intermedio, C_cortado(i) - 2 * A_cortado(j)];
        pertenencia = min(C_cortado_pert(i), A_cortado_pert(j)); 
        R_intermedio_pertenencias = [R_intermedio_pertenencias, pertenencia]; 
    end
end

% Depurar valores duplicados
fprintf('El conjunto intermedio obtenido es el siguiente\n')
disp(R_intermedio)
fprintf('El cual tiene las pertenencias\n')
disp(R_intermedio_pertenencias)

fprintf('Analizando el conjunto intermedio obtenido\n')
[R_intermedio_depurado, R_intermedio_depurado_pertenencias] = depurar(R_intermedio, R_intermedio_pertenencias);

% Segunda operación
fprintf('Realizando la segunda operación\n')

R_intermedio = [];
R_intermedio_pertenencias = []; 

for i = 1:size(R_intermedio_depurado, 2)
    for j = 1:size(B_cortado, 2)
        R_intermedio = [R_intermedio, R_intermedio_depurado(i) + 2 * B_cortado(j)];
        pertenencia = min(R_intermedio_depurado_pertenencias(i), B_cortado_pert(j)); 
        R_intermedio_pertenencias = [R_intermedio_pertenencias, pertenencia]; 
    end
end

fprintf('El conjunto intermedio obtenido es el siguiente\n')
disp(R_intermedio)
fprintf('El cual tiene las pertenencias\n')
disp(R_intermedio_pertenencias)

fprintf('Analizando el conjunto intermedio obtenido\n')
[R_final_depurado, R_final_depurado_pertenencias] = depurar(R_intermedio, R_intermedio_pertenencias);

fprintf('El conjunto final obtenido es el siguiente\n')
disp(R_final_depurado)
fprintf('El cual tiene las pertenencias\n')
disp(R_final_depurado_pertenencias)

% Función de soporte
function [R_intermedio_depurado, R_intermedio_depurado_pertenencias] = depurar(R_intermedio, R_intermedio_pertenencias)
    R_intermedio_depurado = [];
    R_intermedio_depurado_pertenencias = [];

    for i = 1:size(R_intermedio, 2) 
        valor = R_intermedio(i);
        fprintf('Analizando el valor %.3f\n', valor)
        if valor ~= -1000
            coincidencia = false;
            max_pertenencia = R_intermedio_pertenencias(i); 
            for j = i+1:size(R_intermedio, 2)
                if valor == R_intermedio(j)
                    fprintf('Valor coincidente con %.3f encontrado!\n', valor)
                    R_intermedio(j) = -1000; 
                    coincidencia = true;
                    fprintf('Las pertenencias que se tienen son: %.3f, %.3f\n', max_pertenencia, R_intermedio_pertenencias(j))
                    max_pertenencia = max(max_pertenencia, R_intermedio_pertenencias(j)); 
                    fprintf('Tomando %.3f como máxima pertenencia\n', max_pertenencia)
                end
            end
            if ~coincidencia
                fprintf('No se encontraron coincidencias\n\n')
                R_intermedio_depurado = [R_intermedio_depurado, valor];
                R_intermedio_depurado_pertenencias = [R_intermedio_depurado_pertenencias, R_intermedio_pertenencias(i)];
            else
                R_intermedio_depurado = [R_intermedio_depurado, valor];
                R_intermedio_depurado_pertenencias = [R_intermedio_depurado_pertenencias, max_pertenencia];
            end
        end
    end
end

% Gráfica de los resultados obtenidos
figure
scatter(R_final_depurado, R_final_depurado_pertenencias, 'x')
title('Gráfico de la función calculada')
xlabel('Valores obtenidos')
ylabel('Pertenencia')
grid on;

%% Hallar y graficar not(A or B) and C

% Primera operación
[AorB, AorB_pert] = or_zadeh(A_puntos, A_pertenencias, B_puntos, B_pertenencias);

% Negación
D = AorB;
D_pert = 1 - AorB_pert; 

% And
[res, res_pert] = and_zadeh(D, D_pert, C_puntos, C_pertenencias);

% Mostrar resultados
fprintf('El resultado final de las operaciones es\n')
disp(res)
fprintf('Con las funciones de pertenencia\n')
disp(res_pert)

% Mostrar gráfica
figure
scatter(res, res_pert, 'filled')
title('Resultado de la operacion -(A or B) and C')
xlabel('Puntos')
ylabel('Pertenencias')
grid on; 

% Función de soporte
function [puntos, pertenencias] = or_zadeh(A, A_pert, B, B_pert)
    conjunto_union = unique([A, B]);
    A_pert_general = zeros(1, size(conjunto_union, 2)); 
    B_pert_general = zeros(1, size(conjunto_union, 2)); 
    
    [bool_encontrado, indices] = ismember(conjunto_union, A);
    A_pert_general(bool_encontrado) = A_pert(indices(bool_encontrado)); 
    
    [bool_encontrado, indices] = ismember(conjunto_union, B);
    B_pert_general(bool_encontrado) = B_pert(indices(bool_encontrado));

    puntos = conjunto_union; 
    pertenencias = max([A_pert_general; B_pert_general]);
end

function [puntos, pertenencias] = and_zadeh(A, A_pert, B, B_pert)
    conjunto_interseccion = intersect(A, B);
    
    [~, indices_A] = ismember(conjunto_interseccion, A); 
    [~, indices_B] = ismember(conjunto_interseccion, B); 
    A_pert_inter = A_pert(indices_A);
    B_pert_inter = B_pert(indices_B);

    puntos = conjunto_interseccion; 
    pertenencias = min([A_pert_inter; B_pert_inter]); 
end