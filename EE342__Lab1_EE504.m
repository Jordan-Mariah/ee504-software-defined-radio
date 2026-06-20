% pluto_tx_and_rx. m
% Transmit and Receive with single ADALM Pluto Example
% EE 504: Software-Defined Radio
% instructor : Steve Dunton

clear; close all; clc;

% configurePlutoRadio('AD9364'); % only need to configure once

fs = 20e6; % 20 MHz sampling frequency
sw = dsp.SineWave; % Create sine wave using dsp class
sw.Amplitude = 0.5; % set amplitude to 0.5
sw.Frequency = 1e6; % frequency set to 1 MHz
sw.ComplexOutput = true;
sw.SampleRate = fs;
sw.SamplesPerFrame = 10000;
txWaveform = sw();
 

plot(linspace(0, 1/sw.Frequency), txWaveform(1: 100));
title("Transmitted Signal"); xlabel("time (s)");

pause(5);
tx = sdrtx('Pluto'); 
tx.CenterFrequency = 475e6;
tx.BasebandSampleRate = fs / 2;
tx.Gain = 0;
 
rx = sdrrx('Pluto');
rx.SamplesPerFrame = 40000;
rx.CenterFrequency = 475e6;
rx.BasebandSampleRate = fs / 2;


sa = dsp.SpectrumAnalyzer;
sa.SampleRate = rx.BasebandSampleRate;

tx.transmitRepeat(txWaveform);

for k=1:1:1000 % collect frames
     sa(rx());
end
data = rx();

release(tx); % stop transmission
release(rx);
release(sa);