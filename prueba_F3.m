%% Red de Kohonen con Fisheriris usando selforgmap
clear; clc; close all;

% Cargar el dataset Fisheriris
load fisheriris
X_raw = meas';           % Transponer: columnas = muestras
labels = species;       % Etiquetas originales

% Analizar y describir el dataset
fprintf('Análisis del dataset Fisheriris\n');
fprintf('Total de muestras: %d, Características: %d\n', size(X_raw,2), size(X_raw,1));
classList = unique(labels);
fprintf('Clases: %s, %s, %s\n\n', classList{1}, classList{2}, classList{3});

% Normalización (rango [0,1])
minX = min(X_raw,[],2);
maxX = max(X_raw,[],2);
X = (X_raw - minX) ./ (maxX - minX);
fprintf('Datos normalizados en [0,1]\n\n');

% Configuración de la red SOM
dims = [3 3];              % Mapa 3x3
epochs = 5000;             % Número de épocas de entrenamiento

% Crear y entrenar la red
rng(42);
net = selforgmap(dims, epochs, 3, 'hextop', 'linkdist');
net.trainParam.epochs = epochs;

fprintf('Creando red selforgmap de %dx%d (%d neuronas)\n', dims(1), dims(2), prod(dims));
net = train(net, X);
fprintf('Entrenamiento completo en %d épocas\n\n', epochs);

% Clasificación y neuronas ganadoras
y = net(X);
winners = vec2ind(y);

% Imprimir neurona ganadora para cada muestra
fprintf('Asignación de cada muestra a su neurona ganadora:\n');
for i = 1:size(X,2)
    fprintf(' Muestra %3d -> Neurona %2d\n', i, winners(i));
end
fprintf('\n');

% Imprimir distribución de muestras por neurona
totalNeurons = prod(dims);
counts = zeros(totalNeurons,1);
for i = 1:totalNeurons
    counts(i) = sum(winners==i);
end
fprintf('Distribución de muestras por neurona:\n');
for i = 1:totalNeurons
    fprintf(' Neurona %2d: %2d muestras\n', i, counts(i));
end
fprintf('\n');

% Visualizaciones
figure;
plotsom(net.iw{1,1}, net.layers{1}.distances);
title('Topología y pesos del SOM');

figure;
plotsomhits(net, X);
title('Número de muestras por neurona (SOM Hits)');

figure;
plotsomplanes(net);
sgtitle('Planes de componentes (influencia por variable)');

figure;
plotsomnd(net);
title('Mapa U: distancias entre neuronas');

% Distribución de clases en cada neurona (mapa de colores)
% Calcular proporción de cada clase por neurona
dimRows = dims(1); dimCols = dims(2);
proportions = zeros(dimRows, dimCols, numel(classList));
for k = 1:numel(classList)
    idxClass = strcmp(labels, classList{k});
    neuronsClass = winners(idxClass);
    for n = 1:totalNeurons
        [r,c] = ind2sub(dims, n);
        proportions(r,c,k) = sum(neuronsClass==n) / sum(idxClass);
    end
end

figure;
imagesc(proportions);
xlabel('Columna del mapa'); ylabel('Fila del mapa');
title('Proporción normalizada de clases en cada neurona');
colorbar;
labelsMap = {'S','V','Vi'};
for n = 1:totalNeurons
    [r,c] = ind2sub(dims, n);
    totalSamples = counts(n);
    if totalSamples>0
        [~, dom] = max(proportions(r,c,:));
        text(c, r, sprintf('%s\n(%d)', labelsMap{dom}, totalSamples), ...
            'HorizontalAlignment','center','VerticalAlignment','middle', ...
            'Color','white','FontWeight','bold');
    end
end

% Histograma de distancias cuánticas
distances = zeros(1,size(X,2));
for i = 1:size(X,2)
    n = winners(i);
    w = net.iw{1}(n,:).';
    distances(i) = norm(X(:,i)-w);
end

figure;
histogram(distances,20);
xlabel('Distancia a neurona ganadora'); ylabel('Frecuencia');
title('Distribución de distancias cuánticas finales');

% Estadísticas finales
fprintf('Estadísticas de distancias cuánticas:\n');
fprintf(' Promedio: %.4f\n', mean(distances));
fprintf(' Desviación estándar: %.4f\n', std(distances));

% Matriz de confusión simplificada
fprintf('\nDistribución de clases por neurona:\n');
for n = 1:totalNeurons
    idx = (winners==n);
    if sum(idx)>0
        fprintf(' Neurona %2d:', n);
        for k = 1:numel(classList)
            countK = sum(strcmp(labels(idx), classList{k}));
            fprintf(' %s=%d', classList{k}(1: min(3,end)), countK);
        end
        fprintf('\n');
    end
end

%%


%%

%%

%%

%% Sistema de lógica difusa Mamdani

% Control de calidad de servicio en telecomunicaciones

% Problema: Controlar la calidad del servicio de red basado en:
% - Latencia (ms)
% - Ancho de banda disponible (Mbps)
% - Pérdida de paquetes (%)

% - Salida 1: Prioridad de tráfico (0-100)
% - Salida 2: Potencia de transmisión (0-100)

clear all; close all; clc;


% Paso 1: Crear el sistema difuso Mamdani
fis = mamfis('Name', 'ControlCalidadServicio');

% Configurar métodos de inferencia
fis.AndMethod = 'min';           % T-norma para AND
fis.OrMethod = 'max';            % S-norma para OR
fis.ImplicationMethod = 'min';   % Método de implicación
fis.AggregationMethod = 'max';   % Método de agregación
fis.DefuzzificationMethod = 'centroid'; % Método de defuzzificación

fprintf('Sistema Mamdani: Control de calidad de servicio\n');
fprintf('Sistema creado con métodos:\n');
fprintf('- AND: %s\n', fis.AndMethod);
fprintf('- OR: %s\n', fis.OrMethod);
fprintf('- Implicación: %s\n', fis.ImplicationMethod);
fprintf('- Agregación: %s\n', fis.AggregationMethod);
fprintf('- Defuzzificación: %s\n\n', fis.DefuzzificationMethod);

% Paso 2: Definir variables de entrada

% Entrada 1: Latencia (ms)
fis = addInput(fis, [0 200], 'Name', 'Latencia');

% Funciones de pertenencia para Latencia
fis = addMF(fis, 'Latencia', 'trapmf', [0 0 20 40], 'Name', 'Baja');
fis = addMF(fis, 'Latencia', 'trimf', [30 60 90], 'Name', 'Media');
fis = addMF(fis, 'Latencia', 'trapmf', [80 120 200 200], 'Name', 'Alta');

