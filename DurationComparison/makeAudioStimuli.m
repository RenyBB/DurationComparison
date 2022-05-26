function makeAudioStimuli

Fs         = 44100;
cliplength = 10;
time       = [0 : 1/Fs : cliplength]';
Hz         = [ 410 415 418 419 420 421 422 425 430  ];
for i = 1:numel(Hz); labels{i} = [num2str(Hz(i)) 'hz.wav'];end
ramp       = 100;

shock     = [ zeros(numel( 0:1/Fs:0.1),1); ...
              rand(numel([0:1/Fs:0.4]),1);...
              zeros(numel([0:1/Fs:0.1]),1) ];
audiowrite(['shock.wav'],shock,Fs);

blank     = zeros(numel(shock),1);
audiowrite(['blank.wav'],blank,Fs);

for i = 1:numel(Hz)
    out.tone{i}   = sin( 2*pi*time*Hz(i) );
    out.ramped{i} = GenerateEnvelope(Fs,out.tone{i},ramp,ramp);
    out.label{i}  = labels{i};
    audiowrite([labels{i}],out.ramped{i},Fs);
end

disp('done');

%% Two beeps - empty interval 

SamplingRate = 44100;
SoundFreq = 350;
NumChannels = 1;
% Generate a beep
BeepDuration = 0.04;
beep1 = MakeBeep(SoundFreq, BeepDuration, SamplingRate);

all_durations = [1.5:0.5:4];

for i = 1:length(all_durations)
IntervalDuration = all_durations(i);
InveralDuration_ms = IntervalDuration*1000;



blanksize = round((IntervalDuration*SamplingRate) - (BeepDuration*2*SamplingRate)); 
blank = zeros(1, blanksize); 
 


% Make stereo sound
beep1 = repmat(beep1, NumChannels, 1);

sound = [beep1 blank beep1];
audiowrite(['empty_' num2str(InveralDuration_ms) 'ms.wav'],sound,SamplingRate);
end

%% One beep continuous interval 
SamplingRate = 44100;
SoundFreq = 350;
NumChannels = 1;
all_durations = [1];

for i = 1:length(all_durations)
IntervalDuration = all_durations(i);
InveralDuration_ms = IntervalDuration*1000;

beep_continuous = MakeBeep(SoundFreq, IntervalDuration, SamplingRate);

% Make stereo sound
beep_continuous = repmat(beep_continuous, NumChannels, 1);

audiowrite(['continuous_' num2str(InveralDuration_ms) 'ms.wav'],beep_continuous,SamplingRate);

end

%% Rhytmic
SamplingRate = 44100;
SoundFreq = 350;
NumChannels = 1;
all_durations = [1.5:0.5:4];

hertz = 2; %4 and 5 
cycle_duration_s = 1/hertz;


BeepDuration = 0.04;
BeelDuration_ms = BeepDuration*1000;
beep1 = MakeBeep(SoundFreq, BeepDuration, SamplingRate);

blanksize = round((cycle_duration_s*SamplingRate) - (BeepDuration*SamplingRate));
blank = zeros(NumChannels, blanksize); 

for i = 1:length(all_durations)
    IntervalDuration = all_durations(i);
    InveralDuration_ms = IntervalDuration*1000;
    n_cycles_in_interval = IntervalDuration/cycle_duration_s;
    
    blank_beep_sequence_1rep = [blank, beep1];

    blank_beep_sequence_total_rep = repmat(blank_beep_sequence_1rep, 1, n_cycles_in_interval);
    
    complete_sound = [beep1, blank_beep_sequence_total_rep];
    
    audiowrite(['iso_' num2str(InveralDuration_ms) 'ms_' num2str(hertz) 'Hz.wav'],complete_sound,SamplingRate);
end

%% Unscructured 

SamplingRate = 44100;
SoundFreq = 350;
NumChannels = 1;
%all_durations = [1.5:0.5:4];
hertz = 5; %4 and 5 
cycle_duration_s = 1/hertz;
n_cycles = [3:1:16];
all_durations = n_cycles*cycle_duration_s;
all_durations'

BeepDuration = 0.04;
BeelDuration_ms = BeepDuration*1000;
beep1 = MakeBeep(SoundFreq, BeepDuration, SamplingRate);

blanksize = round((cycle_duration_s*SamplingRate) - (BeepDuration*SamplingRate));
blank = zeros(NumChannels, blanksize); 

minimum_blank_between_beeps_s = 0.05;
minimum_blanksize = round(minimum_blank_between_beeps_s*SamplingRate);

for i = 1:length(all_durations)
    clear sample_start_of_beep full_sound
    IntervalDuration = all_durations(i);
    InveralDuration_ms = IntervalDuration*1000;
    %n_cycles_in_interval =n_cycles(i); %IntervalDuration/cycle_duration_s;
    n_cycles_in_interval = IntervalDuration/cycle_duration_s;


    test = [blank, 1];
    rep_test = repmat(test, 1, n_cycles_in_interval);
    
    blank_beep_sequence_1rep = [blank, beep1];

    blank_beep_sequence_total_rep = repmat(blank_beep_sequence_1rep, 1, n_cycles_in_interval);
    
    complete_sound = [beep1, blank_beep_sequence_total_rep];

    end_of_blank = [];
j = 0;
all_zeros = find(blank_beep_sequence_total_rep == 0);
for k = 1:length(all_zeros)-1
    if all_zeros(k)+1 < all_zeros(k+1)
        j=j+1;
        end_of_blank(j) = all_zeros(k);
    end
end

start_of_blank = end_of_blank - blanksize;

for i = 1:length(end_of_blank)
sample_start_of_beep(i) =  randi([start_of_blank(i)+minimum_blanksize,end_of_blank(i)]); 
end


new_sound = zeros(NumChannels, length(complete_sound));

for i = 1: length(sample_start_of_beep)
new_sound(sample_start_of_beep(i):sample_start_of_beep(i)+length(beep1)-1) = beep1;
end 

full_sound = [beep1 new_sound beep1];

audiowrite(['anis_' num2str(InveralDuration_ms) 'ms_' num2str(n_cycles_in_interval) 'cycles_' num2str(hertz) 'Hz.wav'] , full_sound,SamplingRate);
end

