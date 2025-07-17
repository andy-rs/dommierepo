%%

% Algoritmo Genético para Optimización de Reglas de Firewall
clear; clc; close all;

% Parámetros del sistema de firewall
num_reglas = 8;
num_puertos = 1024;
num_ips = 256;

% Tipos de tráfico simulado (legítimo = 1, malicioso = 0)
trafico_tipos = [
    1, 80, 192, 1;    % HTTP legítimo
    1, 443, 10, 1;    % HTTPS legítimo  
    1, 22, 50, 1;     % SSH legítimo
    0, 23, 100, 0;    % Telnet malicioso
    0, 135, 150, 0;   % RPC malicioso
    1, 25, 75, 1;     % SMTP legítimo
    0, 1433, 200, 0;  % SQL injection
    1, 53, 30, 1;     % DNS legítimo
    0, 21, 180, 0;    % FTP exploit
    1, 110, 60, 1;    % POP3 legítimo
    0, 445, 220, 0;   % SMB malicioso
    1, 993, 40, 1;    % IMAPS legítimo
    0, 3389, 250, 0;  % RDP attack
    1, 587, 45, 1;    % SMTP secure
    0, 1337, 300, 0   % Backdoor
];

% Parámetros del algoritmo genético
tam_poblacion = 60;
num_generaciones = 150;
prob_cruce = 0.8;
prob_mutacion = 0.12;

% Inicialización: cada regla tiene [accion(0=deny,1=allow), puerto_min, puerto_max, ip_min, ip_max]
poblacion = zeros(tam_poblacion, num_reglas*5);
for i = 1:tam_poblacion
    for j = 1:num_reglas
        idx = (j-1)*5 + 1;
        poblacion(i, idx) = randi([0,1]);           % acción
        puerto_min = randi([1, num_puertos-50]);
        poblacion(i, idx+1) = puerto_min;           % puerto min
        poblacion(i, idx+2) = puerto_min + randi([0,50]); % puerto max
        ip_min = randi([1, num_ips-20]);
        poblacion(i, idx+3) = ip_min;               % ip min
        poblacion(i, idx+4) = ip_min + randi([0,20]); % ip max
    end
end

maximos = zeros(num_generaciones, 1);
mejores_individuos = zeros(num_generaciones, num_reglas*5);

% Mejores soluciones globales
mejores_globales = [];
fitness_globales = [];

fprintf('Algoritmo Genético para Optimización de Reglas de Firewall\n\n');

% Mostrar población inicial
fprintf('--- Población Inicial (10 individuos) ---\n');
aptitudes_iniciales = evaluarAptitudFirewall(poblacion, trafico_tipos);
[aptitudes_ord, idx_ord] = sort(aptitudes_iniciales, 'descend');
fprintf('Los 10 mejores individuos iniciales:\n');
for i = 1:10
    individuo = poblacion(idx_ord(i), :);
    [bloqueo_mal, falsos_pos, eficiencia] = analizarRendimiento(individuo, trafico_tipos);
    fprintf('Individuo %d: Fitness: %.4f | Bloqueo malicioso: %.1f%% | Falsos positivos: %.1f%% | Eficiencia: %.3f\n', ...
        i, aptitudes_ord(i), bloqueo_mal*100, falsos_pos*100, eficiencia);
    
    fprintf('   Reglas: ');
    for j = 1:num_reglas
        idx = (j-1)*5 + 1;
        accion = individuo(idx);
        puerto_min = individuo(idx+1);
        puerto_max = individuo(idx+2);
        ip_min = individuo(idx+3);
        ip_max = individuo(idx+4);
        
        accion_str = 'ALLOW';
        if accion == 0
            accion_str = 'DENY';
        end
        fprintf('R%d(%s:%.0f-%.0f:%.0f-%.0f) ', j, accion_str, puerto_min, puerto_max, ip_min, ip_max);
    end
    fprintf('\n\n');
end
fprintf('\n');

% Algoritmo genético principal
for gen = 1:num_generaciones
    % Evaluar aptitud
    aptitudes = evaluarAptitudFirewall(poblacion, trafico_tipos);
    
    % Guardar mejor de esta generación
    [~, idx] = max(aptitudes);
    mejor_individuo_actual = poblacion(idx, :);
    maximos(gen) = aptitudes(idx);
    mejores_individuos(gen, :) = poblacion(idx, :);
    
    % Actualizar mejores globales
    if isempty(mejores_globales) || aptitudes(idx) > min(fitness_globales)
        mejores_globales = [mejores_globales; mejor_individuo_actual];
        fitness_globales = [fitness_globales; aptitudes(idx)];
        
        % Mantener solo las 4 mejores
        if length(fitness_globales) > 4
            [~, idx_sort] = sort(fitness_globales, 'descend');
            mejores_globales = mejores_globales(idx_sort(1:4), :);
            fitness_globales = fitness_globales(idx_sort(1:4));
        end
    end
    
    % Llamada modificada (reemplaza tu código original)
    if mod(gen, 50) == 0
        mostrarProgresoFirewall(gen, poblacion, aptitudes, trafico_tipos, num_reglas);
    end

    % Selección por torneo
    seleccionados = seleccionPorTorneoFirewall(poblacion, aptitudes, 6);

    % Cruce específico para reglas de firewall
    hijos = cruceReglasFirewall(seleccionados, prob_cruce);

    % Mutación con restricciones válidas
    mutados = mutacionReglasFirewall(hijos, prob_mutacion, num_puertos, num_ips);

    % Elitismo: preservar las 2 mejores soluciones
    [~, idx_elite] = sort(aptitudes, 'descend');
    mutados(1, :) = poblacion(idx_elite(1), :);
    if tam_poblacion > 1
        mutados(2, :) = poblacion(idx_elite(2), :);
    end

    % Siguiente generación
    poblacion = mutados;
end

% Mostrar resultados finales
fprintf('Resultados Finales\n\n');
fprintf('--- Cuatro mejores Soluciones Globales ---\n');
[~, idx_sort] = sort(fitness_globales, 'descend');
for i = 1:length(idx_sort)
    sol = mejores_globales(idx_sort(i), :);
    fitness = fitness_globales(idx_sort(i));
    [bloqueo_mal, falsos_pos, eficiencia] = analizarRendimiento(sol, trafico_tipos);
    seguridad = calcularSeguridad(sol, trafico_tipos);
    
    fprintf('\nSolución Global #%d:\n', i);
    fprintf('  Fitness: %.6f\n', fitness);
    fprintf('  Bloqueo de tráfico malicioso: %.1f%%\n', bloqueo_mal*100);
    fprintf('  Falsos positivos: %.1f%%\n', falsos_pos*100);
    fprintf('  Eficiencia del sistema: %.3f\n', eficiencia);
    fprintf('  Nivel de seguridad: %.3f\n', seguridad);
end

% Mejor solución absoluta
mejor_absoluta = mejores_globales(idx_sort(1), :);
fprintf('\n*** Mejor Solución Absoluta ***\n');
fprintf('Fitness: %.6f\n', fitness_globales(idx_sort(1)));
fprintf('Configuración de reglas de firewall:\n');
for i = 1:num_reglas
    idx = (i-1)*5 + 1;
    accion = mejor_absoluta(idx);
    puerto_min = mejor_absoluta(idx+1);
    puerto_max = mejor_absoluta(idx+2);
    ip_min = mejor_absoluta(idx+3);
    ip_max = mejor_absoluta(idx+4);
    
    accion_str = 'ALLOW';
    if accion == 0
        accion_str = 'DENY';
    end
    
    fprintf('  Regla %d: %s | Puertos: %.0f-%.0f | IPs: %.0f-%.0f\n', ...
        i, accion_str, puerto_min, puerto_max, ip_min, ip_max);
end

% Gráficas
figure;
plot(1:num_generaciones, maximos, 'LineWidth', 2, 'Color', [0.8 0.2 0.2]);
xlabel('Generación');
ylabel('Fitness del mejor individuo');
title('Evolución del Algoritmo Genético - Optimización Firewall');
grid on;
gen_marks = 50:50:num_generaciones;
hold on;
plot(gen_marks, maximos(gen_marks), 'ro', 'MarkerSize', 6, 'MarkerFaceColor', 'red');

% Análisis de rendimiento de la mejor solución
figure;
[bloqueo_historico, falsos_historico] = analizarEvolucion(mejores_individuos, trafico_tipos);
subplot(2,1,1);
plot(1:num_generaciones, bloqueo_historico*100, 'b-', 'LineWidth', 2);
ylabel('Bloqueo Malicioso (%)');
title('Evolución del Rendimiento');
grid on;

subplot(2,1,2);
plot(1:num_generaciones, falsos_historico*100, 'r-', 'LineWidth', 2);
xlabel('Generación');
ylabel('Falsos Positivos (%)');
grid on;


% Funciones

function aptitudes = evaluarAptitudFirewall(poblacion, trafico_tipos)
    [n, ~] = size(poblacion);
    aptitudes = zeros(n, 1);
    for i = 1:n
        individuo = poblacion(i, :);
        [bloqueo_mal, falsos_pos, eficiencia] = analizarRendimiento(individuo, trafico_tipos);
        seguridad = calcularSeguridad(individuo, trafico_tipos);
        
        fitness_bloqueo = bloqueo_mal * 0.4;
        penalizacion_falsos = falsos_pos * 0.25;
        bonus_eficiencia = eficiencia * 0.2;
        bonus_seguridad = seguridad * 0.15;
        
        aptitudes(i) = fitness_bloqueo - penalizacion_falsos + bonus_eficiencia + bonus_seguridad;
        aptitudes(i) = max(0, aptitudes(i));
    end
end