fprintf('Variable de entrada 1: Latencia (ms)\n');
fprintf('- Rango: [0, 200]\n');
fprintf('- Funciones de pertenencia:\n');
fprintf('  * Baja: [0 0 20 40] (trapezoidal)\n');
fprintf('  * Media: [30 60 90] (triangular)\n');
fprintf('  * Alta: [80 120 200 200] (trapezoidal)\n\n');

% Entrada 2: Ancho de banda (Mbps)
fis = addInput(fis, [0 1000], 'Name', 'AnchoBanda');

% Funciones de pertenencia para Ancho de banda
fis = addMF(fis, 'AnchoBanda', 'trapmf', [0 0 100 250], 'Name', 'Bajo');
fis = addMF(fis, 'AnchoBanda', 'trimf', [200 400 600], 'Name', 'Medio');
fis = addMF(fis, 'AnchoBanda', 'trapmf', [550 750 1000 1000], 'Name', 'Alto');

fprintf('Variable de entrada 2: Ancho de banda (Mbps)\n');
fprintf('- Rango: [0, 1000]\n');
fprintf('- Funciones de pertenencia:\n');
fprintf('  * Bajo: [0 0 100 250] (trapezoidal)\n');
fprintf('  * Medio: [200 400 600] (triangular)\n');
fprintf('  * Alto: [550 750 1000 1000] (trapezoidal)\n\n');

% Entrada 3: Pérdida de paquetes (%)
fis = addInput(fis, [0 20], 'Name', 'PerdidaPaquetes');

% Funciones de pertenencia para Pérdida de paquetes
fis = addMF(fis, 'PerdidaPaquetes', 'trapmf', [0 0 1 3], 'Name', 'Baja');
fis = addMF(fis, 'PerdidaPaquetes', 'trimf', [2 5 8], 'Name', 'Media');
fis = addMF(fis, 'PerdidaPaquetes', 'trapmf', [7 10 20 20], 'Name', 'Alta');

fprintf('Variable de entrada 3: Pérdida de paquetes (%%)\n');
fprintf('- Rango: [0, 20]\n');
fprintf('- Funciones de pertenencia:\n');
fprintf('  * Baja: [0 0 1 3] (trapezoidal)\n');
fprintf('  * Media: [2 5 8] (triangular)\n');
fprintf('  * Alta: [7 10 20 20] (trapezoidal)\n\n');

% Paso 3: Definir variables de salida

% Salida 1: Prioridad de tráfico (0-100)
fis = addOutput(fis, [0 100], 'Name', 'PrioridadTrafico');

% Funciones de pertenencia para Prioridad de tráfico
fis = addMF(fis, 'PrioridadTrafico', 'trapmf', [0 0 20 30], 'Name', 'Muy_Baja');
fis = addMF(fis, 'PrioridadTrafico', 'trimf', [25 40 55], 'Name', 'Baja');
fis = addMF(fis, 'PrioridadTrafico', 'trimf', [50 65 80], 'Name', 'Media');
fis = addMF(fis, 'PrioridadTrafico', 'trapmf', [75 90 100 100], 'Name', 'Alta');

fprintf('Variable de salida 1: Prioridad de tráfico (0-100)\n');
fprintf('- Rango: [0, 100]\n');
fprintf('- Funciones de pertenencia:\n');
fprintf('  * Muy_Baja: [0 0 20 30] (trapezoidal)\n');
fprintf('  * Baja: [25 40 55] (triangular)\n');
fprintf('  * Media: [50 65 80] (triangular)\n');
fprintf('  * Alta: [75 90 100 100] (trapezoidal)\n\n');

% Salida 2: Potencia de transmisión (0-100)
fis = addOutput(fis, [0 100], 'Name', 'PotenciaTransmision');

% Funciones de pertenencia para Potencia de transmisión
fis = addMF(fis, 'PotenciaTransmision', 'trapmf', [0 0 15 25], 'Name', 'Muy_Baja');
fis = addMF(fis, 'PotenciaTransmision', 'trimf', [20 35 50], 'Name', 'Baja');
fis = addMF(fis, 'PotenciaTransmision', 'trimf', [45 60 75], 'Name', 'Media');
fis = addMF(fis, 'PotenciaTransmision', 'trapmf', [70 85 100 100], 'Name', 'Alta');

fprintf('Variable de salida 2: Potencia de transmisión (0-100)\n');
fprintf('- Rango: [0, 100]\n');
fprintf('- Funciones de pertenencia:\n');
fprintf('  * Muy_Baja: [0 0 15 25] (trapezoidal)\n');
fprintf('  * Baja: [20 35 50] (triangular)\n');
fprintf('  * Media: [45 60 75] (triangular)\n');
fprintf('  * Alta: [70 85 100 100] (trapezoidal)\n\n');

% Paso 4: Definir reglas difusas

% Matriz de reglas para Prioridad de tráfico: [Latencia AnchoBanda PerdidaPaquetes => PrioridadTrafico Peso]
% Latencia: 1=Baja, 2=Media, 3=Alta
% AnchoBanda: 1=Bajo, 2=Medio, 3=Alto
% PerdidaPaquetes: 1=Baja, 2=Media, 3=Alta
% PrioridadTrafico: 1=Muy_Baja, 2=Baja, 3=Media, 4=Alta

