
P = dir('*.mat');

for  m=1:length(P)

name=P(m).name
[pathstr, name, ext] = fileparts(name);

name


% This code gets the neural data, the eye data, and the time of the 66xy
% code (fixation off for gap tasks) and the 68xy code (target on for gap
% tasks).  The neural and eye data will be put in matrices where each row
% is a trial.  The time data will be put in two lists.
counter=1;
eyehoriz = [];
eyevert = [];
rasters = [];
nexttrial = 1;
time66xy = [];
time68xy = [];
allowbadtrials = 1;


neuron(1).name= name;
neuron(1).condition = 0.5;
neuron(1).fixtimes=[9999];
neuron(2).name= name;
neuron(2).condition = 1.0;
neuron(2).fixtimes=[9999];
neuron(3).name= name;
neuron(3).condition = 2.0;
neuron(3).fixtimes=[9999];
neuron(4).name= name;
neuron(4).condition = 3.0;
neuron(4).fixtimes=[9999];
neuron(5).name= name;
neuron(5).condition = 5.0;
neuron(5).fixtimes=[9999];
neuron(6).name= name;
neuron(6).condition = 10.0;
neuron(6).fixtimes=[9999];

array=cell(100,6);

for fill=1:6
  array{1,fill}=1;
    
end
for n=1:6

update=n;


trialcodes = [7210,7220,7240,7230,7250,7260];
 %endcodes = trialcodes + 600;
 %endcodes = [7612,7622,7642,7632,7652,7662];
endcodes = trialcodes+ 1;


structarrayindex = 2;

trial = rex_first_trial( name, allowbadtrials );
islast = (trial == 0);

while ~islast

%  Get all the trial data for the next valid trial.

[ecodes, codetimes, spkchan, spk, arate, horiz, vert] = rex_trial( name, trial );

if has_any_of( trialcodes(n), ecodes ) % for miss trials only. For hit trials change back to trialcodes(n), endcodes(n), otherwise

%  Add a new element to the structure array.



[sstarts, sends] = rex_trial_saccade_times( name, trial );
for i = n
f = [];
f = find( ecodes == trialcodes(i) );
if ~isempty( f )
startcodetime = codetimes( f(1) );

end;
f = [];
f = find( ecodes == endcodes( i ) );
   endcodetime=[];
if ~isempty( f )
 
    endcodetime = codetimes( f(1) );

end;
end;

for st = 1:length( sstarts )-1
    if ~isempty(endcodetime)
if (sstarts( st+1 ) < endcodetime ) && (sends(st) > startcodetime)
% This is a saccade we want.

sacduration = sends( st ) - sstarts( st );
fixduration = sstarts( st+1 ) - sends( st );


if fixduration ~=array{structarrayindex-1,update} 
array{structarrayindex,update}= fixduration;

structarrayindex = structarrayindex+1;

end


end;
    end
end;



end;


%  Move on to the next trial.

[trial, islast] = rex_next_trial( name, trial, allowbadtrials );

end;

if ~isempty(array)
neuron(update).fixtimes=array(:,update);
end
end


new_file=[name '_FA'];

save(new_file, 'neuron')



clear neuron

end


s = sprintf( 'Total trials:  %d, mean fixation off time: %d, mean target on time: %d.', ...
nexttrial, floor( mean( time66xy ) ), floor( mean( time68xy ) ) );
disp( s );
