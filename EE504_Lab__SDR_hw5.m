clear; clc; close all;

%% Parameters
Fs = 1000; % Fs(Hz)
FcOffset = 100;% Carrier frequency offset(Hz)
M = 4;% 4QAM
numSymbols = 5000;% Total num QAM
sps = 4;% Samples per symbol
rrcSpan = 4;% RRC span in symbols
rrcDelay = rrcSpan * sps / 2;% Group delay of RRC

% Transmitter
% Generate QAM symbols
data = randi([0 M-1], numSymbols, 1);
modSig = qammod(data, M, 'UnitAveragePower', true);

% Upsample/apply RRC filter
txSig = upsample(modSig, sps);
rrc = rcosdesign(0.35, rrcSpan, sps);
txSigFiltered = conv(txSig, rrc, 'same');

% Apply carrier freq. offset
t = (0:length(txSigFiltered)-1)' / Fs;
rxSig = txSigFiltered .* exp(1j*2*pi*FcOffset*t);

% dump RRC filter delay
rxSigTrimmed = rxSig(rrcDelay+1:end);

% Coarse Freq. Correction
% Full correctio of offset
rxCoarseCorrected = rxSigTrimmed .* exp(-1j*2*pi*FcOffset*t(1:length(rxSigTrimmed)));

% Downsample/normalize
rxDownsampled = rxSigTrimmed(1:sps:end);
rxDownsampled = rxDownsampled / rms(rxDownsampled);
coarseDownsampled = rxCoarseCorrected(1:sps:end);
coarseDownsampled = coarseDownsampled / rms(coarseDownsampled);

% original constellation
figure;
scatterplot(rxDownsampled);
title('Before Any Synch');

figure;
scatterplot(coarseDownsampled);
title('Constellation After Coarse Correction');

%separate signal with resi offset for phase tracking
residualOffset = 5;
rxTrackingCopy = rxSigTrimmed .* exp(-1j*2*pi*(FcOffset - residualOffset)*t(1:length(rxSigTrimmed)));

% Carrier Synch setup
carrierSync = comm.CarrierSynchronizer( ...
    'SamplesPerSymbol', sps, ...
    'DampingFactor', 0.707, ...
    'NormalizedLoopBandwidth', 0.02);

% Run carrier synch. for tracking-only
[~, phaseEst] = carrierSync(rxTrackingCopy);

% Phase converge
figure;
plot(unwrap(angle(phaseEst)));
xlabel('Samples');
ylabel('Phase Estimate (radians)');
title('Carrier Synchronizer Phase Convergence (Tracking Only)');
