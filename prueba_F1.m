%% X^2
% equis cuadrado
% Optimización de f(x) = x² para enteros en [0, 31]
clear all; close all; clc;

% Parámetros del AG
tam_pobla = 50;
num_generaciones = 100;
prob_mutacion = 0.1;
prob_cruce = 0.7;
tam_torneo = 3;

% Dominio entero
x_min = 0; x_max = 31;
num_bits = 5; % 2^5 = 32 valores posibles (0-31)

% Población inicial (representación binaria)
poblacion = randi([0 1], tam_pobla, num_bits);

% Para guardar las mejores aptitudes
mejores = zeros(num_generaciones, 1);

% Mostrar información inicial
fprintf('Optimización de f(x) = x^2 para enteros en [0, 31]\n');
fprintf('Representación binaria: %d bits\n', num_bits);
fprintf('Dominio: x ∈ [%d, %d]\n', x_min, x_max);
fprintf('Tamaño de población: %d\n', tam_pobla);
fprintf('Número de generaciones: %d\n\n', num_generaciones);

% Mostrar población inicial
fprintf('Población inicial (primeros 10 individuos)\n');
for i = 1:10
    x_decimal = binarioADecimal(poblacion(i,:));
    fprintf('Individuo %2d: %s -> x=%d, f(x)=%d\n', i, mat2str(poblacion(i,:)), x_decimal, x_decimal^2);
end

% Evaluar población inicial
aptitudes_iniciales = evaluarFuncion(poblacion);
fprintf('\n--- Evaluación de la población inicial ---\n');
mostrarMejoresSoluciones(poblacion, aptitudes_iniciales, 0);

fprintf('\nIniciando algoritmo genético...\n');

% Bucle principal del AG
for gen = 1:num_generaciones
    % Evaluar aptitudes
    aptitudes = evaluarFuncion(poblacion);
    
    % Guardar mejor de esta generación
    [mejores(gen), idx] = max(aptitudes);
    
    % Mostrar mejores soluciones cada 50 generaciones
    if mod(gen, 50) == 0 || gen == num_generaciones
        fprintf('\n--- Generación %d ---\n', gen);
        mostrarMejoresSoluciones(poblacion, aptitudes, gen);
    end
    
    % Selección por torneo
    seleccionados = seleccionTorneo(poblacion, aptitudes, tam_torneo);
    
    % Cruce de un punto
    hijos = cruceDeUnPunto(seleccionados, prob_cruce);
    
    % Mutación binaria
    mutados = mutacionBinaria(hijos, prob_mutacion);
    
    % Elitismo
    mejor = poblacion(idx,:);
    mutados(1,:) = mejor;
    
    % Reemplazo
    poblacion = mutados;
end

fprintf('\nEl algoritmo genético ha finalizado!\n\n');

% Mostrar las 4 mejores soluciones globales
aptitudes_finales = evaluarFuncion(poblacion);
[aptitudes_ordenadas, indices] = sort(aptitudes_finales, 'descend');

fprintf('--- Las 4 mejores soluciones globales ---\n');
fprintf('Función objetivo: f(x) = x² (maximización)\n');
for i = 1:4
    idx = indices(i);
    x_decimal = binarioADecimal(poblacion(idx,:));
    fitness = aptitudes_ordenadas(i);
    
    fprintf('Solución %d: %s -> x=%d, f(x)=%d, fitness=%.4f\n', ...
            i, mat2str(poblacion(idx,:)), x_decimal, x_decimal^2, fitness);
end

% Análisis de distribución
x_valores = zeros(tam_pobla, 1);
for i = 1:tam_pobla
    x_valores(i) = binarioADecimal(poblacion(i,:));
end

fprintf('\nAnálisis de la población final:\n');
fprintf('Valor máximo encontrado: %d\n', max(x_valores));
fprintf('Valor mínimo encontrado: %d\n', min(x_valores));
fprintf('Valor promedio: %.2f\n', mean(x_valores));

% Verificar óptimo global
fprintf('\nÓptimo global conocido: x=31, f(31)=961\n');
if max(x_valores) == 31
    fprintf('¡Óptimo global encontrado!\n');
else
    fprintf('Mejor valor encontrado: x=%d, f(%d)=%d\n', max(x_valores), max(x_valores), max(x_valores)^2);
end

% Gráficas
x_plot = 0:31;
y_plot = x_plot.^2;

figure(1);
plot(x_plot, y_plot, 'b-', 'LineWidth', 2);
hold on;
scatter(x_valores, x_valores.^2, 50, 'r', 'filled');
title('Función f(x) = x² y población final');
xlabel('x'); ylabel('f(x)');
legend('f(x) = x²', 'Población final');
grid on;

figure(2);
plot(1:num_generaciones, mejores, 'LineWidth', 2);
xlabel('Generación');
ylabel('Aptitud');
title('Evolución del algoritmo genético');
grid on;

figure(3);
hist(x_valores, 0:31);
title('Distribución de valores x en población final');
xlabel('x'); ylabel('Frecuencia');

function mostrarMejoresSoluciones(poblacion, aptitudes, generacion)
    tolerancia = 1e-6;
    
    % Encontrar soluciones únicas basadas en aptitud
    [aptitudes_unicas, ~, ~] = uniquetol(aptitudes, tolerancia, 'DataScale', 1);
    [aptitudes_ordenadas, ~] = sort(aptitudes_unicas, 'descend');
    
    fprintf('Soluciones únicas encontradas (ordenadas por aptitud):\n');
    contador = 0;
    
    for i = 1:min(8, length(aptitudes_ordenadas))
        % Encontrar individuo con esta aptitud
        indices = find(abs(aptitudes - aptitudes_ordenadas(i)) < tolerancia);
        
        if ~isempty(indices)
            contador = contador + 1;
            idx = indices(1);
            x_decimal = binarioADecimal(poblacion(idx,:));
            
            % Justificación breve
            justificacion = '';
            if x_decimal >= 28
                justificacion = '(cerca del óptimo)';
            elseif x_decimal >= 20
                justificacion = '(región alta)';
            elseif x_decimal >= 10
                justificacion = '(región media)';
            else
                justificacion = '(región baja)';
            end
            
            fprintf('#%d: %s -> x=%d, f(x)=%d, fitness=%.4f %s\n', ...
                    contador, mat2str(poblacion(idx,:)), x_decimal, x_decimal^2, aptitudes_ordenadas(i), justificacion);
        end
    end
    
    fprintf('Total: %d soluciones únicas de %d evaluadas.\n', length(aptitudes_unicas), length(aptitudes));
end

function x_decimal = binarioADecimal(individuo)
    x_decimal = 0;
    for i = 1:length(individuo)
        x_decimal = x_decimal + individuo(i) * 2^(length(individuo) - i);
    end
    x_decimal = min(x_decimal, 31); % Asegurar que esté en [0, 31]
end

function aptitudes = evaluarFuncion(poblacion)
    n = size(poblacion, 1);
    aptitudes = zeros(n, 1);
    
    for i = 1:n
        x = binarioADecimal(poblacion(i,:));
        aptitudes(i) = x^2; % Maximizar x²
    end
end

function mutados = mutacionBinaria(poblacion, prob)
    [n, d] = size(poblacion);
    mascara = rand(n, d) < prob;
    
    mutados = poblacion;
    mutados(mascara) = 1 - mutados(mascara); % Flip bits
end

