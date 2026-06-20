function [bestRxBits, bestBitErrors] = demodulatePayload(rxData, payloadBits, preambleSymbols, packetStart, upsampleFactor)
    frameLength = length(payloadBits);
    bestBitErrors = Inf;
    bestRxBits = [];

    for offset = -1:1
        try
            rxPreamble = rxData(packetStart + offset : packetStart + offset + length(preambleSymbols)*upsampleFactor - 1);
            rxPreambleDown = downsample(rxPreamble, upsampleFactor);
            rxPhase = angle(mean(rxPreambleDown .* conj(preambleSymbols)));
            phaseCorrection = exp(-1j * rxPhase);

            payloadStart = packetStart + offset + length(preambleSymbols)*upsampleFactor;
            rxPayload = rxData(payloadStart : payloadStart + frameLength * upsampleFactor - 1);
            rxPayloadDown = downsample(rxPayload, upsampleFactor) * phaseCorrection;

            rxBits = real(rxPayloadDown) > 0;
            bitErrors = sum(rxBits ~= payloadBits);

            if bitErrors < bestBitErrors
                bestBitErrors = bitErrors;
                bestRxBits = rxBits;
            end
        catch
            continue;
        end
    end

    disp(['Bit errors at best timing offset: ', num2str(bestBitErrors)]);
end
