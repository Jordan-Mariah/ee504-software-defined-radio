function [message_out, rxData] = mainPlutoRcv(tx, ber_samp, Fs, centerFreq, ...
    upsampleFactor)
    

    preambleBits = repmat([1; 0], 32, 1);
    preambleSymbols = 2 * preambleBits - 1;
    

    % Receive frame
    rxData = rxPluto(Fs, centerFreq);
    release(tx);

    % Detect packet start via matched filtering
    packetStart = detectPacket(rxData, preambleSymbols, upsampleFactor);
 
    % Demodulate payload and find best timing offset
    [bestRxBits, bestBitErrors] = demodulatePayload(rxData, ber_samp, preambleSymbols, packetStart, upsampleFactor);

    message_out = bestRxBits;

    % Compute BER and plot results
    %computeBER(ber_samp, bestRxBits, bestBitErrors);
end