function seleccionados = seleccionTorneo(poblacion, aptitudes, k)
    n = size(poblacion, 1);
    seleccionados = zeros(size(poblacion));
    
    for i = 1:n
        idx = randperm(n, k);
        [~, mejor] = max(aptitudes(idx));
        seleccionados(i,:) = poblacion(idx(mejor), :);
    end
end

function hijos = cruceDeUnPunto(poblacion, prob)
    [len, num_genes] = size(poblacion);
    hijos = zeros(size(poblacion));
    
    for i = 1:2:len-1
        p1 = poblacion(i,:);
        p2 = poblacion(i+1,:);
        
        if rand < prob
            punto = randi([1 num_genes-1]);
            hijos(i,:) = [p1(1:punto), p2(punto+1:end)];
            hijos(i+1,:) = [p2(1:punto), p1(punto+1:end)];
        else
            hijos(i,:) = p1;
            hijos(i+1,:) = p2;
        end
    end
end
%%

%%

%%

%%

%%

%%

%%
% Ajuste de coeficientes de parábola con AG
clear all; close all; clc;

% Parámetros del AG
tam_pobla = 50;
num_generaciones = 150;
prob_mutacion = 0.1;
prob_cruce = 0.7;
sigma = 0.3;
tam_torneo = 3;

% Límites para los coeficientes a, b, c
a_min = -10; a_max = 10;
b_min = -10; b_max = 10;
c_min = -10; c_max = 10;

% Datos objetivo (parábola verdadera: y = 2x² - 3x + 1)
x_datos = linspace(-3, 3, 20);
y_objetivo = 2*x_datos.^2 - 3*x_datos + 1;
y_objetivo = y_objetivo + 0.1*randn(size(y_objetivo)); % Ruido

% Población inicial (a, b, c para cada individuo)
poblacion = rand(tam_pobla, 3);
poblacion(:,1) = poblacion(:,1) * (a_max - a_min) + a_min;
poblacion(:,2) = poblacion(:,2) * (b_max - b_min) + b_min;
poblacion(:,3) = poblacion(:,3) * (c_max - c_min) + c_min;

% Para guardar las mejores aptitudes
mejores = zeros(num_generaciones, 1);

% Mostrar información inicial
fprintf('Ajuste de coeficientes de parábola y = ax² + bx + c\n');
fprintf('Coeficientes objetivo: a=2, b=-3, c=1\n');
fprintf('Número de puntos de datos: %d\n', length(x_datos));
fprintf('Tamaño de población: %d\n', tam_pobla);
fprintf('Número de generaciones: %d\n\n', num_generaciones);

% Mostrar población inicial
fprintf('Población inicial (primeros 10 individuos)\n');
for i = 1:10
    fprintf('Individuo %2d: a=%.3f, b=%.3f, c=%.3f\n', i, poblacion(i,1), poblacion(i,2), poblacion(i,3));
end

% Evaluar población inicial
aptitudes_iniciales = evaluarAjuste(poblacion, x_datos, y_objetivo);
fprintf('\n--- Evaluación de la población inicial ---\n');
mostrarMejoresSoluciones(poblacion, aptitudes_iniciales, x_datos, y_objetivo, 0);

fprintf('\nIniciando algoritmo genético...\n');

% Bucle principal del AG
for gen = 1:num_generaciones
    % Evaluar aptitudes
    aptitudes = evaluarAjuste(poblacion, x_datos, y_objetivo);
    
    % Guardar mejor de esta generación
    [mejores(gen), idx] = max(aptitudes);
    
    % Mostrar mejores soluciones cada 50 generaciones
    if mod(gen, 50) == 0 || gen == num_generaciones
        fprintf('\n--- Generación %d ---\n', gen);
        mostrarMejoresSoluciones(poblacion, aptitudes, x_datos, y_objetivo, gen);
    end
    
    % Selección por torneo
    seleccionados = seleccionTorneo(poblacion, aptitudes, tam_torneo);
    
    % Cruce de un punto
    hijos = cruceDeUnPunto(seleccionados, prob_cruce);
    
    % Mutación gaussiana
    mutados = mutacionGaussiana(hijos, prob_mutacion, sigma, a_min, a_max, b_min, b_max, c_min, c_max);
    
    % Elitismo
    mejor = poblacion(idx,:);
    mutados(1,:) = mejor;
    
    % Reemplazo
    poblacion = mutados;
end

fprintf('\nEl algoritmo genético ha finalizado!\n\n');

% Mostrar las 4 mejores soluciones globales
aptitudes_finales = evaluarAjuste(poblacion, x_datos, y_objetivo);
[aptitudes_ordenadas, indices] = sort(aptitudes_finales, 'descend');

fprintf('--- Las 4 mejores soluciones globales ---\n');
fprintf('Objetivo: a=2.000, b=-3.000, c=1.000\n');
for i = 1:4
    idx = indices(i);
    a = poblacion(idx, 1);
    b = poblacion(idx, 2);
    c = poblacion(idx, 3);
    fitness = aptitudes_ordenadas(i);
    
    y_predicha = a*x_datos.^2 + b*x_datos + c;
    rmse = sqrt(mean((y_objetivo - y_predicha).^2));
    
    fprintf('Solución %d: a=%.4f, b=%.4f, c=%.4f, fitness=%.4f, rmse=%.4f\n', ...
            i, a, b, c, fitness, rmse);
end

% Mejor ajuste encontrado
mejor_idx = indices(1);
mejor_a = poblacion(mejor_idx, 1);
mejor_b = poblacion(mejor_idx, 2);
mejor_c = poblacion(mejor_idx, 3);

fprintf('\nMejor ajuste: y = %.4fx² + %.4fx + %.4f\n', mejor_a, mejor_b, mejor_c);

% Gráficas
x_continuo = linspace(-3, 3, 100);
y_objetivo_continuo = 2*x_continuo.^2 - 3*x_continuo + 1;
y_mejor_continuo = mejor_a*x_continuo.^2 + mejor_b*x_continuo + mejor_c;

figure(1);
plot(x_continuo, y_objetivo_continuo, 'b-', 'LineWidth', 2);
hold on;
plot(x_continuo, y_mejor_continuo, 'r--', 'LineWidth', 2);
scatter(x_datos, y_objetivo, 50, 'k', 'filled');
title('Ajuste de parábola');
xlabel('x'); ylabel('y');
legend('Parábola objetivo', 'Mejor ajuste', 'Datos');
grid on;

figure(2);
plot(1:num_generaciones, mejores, 'LineWidth', 2);
xlabel('Generación');
ylabel('Aptitud');
title('Evolución del algoritmo genético');
grid on;

figure(3);
hist(aptitudes_finales, 20);
title('Distribución de aptitudes finales');
xlabel('Aptitud'); ylabel('Frecuencia');

