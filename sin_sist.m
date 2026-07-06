% 1. Carregamento e Preparação
u = [Sinais_Sistemas_Export.Massa_Total_Diaria, ...
     Sinais_Sistemas_Export.Temp_Refino_001, ...
     Sinais_Sistemas_Export.Temp_Refino_025];
y = Sinais_Sistemas_Export.Nivel;

% Objeto de identificação
dados_id = iddata(y, u, 1);
dados_id.InputName = {'Massa', 'Temp_R001', 'Temp_R025'};
dados_id.OutputName = 'Nivel_Vidro';

% Filtro Butterworth 
[b, a] = butter(2, 0.05); 
u_filt = filtfilt(b, a, u);
y_filt = filtfilt(b, a, y);

%(Frequência de corte reduzida para 0.05 para melhor suavização)

% Identificação MIMO
dados_limpos = detrend(iddata(y_filt, u_filt, 1), 0);
modelo = procest(dados_limpos, 'P1D');

% 2. Exibição Simplificada das Equações
fprintf('\n Equações do Modelo MIMO \n');
tf_modelo = tf(modelo); 

% Simplificamos a exibição convertendo para String (evita erro do pretty)
for i = 1:3
    fprintf('\nEntrada %d: %s\n', i, dados_id.InputName{i});
    disp(tf_modelo(1,i)); % Exibe a TF de forma direta e segura
end

% 3. Análise de Qualidade 
present(modelo);

% 4. Plotagem da Validação
compare(dados_limpos, modelo);
title('Validação do Modelo MIMO - VIVIX SNG-PG-D 97');