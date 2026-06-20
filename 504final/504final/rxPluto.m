function rxData = rxPluto(Fs, centerFreq)

    rx = sdrrx('Pluto');
    rx.CenterFrequency = centerFreq;
    rx.BasebandSampleRate = Fs;
    rx.SamplesPerFrame = 10000;
    rx.OutputDataType = 'double';
    %disp("Receiving...");
    rxData = rx();
    rxData = rxData / max(abs(rxData));  % Normalize
    release(rx);

    % figure;
    % plot(abs(rxData));
    % title('Received Signal Magnitude');
    % xlabel('Sample'); ylabel('|Amplitude|');
end