function mostrarMejoresSoluciones(poblacion, aptitudes, x_datos, y_objetivo, generacion)
    tolerancia = 1e-4;
    
    % Encontrar soluciones únicas basadas en aptitud
    [aptitudes_unicas, ~, ~] = uniquetol(aptitudes, tolerancia, 'DataScale', 1);
    [aptitudes_ordenadas, ~] = sort(aptitudes_unicas, 'descend');
    
    fprintf('Soluciones únicas encontradas (ordenadas por aptitud):\n');
    contador = 0;
    
    for i = 1:min(5, length(aptitudes_ordenadas))
        % Encontrar individuo con esta aptitud
        indices = find(abs(aptitudes - aptitudes_ordenadas(i)) < tolerancia);
        
        if ~isempty(indices)
            contador = contador + 1;
            idx = indices(1);
            a = poblacion(idx, 1);
            b = poblacion(idx, 2);
            c = poblacion(idx, 3);
            
            y_predicha = a*x_datos.^2 + b*x_datos + c;
            rmse = sqrt(mean((y_objetivo - y_predicha).^2));
            
            % Justificación breve
            justificacion = '';
            if rmse < 0.5
                justificacion = '(excelente ajuste)';
            elseif rmse < 1.0
                justificacion = '(buen ajuste)';
            elseif rmse < 2.0
                justificacion = '(ajuste aceptable)';
            else
                justificacion = '(ajuste pobre)';
            end
            
            fprintf('#%d: a=%.4f, b=%.4f, c=%.4f, fitness=%.4f, rmse=%.4f %s\n', ...
                    contador, a, b, c, aptitudes_ordenadas(i), rmse, justificacion);
        end
    end
    
    fprintf('Total: %d soluciones únicas de %d evaluadas.\n', length(aptitudes_unicas), length(aptitudes));
end

function aptitudes = evaluarAjuste(poblacion, x_datos, y_objetivo)
    n = size(poblacion, 1);
    aptitudes = zeros(n, 1);
    
    for i = 1:n
        a = poblacion(i, 1);
        b = poblacion(i, 2);
        c = poblacion(i, 3);
        
        y_predicha = a*x_datos.^2 + b*x_datos + c;
        
        % Error cuadrático medio
        mse = mean((y_objetivo - y_predicha).^2);
        
        % Aptitud como inverso del error
        aptitudes(i) = 1 / (1 + mse);
    end
end

function mutados = mutacionGaussiana(poblacion, prob, sigma, a_min, a_max, b_min, b_max, c_min, c_max)
    [n, d] = size(poblacion);
    mascara = rand(n, d) < prob;
    ruido = sigma * randn(n, d);
    
    mutados = poblacion;
    mutados(mascara) = mutados(mascara) + ruido(mascara);
    
    mutados(:,1) = max(min(mutados(:,1), a_max), a_min);
    mutados(:,2) = max(min(mutados(:,2), b_max), b_min);
    mutados(:,3) = max(min(mutados(:,3), c_max), c_min);
end

function seleccionados = seleccionTorneo(poblacion, aptitudes, k)
    n = size(poblacion, 1);
    seleccionados = zeros(size(poblacion));
    
    for i = 1:n
        idx = randperm(n, k);
        [~, mejor] = max(aptitudes(idx));
        seleccionados(i,:) = poblacion(idx(mejor), :);
    end
end

function hijos = cruceDeUnPunto(poblacion, prob)
    [len, num_genes] = size(poblacion);
    hijos = zeros(size(poblacion));
    
    for i = 1:2:len-1
        p1 = poblacion(i,:);
        p2 = poblacion(i+1,:);
        
        if rand < prob
            punto = randi([1 num_genes-1]);
            hijos(i,:) = [p1(1:punto), p2(punto+1:end)];
            hijos(i+1,:) = [p2(1:punto), p1(punto+1:end)];
        else
            hijos(i,:) = p1;
            hijos(i+1,:) = p2;
        end
    end
end

%%

%%

%%

%%

%%

%%
% Mochila
clear; clc; close;
% Parámetros del problema
pesos = [10, 20, 30, 15, 25, 5, 35, 12, 22, 18];
valores = [60, 100, 120, 70, 90, 30, 150, 50, 80, 110];
capacidad_maxima = 100;
num_items = length(pesos);

% Parámetros del algoritmo genético
num_generaciones = 200;
tam_poblacion = 100;
prob_cruce = 0.8;
prob_mutacion = 0.02;
maximos = zeros(num_generaciones, 1);
mejores_individuos = zeros(num_generaciones, num_items);

% Inicialización de la población
poblacion = randi([0 1], tam_poblacion, num_items);

% Mostrar información inicial del problema
fprintf('Problema de la mochila\n');
fprintf('Items disponibles: %d\n', num_items);
fprintf('Capacidad máxima: %d\n', capacidad_maxima);
fprintf('Tamaño de población: %d\n', tam_poblacion);
fprintf('Número de generaciones: %d\n\n', num_generaciones);

fprintf('Datos de los items:\n');
fprintf('Item\tPeso\tValor\n');
for i = 1:num_items
    fprintf('%d\t%d\t%d\n', i, pesos(i), valores(i));
end

% Mostrar población inicial
fprintf('\n Población inicial\n');
fprintf('Primeros 10 individuos de la población inicial:\n');
for i = 1:10
    fprintf('Individuo %2d: [%s]\n', i, mat2str(poblacion(i, :)));
end

% Evaluar y mostrar soluciones en la población inicial
fprintf('\n Evaluación de la población inicial\n');
aptitudes_iniciales = evaluarAptitud(poblacion, pesos, valores, capacidad_maxima);
mostrarTodasLasSoluciones(poblacion, aptitudes_iniciales, pesos, valores, capacidad_maxima, 0);

% Algoritmo genético principal
for gen = 1:num_generaciones
    % evaluación de aptitud
    aptitudes = evaluarAptitud(poblacion, pesos, valores, capacidad_maxima);
    
    % mejor aptitud
    maximos(gen) = max(aptitudes);
    [~, idx] = max(aptitudes);
    mejores_individuos(gen, :) = poblacion(idx, :);
    
    % Mostrar todas las soluciones cada 50 generaciones
    if mod(gen, 50) == 0 || gen == num_generaciones
        fprintf('\n Generación %d\n', gen);
        mostrarTodasLasSoluciones(poblacion, aptitudes, pesos, valores, capacidad_maxima, gen);
    end
    
    % selección
    seleccionados = seleccionPorTorneo(poblacion, aptitudes, 6);
    
    % cruce 
    hijos = cruceDeUnPunto(seleccionados, prob_cruce);
    
    % mutacion
    mutados = mutacionFlipBit(hijos, prob_mutacion);
    
    % Reemplazar poblacion original
    poblacion = mutados; 
end

% Función para evaluar aptitud
function aptitudes = evaluarAptitud(poblacion, pesos, valores, capacidad_maxima)
    [len, ~] = size(poblacion);
    aptitudes = zeros(len, 1);
    
    for i = 1:len
        mask = poblacion(i,:) == 1;
        valor_individuo = sum(valores(mask));
        peso_total = sum(pesos(mask));
        
        if peso_total > capacidad_maxima
            aptitudes(i) = 0;
        else
            aptitudes(i) = valor_individuo;
        end
    end
end

