function [ weightedTable ] = preprocessedTable(resultTFIDF)
weightedTable = resultTFIDF;

%her bir kelimenin tf-idf de�erleri toplam� weightedTable'in 1024. s�tununa
%yerle�tiriliyor.
for i=1:4956
   sum=0;
   for j=2:1023
        if(isempty(cell2mat(weightedTable(i,j))))
           continue;
        end
        sum=sum+cell2mat(weightedTable(i,j));
   end
  
   weightedTable(i,1024)=num2cell(sum);
end

%kelimeleri tf-idf de�erleri toplam� en b�y�kten en k����e s�rala
weightedTable = sortrows(weightedTable,-1024);

%ilk 3000'i al
weightedTable = weightedTable(1:3000,:);
end