rules_combinadas = [
    % Latencia Baja
    1 1 1 2 2 1 1;  % Latencia_Baja Y AnchoBanda_Bajo Y Perdida_Baja => Prioridad_Baja, Potencia_Baja
    1 1 2 3 3 1 1;  % Latencia_Baja Y AnchoBanda_Bajo Y Perdida_Media => Prioridad_Media, Potencia_Media
    1 1 3 4 3 1 1;  % Latencia_Baja Y AnchoBanda_Bajo Y Perdida_Alta => Prioridad_Alta, Potencia_Media
    1 2 1 1 1 1 1;  % Latencia_Baja Y AnchoBanda_Medio Y Perdida_Baja => Prioridad_Muy_Baja, Potencia_Muy_Baja
    1 2 2 2 2 1 1;  % Latencia_Baja Y AnchoBanda_Medio Y Perdida_Media => Prioridad_Baja, Potencia_Baja
    1 2 3 3 2 1 1;  % Latencia_Baja Y AnchoBanda_Medio Y Perdida_Alta => Prioridad_Media, Potencia_Baja
    1 3 1 1 1 1 1;  % Latencia_Baja Y AnchoBanda_Alto Y Perdida_Baja => Prioridad_Muy_Baja, Potencia_Muy_Baja
    1 3 2 1 1 1 1;  % Latencia_Baja Y AnchoBanda_Alto Y Perdida_Media => Prioridad_Muy_Baja, Potencia_Muy_Baja
    1 3 3 2 2 1 1;  % Latencia_Baja Y AnchoBanda_Alto Y Perdida_Alta => Prioridad_Baja, Potencia_Baja
    
    % Latencia Media
    2 1 1 3 3 1 1;  % Latencia_Media Y AnchoBanda_Bajo Y Perdida_Baja => Prioridad_Media, Potencia_Media
    2 1 2 4 4 1 1;  % Latencia_Media Y AnchoBanda_Bajo Y Perdida_Media => Prioridad_Alta, Potencia_Alta
    2 1 3 4 4 1 1;  % Latencia_Media Y AnchoBanda_Bajo Y Perdida_Alta => Prioridad_Alta, Potencia_Alta
    2 2 1 2 2 1 1;  % Latencia_Media Y AnchoBanda_Medio Y Perdida_Baja => Prioridad_Baja, Potencia_Baja
    2 2 2 3 3 1 1;  % Latencia_Media Y AnchoBanda_Medio Y Perdida_Media => Prioridad_Media, Potencia_Media
    2 2 3 4 3 1 1;  % Latencia_Media Y AnchoBanda_Medio Y Perdida_Alta => Prioridad_Alta, Potencia_Media
    2 3 1 1 1 1 1;  % Latencia_Media Y AnchoBanda_Alto Y Perdida_Baja => Prioridad_Muy_Baja, Potencia_Muy_Baja
    2 3 2 2 2 1 1;  % Latencia_Media Y AnchoBanda_Alto Y Perdida_Media => Prioridad_Baja, Potencia_Baja
    2 3 3 3 2 1 1;  % Latencia_Media Y AnchoBanda_Alto Y Perdida_Alta => Prioridad_Media, Potencia_Baja
    
    % Latencia Alta
    3 1 1 4 4 1 1;  % Latencia_Alta Y AnchoBanda_Bajo Y Perdida_Baja => Prioridad_Alta, Potencia_Alta
    3 1 2 4 4 1 1;  % Latencia_Alta Y AnchoBanda_Bajo Y Perdida_Media => Prioridad_Alta, Potencia_Alta
    3 1 3 4 4 1 1;  % Latencia_Alta Y AnchoBanda_Bajo Y Perdida_Alta => Prioridad_Alta, Potencia_Alta
    3 2 1 3 3 1 1;  % Latencia_Alta Y AnchoBanda_Medio Y Perdida_Baja => Prioridad_Media, Potencia_Media
    3 2 2 4 4 1 1;  % Latencia_Alta Y AnchoBanda_Medio Y Perdida_Media => Prioridad_Alta, Potencia_Alta
    3 2 3 4 4 1 1;  % Latencia_Alta Y AnchoBanda_Medio Y Perdida_Alta => Prioridad_Alta, Potencia_Alta
    3 3 1 2 2 1 1;  % Latencia_Alta Y AnchoBanda_Alto Y Perdida_Baja => Prioridad_Baja, Potencia_Baja
    3 3 2 3 2 1 1;  % Latencia_Alta Y AnchoBanda_Alto Y Perdida_Media => Prioridad_Media, Potencia_Baja
    3 3 3 4 3 1 1;  % Latencia_Alta Y AnchoBanda_Alto Y Perdida_Alta => Prioridad_Alta, Potencia_Media
];

% Agregar reglas al sistema
fis = addRule(fis, rules_combinadas);

fprintf('Reglas difusas definidas:\n');
fprintf('Total de reglas: %d\n', size(rules_combinadas, 1));
fprintf('Cada regla define ambas salidas simultáneamente\n\n');

% Paso 5: Visualizar funciones de pertenencia

% Graficar funciones de pertenencia
figure('Name', 'Funciones de pertenencia - Sistema Mamdani Telecomunicaciones', 'Position', [100 100 1200 800]);

% Entradas
subplot(2,3,1);
plotmf(fis, 'input', 1);
title('Latencia (ms)');
xlabel('Milisegundos');
ylabel('Grado de pertenencia');
grid on;

subplot(2,3,2);
plotmf(fis, 'input', 2);
title('Ancho de banda (Mbps)');
xlabel('Megabits por segundo');
ylabel('Grado de pertenencia');
grid on;

subplot(2,3,3);
plotmf(fis, 'input', 3);
title('Pérdida de paquetes (%)');
xlabel('Porcentaje');
ylabel('Grado de pertenencia');
grid on;

% Salidas
subplot(2,3,4);
plotmf(fis, 'output', 1);
title('Prioridad de tráfico (0-100)');
xlabel('Nivel de prioridad');
ylabel('Grado de pertenencia');
grid on;

subplot(2,3,5);
plotmf(fis, 'output', 2);
title('Potencia de transmisión (0-100)');
xlabel('Nivel de potencia');
ylabel('Grado de pertenencia');
grid on;

% Paso 6: Evaluación del sistema

fprintf('Evaluación del sistema\n');

% Casos de prueba
test_cases = [
    20 800 1;   % Latencia baja, ancho banda alto, pérdida baja
    60 400 5;   % Latencia media, ancho banda medio, pérdida media
    150 100 12; % Latencia alta, ancho banda bajo, pérdida alta
    30 600 8;   % Latencia baja, ancho banda alto, pérdida media
    100 200 15; % Latencia alta, ancho banda bajo, pérdida alta
];

test_descriptions = {
    'Red óptima con excelente rendimiento';
    'Red con rendimiento moderado';
    'Red congestionada con problemas severos';
    'Red con buena conectividad pero pérdidas';
    'Red crítica que requiere intervención'
};

fprintf('Casos de prueba:\n');
for i = 1:size(test_cases, 1)
    latencia = test_cases(i, 1);
    ancho_banda = test_cases(i, 2);
    perdida = test_cases(i, 3);
    resultados = evalfis(fis, [latencia ancho_banda perdida]);
    prioridad = resultados(1);
    potencia = resultados(2);
    
    fprintf('%d. %s\n', i, test_descriptions{i});
    fprintf('   Entrada: Latencia=%.1fms, AnchoBanda=%.1fMbps, PerdidaPaquetes=%.1f%%\n', latencia, ancho_banda, perdida);
    fprintf('   Salida: PrioridadTrafico=%.2f, PotenciaTransmision=%.2f\n\n', prioridad, potencia);
end

% 
% Paso 7: Análisis de superficie de respuesta
% 

% Generar superficie de respuesta para las primeras dos entradas
latencia_range = 0:10:200;
ancho_banda_range = 0:50:1000;
perdida_fija = 3; % Pérdida fija para visualización

[L, A] = meshgrid(latencia_range, ancho_banda_range);