function mostrarTodasLasSoluciones(poblacion, aptitudes, pesos, valores, capacidad_maxima, generacion)
    % Encontrar soluciones válidas
    soluciones_validas = find(aptitudes > 0);
    if isempty(soluciones_validas)
        fprintf('No se encontraron soluciones válidas en esta generación.\n');
        return;
    end
    
    % Ordenar y filtrar soluciones únicas
    valores_aptitud = aptitudes(soluciones_validas);
    [valores_ordenados, indices_orden] = sort(valores_aptitud, 'descend');
    soluciones_ordenadas = soluciones_validas(indices_orden);
    
    [~, indices_unicos] = unique(poblacion(soluciones_ordenadas, :), 'rows', 'stable');
    soluciones_unicas = soluciones_ordenadas(indices_unicos);
    aptitudes_unicas = valores_ordenados(indices_unicos);
    
    fprintf('Todas las soluciones únicas (ordenadas por valor descendente) son:\n');
    
    for i = 1:length(soluciones_unicas)
        idx = soluciones_unicas(i);
        individuo = poblacion(idx, :);
        items_seleccionados = find(individuo == 1);
        peso_total = sum(pesos(items_seleccionados));
        valor_total = sum(valores(items_seleccionados));
        
        fprintf('\nSolución Única #%d (Individuo %d)\n', i, idx);
        fprintf(' Cromosoma: %s\n', mat2str(individuo));
        fprintf(' Items seleccionados: %s\n', mat2str(items_seleccionados));
        fprintf(' Peso total: %d/%d\n', peso_total, capacidad_maxima);
        fprintf(' Valor total: %d\n', valor_total);
        
        % Justificación de por qué es una solución
        fprintf(' Esta es una solución válida porque:\n');
        fprintf(' - Peso total (%d) ≤ Capacidad máxima (%d)\n', peso_total, capacidad_maxima);
        fprintf(' - Valor total obtenido: %d\n', valor_total);
        fprintf(' - Posición en ranking de soluciones únicas: #%d de %d\n', i, length(soluciones_unicas));
    end
    
    fprintf('\nResumen: Se encontraron %d soluciones válidas total, de las cuales %d son únicas\n', ...
            length(soluciones_validas), length(soluciones_unicas));
end

% Función de selección por torneo
function seleccionados = seleccionPorTorneo(poblacion, fitness, k)
    len = size(poblacion, 1);
    seleccionados = zeros(size(poblacion));
    
    for i = 1:len
        indices = randperm(len, k);
        
        [~, best_idx] = max(fitness(indices));
        seleccionados(i,:) = poblacion(indices(best_idx), :);
    end
end

% Función de cruce de un punto
function hijos = cruceDeUnPunto(poblacion, prob)
    hijos = zeros(size(poblacion));
    len = size(poblacion, 1);
    num_genes = size(poblacion, 2);
    
    for i = 1:2:len-1
        p1 = poblacion(i, :);
        p2 = poblacion(i+1, :);
        
        if rand < prob
            punto = randi([1 num_genes-1]);
            hijos(i, :) = [p1(1:punto) p2(punto+1:end)];
            hijos(i+1, :) = [p2(1:punto) p1(punto+1:end)];
        else
            hijos(i, :) = p1;
            hijos(i+1, :) = p2;
        end
    end
end

% Función de mutación flip bit
function mutados = mutacionFlipBit(hijos, probabilidad)
    [len, num_genes] = size(hijos);
    mascara = rand(len, num_genes) < probabilidad;
    mutados = hijos;
    mutados(mascara) = 1 - mutados(mascara);
end

% Gráficas
figure(1)
plot(1:num_generaciones, maximos, 'b-', 'LineWidth', 2)
xlabel('Generación')
ylabel('Mejor aptitud')
title('Evolución de la Mejor Aptitud por Generación')
grid on

% Resultados finales
fprintf('\n___ Resultados Finales ___\n');

% Mejor solución de la última generación
aptitudes_finales = evaluarAptitud(poblacion, pesos, valores, capacidad_maxima);
[mejor_aptitud, idx] = max(aptitudes_finales);
mejor_individuo = poblacion(idx, :);

fprintf('Mejor aptitud en la generación final: %d\n', mejor_aptitud);
fprintf('Items seleccionados: %s\n', mat2str(find(mejor_individuo)));

% Mejor solución global
mejor_aptitud_global = max(maximos);
[~, idy] = max(maximos);
mejor_individuo_global = mejores_individuos(idy, :);

fprintf('\nMejor aptitud global obtenida: %d (Generación %d)\n', mejor_aptitud_global, idy);
fprintf('Items seleccionados en la mejor solución: %s\n', mat2str(find(mejor_individuo_global)));

% Mostrar detalles de la mejor solución global
items_mejor_global = find(mejor_individuo_global == 1);
peso_mejor_global = sum(pesos(items_mejor_global));
fprintf('\nDetalle de la mejor solución global:\n');
fprintf('Peso total: %d/%d\n', peso_mejor_global, capacidad_maxima);
fprintf('Valor total: %d\n', mejor_aptitud_global);
fprintf('Items incluidos:\n');
for i = 1:length(items_mejor_global)
    item = items_mejor_global(i);
    fprintf('  Item %d: Peso=%d, Valor=%d\n', item, pesos(item), valores(item));
end

%%

%%

%%

%%

%%

%%

%%
% Himmelblau
clear all; close all; clc;

% Parámetros del AG
tam_pobla = 50;
num_generaciones = 200;
prob_mutacion = 0.1;
prob_cruce = 0.7;
sigma = 0.5;
tam_torneo = 3;

% Límites del dominio de Himmelblau
x_min = -5; x_max = 5;
y_min = -5; y_max = 5;

% Población inicial (x, y para cada individuo)
poblacion = rand(tam_pobla, 2);
poblacion(:,1) = poblacion(:,1) * (x_max - x_min) + x_min;
poblacion(:,2) = poblacion(:,2) * (y_max - y_min) + y_min;

% Para guardar las mejores aptitudes
mejores = zeros(num_generaciones, 1);

% Mostrar información inicial
fprintf('Optimización de la función de Himmelblau\n');
fprintf('Dominio: x ∈ [%.1f, %.1f], y ∈ [%.1f, %.1f]\n', x_min, x_max, y_min, y_max);
fprintf('Tamaño de población: %d\n', tam_pobla);
fprintf('Número de generaciones: %d\n\n', num_generaciones);

% Mostrar población inicial
fprintf('Población inicial (primeros 10 individuos)\n');
for i = 1:10
    fprintf('Individuo %2d: x=%.3f, y=%.3f\n', i, poblacion(i,1), poblacion(i,2));
end

% Evaluar población inicial
aptitudes_iniciales = evaluarHimmelblau(poblacion);
fprintf('\n--- Evaluación de la población inicial ---\n');
mostrarMejoresSoluciones(poblacion, aptitudes_iniciales, 0);

fprintf('\nIniciando algoritmo genético...\n');

% Bucle principal del AG
for gen = 1:num_generaciones
    % Evaluar aptitudes
    aptitudes = evaluarHimmelblau(poblacion);
    
    % Guardar mejor de esta generación
    [mejores(gen), idx] = max(aptitudes);
    
    % Mostrar mejores soluciones cada 50 generaciones
    if mod(gen, 50) == 0 || gen == num_generaciones
        fprintf('\n--- Generación %d ---\n', gen);
        mostrarMejoresSoluciones(poblacion, aptitudes, gen);
    end
    
    % Selección por torneo
    seleccionados = seleccionTorneo(poblacion, aptitudes, tam_torneo);
    
    % Cruce de un punto
    hijos = cruceDeUnPunto(seleccionados, prob_cruce);
    
    % Mutación gaussiana
    mutados = mutacionGaussiana(hijos, prob_mutacion, sigma, x_min, x_max, y_min, y_max);
    
    % Elitismo
    mejor = poblacion(idx,:);
    mutados(1,:) = mejor;
    
    % Reemplazo
    poblacion = mutados;
end

fprintf('\nEl algoritmo genético ha finalizado!\n\n');

% Mostrar las 4 mejores soluciones globales
aptitudes_finales = evaluarHimmelblau(poblacion);
[aptitudes_ordenadas, indices] = sort(aptitudes_finales, 'descend');

