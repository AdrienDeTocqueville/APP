F = [ 32.70, 65.41, 130.81, 261.63, 523.25, 1046.50, 2093.00, 4186.01; %do
      34.65, 69.30, 138.59, 277.18, 554.37, 1108.73, 2217.46, 4434.92; %do#
      36.71, 73.42, 146.83, 293.66, 587.33, 1174.66, 2349.32, 4698.64; %re
      38.89, 77.78, 155.56, 311.13, 622.25, 1244.51, 2489.02, 4978.03; %re#
      41.20, 82.41, 164.81, 329.63, 659.26, 1318.51, 2637.02, 5274.04; %mi
      43.65, 87.31, 174.61, 349.23, 698.46, 1396.91, 2793.83, 5587.65; %fa
      46.25, 92.50, 185.00, 369.99, 739.99, 1479.98, 2959.96, 5919.91; %fa#
      49.00, 98.00, 196.00, 392.00, 783.99, 1567.98, 3135.96, 6271.93; %sol
      51.91, 103.83,207.65, 415.30, 830.61, 1661.22, 3322.44, 6644.88; %sol#
      55.00, 110.00,220.00, 440.00, 880.00, 1760.00, 3520.00, 7040.00]; %la

[nbNotes, nbOctaves] = size(F);

[y, Fe] = audioread("D:/Adrien/PROG/GitHub/APP/Chord2.wav"); Te = 1/Fe;

pas = 20e-3 * Fe;
FFTbin = Fe/pas;

seuilDB = 30;
seuil = power(10, seuilDB/20);

for note = 1:nbNotes
  for octave = 1:nbOctaves
    F(note, octave) = floor(F(note, octave) / FFTbin);
  end
end

enJeu = 0;

resultat = zeros(1, length(y));

for t = 1:pas:length(y)-pas
  
  yf = y(t:t+pas-1);
  Y = abs(fft(yf));
  
  enJeuFenetre = 0;
  
  for i = 1:pas
    if (Y(i) > seuil)
      resultat(t+i) = Y(i);
      
      enJeuFenetre = 1;
    end
  end
  
  if enJeuFenetre
    energies = zeros(1, nbNotes);

    for note = 1:nbNotes
      for octave = 1:nbOctaves
        freq = F(note, octave);
        
        energies(note) = energies(note) + Y(freq+1);
      end
    end
    
    energiesSorted = sort(energies, 'descend');
    res = energies == energiesSorted(1);
    [un, note1] = max(res);
    
    res = energies == energiesSorted(2);
    [un, note2] = max(res);
    
    res = energies == energiesSorted(3);
    [un, note3] = max(res);
    
    note1
    note2
    note3
    
  end

  if enJeu == 1 && enJeuFenetre == 0
    break;
  end
  
  enJeu = enJeuFenetre;
end

x = (0:length(y)-1)*Te;
plot(x, resultat);
