function packetStart = detectPacket(rxData, preambleSymbols, upsampleFactor)
    preambleUpsampled = upsample(preambleSymbols, upsampleFactor);
    matchedFilter = flipud(conj(preambleUpsampled));
    corr = abs(conv(rxData, matchedFilter, 'valid'));
    [peakVal, packetStart] = max(corr);

    if peakVal < 0.3
        error('Preamble not detected — correlation peak too low.');
    end
    disp(['Packet start index (before timing search): ', num2str(packetStart)]);
end
