classdef AppTest < matlab.uitest.TestCase
    % Practice Tracker Unit Tests
    properties
        App
    end
    
    methods (TestMethodSetup)
        function launchApp(testCase)
            testCase.App = AppMockUp;
            testCase.addTeardown(@delete,testCase.App);
        end
    end
    
    methods (Test)
        function testObjCreation(testCase)
            testCase.verifyEqual(class(testCase.App), 'AppMockUp');
        end
        
        %% Practice Tracker Testing
        function testSubmitSession(testCase)
            % set data 
            testCase.type(testCase.App.PracticeNotesTextArea, "This is a test note");
            testCase.type(testCase.App.GoalTextArea, "This is a test goal");
            
            testCase.choose(testCase.App.SongDropDown, 1);
            testCase.type(testCase.App.MinutesEditField, 15);
            testCase.type(testCase.App.HoursEditField, 1);
            
            testCase.choose(testCase.App.SongDropDown_2, 1);
            testCase.type(testCase.App.MinutesEditField_2, 30);
            testCase.type(testCase.App.HoursEditField_2, 2);
            
            testCase.choose(testCase.App.SongDropDown_3, 1);
            testCase.type(testCase.App.MinutesEditField_3, 45);
            testCase.type(testCase.App.HoursEditField_3, 0);
            
            testCase.App.practiceLog.setDateTime;
            
            testCase.choose(testCase.App.InstrumentDropDown, 1);
            testCase.choose(testCase.App.AMPMDropDown, 1);
            
            % press button
            testCase.press(testCase.App.SubmitSessionButton);
            
            % verify file was created
            instr = testCase.App.InstrumentDropDown.Value;
            date = testCase.App.DateEditField.Value;
            time = testCase.App.TimeEditField.Value;
            curfolder = pwd;
            file = strcat(curfolder, '\', instr, "_", erase(date,"/"), "_", erase(time,":"), ".xlsx");
            testCase.verifyEqual(isfile(file),true);
            
            % verify data
        end
        
        function testRecallSession(testCase)
            % function to be implemented in later sprint
            %testCase.press(testCase.App.RecallSessionButton);
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
        
    end
end