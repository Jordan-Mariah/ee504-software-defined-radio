function [txComplex, payloadBits, preambleSymbols] = encodeMessage(message, upsampleFactor)
    
    payloadBits = message;
    preambleBits = repmat([1; 0], 32, 1);
    preambleSymbols = 2 * preambleBits - 1;
    payloadSymbols = 2 * payloadBits - 1;

    txSymbols = [preambleSymbols; payloadSymbols];
    txUpsampled = upsample(txSymbols, upsampleFactor);
    txUpsampled = txUpsampled / max(abs(txUpsampled));
    txComplex = complex(txUpsampled, zeros(size(txUpsampled)));

end
