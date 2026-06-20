function [message_out] = mainPlutoComm(message)
    % PARAMETERS
    Fs = 1e6; % Sample rate
    centerFreq = 2.45e9; % Carrier frequency
    upsampleFactor = 2; % Oversampling
    
    %tx
    tx = sdrtx('Pluto');
    tx.CenterFrequency = centerFreq;
    tx.BasebandSampleRate = Fs;
    tx.Gain = 0;

    % Encode message and build transmit frame
    [txComplex, payloadBits, preambleSymbols] = encodeMessage(message, upsampleFactor);

    % Transmit frame
    txPluto(txComplex, Fs, centerFreq, tx);

    % Receive frame
    rxData = rxPluto(Fs, centerFreq);
    release(tx);

    % Detect packet start via matched filtering
    packetStart = detectPacket(rxData, preambleSymbols, upsampleFactor);
 
    % Demodulate payload and find best timing offset
    [bestRxBits, bestBitErrors] = demodulatePayload(rxData, payloadBits, preambleSymbols, packetStart, upsampleFactor);

    message_out = bestRxBits;

    % Compute BER and plot results
    computeBER(payloadBits, bestRxBits, bestBitErrors);
end