% Evaluar sistema para toda la superficie
Z_prioridad = zeros(size(L));
Z_potencia = zeros(size(L));

for i = 1:size(L, 1)
    for j = 1:size(L, 2)
        resultados = evalfis(fis, [L(i, j) A(i, j) perdida_fija]);
        Z_prioridad(i, j) = resultados(1);
        Z_potencia(i, j) = resultados(2);
    end
end

% Graficar superficies de respuesta
figure('Name', 'Superficies de respuesta - Sistema Mamdani Telecomunicaciones', 'Position', [200 200 1200 500]);

subplot(1,2,1);
surf(L, A, Z_prioridad);
xlabel('Latencia (ms)');
ylabel('Ancho de banda (Mbps)');
zlabel('Prioridad de tráfico');
title('Superficie de respuesta - Prioridad de tráfico');
colorbar;
grid on;

subplot(1,2,2);
surf(L, A, Z_potencia);
xlabel('Latencia (ms)');
ylabel('Ancho de banda (Mbps)');
zlabel('Potencia de transmisión');
title('Superficie de respuesta - Potencia de transmisión');
colorbar;
grid on;

% Paso 8: Análisis detallado de una inferencia CORREGIDO

fprintf('Análisis detallado de inferencia\n');

% Caso específico: Latencia=80ms, AnchoBanda=300Mbps, PerdidaPaquetes=6%
latencia_test = 80;
ancho_banda_test = 300;
perdida_test = 6;
resultados_test = evalfis(fis, [latencia_test ancho_banda_test perdida_test]);
prioridad_resultado = resultados_test(1);
potencia_resultado = resultados_test(2);

fprintf('Caso de análisis: Latencia=%.1fms, AnchoBanda=%.1fMbps, PerdidaPaquetes=%.1f%%\n', latencia_test, ancho_banda_test, perdida_test);
fprintf('Resultado: PrioridadTrafico=%.2f, PotenciaTransmision=%.2f\n\n', prioridad_resultado, potencia_resultado);

% Mostrar el proceso de inferencia paso a paso
fprintf('Proceso de inferencia paso a paso:\n');
fprintf('1. Fuzzificación:\n');

% Evaluar grados de pertenencia para latencia
lat_baja = evalmf(fis.Inputs(1).MembershipFunctions(1), latencia_test);
lat_media = evalmf(fis.Inputs(1).MembershipFunctions(2), latencia_test);
lat_alta = evalmf(fis.Inputs(1).MembershipFunctions(3), latencia_test);

fprintf('   Latencia %.1fms:\n', latencia_test);
fprintf('   - Baja: %.3f\n', lat_baja);
fprintf('   - Media: %.3f\n', lat_media);
fprintf('   - Alta: %.3f\n', lat_alta);

% Evaluar grados de pertenencia para ancho de banda 
ancho_bajo = evalmf(fis.Inputs(2).MembershipFunctions(1), ancho_banda_test);
ancho_medio = evalmf(fis.Inputs(2).MembershipFunctions(2), ancho_banda_test);
ancho_alto = evalmf(fis.Inputs(2).MembershipFunctions(3), ancho_banda_test);

fprintf('   Ancho de banda %.1fMbps:\n', ancho_banda_test);
fprintf('   - Bajo: %.3f\n', ancho_bajo);
fprintf('   - Medio: %.3f\n', ancho_medio);
fprintf('   - Alto: %.3f\n', ancho_alto);

% Evaluar grados de pertenencia para pérdida de paquetes
perdida_baja = evalmf(fis.Inputs(3).MembershipFunctions(1), perdida_test);
perdida_media = evalmf(fis.Inputs(3).MembershipFunctions(2), perdida_test);
perdida_alta = evalmf(fis.Inputs(3).MembershipFunctions(3), perdida_test);

fprintf('   Pérdida de paquetes %.1f%%:\n', perdida_test);
fprintf('   - Baja: %.3f\n', perdida_baja);
fprintf('   - Media: %.3f\n', perdida_media);
fprintf('   - Alta: %.3f\n\n', perdida_alta);

fprintf('2. Evaluación de reglas activas:\n');
fprintf('   Las reglas que se activan son aquellas donde los antecedentes\n');
fprintf('   tienen grados de pertenencia > 0.\n\n');

fprintf('3. Defuzzificación por método centroide:\n');
fprintf('   PrioridadTrafico: %.2f es el centroide del área resultante\n', prioridad_resultado);
fprintf('   PotenciaTransmision: %.2f es el centroide del área resultante\n', potencia_resultado);
fprintf('   de la agregación de todas las reglas activas.\n\n');

% 
% Paso 9: Visualización del proceso de inferencia
% 

% Mostrar el proceso de inferencia gráficamente
figure('Name', 'Proceso de inferencia - Sistema Mamdani Telecomunicaciones', 'Position', [300 300 1200 800]);

% Crear subgráficos para cada salida
subplot(2,1,1);
gensurf(fis, [1 2], 1, [50 50], [0 0 perdida_test]);
title('Proceso de inferencia - Prioridad de tráfico');

subplot(2,1,2);
gensurf(fis, [1 2], 2, [50 50], [0 0 perdida_test]);
title('Proceso de inferencia - Potencia de transmisión');

fprintf('Análisis completado\n');
fprintf('El sistema Mamdani ha sido diseñado, implementado y evaluado.\n');
fprintf('Características principales:\n');
fprintf('- Maneja incertidumbre en control de calidad de servicio\n');
fprintf('- Usa conocimiento experto para optimizar recursos de red\n');
fprintf('- Proporciona control adaptativo y robusto\n');
fprintf('- Fácil de interpretar y modificar para diferentes escenarios\n\n');


%%

%%

%%

%%

%%

%%

% Sistema de Lógica Difusa Sugeno con Salidas Lineales
% Detección de Intrusiones en Redes de Telecomunicaciones
% Problema: Evaluar el nivel de amenaza y prioridad de respuesta basado en:
% - Tráfico de red anómalo (%)
% - Intentos de acceso fallidos (por minuto)
% - Latencia de red (ms)
% - Uso de CPU del servidor (%)
% - Salidas: Nivel de amenaza (0-100) y Prioridad de respuesta (0-10) - Funciones lineales

clear all; close all; clc;

% Paso 1: Crear el sistema difuso Sugeno
fis = sugfis('Name', 'DeteccionIntrusiones');

% Configurar métodos de inferencia
fis.AndMethod = 'prod';          % T-norma para AND (típico en Sugeno)
fis.OrMethod = 'probor';         % S-norma para OR (típico en Sugeno)
fis.DefuzzificationMethod = 'wtaver'; % Promedio ponderado (típico Sugeno)

