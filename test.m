clc 
clear 
close all 
file_contents = readFile('emailSample1.txt');
email_contents=file_contents;
vocabList = getVocabList();
size1=length(file_contents);
size2=length(vocabList);
words_idex=zeros(1,size1);
f=transpose((file_contents))
z=f(3,1)
vocabList(1,1)
r=1
 email_contents = lower(email_contents);

% Strip all HTML
% Looks for any expression that starts with < and ends with > and replace
% and does not have any < or > in the tag it with a space
email_contents = regexprep(email_contents, '<[^<>]+>', ' ');

% Handle Numbers
% Look for one or more characters between 0-9
email_contents = regexprep(email_contents, '[0-9]+', 'number');

% Handle URLS
% Look for strings starting with http:// or https://
email_contents = regexprep(email_contents, ...
                           '(http|https)://[^\s]*', 'httpaddr');

% Handle Email Addresses
% Look for strings with @ in the middle
email_contents = regexprep(email_contents, '[^\s]+@[^\s]+', 'emailaddr');

% Handle $ sign
email_contents = regexprep(email_contents, '[$]+', 'dollar');


% ========================== Tokenize Email ===========================

% Output the email to screen as well
fprintf('\n==== Processed Email ====\n\n');

% Process file
l = 0;
i=0;
yas=zeros(size(file_contents));
while ~isempty(email_contents)
i=i+1;
    % Tokenize and also get rid of any punctuation
    [str, email_contents] = ...
       strtok(email_contents, ...
              [' @$/#.-:&*+=[]?!(){},''">_<;%' char(10) char(13)]);
   
    % Remove any non alphanumeric characters
    str = regexprep(str, '[^a-zA-Z0-9]', '');

    % Stem the word 
    % (the porterStemmer sometimes has issues, so we use a try catch block)
    try str = porterStemmer(strtrim(str)); 
    catch str = ''; continue;
    end;

    % Skip the word if it is too short
    if length(str) < 1
       continue;
    end
  % Print to screen, ensuring that the output lines are not too long
    if (l + length(str) + 1) > 78
        fprintf('\n');
        l = 0;
    end
    fprintf('%s ', str);
    yas(1,i)=str2num(str)
    l = l + length(str) + 1;

end

% for i=1:size1
% for j=1:size2
%     
% if(file_contents(i,1)==char(vocabList(j,1)))
%     words_idex(1:i)=j;
%     j=size2;
% 
% end
% end 
% end 

% Init return value
word_indices = [];