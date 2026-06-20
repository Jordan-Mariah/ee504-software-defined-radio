function [tx] = mainPlutoTrans(message, Fs, centerFreq, ...
    upsampleFactor, snr)
    
    %tx
    tx = sdrtx('Pluto');
    tx.CenterFrequency = centerFreq;
    tx.BasebandSampleRate = Fs;
    tx.Gain = 0;

    outTx = tx;

    % Encode message and build transmit frame
    [txComplex] = encodeMessage(message, upsampleFactor);

    % Transmit frame
    txPluto(txComplex, Fs, centerFreq, tx, snr);
end
