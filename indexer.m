function [resultTFIDF, resultDFmap] = indexer()
    trainingFile = fopen('training.txt','r');
    df_map = containers.Map('KeyType','char','ValueType','int32');  
    tf_map = containers.Map('KeyType','char','ValueType','any');
    
    line = fgetl(trainingFile); %her line bir yorum
    line_count=1;  
    %positive.txt dosyas�ndan kelimeler line olarak al�n�yor.
    while ischar(line)
          %harf olmayan karakterleri at 
          %hepsini k���k harf haline getir
          %bo�luklara g�re ay�r.
          line = regexprep(line,'[^A-Za-z_������������]',' ');
          line=lower(line);
          line = strsplit(line);
          
          %line i�indeki kelimeler teker teker ele al�n�p uygun olanlar map
          %e ekleniyor.
          tmp = containers.Map('KeyType','char','ValueType','int32');
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
         
               %tf hesaplamak i�in tf say
                if(~tmp.isKey(word))
                    tmp(word) = 1;
                    if df_map.isKey(word)   % o ara df i de aradan ��karal�m
                        val = df_map(word);
                        df_map(word) = val + 1;
                    else    
                        df_map(word) = 1;
                    end   
                else
                    val = tmp(word);
                    tmp(word) = val + 1; 
                end    
          end
          
          %bu line da ge�en kelimeler keys in i�inde tf de�erleri ile
          %bulunuyor
          keys = tmp.keys;
          %keys in i�indeki herkelimenin tf ini 
          %ilgili kelime ve line
          %countuna g�re indexlenmi� tf de�erini yazarak tf_map'inde
          %g�ncelle
          for c = 1:tmp.length
             tf_cell = cell(1);
             word = char(keys(1,c));
             if(tf_map.isKey(word))
                 tf_cell = tf_map(word);
                 tf_val = tmp(word);
                 tf_cell{1,line_count} = tf_val;
                 tf_map(word) = tf_cell;
             else
                 tf_val = tmp(word);
                 tf_cell{1,line_count} = tf_val;
                 tf_map(word) = tf_cell;
             end
          end   
          
        line=fgetl(trainingFile);
        line_count=line_count+1;
    end
 
    
    %tf lerin yaz�laca�� bir cell tablosu olu�turuluyor.
    tf_cell = cell(1);
    keys = tf_map.keys();                           %keyler tf_map ten �ekildi
    for i=1:length(keys)    
        word  = char(keys(1,i));                    %her kelime ayr� ayr� al�n�yor.
        tf_cell{i,1} = word;                        %ve cellin 1. s�tununa yaz�l�yor
             tmp_cell = tf_map(char(word));         %ve ilgili kelimenin tf de�erlerini i�eren cell arrayi al�n�yor
             for j = 1 : length(tmp_cell)
                 if(~isempty(tmp_cell{1,j}))
                 tf = tmp_cell{1,j};                %tf de�erleri tf mapinden al�n�yor.
                 df = df_map(word);                 %df de�erleri df mapinden al�n�yor.
                 idf = double(double(tf) * log(double(line_count/df))); %idf hesaplan�yor
                 tf_cell{i,j+1} = idf;              %ve di�er s�tunlara idf de�erleri yaz�l�yor.
                 else
                 tf_cell{i,j+1} = 0;                %e�er tf de�eri bo� d�nm�� ise 0 yaz�lyor.
                 end
             end   
    end    
    fclose(trainingFile);
    resultTFIDF = tf_cell;
    resultDFmap = df_map;
end