% Función para mostrar progreso de firewall
function mostrarProgresoFirewall(gen, poblacion, aptitudes, trafico_tipos, num_reglas)
    fprintf('--- Generación %d ---\n', gen);
    
    % Obtener soluciones únicas con tolerancia
    [aptitudes_ord, idx_ord] = sort(aptitudes, 'descend');
    soluciones_unicas = [];
    fitness_unicos = [];
    tolerancia = 1e-4;
    
    for i = 1:length(aptitudes_ord)
        individuo = poblacion(idx_ord(i), :);
        
        % Verificar si es único
        if isempty(soluciones_unicas) || all(max(abs(soluciones_unicas - individuo), [], 2) >= tolerancia)
            soluciones_unicas = [soluciones_unicas; individuo];
            fitness_unicos = [fitness_unicos; aptitudes_ord(i)];
        end
    end
    
    fprintf('Todas las %d soluciones únicas actuales:\n', size(soluciones_unicas, 1));
    
    for i = 1:size(soluciones_unicas, 1)
        individuo = soluciones_unicas(i, :);
        [bloqueo_mal, falsos_pos, eficiencia] = analizarRendimiento(individuo, trafico_tipos);
        seguridad = calcularSeguridad(individuo, trafico_tipos);
        
        fprintf('Solución %d: Fitness: %.4f\n', i, fitness_unicos(i));
        fprintf(' Bloqueo malicioso: %.1f%% | Falsos positivos: %.1f%% | Eficiencia: %.3f | Seguridad: %.3f\n', ...
                bloqueo_mal*100, falsos_pos*100, eficiencia, seguridad);
        
        % Mostrar reglas
        fprintf(' Reglas: ');
        for j = 1:num_reglas
            idx = (j-1)*5 + 1;
            accion = individuo(idx);
            puerto_min = individuo(idx+1);
            puerto_max = individuo(idx+2);
            ip_min = individuo(idx+3);
            ip_max = individuo(idx+4);
            
            accion_str = {'DENY', 'ALLOW'};
            fprintf('R%d(%s:%.0f-%.0f:%.0f-%.0f) ', j, accion_str{accion+1}, ...
                    puerto_min, puerto_max, ip_min, ip_max);
        end
        fprintf('\n');
        
        % Justificación
        fprintf(' Justificación: ');
        if bloqueo_mal >= 0.9 && falsos_pos <= 0.1
            fprintf('Excelente detección con mínimos falsos positivos');
        elseif bloqueo_mal >= 0.8 && falsos_pos <= 0.2
            fprintf('Buena protección con precisión aceptable');
        elseif seguridad >= 0.7 && eficiencia >= 0.6
            fprintf('Balance óptimo entre seguridad y rendimiento');
        else
            fprintf('Configuración viable con protección básica');
        end
        fprintf('\n\n');
    end
end

function [bloqueo_mal, falsos_pos, eficiencia] = analizarRendimiento(individuo, trafico_tipos)
    num_reglas = length(individuo) / 5;
    trafico_bloqueado_mal = 0;
    trafico_bloqueado_leg = 0;
    total_malicioso = sum(trafico_tipos(:,4) == 0);
    total_legitimo = sum(trafico_tipos(:,4) == 1);
    
    for i = 1:size(trafico_tipos, 1)
        tipo = trafico_tipos(i, 1);
        puerto = trafico_tipos(i, 2);
        ip = trafico_tipos(i, 3);
        es_legitimo = trafico_tipos(i, 4);
        
        bloqueado = false;
        for j = 1:num_reglas
            idx = (j-1)*5 + 1;
            accion = individuo(idx);
            puerto_min = individuo(idx+1);
            puerto_max = individuo(idx+2);
            ip_min = individuo(idx+3);
            ip_max = individuo(idx+4);
            
            if puerto >= puerto_min && puerto <= puerto_max && ...
               ip >= ip_min && ip <= ip_max
                if accion == 0  % DENY
                    bloqueado = true;
                    break;
                end
            end
        end
        
        if bloqueado
            if es_legitimo == 0  % tráfico malicioso bloqueado (bueno)
                trafico_bloqueado_mal = trafico_bloqueado_mal + 1;
            else  % tráfico legítimo bloqueado (falso positivo)
                trafico_bloqueado_leg = trafico_bloqueado_leg + 1;
            end
        end
    end
    
    bloqueo_mal = trafico_bloqueado_mal / max(1, total_malicioso);
    falsos_pos = trafico_bloqueado_leg / max(1, total_legitimo);
    eficiencia = (bloqueo_mal + (1 - falsos_pos)) / 2;
end

function seguridad = calcularSeguridad(individuo, trafico_tipos)
    num_reglas = length(individuo) / 5;
    reglas_deny = 0;
    cobertura_puertos = 0;
    
    for j = 1:num_reglas
        idx = (j-1)*5 + 1;
        accion = individuo(idx);
        puerto_min = individuo(idx+1);
        puerto_max = individuo(idx+2);
        
        if accion == 0  % DENY
            reglas_deny = reglas_deny + 1;
            cobertura_puertos = cobertura_puertos + (puerto_max - puerto_min + 1);
        end
    end
    
    ratio_deny = reglas_deny / num_reglas;
    cobertura_norm = min(1, cobertura_puertos / 1024);
    seguridad = (ratio_deny * 0.6) + (cobertura_norm * 0.4);
end

function [bloqueo_hist, falsos_hist] = analizarEvolucion(mejores_individuos, trafico_tipos)
    num_gen = size(mejores_individuos, 1);
    bloqueo_hist = zeros(num_gen, 1);
    falsos_hist = zeros(num_gen, 1);
    
    for i = 1:num_gen
        [bloqueo, falsos, ~] = analizarRendimiento(mejores_individuos(i, :), trafico_tipos);
        bloqueo_hist(i) = bloqueo;
        falsos_hist(i) = falsos;
    end
end

function mutados = mutacionReglasFirewall(poblacion, prob, max_puerto, max_ip)
    [len, num_genes] = size(poblacion);
    mutados = poblacion;
    
    for i = 1:len
        for j = 1:5:num_genes
            if rand() < prob
                % Mutar acción
                mutados(i, j) = randi([0,1]);
                % Mutar rangos de puertos
                puerto_min = randi([1, max_puerto-50]);
                mutados(i, j+1) = puerto_min;
                mutados(i, j+2) = puerto_min + randi([0,50]);
                % Mutar rangos de IPs
                ip_min = randi([1, max_ip-20]);
                mutados(i, j+3) = ip_min;
                mutados(i, j+4) = ip_min + randi([0,20]);
            end
        end
    end
end

function hijos = cruceReglasFirewall(poblacion, probabilidad)
    [len, num_genes] = size(poblacion);
    hijos = zeros(len, num_genes);
    
    for i = 1:2:len
        p1 = poblacion(i, :);
        p2 = poblacion(mod(i,len)+1, :);
        
        if rand() < probabilidad
            % Cruce por reglas completas
            num_reglas = num_genes / 5;
            punto_cruce = randi([1, num_reglas-1]) * 5;
            hijos(i,:) = [p1(1:punto_cruce), p2(punto_cruce+1:end)];
            hijos(i+1,:) = [p2(1:punto_cruce), p1(punto_cruce+1:end)];
        else
            hijos(i,:) = p1;
            hijos(i+1,:) = p2;
        end
    end
end

function seleccionados = seleccionPorTorneoFirewall(poblacion, fitness, k)
    len = size(poblacion, 1);
    seleccionados = zeros(size(poblacion));
    
    for i = 1:len
        indices = randsample(len, k);
        [~, best_idx] = max(fitness(indices));
        seleccionados(i,:) = poblacion(indices(best_idx), :);
    end
end







%%

%%

%%

%%

%%

%%
% Algoritmo Genético para Optimización de Repetidores Wi-Fi o Wifi
clear; clc; close all; 

% Parámetros del edificio
edificio_ancho = 100;  
edificio_alto = 100;   
num_repetidores = 6;
radio_cobertura = 15; 

% Puntos críticos que necesitan cobertura (oficinas, salas)
puntos_criticos = [
    10, 5; 25, 8; 40, 12; 15, 20; 76, 97; 
    8, 15; 45, 6; 20, 28; 43, 20; 12, 65;
    30, 15; 5, 85; 48, 18; 22, 5; 95, 88
];

% Parámetros del algoritmo genético
tam_poblacion = 80;
num_generaciones = 200;
prob_cruce = 0.75;
prob_mutacion = 0.15;

% Inicialización (cada repetidor tiene coordenadas x,y)
limites = repmat([edificio_ancho, edificio_alto], 1, num_repetidores);
poblacion = rand(tam_poblacion, num_repetidores*2) .* repmat(limites, tam_poblacion, 1);

maximos = zeros(num_generaciones, 1);
mejores_individuos = zeros(num_generaciones, num_repetidores*2);

% Mejores soluciones globales
mejores_globales = [];
fitness_globales = [];

fprintf('Algoritmo Genético para Optimización de Repetidores Wi-Fi\n\n');

% Mostrar población inicial
fprintf('--- Población Inicial (10 individuos) ---\n');
disp(poblacion(1:10, :))
fprintf('\n');

% Algoritmo genético principal
for gen = 1:num_generaciones
    % Evaluar aptitud
    aptitudes = evaluarAptitudWiFi(poblacion, puntos_criticos, radio_cobertura);
    
    % Guardar mejor de esta generación
    [~, idx] = max(aptitudes);
    mejor_individuo_actual = poblacion(idx, :);
    maximos(gen) = aptitudes(idx);
    mejores_individuos(gen, :) = poblacion(idx, :);
    
    % Actualizar mejores globales
    if isempty(mejores_globales) || aptitudes(idx) > min(fitness_globales)
        mejores_globales = [mejores_globales; mejor_individuo_actual];
        fitness_globales = [fitness_globales; aptitudes(idx)];
        
        % Mantener solo las 4 mejores
        if length(fitness_globales) > 4
            [~, idx_sort] = sort(fitness_globales, 'descend');
            mejores_globales = mejores_globales(idx_sort(1:4), :);
            fitness_globales = fitness_globales(idx_sort(1:4));
        end
    end
    
    % Mostrar progreso cada 50 generaciones
    if mod(gen, 50) == 0
       fprintf('--- Generación %d ---\n', gen);
       [aptitudes_ord, idx_ord] = sort(aptitudes, 'descend');
       
       % Encontrar soluciones únicas
       soluciones_unicas = [];
       fitness_unicos = [];
       tolerancia = 1e-3;
       
       for i = 1:length(aptitudes_ord)
           individuo = poblacion(idx_ord(i), :);
           es_unico = true;
           
           for j = 1:size(soluciones_unicas, 1)
               if max(abs(individuo - soluciones_unicas(j, :))) < tolerancia
                   es_unico = false;
                   break;
               end
           end
           
           if es_unico
               soluciones_unicas = [soluciones_unicas; individuo];
               fitness_unicos = [fitness_unicos; aptitudes_ord(i)];
           end
           
           if size(soluciones_unicas, 1) >= 4
               break;
           end
       end
       
       fprintf('Las %d mejores soluciones únicas actuales:\n', size(soluciones_unicas, 1));
       for i = 1:size(soluciones_unicas, 1)
           individuo = soluciones_unicas(i, :);
           cobertura = calcularCobertura(individuo, puntos_criticos, radio_cobertura);
           solapamiento = calcularSolapamiento(individuo, radio_cobertura);
           distribucion = calcularDistribucion(individuo, edificio_ancho, edificio_alto);
           
           fprintf('Solución %d: Fitness: %.4f\n', i, fitness_unicos(i));
           fprintf('   Cobertura: %.1f%% | Solapamiento: %.1f%% | Distribución: %.2f\n', ...
               cobertura*100, solapamiento*100, distribucion);
           
           % Mostrar coordenadas de repetidores
           fprintf('   Coordenadas: ');
           for j = 1:num_repetidores
               x = individuo(2*j-1);
               y = individuo(2*j);
               fprintf('R%d(%.1f,%.1f) ', j, x, y);
           end
           fprintf('\n');
           
           fprintf('   Justificación: ');
           if cobertura >= 0.9 && solapamiento <= 0.3
               fprintf('Excelente cobertura con mínimo solapamiento');
           elseif cobertura >= 0.8 && solapamiento <= 0.4
               fprintf('Buena cobertura con solapamiento aceptable');
           elseif cobertura >= 0.7
               fprintf('Cobertura adecuada, distribución eficiente');
           else
               fprintf('Solución viable con distribución equilibrada');
           end
           fprintf('\n\n');
       end
    end

    % Selección por torneo
    seleccionados = seleccionPorTorneoWiFi(poblacion, aptitudes, 8);

    % Cruce específico para coordenadas
    hijos = cruceCoordenadasWiFi(seleccionados, prob_cruce);

    % Mutación con restricciones del edificio
    mutados = mutacionCoordenadasWiFi(hijos, prob_mutacion, edificio_ancho, edificio_alto);

    % Elitismo: preservar las 2 mejores soluciones
    [~, idx_elite] = sort(aptitudes, 'descend');
    mutados(1, :) = poblacion(idx_elite(1), :);
    if tam_poblacion > 1
        mutados(2, :) = poblacion(idx_elite(2), :);
    end

    % Siguiente generación
    poblacion = mutados;
