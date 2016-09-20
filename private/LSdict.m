function out = LSdict(x,mode,N,diagonal)

if mode==1
    out = diagonal.*(1/sqrt(N)*fft(x));
elseif mode==2
    out = sqrt(N)*ifft(conj(diagonal).*x);
else
    error('Someone screwed up big time');
end

end