fprintf('--- Las 4 mejores soluciones globales ---\n');
for i = 1:4
    idx = indices(i);
    x = poblacion(idx, 1);
    y = poblacion(idx, 2);
    fitness = aptitudes_ordenadas(i);
    valor_funcion = himmelblau(x, y);
    
    fprintf('Solución %d: x=%.4f, y=%.4f, fitness=%.4f, f(x,y)=%.4f\n', ...
            i, x, y, fitness, valor_funcion);
end

% Verificar cercanía a los mínimos conocidos
fprintf('\nMínimos conocidos de Himmelblau:\n');
minimos = [3, 2; -2.805118, 3.131312; -3.779310, -3.283186; 3.584428, -1.848126];
for i = 1:4
    fprintf('Mínimo %d: x=%.4f, y=%.4f, f(x,y)=%.4f\n', ...
            i, minimos(i,1), minimos(i,2), himmelblau(minimos(i,1), minimos(i,2)));
end

% Gráficas
x = linspace(x_min, x_max, 100);
y = linspace(y_min, y_max, 100);
[X, Y] = meshgrid(x, y);
Z = himmelblau(X, Y);

figure(1);
surf(X, Y, Z);
title('Superficie de Himmelblau');
xlabel('x'); ylabel('y'); zlabel('f(x,y)');

figure(2);
plot(1:num_generaciones, mejores, 'LineWidth', 2);
xlabel('Generación');
ylabel('Aptitud');
title('Evolución del algoritmo genético');
grid on;

figure(3);
hist(aptitudes_finales, 20);
title('Distribución de aptitudes finales');
xlabel('Aptitud'); ylabel('Frecuencia');

function mostrarMejoresSoluciones(poblacion, aptitudes, generacion)
    tolerancia = 1e-3;
    
    % Encontrar soluciones únicas basadas en aptitud
    [aptitudes_unicas, ~, ~] = uniquetol(aptitudes, tolerancia, 'DataScale', 1);
    [aptitudes_ordenadas, ~] = sort(aptitudes_unicas, 'descend');
    
    fprintf('Soluciones únicas encontradas (ordenadas por aptitud):\n');
    contador = 0;
    
    for i = 1:length(aptitudes_ordenadas)
        % Encontrar todos los individuos con esta aptitud
        indices = find(abs(aptitudes - aptitudes_ordenadas(i)) < tolerancia);
        
        if ~isempty(indices)
            contador = contador + 1;
            idx = indices(1);
            x = poblacion(idx, 1);
            y = poblacion(idx, 2);
            valor_funcion = himmelblau(x, y);
            
            % Justificación breve
            justificacion = '';
            if valor_funcion < 0.1
                justificacion = '(cerca de mínimo global)';
            elseif valor_funcion < 50
                justificacion = '(región de baja energía)';
            else
                justificacion = '(exploración)';
            end
            
            fprintf('#%d: x=%.4f, y=%.4f, fitness=%.4f, f(x,y)=%.4f %s\n', ...
                    contador, x, y, aptitudes_ordenadas(i), valor_funcion, justificacion);
        end
    end
    
    fprintf('Total: %d soluciones únicas de %d evaluadas.\n', contador, length(aptitudes));
end

function f = himmelblau(x, y)
    f = (x.^2 + y - 11).^2 + (x + y.^2 - 7).^2;
end

function aptitudes = evaluarHimmelblau(poblacion)
    n = size(poblacion, 1);
    aptitudes = zeros(n, 1);
    
    for i = 1:n
        x = poblacion(i, 1);
        y = poblacion(i, 2);
        valor = himmelblau(x, y);
        aptitudes(i) = 1 / (1 + valor);
    end
end

function mutados = mutacionGaussiana(poblacion, prob, sigma, x_min, x_max, y_min, y_max)
    [n, d] = size(poblacion);
    mascara = rand(n, d) < prob;
    ruido = sigma * randn(n, d);
    
    mutados = poblacion;
    mutados(mascara) = mutados(mascara) + ruido(mascara);
    
    mutados(:,1) = max(min(mutados(:,1), x_max), x_min);
    mutados(:,2) = max(min(mutados(:,2), y_max), y_min);
end

function seleccionados = seleccionTorneo(poblacion, aptitudes, k)
    n = size(poblacion, 1);
    seleccionados = zeros(size(poblacion));
    
    for i = 1:n
        idx = randperm(n, k);
        [~, mejor] = max(aptitudes(idx));
        seleccionados(i,:) = poblacion(idx(mejor), :);
    end
end

function hijos = cruceDeUnPunto(poblacion, prob)
    [len, num_genes] = size(poblacion);
    hijos = zeros(size(poblacion));
    
    for i = 1:2:len-1
        p1 = poblacion(i,:);
        p2 = poblacion(i+1,:);
        
        if rand < prob
            punto = randi([1 num_genes-1]);
            hijos(i,:) = [p1(1:punto), p2(punto+1:end)];
            hijos(i+1,:) = [p2(1:punto), p1(punto+1:end)];
        else
            hijos(i,:) = p1;
            hijos(i+1,:) = p2;
        end
    end
end





%%

%%

%%

%%

%%

%% Job Sequencing Problem
clear; clc; close;

n_tareas = 20;

% Generar tiempos de procesamiento y fechas límite aleatorias
tiempos_procesamiento = randi([5, 50], n_tareas, 1);
fechas_limite = cumsum(tiempos_procesamiento) + randi([0, 100], n_tareas, 1);

% Penalización en las tareas por retraso
penalizaciones = randi([10, 100], n_tareas, 1); 

% Parámetros del AG
tam_poblacion = 100;
num_generaciones = 200;
prob_cruce = 0.8;
prob_mutacion = 0.2;

% Inicialización de la población 
poblacion = zeros(tam_poblacion, n_tareas);
for i = 1:tam_poblacion
    poblacion(i,:) = randperm(n_tareas);
end

fprintf('Problema de Ordenamiento de Tareas \n');
fprintf('Número de tareas: %d\n', n_tareas);
fprintf('Tamaño de población: %d\n', tam_poblacion);
fprintf('Número de generaciones: %d\n\n', num_generaciones);

% Mostrar datos del problema
fprintf('Datos del Problema \n');
fprintf('Tarea\tTiempo\tFecha Límite\tPenalización\n');
for i = 1:min(10, n_tareas)
    fprintf('%d\t%d\t%d\t\t%d\n', i, tiempos_procesamiento(i), fechas_limite(i), penalizaciones(i));
end
fprintf('\n');

% Mostrar población inicial
fprintf(' Población Inicial (10 individuos) \n');
disp(poblacion(1:10, :));

% arreglos para almacenar estadísticas
maximos = zeros(num_generaciones, 1);
mejores_individuos = zeros(num_generaciones, n_tareas);
todas_las_soluciones = {};
historial_mejores_costos = [];