end

% Mostrar resultados finales
fprintf('Resultados Finales\n\n');
fprintf('--- Cuatro mejores Soluciones Globales ---\n');
[~, idx_sort] = sort(fitness_globales, 'descend');
for i = 1:length(idx_sort)
    sol = mejores_globales(idx_sort(i), :);
    fitness = fitness_globales(idx_sort(i));
    cobertura = calcularCobertura(sol, puntos_criticos, radio_cobertura);
    solapamiento = calcularSolapamiento(sol, radio_cobertura);
    distribucion = calcularDistribucion(sol, edificio_ancho, edificio_alto);
    
    fprintf('\nSolución Global #%d:\n', i);
    fprintf('  Fitness: %.6f\n', fitness);
    fprintf('  Cobertura de puntos críticos: %.1f%%\n', cobertura*100);
    fprintf('  Solapamiento de señales: %.1f%%\n', solapamiento*100);
    fprintf('  Distribución espacial: %.3f\n', distribucion);
    fprintf('  Eficiencia general: %.1f%%\n', fitness*100);
end

% Mejor solución absoluta
mejor_absoluta = mejores_globales(idx_sort(1), :);
fprintf('\n*** Mejor Solución Absoluta ***\n');
fprintf('Fitness: %.6f\n', fitness_globales(idx_sort(1)));
fprintf('Coordenadas de repetidores:\n');
for i = 1:num_repetidores
    x = mejor_absoluta(2*i-1);
    y = mejor_absoluta(2*i);
    fprintf('  Repetidor %d: (%.1f, %.1f)\n', i, x, y);
end

% Gráficas
figure;
plot(1:num_generaciones, maximos, 'LineWidth', 2, 'Color', [0.2 0.4 0.8]);
xlabel('Generación');
ylabel('Fitness del mejor individuo');
title('Evolución del Algoritmo Genético');
grid on;
gen_marks = 50:50:num_generaciones;
hold on;
plot(gen_marks, maximos(gen_marks), 'ro', 'MarkerSize', 6, 'MarkerFaceColor', 'red');

% Visualización de la mejor solución
figure
hold on;
% Dibujar edificio
rectangle('Position', [0, 0, edificio_ancho, edificio_alto], 'EdgeColor', 'k', 'LineWidth', 2);
% Puntos críticos
plot(puntos_criticos(:,1), puntos_criticos(:,2), 'rs', 'MarkerSize', 8, 'MarkerFaceColor', 'red');
% Repetidores y cobertura
for i = 1:num_repetidores
    x = mejor_absoluta(2*i-1);
    y = mejor_absoluta(2*i);
    plot(x, y, 'bo', 'MarkerSize', 10, 'MarkerFaceColor', 'blue');
    viscircles([x, y], radio_cobertura, 'EdgeColor', 'blue', 'LineStyle', '--');
end
xlim([0, edificio_ancho]);
ylim([0, edificio_alto]);
xlabel('Ancho (m)');
ylabel('Alto (m)');
title('Mejor Configuración de Repetidores');
legend('Puntos críticos', 'Repetidores', 'Location', 'best');
grid on;


% Funciones

function aptitudes = evaluarAptitudWiFi(poblacion, puntos_criticos, radio_cobertura)
    [n, ~] = size(poblacion);
    aptitudes = zeros(n, 1);
    for i = 1:n
        individuo = poblacion(i, :);
        cobertura = calcularCobertura(individuo, puntos_criticos, radio_cobertura);
        solapamiento = calcularSolapamiento(individuo, radio_cobertura);
        distribucion = calcularDistribucion(individuo, 50, 30);
        
        % Función de aptitud mejorada
        fitness_cobertura = cobertura * 0.6;  % 60% peso a cobertura
        penalizacion_solapamiento = solapamiento * 0.2;  % penalizar solapamiento
        bonus_distribucion = distribucion * 0.2;  % bonus por buena distribución
        
        aptitudes(i) = fitness_cobertura - penalizacion_solapamiento + bonus_distribucion;
    end
end

function cobertura = calcularCobertura(individuo, puntos_criticos, radio)
    num_repetidores = length(individuo) / 2;
    puntos_cubiertos = 0;
    
    for i = 1:size(puntos_criticos, 1)
        punto = puntos_criticos(i, :);
        cubierto = false;
        
        for j = 1:num_repetidores
            rep_x = individuo(2*j-1);
            rep_y = individuo(2*j);
            distancia = sqrt((punto(1) - rep_x)^2 + (punto(2) - rep_y)^2);
            
            if distancia <= radio
                cubierto = true;
                break;
            end
        end
        
        if cubierto
            puntos_cubiertos = puntos_cubiertos + 1;
        end
    end
    
    cobertura = puntos_cubiertos / size(puntos_criticos, 1);
end

function solapamiento = calcularSolapamiento(individuo, radio)
    num_repetidores = length(individuo) / 2;
    total_solapamiento = 0;
    comparaciones = 0;
    
    for i = 1:num_repetidores-1
        for j = i+1:num_repetidores
            x1 = individuo(2*i-1); y1 = individuo(2*i);
            x2 = individuo(2*j-1); y2 = individuo(2*j);
            distancia = sqrt((x1-x2)^2 + (y1-y2)^2);
            
            if distancia < 2*radio
                overlap = (2*radio - distancia) / (2*radio);
                total_solapamiento = total_solapamiento + overlap;
            end
            comparaciones = comparaciones + 1;
        end
    end
    
    solapamiento = total_solapamiento / comparaciones;
end

function distribucion = calcularDistribucion(individuo, ancho, alto)
    num_repetidores = length(individuo) / 2;
    distancias = [];
    
    for i = 1:num_repetidores-1
        for j = i+1:num_repetidores
            x1 = individuo(2*i-1); y1 = individuo(2*i);
            x2 = individuo(2*j-1); y2 = individuo(2*j);
            dist = sqrt((x1-x2)^2 + (y1-y2)^2);
            distancias = [distancias, dist];
        end
    end
    
    % Distribución uniforme ideal
    diagonal = sqrt(ancho^2 + alto^2);
    dist_ideal = diagonal / num_repetidores;
    
    % Calcular qué tan cerca está de la distribución ideal
    std_distancias = std(distancias);
    distribucion = 1 / (1 + std_distancias/dist_ideal);
end

function mutados = mutacionCoordenadasWiFi(poblacion, prob, ancho, alto)
    [len, num_genes] = size(poblacion);
    mascara = rand(len, num_genes) < prob;
    
    mutados = poblacion;
    for i = 1:len
        for j = 1:num_genes
            if mascara(i, j)
                if mod(j, 2) == 1  % coordenada x
                    mutados(i, j) = rand() * ancho;
                else  % coordenada y
                    mutados(i, j) = rand() * alto;
                end
            end
        end
    end
end

function hijos = cruceCoordenadasWiFi(poblacion, probabilidad)
    [len, num_genes] = size(poblacion);
    hijos = zeros(len, num_genes);
    
    for i = 1:2:len
        p1 = poblacion(i, :);
        p2 = poblacion(mod(i,len)+1, :);
        
        if rand() < probabilidad
            % Cruce por repetidores completos
            punto_cruce = randi([1, num_genes/2-1]) * 2;
            hijos(i,:) = [p1(1:punto_cruce), p2(punto_cruce+1:end)];
            hijos(i+1,:) = [p2(1:punto_cruce), p1(punto_cruce+1:end)];
        else
            hijos(i,:) = p1;
            hijos(i+1,:) = p2;
        end
    end
end

function seleccionados = seleccionPorTorneoWiFi(poblacion, fitness, k)
    len = size(poblacion, 1);
    seleccionados = zeros(size(poblacion));
    
    for i = 1:len
        indices = randsample(len, k);
        [~, best_idx] = max(fitness(indices));
        seleccionados(i,:) = poblacion(indices(best_idx), :);
    end
end






%% 

%%

%%

%%

%%

% Algoritmo Genético para Selección de Características en Detección de
% Intrusos o IDS
clear; clc; close all;

% Parámetros del problema
num_caracteristicas = 20;  % Número total de características disponibles
max_seleccionadas = 12;    % Máximo de características a seleccionar

% Base de datos simulada de características de red
nombres_caracteristicas = {
    'duracion_conexion', 'bytes_enviados', 'bytes_recibidos', 'num_paquetes',
    'frecuencia_conexion', 'puertos_destino', 'ips_origen', 'tiempo_respuesta',
    'patrones_payload', 'flags_tcp', 'tamano_ventana', 'numero_sesiones',
    'anomalias_protocolo', 'intentos_login', 'comandos_ejecutados', 'accesos_archivo',
    'conexiones_fallidas', 'escaneo_puertos', 'transferencia_datos', 'actividad_nocturna'
};

% Datos simulados de rendimiento por característica (precisión individual)
precision_individual = [0.65, 0.72, 0.68, 0.71, 0.58, 0.75, 0.69, 0.63, 0.77, 0.64, 0.66, 0.70, 0.73, 0.78, 0.74, 0.67, ...
                       0.72, 0.76, 0.69, 0.61];

