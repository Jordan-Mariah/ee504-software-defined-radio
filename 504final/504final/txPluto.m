function txPluto(txComplex, Fs, centerFreq, tx, snr)

    c = comm.ConstellationDiagram();

    %disp("Transmitting...");
    txComplex = awgn(txComplex, snr);
    tx.transmitRepeat(txComplex);
    pause(0.1);
    %release(tx);
end
