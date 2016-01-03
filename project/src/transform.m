% Read the file with the persons
fid1 = fopen('mergedDBpediaNobelNewUni.csv','r','n','UTF-8');
nbPersons = 10978;

names = cell(nbPersons, 1);
year = cell(nbPersons, 1);
country = cell(nbPersons, 1);
university = cell(nbPersons, 1);
nobel = cell(nbPersons, 1);

tline = fgetl(fid1);

for i=1:nbPersons
    person_splitted = strsplit(tline,{';'});
    
    names{i, 1} = person_splitted{1, 1};
    year{i, 1} = person_splitted{1, 2};
    country{i, 1} = person_splitted{1, 3};
    university{i, 1} = person_splitted{1, 4};
    nobel{i, 1} = person_splitted{1, 5};

    tline = fgetl(fid1);
end

fclose(fid1);

fid2 = fopen('rankings2.csv','r','n','UTF-8');
nbRankings = 499;

university_ranked = cell(nbRankings, 1);
ranking = cell(nbRankings, 1);

tline = fgetl(fid2);

for i=1:nbRankings
    ranking_splitted = strsplit(tline,{';'});
    
    university_ranked{i, 1} = ranking_splitted{1, 1};
    ranking{i, 1} = ranking_splitted{1, 2}; 

    tline = fgetl(fid2);
end

fclose(fid2);

% ADJUST UNIVERSITIES
% first add a space before and after every university and set to lowercase
for i=1:nbPersons
    oldUniversity = university{i, 1};
    newUniversity = lower(strcat({' '},oldUniversity,{' '}));
    university{i, 1} = newUniversity{1};
end

for i=1:nbRankings
    oldUniversity_ranked = university_ranked{i, 1};
    newUniversity_ranked = lower(strcat({' '},oldUniversity_ranked,{' '}));
    university_ranked{i, 1} = newUniversity_ranked{1};
end

% second remove everything in parentheses
expression = '\([^)]+\)';
replace = '';

for i=1:nbPersons
    oldUniversity = university{i, 1};
    newUniversity = regexprep(oldUniversity,expression,replace);
    university{i, 1} = newUniversity;
end

for i=1:nbRankings
    oldUniversity_ranked = university_ranked{i, 1};
    newUniversity_ranked = regexprep(oldUniversity_ranked,expression,replace);
    university_ranked{i, 1} = newUniversity_ranked;
end

% next remove all punctuation
for i=1:nbPersons
    oldUniversity = university{i, 1};
    newUniversity = strrep(strrep(strrep(strrep(strrep(strrep(oldUniversity, ',', ''), '.', ''), '(', ''), ')', ''), '''', ''), '-', '');
    university{i, 1} = newUniversity;
end

for i=1:nbRankings
    oldUniversity_ranked = university_ranked{i, 1};
    newUniversity_ranked = strrep(strrep(strrep(strrep(strrep(strrep(oldUniversity_ranked, ',', ''), '.', ''), '(', ''), ')', ''), '''', ''), '-', '');
    university_ranked{i, 1} = newUniversity_ranked;
end

% then remove the words university, college, state, of, the 
% and remove the white spaces before and after again
for i=1:nbPersons
    oldUniversity = university{i, 1};
    newUniversity = strrep(strrep(strrep(strrep(strrep(oldUniversity, ' university ', ' '), ' college ', ' '), ' state ', ' '), ' of ', ' '), ' the ', ' ');
    university{i, 1} = strtrim(newUniversity);
end

for i=1:nbRankings
    oldUniversity_ranked = university_ranked{i, 1};
    newUniversity_ranked = strrep(strrep(strrep(strrep(strrep(oldUniversity_ranked, ' university ', ' '), ' college ', ' '), ' state ', ' '), ' of ', ' '), ' the ', ' ');
    university_ranked{i, 1} = strtrim(newUniversity_ranked);
end

% lastly remove all the white spaces
for i=1:nbPersons
    oldUniversity = university{i, 1};
    newUniversity = strrep(oldUniversity, ' ', '');
    university{i, 1} = newUniversity;
end

for i=1:nbRankings
    oldUniversity_ranked = university_ranked{i, 1};
    newUniversity_ranked = strrep(oldUniversity_ranked, ' ', '');
    university_ranked{i, 1} = newUniversity_ranked;
end

% ADJUST COUNTRIES
% set to lowercase
for i=1:nbPersons
    oldCountry = country{i, 1};
    newCountry = lower(oldCountry);
    country{i, 1} = newCountry;
end

% second remove everything in parentheses and remove the white spaces before and after
expression = '\([^)]+\)';
replace = '';

for i=1:nbPersons
    oldCountry = country{i, 1};
    newCountry = regexprep(oldCountry,expression,replace);
    country{i, 1} = strtrim(newCountry);
end

% Write everything to file again
fid = fopen('mergedDBpediaNobelNewUni_Final.csv', 'w','n','UTF-8') ;

for i=1:nbPersons
   fprintf(fid,'%s;%s;%s;%s;%s\n', names{i, 1}, year{i, 1}, country{i, 1}, university{i, 1}, nobel{i, 1});
end

fclose(fid);

fid = fopen('rankings_Final.csv', 'w','n','UTF-8') ;

for i=1:nbRankings
   fprintf(fid,'%s;%s\n', university_ranked{i, 1}, ranking{i, 1});
end

fclose(fid);
