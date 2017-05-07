% FFT of quadrature examples.
% Implements a sampling of the IQ signals at fs2 with low-pass filtering at
% fs2/2.

i=sqrt(-1);
T = 20;

fs=1000; % Original signal frequency
fs2=100; % Mimic Sampling frequency
nsamples=T*fs; % Number of samples
nsamples2=T*fs2; % Number of samples

flo= 400; % Frequency of the Local Oscillator

f1=flo+2; % Frequency of the positive signal
f2=flo-1; % Frequency of the negative signal
f3 = flo+49;
f4 = flo-47;

t=(0:nsamples-1)/fs; % Time vector

LOi = cos(2*pi*flo*t);
LOq = sin(2*pi*flo*t);
sig = 1*cos(2*pi*f1*t);
sig = sig+cos(2*pi*f2*t);
sig = sig + 1*cos(2*pi*f3*t);
sig = sig +1*cos(2*pi*f4*t);
sig = sig*2;

I= sig.*LOi;% Real part (I)
Q= sig.*LOq;% Imaginary part (Q)
freqaxis=(0:nsamples-1)*fs/nsamples - fs/2; % Frequency axis with DC in the


[b,a]=butter(15, (fs2)/fs); % builds the butterworth filter
% filters the signal in both directions to minimize
% startup and ending transients
I=filtfilt(b,a,I);
Q=filtfilt(b,a,Q);



% fft(I+i*Q) is the FFT of a complex signal and produces the positive
% frequency only
clf
subplot(311)
%x1=I+i*Q;
x1 = sig;
y1=fft(x1);
y1=fftshift(y1);
plot(freqaxis,abs(y1))
hold on;
x1 = LOi;
y1=fft(x1);
y1=fftshift(y1);

plot(freqaxis,abs(y1),'--','LineWidth',2)
title('fft(signal) and fft(LO)')
legend('signal','LO');

grid on

% Resampling of the signal
t2=(0:nsamples2-1)/fs2; % Time vector
I = interp1(t,I,t2,'nearest');
Q = interp1(t,Q,t2,'nearest');
freqaxis=(0:nsamples2-1)*fs2/nsamples2 - fs2/2; % Frequency axis with DC in the


% fft(I) is the FFT of a real signal and produces the
% positive and negative frequencies but at half the
% amplitude
subplot(312)
x2=I;
y2=fft(x2);
y2=fftshift(y2);
plot(freqaxis,abs(y2),'.-')
hold on;
x2=Q;
y2=fft(x2);
y2=fftshift(y2);
plot(freqaxis,abs(y2),'--')
title('fft(I) and fft(Q)')
legend('I','Q');
grid on

% fft(I+i*Q + conj(I+i*Q)) is the FFT of a complex signal. It
% adds the negative frequencies with the complex conjugate.
subplot(313)
x3=I-i*Q;
y3=fft(x3);
y3=fftshift(y3);
plot(freqaxis,abs(y3))
title('fft(I-i*Q)')
grid on

xlabel('f [Hz]');
