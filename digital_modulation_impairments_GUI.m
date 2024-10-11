function digital_modulation_impairments_GUI
    
    fig = figure('Name', 'Digital Modulation Impairments', 'NumberTitle', 'off', ...
                 'Position', [100, 100, 600, 400]);

    uicontrol('Style', 'text', 'Position', [50, 800, 150, 25], 'String', 'Select Impairment:');
    impairmentMenu = uicontrol('Style', 'popupmenu', 'Position', [210, 800, 200, 25], ...
                               'String', {'Aliasing', 'Quantization Noise', 'Phase Noise', ...
                                          'Channel Noise', 'ISI',  ...
                                          'Symbol Timing Offset', 'Carrier Frequency Offset'}, ...
                               'Callback', @updatePlot);
    uicontrol('Style', 'text', 'Position', [50, 700, 150, 25], 'String', 'Adjust Frequency/Noise:');
    slider = uicontrol('Style', 'slider', 'Position', [210, 700, 200, 25], ...
                       'Min', 1, 'Max', 100, 'Value', 50, 'Callback', @updatePlot);
    sliderValueText = uicontrol('Style', 'text', 'Position', [420, 700, 50, 25], 'String', '50');
    
   
    ax = axes('Position', [0.1, 0.1, 0.8, 0.5]);
    updatePlot();
    function updatePlot(~, ~)
        
        val = get(impairmentMenu, 'Value');
        impairment = get(impairmentMenu, 'String');
        selectedImpairment = impairment{val};
        
        
        sliderValue = get(slider, 'Value');
        set(sliderValueText, 'String', num2str(round(sliderValue)));
        
        
        t = 0:0.001:1;
        signal = sin(2 * pi * 10 * t); 

        
        switch selectedImpairment
            case 'Aliasing'
                fs = sliderValue; 
                sampledSignal = signal(1:round(length(signal)/fs):end);
                plot(ax, t, signal, 'b', 'LineWidth', 1.5);
                hold on;
                stem(ax, t(1:round(length(signal)/fs):end), sampledSignal, 'r', 'LineWidth', 1.5);
                title(ax, 'Aliasing Effect');
                hold off;
                
            case 'Quantization Noise'
                levels = round(sliderValue);
                quantizedSignal = round(signal * levels) / levels;
                plot(ax, t, signal, 'b', t, quantizedSignal, 'r', 'LineWidth', 1.5);
                title(ax, 'Quantization Noise');
                
            case 'Phase Noise'
                phaseNoise = randn(1, length(signal)) * sliderValue / 100; 
                noisySignal = sin(2 * pi * 10 * t + phaseNoise);
                plot(ax, t, signal, 'b', t, noisySignal, 'r', 'LineWidth', 1.5);
                title(ax, 'Phase Noise');
                
            case 'Channel Noise'
                noise = randn(1, length(signal)) * sliderValue / 100; 
                noisySignal = signal + noise;
                plot(ax, t, signal, 'b', t, noisySignal, 'r', 'LineWidth', 1.5);
                title(ax, 'Channel Noise');
                
            case 'ISI'
                delay = round(sliderValue / 10); 
                isiSignal = signal + [zeros(1, delay), signal(1:end-delay)];
                plot(ax, t, signal, 'b', t, isiSignal, 'r', 'LineWidth', 1.5);
                title(ax, 'Inter-Symbol Interference (ISI)');
                
            case 'Multipath Fading'
                n = round(sliderValue / 10); 
                multipathSignal = signal; 
                for i = 1:n
                    delay = randi([1, length(signal)/10]); 
                    attenuation = 0.5 * rand; 
                    multipathSignal = multipathSignal + attenuation * [zeros(1, delay), signal(1:end-delay)];
                end
                plot(ax, t, signal, 'b', t, multipathSignal, 'r', 'LineWidth', 1.5);
                title(ax, sprintf('Multipath Fading with %d paths', n));
                
            case 'Symbol Timing Offset'
                offset = round(sliderValue / 10); 
                timingOffsetSignal = circshift(signal, [0, offset]);
                plot(ax, t, signal, 'b', t, timingOffsetSignal, 'r', 'LineWidth', 1.5);
                title(ax, 'Symbol Timing Offset');
                
            case 'Carrier Frequency Offset'
                freqOffset = sliderValue / 10; 
                offsetSignal = sin(2 * pi * (10 + freqOffset) * t);
                plot(ax, t, signal, 'b', t, offsetSignal, 'r', 'LineWidth', 1.5);
                title(ax, 'Carrier Frequency Offset');
        end
        
        xlabel(ax, 'Time (s)');
        ylabel(ax, 'Amplitude');
        legend(ax, 'Original Signal', 'Distorted Signal');
        grid(ax, 'on');
    end
end
