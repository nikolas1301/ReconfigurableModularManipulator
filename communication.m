function communication(Angulos)

arduino = serial('COM4','BaudRate',115200, 'Parity', 'none'); % create serial communication object on port COM4
set(arduino, 'terminator', 'LF');

try
    fopen(arduino); % initiate arduino communication
catch err
    fclose(instrfind);
    fclose(arduino);
    error('Make sure you select the correct COM Port where the Arduino is connected.');
end
pause(2)
%%

An1 = Angulos(1);
An2 = Angulos(2);
An3 = Angulos(3);

%An1 = 270;
%An2 = 90;
%An3 = 310;

anstr1 = int2str(An1);
anstr2 = int2str(An2);
anstr3 = int2str(An3);

if (An1<100)
    
    s = '0';
    ancat11 = strcat(s, anstr1);
    anstr1 = ancat11;
    
    if(An1<10)
        
        ancat12 = strcat(s, anstr1);
        anstr1 = ancat12;
    end
end

if (An2<100)
    
    s = '0';
    ancat21 = strcat(s, anstr2);
    anstr2 = ancat21;
    
    if(An2<10)
        
        ancat22 = strcat(s, anstr2);
        anstr2 = ancat22;
    end
end

if (An3<100)
    
    s = '0';
    ancat31 = strcat(s, anstr3);
    anstr3 = ancat31;
    
    if(An3<10)
        
        ancat32 = strcat(s, anstr3);
        anstr3 = ancat32;
    end
end

%%
an1 = str2double(anstr1(1));
an2 = str2double(anstr1(2));
an3 = str2double(anstr1(3));
an4 = str2double(anstr2(1));
an5 = str2double(anstr2(2));
an6 = str2double(anstr2(3));
an7 = str2double(anstr3(1));
an8 = str2double(anstr3(2));
an9 = str2double(anstr3(3));

an1 = num2str(an1);
an2 = num2str(an2);
an3 = num2str(an3);
an4 = num2str(an4);
an5 = num2str(an5);
an6 = num2str(an6);
an7 = num2str(an7);
an8 = num2str(an8);
an9 = num2str(an9);

%%
fprintf(arduino,'%s',char(an1));

fprintf(arduino,'%s',char(an2));

fprintf(arduino,'%s',char(an3));

fprintf(arduino,'%s',char(an4));

fprintf(arduino,'%s',char(an5));

fprintf(arduino,'%s',char(an6));

fprintf(arduino,'%s',char(an7));

fprintf(arduino,'%s',char(an8));

fprintf(arduino,'%s',char(an9));
%end

fclose(arduino); % end communication with arduino
delete(arduino);
clear arduino;