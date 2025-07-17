% Red ADALINE aplicado a la MADALINE para la función lógica XNOR
% Pesos y bias iniciales: +/- 0.4

close all; 
clear; 
clc; 

X = [0 0 1 1;
     0 1 0 1]; 
Y = [1 0 0 1]; 

% a) Esquema de la red
fprintf('La red tiene un esquema de red 2x4 - 1x4\n')

% b) Gráfico de la red
red = feedforwardnet(2);
red.layers{1}.transferFcn = 'hardlim'; 
red.layers{2}.transferFcn = 'purelin';
red = configure(red, X, Y);
view(red)

% b) Matrices representativas

% I = [I11 I12;
%      I21 I22]

% Primeras dos ADALINE
% W1 = [W11 W12;
%       W21 W22]

% ADALINE de salida
% W2 = [W11; W21]

% Primeras dos ADALINE
% B1 = [B1; B2]

% ADALINE de salida
% B2 = [B1']

% Uso detallado del algoritmo paso a paso
% Parámetros generales 
alfa = 0.01;
ecma = 0.36;
JE = size(X, 2);

%% Entrenamiento de la primera ADALINE
% Salida esperada: -(A or B)
Y1 = [1 0 0 0]; 

% Pesos iniciales 
W1 = [0.4; -0.4]; 
B1 = 0.4;
max_epochs = 500;
ecm_matrix_1 = []; 
epoch1 = 1;

% Entrenamiento
fprintf('Iniciando entrenamiento...\n')
for epoch1 = 1:max_epochs
    ecm = 0; 
    fprintf('Estamos en la época: %d\n', epoch1)
    for i = 1:JE
        % Selección del punto
        punto = X(:, i);
        fprintf('Se seleccionó el punto. %d %d\n', punto)

        % Calculo de la salida lineal
        linear = W1' * punto + B1;
        fprintf('Con lo que la salida lineal es: %.3f\n', linear)

        % Error
        error = linear - Y1(i);
        fprintf('Lo que da un error de %.3f\n', error)

        % Actualización
        W1 = W1 - alfa * error * punto; 
        B1 = B1 - alfa * error;
        fprintf('Los pesos y bias actualizados son los siguientes\n')
        disp('Pesos')
        disp(W1)
        disp('Bias')
        disp(B1)

        % Suma del error en forma cuadrática
        ecm = ecm + error * error; 
    end
    
    % Actualización del ecm
    ecm = sqrt(ecm / 2); 
    fprintf('El ECM de esta época es: %.4f\n', ecm)
    % Se guarda el ecm
    ecm_matrix_1 = [ecm_matrix_1, ecm];

    % Criterio de parada
    if ecm <= ecma
        disp('Terminando el algoritmo porque se alcanzó el ecma aceptable')
        break
    end
end

fprintf('El entrenamiento ha terminado!\n')

% Verificación de las salidas
s1 = (W1' * X + B1) > 0.5;
fprintf('La salida esperada era: %d %d %d %d\n', Y1)
fprintf('La salida obtenida es: %d %d %d %d\n', s1)

% Impresión del ecm
disp('Los ECMs cada 10 épocas son:')
for i=1:10:size(ecm_matrix_1,2)
    fprintf('ECM: %.4f\n', ecm_matrix_1(i))
end
fprintf('El ECM final es: %.4f\n', ecm_matrix_1(end))
fprintf('Mostrando gráfica del ECM para esta ADALINE...\n')

% Gráfica del ecm
figure
plot(1:epoch1, ecm_matrix_1)
title('ECM en la primera ADALINE')
xlabel('Época')
ylabel('ECM')

%% Entrenamiento de la segunda ADALINE
% Salida esperada: (A and B)
Y2 = [0 0 0 1]; 

% Pesos iniciales 
W2 = [0.4; -0.4]; 
B2 = 0.4;
max_epochs = 500;
ecm_matrix_2 = []; 
epoch2 = 1;

% Entrenamiento
fprintf('Iniciando entrenamiento de la segunda ADALINE...\n')
for epoch2 = 1:max_epochs
    ecm = 0; 
    fprintf('Estamos en la época: %d\n', epoch2)
    for i = 1:JE
        % Selección del punto
        punto = X(:, i);
        fprintf('Se seleccionó el punto. %d %d\n', punto)

        % Calculo de la salida lineal
        linear = W2' * punto + B2;
        fprintf('Con lo que la salida lineal es: %.3f\n', linear)

        % Error
        error = linear - Y2(i);
        fprintf('Lo que da un error de %.3f\n', error)

        % Actualización
        W2 = W2 - alfa * error * punto; 
        B2 = B2 - alfa * error;
        fprintf('Los pesos y bias actualizados son los siguientes\n')
        disp('Pesos')
        disp(W2)
        disp('Bias')
        disp(B2)

        % Suma del error en forma cuadrática
        ecm = ecm + error * error; 
    end
    
    % Actualización del ecm
    ecm = sqrt(ecm / 2); 
    fprintf('El ECM de esta época es: %.4f\n', ecm)
    % Se guarda el ecm
    ecm_matrix_2 = [ecm_matrix_2, ecm];

    % Criterio de parada
    if ecm <= ecma
        disp('Terminando el algoritmo porque se alcanzó el ecma aceptable')
        break
    end
end

fprintf('El entrenamiento ha terminado!\n')

% Verificación de las salidas
s2 = (W2' * X + B2) > 0.5;
fprintf('La salida esperada era: %d %d %d %d\n', Y2)
fprintf('La salida obtenida es: %d %d %d %d\n', s2)

% Impresión del ecm
disp('Los ECMs cada 10 épocas son:')
for i=1:10:size(ecm_matrix_2,2)
    fprintf('ECM: %.4f\n', ecm_matrix_2(i))
end
fprintf('El ECM final es: %.4f\n', ecm_matrix_2(end))
fprintf('Mostrando gráfica del ECM para esta ADALINE...\n')

% Gráfica del ecm
figure
plot(1:epoch2, ecm_matrix_2)
title('ECM en la segunda ADALINE')
xlabel('Época')
ylabel('ECM')

%% Entrenamiento de la tercera ADALINE
% Salida esperada: (S1 or S2)
Y3 = [1 0 0 1]; 
X = [s1; s2];

% Pesos iniciales 
W3 = [0.4; -0.4]; 
B3 = 0.4;
max_epochs = 500;
ecm_matrix_3 = []; 
epoch3 = 1;

% Entrenamiento
fprintf('Iniciando entrenamiento de la tercera ADALINE...\n')
for epoch3 = 1:max_epochs
    ecm = 0; 
    fprintf('Estamos en la época: %d\n', epoch3)
    for i = 1:JE
        % Selección del punto
        punto = X(:, i);
        fprintf('Se seleccionó el punto. %d %d\n', punto)

        % Calculo de la salida lineal
        linear = W3' * punto + B3;
        fprintf('Con lo que la salida lineal es: %.3f\n', linear)

        % Error
        error = linear - Y3(i);
        fprintf('Lo que da un error de %.3f\n', error)

        % Actualización
        W3 = W3 - alfa * error * punto; 
        B3 = B3 - alfa * error;
        fprintf('Los pesos y bias actualizados son los siguientes\n')
        disp('Pesos')
        disp(W3)
        disp('Bias')
        disp(B3)

        % Suma del error en forma cuadrática
        ecm = ecm + error * error; 
    end
    
    % Actualización del ecm
    ecm = sqrt(ecm / 2); 
    fprintf('El ECM de esta época es: %.4f\n', ecm)
    % Se guarda el ecm
    ecm_matrix_3 = [ecm_matrix_3, ecm];

    % Criterio de parada
    if ecm <= ecma
        disp('Terminando el algoritmo porque se alcanzó el ecma aceptable')
        break
    end
end

fprintf('El entrenamiento ha terminado!\n')

% Verificación de las salidas
s3 = (W3' * X + B3) > 0.5;
fprintf('La salida esperada era: %d %d %d %d\n', Y3)
fprintf('La salida obtenida es: %d %d %d %d\n', s3)

% Impresión del ecm
disp('Los ECMs cada 10 épocas son:')
for i=1:10:size(ecm_matrix_3,2)
    fprintf('ECM: %.4f\n', ecm_matrix_3(i))
end
fprintf('El ECM final es: %.4f\n', ecm_matrix_3(end))
fprintf('Mostrando gráfica del ECM para esta ADALINE...\n')

% Gráfica del ecm
figure
plot(1:epoch3, ecm_matrix_3)
title('ECM en la tercera ADALINE')
xlabel('Época')
ylabel('ECM')

fprintf('Entrenamiento de la red terminado!\n')

% Número de épocas de entrenamiento
fprintf('La red se ha entrenado en: %d épocas\n', epoch1 + epoch2 + epoch3)

% Valores finales de pesos y bias
disp('Pesos finales')
disp('Para la primera ADALINE')
disp(W1)
disp('Para la segunda ADALINE')
disp(W2)
disp('Para la tercera ADALINE')
disp(W3)
disp('Pesos en ese orden')
disp('Prineras dos ADALINE')
disp(B1)
disp(B2)
disp('ADALINE de la salida')
disp(B3)

%%

%%

%%

%% Red Backpropagation para aproximar la función y = x + cos(x) 

% Una capa oculta
% Sigmoide y lineal 

clear all; 
clc; 
close all; 

% Esquema y gráfico de la red
% Se tendrán 25 neuronas en la capa oculta
% Se tendrán 2001 juegos de entradas
% Entonces, el esquema de red es: 1x2001-25-1x2001

% Gráfico de la red
red = network;

% Matrices representativas
% I = [I1, I2, I3, I4, I5, ...]
% W1 = [W11 W12, W13, W14, ... W1-25]
% W2 = [W11; W21; W31; W41 ... W25-1]
% B1 = [B1 B2 B3 ... B25]
% B2 = [B1']

% Generación de datos
X = -10:0.01:10;
Y = X + cos(X);

% Escalado
media = mean(X); 
desviacion = std(X); 
X = (X - media) / desviacion;

max_epochs = 5000; 
alfa = 0.001; 
neuronas_ocultas = 25; 
epoch = 1;
ecm_matrix = []; 
ecm_aceptable = 0.001; 

% Inicialización de pesos y bias
rng(42)
W1 = rand(1, neuronas_ocultas); 
W2 = rand(neuronas_ocultas, 1);
B1 = rand(neuronas_ocultas, 1); 
B2 = rand(); 


disp('Parámetros para el modelo Backpropagation')
disp('Se considerarán 25 neuronas en la capa oculta')
disp('Se considerarán 2001 entradas')
disp('Se tendrá una neurona en la capa de salida para aproximar la función x + cos(x)')
fprintf('Iniciando entrenamiento...\n')

% Entranimiento detallado paso a paso
for epoch = 1:max_epochs
    ecm = 0; 
    for j = 1:size(X, 2)
        % Forward Propagation
        linear = W1' * X(j) + B1;
        % Activación sigmoidal
        H1 = logsig(linear);

        linear2 = W2' * H1 + B2;
        % Activación lineal
        H2 = linear2;

        % Actualización del error
        error = H2 - Y(j);
        ecm = ecm + error * error;

        % Backpropagation
        delta2 = error * 1;
        W2 = W2 - alfa * delta2 * H1;
        B2 = B2 - alfa * delta2; 

        delta1 = (W2 * delta2) .* H1 .* (1 - H1); 
        W1 = W1 - alfa * X(j) * delta1';
        B1 = B1 - alfa * delta1;
    end
    ecm = sqrt(ecm / size(X, 2));
    ecm_matrix = [ecm_matrix, ecm]; 

    % Imprimir ECM cada 50 épocas
    if mod(epoch, 50) == 0
        fprintf('Época: %d\tECM: %d\n', epoch, ecm)
    end

    % Criterio de parada
    if ecm < ecm_aceptable
        fprintf('Terminando el algoritmo porque se alcanzó el ECM aceptable\n')
        break
    end
end

fprintf('Algoritmo terminado...\n')

% Número de épocas de entrenamiento
fprintf('El algoritmo se entrenó en %d épocas\n', epoch)

% Pesos finales
disp('Los pesos finales son: ')
disp('Para la capa oculta')
disp(W1)
disp('Para la capa de salida')
disp(W2)
disp('Los bias finales para la capa oculta son')
disp(B1)
disp('Los bias finales para la capa de salida son')
disp(B2)

% Evaluación del modelo
X_prueba = [4, 1, 2, 5, -2, 3, -3, -6, -7];
Y_esperado = X_prueba + cos(X_prueba);
X_prueba = (X_prueba - media) / desviacion; 
Z1 = logsig(W1' * X_prueba + B1);
Z2 = W2' * Z1 + B2;

% Impresión de los resultados
disp('Se quiere probar el modelo con los siguientes puntos')
disp(X_prueba)
fprintf('Valores obtenidos con el argoritmo\n')
disp(Z2)
fprintf('Valores esperados\n')
disp(Y_esperado)

% Gráfica del ECM
figure
plot(1:size(ecm_matrix, 2), ecm_matrix)
title('ECM según las épocas de entrenamiento')
xlabel('Época')
ylabel('ECM')

% Gráfica de salida predicha vs esperada
Z1 = logsig(W1' * X + B1);
Z2 = W2' * Z1 + B2;
figure
plot(1:size(X,2), Z2)
hold on;
plot(1:size(X,2), Y);
title('Salida predicha vs esperada')
xlabel('Entrada x')
ylabel('Salida x + cos(x)')
legend('Salida predicha', 'Salida esperada')

%% Novedad

clear; 
clc; 
close all;

% Generar un vector de 20 valores enteros en [-3, 5]
% Semilla para obtener siempre los mismos valores
rng(42)
fprintf('Generando un vector de 20 valores enteros en [-3, 5]...\n')
vector_inicial = randi([-3 5], 1, 20); 
fprintf('El vector generado es:\n')
fprintf('%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n', vector_inicial)

% Generar 10 nuevos valors entre -4 y 7
fprintf('Generando 10 nuevos valors entre [-4, 7]...\n')
vector_nuevo = randi([-4, 7], 1, 10); 
fprintf('%d %d %d %d %d %d %d %d %d %d\n', vector_nuevo)

% Matrices para resultados globales
novedades = []; 
no_novedades = [];
vector_total = vector_nuevo; 
historial_promedios = [];
colores = zeros(size(vector_nuevo, 2), 3); 

% Procesamiento por novedad
promedio = mean(vector_inicial);
fprintf('El promedio con el que se inicia es de %.3f\n\n', promedio)

% Bucle principal
fprintf('Iniciando el procesamiento...\n')
for i = 1:size(vector_nuevo, 2)
    % Actualizamos el historial de promedios
    historial_promedios = [historial_promedios, promedio]; 

    % Selección del nuevo valor
    valor = vector_nuevo(i);
    fprintf('El valor nuevo tomado es de %d\n', valor)

    % Calculo de la diferencia
    diferencia = abs(valor - promedio);
    fprintf('La diferencia con el promedio es de %.3f\n', diferencia)
    
    % Criterios para considerar novedad o no
    if diferencia >= 1
        fprintf('En base a esto, se trata de una novedad\n')

        % Actualizar el vector de novedades
        novedades = [novedades, valor]; 
        fprintf('Hasta ahora se tienen las siguientes novedades: \n')
        disp(novedades)

        % Actualizar el vector de colores
        colores(i, :) = [1 0 0];  
    else
        fprintf('No se trada de una novedad\n')

        % Actualizar el vector de no novedades
        no_novedades = [no_novedades, valor];
        fprintf('Hasta ahora se tienen los valores considerados como no novedades: \n')
        disp(no_novedades)
        
        % Actualizar el vector de colores
        colores(i, :) = [0 0 1]; 
    end
    vector_total = [vector_total, valor];
    promedio = mean(vector_total); 
    fprintf('El nuevo promedio es de %.3f\n', promedio)
end

fprintf('Fin del procesamiento!\n')
fprintf('Se encontraron las siguientes novedades:\n')
disp(novedades)
fprintf('Se encontraron las siguientes no novedades:\n')
disp(no_novedades)
fprintf('Mostrando gráficos relevantes...\n')

% Gráfica del historial de promedios
figure
plot(1:size(vector_nuevo, 2), historial_promedios)
xlabel('Indice el valor analizado')
ylabel('Promedio en dicho valor')
title('Promedio según los valores analizados')
yline(historial_promedios(1))
grid on;

% Gráfica de los valores y su promedio
figure
barras = bar(1:size(vector_nuevo, 2), vector_nuevo, 'FaceColor', 'flat');
barras.CData = colores;
hold on;
scatter(1:size(historial_promedios, 2), historial_promedios, 'filled', 'black')
title('Promedios vs valores nuevos')
xlabel('Indice del valor nuevo')
ylabel('Valor nuevo analizado')
legend('Valores de análisis (Rojo: Novedades)', 'Promedio')
grid on;

%%
%% Análisis de componentes principales

clear;
close all;
clc;

neuronas = 6; 
JE = 4; 
dimension = 2; 
minimo = -3; 
maximo = 3; 
rng(42)

% Generar matrices de entradas
X = minimo + rand(dimension, JE) * (maximo - minimo);
fprintf('Las entradas a evaluar son: \n')
disp(X)

% Generar pesos iniciales
W = minimo + rand(neuronas, dimension) * (maximo - minimo); 
fprintf('Los pesos de las neuronas son:\n')
disp(W)

% a) Esquema de la red
fprintf('La red tiene un esquema de red: 2x4 - 6 - 1x6\n\n')

% b) Gráfico de la red
%      |-- N11 N12  ->  d1
%      |-- N21 N22  ->  d2 
% I1 |_|-- N31 N32  ->  d3
% I2 | |-- N41 N42  ->  d4
%      |-- N51 N52  ->  d5
%      |-- N61 N62  ->  d6

% En el gráfico cada entrada (con dos coordinadas) se procesa
% por cada neurona (dos pesos) y se produce una salida (distancia)

% Matrices representativas
% I = [I11 I12 I13 I14;
%      I21 I22 I23 I34]

% W = [W11 W12;
%      W21 W22;
%      W31 W32;
%      W41 W42;
%      W51 W52;
%      W61 W62];

% Procesamiento
distancias_JE = zeros(1, JE);
neuronas_ganadoras = zeros(1, JE); 

fprintf('Iniciando procesamiento...\n')
% Iteración para cada JE
for i = 1:JE
    % Generar vector de distancias nuevo
    distancias_neuronas = zeros(1, neuronas);

    % Selección de la entrada
    entrada = X(:, i);
    fprintf('Evaluando el vector (%.3f, %.3f)\n', entrada(1), entrada(2))

    % Iteración para cada neurona
    for j = 1:neuronas
        % Selección de pesos
        pesos = W(j, :);

        % Cálculo de la distancia solicitada
        distancia = sum(abs(entrada - pesos'));
        fprintf('La distancia para la neurona %d es %.3f\n', j, distancia)

        % Almacenar distancia
        distancias_neuronas(j) = distancia;
    end
    % Conseguir la distancia mínima para el juego de entradas
    [dist_min, indice_neurona] = min(distancias_neuronas);
    distancias_JE(i) = dist_min;
    neuronas_ganadoras(i) = indice_neurona;
    fprintf('La distancia mínima para este JE es: %.3f\n', dist_min)
    fprintf('La neurona ganadora es: %d\n\n', indice_neurona)
end

fprintf('Procesamiento finalizado con éxito!\n\n')

% Mostrar resultados del procesamiento
fprintf('Mostrando resumen del procesamiento...\n')
fprintf(['Las neuronas ganadoras para cada juego de entrada son: ' ...
    '%d %d %d %d %d %d\n'], neuronas_ganadoras)
fprintf('\nSus respectivas distancias son: %.3f %.3f %.3f %.3f', distancias_JE)

% Gráfica de neuronas y entradas en el plano
figure
scatter(X(1, :), X(2, :), 'blue')
hold on;
scatter(W(:, 1), W(:, 2), 'red')

for i = 1:JE
    ganadora = neuronas_ganadoras(i);
    pesos_ganadora = W(ganadora, :); 
    entrada = X(:, i); 
    plot([entrada(1), pesos_ganadora(1)], [entrada(2), pesos_ganadora(2)])
end

title('Entradas y neuronas vistas en 2D')
xlabel('Coordenada 1')
ylabel('Coordenada 2')
legend('Entradas', 'Neuronas')
grid on;

%%

%% Red de Kohonen para clasificar datos agrupados
clear; 
close all; 
clc; 

% Creación de los datos agrupados
rng(42)
clusters = 6; 
puntos = 12; 
std_deviation = 0.03;
bordes = [0 1; 0 1]; 
X = nngenc(bordes, clusters, puntos, std_deviation);

% Visualización de los datos
figure
scatter(X(1, :), X(2, :), 'x')
xlabel('Dimensión 1')
ylabel('Dimensión 2')
title('Clusters generados')

% Parámetros generales de la red
filas = 3; 
columnas = 5; 
neuronas = 15;

% a) Esquema de la red
fprintf('La red tiene un ER: 2x72 - 15 - 15 x 72\n')
fprintf(['Ya que hay 72 entradas con dos características cada una, 15 neuronas procesadoras' ...
    ' y 15 salidas para cada una de las 72 entradas\n'])

% a) Gráfico de la red
dimension = [filas columnas];
red = selforgmap(dimension);
red = configure(red, X);
view(red)

% b) Matrices representativas
% I = [I11 I12 I13 ... I1-72;
%      I21 I22 I23 ... I2-72]

% W = [W11 W12 W13 W14 W15;
%      W21 W22 W23 W24 W25;
%      W31 W32 W33 W34 W35]

% donde Wij = (wij1, wij2) 

% c) Parámetros de la creación de los datos agrupados
fprintf('Los parámetros de la creación de los datos agrupados son:\n')
fprintf('Número de grupos: %d\n', clusters)
fprintf('Número de puntos en cada grupo: %d\n', puntos)
fprintf('Desviación estándar: %.4f\n', std_deviation)
fprintf('Bordes: [%d %d; %d %d]\n', bordes(1, :), bordes(2, :))

%% d) Resultados del procesamiento
rng(42)
% Variables generales
JE = puntos * clusters; 
W = rand(filas, columnas, 2);
ganadoras = zeros(2, JE);
distancias_minimas = zeros(1, JE); 
alfa_o = 0.3;
radio_o = 2;
radio_f = 0.5; 
alfa_f = 0.01;
epocas = 300;

% Bucle principal
fprintf('Iniciando entrenamiento...\n')
for epoch = 1:epocas
    % Impresión del avance de épocas
    if mod(epoch, 20) == 0
        fprintf('Entranando en la época %d\n', epoch)
    end

    for i = 1:JE
        % Selección de la entrada
        entrada = X(:, i); 
        
        % Variables generales
        idx = 0;
        idy = 0;
        mejor_distancia = 100;
    
        % Calculo de las distancias para cada neurona
        for j = 1:filas
            for k = 1:columnas
                % Cálculo de la distancia
                pesos = [W(j, k, 1) W(j, k, 2)];
                distancia = sum(abs(pesos - entrada'));
    
                % Se guardan los índices de la ganadora
                if distancia < mejor_distancia
                    idx = j;
                    idy = k;
                    mejor_distancia = distancia; 
                end
            end
        end
        
        % Calculo de la tasa de aprendizaje
        alfa = alfa_o * (alfa_f/alfa_o) ^ (epoch / epocas);
        radio = radio_o * (radio_f / radio_o) ^ (epoch / epocas);
        
        % Activación en escalón
        for l = 1:filas
            for m = 1:columnas
                distancia = abs(idx - l) + abs(idy - m);
                activacion = 0;

                if distancia <= radio
                    activacion = 1;
                end
                % Actualización de los pesos de las vecinas
                W(l, m, 1) = W(l, m, 1) - alfa * activacion * (W(l, m, 1) - entrada(1));
                W(l, m, 2) = W(l, m, 2) - alfa * activacion * (W(l, m, 2) - entrada(2));
            end
        end

        % Guardar info en la época final
        if epoch == epocas
            ganadoras(1, i) = idx; ganadoras(2, i) = idy;
            distancias_minimas(i) = mejor_distancia; 
        end
    end
end

fprintf('Entrenamiento finalizado con éxito!\n\n')

% d) Escriba los resultados del tipo de procesamiento
fprintf('Estos son los resultados del procesamiento\n')
fprintf('Las neuronas ganadoras fueron\n')
for i = 1:JE
    fprintf('Para la entrada %d: (%d, %d)\n', i, ganadoras(1, i), ganadoras(2, i))
end

% e) Adicional - Gráfico de la asignación de pesos
fprintf('Generando gráfica 2D para ver los resultados...\n')
figure;
scatter(X(1,:), X(2,:), 'filled');
hold on;
for i = 1:JE
    w1 = W(ganadoras(1, i), ganadoras(2, i), 1);
    w2 = W(ganadoras(1, i), ganadoras(2, i), 2);
    plot([X(1, i) w1], [X(2, i) w2], 'red')
end
title('Asignación de entradas a neuronas ganadoras')
xlabel('Dimension 1')
ylabel('Dimension 2')
grid on; 
fprintf('Gráfica generada con éxito\n')