clc
clear all
close all

%% Getting back the message 
[y rec_Fs]=audioread('Output.wav');

steg_audio_sig1= y(:,1);
rec_Fs=length(steg_audio_sig1);
steg_asig1= steg_audio_sig1/max(steg_audio_sig1);
n=8; %considering 8 bit conversion

levels= 2^n;
delta = abs(max(steg_asig1) - min(steg_asig1)) / (levels-1);
q_level = min(steg_asig1) : delta : max(steg_asig1);
for i = 1 : length(steg_asig1)
    for j = 1 : length(q_level)
        if steg_asig1(i) >= q_level(j) && steg_asig1(i) <=(q_level(j) + (delta/2))
            asig1_quant(i) = q_level(j);
            rec_sigbin(i) = j-1 ;
        elseif steg_asig1(i) > (q_level(j) + (delta/2)) && steg_asig1(i)<= (q_level(j)+delta)
            asig1_quant(i) = q_level(j+1);
            rec_sigbin(i)=j;
        end
    end
end
L1= length(asig1_quant) ;
L2= length(rec_sigbin);
rec_sigbin = reshape(rec_sigbin, [1,L2]);
%making a column matrix of samples values
rec_sigbin=de2bi(rec_sigbin,8,'left-msb');
pos = 1;
message_len = rec_sigbin(10:15, pos);
message_length = msg_len(message_len);

pattern_matrix = rec_sigbin(16:16+(n*2)-1, pos);
pattern_matrix = num2str(reshape( pattern_matrix,[1,2*n]));
pattern_matrix = erase(pattern_matrix," ");
%% Taking message bits
received_bin = rec_sigbin(50:50+(n*2*(message_length)-1), pos);
%% pattern matching
characters = char(zeros([message_length,1]));
%ei m lagbe amr msg er every char characters matrix e indexing er jonno
m = 1;
for i = 1:2*n:length(received_bin)
    temp = received_bin(i:i+(2*n)-1,1); %jei binary paisi tar majhe 2*n sonkok nicchi

%karon n bit hole akta char 2*n e
%convert hoy.
%temp
    split_temp = zeros([(2*n/4),4]); % jei 2*n nisi oigulare akhn 4 by 4 e vangte hobe
    k = 1;
    for j = 1:4:length(temp)
        split_temp(k, :) = temp(j:j+3,1); %2*n ke venge split temp e rakhtsi
        k=k+1;
    end
    indexing = zeros([(2*n/4),1]);
%akta row & 4 ta column theke 1ta num/index generate korbo oi index ke pore pattern e khujte hobe
    k = 1;
    for i = 1:(n/2)
%ekhane oi 4 ta value ke merge kortesi jeno bin2text value te
%nite pari pore
        x = split_temp(i,:);
        x = num2str(reshape( x,[1,4]));
        x = erase(x," ");
        indexing(k,:) = string(x);
        k = k+1;
    end
%ekhane je value gula paisi divide kore oigula ke dec e nitesi
    index_dec = zeros([4,1]);
    for i = 1:(n/2)
        index_dec(i) = bin2dec(string(indexing(i)));
    end
%retriving original binary
%ekhane oi decimal gulake pattern er sathe match kore original binary
%banaitesi
%ei prapto value gula te asole oi pattern matrix er index khujbo



















%oi index e corresponding 2 ta bit nibo









    original_binary = strings([(2*n/4),1]);
    for i = 1:(n/2)
        k=(index_dec(i));
        original_binary(i,1) =string(pattern_matrix(1,k:k+1));
        
        
    end
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
%index theke khuje sb original msg er binary original_binary vector e niye nilam
%ei vector to (n/4)by1 mane row vector
%eke ak row te ene msg retrive korte hobe
    original_binray = reshape(original_binary, [1, (n/2)] );
    final = strings(); %ekhon amader bin2text kintu string ney
%so akta char ber hobe original_binary vector theke
%oi akta char rakhar jonno final string nilam
    for i=1:(n/2)
    final = strcat(final, original_binary(i)) ; %final e oi original_binary binary er

%every binary jora ditesi
%akta single string
%bananor jonno cz
%original_binary er kintu
%vector
    end
    characters(m,1) = bin2text(char(final)); %oi string theke akhon akta char pelar
    m = m+1;
end
original_message = strings(); % pura msg aksathe dekhate akta string nilam
%akhon every char aksathe jora dibo
for i = 1:length(characters)
original_message = strcat(original_message, characters(i)) ;
end
% origianl msg e final
%jonno characters name arekta single matrix e rakhlam
Encrypted_message = reshape(characters, [1,length(characters)])
