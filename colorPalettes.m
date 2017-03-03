% Grab color palettes from the website color-hex.com and save them in the structure C

clear;
favThreshold = 30; % won't save palettes than have a number of favorites below this number
% decrease favThreshold to save more palettes in the data structure

for i=200:30000 % valid URLs (once more are added to the website, upper bound can increase)
    fullURL=strcat('http://www.color-hex.com/color-palette/',num2str(i));
    text=urlread(fullURL);
    
    patFound='[<][p][>][n][o][t][ ][f][o][u][n][d]';
    found=regexp(text,patFound,'match'); % some URLs are unavailable and return a blank page
    
    if isempty(found)
        patFav='\d*\s[F][a][v]';
        strtmp=regexp(text,patFav,'match');
        pat='\s[F][a][v]';
        strFav=regexprep(strtmp,pat,'');
        
        if length(strFav)==1 % make sure that the number of favorites is a valid number
            fav=str2num(strFav{:});
        else
            continue
        end
        
        if fav > favThreshold % only save palettes above a certain number of favorites
            
            patName='[t][i][t][l][e][>][^...][\w+\s]+';
            strtmp=regexp(text,patName,'match');
            pat='[t][i][t][l][e][>]';
            strName=regexprep(strtmp,pat,'');
            strName=regexprep(strName,'[+#\s]','');
            strName=strrep(strName,'ColorPalette','');
            name=strName{:};
            
            if ~isempty(strName) && isempty(str2num(name(1))) % make sure that name is a valid name
                
                patColor='[t][d][>][(]\d*[,]\d*[,]\d*';
                strtmp=regexp(text,patColor,'match');
                pat='[t][d][>][(]';
                strColor=regexprep(strtmp,pat,'');
                colors=NaN(length(strColor),3);
                for j=1:length(strColor)
                    colors(j,:)=str2num(strColor{j}); % get rgb values for each color in the palette
                end
                C.(name)=colors; % save each palette under its name within the structure
            end
        end
    end
    if mod(i,10)==0
        disp(i) % prints every 10th iteration so the user has a rough estimate of runtime
    end
end

save('colorPalettes.mat','C');