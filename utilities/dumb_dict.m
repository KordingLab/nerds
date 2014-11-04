function y = dumb_dict(x, mode, N, gen_atom_freq)

if mode==1
    y = ifft((gen_atom_freq*sqrt(N)).*(fft(x)));
elseif mode==2
    y = ifft(conj(gen_atom_freq*sqrt(N)).*(fft(x)));
else
    error('Someone screwed up big time');
end

end

