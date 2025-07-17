%% Entrenar C or (not A or B)
clear all;
close all;
clc;

X = [0 0 0 0 1 1 1 1;
     0 0 1 1 0 0 1 1;
     0 1 0 1 0 1 0 1];
Y = [1 1 1 1 0 1 1 1];

% Verificar si la red es entrenable
fprintf('Verificar si la red es entrenable\n')
red = perceptron();
red = train(red, X, Y);
pesos = red.IW{1,1};
bias = red.b{1,1};

% Impresión de gráfico
plotpv(X, Y)
plotpc(pesos, bias)

fprintf('Se puede ver que la red es entrenable, por lo tanto se continua con el entrenamiento\n')

% Esquema y gráfico de red
fprintf('La red tiene un ER: 3x8-1x8\n')

% Gráfico de la red
view(red);

% Matrices representativas
% I = [I11 I12 I13 ... I18;
%      I21 I22 I23 ... I28
%      I31 I32 I33 ... I38]

% W = [W11; W21; W31] 
% B = [B1 B1 B1 ... B1]

% Uso detallado del algoritmo paso a paso
% Código UNI: 20240014H
alfa = 0.4; 
W = [-0.1; -0.1; 0.1]; 
B = 0.1; 
errores_matrix = []; 
epoch = 1; 
weigths = [];
bias = []; 

