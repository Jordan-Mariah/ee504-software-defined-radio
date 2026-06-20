function computeBER(payloadBits, bestRxBits, bitErrors)
    ber = bitErrors / length(payloadBits);
    disp(['Bit Error Rate (BER): ', num2str(ber, '%.4e')]);

    figure;
    stem(payloadBits(1:50), 'b', 'filled'); hold on;
    stem(bestRxBits(1:50), 'r');
    legend('Transmitted', 'Received');
    xlabel('Bit Index'); ylabel('Bit Value');
    title('First 50 Payload Bits: Transmitted vs Received');
end
