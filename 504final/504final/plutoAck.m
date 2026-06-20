function [AckOut] = plutoAck(Fs, centerFreq, upsampleFactor, APADRC, DV_Addr)
    
    cbde = 0;
    mout = [0 0 0 0 1 1 1 1 0 0 0 0 1 1 1 1 0 0 0 0 1 1 1 1 0 0 0 0 1 1 1 1 0 0 0 0 1 1 1 1 0 0 0 0 1 1 1 1 ];
    %configure amd make ack bit
    cfgMac = wlanMACFrameConfig('FromDS',false, 'ToDS',true, ...
    'Address1', APADRC, 'Address2',DV_Addr, 'Address3',...
    'BEEFBEEFBEEF', 'FrameType','ACK');

    [Ack_Mpdu, Ack_Flen] = wlanMACFrame(cfgMac, OutputFormat='bits');

    tx = mainPlutoTrans(double(Ack_Mpdu), Fs, centerFreq, upsampleFactor, 40);

    mout = mainPlutoRcv(tx, Ack_Mpdu, Fs, centerFreq, ...
    upsampleFactor);

    [Ack, flen_ap, data_out] = mac_ds_rcv(DV_Addr, mout');

    AckOut = data_out;

end