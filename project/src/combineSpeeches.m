% Read the file with the speeches
fid1 = fopen('numberofspeeches.csv','r','n','UTF-8');
nbPersons = 1694;

names_speeches = cell(nbPersons, 1);
speeches_speeches = cell(nbPersons, 1);

tline = fgetl(fid1);

for i=1:nbPersons
    person_splitted = strsplit(tline,{';'});
    
    fullName = strcat(person_splitted{1, 1}, {' '}, person_splitted{1, 2});
    names_speeches{i, 1} = fullName{1};
    speeches_speeches{i, 1} = person_splitted{1, 3};

    tline = fgetl(fid1);
end

fclose(fid1);

% Read the file with the politicians
fid1 = fopen('ToEdataPoliticians_formatted.csv','r','n','UTF-8');
nbPersons = 125;

names = cell(nbPersons, 1);
year = cell(nbPersons, 1);
country = cell(nbPersons, 1);
university = cell(nbPersons, 1);

tline = fgetl(fid1);

for i=1:nbPersons
    person_splitted = strsplit(tline,{';'});
    
    names{i, 1} = person_splitted{1, 1};
    year{i, 1} = person_splitted{1, 2};
    country{i, 1} = person_splitted{1, 3};
    university{i, 1} = person_splitted{1, 4};

    tline = fgetl(fid1);
end

fclose(fid1);

% Get the speeches for the politicians
speeches = cell(nbPersons, 1);

% go over all the names of the politicians
for i=1:nbPersons
    name = names{i, 1};
    
    % find this name in the speeches file
    index = find(strcmp(names_speeches, name));
    
    % store the speech in the speeches file for the politician,
    % if the politician was not found, store 0
    if isempty(index) == 1
        speeches{i, 1} = '0';
        name
    else
        speeches{i, 1} = speeches_speeches{index, 1};
    end
end

% Combine everything into a file again
fid = fopen('ToEdataPoliticians_withSpeeches.csv', 'w','n','UTF-8') ;

for i=1:nbPersons
   fprintf(fid,'%s;%s;%s;%s;%s\n', names{i, 1}, year{i, 1}, country{i, 1}, university{i, 1}, speeches{i, 1});
end

fclose(fid);

