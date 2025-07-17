%%  Entrenar la red (A XOR B) OR (A OR C)

clear; 
clc; 
close all; 

% Código UNI: 20230014H
% Pesos y bias iniciales +/- 0.4

% Paso cero: Verificación de la red
fprintf('Se desea verificar que la red es entrenable\n')
X = [0 0 0 0 1 1 1 1
     0 0 1 1 0 0 1 1
     0 1 0 1 0 1 0 1]; 
Y = [0 1 1 1 1 1 1 1]; 
fprintf('La salida deseada es: %d %d %d %d %d %d %d %d\n', Y)
fprintf('Se ve que se puede trazar un plano de separación que separa una de las esquinas\n')
fprintf('Por lo tanto la red es entrenable\n');
plotpv(X, Y)

% a) Esquema de la red
fprintf('La red tiene un ER: 3x8 - 1 x 8\n')

% a) Gráfico de la red
red = linearlayer();
red = configure(red, X, Y);
view(red)

% b) Matrices representativas
% I = [I11 I12 I13 I14 ... I18;
%      I21 I22 I23 I24 ... I28;
%      I31 I32 I33 I34 ... I38];

% W = [W11; W21; W31] 

% B = [B1]

% c) Pesos y biases iniciales
W = [0.4; -0.4; 0.4]; 
B = 0.4; 

% Variables globales
alfa = 0.005; 
ecma = 0.506; 
max_epochs = 1000; 
ecm_matrix = []; 
epoch = 1; 
umbral = 0.6; 
JE = size(X, 2);

% d) Uso detallado del algoritmo paso a paso, mostrando resultados en cada
% paso
for epoch = 1:max_epochs
    ecm = 0;

    fprintf('Se está entrenando la época %d\n', epoch)

    for i = 1:JE
        % Selección del punto
        punto = X(:, i);
        fprintf('Punto seleccionado: %d %d %d\n', punto)

        % Cálculo de la salida
        salida = W' * punto + B; 
        fprintf('Salida obtenida: %.3f\n', salida)

        % Cálculo del error
        error = salida - Y(i); 
        fprintf('Error encontrado: %.3f\n', error)
        
        %  Actualización del ECM
        ecm = ecm + error * error; 

        % Actualización
        fprintf('Actualizando pesos y bias...\n')
        W = W - alfa * error * punto; 
        B = B - alfa * error; 
        disp('Pesos actualizados')
        disp(W)
        disp('Bias actualizado')
        disp(B)
    end
    ecm = sqrt(ecm / 2); 
    fprintf('El ECM de esta época es: %.3f\n', ecm)

    % Actualización de la matriz de ECMs
    ecm_matrix = [ecm_matrix, ecm]; 

    % Criterio de parada
    if ecm <= ecma
        fprintf('Terminando el algoritmo porque se alcanzó el ECM aceptable...\n')
        break
    end
end
fprintf('Algoritmo de entrenamiento finalizado con éxito!\n\n')

% e) Número de épocas de entrenamiento y valores finales de pesos y bias
fprintf('La red se entrenó en %d épocas\n', epoch)
fprintf('Los pesos finales encontrados son: \n')
disp(W)
fprintf('El bias final encontrado es: \n')
disp(B)

% f) Extra - Gráfico del ECM
fprintf('Mostrando gráfico del ECM...\n')
figure
plot(1:epoch, ecm_matrix)
title('ECM según la época')
xlabel('Época')
ylabel('ECM')
grid on; 
fprintf('Gráfico generado con éxito!\n')

% g) Extra - Comprobación de la red
fprintf('Comprobando la red...\n')
fprintf('La salida deseada es: %d %d %d %d %d %d %d %d\n', Y)
salida_final = (W' * X + B) > umbral; 
fprintf('La salida obtenida es: %d %d %d %d %d %d %d %d\n', salida_final)
fprintf('Puede verse que la salida obtenida es igual a la salida deseada\n')

%%

%%

%%

%%

%% Red neuronal Backpropagation para aproximar y = x^3 + 2x - 1
% Red MLP con 10 neuronas ocultas
% Funciones: tansig, purelin
close all;
clear;
clc;

% Generar 100 puntos entre -2 y 2
JE = 100; 
minimo = -2; 
maximo = 2; 

% Creación de entradas
rng(42)
X = minimo + rand(1, JE) * (maximo - minimo);
X = sort(X, 'ascend');

Y = X.^3 + 2*X - 1;

neuronas_ocultas = 10; 

% a) Crear y configurar la red neuronal
red = fitnet(neuronas_ocultas);
red = configure(red, X, Y); 
view(red)

