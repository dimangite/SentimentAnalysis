%positive.txt ve negative.txt dosyalar�nda %70'i training olacak
%�ekilde training.txt dosyas� olu�turuluyor.
createTrainingSet();

%tfIdfTermCount fonksiyonu ile kelimelerin tf idf de�erleri ve sonraki
%fonksiyonlarda kullan�lacak de�erler hesaplan�yor.
[resultTFIDF, resultDFmap, resultDFpositive, resultDFnegative, resultTermCountInPos, resultTermCountInNeg, pos_word_count, neg_word_count] = tfIdfTermCount( );

%preprocessedTable foksiyonu ile kelimelerin tfidf de�erleri toplanarak bir
%sort i�lemi ger�ekle�tiriliyor. En b�y�k de�ere sahip 3000kelime al�narak
%de�ersiz kelimeler at�l�yor ve toplam kelime say�s� azalt�l�yor.
weightedTable = preprocessedTable(resultTFIDF);

%calculateIG fonksiyonu ile kelimelerin information gain de�erleri
%hesaplan�yor ve en ay�rt edici 500 kelime feature olarak se�iliyor.
IGTable = calculateIG(weightedTable, resultDFmap, resultDFpositive, resultDFnegative);

%calculateProbabilities fonksiyonu ile feature'larin hem pozitif hem
%negatif classlar i�in olas�l�klar� hesaplan�yor.
[posProbMap, negProbMap] = calculateProbabilities(IGTable, resultTermCountInPos, resultTermCountInNeg, pos_word_count, neg_word_count);

%positive.txt ve negative.txt dosyalar�nda %30'u testing olacak
%�ekilde testing.txt dosyas� olu�turuluyor.
createTestingSet();

%testing.txt dosyas�ndan al�nan yorumlar ile Naive Bayes ile olu�turdu�umuz
%classification methodu test ediliyor ve accuracy de�eri hesaplan�yor.
[resultTable, accuracy] = calculateNaiveBayes(posProbMap, negProbMap);
