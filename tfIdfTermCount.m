function [resultTFIDF, resultDFmap, resultDFpositive, resultDFnegative, resultTermCountInPos, resultTermCountInNeg, pos_word_count, neg_word_count] = tfIdfTermCount( )
    training = fopen('training.txt','r');
    dfMap = containers.Map('KeyType','char','ValueType','int32');  
    tf_map = containers.Map('KeyType','char','ValueType','any');
    %IG hesaplerken kullan�lacak pozitif file i�in df
    df_positive = containers.Map('KeyType','char','ValueType','int32');
    %IG hesaplerken kullan�lacak negatif file i�in df
    df_negative = containers.Map('KeyType','char','ValueType','int32');
    %Probability hesaplerken kullan�lacak positive file i�indeki bir
    %kelimenin toplam ka� kere ge�ti�i
    termCountInPos_map = containers.Map('KeyType','char','ValueType','int32');
    termCountInNeg_map = containers.Map('KeyType','char','ValueType','int32');
    pos_word_count=0;
    neg_word_count=0;
    comment = fgetl(training);
    commentCount=1;  
    %createTrainingSet fonksiyonu �a�r�ld�ktan sonra olu�turulan training
    %file i�indeki her yorum tek tek i�leniyor.
    while ischar(comment)
          %n�merik karakterleri kald�r
          %her bir kelime aras�  noktalama i�aretlerini kald�r
          %bo�luk koy
          comment = regexprep(comment,'[^A-Za-z_������������]',' ');
          %t�m kelimeler k���k harfe d�n���yor
          comment=lower(comment);
          %Tokenization = bo�luklara g�re comment i�indeki her bir kelimeyi
          %ay�rd�k ve tekrar comment de�i�kenine atad�k
          comment = strsplit(comment);
 
          %comment i�indeki her bir kelime kontrol edilip commentWords
          %mapine insert ediliyor
          commentWords = containers.Map('KeyType','char','ValueType','int32');
          
          for i=1:length(comment)
               word = char(comment(1,i));
               %Stop Words ~ 3 harften k�sa kelimeler ele al�nm�yor.
               if(length(word)<3)
                   continue;
               end
               %Stemming = Fixed-Prefix n=5
               if(length(word)>5)
                   word = word(1:5);
               end    
         
               if(~commentWords.isKey(word))
                    commentWords(word) = 1;
                    
                    %comment i�indeki her bir kelimenin df de�erleri
                    %hesaplanarak dfMap'ine key value �eklinde ekleniyor.
                    if dfMap.isKey(word)
                        val = dfMap(word);
                        dfMap(word) = val + 1;
                    else    
                        dfMap(word) = 1;
                    end
                    
                    %her bir kelimenin positive class�na g�re df'ini
                    %hesapl�yoruz
                    %bu df de�eri df_positive'de tutuluyor.
                    %bu de�erler information gain hesaplarken yard�mc�
                    %olacak
                    if commentCount<512
                         pos_word_count=pos_word_count+1; %pozitif d�k�manda ge�en toplam kelime say�s�
                        
                        if df_positive.isKey(word)   % o ara df i de aradan ��karal�m
                            val = df_positive(word);
                            df_positive(word) = val + 1;
                        else    
                            df_positive(word) = 1;
                        end
                        
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        %bir kelimenin pozitif fileda toplam ka� kere
                        %ge�ti�i
                        if ~termCountInPos_map.isKey(word)
                            termCountInPos_map(word)=1;
                        else
                            val = termCountInPos_map(word);
                            termCountInPos_map(word)=val+1;
                        end
                        
                    %her bir kelimenin negative class�na g�re df'ini
                    %hesapl�yoruz
                    %bu df de�eri df_negative'de tutuluyor.
                    else
                        neg_word_count=neg_word_count+1; %negatif d�k�manda ge�en toplam kelime say�s�
                        
                        if df_negative.isKey(word)   % o ara df i de aradan ��karal�m
                        val = df_negative(word);
                        df_negative(word) = val + 1;
                        else    
                        df_negative(word) = 1;
                        end
                        
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        %bir kelimenin negatif fileda toplam ka� kere
                        %ge�ti�i
                        if ~termCountInNeg_map.isKey(word)
                            termCountInNeg_map(word)=1;
                        else
                            val = termCountInNeg_map(word);
                            termCountInNeg_map(word)=val+1;
                        end
                    end
                    
                %commentWords i�indeki wordlerin tf de�erleri hesaplan�yor.    
                else
                    val = commentWords(word);
                    commentWords(word) = val + 1; 
                end    
          end

          commentWordsKeys = commentWords.keys;
          for j = 1:commentWords.length
             tfTable = cell(1);
             word = char(commentWordsKeys(1,j));
             
             if(tf_map.isKey(word))
                 tfTable = tf_map(word);
                 tf = commentWords(word);
                 tfTable{1,commentCount} = tf;
                 tf_map(word) = tfTable;
             else
                 tf = commentWords(word);
                 tfTable{1,commentCount} = tf;
                 tf_map(word) = tfTable;
             end
             
          end   
          
        comment=fgetl(training);
        commentCount=commentCount+1;
    end
 
    %tfTable i�inde TF de�erleri bulunuyor.
    tfTable = cell(1);
    tfMapKeys = tf_map.keys();
    
    for i=1:length(tfMapKeys)    
         word  = char(tfMapKeys(1,i));
         tfTable{i,1} = word;
         
         %tempArray = wordun tf de�erlerini tutuyor
         tempArray = tf_map(char(word));     
         
         for j = 1 : length(tempArray)
             if(~isempty(tempArray{1,j}))
                tf = tempArray{1,j};                
                df = dfMap(word);
                tfIdf = double(double(tf) * log(double(commentCount/df))); 
                tfTable{i,j+1} = tfIdf;              
             else
                %tfIdf de�eri yoksa 0
                tfTable{i,j+1} = 0;
             end
         end   
    end 
    
    fclose(training);
    resultTermCountInPos = termCountInPos_map;
    resultTermCountInNeg = termCountInNeg_map;
    resultTFIDF = tfTable;
    resultDFmap = dfMap;
    resultDFpositive = df_positive;
    resultDFnegative = df_negative;
end

