%[mpdu, flen] = mac_ap_data(AP_Addr, DS_Addr)
%imports a file and generates a data frame
function [mpdu, flen] = mac_ap_data(AP_Addr, DV_Addr, txtfile)


Data_In = txtfile; %import text


cfgMac = wlanMACFrameConfig('FromDS',true, 'ToDS',false, ... %cfg mac
    'Address1', DV_Addr, 'Address2',AP_Addr, 'Address3',...
    'BEEFBEEFBEEF', 'FrameType','Data', ...
    'AckPolicy','Normal Ack/Implicit Block Ack Request');



binary_str = dec2hex(Data_In); 


%binary_str = (Data_In); 

[mpdu, flen] = wlanMACFrame(binary_str, cfgMac, ... %generate mpdu
    'OutputFormat','bits');
end

