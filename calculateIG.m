function [ output_args ] = calculateIG(  )
%P(positive)=1/2
%P(negative)=1/2
%P(word)=>from function
%~P(word)=1-P(word)
%P(positive|word)=word, ka� tane positive yorumda ge�mi� / word, toplam ka� tane yorumda ge�mi� (df) 
%P(positive|~word)=ka� tane positive yorumda bu word yok / 1-df
%P(negative|word)
%P(negative|~word)
weightedTable = preprocessedTable();



end

function result = P(word)
[x,dfMap]=indexer();
df_map = dfMap;

df_value = df_map(word); %verilen kelimenin df de�eri
N = 730; %toplam d�k say�s�

result = df_value/N;
end