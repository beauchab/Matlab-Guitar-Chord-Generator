classdef PracticeTrackerTest < matlab.unittest.TestCase
    % Practice Tracker Unit Tests
    properties
        App
        tracker
    end
    
    methods (TestMethodSetup)
        function launchApp(testCase)
            testCase.App = AppMockUp;
            testCase.tracker = PracticeTracker(testCase.App);
            testCase.addTeardown(@delete,testCase.App);
        end
    end
    
    methods (Test)
        function testObjCreation(testCase)
            testCase.verifyEqual(class(testCase.tracker), 'PracticeTracker');
        end
        
        function testSetDateTime(testCase)
            testCase.tracker.setDateTime
            time = datestr(now,'HH:MM PM');
            testCase.verifyEqual(testCase.App.DateEditField.Value,datestr(now,'mm/dd/yyyy'));
            testCase.verifyEqual(testCase.App.TimeEditField.Value,strtrim(time(1:5)));
            testCase.verifyEqual(testCase.App.AMPMDropDown.Value,time(7:8));
        end
        
    end
end