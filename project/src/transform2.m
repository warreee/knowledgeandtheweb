% Read the file with the persons
fid1 = fopen('mergedDBpediaNobelNewUni_economist_or_scientist_Final.csv','r','n','UTF-8');
nbPersons = 10987;

names = cell(nbPersons, 1);
year = cell(nbPersons, 1);
country = cell(nbPersons, 1);
university = cell(nbPersons, 1);
category = cell(nbPersons, 1);
nobel = cell(nbPersons, 1);

tline = fgetl(fid1);

for i=1:nbPersons
    person_splitted = strsplit(tline,{';'});
    
    names{i, 1} = person_splitted{1, 1};
    year{i, 1} = person_splitted{1, 2};
    country{i, 1} = person_splitted{1, 3};
    university{i, 1} = person_splitted{1, 4};
    category{i, 1} = person_splitted{1, 5};
    nobel{i, 1} = person_splitted{1, 6};

    tline = fgetl(fid1);
end

fclose(fid1);

% ADJUST UNIVERSITIES
% first add a space before and after every university and set to lowercase
for i=1:nbPersons
    oldUniversity = university{i, 1};
    newUniversity = lower(strcat({' '},oldUniversity,{' '}));
    university{i, 1} = newUniversity{1};
end

% second remove everything in parentheses
expression = '\([^)]+\)';
replace = '';

for i=1:nbPersons
    oldUniversity = university{i, 1};
    newUniversity = regexprep(oldUniversity,expression,replace);
    university{i, 1} = newUniversity;
end

% next remove all punctuation
for i=1:nbPersons
    oldUniversity = university{i, 1};
    newUniversity = strrep(strrep(strrep(strrep(strrep(strrep(oldUniversity, ',', ''), '.', ''), '(', ''), ')', ''), '''', ''), '-', '');
    university{i, 1} = newUniversity;
end

% then remove the words university, college, state, of, the 
% and remove the white spaces before and after again
for i=1:nbPersons
    oldUniversity = university{i, 1};
    newUniversity = strrep(strrep(strrep(strrep(strrep(oldUniversity, ' university ', ' '), ' college ', ' '), ' state ', ' '), ' of ', ' '), ' the ', ' ');
    university{i, 1} = strtrim(newUniversity);
end

% lastly remove all the white spaces
for i=1:nbPersons
    oldUniversity = university{i, 1};
    newUniversity = strrep(oldUniversity, ' ', '');
    university{i, 1} = newUniversity;
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
fid = fopen('mergedDBpediaNobelNewUni_economist_or_scientist_Final_PARSED.csv', 'w','n','UTF-8') ;

for i=1:nbPersons
   fprintf(fid,'%s;%s;%s;%s;%s;%s\n', names{i, 1}, year{i, 1}, country{i, 1}, university{i, 1}, category{i, 1}, nobel{i, 1});
end

fclose(fid);
