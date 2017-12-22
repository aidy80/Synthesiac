%Synesthesiac - Image to Song Converter
%Sebastian Coates, Danielle Blelloch, Aidan Fike, Nico Avalle-Embree
%EN1 - Music and the Art of Engineering
%Prof. Hopwood
%

%Reset Memory
clear

%Constant Values
FILE_NAME = 'mario.png';
RED_INDEX = 1;
GREEN_INDEX = 2;
BLUE_INDEX = 3;
SCALE_CUTOFF = 122.5;
MIN_TEMPO = 45;
DIMINISHED = 'D';
MAJOR = 'M';
MINOR = 'm';
LOWEST_ROOT_NOTE = -24;
ROOT_NOTE_DIVISOR = 10;
MIN_FREQ_RANGE = 12;
FREQ_RANGE_DIVISOR = 21;
SAMPLE_RATE = 44100;%Frames per second
DURATION = 15;%Seconds
RC = .025; %.025; %Decay constant
AC = 2; %Attack constant

%Import file into 3D RGB Image Vector (width by height by RGB Values)
rgb_image = imread(FILE_NAME);

%Store size of vector (length of each dimension)
[image_width, image_height, num_colors] = size(rgb_image);

%Calculate reslution of image
resolution = image_width * image_height;

%Determine if image is grayscale (Only has 2 dimensions)
if (num_colors == 1)
    image_is_grayscale = true;
else
    image_is_grayscale = false;
end

%Calculate average red, green, and blue values
if (image_is_grayscale)
    average_red = average_value(rgb_image, RED_INDEX, image_width, image_height);
    average_green = average_red;
    average_blue = average_red;
else
    average_red = average_value(rgb_image, RED_INDEX, image_width, image_height);
    average_green = average_value(rgb_image, GREEN_INDEX, image_width, image_height);
    average_blue = average_value(rgb_image, BLUE_INDEX, image_width, image_height);
end

%Set tempo
tempo = MIN_TEMPO + 3*int16(average_red)/4;

%Determine Key
if (image_is_grayscale)
    key = DIMINISHED;
elseif (average_blue > SCALE_CUTOFF)
    key = MAJOR;
else
    key = MINOR;
end

%Determine frequency range (root note of key and number of notes)
root_note = LOWEST_ROOT_NOTE + int16(average_green/ROOT_NOTE_DIVISOR);
freq_range = MIN_FREQ_RANGE + int16(average_green/FREQ_RANGE_DIVISOR);
if (key == DIMINISHED)
    scale_relations = [1,2];
elseif (key == MAJOR)
    scale_relations = [2,2,1,2,2,2,1];
else
    scale_relations = [2,1,2,2,1,2,2];
end

%Create vector of note frequencies based on starting note, range, and scale
notes = choose_notes(root_note, freq_range, scale_relations);

%Calculate time of quarter notes / time per beat (In seconds)
time_per_quarter = 60/double(tempo);

%Generate note length vectors
whole_time = [0:1/SAMPLE_RATE:double(time_per_quarter)*4];
slow_triplet_time = [0:1/SAMPLE_RATE:double(time_per_quarter)*3];
half_time = [0:1/SAMPLE_RATE:double(time_per_quarter)*2];
quarter_time = [0:1/SAMPLE_RATE:double(time_per_quarter)];
eight_time = [0:1/SAMPLE_RATE:double(time_per_quarter)/2];
fast_triplet_time = [0:1/SAMPLE_RATE:double(time_per_quarter)/3];
sixteenth_time = [0:1/SAMPLE_RATE:double(time_per_quarter)/4];

%Create vector of note lengths to play
note_lengths = choose_lengths(tempo,DURATION);

%Assign note frequency to each note length
for i = 1:1:length(note_lengths)
    rando = round(rand(1)*freq_range);
    if (rando == 0)
        rando = 1;
    end
    note_selection(i) = rando;
end

%Create vector of concatenated notes to create melody
audio = 0;
for i = 1:1:length(note_lengths)
    whole_time = [0:1/SAMPLE_RATE:double(time_per_quarter)*4];
    slow_triplet_time = [0:1/SAMPLE_RATE:double(time_per_quarter)*3];
    half_time = [0:1/SAMPLE_RATE:double(time_per_quarter)*2];
    quarter_time = [0:1/SAMPLE_RATE:double(time_per_quarter)];
    eighth_time = [0:1/SAMPLE_RATE:double(time_per_quarter)/2];
    fast_triplet_time = [0:1/SAMPLE_RATE:double(time_per_quarter)/3];
    sixteenth_time = [0:1/SAMPLE_RATE:double(time_per_quarter)/4];
    
    if (note_lengths(i) == 1)
        sound = sin(2*pi*whole_time*notes(note_selection(i)));
        decay = exp(-whole_time/RC);
        attack = 1 - exp(-whole_time/AC);
        sound = sound.*attack;
        sound = sound.*decay;
        audio = [audio, sound];
    end
    
    if (note_lengths(i) == 1/3)
        sound = sin(2*pi*slow_triplet_time*notes(note_selection(i)));
        decay = exp(-slow_triplet_time/RC);
        attack = 1 - exp(-slow_triplet_time/AC);
        sound = sound.*attack;
        sound = sound.*decay;
        audio = [audio, sound];
    end
    
    if (note_lengths(i) == 1/2)
        sound = sin(2*pi*half_time*notes(note_selection(i)));
        decay = exp(-half_time/RC);
        attack = 1 - exp(-half_time/AC);
        sound = sound.*attack;
        sound = sound.*decay;
        audio = [audio, sound];
    end
    
    if (note_lengths(i) == 1/4)
        sound = sin(2*pi*quarter_time*notes(note_selection(i)));
        decay = exp(-quarter_time/RC);
        attack = 1 - exp(-quarter_time/AC);
        sound = sound.*attack;
        sound = sound.*decay;
        audio = [audio, sound];
    end
    
    if (note_lengths(i) == 1/8)
        sound = sin(2*pi*eighth_time*notes(note_selection(i)));
        decay = exp(-eighth_time/RC);
        attack = 1 - exp(-eighth_time/AC);
        sound = sound.*attack;
        sound = sound.*decay;
        audio = [audio, sound];
    end
    
    if (note_lengths(i) == 1/9)
        sound = sin(2*pi*fast_triplet_time*notes(note_selection(i)));
        decay = exp(-fast_triplet_time/RC);
        attack = 1 - exp(-fast_triplet_time/AC);
        sound = sound.*attack;
        sound = sound.*decay;
        audio = [audio, sound];
    end
    
     if (note_lengths(i) == 1/16)
        sound = sin(2*pi*sixteenth_time*notes(note_selection(i)));
        decay = exp(-sixteenth_time/RC);
        attack = 1 - exp(-sixteenth_time/AC);
        sound = sound.*attack;
        sound = sound.*decay;
        audio = [audio, sound];
    end
end

%Add distortion to sound
top_clip = 1 - (2^(-resolution/1000000));
for i = 1:length(audio)
if (audio(i) > top_clip)
        audio(i) = top_clip;
    end
end

bottom_clip = (2^(-resolution/1000000)) - 1;
for i = 1:length(audio)
if (audio(i) < bottom_clip)
        audio(i) = bottom_clip;
    end
end

%Adjust amplitude
audio = (1/top_clip)*audio;

%Play song
soundsc(audio, SAMPLE_RATE);