% Bucle principal de ejecución
for gen = 1:num_generaciones
    aptitudes = evaluarAptitudJSP(poblacion, tiempos_procesamiento, fechas_limite, penalizaciones);
    costos = 1 ./ aptitudes - 1;

    [~, idx] = max(aptitudes);
    maximos(gen) = costos(idx);
    mejores_individuos(gen, :) = poblacion(idx,:);
    mejor_individuo = poblacion(idx,:);
    
    % Almacenar mejores soluciones globales
    todas_las_soluciones{end+1} = struct('generacion', gen, 'individuo', mejor_individuo, 'costo', costos(idx));
    historial_mejores_costos(end+1) = costos(idx);
    
    % Imprimir soluciones
    if mod(gen, 50) == 0 || gen == 1
        mostrarProgresoSecuencia(gen, poblacion, costos, tiempos_procesamiento, fechas_limite, penalizaciones, historial_mejores_costos);
    end

    % Selección
    seleccionados = seleccionPorTorneo(poblacion, aptitudes, 5);

    % Cruce ordenado
    hijos = cruceOX(seleccionados, prob_cruce);

    % Mutación swap
    mutados = mutacionSwap(hijos, prob_mutacion);

    % Elitismo
    mutados(1,:) = mejor_individuo;

    % Nueva generación
    poblacion = mutados;
end

% Análisis final en el que se muestran las mejores 4 soluciones globales
fprintf(' Análisis Final \n');
final_aptitudes = evaluarAptitudJSP(poblacion, tiempos_procesamiento, fechas_limite, penalizaciones);
final_costos = 1 ./ final_aptitudes - 1;

% Extraer todos los costos históricos
todos_costos = [];
for i = 1:length(todas_las_soluciones)
    todos_costos(end+1) = todas_las_soluciones{i}.costo;
end

% Encontrar las 4 mejores soluciones únicas
[costos_ordenados, idx_ordenados] = sort(todos_costos);
mejores_4_soluciones = {};
soluciones_unicas = {};
count = 0;

for i = 1:length(idx_ordenados)
    sol_actual = todas_las_soluciones{idx_ordenados(i)};
    es_unica = true;
    
    % Verificar si la solución ya está en la lista
    for j = 1:length(soluciones_unicas)
        if isequal(sol_actual.individuo, soluciones_unicas{j}.individuo)
            es_unica = false;
            break;
        end
    end
    
    if es_unica && count < 4
        count = count + 1;
        soluciones_unicas{count} = sol_actual;
    end
    
    if count == 4
        break;
    end
end

% Mostrar las mejores soluciones haciendo uso de la consola
fprintf('-----------------------------------------\n')
fprintf('Estas son las mejores soluciones globales\n');
fprintf('-----------------------------------------\n')
for i = 1:length(soluciones_unicas)
    sol = soluciones_unicas{i};
    fprintf('  Puesto #%d\n', i);
    fprintf('  Generación: %-8d\n', sol.generacion);
    fprintf('  Secuencia: [%-42s] │\n', num2str(sol.individuo));
    fprintf('  Fitness (Costo): %-8.4f\n', sol.costo);
    
    % Análisis detallado de la secuencia
    [tiempo_total, retrasos, penalizacion_total] = calcularMetricasSecuencia(sol.individuo, tiempos_procesamiento, fechas_limite, penalizaciones);
    fprintf('  Tiempo total: %-8.2f | Tareas retrasadas: %-3d | Penalización: %-8.2f\n', tiempo_total, sum(retrasos > 0), penalizacion_total);
    
    % Barra visual del fitness
    if i == 1
        mejor_costo = sol.costo;
    end
    ratio = sol.costo / mejor_costo;
end

% Mejor secuencia final para gráficas
[~, idx_final] = max(final_aptitudes);
mejor = poblacion(idx_final, :);
fprintf("Costo de la mejor solución final: %.4f\n\n", 1 / final_aptitudes(idx_final) - 1);

% Gráfica de convergencia
figure('Position', [100, 100, 1200, 400]);
plot(1:num_generaciones, maximos, 'LineWidth', 2, 'Color', [0.2 0.6 0.8]);
hold on;
xlabel('Generación');
ylabel('Costo mínimo');
title('Convergencia del Algoritmo Genético - JSP');
grid on;
legend('Evolución', 'Location', 'best');

% Gráfica adicional: Comparación de las top 4 soluciones
figure('Position', [100, 550, 800, 400]);
if length(soluciones_unicas) >= 2
    costos_top4 = [];
    generaciones_top4 = [];
    for i = 1:min(4, length(soluciones_unicas))
        costos_top4(i) = soluciones_unicas{i}.costo;
        generaciones_top4(i) = soluciones_unicas{i}.generacion;
    end
    
    bar(1:length(costos_top4), costos_top4, 'FaceColor', [0.3 0.7 0.4]);
    xlabel('Ranking de Solución');
    ylabel('Costo Total');
    title('Comparación de las Mejores Soluciones Encontradas');
    grid on;
    
    % Añadir valores sobre las barras
    for i = 1:length(costos_top4)
        text(i, costos_top4(i) + max(costos_top4)*0.01, ...
            sprintf('%.2f\n(Gen %d)', costos_top4(i), generaciones_top4(i)), 'HorizontalAlignment', 'center', 'FontWeight', 'bold');
    end
end

function aptitudes = evaluarAptitudJSP(poblacion, tiempos, fechas_limite, penalizaciones)
    [n, d] = size(poblacion);
    aptitudes = zeros(n, 1);
    for i = 1:n
        secuencia = poblacion(i,:);
        costo_total = calcularCostoSecuencia(secuencia, tiempos, fechas_limite, penalizaciones);
        aptitudes(i) = 1 / (1 + costo_total); 
    end
end

function costo = calcularCostoSecuencia(secuencia, tiempos, fechas_limite, penalizaciones)
    n = length(secuencia);
    tiempo_actual = 0;
    costo = 0;
    
    for i = 1:n
        tarea = secuencia(i);
        tiempo_actual = tiempo_actual + tiempos(tarea);
        
        % Calcular retraso
        retraso = max(0, tiempo_actual - fechas_limite(tarea));
        
        % Añadir penalización por retraso
        if retraso > 0
            costo = costo + penalizaciones(tarea) * retraso;
        end
        
        % Añadir tiempo de procesamiento como parte del costo
        costo = costo + tiempos(tarea) * 0.1; % Factor de peso menor
    end
end

% Función para mostrar progreso de secuencia
function mostrarProgresoSecuencia(gen, poblacion, costos, tiempos_procesamiento, fechas_limite, penalizaciones, historial_mejores_costos)
    fprintf(' Generación %d \n', gen);
    
    % Encontrar todas las mejores soluciones en esta generación
    costo_min_gen = min(costos);
    tolerancia = costo_min_gen * 0.01;
    idx_mejores = find(costos <= costo_min_gen + tolerancia);
    
    % Filtrar soluciones únicas usando unique
    [soluciones_unicas, idx_unicos] = unique(poblacion(idx_mejores, :), 'rows', 'stable');
    idx_unicos = idx_mejores(idx_unicos);
    
    fprintf('Todas las soluciones únicas encontradas:\n');
    
    for i = 1:length(idx_unicos)
        idx_sol = idx_unicos(i);
        fprintf(' Solución %d (Índice %d): [%s]\n', i, idx_sol, num2str(poblacion(idx_sol,:)));
        fprintf(' Costo total: %.4f\n', costos(idx_sol));
        fprintf(' Justificación de su validez: ');
        
        if costos(idx_sol) == costo_min_gen
            fprintf('Esta es la mejor solución en esta generación (menor costo)\n');
        elseif costos(idx_sol) <= costo_min_gen + tolerancia
            fprintf('Esta es una de las mejores soluciones de esta generación\n');
        end
        
        % Mostrar detalles de la secuencia
        [tiempo_total, retrasos, ~] = calcularMetricasSecuencia(poblacion(idx_sol,:), tiempos_procesamiento, fechas_limite, penalizaciones);
        fprintf(' Tiempo total de procesamiento: %.2f, Número de tareas con retraso: %d\n', tiempo_total, sum(retrasos > 0));
    end
    
    fprintf(' Costo promedio en generación: %.2f\n', mean(costos));
    fprintf(' Mejor costo histórico hasta ahora: %.4f\n\n', min(historial_mejores_costos));
