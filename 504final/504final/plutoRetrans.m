function [data_out] = plutoRetrans(message_in, AP_Addr, DV_Addr, Fs, centerFreq, ...
            upsampleFactor)

        MajRulesR = 1;
        MajArrayR = [];

        while (MajRulesR <= 4)
        [ap_mpdu, ap_flen] = mac_ap_data(AP_Addr, DV_Addr, message_in);
        frameLength = ap_flen*8;
        
        message = double(ap_mpdu);  % MAC
 

        [tx] = mainPlutoTrans(message, Fs, centerFreq, ...
            upsampleFactor, 9);
        
        mout = mainPlutoRcv(tx, message, Fs, centerFreq, ...
            upsampleFactor);
        
        MajArray(1:length(mout), MajRulesR) = mout;
        
        MajRulesR = MajRulesR + 1;
        end

        for i = 1:(height(MajArray))
            mout(i, 1) = mode(MajArray(i, 1:3));
        end
            MajRules = 1;
        

            [Ack, flen_ap, data_out] = mac_ds_rcv(DV_Addr, mout');

            Retrans_Char_RCV = data_out
            end