% b) Entrenar y simular la red
red = train(red, X, Y);

% b) Entrenamiento manual de la red
% Variables globales 
alfa = 0.01; 
ecma = 0.05; 
max_epochs = 8000; 
ecm_matrix = []; 
epoch = 1; 

% Inicialización de pesos y bias
W1 = randn(1, neuronas_ocultas); 
W2 = randn(neuronas_ocultas, 1); 
B1 = randn(neuronas_ocultas, 1);
B2 = randn(1, 1); 

W1_copy = W1; 
W2_copy = W2; 
B1_copy = B1; 
B2_copy = B2; 

for epoch = 1:max_epochs
    ecm = 0; 
    % Impresión del avance según época
    if mod(epoch, 200) == 0
        fprintf('El algoritmo se encuentra en la época %d\n', epoch)
    end
    for i = 1:JE
        % Selección del punto
        punto = X(1, i); 

        % Propagación hacia adelante
        linear1 = W1' * punto + B1; 
        Z1 = tansig(linear1); 

        linear2 = W2' * Z1 + B2;
        Z2 = linear2; 

        % Backpropagation
        error = Z2 - Y(i);
        ecm = ecm + error * error; 

        % Activación lineal: f' = 1
        delta2 = error * 1;

        W2 = W2 - alfa * Z1 * delta2'; 
        B2 = B2 - alfa * delta2; 
        
        % Activación tanh: f' = (1 - f^2)
        delta1 = (W2 * delta2) .* (1 - Z1.^2);
        
        W1 = W1 - alfa * punto * delta1'; 
        B1 = B1 - alfa * delta1; 
    end

    % Actualización del ECM y guardado
    ecm = sqrt(ecm/2);
    ecm_matrix = [ecm_matrix, ecm]; 

    % Criterio de parada
    if ecm <= ecma
        fprintf('Terminando el algoritmo porque se alcanzó el ECM aceptable\n')
        break; 
    end
end
fprintf('Algoritmo terminado con éxito!\n')

% Calcular salida con la primera red
Z1_1ra = tansig(W1' * X + B1); 
Z2_1ra = W2' * Z1_1ra + B2; 

% e) FA: tansig - logsig
ecm_matrix_2 = []; 
epoch2 = 1; 

fprintf('Iniciando entrenamiento de la 2da red\n')
for epoch2 = 1:max_epochs
    ecm = 0; 
    % Impresión del avance según época
    if mod(epoch2, 200) == 0
        fprintf('El algoritmo se encuentra en la época %d\n', epoch2)
    end
    for i = 1:JE
        % Selección del punto
        punto = X(1, i); 

        % Propagación hacia adelante
        linear1 = W1_copy' * punto + B1_copy; 
        Z1 = tansig(linear1); 

        linear2 = W2_copy' * Z1 + B2_copy;
        Z2 = logsig(linear2); 

        % Backpropagation
        error = Z2 - Y(i);
        ecm = ecm + error * error; 

        % Activación logsig: f' = f * (1 - f)
        delta2 = error .* Z2 .* (1 - Z2);

        W2_copy = W2_copy - alfa * Z1 * delta2'; 
        B2_copy = B2_copy - alfa * delta2; 
        
        % Activación tansig: f' = (1 - f^2)
        delta1 = (W2_copy * delta2) .* (1 - Z1.^2);
        
        W1_copy = W1_copy - alfa * punto * delta1'; 
        B1_copy = B1_copy - alfa * delta1; 
    end

    % Actualización del ECM y guardado
    ecm = sqrt(ecm/2);
    ecm_matrix_2 = [ecm_matrix_2, ecm]; 

    % Criterio de parada
    if ecm <= ecma
        fprintf('Terminando el algoritmo porque se alcanzó el ECM aceptable\n')
        break; 
    end
end

fprintf('Entrenamiento de la segunda red terminado!\n')

% Calcular salida con la segunda red
Z1_2da = tansig(W1_copy' * X + B1_copy); 
Z2_2da = logsig(W2_copy' * Z1_2da + B2_copy); 

%% c) Graficar resultados
% Grafica de los resultados
figure
plot(X, Y)
hold on;
plot(X, Z2_1ra)
plot(X, Z2_2da)
xlabel('Entrada X')
ylabel('Función X^3 + 2X - 1')
title('Salida esperada vs salida predicha')
legend('Salida esperada', 'Salida predicha con la 1ra red', 'Salida predicha con la 2da red')
grid on; 

% d) Número de épocas y valores finales de pesos y bias
fprintf('Para la primera red\n')
fprintf('El modelo se entrenó en %d épocas\n', epoch)
fprintf('Los pesos finales de la capa oculta son:\n')
disp(W1)
fprintf('Los pesos finales de la capa de salida son: \n')
disp(W2)
disp('Los bias finales de la capa oculta son')
disp(B1)
disp('El bias final de la capa de salida es')
disp(B2)

