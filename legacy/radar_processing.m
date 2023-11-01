clear
clc

% Figures taken from AWR294x Datasheet 7.8
fs = 200e9;
IR_Bandwidth = 5e9;
IR_StartFreq = 76e9;
IR_PulseTime = 40e-6;
IR_PRF = 1/(IR_PulseTime); % Pulse repetition frequency
IR_Waveform = phased.LinearFMWaveform('SampleRate',fs,'PulseWidth',IR_PulseTime,'PRF',IR_PRF, ...
    'SweepBandwidth',IR_Bandwidth,'FrequencyOffset',IR_StartFreq);

% wave = IR_Waveform();

% figure
% nsamp = size(wave,1);
% t = [0:(nsamp-1)]/fs;
% plot(t*1e6,real(wave))
% xlabel('Time (us)')
% ylabel('Amplitude')
% 
% figure
% nfft = 2^nextpow2(nsamp);
% Z = fft(wave,nfft);
% fr = [0:(nfft/2-1)]/nfft*fs;
% plot(fr/1e9, abs(Z(1:nfft/2)))
% xlabel('Frequency (GHz)')
% ylabel('Amplitude')
% grid

% Figures taken from AWR294x Datasheet 7.8
TX_Power = 13.5; %dBm
Transmitter = phased.Transmitter('PeakPower',10^((TX_Power-30)/10));

TX_Array_Element = phased.IsotropicAntennaElement;
TransmitAntenna = phased.Radiator('Sensor', TX_Array_Element);

% Add receive antenna
RX_Array_Element = phased.IsotropicAntennaElement;
ReceiveAntenna = phased.Collector('Sensor', RX_Array_Element);

% Figures taken from AWR294x Datasheet 7.8
RX_Gain = 44; %dB
RX_NoiseFigure = 12; %dB
RX_SampleRate = fs;
Receiver = phased.ReceiverPreamp('Gain',RX_Gain,'NoiseFigure',RX_NoiseFigure,'SampleRate',RX_SampleRate);

radarTrans = radarTransceiver('Waveform',IR_Waveform,'Transmitter',Transmitter, ...
    'TransmitAntenna',TransmitAntenna, 'ReceiveAntenna',ReceiveAntenna, 'Receiver',Receiver,...
    'TimeOutputPort',true);

% Radar target
target.Position = [0 5e3 0];
target.Velocity = [0 0 0];

[sig, tgrid] = radarTrans(target, 0);

% plot(tgrid*1e6, abs(sig))
% xlabel('Time (us)')
% ylabel('Magnitude')

% nfft1 = 32;
% nov = floor(0.5*nfft1);
% spectrogram(sig, hamming(nfft1), nov, nfft1*4, fs, 'yaxis', 'centered');

wave = IR_Waveform();
nfft1 = 32;
nov = floor(0.5*nfft1);
spectrogram(wave, hamming(nfft1), nov, nfft1*4, fs, 'yaxis', 'centered');