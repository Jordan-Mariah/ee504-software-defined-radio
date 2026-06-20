%[mpdu, flen, data_out] = mac_ds_rcv(AP_Addr, DS_Addr, mpdu)
%demodulates data on one end and sends an ack frame to AP
function [Ack_Mpdu, Ack_Flen, data_out, AP_Addr] = mac_ds_rcv(DV_Addr, mpdu_in)

%decode packet
[rxFrameCfg, rxMSDU, status] = wlanMPDUDecode(double(mpdu_in), DataFormat='bits');

AP_Addr = rxFrameCfg.Address2;
%AP_Addr = rxMSDU.
if status ~= 'Success' 
    Ack_Mpdu = rxFrameCfg.FrameType;
    Ack_Flen = 0;
    data_out = status;
else
    if rxFrameCfg.FrameType(1:3) ~= 'ACK'
    data_out = char(hex2dec(rxMSDU{1,1}))';
    else
    data_out = "ACK";
    end

    Ack_Mpdu = 0;
    Ack_Flen = 0;
%disp(['Status of the MPDU decoding: ' char(status)])



end
