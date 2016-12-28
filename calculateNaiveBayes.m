function [ resultTable,accuracy,fscore,confusionMatrix ] = calculateNaiveBayes(posProbMap, negProbMap)
%Naive Bayes Classifier
%P(word | positive) = (word kelimesi positive yorumlarda toplam ka� kere ge�mi� + 1)/
%(Pozitifte toplam ka� kelime var + Train edilen yani calculate IG'den d�nen tabloda her biri farkl� toplam ka� tane kelime var (500))  
%testing.txt 1-219 aras� pozitif yorum var, 220den 438e kadar negatif yorum
resultTable=cell(1);
file = fopen('testing.txt');
line = fgetl(file);
line_count=1;
accuracy_count=0;
%tp (true positive) = ger�ekte pozitif ve pozitif tahmin edilmi�
tp=0;
%tn (true negative) = ger�ekte negatif ve negatif tahmin edilmi�
tn=0;
%fp (false positive) = ger�ekte negatif ama pozitif tahmin edilmi�
fp=0;
%fn (false negative) = ger�ekte pozitif ama negatif tahmin edilmi�
fn=0;
while ischar(line)
     %harf olmayan karakterleri at 
     %hepsini k���k harf haline getir
     %bo�luklara g�re ay�r.
     line = regexprep(line,'[^A-Za-z_������������]',' ');
     line=lower(line);
     line = strsplit(line);
     
     tmpPos = containers.Map('KeyType','char','ValueType','double');
     tmpNeg = containers.Map('KeyType','char','ValueType','double');
     
     for j=1:length(line)
            word = char(line(1,j));
            %3 harften k�sa kelimeleri dikkate alma
            if(length(word)<3)
                continue;
            end
            %kelimeleri ilk 5 harfine g�re stemming et
            if(length(word)>5)
                word = word(1:5);
            end

            %e�er test datas�ndan ald���m�z bir yorum i�inde ge�en herhangi bir kelime bir feature'a e�itse
            %o kelimenin pozitif ve negatif file'lar i�in olas�l�klar�n�
            %al�yoruz
            if posProbMap.isKey(word) || negProbMap.isKey(word)
                tmpPos(word)=posProbMap(word);
                tmpNeg(word)=negProbMap(word);
            %e�er bu kelimenin bir feature kar��l��� yok ise hem pozitif
            %hem negatif olas�l���n� 1 al�yoruz ��nk� 0 al�rsak birazdan
            %uygulayaca��m�z �arpma i�leminde sonu�lar 0 gelmesin
            else
                tmpPos(word)=1; %�arpma i�lemi sonucu 0 olmas�n diye 1 veriyoruz
                tmpNeg(word)=1;
            end
     end
     
     if line_count<220 %pozitif commentler i�in
        posKeys = tmpPos.keys;
        posResult = 1;
        negResult = 1;
        for a=1:length(tmpPos)
            posResult = posResult * tmpPos(char(posKeys(1,a)));
        end
        negKeys = tmpNeg.keys;
        for a=1:length(tmpNeg)
            negResult = negResult * tmpNeg(char(negKeys(1,a))); 
        end
        
        %e�er test dosyas�ndan ald���m�z bir yorum ger�ekte pozitif ise ve
        %�imdi Naive Bayes kullanarak ula�t���m�z sonu� da pozitif ise accuracy artt�r
        %o yorumun tahmin edilen class�n� 1(pozitif) yaz
        if posResult > negResult
            accuracy_count=accuracy_count+1;
            tp=tp+1;
            %tahmin edilen class pozitif ise 1, negatif ise 0
            resultTable{line_count,1}=1;
        else
            fn=fn+1;
            resultTable{line_count,1}=0;
        end
        
     else %negatif commentler i�in
        posKeys = tmpPos.keys; 
        posResult = 1;
        negResult = 1;
        for a=1:length(tmpPos)
            posResult = posResult * tmpPos(char(posKeys(1,a)));
        end
        negKeys = tmpNeg.keys;
        for a=1:length(tmpNeg)
            negResult = negResult * tmpNeg(char(negKeys(1,a))); 
        end
        
        if negResult > posResult
            accuracy_count=accuracy_count+1;
            tn=tn+1;
            resultTable{line_count,1}=0;
        else
            fp=fp+1;
            resultTable{line_count,1}=1;
        end
     end
     
     line=fgetl(file);
     line_count=line_count+1;
end
fclose(file);
accuracy = double((accuracy_count*100)/line_count);
precision = double(tp/(tp+fp));
recall = double(tp/(tp+fn));
fscore = double((2*(precision*recall))/(precision+recall));
confusionMatrix=cell(1);
confusionMatrix{2,1}='Actual Positive';
confusionMatrix{3,1}='Actual Negative';
confusionMatrix{1,2}='Predicted Positive';
confusionMatrix{1,3}='Predicted Negative';
confusionMatrix{2,2}=tp;
confusionMatrix{2,3}=fn;
confusionMatrix{3,2}=fp;
confusionMatrix{3,3}=tn;
end