fprintf('Para la segunda red\n\n')
fprintf('El modelo se entrenó en %d épocas\n', epoch2)
fprintf('Los pesos finales de la capa oculta son:\n')
disp(W1_copy)
fprintf('Los pesos finales de la capa de salida son: \n')
disp(W2_copy)
disp('Los bias finales de la capa oculta son')
disp(B1_copy)
disp('El bias final de la capa de salida es')
disp(B2_copy)

% Gráficas el ecm
figure
plot(1:epoch, ecm_matrix)
hold on;
plot(1:epoch2, ecm_matrix_2)
title('ECM en las redes')
xlabel('Época')
ylabel('ECM')
grid on; 

%%


%%

%%

%%


%%

%%

clear;
clc;
close all;

load fisheriris

% a) Analizar y describir el dataset de Iris
fprintf('Análisis del dataset Fisheriris\n')
fprintf('El dataset tiene los grupos meas y species\n')
fprintf('Meas contiene información como:\n')
fprintf('\t Longitud del sépalo en cm\n')
fprintf('\t Ancho del sépalo en cm\n')
fprintf('\t Longitud del pétalo en cm\n')
fprintf('\t Ancho del pétalo en cm\n\n')
fprintf('El arreglo meas tiene dimensiones (%d, %d)\n', size(meas,1), size(meas,2))
fprintf('El arreglo species tiene la clasificación de la flor a la que pertenecen esas características\n')
fprintf('Este arreglo tiene %d filas y %d columnas\n', size(species, 1), size(species, 2))
fprintf('Se tienen los tipos: Setosa, Versicolor y Virginica\n')

% Normalización de datos (CRÍTICO para convergencia)
fprintf('\nNormalizando datos para mejorar convergencia...\n')
X_raw = meas';
X = (X_raw - min(X_raw, [], 2)) ./ (max(X_raw, [], 2) - min(X_raw, [], 2));
fprintf('Datos normalizados en rango [0,1]\n')

% Crear la red de Kohonen de 3x3 nodos y entrenar
rng(42)
filas = 3; 
columnas = 3; 
num_caracteristicas = 4; 

% Inicialización mejorada de pesos (pequeños valores aleatorios)
W = randn(filas, columnas, num_caracteristicas);
alfa_o = 0.5; 
alfa_f = 0.01; 
radio_o = 2.0; 
radio_f = 0.5; 
max_epochs = 5000; 
epoch = 1;
JE = size(X, 2);
pesos = zeros(1, num_caracteristicas);
ganadoras = zeros(2, JE);
distancias = zeros(1, JE); 

% Arrays para monitoreo de convergencia
error_cuantico = zeros(1, max_epochs);

