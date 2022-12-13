clc
clear all
close all
[y Fs]=audioread('steganography.wav');

audio_sig1= y(:,1);
Fs=length(audio_sig1);
y2=y(:,2);
asig1= audio_sig1/max(audio_sig1);
n=8; %considering 8 bit conversion

levels= 2^n;
delta = abs(max(asig1) - min(asig1)) / (levels-1);
q_level = min(asig1) : delta : max(asig1);
for i = 1 : length(asig1)
    for j = 1 : length(q_level)
        if asig1(i) >= q_level(j) && asig1(i) <=(q_level(j) + (delta/2))
            asig1_quant(i) = q_level(j);
            sigbin(i) = j-1 ;
        elseif asig1(i) > (q_level(j) + (delta/2)) && asig1(i)<= (q_level(j)+delta)
            asig1_quant(i) = q_level(j+1);
            sigbin(i)=j;
        end
    end
end
L1= length(asig1_quant) ;
L2= length(sigbin);
sigbin = reshape(sigbin,1,L2);
%making a column matrix of samples values
sigbin=de2bi(sigbin,8,'left-msb');
%making 8 bit binary of sample values

%% taking input a msg and converting it to binary
msg = input('Enter your message : ','s');
msgbin = zeros([length( msg ), n], 'int8');
for i = 1:length(msg)
msgbin(i,:) = text2bin(msg(i),n); %converting string message to binary
end

%% pattern matching
ptrn_mat=sigbin(1:2,:);
ptrn_mat_copy = reshape(ptrn_mat, [1, 2*n]);
ptrn_mat = num2str(reshape( ptrn_mat,1,2*n));
ptrn_mat = erase(ptrn_mat," ");
gen_bin_msg=[];
for i= 1:length(msg)
    temp=msgbin(i,:); 
    splited_char=zeros([n/2,2]);%alada kortesi per alphabet k 4 bhag e ,each has 2 bit
    k=1;
    for j=1:2:length(temp)-1
        splited_char(k,:)=temp(j:j+1);
        k=k+1;
    end % getting two bit 
    splited_char_index = zeros( [n/2, 1] );
    for i = 1:n/2
         temp=num2str(splited_char(i,:));
         temp=erase(temp," ");
         index=strfind(ptrn_mat, temp);% comparing 2 bit with pattern matrix
         splited_char_index(i)=index(1,1);
    end
    for i = 1:n/2
         temp = dec2bin( splited_char_index(i,1), 4 )-'0'; % converting to bin the ascii so 
         % minus the ascii of 0
         gen_bin_msg = [gen_bin_msg temp];
    end 
end
%% inserting the bits of msg in the audio
gen_binary=sigbin;
info_binary=de2bi(length(msg),6,'left-msb');
for i=1:length(info_binary)
    gen_binary(i+9,1)=info_binary(i);%for inserting at 6th column   
end
for i = 1:length(ptrn_mat)
    gen_binary(i+15,1) = ptrn_mat_copy(i);%inserting pattern matrix
end
for i = 1:length(gen_bin_msg)
    gen_binary(i+49,1) = gen_bin_msg(i); %inserting the msg
end
ind=bi2de(gen_binary,'left-msb');
steg_output = delta*(ind)+min(asig1)+(delta/2);
output_data(:,1)=steg_output;
output_data(:,2)=y2;
audiowrite('Output.wav',output_data,Fs)





