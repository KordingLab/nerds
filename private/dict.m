function y = dict(x, mode, N, gen_atom_freq)
%DICT mode 1: convolve x with template/gen_atom and 

if mode==1
    y = ifft((gen_atom_freq*sqrt(N)).*(fft(x(1:N)))) + dct(x(N+1:2*N));
elseif mode==2
    y = zeros(2*N,1);
    y(1:N) = ifft(conj(gen_atom_freq*sqrt(N)).*(fft(x)));
    y(N+1:2*N) = idct(x);
else
    error('Someone screwed up big time');
end

end

