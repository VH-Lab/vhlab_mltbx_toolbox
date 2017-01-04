function spiketimes = spiketrain_sinusoidal(maxrate, frequency, phase, rate_offset, t_start, t_end, dt)
% SPIKETRAIN_SINUSOIDAL - Create a spike train with a sinusoidal rate
%
%  SPIKETIMES = SPIKETRAIN_SINUSOIDAL(MAXRATE, FREQUENCY,...
%      PHASE, RATE_OFFSET, T_START, T_END, DT)
%
%  On top of a background spike rate of RATE_OFFSET, create a
%  sinusoidal spike train with a maximum rate MAXRATE, 
%  sinusoidal frequency equal to FREQUENCY, with a phase of PHASE.
%  Time will start at T_START and end at T_END in steps of DT.
%  
%  SPIKETIMES will be the spike times generated by a poisson process.
%
%  Example:  Generate a sinusoidal spike train and verify the modulation
%  rate with fourier analysis.
%
%    dt = 0.001; t_start = 0; t_end = 50/4; % 50 cycles at 4Hz
%    %Generate a spike train with modulation rate of 4Hz and amplitude of 20Hz on
%    %a background of 50Hz rate
%    ST =spiketrain_sinusoidal(20,4,0,50,t_start,t_end,dt);
%    % convert back to bins
%    T = t_start:dt:t_end; % time bins
%    SC = spiketimes2bins(ST,T);
%    % convert spikes to be instantaneous rates
%    SCr = SC/dt;
%    [fc,freqs] = fouriercoeffs(SCr,dt);
%    figure;
%    subplot(2,1,1,'box','off');
%    plot(T(find(SC)),SC(find(SC)),'x');
%    xlabel('Time(s)');
%    ylabel('Spike');
%    subplot(2,1,2,'box','off');
%    plot(freqs, abs(fc));
%    xlabel('Frequency');
%    ylabel('Fourier magnitude');
%    A = axis; axis([0 10 A(3) A(4)]);

T = t_start:dt:t_end;
S = rate_offset + maxrate * sin(2*pi*frequency*T+phase);
SP = S*dt > rand(size(T)); % poisson rate process
spiketimes = T(find(SP));

