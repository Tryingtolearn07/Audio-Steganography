function length_msg = msg_len(binary_data)

    data = num2str(reshape(binary_data, [1,6]));
    
    data = erase(data," ");
    length_msg = bin2dec(data);

end