% Matriz de correlación generada para características
correlacion = rand(num_caracteristicas, num_caracteristicas);
correlacion = (correlacion + correlacion') / 2;
for i = 1:num_caracteristicas
    correlacion(i, i) = 1;
end

% Parámetros del algoritmo genético
tam_poblacion = 60;
num_generaciones = 200;
prob_cruce = 0.8;
prob_mutacion = 0.12;

% Inicialización (cromosoma binario: 1=característica seleccionada, 0=no seleccionada)
poblacion = zeros(tam_poblacion, num_caracteristicas);
for i = 1:tam_poblacion
    num_sel = randi([3, max_seleccionadas]);
    indices = randperm(num_caracteristicas, num_sel);
    poblacion(i, indices) = 1;
end

maximos = zeros(num_generaciones, 1);
mejores_individuos = zeros(num_generaciones, num_caracteristicas);

% Mejores soluciones globales
mejores_globales = [];
fitness_globales = [];

fprintf('Algoritmo Genético para Selección de Características en Detección de Intrusos\n\n');

% Mostrar población inicial
fprintf('Población inicial (Los 10 primeros individuos)\n');
aptitudes_iniciales = evaluarAptitudDeteccion(poblacion, precision_individual, correlacion);

for i = 1:10
    individuo = poblacion(i, :);
    num_caract = sum(individuo);
    precision = calcularPrecision(individuo, precision_individual, correlacion);
    redundancia = calcularRedundancia(individuo, correlacion);
    
    fprintf('Individuo %d: Fitness: %.4f | Características: %d | Precisión: %.1f%% | Redundancia: %.3f\n', ...
            i, aptitudes_iniciales(i), num_caract, precision*100, redundancia);
    disp('El individuo es:')
    disp(individuo)
end
fprintf('\n');

% Algoritmo genético principal
for gen = 1:num_generaciones
    % Evaluar aptitud
    aptitudes = evaluarAptitudDeteccion(poblacion, precision_individual, correlacion);
    
    % Guardar mejor de esta generación
    [~, idx] = max(aptitudes);
    mejor_individuo_actual = poblacion(idx, :);
    maximos(gen) = aptitudes(idx);
    mejores_individuos(gen, :) = poblacion(idx, :);
    
    % Actualizar mejores globales
    if isempty(mejores_globales) || aptitudes(idx) > min(fitness_globales)
        mejores_globales = [mejores_globales; mejor_individuo_actual];
        fitness_globales = [fitness_globales; aptitudes(idx)];
        
        % Mantener solo las 4 mejores
        if length(fitness_globales) > 4
            [~, idx_sort] = sort(fitness_globales, 'descend');
            mejores_globales = mejores_globales(idx_sort(1:4), :);
            fitness_globales = fitness_globales(idx_sort(1:4));
        end
    end
    
    % Mostrar progreso cada 50 generaciones
    if mod(gen, 50) == 0
        mostrarProgresoDeteccion(gen, poblacion, aptitudes, precision_individual, correlacion, max_seleccionadas, nombres_caracteristicas);
    end
    
    % Selección por torneo
    seleccionados = seleccionPorTorneoDeteccion(poblacion, aptitudes, 6);
    
    % Cruce uniforme
    hijos = cruceUniformeDeteccion(seleccionados, prob_cruce);
    
    % Mutación con restricciones
    mutados = mutacionRestringidaDeteccion(hijos, prob_mutacion, max_seleccionadas);
    
    % Elitismo
    [~, idx_elite] = sort(aptitudes, 'descend');
    mutados(1, :) = poblacion(idx_elite(1), :);
    
    % Siguiente generación
    poblacion = mutados;
end

% Mostrar resultados finales
fprintf('Resultados finales\n\n');
fprintf('--- Las 4 mejores soluciones globales ---\n');
[~, idx_sort] = sort(fitness_globales, 'descend');
for i = 1:length(idx_sort)
    sol = mejores_globales(idx_sort(i), :);
    fitness = fitness_globales(idx_sort(i));
    num_caract = sum(sol);
    precision = calcularPrecision(sol, precision_individual, correlacion);
    redundancia = calcularRedundancia(sol, correlacion);
    
    fprintf('\nSolución global #%d:\n', i);
    fprintf('  Fitness: %.6f\n', fitness);
    fprintf('  Número de características: %d/%d\n', num_caract, num_caracteristicas);
    fprintf('  Precisión de detección: %.1f%%\n', precision*100);
    fprintf('  Redundancia: %.3f\n', redundancia);
    fprintf('  Eficiencia: %.1f%%\n', (1-(num_caract/max_seleccionadas))*100);
end

% Mejor solución absoluta
mejor_absoluta = mejores_globales(idx_sort(1), :);
fprintf('\n*** Mejor solución absoluta ***\n');
fprintf('Fitness: %.6f\n', fitness_globales(idx_sort(1)));
fprintf('Características seleccionadas:\n');
seleccionadas = find(mejor_absoluta == 1);
for i = 1:length(seleccionadas)
    idx = seleccionadas(i);
    fprintf('  %d. %s (precisión individual: %.1f%%)\n', ...
        i, nombres_caracteristicas{idx}, precision_individual(idx)*100);
end

% Gráficas
figure;
plot(1:num_generaciones, maximos, 'LineWidth', 2, 'Color', [0.8 0.2 0.4]);
xlabel('Generación');
ylabel('Fitness del mejor individuo');
title('Evolución del algoritmo genético');
grid on;
gen_marks = 50:50:num_generaciones;
hold on;
plot(gen_marks, maximos(gen_marks), 'ro', 'MarkerSize', 6, 'MarkerFaceColor', 'red');

% Análisis de características más seleccionadas
figure;
frecuencia_seleccion = sum(mejores_individuos > 0, 1) / num_generaciones;
bar(frecuencia_seleccion, 'FaceColor', [0.2 0.6 0.8]);
xlabel('Índice de característica');
ylabel('Frecuencia de selección');
title('Frecuencia de selección de características a lo largo de las generaciones');
grid on;
set(gca, 'XTick', 1:num_caracteristicas);
xtickangle(45);

% Funciones

function aptitudes = evaluarAptitudDeteccion(poblacion, precision_indiv, correlacion)
    [n, ~] = size(poblacion);
    aptitudes = zeros(n, 1);
    for i = 1:n
        individuo = poblacion(i, :);
        if sum(individuo) == 0
            aptitudes(i) = 0;
            continue;
        end
        
        precision = calcularPrecision(individuo, precision_indiv, correlacion);
        redundancia = calcularRedundancia(individuo, correlacion);
        complejidad = sum(individuo) / length(individuo);
        
        % Función de aptitud balanceada
        fitness_precision = precision * 0.7;  % 70% peso a precisión
        penalizacion_redundancia = redundancia * 0.2;  % penalizar redundancia
        penalizacion_complejidad = complejidad * 0.1;  % penalizar demasiadas características
        
        aptitudes(i) = fitness_precision - penalizacion_redundancia - penalizacion_complejidad;
        aptitudes(i) = max(aptitudes(i), 0);  % Evitar valores negativos
    end
end

function precision = calcularPrecision(individuo, precision_indiv, correlacion)
    seleccionadas = find(individuo == 1);
    if isempty(seleccionadas)
        precision = 0;
        return;
    end
    
    % Precisión combinada considerando sinergia entre características
    precision_base = mean(precision_indiv(seleccionadas));
    
    % Bonus por combinaciones complementarias
    if length(seleccionadas) > 1
        sinergia = 0;
        for i = 1:length(seleccionadas)-1
            for j = i+1:length(seleccionadas)
                corr = correlacion(seleccionadas(i), seleccionadas(j));
                if corr < 0.3  % Características complementarias
                    sinergia = sinergia + 0.02;
                end
            end
        end
        precision = min(precision_base + sinergia, 1.0);
    else
        precision = precision_base;
    end
end

function redundancia = calcularRedundancia(individuo, correlacion)
    seleccionadas = find(individuo == 1);
    if length(seleccionadas) <= 1
        redundancia = 0;
        return;
    end
    
    correlaciones_altas = 0;
    total_pares = 0;
    
    for i = 1:length(seleccionadas)-1
        for j = i+1:length(seleccionadas)
            corr = correlacion(seleccionadas(i), seleccionadas(j));
            if corr > 0.7  % Umbral de alta correlación
                correlaciones_altas = correlaciones_altas + corr;
            end
            total_pares = total_pares + 1;
        end
    end
    
    redundancia = correlaciones_altas / total_pares;
end


% Función para mostrar progreso de detección
function mostrarProgresoDeteccion(gen, poblacion, aptitudes, precision_individual, correlacion, max_seleccionadas, nombres_caracteristicas)
    fprintf('--- Generación %d ---\n', gen);
    
    % Obtener soluciones únicas con tolerancia
    [aptitudes_ord, idx_ord] = sort(aptitudes, 'descend');
    soluciones_unicas = [];
    fitness_unicos = [];
    tolerancia = 1e-4;
    
    for i = 1:length(aptitudes_ord)
        individuo = poblacion(idx_ord(i), :);
        
        % Verificar si es único
        if isempty(soluciones_unicas) || all(sum(abs(soluciones_unicas - individuo), 2) >= tolerancia)
            soluciones_unicas = [soluciones_unicas; individuo];
            fitness_unicos = [fitness_unicos; aptitudes_ord(i)];
        end
    end
    
    fprintf('Todas las %d soluciones únicas actuales:\n', size(soluciones_unicas, 1));
    
    for i = 1:size(soluciones_unicas, 1)
        individuo = soluciones_unicas(i, :);
        num_caract = sum(individuo);
        precision = calcularPrecision(individuo, precision_individual, correlacion);
        redundancia = calcularRedundancia(individuo, correlacion);
        eficiencia = num_caract / max_seleccionadas;
        
        fprintf('Solución %d: Fitness: %.4f\n', i, fitness_unicos(i));
        fprintf(' Características: %d | Precisión: %.1f%% | Redundancia: %.3f | Eficiencia: %.2f\n', ...
                num_caract, precision*100, redundancia, eficiencia);
        
        % Mostrar características seleccionadas
        seleccionadas = find(individuo == 1);
        fprintf(' Características seleccionadas: ');
        for j = 1:length(seleccionadas)
            fprintf('%s ', nombres_caracteristicas{seleccionadas(j)});
        end
        fprintf('\n');
        
        % Justificación
        fprintf(' Justificación: ');
        if precision >= 0.85 && redundancia <= 0.3 && num_caract <= 8
            fprintf('Excelente precisión con mínima redundancia y alta eficiencia');
        elseif precision >= 0.80 && redundancia <= 0.4
            fprintf('Buena precisión con redundancia controlada');
        elseif precision >= 0.75 && num_caract <= 10
            fprintf('Precisión adecuada con selección eficiente');
        else
            fprintf('Solución balanceada entre precisión y complejidad');
        end
        fprintf('\n\n');
    end
end

function mutados = mutacionRestringidaDeteccion(poblacion, prob, max_sel)
    [len, num_genes] = size(poblacion);
    mutados = poblacion;
    
    for i = 1:len
        if rand() < prob
            % Mutación: flip bit aleatorios respetando restricciones
            num_actual = sum(mutados(i, :));
            
            if num_actual < max_sel && rand() < 0.6
                % Agregar característica
                disponibles = find(mutados(i, :) == 0);
                if ~isempty(disponibles)
                    idx = disponibles(randi(length(disponibles)));
                    mutados(i, idx) = 1;
                end
            elseif num_actual > 2
                % Quitar característica
                seleccionadas = find(mutados(i, :) == 1);
                if ~isempty(seleccionadas)
                    idx = seleccionadas(randi(length(seleccionadas)));
                    mutados(i, idx) = 0;
                end
            end
        end
    end
end

function hijos = cruceUniformeDeteccion(poblacion, probabilidad)
    [len, num_genes] = size(poblacion);
    hijos = zeros(len, num_genes);
    
    for i = 1:2:len
        p1 = poblacion(i, :);
        p2 = poblacion(mod(i,len)+1, :);
        
        if rand() < probabilidad
            % Cruce uniforme
            mascara = rand(1, num_genes) < 0.5;
            hijos(i,:) = p1 .* mascara + p2 .* (~mascara);
            hijos(i+1,:) = p2 .* mascara + p1 .* (~mascara);
        else
            hijos(i,:) = p1;
            hijos(i+1,:) = p2;
        end
    end
end

function seleccionados = seleccionPorTorneoDeteccion(poblacion, fitness, k)
    len = size(poblacion, 1);
    seleccionados = zeros(size(poblacion));
    
    for i = 1:len
        indices = randsample(len, k);
        [~, best_idx] = max(fitness(indices));
        seleccionados(i,:) = poblacion(indices(best_idx), :);
    end
end





%%

%%

%%

%%

%%

%% 
% Algoritmo Genético Mejorado para Asignación de Canales
clear; clc;

% Parámetros del problema (Canales)
n_cells = 10;
n_channels = 15;

% Matriz de adyacencia
adyacencia = rand(n_cells) < 0.7;
adyacencia = triu(adyacencia, 1);
adyacencia = adyacencia + adyacencia';  % simétrica
adyacencia(1:n_cells+1:end) = 0;  % sin autointerferencia

% Parámetros del algoritmo genético
tam_poblacion = 100;
num_generaciones = 200;
prob_cruce = 0.8;
prob_mutacion = 0.1;

% Inicialización
poblacion = randi([1 n_channels], tam_poblacion, n_cells);
maximos = zeros(num_generaciones, 1);
mejores_individuos = zeros(num_generaciones, n_cells);

% Variable para almacenar las mejores soluciones globales
mejores_globales = [];
fitness_globales = [];

fprintf(' Algoritmo Genético Para Asignación de Canales \n\n');

% Mostrar población inicial
fprintf('Población Inicial\n');
aptitudes_iniciales = evaluarAptitudCanales(poblacion, adyacencia);
[aptitudes_ord, idx_ord] = sort(aptitudes_iniciales, 'descend');

% Algoritmo genético principal
for gen = 1:num_generaciones
    % Evaluar aptitud (maximizar: menos interferencia)
    aptitudes = evaluarAptitudCanales(poblacion, adyacencia);
    
    % Guardar mejor de esta generación
    [~, idx] = max(aptitudes);
    mejor_individuo_actual = poblacion(idx, :);
    interferencias_actual = contarInterferencias(mejor_individuo_actual, adyacencia);
    maximos(gen) = interferencias_actual;
    mejores_individuos(gen, :) = poblacion(idx, :);
    
    % Actualizar mejores globales
    if isempty(mejores_globales) || aptitudes(idx) > min(fitness_globales)
        mejores_globales = [mejores_globales; mejor_individuo_actual];
        fitness_globales = [fitness_globales; aptitudes(idx)];
        
        % Mantener solo las 4 mejores
        if length(fitness_globales) > 4
            [~, idx_sort] = sort(fitness_globales, 'descend');
            mejores_globales = mejores_globales(idx_sort(1:4), :);
            fitness_globales = fitness_globales(idx_sort(1:4));
        end
    end
    
    % Imprimir los resultados cada 50 generaciones
    if mod(gen, 50) == 0
        mostrarProgreso(gen, poblacion, aptitudes, adyacencia);
    end


    % Selección por torneo
    seleccionados = seleccionPorTorneo(poblacion, aptitudes, 10);

    % Cruce uniforme
    hijos = cruceUniforme(seleccionados, prob_cruce);

    % Mutación: cambio aleatorio de canal
    mutados = mutacionUniforme(hijos, prob_mutacion, 1, n_channels);

    % Elitismo mejorado: preservar las 2 mejores soluciones
    [~, idx_elite] = sort(aptitudes, 'descend');
    mutados(1, :) = poblacion(idx_elite(1), :);

    % Siguiente generación
    poblacion = mutados;
end

% Mostrar mejores soluciones finales
fprintf(' Resultados Finales \n\n');
fprintf('Cuatro mejores Soluciones Glbales\n');
[~, idx_sort] = sort(fitness_globales, 'descend');
for i = 1:length(idx_sort)
    sol = mejores_globales(idx_sort(i), :);
    fitness = fitness_globales(idx_sort(i));
    interferencias = contarInterferencias(sol, adyacencia);
    diversidad = calcularDiversidad(sol);
    
    fprintf('\nSolución Global #%d:\n', i);
    fprintf('  Asignación: %s\n', mat2str(sol));
    fprintf('  Fitness: %.6f\n', fitness);
    fprintf('  Interferencias: %d\n', interferencias);
    fprintf('  Diversidad de canales: %.1f%\n', diversidad*100);
    fprintf('  Eficiencia: %.1f%\n\n', fitness*100);
end

% Mejor solución absoluta
mejor_absoluta = mejores_globales(idx_sort(1), :);
fprintf('\nMejor Solución De Todas\n');
fprintf('Asignación: %s\n', mat2str(mejor_absoluta));
fprintf('Interferencias: %d\n', contarInterferencias(mejor_absoluta, adyacencia));
fprintf('Fitness: %.6f\n', fitness_globales(idx_sort(1)));

% Gráfica
figure;
plot(1:num_generaciones, maximos, 'LineWidth', 2, 'Color', [0.2 0.4 0.8]);
xlabel('Generación');
ylabel('Interferencias del mejor individuo');
title('Evolución del Algoritmo Genético - Asignación de Canales');
grid on;
hold on;

% Marcar puntos cada 50 generaciones
gen_marks = 50:50:num_generaciones;
plot(gen_marks, maximos(gen_marks), 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'red');
legend('Evolución', 'Puntos de control (cada 50 gen)', 'Location', 'best');

% Funciones
function aptitudes = evaluarAptitudCanales(poblacion, adyacencia)
    [n, n_cells] = size(poblacion);
    aptitudes = zeros(n, 1);
    for i = 1:n
        individuo = poblacion(i, :);
        interferencias = contarInterferencias(individuo, adyacencia);
        diversidad = calcularDiversidad(individuo);
        
        base_fitness = 1 / (1 + interferencias);
        bonus_diversidad = diversidad * 0.1; % Bonus por diversidad
        aptitudes(i) = base_fitness + bonus_diversidad;
    end
end

function total = contarInterferencias(individuo, adyacencia)
    n = length(individuo);
    total = 0;
    for i = 1:n-1
        for j = i+1:n
            if adyacencia(i,j)
                diff = abs(individuo(i) - individuo(j));
                if diff == 0 || diff == 1
                    total = total + 1;
                end
            end
        end
    end
end

function diversidad = calcularDiversidad(individuo)
    % Calcula la diversidad de canales utilizados
    canales_unicos = length(unique(individuo));
    total_canales = length(individuo);
    diversidad = canales_unicos / total_canales;
end

% Función para mostrar progreso
function mostrarProgreso(gen, poblacion, aptitudes, adyacencia)
    % Obtener soluciones únicas
    [poblacion_unica, idx_unicos] = unique(poblacion, 'rows', 'stable');
    aptitudes_unicas = aptitudes(idx_unicos);
    
    % Ordenar por aptitud descendente
    [aptitudes_ord, idx_ord] = sort(aptitudes_unicas, 'descend');
    poblacion_ordenada = poblacion_unica(idx_ord, :);
    
    fprintf('--- Generación %d ---\n', gen);
    fprintf('Todas las soluciones únicas actuales:\n');
    
    for i = 1:length(aptitudes_ord)
        interferencias = contarInterferencias(poblacion_ordenada(i, :), adyacencia);
        diversidad = calcularDiversidad(poblacion_ordenada(i, :));
        
        fprintf('Sol %d: %s\n', i, mat2str(poblacion_ordenada(i, :)));
        fprintf(' Fitness: %.4f | Interferencias: %d | Diversidad: %.2f\n', ...
                aptitudes_ord(i), interferencias, diversidad);
        fprintf(' Justificación de porqué es válida: ');
        
        if interferencias == 0
            fprintf('Esta es la mejor solución sin interferencias');
        elseif interferencias <= 2
            fprintf('Excelente solución con mínimas interferencias');
        elseif interferencias <= 5
            fprintf('Buena solución con pocas interferencias');
        else
            fprintf('Solución aceptable, diversidad de canales: %.1f%%', diversidad*100);
        end
        fprintf('\n\n');
    end
end

function mutados = mutacionUniforme(poblacion, prob, min_val, max_val)
    [len, num_genes] = size(poblacion);
    mascara = rand(len, num_genes) < prob;
    nuevos = randi([min_val max_val], len, num_genes);
    mutados = poblacion;
    mutados(mascara) = nuevos(mascara);
end

function hijos = cruceUniforme(poblacion, probabilidad)
    [len, num_genes] = size(poblacion);
    hijos = zeros(len, num_genes);
    for i = 1:2:len
        p1 = poblacion(i, :);
        p2 = poblacion(mod(i,len)+1, :);
        mask = rand(1, num_genes) < probabilidad;
        hijos(i,:) = p1;
        hijos(i+1,:) = p2;
        hijos(i,mask) = p2(mask);
        hijos(i+1,mask) = p1(mask);
    end
end

function seleccionados = seleccionPorTorneo(poblacion, fitness, k)
    len = size(poblacion, 1);
    seleccionados = zeros(size(poblacion));
    
    for i = 1:len
        indices = randsample(len, k);
        [~, best_idx] = max(fitness(indices));
        seleccionados(i,:) = poblacion(indices(best_idx), :);
    end
end









%%


%%


%%


%%

%%
% Algoritmo Genético para Programación de Escaneos de Puertos
clear; clc; close all;

% Parámetros del problema
num_puertos = 20;           % puertos a escanear
tiempo_total = 300;         % ventana de tiempo (segundos)
num_hosts = 5;              % número de hosts objetivo
max_intentos_simultaneos = 3; % máximo escaneos simultáneos

% Puertos críticos con diferentes prioridades
puertos_criticos = [21, 22, 23, 25, 53, 80, 110, 135, 139, 143, ...
                   443, 993, 995, 1433, 1521, 3306, 3389, 5432, 8080, 8443];
prioridades = [0.8, 0.9, 0.6, 0.7, 0.8, 1.0, 0.6, 0.7, 0.8, 0.6, ...
              1.0, 0.7, 0.7, 0.9, 0.8, 0.9, 0.8, 0.8, 0.8, 0.9];

% Parámetros del algoritmo genético
tam_poblacion = 60;
num_generaciones = 150;
prob_cruce = 0.7;
prob_mutacion = 0.12;

% Inicialización: cada gen representa [host, puerto, tiempo_inicio, intervalo]
poblacion = inicializarPoblacion(tam_poblacion, num_puertos, num_hosts, tiempo_total);

maximos = zeros(num_generaciones, 1);
mejores_individuos = zeros(num_generaciones, num_puertos*4);

mejores_globales = [];
fitness_globales = [];

fprintf('Algoritmo Genético para Programación de Escaneos de Puertos\n\n');

% Mostrar población inicial
fprintf('--- Población Inicial (10 individuos) ---\n');
aptitudes_iniciales = evaluarAptitudEscaneo(poblacion, puertos_criticos, prioridades, tiempo_total, max_intentos_simultaneos);
[aptitudes_ord, idx_ord] = sort(aptitudes_iniciales, 'descend');
fprintf('Los 10 mejores individuos iniciales:\n');
for i = 1:10
    cobertura = calcularCoberturaPuertos(poblacion(idx_ord(i), :), puertos_criticos, prioridades);
    deteccion = calcularRiesgoDeteccion(poblacion(idx_ord(i), :), tiempo_total, max_intentos_simultaneos);
    distribucion = calcularDistribucionTemporal(poblacion(idx_ord(i), :), tiempo_total);
    fprintf('Individuo %d: Fitness: %.4f | Cobertura: %.1f%% | Riesgo: %.1f%% | Distribución: %.2f\n', ...
        i, aptitudes_ord(i), cobertura*100, deteccion*100, distribucion);
    
    % Mostrar cromosoma
    cromosoma = poblacion(idx_ord(i), :);
    fprintf('  Cromosoma: [');
    for j = 1:min(12, length(cromosoma))
        fprintf('%.0f ', cromosoma(j));
    end
    if length(cromosoma) > 12
        fprintf('...]');
    else
        fprintf(']');
    end
    fprintf('\n\n');
end

% Algoritmo genético principal
for gen = 1:num_generaciones
    aptitudes = evaluarAptitudEscaneo(poblacion, puertos_criticos, prioridades, tiempo_total, max_intentos_simultaneos);
    
    [~, idx] = max(aptitudes);
    mejor_individuo_actual = poblacion(idx, :);
    maximos(gen) = aptitudes(idx);
    mejores_individuos(gen, :) = poblacion(idx, :);
    
    % Actualizar mejores globales
    if isempty(mejores_globales) || aptitudes(idx) > min(fitness_globales)
        mejores_globales = [mejores_globales; mejor_individuo_actual];
        fitness_globales = [fitness_globales; aptitudes(idx)];
        
        if length(fitness_globales) > 4
            [~, idx_sort] = sort(fitness_globales, 'descend');
            mejores_globales = mejores_globales(idx_sort(1:4), :);
            fitness_globales = fitness_globales(idx_sort(1:4));
        end
    end
    
    % Llamada modificada (reemplaza tu código original)
    if mod(gen, 50) == 0
        mostrarProgresoEscaneos(gen, poblacion, aptitudes, puertos_criticos, prioridades, tiempo_total, max_intentos_simultaneos);
    end

    % Selección por torneo
    seleccionados = seleccionPorTorneoEscaneo(poblacion, aptitudes, 6);

    % Cruce específico para escaneos
    hijos = cruceEscaneos(seleccionados, prob_cruce);

    % Mutación con restricciones temporales
    mutados = mutacionEscaneos(hijos, prob_mutacion, tiempo_total, num_hosts);

    % Elitismo
    [~, idx_elite] = sort(aptitudes, 'descend');
    mutados(1, :) = poblacion(idx_elite(1), :);
    if tam_poblacion > 1
        mutados(2, :) = poblacion(idx_elite(2), :);
    end

    poblacion = mutados;
end

% Resultados finales
fprintf('Resultados Finales\n\n');
fprintf('--- Cuatro mejores Soluciones Globales ---\n');
[~, idx_sort] = sort(fitness_globales, 'descend');
for i = 1:length(idx_sort)
    sol = mejores_globales(idx_sort(i), :);
    fitness = fitness_globales(idx_sort(i));
    cobertura = calcularCoberturaPuertos(sol, puertos_criticos, prioridades);
    deteccion = calcularRiesgoDeteccion(sol, tiempo_total, max_intentos_simultaneos);
    distribucion = calcularDistribucionTemporal(sol, tiempo_total);
    
    fprintf('\nSolución Global #%d:\n', i);
    fprintf('  Fitness: %.6f\n', fitness);
    fprintf('  Cobertura de puertos críticos: %.1f%%\n', cobertura*100);
    fprintf('  Riesgo de detección: %.1f%%\n', deteccion*100);
    fprintf('  Distribución temporal: %.3f\n', distribucion);
    fprintf('  Eficiencia general: %.1f%%\n', fitness*100);
end

% Mejor solución absoluta
mejor_absoluta = mejores_globales(idx_sort(1), :);
fprintf('\n*** Mejor Solución Absoluta ***\n');
fprintf('Fitness: %.6f\n', fitness_globales(idx_sort(1)));
escaneos_finales = decodificarEscaneos(mejor_absoluta, puertos_criticos);
fprintf('Programación de escaneos:\n');
for i = 1:size(escaneos_finales, 1)
    fprintf('  Host %d, Puerto %d: Tiempo %.1fs, Intervalo %.1fs\n', ...
        escaneos_finales(i,1), escaneos_finales(i,2), escaneos_finales(i,3), escaneos_finales(i,4));
end

% Gráficas
figure;
plot(1:num_generaciones, maximos, 'LineWidth', 2, 'Color', [0.2 0.4 0.8]);
xlabel('Generación');
ylabel('Fitness del mejor individuo');
title('Evolución del Algoritmo Genético');
grid on;
gen_marks = 50:50:num_generaciones;
hold on;
plot(gen_marks, maximos(gen_marks), 'ro', 'MarkerSize', 6, 'MarkerFaceColor', 'red');

% Visualización temporal de la mejor solución
figure;
hold on;
escaneos = decodificarEscaneos(mejor_absoluta, puertos_criticos);
colors = lines(num_hosts);
for i = 1:size(escaneos, 1)
    host = escaneos(i, 1);
    tiempo = escaneos(i, 3);
    puerto = escaneos(i, 2);
    bar(tiempo, puerto, 2, 'FaceColor', colors(host, :), 'EdgeColor', 'none');
end
xlabel('Tiempo (s)');
ylabel('Puerto');
title('Distribución Temporal de Escaneos');
legend(arrayfun(@(x) sprintf('Host %d', x), 1:num_hosts, 'UniformOutput', false));
grid on;

% Funciones

function poblacion = inicializarPoblacion(tam_poblacion, num_puertos, num_hosts, tiempo_total)
    poblacion = zeros(tam_poblacion, num_puertos*4);
    for i = 1:tam_poblacion
        for j = 1:num_puertos
            idx = (j-1)*4 + 1;
            poblacion(i, idx) = randi(num_hosts);              % host
            poblacion(i, idx+1) = j;                           % puerto (índice)
            poblacion(i, idx+2) = rand()*tiempo_total;         % tiempo inicio
            poblacion(i, idx+3) = 5 + rand()*25;              % intervalo
        end
    end
end

function aptitudes = evaluarAptitudEscaneo(poblacion, puertos_criticos, prioridades, tiempo_total, max_simultaneos)
    [n, ~] = size(poblacion);
    aptitudes = zeros(n, 1);
    for i = 1:n
        individuo = poblacion(i, :);
        cobertura = calcularCoberturaPuertos(individuo, puertos_criticos, prioridades);
        deteccion = calcularRiesgoDeteccion(individuo, tiempo_total, max_simultaneos);
        distribucion = calcularDistribucionTemporal(individuo, tiempo_total);
        
        fitness_cobertura = cobertura * 0.5;
        penalizacion_deteccion = deteccion * 0.3;
        bonus_distribucion = distribucion * 0.2;
        
        aptitudes(i) = fitness_cobertura - penalizacion_deteccion + bonus_distribucion;
    end
end

function cobertura = calcularCoberturaPuertos(individuo, puertos_criticos, prioridades)
    num_puertos = length(individuo) / 4;
    cobertura_total = 0;
    
    for i = 1:num_puertos
        idx = (i-1)*4 + 1;
        puerto_idx = individuo(idx+1);
        if puerto_idx <= length(prioridades)
            cobertura_total = cobertura_total + prioridades(puerto_idx);
        end
    end
    
    cobertura = cobertura_total / sum(prioridades);
end

function riesgo = calcularRiesgoDeteccion(individuo, tiempo_total, max_simultaneos)
    num_puertos = length(individuo) / 4;
    eventos_simultaneos = 0;
    total_ventanas = 0;
    
    ventana_tiempo = 10; % segundos
    for t = 0:ventana_tiempo:tiempo_total-ventana_tiempo
        activos = 0;
        for i = 1:num_puertos
            idx = (i-1)*4 + 1;
            tiempo_inicio = individuo(idx+2);
            intervalo = individuo(idx+3);
            
            if tiempo_inicio >= t && tiempo_inicio < t+ventana_tiempo
                activos = activos + 1;
            end
        end
        
        if activos > max_simultaneos
            eventos_simultaneos = eventos_simultaneos + (activos - max_simultaneos);
        end
        total_ventanas = total_ventanas + 1;
    end
    
    riesgo = eventos_simultaneos / (total_ventanas * max_simultaneos);
    riesgo = min(riesgo, 1);
end

function distribucion = calcularDistribucionTemporal(individuo, tiempo_total)
    num_puertos = length(individuo) / 4;
    tiempos = [];
    
    for i = 1:num_puertos
        idx = (i-1)*4 + 1;
        tiempos = [tiempos, individuo(idx+2)];
    end
    
    tiempos = sort(tiempos);
    if length(tiempos) > 1
        intervalos = diff(tiempos);
        std_intervalos = std(intervalos);
        distribucion = 1 / (1 + std_intervalos/10);
    else
        distribucion = 0.5;
    end
end

function escaneos = decodificarEscaneos(individuo, puertos_criticos)
    num_puertos = length(individuo) / 4;
    escaneos = zeros(num_puertos, 4);
    
    for i = 1:num_puertos
        idx = (i-1)*4 + 1;
        escaneos(i, 1) = individuo(idx);     % host
        escaneos(i, 2) = puertos_criticos(min(individuo(idx+1), length(puertos_criticos))); % puerto real
        escaneos(i, 3) = individuo(idx+2);   % tiempo
        escaneos(i, 4) = individuo(idx+3);   % intervalo
    end
end

% Función para mostrar progreso de escaneos
function mostrarProgresoEscaneos(gen, poblacion, aptitudes, puertos_criticos, prioridades, tiempo_total, max_intentos_simultaneos)
    fprintf('--- Generación %d ---\n', gen);
    
    % Obtener soluciones únicas con tolerancia
    [aptitudes_ord, idx_ord] = sort(aptitudes, 'descend');
    soluciones_unicas = [];
    fitness_unicos = [];
    tolerancia = 1e-2;
    
    for i = 1:length(aptitudes_ord)
        individuo = poblacion(idx_ord(i), :);
        
        % Verificar si es único
        if isempty(soluciones_unicas) || all(max(abs(soluciones_unicas - individuo), [], 2) >= tolerancia)
            soluciones_unicas = [soluciones_unicas; individuo];
            fitness_unicos = [fitness_unicos; aptitudes_ord(i)];
        end
    end
    
    fprintf('Todas las %d soluciones únicas actuales:\n', size(soluciones_unicas, 1));
    
    for i = 1:size(soluciones_unicas, 1)
        individuo = soluciones_unicas(i, :);
        cobertura = calcularCoberturaPuertos(individuo, puertos_criticos, prioridades);
        deteccion = calcularRiesgoDeteccion(individuo, tiempo_total, max_intentos_simultaneos);
        distribucion = calcularDistribucionTemporal(individuo, tiempo_total);
        
        fprintf('Solución %d: Fitness: %.4f\n', i, fitness_unicos(i));
        fprintf(' Cobertura: %.1f%% | Riesgo detección: %.1f%% | Distribución: %.2f\n', ...
                cobertura*100, deteccion*100, distribucion);
        
        % Mostrar programación de escaneos
        fprintf(' Programación: ');
        escaneos = decodificarEscaneos(individuo, puertos_criticos);
        num_mostrar = min(3, size(escaneos, 1));
        for j = 1:num_mostrar
            fprintf('H%d:P%d@%ds ', escaneos(j,1), escaneos(j,2), round(escaneos(j,3)));
        end
        if size(escaneos, 1) > 3
            fprintf('...');
        end
        fprintf('\n');
        
        % Justificación
        fprintf(' Justificación: ');
        if cobertura >= 0.85 && deteccion <= 0.3
            fprintf('Excelente cobertura con mínimo riesgo de detección');
        elseif cobertura >= 0.7 && deteccion <= 0.4
            fprintf('Buena cobertura con riesgo aceptable');
        elseif distribucion >= 0.7
            fprintf('Distribución temporal eficiente para evasión');
        else
            fprintf('Solución equilibrada entre cobertura y sigilo');
        end
        fprintf('\n\n');
    end
end

function mutados = mutacionEscaneos(poblacion, prob, tiempo_total, num_hosts)
    [len, num_genes] = size(poblacion);
    mascara = rand(len, num_genes) < prob;
    
    mutados = poblacion;
    for i = 1:len
        for j = 1:num_genes
            if mascara(i, j)
                tipo_gen = mod(j-1, 4) + 1;
                switch tipo_gen
                    case 1 % host
                        mutados(i, j) = randi(num_hosts);
                    case 2 % puerto (índice)
                        mutados(i, j) = randi(20);
                    case 3 % tiempo
                        mutados(i, j) = rand() * tiempo_total;
                    case 4 % intervalo
                        mutados(i, j) = 5 + rand() * 25;
                end
            end
        end
    end
end

function hijos = cruceEscaneos(poblacion, probabilidad)
    [len, num_genes] = size(poblacion);
    hijos = zeros(len, num_genes);
    
    for i = 1:2:len
        p1 = poblacion(i, :);
        p2 = poblacion(mod(i,len)+1, :);
        
        if rand() < probabilidad
            punto_cruce = randi([4, num_genes-4]);
            punto_cruce = floor(punto_cruce/4)*4; % alinear con grupos de 4
            hijos(i,:) = [p1(1:punto_cruce), p2(punto_cruce+1:end)];
            hijos(i+1,:) = [p2(1:punto_cruce), p1(punto_cruce+1:end)];
        else
            hijos(i,:) = p1;
            hijos(i+1,:) = p2;
        end
    end
end

function seleccionados = seleccionPorTorneoEscaneo(poblacion, fitness, k)
    len = size(poblacion, 1);
    seleccionados = zeros(size(poblacion));
    
    for i = 1:len
        indices = randsample(len, k);
        [~, best_idx] = max(fitness(indices));
        seleccionados(i,:) = poblacion(indices(best_idx), :);
    end
end
%%

% Algoritmo Genético para Optimización de Reglas de Firewall
clear; clc; close all;

% Parámetros del sistema de firewall
num_reglas = 8;
num_puertos = 1024;
num_ips = 256;

% Tipos de tráfico simulado (legítimo = 1, malicioso = 0)
trafico_tipos = [
    1, 80, 192, 1;    % HTTP legítimo
    1, 443, 10, 1;    % HTTPS legítimo  
    1, 22, 50, 1;     % SSH legítimo
    0, 23, 100, 0;    % Telnet malicioso
    0, 135, 150, 0;   % RPC malicioso
    1, 25, 75, 1;     % SMTP legítimo
    0, 1433, 200, 0;  % SQL injection
    1, 53, 30, 1;     % DNS legítimo
    0, 21, 180, 0;    % FTP exploit
    1, 110, 60, 1;    % POP3 legítimo
    0, 445, 220, 0;   % SMB malicioso
    1, 993, 40, 1;    % IMAPS legítimo
    0, 3389, 250, 0;  % RDP attack
    1, 587, 45, 1;    % SMTP secure
    0, 1337, 300, 0   % Backdoor
];

% Parámetros del algoritmo genético
tam_poblacion = 60;
num_generaciones = 150;
prob_cruce = 0.8;
prob_mutacion = 0.12;

% Inicialización: cada regla tiene [accion(0=deny,1=allow), puerto_min, puerto_max, ip_min, ip_max]
poblacion = zeros(tam_poblacion, num_reglas*5);
for i = 1:tam_poblacion
    for j = 1:num_reglas
        idx = (j-1)*5 + 1;
        poblacion(i, idx) = randi([0,1]);           % acción
        puerto_min = randi([1, num_puertos-50]);
        poblacion(i, idx+1) = puerto_min;           % puerto min
        poblacion(i, idx+2) = puerto_min + randi([0,50]); % puerto max
        ip_min = randi([1, num_ips-20]);
        poblacion(i, idx+3) = ip_min;               % ip min
        poblacion(i, idx+4) = ip_min + randi([0,20]); % ip max
    end
end

maximos = zeros(num_generaciones, 1);
mejores_individuos = zeros(num_generaciones, num_reglas*5);

% Mejores soluciones globales
mejores_globales = [];
fitness_globales = [];

fprintf('Algoritmo Genético para Optimización de Reglas de Firewall\n\n');

% Mostrar población inicial
fprintf('--- Población Inicial (10 individuos) ---\n');
aptitudes_iniciales = evaluarAptitudFirewall(poblacion, trafico_tipos);
[aptitudes_ord, idx_ord] = sort(aptitudes_iniciales, 'descend');
fprintf('Los 10 mejores individuos iniciales:\n');
for i = 1:10
    individuo = poblacion(idx_ord(i), :);
    [bloqueo_mal, falsos_pos, eficiencia] = analizarRendimiento(individuo, trafico_tipos);
    fprintf('Individuo %d: Fitness: %.4f | Bloqueo malicioso: %.1f%% | Falsos positivos: %.1f%% | Eficiencia: %.3f\n', ...
        i, aptitudes_ord(i), bloqueo_mal*100, falsos_pos*100, eficiencia);
    
    fprintf('   Reglas: ');
    for j = 1:num_reglas
        idx = (j-1)*5 + 1;
        accion = individuo(idx);
        puerto_min = individuo(idx+1);
        puerto_max = individuo(idx+2);
        ip_min = individuo(idx+3);
        ip_max = individuo(idx+4);
        
        accion_str = 'ALLOW';
        if accion == 0
            accion_str = 'DENY';
        end
        fprintf('R%d(%s:%.0f-%.0f:%.0f-%.0f) ', j, accion_str, puerto_min, puerto_max, ip_min, ip_max);
    end
    fprintf('\n\n');
end
fprintf('\n');

% Algoritmo genético principal
for gen = 1:num_generaciones
    % Evaluar aptitud
    aptitudes = evaluarAptitudFirewall(poblacion, trafico_tipos);
    
    % Guardar mejor de esta generación
    [~, idx] = max(aptitudes);
    mejor_individuo_actual = poblacion(idx, :);
    maximos(gen) = aptitudes(idx);
    mejores_individuos(gen, :) = poblacion(idx, :);
    
    % Actualizar mejores globales
    if isempty(mejores_globales) || aptitudes(idx) > min(fitness_globales)
        mejores_globales = [mejores_globales; mejor_individuo_actual];
        fitness_globales = [fitness_globales; aptitudes(idx)];
        
        % Mantener solo las 4 mejores
        if length(fitness_globales) > 4
            [~, idx_sort] = sort(fitness_globales, 'descend');
            mejores_globales = mejores_globales(idx_sort(1:4), :);
            fitness_globales = fitness_globales(idx_sort(1:4));
        end
    end
    
    % Llamada modificada (reemplaza tu código original)
    if mod(gen, 50) == 0
        mostrarProgresoFirewall(gen, poblacion, aptitudes, trafico_tipos, num_reglas);
    end

    % Selección por torneo
    seleccionados = seleccionPorTorneoFirewall(poblacion, aptitudes, 6);

    % Cruce específico para reglas de firewall
    hijos = cruceReglasFirewall(seleccionados, prob_cruce);

    % Mutación con restricciones válidas
    mutados = mutacionReglasFirewall(hijos, prob_mutacion, num_puertos, num_ips);

    % Elitismo: preservar las 2 mejores soluciones
    [~, idx_elite] = sort(aptitudes, 'descend');
    mutados(1, :) = poblacion(idx_elite(1), :);
    if tam_poblacion > 1
        mutados(2, :) = poblacion(idx_elite(2), :);
    end

    % Siguiente generación
    poblacion = mutados;
end

% Mostrar resultados finales
fprintf('Resultados Finales\n\n');
fprintf('--- Cuatro mejores Soluciones Globales ---\n');
[~, idx_sort] = sort(fitness_globales, 'descend');
for i = 1:length(idx_sort)
    sol = mejores_globales(idx_sort(i), :);
    fitness = fitness_globales(idx_sort(i));
    [bloqueo_mal, falsos_pos, eficiencia] = analizarRendimiento(sol, trafico_tipos);
    seguridad = calcularSeguridad(sol, trafico_tipos);
    
    fprintf('\nSolución Global #%d:\n', i);
    fprintf('  Fitness: %.6f\n', fitness);
    fprintf('  Bloqueo de tráfico malicioso: %.1f%%\n', bloqueo_mal*100);
    fprintf('  Falsos positivos: %.1f%%\n', falsos_pos*100);
    fprintf('  Eficiencia del sistema: %.3f\n', eficiencia);
    fprintf('  Nivel de seguridad: %.3f\n', seguridad);
end

% Mejor solución absoluta
mejor_absoluta = mejores_globales(idx_sort(1), :);
fprintf('\n*** Mejor Solución Absoluta ***\n');
fprintf('Fitness: %.6f\n', fitness_globales(idx_sort(1)));
fprintf('Configuración de reglas de firewall:\n');
for i = 1:num_reglas
    idx = (i-1)*5 + 1;
    accion = mejor_absoluta(idx);
    puerto_min = mejor_absoluta(idx+1);
    puerto_max = mejor_absoluta(idx+2);
    ip_min = mejor_absoluta(idx+3);
    ip_max = mejor_absoluta(idx+4);
    
    accion_str = 'ALLOW';
    if accion == 0
        accion_str = 'DENY';
    end
    
    fprintf('  Regla %d: %s | Puertos: %.0f-%.0f | IPs: %.0f-%.0f\n', ...
        i, accion_str, puerto_min, puerto_max, ip_min, ip_max);
end

% Gráficas
figure;
plot(1:num_generaciones, maximos, 'LineWidth', 2, 'Color', [0.8 0.2 0.2]);
xlabel('Generación');
ylabel('Fitness del mejor individuo');
title('Evolución del Algoritmo Genético - Optimización Firewall');
grid on;
gen_marks = 50:50:num_generaciones;
hold on;
plot(gen_marks, maximos(gen_marks), 'ro', 'MarkerSize', 6, 'MarkerFaceColor', 'red');

% Análisis de rendimiento de la mejor solución
figure;
[bloqueo_historico, falsos_historico] = analizarEvolucion(mejores_individuos, trafico_tipos);
subplot(2,1,1);
plot(1:num_generaciones, bloqueo_historico*100, 'b-', 'LineWidth', 2);
ylabel('Bloqueo Malicioso (%)');
title('Evolución del Rendimiento');
grid on;

subplot(2,1,2);
plot(1:num_generaciones, falsos_historico*100, 'r-', 'LineWidth', 2);
xlabel('Generación');
ylabel('Falsos Positivos (%)');
grid on;


% Funciones

function aptitudes = evaluarAptitudFirewall(poblacion, trafico_tipos)
    [n, ~] = size(poblacion);
    aptitudes = zeros(n, 1);
    for i = 1:n
        individuo = poblacion(i, :);
        [bloqueo_mal, falsos_pos, eficiencia] = analizarRendimiento(individuo, trafico_tipos);
        seguridad = calcularSeguridad(individuo, trafico_tipos);
        
        fitness_bloqueo = bloqueo_mal * 0.4;
        penalizacion_falsos = falsos_pos * 0.25;
        bonus_eficiencia = eficiencia * 0.2;
        bonus_seguridad = seguridad * 0.15;
        
        aptitudes(i) = fitness_bloqueo - penalizacion_falsos + bonus_eficiencia + bonus_seguridad;
        aptitudes(i) = max(0, aptitudes(i));
    end
end

% Función para mostrar progreso de firewall
function mostrarProgresoFirewall(gen, poblacion, aptitudes, trafico_tipos, num_reglas)
    fprintf('--- Generación %d ---\n', gen);
    
    % Obtener soluciones únicas con tolerancia
    [aptitudes_ord, idx_ord] = sort(aptitudes, 'descend');
    soluciones_unicas = [];
    fitness_unicos = [];
    tolerancia = 1e-4;
    
    for i = 1:length(aptitudes_ord)
        individuo = poblacion(idx_ord(i), :);
        
        % Verificar si es único
        if isempty(soluciones_unicas) || all(max(abs(soluciones_unicas - individuo), [], 2) >= tolerancia)
            soluciones_unicas = [soluciones_unicas; individuo];
            fitness_unicos = [fitness_unicos; aptitudes_ord(i)];
        end
    end
    
    fprintf('Todas las %d soluciones únicas actuales:\n', size(soluciones_unicas, 1));
    
    for i = 1:size(soluciones_unicas, 1)
        individuo = soluciones_unicas(i, :);
        [bloqueo_mal, falsos_pos, eficiencia] = analizarRendimiento(individuo, trafico_tipos);
        seguridad = calcularSeguridad(individuo, trafico_tipos);
        
        fprintf('Solución %d: Fitness: %.4f\n', i, fitness_unicos(i));
        fprintf(' Bloqueo malicioso: %.1f%% | Falsos positivos: %.1f%% | Eficiencia: %.3f | Seguridad: %.3f\n', ...
                bloqueo_mal*100, falsos_pos*100, eficiencia, seguridad);
        
        % Mostrar reglas
        fprintf(' Reglas: ');
        for j = 1:num_reglas
            idx = (j-1)*5 + 1;
            accion = individuo(idx);
            puerto_min = individuo(idx+1);
            puerto_max = individuo(idx+2);
            ip_min = individuo(idx+3);
            ip_max = individuo(idx+4);
            
            accion_str = {'DENY', 'ALLOW'};
            fprintf('R%d(%s:%.0f-%.0f:%.0f-%.0f) ', j, accion_str{accion+1}, ...
                    puerto_min, puerto_max, ip_min, ip_max);
        end
        fprintf('\n');
        
        % Justificación
        fprintf(' Justificación: ');
        if bloqueo_mal >= 0.9 && falsos_pos <= 0.1
            fprintf('Excelente detección con mínimos falsos positivos');
        elseif bloqueo_mal >= 0.8 && falsos_pos <= 0.2
            fprintf('Buena protección con precisión aceptable');
        elseif seguridad >= 0.7 && eficiencia >= 0.6
            fprintf('Balance óptimo entre seguridad y rendimiento');
        else
            fprintf('Configuración viable con protección básica');
        end
        fprintf('\n\n');
    end
end

function [bloqueo_mal, falsos_pos, eficiencia] = analizarRendimiento(individuo, trafico_tipos)
    num_reglas = length(individuo) / 5;
    trafico_bloqueado_mal = 0;
    trafico_bloqueado_leg = 0;
    total_malicioso = sum(trafico_tipos(:,4) == 0);
    total_legitimo = sum(trafico_tipos(:,4) == 1);
    
    for i = 1:size(trafico_tipos, 1)
        tipo = trafico_tipos(i, 1);
        puerto = trafico_tipos(i, 2);
        ip = trafico_tipos(i, 3);
        es_legitimo = trafico_tipos(i, 4);
        
        bloqueado = false;
        for j = 1:num_reglas
            idx = (j-1)*5 + 1;
            accion = individuo(idx);
            puerto_min = individuo(idx+1);
            puerto_max = individuo(idx+2);
            ip_min = individuo(idx+3);
            ip_max = individuo(idx+4);
            
            if puerto >= puerto_min && puerto <= puerto_max && ...
               ip >= ip_min && ip <= ip_max
                if accion == 0  % DENY
                    bloqueado = true;
                    break;
                end
            end
        end
        
        if bloqueado
            if es_legitimo == 0  % tráfico malicioso bloqueado (bueno)
                trafico_bloqueado_mal = trafico_bloqueado_mal + 1;
            else  % tráfico legítimo bloqueado (falso positivo)
                trafico_bloqueado_leg = trafico_bloqueado_leg + 1;
            end
        end
    end
    
    bloqueo_mal = trafico_bloqueado_mal / max(1, total_malicioso);
    falsos_pos = trafico_bloqueado_leg / max(1, total_legitimo);
    eficiencia = (bloqueo_mal + (1 - falsos_pos)) / 2;
end

function seguridad = calcularSeguridad(individuo, trafico_tipos)
    num_reglas = length(individuo) / 5;
    reglas_deny = 0;
    cobertura_puertos = 0;
    
    for j = 1:num_reglas
        idx = (j-1)*5 + 1;
        accion = individuo(idx);
        puerto_min = individuo(idx+1);
        puerto_max = individuo(idx+2);
        
        if accion == 0  % DENY
            reglas_deny = reglas_deny + 1;
            cobertura_puertos = cobertura_puertos + (puerto_max - puerto_min + 1);
        end
    end
    
    ratio_deny = reglas_deny / num_reglas;
    cobertura_norm = min(1, cobertura_puertos / 1024);
    seguridad = (ratio_deny * 0.6) + (cobertura_norm * 0.4);
end

function [bloqueo_hist, falsos_hist] = analizarEvolucion(mejores_individuos, trafico_tipos)
    num_gen = size(mejores_individuos, 1);
    bloqueo_hist = zeros(num_gen, 1);
    falsos_hist = zeros(num_gen, 1);
    
    for i = 1:num_gen
        [bloqueo, falsos, ~] = analizarRendimiento(mejores_individuos(i, :), trafico_tipos);
        bloqueo_hist(i) = bloqueo;
        falsos_hist(i) = falsos;
    end
end

function mutados = mutacionReglasFirewall(poblacion, prob, max_puerto, max_ip)
    [len, num_genes] = size(poblacion);
    mutados = poblacion;
    
    for i = 1:len
        for j = 1:5:num_genes
            if rand() < prob
                % Mutar acción
                mutados(i, j) = randi([0,1]);
                % Mutar rangos de puertos
                puerto_min = randi([1, max_puerto-50]);
                mutados(i, j+1) = puerto_min;
                mutados(i, j+2) = puerto_min + randi([0,50]);
                % Mutar rangos de IPs
                ip_min = randi([1, max_ip-20]);
                mutados(i, j+3) = ip_min;
                mutados(i, j+4) = ip_min + randi([0,20]);
            end
        end
    end
end

function hijos = cruceReglasFirewall(poblacion, probabilidad)
    [len, num_genes] = size(poblacion);
    hijos = zeros(len, num_genes);
    
    for i = 1:2:len
        p1 = poblacion(i, :);
        p2 = poblacion(mod(i,len)+1, :);
        
        if rand() < probabilidad
            % Cruce por reglas completas
            num_reglas = num_genes / 5;
            punto_cruce = randi([1, num_reglas-1]) * 5;
            hijos(i,:) = [p1(1:punto_cruce), p2(punto_cruce+1:end)];
            hijos(i+1,:) = [p2(1:punto_cruce), p1(punto_cruce+1:end)];
        else
            hijos(i,:) = p1;
            hijos(i+1,:) = p2;
        end
    end
end

function seleccionados = seleccionPorTorneoFirewall(poblacion, fitness, k)
    len = size(poblacion, 1);
    seleccionados = zeros(size(poblacion));
    
    for i = 1:len
        indices = randsample(len, k);
        [~, best_idx] = max(fitness(indices));
        seleccionados(i,:) = poblacion(indices(best_idx), :);
    end
end