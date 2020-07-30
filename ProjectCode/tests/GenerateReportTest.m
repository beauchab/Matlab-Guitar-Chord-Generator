classdef GenerateReportTest < matlab.uitest.TestCase
    % Practice Tracker Unit Tests
    properties
        App
        songs = [{'Shallow'}, {'Never'}, {'Gonna'}, {'Give'}, {'you'}, {'up'}, {'a'}, {'b'}, {'c'}, {'d'}, {'e'}];
        instrs = [{'instr1'}, {'instr2'}];
    end
    
    methods (TestMethodSetup)
        function launchApp(testCase)
            cd  'W:\CIS350SemesterProject';
            testCase.App = GenerateReport(testCase.songs, testCase.instrs);
            testCase.addTeardown(@delete,testCase.App);
        end
    end
    
    methods (Test)
        function testObjCreation(testCase)
            testCase.verifyEqual(class(testCase.App), 'GenerateReport');
        end
    
        function testSongPanelPopulation(testCase)
           % verify song panel has the right songs
           testCase.verifyEqual(numel(testCase.songs),numel(testCase.App.SongsPanel.Children));
           for ii=0:numel(testCase.songs)
               testCase.verifyEqual(testCase.songs{ii}, testCase.App.SongsPanel.Children{ii});
           end
          
        end
        
        function testInstrumentPanelPopulate(testCase)
             % verify instrument panel has the right instruments
           testCase.verifyEqual(numel(testCase.instrs),numel(testCase.App.InstrumentsPanel.Children));
           for ii=0:numel(testCase.instrs)
               testCase.verifyEqual(testCase.instrs{ii}, testCase.App.InstrumentsPanel.Children{ii});
           end
        end
        
        
        function testClearSession(testCase)
            % set data
            testCase.type(testCase.App.PracticeNotesTextArea, "This is a test note");
            testCase.type(testCase.App.GoalTextArea, "This is a test goal");
            
            testCase.choose(testCase.App.SongDropDown, 1);
            testCase.type(testCase.App.MinutesEditField, 15);
            testCase.type(testCase.App.HoursEditField, 1);
            
            testCase.choose(testCase.App.SongDropDown_2, 1);
            testCase.type(testCase.App.MinutesEditField_2, 30);
            testCase.type(testCase.App.HoursEditField, 2);
            
            testCase.choose(testCase.App.SongDropDown, 1);
            testCase.type(testCase.App.MinutesEditField_3, 45);
            testCase.type(testCase.App.HoursEditField_3, 0);
            
            testCase.App.practiceLog.setDateTime;
            
            testCase.choose(testCase.App.InstrumentDropDown, 1);
            testCase.choose(testCase.App.AMPMDropDown, 1);
            
            % press button
            testCase.press(testCase.App.ClearInputsButton);
            
            % verify data
            children = testCase.App.PracticeTrackerTab.Children; % get all properties
            
            for ii = numel(children):-1:1
                thisProp = children(ii);
                
                if strcmp(thisProp.Type,'uitextarea')
                    testCase.verifyEqual(thisProp.Value,{''});
                elseif strcmp(thisProp.Type,'uidropdown')
                    testCase.verifyEqual(thisProp.Value, thisProp.Items{1});
                elseif strcmp(thisProp.Type,'uieditfield')
                    if ~(strcmp(thisProp.UserData, "Date")||strcmp(thisProp.UserData, "Time"))
                        testCase.verifyEqual(thisProp.Value, {0});
                    end
                end
            end
        end
        
        %% Guitar Chord Tests
        %THIS TEST SHOULD WORK
        function testGuitarChords1(testCase)
            %testCase.verifyEqual(class(testCase.App), 'AppMockUp');
            for x = 1:12
                %Generate Key and Chords in Key for Test Case
                key = testCase.co5Arr(x+1,1);
                
                chords = testCase.co5Arr(x+1,:);
                for ii=numel(chords):-1:1
                    chordsInKey(ii) = strcat(testCase.co5Arr(1,ii), " : ", chords(ii));
                end
                
                %Select Key
                testCase.choose(testCase.App.GuitarChords_KeyDD,key);
                
                chordsToTest = testCase.App.GuitarChords_ChordDD.Items;
                
                for i = 1:7
                    %Test Verifications -> Chords have been properly
                    %concatenated to chord num
                    testCase.verifyEqual(convertCharsToStrings(chordsToTest{i}), chordsInKey(i));
                end
                %Test Verifications:
                keyToVer = strcat(key, '.png');
                testCase.verifyEqual(keyToVer, convertCharsToStrings(testCase.App.co5PNG));
            end
        end
        
        %THIS NEEDS WORK DUDE
        function testGuitarChords2(testCase)
            %Loop through all Keys
            for x = 1:12
                %Generate Key and Chords in Key for Test Case
                key = testCase.co5Arr(x+1,1);
                
                chords = testCase.co5Arr(x+1,:);
                for ii=numel(chords):-1:1
                    chordsInKey(ii) = strcat(testCase.co5Arr(1,ii), " : ", chords(ii));
                end
                
                %Select Key
                testCase.choose(testCase.App.GuitarChords_KeyDD,key);
                %Loop through all chords
                for i = 1:7
                    %Select Chord
                    testCase.choose(testCase.App.GuitarChords_ChordDD,chordsInKey(i));
                    %Loop through all caged shapes
                    
                    if(i == 1 || i == 4 || i == 5)
                        subFolder = 'Major';
                    elseif(i == 7)
                        subFolder = 'Diminished';
                    else
                        subFolder = 'Minor';
                    end
                    
                    for j = 1:5
                        %Select Caged Shape
                        cagedShape = testCase.shapeVec(j);
                        testCase.choose(testCase.App.GuitarChords_CAGEDLB,cagedShape);
                        shapeToVer = strcat(cagedShape, '.png');
                        
                        %Test Verifications:
                        %testCase.verifyEqual(convertCharsToStrings(testCase.App.shapePNG),shapeToVer);
                        testCase.verifyEqual(convertCharsToStrings(testCase.App.fMajMin),convertCharsToStrings(subFolder));
                        %   XLocations
                    end
                end
            end
        end
        %% Song Database Tests
        function TestAddSong(testCase)
            testCase.App.addSongToDatabase('Shallow', 'Lady Gaga', 'URL');
            testCase.verifyEqual(testCase.App.UITable.Data{1,1},'Shallow');
            testCase.verifyEqual(testCase.App.UITable.Data{1,2},'Lady Gaga');
            testCase.verifyEqual(testCase.App.UITable.Data{1,3},'URL');
            
            testCase.App.addSongToDatabase('We Will Rock You', 'Queen', 'URL');
            testCase.verifyEqual(testCase.App.UITable.Data{1,1},'Shallow');
            testCase.verifyEqual(testCase.App.UITable.Data{1,2},'Lady Gaga');
            testCase.verifyEqual(testCase.App.UITable.Data{1,3},'URL');
            testCase.verifyEqual(testCase.App.UITable.Data{2,1},'We Will Rock You');
            testCase.verifyEqual(testCase.App.UITable.Data{2,2},'Queen');
            testCase.verifyEqual(testCase.App.UITable.Data{2,3},'URL');
            
            testCase.App.addSongToDatabase('Baby', 'Justin Bieber', 'URL');
            testCase.verifyEqual(testCase.App.UITable.Data{1,1},'Baby');
            testCase.verifyEqual(testCase.App.UITable.Data{1,2},'Justin Bieber');
            testCase.verifyEqual(testCase.App.UITable.Data{1,3},'URL');
            testCase.verifyEqual(testCase.App.UITable.Data{2,1},'Shallow');
            testCase.verifyEqual(testCase.App.UITable.Data{2,2},'Lady Gaga');
            testCase.verifyEqual(testCase.App.UITable.Data{2,3},'URL');
            testCase.verifyEqual(testCase.App.UITable.Data{3,1},'We Will Rock You');
            testCase.verifyEqual(testCase.App.UITable.Data{3,2},'Queen');
            testCase.verifyEqual(testCase.App.UITable.Data{3,3},'URL');
        end
        
        function TestDeleteSong(testCase)
            testCase.App.addSongToDatabase('Shallow', 'Lady Gaga', 'URL');
            testCase.App.addSongToDatabase('We Will Rock You', 'Queen', 'URL');
            testCase.App.addSongToDatabase('Baby', 'Justin Bieber', 'URL');
            testCase.verifyEqual(testCase.App.UITable.Data{1,1},'Baby');
            testCase.verifyEqual(testCase.App.UITable.Data{1,2},'Justin Bieber');
            testCase.verifyEqual(testCase.App.UITable.Data{1,3},'URL');
            testCase.verifyEqual(testCase.App.UITable.Data{2,1},'Shallow');
            testCase.verifyEqual(testCase.App.UITable.Data{2,2},'Lady Gaga');
            testCase.verifyEqual(testCase.App.UITable.Data{2,3},'URL');
            testCase.verifyEqual(testCase.App.UITable.Data{3,1},'We Will Rock You');
            testCase.verifyEqual(testCase.App.UITable.Data{3,2},'Queen');
            testCase.verifyEqual(testCase.App.UITable.Data{3,3},'URL');
            
            testCase.App.deleteSongInDatabase('Shallow');
            testCase.verifyEqual(testCase.App.UITable.Data{1,1},'Baby');
            testCase.verifyEqual(testCase.App.UITable.Data{1,2},'Justin Bieber');
            testCase.verifyEqual(testCase.App.UITable.Data{1,3},'URL');
            testCase.verifyEqual(testCase.App.UITable.Data{2,1},'We Will Rock You');
            testCase.verifyEqual(testCase.App.UITable.Data{2,2},'Queen');
            testCase.verifyEqual(testCase.App.UITable.Data{2,3},'URL');
        end
        
    end
end