fprintf('=== Sistema Sugeno: Detección de Intrusiones en Redes ===\n');
fprintf('Sistema creado con métodos:\n');
fprintf('- AND: %s\n', fis.AndMethod);
fprintf('- OR: %s\n', fis.OrMethod);
fprintf('- Defuzzificación: %s (Weighted Average)\n\n', fis.DefuzzificationMethod);

% Paso 2: Definir variables de entrada

% Entrada 1: Tráfico de red anómalo (%)
fis = addInput(fis, [0 100], 'Name', 'TraficoAnomalo');

% Funciones de pertenencia para Tráfico Anómalo
fis = addMF(fis, 'TraficoAnomalo', 'trimf', [0 0 30], 'Name', 'Bajo');
fis = addMF(fis, 'TraficoAnomalo', 'trimf', [20 50 80], 'Name', 'Medio');
fis = addMF(fis, 'TraficoAnomalo', 'trimf', [70 100 100], 'Name', 'Alto');

fprintf('Variable de entrada 1: Tráfico Anómalo (%%)\n');
fprintf('- Rango: [0, 100]\n');
fprintf('- Funciones de pertenencia:\n');
fprintf('  * Bajo: [0 0 30] (triangular)\n');
fprintf('  * Medio: [20 50 80] (triangular)\n');
fprintf('  * Alto: [70 100 100] (triangular)\n\n');

% Entrada 2: Intentos de acceso fallidos (por minuto)
fis = addInput(fis, [0 50], 'Name', 'AccesosFallidos');

% Funciones de pertenencia para Accesos Fallidos
fis = addMF(fis, 'AccesosFallidos', 'trimf', [0 0 10], 'Name', 'Bajo');
fis = addMF(fis, 'AccesosFallidos', 'trimf', [5 20 35], 'Name', 'Medio');
fis = addMF(fis, 'AccesosFallidos', 'trimf', [30 50 50], 'Name', 'Alto');

fprintf('Variable de entrada 2: Accesos Fallidos (por minuto)\n');
fprintf('- Rango: [0, 50]\n');
fprintf('- Funciones de pertenencia:\n');
fprintf('  * Bajo: [0 0 10] (triangular)\n');
fprintf('  * Medio: [5 20 35] (triangular)\n');
fprintf('  * Alto: [30 50 50] (triangular)\n\n');

% Entrada 3: Latencia de red (ms)
fis = addInput(fis, [0 200], 'Name', 'Latencia');

% Funciones de pertenencia para Latencia
fis = addMF(fis, 'Latencia', 'trimf', [0 0 50], 'Name', 'Baja');
fis = addMF(fis, 'Latencia', 'trimf', [30 80 130], 'Name', 'Media');
fis = addMF(fis, 'Latencia', 'trimf', [100 200 200], 'Name', 'Alta');

fprintf('Variable de entrada 3: Latencia (ms)\n');
fprintf('- Rango: [0, 200]\n');
fprintf('- Funciones de pertenencia:\n');
fprintf('  * Baja: [0 0 50] (triangular)\n');
fprintf('  * Media: [30 80 130] (triangular)\n');
fprintf('  * Alta: [100 200 200] (triangular)\n\n');

% Entrada 4: Uso de CPU del servidor (%)
fis = addInput(fis, [0 100], 'Name', 'UsoCPU');

% Funciones de pertenencia para Uso de CPU
fis = addMF(fis, 'UsoCPU', 'trimf', [0 0 40], 'Name', 'Bajo');
fis = addMF(fis, 'UsoCPU', 'trimf', [30 60 90], 'Name', 'Medio');
fis = addMF(fis, 'UsoCPU', 'trimf', [80 100 100], 'Name', 'Alto');

fprintf('Variable de entrada 4: Uso de CPU (%%)\n');
fprintf('- Rango: [0, 100]\n');
fprintf('- Funciones de pertenencia:\n');
fprintf('  * Bajo: [0 0 40] (triangular)\n');
fprintf('  * Medio: [30 60 90] (triangular)\n');
fprintf('  * Alto: [80 100 100] (triangular)\n\n');

% Paso 3: Definir variables de salida (Sugeno con funciones lineales)

% Salida 1: Nivel de amenaza (0-100)
fis = addOutput(fis, [0 100], 'Name', 'NivelAmenaza');

% Funciones lineales para Nivel de Amenaza
% Formato: [a0 a1 a2 a3 a4] donde salida = a0 + a1*Trafico + a2*Accesos + a3*Latencia + a4*CPU
fis = addMF(fis, 'NivelAmenaza', 'linear', [5 0.2 0.8 0.1 0.3], 'Name', 'Muy_Bajo');
fis = addMF(fis, 'NivelAmenaza', 'linear', [15 0.4 1.2 0.2 0.4], 'Name', 'Bajo');
fis = addMF(fis, 'NivelAmenaza', 'linear', [30 0.6 1.5 0.3 0.5], 'Name', 'Medio');
fis = addMF(fis, 'NivelAmenaza', 'linear', [50 0.8 2.0 0.4 0.6], 'Name', 'Alto');
fis = addMF(fis, 'NivelAmenaza', 'linear', [70 1.0 2.5 0.5 0.8], 'Name', 'Muy_Alto');

fprintf('Variable de salida 1: Nivel de Amenaza (0-100)\n');
fprintf('- Rango: [0, 100]\n');
fprintf('- Funciones de pertenencia lineales:\n');
fprintf('  * Muy_Bajo: 5 + 0.2*Trafico + 0.8*Accesos + 0.1*Latencia + 0.3*CPU\n');
fprintf('  * Bajo: 15 + 0.4*Trafico + 1.2*Accesos + 0.2*Latencia + 0.4*CPU\n');
fprintf('  * Medio: 30 + 0.6*Trafico + 1.5*Accesos + 0.3*Latencia + 0.5*CPU\n');
fprintf('  * Alto: 50 + 0.8*Trafico + 2.0*Accesos + 0.4*Latencia + 0.6*CPU\n');
fprintf('  * Muy_Alto: 70 + 1.0*Trafico + 2.5*Accesos + 0.5*Latencia + 0.8*CPU\n\n');

% Salida 2: Prioridad de respuesta (0-10)
fis = addOutput(fis, [0 10], 'Name', 'PrioriadRespuesta');