while true
    errores = zeros(1, size(X, 2));
    fprintf('Iniciando la época %d\n', epoch)
    for i = 1:size(X,2)
        % Selección del punto o entrada
        entrada = X(:, i);
        fprintf('La entrada seleccionada es: %d %d %d\n', entrada(1), entrada(2), entrada(3))
        
        % Calculo de la salida lineal
        linear = W' * entrada + B;
        fprintf('La salida lineal obtenida es %.3f\n', linear)

        % Se aplica la función de activación
        salida = hardlim(linear);
        fprintf('La salida con hardlim es %d\n', salida)
        fprintf('La salida esperada es: %d\n', Y(i))
        
        % Se calcula el error
        error = salida - Y(i);
        fprintf('Lo cual da un error de: %d\n', error)
        
        if error ~= 0
            errores(i) = 1; 
            % Actulización de pesos y bias
            W = W - alfa * error * entrada; 
            B = B - alfa * error;
            fprintf('Los pesos y bias se actualizan de la siguiente manera: \n')
            disp('Nuevos pesos')
            disp(W)
            disp('Nuevo bias')
            disp(B)
        else
            fprintf('Entonces no es necesario actualizar\n')
        end
    end
    % Recolectar número de errores en esta época
    errores_matrix = [errores_matrix, sum(errores)];

    % Almacenar los pesos y bias
    weigths = [weigths; W'];
    bias = [bias, B];
    
    % Mostrar la evolución de los planos cada 2 épocas
    if mod(epoch, 2) == 0
        figure
        plotpv(X, Y)
        hold on; 
        plotpc(weigths(size(weigths, 1), :), bias(size(weigths, 1)))
        title('Gráfico del PS en la época %d', epoch)
    end

    % Aumentar en uno el número de épocas
    epoch = epoch + 1; 

    % Criterio de parada
    if sum(errores) == 0
        break
    end
end

fprintf('Algoritmo terminado...\n')

% Número de épocas de entrenamiento
fprintf('El algoritmo se entrenó en %d épocas\n', epoch-1)

% Valores finales W y B
disp('Los pesos finales encontrados son:')
disp(W)
disp('El bias final es:')
disp(B)

% Puntos y plano de separación finales
figure
plotpv(X,Y)
hold on; 
plotpc(W', B)
title('Gráfica final de la red entrenada')

%% Entrenar de forma manual A and (B or C) 
clear all;
close all; 
clc; 

X = [0 0 0 0 1 1 1 1;
     0 0 1 1 0 0 1 1;
     0 1 0 1 0 1 0 1]; 
Y = [0 0 0 0 0 1 1 1]; 

% Verificación de que la red es entrenable
fprintf('Verificando que la red es entrenable...\n')
red = perceptron();
red = configure(red, X, Y);

red.IW{1,1} = [0.1 -0.1 0.1]; 
red.b{1,1} = 0.1;
red.trainParam.lr = 0.4;

red = train(red, X, Y); 
pesos = red.IW{1,1};
bias = red.b{1,1};
plotpv(X, Y);
plotpc(pesos, bias)
fprintf('Se puede ver que la red es entrenable, por lo que se detallará el entrenamiento\n')

% Esquema de red
fprintf('La red tiene un esquema de red: 3x8-1x8\n')

% Gráfico de la red
view(red)

% Matrices representativas
fprintf('Las matrices representativas de la red son las siguientes:\n')
fprintf('Matriz de pesos\n')
fprintf('W = [W11; W21; W31]\n')
fprintf('Bias\n')
fprintf('B = [B1]\n')
fprintf('Entradas\n')
fprintf('I = [I11 I12 I13 ... I18;\n     I21 I22 I23 ... I28;\n     I31 I32 I33 ... I38]\n')

% Uso detallado del algoritmo paso a paso
% Código UNI: 20230014H
alfa = 0.4; 
W = [0.1; -0.1; 0.1]; 
B = 0.1; 
ecm = 0; 
ecm_matrix = []; 
epoch = 1; 
JE = size(X, 2); 
num_errores = []; 
weights = [];
bias = []; 

while true
    errores = zeros(1, JE);
    fprintf('Estamos en la época %d\n', epoch)
    for i = 1:JE
        % Selección del punto
        punto = X(:, i);
        fprintf('El punto seleccionado es: %d %d %d\n', punto)

        % Evaluación de la salida
        linear = W' * punto + B; 
        salida = hardlim(linear);
        fprintf('La salida lineal calculada es: %.4f\n', linear)
        fprintf('La salida con hardlim es: %d\n', salida)

        % Cálculo del error
        fprintf('La salida esperada es: %d\n', Y(i))
        error = salida - Y(i);
        fprintf('Esto da un error de: %d\n', error)

        % Error diferente de cero, actualizar
        if error ~= 0
            fprintf('Como este error es diferente de cero, se actualizan pesos y bias\n')
            errores(i) = 1; 
            W = W - alfa * error * punto; 
            B = B - alfa * error;
            fprintf('Nuevos pesos\n')
            disp(W)
            fprintf('Nuevos bias\n')
            disp(B)
        else
        % Error igual a cero, no actualizar
            fprintf('Entonces no se actualiza\n')
        end
    end
    % Guardar los pesos y bias de esta generación
    weights = [weights; W']; 
    bias = [bias, B]; 

    % Guardar el número de errores de esta época
    num_errores = [num_errores sum(errores)]; 

    % Verificación de que la red está entrenada
    if sum(errores) == 0
        fprintf('No se detectaron errores, la red está entrenada!\n')
        break
    end
    
    % Mostrar la evolución de los PS
    if mod(epoch, 3) == 0
        figure
        plotpv(X, Y)
        hold on; 
        plotpc(weights(epoch-1,:), bias(epoch-1))
        plotpc(weights(epoch,:), bias(epoch))
    end

    % Sumar una época
    epoch = epoch + 1; 
end

fprintf('Algoritmo de entrenamiento terminado...\n')

% Verificación de que la red está entrenada
s = hardlim(W' * X + B); 
fprintf('Verificación de que la red está entrenada\n')
fprintf('La salida esperada es:\n')
disp(Y)
fprintf('La salida obtenida es:\n')
disp(s)
fprintf('Con esto se ve que la red está entrenada!\n')

% Número de épocas de entrenamiento
fprintf('La red se entrenó en %d épocas, empezando en la época 1\n', epoch)
fprintf('Los pesos finales son\n')
disp(W)
fprintf('Los bias finales son\n')
disp(B)

% Gráfica del plano de separación final
figure
plotpv(X, Y)
hold on; 
plotpc(W', B)

% Gráfica de los errores según el número de épocas
figure
plot(1:epoch, num_errores)
title('Número de erores según la época')
xlabel('Época')
ylabel('Número de errores')

%% Números triangulares menores a 10

clear all;
clc;
close all;

% Los números triangulares menores a 10 son: 1, 3 y 6

uno = [0 0 0 0 1 1 0 0 0 1 1 1 1 1 1 0 0 0 0 1 0 0 0 0 1];
% 01100
% 00100
% 00100
% 00100
% 11111

dos = [1 0 0 0 1 1 0 0 1 1 1 0 1 0 1 1 1 0 0 1 1 0 0 0 1];
% 11111
% 00010
% 00100
% 01000
% 11111

tres = [1 0 1 0 1 1 0 1 0 1 1 0 1 0 1 1 0 1 0 1 1 1 1 1 1];
% 11111
% 00001
% 11111
% 00001
% 11111

cuatro = [1 1 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1 0 0 1 1 1 1 1];
% 10001
% 10001
% 11111
% 00001
% 00001

cinco = [1 1 1 0 1 1 0 1 0 1 1 0 1 0 1 1 0 1 0 1 1 0 1 1 1];
% 11111
% 10000
% 11111
% 00001
% 11111

seis = [1 0 1 1 1 1 0 1 0 1 1 0 1 0 1 1 0 1 0 1 1 1 1 1 1]; 
% 11111
% 00001
% 11111
% 10001
% 11111

siete = [1 0 1 0 0 1 0 1 0 0 1 0 1 0 0 1 1 1 1 1 0 0 1 0 0]; 
% 11110
% 00010
% 11111
% 00010
% 00010

ocho = [1 1 1 1 1 1 0 1 0 1 1 0 1 0 1 1 0 1 0 1 1 1 1 1 1]; 
% 11111
% 10001
% 11111
% 10001
% 11111

nueve = [1 1 1 0 0 1 0 1 0 0 1 0 1 0 0 1 0 1 0 0 1 1 1 1 1]; 
% 11111
% 10001
% 11111
% 00001
% 00001

X =[uno', dos', tres', cuatro', cinco', seis', siete', ocho', nueve'];
Y = [1, 0, 1, 0, 0, 1, 0, 0, 0]; 

% Código UNI: 20230014H
% Pesos y bias +/- 0.1
% Tasa de aprendizaje = 0.4

% Esquema y gráfico de la red
red = perceptron();
red = configure(red, X, Y);
view(red);

% Uso detallado del algorito paso a paso
alfa = 0.4; 
epoch = 1; 
error = 0; 
max_epochs = 10000;
errores_globales = [];

W = [0.1; 0.1; 0.1; 0.1; 0.1;
     0.1; 0.1; 0.1; 0.1; 0.1;
     0.1; 0.1; 0.1; 0.1; 0.1;
     0.1; 0.1; 0.1; 0.1; 0.1;
     0.1; 0.1; 0.1; 0.1; 0.1;];

B = 0.1; 

while true
    fprintf('Estamos en la época %d\n', epoch)
    errores = zeros(1, size(X,2));

    for i = 1:size(X, 2)
        % Selección del punto
        entrada = X(:, i);
        disp('Selección del nuevo punto')
        disp('El punto seleccionado es: ')
        disp(entrada')

        % Calcular la salida lineal
        linear = W' * entrada + B;
        salida = hardlim(linear);
        fprintf('La salida obtenida es: %d\n', salida)
        fprintf('La salida esperada es: %d\n', Y(i))
    
        % Calcular el error
        error = salida - Y(i);
        fprintf('Por lo tanto, el error es de: %d\n', error)

        if abs(error) == 1
            errores(i) = 1;
            % Actualización de pesos y bias
            W = W - alfa * error * entrada;
            B = B - alfa * error;
           
            disp('Los nuevos pesos son: ')
            disp(W)
            disp('Los nuevos bias son: ')
            disp(B)
        else
            disp('Entonces los pesos y bias no se actualizan')
        end

    end
    % Sumamos una época
    epoch = epoch + 1;

    % Almacenamos el número de errores en esta época
    errores_globales = [errores_globales, sum(errores)];
    
    % Criterio de parada
    if sum(errores) == 0
        fprintf('Ya no se detectaron errores, terminando el algoritmo...\n')
        break
    end
end

fprintf('Entrenamiento terminado!\n')

% Numero de épocas de entrenamiento
fprintf('La red se entrenó en: %d épocas\n', epoch-1)

% valores finales de W y B
fprintf('Los pesos finales encontrados son los siguientes: \n')
disp(W)
fprintf('Los bias finales encontrados son los siguientes: \n')
disp(B)

% Gráfica de evolución del número de errores
figure
plot(1:epoch-1, errores_globales')
title('Número de errores en función de las épocas')
xlabel('Época')
ylabel('Número de errores')

% Verificación de la red entrenada
salida = hardlim(W' * X + B);
fprintf('La salida esperada es \n')
disp(Y)
fprintf('La salida obtenida es \n')
disp(salida)

%% Las vocales de las 10 primeras letras del abecedario
clear all;
close all;
clc;

A = [1 1 1 1 1 1 0 1 0 0 1 0 1 0 0 1 0 1 0 0 1 0 1 0 0 1 0 1 0 0 1 1 1 1 1];

% 1111111
% 1000001
% 1111111
% 1000001
% 1000001

B = [1 1 1 1 1 1 0 1 0 1 1 0 1 0 1 1 0 1 0 1 1 0 1 0 1 1 0 1 0 1 1 1 1 1 1]; 
% 1111111
% 1000001
% 1111111
% 1000001
% 1111111

C = [1 1 1 1 1 1 0 0 0 1 1 0 0 0 1 1 0 0 0 1 1 0 0 0 1 1 0 0 0 1 1 0 0 0 1]; 
% 1111111
% 1000000
% 1000000
% 1000000
% 1111111

D = [1 1 1 1 1 1 0 0 0 1 1 0 0 0 1 1 0 0 0 1 1 0 0 0 1 1 0 0 0 1 0 1 1 0 0]; 
% 1111110
% 1000001
% 1000001
% 1000000
% 1111110

E = [1 1 1 1 1 1 0 1 0 1 1 0 1 0 1 1 0 1 0 1 1 0 1 0 1 1 0 1 0 1 1 0 1 0 1]; 
% 1111111
% 1000000
% 1111111
% 1000000
% 1111111

F = [1 1 1 1 1 1 0 1 0 0 1 0 1 0 0 1 0 1 0 0 1 0 1 0 0 1 0 1 0 0 1 0 1 0 0];
% 1111111
% 1000000
% 1111111
% 1000000
% 1000000

G = [1 1 1 1 1 1 0 1 0 1 1 0 1 0 1 1 0 1 0 1 1 0 1 0 1 1 0 1 0 1 1 0 1 1 1]; 
% 1111111
% 1000000
% 1111111
% 1000001
% 1111111

H = [1 1 1 1 1 0 0 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 0 1 0 1 1 1 1 1]; 
% 1000001
% 1000001
% 1111111
% 1000001
% 1000001

I = [1 0 0 0 1 1 0 0 0 1 1 0 0 0 1 1 1 1 1 1 1 0 0 0 1 1 0 0 0 1 1 0 0 0 1]; 
% 1111111
% 0001000
% 0001000
% 0001000
% 1111111

J = [1 0 0 0 1 1 0 0 0 1 1 0 0 0 1 1 1 1 1 1 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0]; 
% 1111111
% 0001000
% 0001000
% 0001000
% 1111000

X = [A', B' , C', D', E', F', G', H', I', J']; 
Y = [1, 0, 0, 0, 1, 0, 0, 0, 1, 0]; 

% Codigo UNI: 20230014H
% Pesos y bias = +/- 0.1
% alfa = 0.4

% Esquema y gráfico de la red
fprintf('La red tiene un esquema: 35-10 x 1 x 10\n')

% Gráfico de la red
red = perceptron(); 
red = configure(red, X, Y); 
view(red)

% Uso detallado del algoritmo paso a paso
epoch = 1;
errores_globales = [];
alfa = 0.4; 
W = 0.1 * ones(size(X, 1), 1);
bias = -0.1;

while true
    errores = zeros(1, size(X,2)); 
    fprintf('Se esta iniciando la época: %d\n', epoch);

    for i = 1:size(X,2)
        % Calculo de la salida
        linear = W' * X(:,i) + bias; 
        salida = hardlim(linear); 
        fprintf('La salida obtenida es de %d\n', salida)
        fprintf('La salida esperada es de %d\n', Y(i))

        % Calculo del error
        error = salida - Y(i); 
        fprintf('Por lo tanto, se tiene un error de %d\n', error)
       
        % Si el error es diferente de cero, se actualiza
        if error ~= 0
            fprintf('Actualizando pesos y bias...\n')
            errores(i) = 1; 
            W = W - alfa * error * X(:, i); 
            bias = bias - alfa * error; 
            fprintf('Los nuevos pesos son: \n')
            disp(W)
            fprintf('El nuevo bias es: %d\n', bias)
        else
            % Si el errores es igual a cero no se actualiza
            fprintf('Entonces no se actualiza\n')
        end
    end
    % Se aumenta una época
    epoch = epoch + 1; 

    % Se agregan los errores en esta época
    errores_globales = [errores_globales, sum(errores)]; 

    % Criterio de parada
    if sum(errores) == 0
        fprintf('No se encontraron errores en esta época, terminando el algoritmo...\n')
        break
    end
end

% Impresión de resultados
fprintf('Algoritmo terminado con éxito!\n')
fprintf('El algoritmo se entrenó en %d épocas\n', epoch-1)
fprintf('Los pesos finales encontrados son: \n')
disp(W)
fprintf('Los bias finales encontrados son: \n')
disp(bias);

% Gráfica de evolución del número de errores
figure()
plot(1:epoch-1, errores_globales)
title('Número de errores en función de las épocas')
xlabel('Época')
ylabel('Número de errores')

% Verificación de la red entrenada
salida = hardlim(W' * X + bias);
fprintf('Salida esperada\n')
disp(Y)
fprintf('Salida obtenida\n')
disp(salida)