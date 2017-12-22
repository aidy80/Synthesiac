%Helper functions used in main.m
%
%
%Calculate average value of 2 dimensions in 3D array
function avg = average_value(vector, third_dimension, width, height)
    avg = 0.0;
    for i=1:1:width
        for j=1:1:height
            avg = avg + double(vector(i,j,third_dimension))/
                                                       double((width*height));
        end
    end
end

%Create vector with note frequencies in scale
function notes = choose_notes(root_note, freq_range, scale_relations)
    notes = zeros(1,freq_range);%Preallocate array size
    notes(1) = 440.00 * (double(2.0)^(double(root_note)/double(12.0)));
    scale_index = 1;
    for i=2:1:freq_range
        notes(i) = notes(i-1) * (double(2.0)^
                                (double(scale_relations(scale_index))
                                                            /double(12.0)));
        scale_index = scale_index +1;
        if (scale_index > length(scale_relations))
            scale_index = 1;
        end
    end
end

%Create a vector with different note lengths increasing
%in speed as the song continues
function note_length = choose_lengths(tempo, DURATION)
    tempo = double(tempo);
    note_length = [];
    sum_time = 0;
    note_length_index = 1;
    still_time = true;
    %create two different probability distributions - each sample has
    % a different probability value
    percent_quart = create_inv_y(tempo, DURATION);
    percent_whole = create_inv_x(tempo, DURATION);
    while(still_time)
        %create two random values between 0 and 1
        rand_num = rand;
        rand_num_2 = rand;
        
        length_note = 0;
        
        if(sum_time ~= 0)
            %count the new position where the probability should be read from
            percent_index = round(sum_time * 9 * 16) + 1;
        else
            percent_index = 1;
        end
        
        %each note - options are whole, half, third, quarter, eighth, 
        %triplet, sixteenth - has its own probability of getting played at
        %any one time. This following conditional flow implements that
        %likelihood and chooses a note length
        if(rand_num >= 0 && rand_num <= percent_quart(percent_index))
            if(rand_num_2 < .5)
                length_note = 1/4;
            else 
                length_note = 1/3;
            end
        elseif (rand_num > percent_quart(percent_index) && rand_num <= .5)
            if(rand_num_2 < .5) 
                length_note = 1/8;
            else
                length_note = 1/9;
            end
        elseif (rand_num > .5 && rand_num <= (.5 + 
                                                percent_whole(percent_index)))
            if(rand_num_2 < .5) 
                length_note = 1;
            else
                length_note = 1/2;
            end
        else
            length_note = 1/16;
        end
        
        %set the chosen note length to the next free position in the array
        note_length(note_length_index) = length_note;
        
        %add the note length to the amount of time played
        sum_time = sum_time + length_note;
        note_length_index = note_length_index + 1;
        
        %end this loop when the combined length of all the notes is longer
        %than the duration of the song
        if (sum_time > tempo * ((DURATION / 60)/4))
            still_time = false;
            note_length(note_length_index - 1) = 0;
        end
    end
end
 
%create a probability array from function 1/x. Has values at each sample 
%rate increment.
function inv_x = create_inv_x(tempo,DURATION)
    inv_x = zeros(1, int16(DURATION * tempo));
    position = 1; 
    for i = 1:1/(9*16):tempo * (DURATION / 60) + 1 
        inv_x(position) = 1/(2*i);
        position = position + 1;
    end
end

%create a probability array from function e^-x. Has values at each point a
%sample is taken digitally
function inv_y = create_inv_y(tempo, DURATION)
    inv_y = zeros(1, int16(DURATION * tempo));
    position = 1;
    for i = -ln(.5):1/(9*16):(tempo * (DURATION / 60) -ln(.5) + 1)
        inv_y(position) = 1 / exp(i);
        position = position + 1;
    end
end
 
%A function to calculate natural log (ln).
function nat_log = ln(x) 
    nat_log = log(x)/log(exp(1));
end