% Funciones lineales para Prioridad de Respuesta
fis = addMF(fis, 'PrioriadRespuesta', 'linear', [0.5 0.02 0.08 0.01 0.03], 'Name', 'Muy_Baja');
fis = addMF(fis, 'PrioriadRespuesta', 'linear', [1.5 0.04 0.12 0.02 0.04], 'Name', 'Baja');
fis = addMF(fis, 'PrioriadRespuesta', 'linear', [3.0 0.06 0.15 0.03 0.05], 'Name', 'Media');
fis = addMF(fis, 'PrioriadRespuesta', 'linear', [5.0 0.08 0.20 0.04 0.06], 'Name', 'Alta');
fis = addMF(fis, 'PrioriadRespuesta', 'linear', [7.0 0.10 0.25 0.05 0.08], 'Name', 'Muy_Alta');

fprintf('Variable de salida 2: Prioridad de Respuesta (0-10)\n');
fprintf('- Rango: [0, 10]\n');
fprintf('- Funciones de pertenencia lineales:\n');
fprintf('  * Muy_Baja: 0.5 + 0.02*Trafico + 0.08*Accesos + 0.01*Latencia + 0.03*CPU\n');
fprintf('  * Baja: 1.5 + 0.04*Trafico + 0.12*Accesos + 0.02*Latencia + 0.04*CPU\n');
fprintf('  * Media: 3.0 + 0.06*Trafico + 0.15*Accesos + 0.03*Latencia + 0.05*CPU\n');
fprintf('  * Alta: 5.0 + 0.08*Trafico + 0.20*Accesos + 0.04*Latencia + 0.06*CPU\n');
fprintf('  * Muy_Alta: 7.0 + 0.10*Trafico + 0.25*Accesos + 0.05*Latencia + 0.08*CPU\n\n');

% Paso 4: Definir reglas difusas

% Matriz de reglas: [Trafico Accesos Latencia CPU => NivelAmenaza PrioridadRespuesta Peso]
% Entradas: 1=Bajo, 2=Medio, 3=Alto
% Salidas: 1=Muy_Bajo, 2=Bajo, 3=Medio, 4=Alto, 5=Muy_Alto

rules = [

    %% Situaciones de baja amenaza
    1 1 1 1 1 1 1 1;  % Todo bajo => Muy_Bajo, Muy_Baja
    1 1 1 2 1 1 1 1;  % Solo CPU medio => Muy_Bajo, Muy_Baja
    1 1 2 1 2 2 1 1;  % Latencia media => Bajo, Baja
    1 2 1 1 2 2 1 1;  % Accesos medio => Bajo, Baja
    2 1 1 1 2 2 1 1;  % Tráfico medio => Bajo, Baja

    %% Amenaza leve-media por múltiples factores medios
    1 1 2 2 2 2 1 1;  % Latencia y CPU medios
    1 2 1 2 3 3 1 1;  % Accesos y CPU medios
    2 1 1 2 3 3 1 1;  % Tráfico y CPU medios
    2 2 1 1 3 3 1 1;  % Tráfico y accesos medios
    1 2 2 1 3 3 1 1;  % Accesos y latencia medios
    2 1 2 1 3 3 1 1;  % Tráfico y latencia medios

    %% Amenaza alta por acumulación de niveles medios o un alto
    2 2 2 2 4 4 1 1;  % Todo medio => Alto, Alta
    3 1 1 1 3 3 1 1;  % Tráfico alto
    1 3 1 1 3 3 1 1;  % Accesos altos
    1 1 3 1 3 3 1 1;  % Latencia alta
    1 1 1 3 3 3 1 1;  % CPU alta

    %% Amenaza alta con una variable alta + otras medias
    3 2 2 2 4 4 1 1;  % Tráfico alto + 3 medios
    2 3 2 2 4 4 1 1;  % Accesos altos + medios
    2 2 3 2 4 4 1 1;  % Latencia alta + medios
    2 2 2 3 4 4 1 1;  % CPU alta + medios

    %% Amenaza alta con pares de variables altas
    3 3 1 1 4 4 1 1;  % Tráfico y accesos altos
    3 1 3 1 4 4 1 1;  % Tráfico y latencia altos
    3 1 1 3 4 4 1 1;  % Tráfico y CPU altos
    1 3 3 1 4 4 1 1;  % Accesos y latencia altos
    1 3 1 3 4 4 1 1;  % Accesos y CPU altos
    1 1 3 3 4 4 1 1;  % Latencia y CPU altos

    %% Amenaza muy alta: combinaciones extremas
    3 3 2 2 5 5 1 1;  % Tráfico y accesos altos + 2 medios
    3 2 3 2 5 5 1 1;  % Tráfico y latencia altos + 2 medios
    3 2 2 3 5 5 1 1;  % Tráfico y CPU altos + 2 medios
    2 3 3 2 5 5 1 1;  % Accesos y latencia altos + medios
    2 3 2 3 5 5 1 1;  % Accesos y CPU altos + medios
    2 2 3 3 5 5 1 1;  % Latencia y CPU altos + medios

    %% Amenaza muy alta: 3 variables altas o más
    3 3 3 1 5 5 1 1;  % Tráfico, accesos y latencia altos
    3 3 1 3 5 5 1 1;  % Tráfico, accesos y CPU altos
    3 1 3 3 5 5 1 1;  % Tráfico, latencia y CPU altos
    1 3 3 3 5 5 1 1;  % Accesos, latencia y CPU altos
    3 3 3 3 5 5 1 1;  % Todo alto (peor escenario)

];

% Agregar reglas al sistema
fis = addRule(fis, rules);

fprintf('\nReglas difusas definidas\n');
fprintf('Total de reglas: %d\n\n', size(rules, 1));

fprintf('Ejemplos de reglas:\n');
fprintf('1. If Trafico = Bajo AND Accesos = Bajo AND Latencia = Baja AND CPU = Bajo\n');
fprintf('      Then NivelAmenaza = Muy_Bajo AND PrioridadRespuesta = Muy_Baja\n\n');

fprintf('2. If Trafico = Medio AND Accesos = Medio AND Latencia = Media AND CPU = Medio\n');
fprintf('      Then NivelAmenaza = Alto AND PrioridadRespuesta = Alta\n\n');

fprintf('3. If Trafico = Alto AND Accesos = Alto AND Latencia = Alta AND CPU = Alto\n');
fprintf('      Then NivelAmenaza = Muy_Alto AND PrioridadRespuesta = Muy_Alta\n\n');


% Paso 5: Visualizar funciones de pertenencia

% Graficar funciones de pertenencia de entrada
figure('Name', 'Funciones de Pertenencia - Entradas', 'Position', [100 100 1400 800]);

% Tráfico anómalo
subplot(2,2,1);
plotmf(fis, 'input', 1);
title('Tráfico Anómalo (%)');
xlabel('Porcentaje');
ylabel('Grado de Pertenencia');
grid on;