% Bucle principal
fprintf('Iniciando entrenamiento...\n')
for epoch = 1:max_epochs

    if mod(epoch, 500) == 0
        fprintf('Entrenando en la época %d\n', epoch)
    end
    
    % Variables para cálculo de error cuántico
    sum_min_dist = 0;
    
    % Iteración para cada JE
    for i = 1:JE
        entrada = X(:, i);
        min_distancia = inf;

        % Iteración para cada neurona
        for j = 1:filas
            for k = 1:columnas
                pesos(1) = W(j, k, 1); pesos(2) = W(j, k, 2);
                pesos(3) = W(j, k, 3); pesos(4) = W(j, k, 4);
                
                % Distancia euclidiana vectorizada
                distancia = norm(entrada - pesos);
                
                % Se encuentra la distancia mínima
                if distancia < min_distancia
                    min_distancia = distancia;
                    idx = j;
                    idy = k; 
                end
            end
        end
        
        % Acumular error cuántico
        sum_min_dist = sum_min_dist + min_distancia;
        
        %  Cálculo de alfa y el radio según época
        alfa = alfa_o * (alfa_f/alfa_o) ^ (epoch/max_epochs);
        radio = radio_o * (radio_f/radio_o) ^ (epoch/max_epochs);
        sigma = radio; 

        % Iteración para cada neurona y actualización
        for l = 1:filas
            for m = 1:columnas
                pesos(1) = W(l, m, 1); pesos(2) = W(l, m, 2);
                pesos(3) = W(l, m, 3); pesos(4) = W(l, m, 4);

                dist_neurona = sqrt((l-idx)^2 + (m-idy)^2);

                activacion = exp(- (dist_neurona^2) / (2 * sigma^2));

                % Corrección: actualización correcta de pesos
                pesos = pesos + alfa * activacion * (entrada' - pesos);
                W(l, m, 1) = pesos(1); W(l, m, 2) = pesos(2);
                W(l, m, 3) = pesos(3); W(l, m, 4) = pesos(4);
            end
        end
        % Almacenar ganadoras en la última época
        if epoch == max_epochs
            ganadoras(1, i) = idx; ganadoras(2, i) = idy;
            distancias(1, i) = min_distancia; 
        end
    end
    
    % Calcular errores de época
    error_cuantico(epoch) = sum_min_dist / JE;
end

fprintf('Entrenamiento finalizado con éxito!\n')
fprintf('Error cuántico final: %.4f\n', error_cuantico(end))

% Gráfico de convergencia
figure(1);
plot(1:max_epochs, error_cuantico, 'b-', 'LineWidth', 2);
xlabel('Época');
ylabel('Error Cuántico');
title('Convergencia del Error Cuántico');
grid on;

% Mostrar resultados del procesamiento
colores = ones(filas, columnas, 3);
conteo_setosa = zeros(filas, columnas);
conteo_virginica = zeros(filas, columnas); 
conteo_versicolor = zeros(filas, columnas); 

total_setosa = 0;
total_virginica = 0; 
total_versicolor = 0;

% Iteración para cada juego de entradas
for i = 1:JE
    idx = ganadoras(1, i); 
    idy = ganadoras(2, i); 
    switch species{i}
        case 'setosa'
            conteo_setosa(idx, idy) = conteo_setosa(idx, idy) + 1;
            total_setosa = total_setosa + 1;
        case 'versicolor'
            conteo_versicolor(idx, idy) = conteo_versicolor(idx, idy) + 1;
            total_versicolor = total_versicolor + 1; 
        case 'virginica'
            conteo_virginica(idx, idy) = conteo_virginica(idx, idy) + 1; 
            total_virginica = total_virginica + 1; 
    end
end

% Escalado de cero a a uno
conteo_setosa = conteo_setosa / total_setosa; 
conteo_virginica = conteo_virginica / total_virginica;
conteo_versicolor = conteo_versicolor / total_versicolor;

colores(:, :, 1) = conteo_setosa;
colores(:, :, 2) = conteo_virginica;
colores(:, :, 3) = conteo_versicolor;

% Mapa autoorganizado mejorado
figure(2);
imagesc(colores)
colorbar
xlabel('Columna de la grilla')
ylabel('Fila de la grilla')
title('Distribución normalizada de clases en cada neurona')

% Añadir etiquetas en cada celda
for i = 1:filas
    for j = 1:columnas
        % Encontrar clase dominante
        [~, clase_dom] = max([conteo_setosa(i,j), conteo_virginica(i,j), conteo_versicolor(i,j)]);
        clases = {'S', 'Vi', 'Ve'};
        
        % Contar muestras totales en esta neurona
        total_muestras = sum(ganadoras(1,:) == i & ganadoras(2,:) == j);
        
        if total_muestras > 0
            text(j, i, sprintf('%s\n(%d)', clases{clase_dom}, total_muestras), ...
                'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
                'Color', 'white', 'FontWeight', 'bold', 'FontSize', 10);
        end
    end
end

% Análisis adicional de la calidad del mapa
figure(3);
distancias_reshape = reshape(distancias, 1, []);
histogram(distancias_reshape, 20);
xlabel('Distancia a neurona ganadora');
ylabel('Frecuencia');
title('Distribución de distancias cuánticas finales');
grid on;

fprintf('\nAnálisis de calidad del mapa:\n')
fprintf('Distancia cuántica promedio: %.4f\n', mean(distancias_reshape))
fprintf('Desviación estándar: %.4f\n', std(distancias_reshape))

% Matriz de confusión simplificada
fprintf('\nDistribución de clases por neurona:\n')
for i = 1:filas
    for j = 1:columnas
        neurona_samples = ganadoras(1,:) == i & ganadoras(2,:) == j;
        if sum(neurona_samples) > 0
            fprintf('Neurona (%d,%d): ', i, j)
            clases_neurona = species(neurona_samples);
            setosa_count = sum(strcmp(clases_neurona, 'setosa'));
            versicolor_count = sum(strcmp(clases_neurona, 'versicolor'));
            virginica_count = sum(strcmp(clases_neurona, 'virginica'));
            fprintf('Setosa=%d, Versicolor=%d, Virginica=%d\n', ...
                setosa_count, versicolor_count, virginica_count);
        end
    end
end