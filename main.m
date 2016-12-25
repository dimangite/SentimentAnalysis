[tfidf,x]=indexer();
weightedTable = tfidf;

%her bir kelimenin tf-idf de�erleri toplam� weightedTable'in 732. s�tununa
%yerle�tiriliyor.
for i=1:4054
   sum=0;
   for j=2:731
        if(isempty(cell2mat(weightedTable(i,j))))
           continue;
        end
        sum=sum+cell2mat(weightedTable(i,j));
   end
  
   weightedTable(i,732)=num2cell(sum);
end

%kelimeleri tf-idf de�erleri toplam� en b�y�kten en k����e s�rala
weightedTable = sortrows(weightedTable,-732);

%ilk 2000'i al
weightedTable = weightedTable(1:2000,:);