% Accesos fallidos
subplot(2,2,2);
plotmf(fis, 'input', 2);
title('Accesos Fallidos (por minuto)');
xlabel('Cantidad');
ylabel('Grado de Pertenencia');
grid on;

% Latencia
subplot(2,2,3);
plotmf(fis, 'input', 3);
title('Latencia (ms)');
xlabel('Milisegundos');
ylabel('Grado de Pertenencia');
grid on;

% Uso de CPU
subplot(2,2,4);
plotmf(fis, 'input', 4);
title('Uso de CPU (%)');
xlabel('Porcentaje');
ylabel('Grado de Pertenencia');
grid on;

% Paso 6: Evaluación del sistema

fprintf('=== Evaluación del sistema ===\n');

% Casos de prueba
test_cases = [
    5 2 20 15;    % Situación normal
    40 15 80 60;  % Situación sospechosa
    80 35 150 85; % Situación crítica
    25 8 45 30;   % Situación moderada
    90 40 180 95; % Ataque severo
    60 25 120 70; % Amenaza alta
    10 5 30 20;   % Situación tranquila
    100 50 200 100; % Situación extrema
];

test_descriptions = {
    'Operación normal de la red';
    'Actividad sospechosa detectada';
    'Situación crítica - posible ataque';
    'Actividad moderadamente anómala';
    'Ataque severo en curso';
    'Amenaza alta detectada';
    'Red en estado tranquilo';
    'Situación extrema - alerta máxima'
};

fprintf('Casos de prueba con funciones lineales:\n');
for i = 1:size(test_cases, 1)
    trafico = test_cases(i, 1);
    accesos = test_cases(i, 2);
    latencia = test_cases(i, 3);
    cpu = test_cases(i, 4);
    
    resultado = evalfis(fis, [trafico accesos latencia cpu]);
    nivel_amenaza = resultado(1);
    prioridad_respuesta = resultado(2);
    
    fprintf('%d. %s\n', i, test_descriptions{i});
    fprintf('   Entrada: Trafico=%.0f%%, Accesos=%.0f/min, Latencia=%.0fms, CPU=%.0f%%\n', trafico, accesos, latencia, cpu);
    fprintf('   Salida: Nivel Amenaza=%.1f, Prioridad Respuesta=%.1f\n\n', nivel_amenaza, prioridad_respuesta);
end

% Paso 7: Análisis de superficie de respuesta (usando las primeras dos entradas)

% Generar superficie de respuesta para Tráfico vs Accesos (manteniendo Latencia=50, CPU=50)
trafico_range = 0:5:100;
accesos_range = 0:2:50;
[T, A] = meshgrid(trafico_range, accesos_range);

% Evaluar sistema para toda la superficie
Z_amenaza = zeros(size(T));
Z_prioridad = zeros(size(T));

for i = 1:size(T, 1)
    for j = 1:size(T, 2)
        resultado = evalfis(fis, [T(i, j) A(i, j) 50 50]);
        Z_amenaza(i, j) = resultado(1);
        Z_prioridad(i, j) = resultado(2);
    end
end

% Graficar superficie de respuesta para Nivel de Amenaza
figure('Name', 'Superficie de Respuesta - Nivel de Amenaza', 'Position', [300 200 800 600]);
surf(T, A, Z_amenaza);
xlabel('Tráfico Anómalo (%)');
ylabel('Accesos Fallidos (por minuto)');
zlabel('Nivel de Amenaza');
title('Superficie de Respuesta - Nivel de Amenaza (Latencia=50ms, CPU=50%)');
colorbar;
grid on;
shading interp;

% Graficar superficie de respuesta para Prioridad de Respuesta
figure('Name', 'Superficie de Respuesta - Prioridad de Respuesta', 'Position', [400 300 800 600]);
surf(T, A, Z_prioridad);
xlabel('Tráfico Anómalo (%)');
ylabel('Accesos Fallidos (por minuto)');
zlabel('Prioridad de Respuesta');
title('Superficie de Respuesta - Prioridad de Respuesta (Latencia=50ms, CPU=50%)');
colorbar;
grid on;
shading interp;

% Gráficos de contorno
figure('Name', 'Análisis de Contorno', 'Position', [500 400 1200 500]);

% Contorno para Nivel de Amenaza
subplot(1,2,1);
contour(T, A, Z_amenaza, 15);
xlabel('Tráfico Anómalo (%)');
ylabel('Accesos Fallidos (por minuto)');
title('Curvas de Nivel - Nivel de Amenaza');
colorbar;
grid on;

% Agregar puntos de los casos de prueba
hold on;
for i = 1:size(test_cases, 1)
    plot(test_cases(i, 1), test_cases(i, 2), 'ro', 'MarkerSize', 6, 'MarkerFaceColor', 'red');
    text(test_cases(i, 1)+2, test_cases(i, 2), sprintf('%d', i), 'FontSize', 8);
end
hold off;

% Contorno para Prioridad de Respuesta
subplot(1,2,2);
contour(T, A, Z_prioridad, 15);
xlabel('Tráfico Anómalo (%)');
ylabel('Accesos Fallidos (por minuto)');
title('Curvas de Nivel - Prioridad de Respuesta');
colorbar;
grid on;

% Agregar puntos de los casos de prueba
hold on;
for i = 1:size(test_cases, 1)
    plot(test_cases(i, 1), test_cases(i, 2), 'ro', 'MarkerSize', 6, 'MarkerFaceColor', 'red');
    text(test_cases(i, 1)+2, test_cases(i, 2), sprintf('%d', i), 'FontSize', 8);
end
hold off;

% Paso 8: Análisis comparativo de funciones lineales

fprintf('\n=== Análisis de funciones lineales ===\n');
fprintf('Comparación de salidas para diferentes entradas:\n\n');

% Parámetros de las funciones lineales para Nivel de Amenaza
mf_amenaza_params = [
    5 0.2 0.8 0.1 0.3;    % Muy_Bajo
    15 0.4 1.2 0.2 0.4;   % Bajo
    30 0.6 1.5 0.3 0.5;   % Medio
    50 0.8 2.0 0.4 0.6;   % Alto
    70 1.0 2.5 0.5 0.8;   % Muy_Alto
];

% Parámetros de las funciones lineales para Prioridad de Respuesta
mf_prioridad_params = [
    0.5 0.02 0.08 0.01 0.03;  % Muy_Baja
    1.5 0.04 0.12 0.02 0.04;  % Baja
    3.0 0.06 0.15 0.03 0.05;  % Media
    5.0 0.08 0.20 0.04 0.06;  % Alta
    7.0 0.10 0.25 0.05 0.08;  % Muy_Alta
];

