function [A,D,E] =  ProcessMedPC(filename)


        fileID = fopen(filename,'r');
        
        %READ IN EVERY LETTER THAT"S IMPORTANT
        C = fscanf(fileID,'%s');
        tmp = strsplit(C,'A:');
        Intro = tmp{1}; %NOT SO IMPORTANT
        tmp = strsplit(tmp{2},'B:');
        
        A = tmp{1};%Save A
        tmp = strsplit(tmp{2},'D:');
        B = tmp{1}; %Save B
        
        tmp = strsplit(tmp{2},'E:');
        D = tmp{1}; %Save c
        
        tmp = strsplit(tmp{2},'I:');
        E = tmp{1}; %save D
        
       
        
        fclose(fileID)
        
        %WRite all variables to numbers
        VariablesOfInterest = {'A','D','E'};
        for idx = 1:length(VariablesOfInterest)
            delimeter = ':';
            eval(['findcolumnend = strfind(' VariablesOfInterest{idx} ',''' delimeter ''');'])
            delimeter = '.000';
            eval(['findnewnumber = strfind(' VariablesOfInterest{idx} ',''' delimeter ''');'])
            findnewnumber = findnewnumber+4; %Don't count the delimiter
            findnewnumber = [1 findnewnumber]; % add 1
            removeidx = [];
            for iidx = 1:length(findcolumnend)
                tmp = findnewnumber-findcolumnend(iidx);
                findcolumnstart(iidx) = find(abs(tmp)==min(abs(tmp)) & tmp<0);
                removeidx = [removeidx findnewnumber(findcolumnstart(iidx)):findcolumnend(iidx)];
            end
            eval([VariablesOfInterest{idx} '(removeidx) = [];'])
            delimeter = '.000';
            eval(['[tmp,matches] = strsplit(' VariablesOfInterest{idx} ',''' delimeter ''');'])
            tmp(cellfun(@isempty,tmp)) = [];
            eval([VariablesOfInterest{idx} '=cellfun(@str2num,tmp);'])
        end