end

function [tiempo_total, retrasos, penalizacion_total] = calcularMetricasSecuencia(secuencia, tiempos, fechas_limite, penalizaciones)
    n = length(secuencia);
    tiempo_actual = 0;
    retrasos = zeros(n, 1);
    penalizacion_total = 0;
    
    for i = 1:n
        tarea = secuencia(i);
        tiempo_actual = tiempo_actual + tiempos(tarea);
        
        % Calcular retraso
        retraso = max(0, tiempo_actual - fechas_limite(tarea));
        retrasos(i) = retraso;
        
        % Calcular penalización
        if retraso > 0
            penalizacion_total = penalizacion_total + penalizaciones(tarea) * retraso;
        end
    end
    
    tiempo_total = tiempo_actual;
end

function tiempos_acumulados = calcularTiemposAcumulados(secuencia, tiempos)
    n = length(secuencia);
    tiempos_acumulados = zeros(n, 1);
    tiempo_actual = 0;
    
    for i = 1:n
        tarea = secuencia(i);
        tiempo_actual = tiempo_actual + tiempos(tarea);
        tiempos_acumulados(i) = tiempo_actual;
    end
end

function seleccionados = seleccionPorTorneo(poblacion, aptitudes, k)
    n = size(poblacion, 1);
    seleccionados = zeros(size(poblacion));
    for i = 1:n
        idxs = randsample(n, k);
        [~, best] = max(aptitudes(idxs));
        seleccionados(i,:) = poblacion(idxs(best), :);
    end
end

function hijos = cruceOX(poblacion, prob)
    [n, d] = size(poblacion);
    hijos = zeros(size(poblacion));
    for i = 1:2:n-1
        p1 = poblacion(i,:);
        p2 = poblacion(i+1,:);
        if rand < prob
            punto1 = randi([1 d-1]);
            punto2 = randi([punto1+1 d]);
            h1 = ordenCruzado(p1, p2, punto1, punto2);
            h2 = ordenCruzado(p2, p1, punto1, punto2);
            hijos(i,:) = h1;
            hijos(i+1,:) = h2;
        else
            hijos(i,:) = p1;
            hijos(i+1,:) = p2;
        end
    end
end

function hijo = ordenCruzado(p1, p2, punto1, punto2)
    d = length(p1);
    hijo = zeros(1, d);
    hijo(punto1:punto2) = p1(punto1:punto2);
    pos = mod(punto2, d) + 1;
    j = pos;
    for k = 1:d
        gene = p2(mod(punto2 + k - 1, d) + 1);
        if ~ismember(gene, hijo)
            hijo(j) = gene;
            j = mod(j, d) + 1;
        end
    end
end

function mutados = mutacionSwap(poblacion, prob)
    [n, d] = size(poblacion);
    mutados = poblacion;
    for i = 1:n
        if rand < prob
            idx = randperm(d, 2);
            temp = mutados(i, idx(1));
            mutados(i, idx(1)) = mutados(i, idx(2));
            mutados(i, idx(2)) = temp;
        end
    end
end






%%

%%

%%

%%

%%

%% Viajante TSP
clear; clc; close;
n_ciudades = 20;
coordenadas = rand(n_ciudades, 2) * 100;

% Parámetros del AG
tam_poblacion = 100;
num_generaciones = 200;
prob_cruce = 0.8;
prob_mutacion = 0.2;

% Inicialización de la población 
poblacion = zeros(tam_poblacion, n_ciudades);
for i = 1:tam_poblacion
    poblacion(i,:) = randperm(n_ciudades);
end

fprintf('___ Problema del viajante ___\n');
fprintf('Número de ciudades: %d\n', n_ciudades);
fprintf('Tamaño de población: %d\n', tam_poblacion);
fprintf('Número de generaciones: %d\n\n', num_generaciones);

% Mostrar población inicial
fprintf('___ Población Inicial ___\n');
aptitudes_iniciales = evaluarAptitudTSP(poblacion, coordenadas);
distancias_iniciales = 1 ./ aptitudes_iniciales - 1;
[dist_inicial_min, idx_inicial_min] = min(distancias_iniciales);
[dist_inicial_max, idx_inicial_max] = max(distancias_iniciales);

fprintf('Mejor individuo inicial (Índice %d): [%s] - Distancia: %.2f\n', ...
    idx_inicial_min, num2str(poblacion(idx_inicial_min,:)), dist_inicial_min);
fprintf('Peor individuo inicial (Índice %d): [%s] - Distancia: %.2f\n', ...
    idx_inicial_max, num2str(poblacion(idx_inicial_max,:)), dist_inicial_max);
fprintf('Distancia promedio inicial: %.2f\n', mean(distancias_iniciales));
fprintf('Rango de distancias: [%.2f - %.2f]\n\n', dist_inicial_min, dist_inicial_max);

% Arrays para almacenar estadísticas
maximos = zeros(num_generaciones, 1);
mejores_individuos = zeros(num_generaciones, n_ciudades);
todas_las_soluciones = {};
historial_mejores_distancias = [];

for gen = 1:num_generaciones
    aptitudes = evaluarAptitudTSP(poblacion, coordenadas);
    distancias = 1 ./ aptitudes - 1;

    [~, idx] = max(aptitudes);
    maximos(gen) = distancias(idx);
    mejores_individuos(gen, :) = poblacion(idx,:);
    mejor_individuo = poblacion(idx,:);
    
    % Almacenar mejores soluciones globales
    todas_las_soluciones{end+1} = struct('generacion', gen, 'individuo', mejor_individuo, 'distancia', distancias(idx));
    historial_mejores_distancias(end+1) = distancias(idx);

    % Mostrar soluciones cada x generaciones
    if mod(gen, 50) == 0 || gen == 1
        fprintf('___ Generación %d ___\n', gen);
        
        % Encontrar mejores soluciones con tolerancia
        dist_min_gen = min(distancias);
        tolerancia = dist_min_gen * 0.01;
        idx_mejores = find(distancias <= dist_min_gen + tolerancia);
        
        % Obtener soluciones únicas
        soluciones_mejores = poblacion(idx_mejores, :);
        [soluciones_unicas, idx_unicos_rel] = unique(soluciones_mejores, 'rows');
        idx_unicos = idx_mejores(idx_unicos_rel);
        
        % Mostrar todas las soluciones únicas
        num_mostrar = length(idx_unicos);
        fprintf('Todas las soluciones únicas encontradas:\n');
        
        for i = 1:num_mostrar
            idx_sol = idx_unicos(i);
            fprintf(' Solución %d (Índice %d): [%s]\n', i, idx_sol, num2str(poblacion(idx_sol,:)));
            fprintf(' Distancia: %.4f\n', distancias(idx_sol));
            fprintf(' Justificación de su validez: ');
            
            % Justificar por qué es una solución
            if distancias(idx_sol) == dist_min_gen
                fprintf('Esta es la mejor solución en esta generación (menor distancia)\n');
            elseif distancias(idx_sol) <= dist_min_gen + tolerancia
                fprintf('Esta es una de las mejores soluciones de esta generación (dentro del %.1f%% de la mejor solución)\n', (tolerancia/dist_min_gen)*100);
            end
            
            % Verificar validez de la ruta
            if length(unique(poblacion(idx_sol,:))) == n_ciudades && all(sort(poblacion(idx_sol,:)) == 1:n_ciudades)
                fprintf(' Además, esta solución es válida ya que visita todas las ciudades exactamente una vez\n');
            end
        end
        
        fprintf(' Total de soluciones únicas mostradas: %d de %d encontradas\n', num_mostrar, length(idx_unicos));
        fprintf(' Distancia promedio en generación: %.2f\n', mean(distancias));
        fprintf(' Mejor distancia histórica hasta ahora: %.4f\n\n', min(historial_mejores_distancias));
    end

    % Selección
    seleccionados = seleccionPorTorneo(poblacion, aptitudes, 5);

    % Cruce ordenado
    hijos = cruceOX(seleccionados, prob_cruce);

    % Mutación swap
    mutados = mutacionSwap(hijos, prob_mutacion);

    % Elitismo
    mutados(1,:) = mejor_individuo;

    % Nueva generación
    poblacion = mutados;