mf_names = {'Muy_Bajo', 'Bajo', 'Medio', 'Alto', 'Muy_Alto'};
sample_inputs = [10 5 25 20; 50 20 80 60; 80 40 150 90];

for i = 1:size(sample_inputs, 1)
    trafico = sample_inputs(i, 1);
    accesos = sample_inputs(i, 2);
    latencia = sample_inputs(i, 3);
    cpu = sample_inputs(i, 4);
    
    fprintf('Para Trafico=%.0f%%, Accesos=%.0f/min, Latencia=%.0fms, CPU=%.0f%%:\n', trafico, accesos, latencia, cpu);
    fprintf('Funciones lineales de Nivel de Amenaza:\n');
    for j = 1:size(mf_amenaza_params, 1)
        linear_output = mf_amenaza_params(j, 1) + mf_amenaza_params(j, 2) * trafico + ...
                       mf_amenaza_params(j, 3) * accesos + mf_amenaza_params(j, 4) * latencia + ...
                       mf_amenaza_params(j, 5) * cpu;
        fprintf('  %s: %.1f\n', mf_names{j}, linear_output);
    end
    
    fprintf('Funciones lineales de Prioridad de Respuesta:\n');
    for j = 1:size(mf_prioridad_params, 1)
        linear_output = mf_prioridad_params(j, 1) + mf_prioridad_params(j, 2) * trafico + ...
                       mf_prioridad_params(j, 3) * accesos + mf_prioridad_params(j, 4) * latencia + ...
                       mf_prioridad_params(j, 5) * cpu;
        fprintf('  %s: %.1f\n', mf_names{j}, linear_output);
    end
    fprintf('\n');
end

% Mostrar reglas del sistema
fprintf('\n=== Reglas del sistema ===\n');
showrule(fis);

% Paso 9: Comparación numérica detallada

fprintf('\n=== Comparación detallada ===\n');
fprintf('Análisis de un caso específico:\n\n');

% Caso específico para análisis
trafico_test = 65;
accesos_test = 28;
latencia_test = 120;
cpu_test = 75;

resultado_final = evalfis(fis, [trafico_test accesos_test latencia_test cpu_test]);
amenaza_final = resultado_final(1);
prioridad_final = resultado_final(2);

fprintf('Caso de análisis: Trafico=%.0f%%, Accesos=%.0f/min, Latencia=%.0fms, CPU=%.0f%%\n', trafico_test, accesos_test, latencia_test, cpu_test);
fprintf('Resultados finales del sistema:\n');
fprintf('- Nivel de Amenaza: %.1f\n', amenaza_final);
fprintf('- Prioridad de Respuesta: %.1f\n\n', prioridad_final);

fprintf('Valores individuales de cada función lineal:\n');
fprintf('Nivel de Amenaza:\n');
for i = 1:length(mf_names)
    linear_val = mf_amenaza_params(i, 1) + mf_amenaza_params(i, 2) * trafico_test + ...
                 mf_amenaza_params(i, 3) * accesos_test + mf_amenaza_params(i, 4) * latencia_test + ...
                 mf_amenaza_params(i, 5) * cpu_test;
    fprintf('  %s: %.1f\n', mf_names{i}, linear_val);
end

fprintf('Prioridad de Respuesta:\n');
for i = 1:length(mf_names)
    linear_val = mf_prioridad_params(i, 1) + mf_prioridad_params(i, 2) * trafico_test + ...
                 mf_prioridad_params(i, 3) * accesos_test + mf_prioridad_params(i, 4) * latencia_test + ...
                 mf_prioridad_params(i, 5) * cpu_test;
    fprintf('  %s: %.1f\n', mf_names{i}, linear_val);
end

fprintf('\n¡Sistema Sugeno de detección de intrusiones completado!\n');
fprintf('El sistema evalúa cuatro parámetros de red para determinar el nivel de amenaza\n');
fprintf('y la prioridad de respuesta usando funciones lineales que proporcionan\n');
fprintf('mayor flexibilidad y precisión en la detección de amenazas cibernéticas.\n');

% Paso 10: Análisis de sensibilidad

fprintf('\n=== Análisis de sensibilidad ===\n');
fprintf('Evaluando cómo cada entrada afecta las salidas:\n\n');

% Valores base para el análisis
base_values = [50 20 80 60]; % Trafico, Accesos, Latencia, CPU
base_result = evalfis(fis, base_values);

fprintf('Valores base: Trafico=%.0f%%, Accesos=%.0f/min, Latencia=%.0fms, CPU=%.0f%%\n', base_values);
fprintf('Resultados base: Amenaza=%.1f, Prioridad=%.1f\n\n', base_result(1), base_result(2));

% Análisis de sensibilidad variando cada entrada
input_names = {'Trafico', 'Accesos', 'Latencia', 'CPU'};
input_ranges = {0:10:100, 0:5:50, 0:20:200, 0:10:100};

for input_idx = 1:4
    fprintf('Variando %s:\n', input_names{input_idx});
    
    for val = input_ranges{input_idx}
        test_input = base_values;
        test_input(input_idx) = val;
        
        result = evalfis(fis, test_input);
        amenaza_change = result(1) - base_result(1);
        prioridad_change = result(2) - base_result(2);
        
        fprintf('  %s=%.0f: Amenaza=%.1f (Δ=%.1f), Prioridad=%.1f (Δ=%.1f)\n', ...
                input_names{input_idx}, val, result(1), amenaza_change, result(2), prioridad_change);
    end
    fprintf('\n');
end

% Paso 11: Visualización de sensibilidad

figure('Name', 'Análisis de Sensibilidad', 'Position', [600 100 1200 800]);

for input_idx = 1:4
    subplot(2, 2, input_idx);
    
    amenaza_vals = [];
    prioridad_vals = [];
    input_vals = [];
    
    for val = input_ranges{input_idx}
        test_input = base_values;
        test_input(input_idx) = val;
        
        result = evalfis(fis, test_input);
        amenaza_vals = [amenaza_vals result(1)];
        prioridad_vals = [prioridad_vals result(2)];
        input_vals = [input_vals val];
    end
    
    yyaxis left;
    plot(input_vals, amenaza_vals, 'b-o', 'LineWidth', 2);
    ylabel('Nivel de Amenaza', 'Color', 'b');
    ylim([0 100]);
    
    yyaxis right;
    plot(input_vals, prioridad_vals, 'r-s', 'LineWidth', 2);
    ylabel('Prioridad de Respuesta', 'Color', 'r');
    ylim([0 10]);
    
    xlabel(input_names{input_idx});
    title(sprintf('Sensibilidad a %s', input_names{input_idx}));
    grid on;
    legend('Nivel Amenaza', 'Prioridad Respuesta', 'Location', 'northwest');
end