end

% Análisis final en el que se muestran las mejores 4 soluciones globales
fprintf(' Análisis Final \n');
final_aptitudes = evaluarAptitudTSP(poblacion, coordenadas);
final_distancias = 1 ./ final_aptitudes - 1;

% Extraer todas las distancias históricas
todas_distancias = [];
for i = 1:length(todas_las_soluciones)
    todas_distancias(end+1) = todas_las_soluciones{i}.distancia;
end

% Encontrar las 4 mejores soluciones únicas
[distancias_ordenadas, idx_ordenados] = sort(todas_distancias);
individuos_matriz = cell2mat(cellfun(@(x) x.individuo, todas_las_soluciones(idx_ordenados), 'UniformOutput', false)');
[~, idx_unicos, ~] = unique(individuos_matriz, 'rows', 'stable');
num_mejores = min(4, length(idx_unicos));
idx_mejores_unicos = idx_unicos(1:num_mejores);
soluciones_unicas = cell(num_mejores, 1);
for i = 1:num_mejores
    soluciones_unicas{i} = todas_las_soluciones{idx_ordenados(idx_mejores_unicos(i))};
end

% Mostrar las mejores soluciones de forma gráfica en consola
fprintf('-----------------------------------------\n')
fprintf('Estas son las mejores soluciones globales\n');
fprintf('-----------------------------------------\n')
for i = 1:length(soluciones_unicas)
    sol = soluciones_unicas{i};
    fprintf('  Puesto #%d\n', i);
    fprintf('  Generación: %-8d                               \n', sol.generacion);
    fprintf('  Ruta: [%-42s] │\n', num2str(sol.individuo));
    fprintf('  Fitness (Distancia): %-8.4f                        \n', sol.distancia);
    fprintf(' -----------------------------------------------\n\n');
end

% Mejor ruta final para gráficas
[~, idx_final] = max(final_aptitudes);
mejor = poblacion(idx_final, :);
mejor_ruta = [mejor mejor(1)];  % vuelta a la ciudad inicial
fprintf("Distancia de la mejor solución final: %.4f\n\n", 1 / final_aptitudes(idx_final) - 1);

% Gráfica de convergencia
figure('Position', [100, 100, 1200, 400]);
subplot(1,2,1);
plot(1:num_generaciones, maximos, 'LineWidth', 2, 'Color', [0.2 0.6 0.8]);
hold on;
xlabel('Generación');
ylabel('Distancia mínima');
title('Convergencia del Algoritmo Genético - TSP');
grid on;
legend('Evolución', 'Location', 'best');

% Ruta final
subplot(1,2,2);
plot(coordenadas(mejor_ruta,1), coordenadas(mejor_ruta,2), '-o', 'LineWidth', 2, 'MarkerSize', 8);
title(sprintf('Mejor Ruta Encontrada (Distancia: %.2f)', 1 / final_aptitudes(idx_final) - 1));
xlabel('Coordenada X');
ylabel('Coordenada Y');
axis equal;
grid on;

% Gráfica adicional: Comparación de las top 4 soluciones
figure('Position', [100, 550, 800, 400]);
if length(soluciones_unicas) >= 2
    distancias_top4 = [];
    generaciones_top4 = [];
    for i = 1:min(4, length(soluciones_unicas))
        distancias_top4(i) = soluciones_unicas{i}.distancia;
        generaciones_top4(i) = soluciones_unicas{i}.generacion;
    end
    
    bar(1:length(distancias_top4), distancias_top4, 'FaceColor', [0.3 0.7 0.4]);
    xlabel('Ranking de Solución');
    ylabel('Distancia Total');
    title('Comparación de las Mejores Soluciones Encontradas');
    grid on;
    
    % Añadir valores sobre las barras
    for i = 1:length(distancias_top4)
        text(i, distancias_top4(i) + max(distancias_top4)*0.01, ...
            sprintf('%.2f\n(Gen %d)', distancias_top4(i), generaciones_top4(i)), 'HorizontalAlignment', 'center', 'FontWeight', 'bold');
    end
end

function aptitudes = evaluarAptitudTSP(poblacion, coords)
    [n, d] = size(poblacion);
    aptitudes = zeros(n, 1);
    for i = 1:n
        ruta = poblacion(i,:);
        ruta = [ruta ruta(1)];
        dist = 0;
        for j = 1:d
            a = coords(ruta(j), :);
            b = coords(ruta(j+1), :);
            dist = dist + norm(a - b);
        end
        aptitudes(i) = 1 / (1 + dist); 
    end
end

function seleccionados = seleccionPorTorneo(poblacion, aptitudes, k)
    n = size(poblacion, 1);
    seleccionados = zeros(size(poblacion));
    for i = 1:n
        idxs = randsample(n, k);
        [~, best] = max(aptitudes(idxs));
        seleccionados(i,:) = poblacion(idxs(best), :);
    end
end

function hijos = cruceOX(poblacion, prob)
    [n, d] = size(poblacion);
    hijos = zeros(size(poblacion));
    for i = 1:2:n-1
        p1 = poblacion(i,:);
        p2 = poblacion(i+1,:);
        if rand < prob
            punto1 = randi([1 d-1]);
            punto2 = randi([punto1+1 d]);
            h1 = ordenCruzado(p1, p2, punto1, punto2);
            h2 = ordenCruzado(p2, p1, punto1, punto2);
            hijos(i,:) = h1;
            hijos(i+1,:) = h2;
        else
            hijos(i,:) = p1;
            hijos(i+1,:) = p2;
        end
    end
end

function hijo = ordenCruzado(p1, p2, punto1, punto2)
    d = length(p1);
    hijo = zeros(1, d);
    hijo(punto1:punto2) = p1(punto1:punto2);
    pos = mod(punto2, d) + 1;
    j = pos;
    for k = 1:d
        gene = p2(mod(punto2 + k - 1, d) + 1);
        if ~ismember(gene, hijo)
            hijo(j) = gene;
            j = mod(j, d) + 1;
        end
    end
end

function mutados = mutacionSwap(poblacion, prob)
    [n, d] = size(poblacion);
    mutados = poblacion;
    for i = 1:n
        if rand < prob
            idx = randperm(d, 2);
            temp = mutados(i, idx(1));
            mutados(i, idx(1)) = mutados(i, idx(2));
            mutados(i, idx(2)) = temp;
        end
    end
end