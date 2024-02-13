classdef Ballistic < handle
        
    properties (Constant, Hidden)
        CHANNELIN = 0;
        SAMPLERATE = 2000;                      % in samples for DAQ
        MOUSESAMPLERATE = 100;                  % in samples for mouse
        DAQREFRESHRATE = 0.1;                   % in seconds
        SINGLEENDED = false;
        SOUNDBEEPFREQUENCYBEFORETRIAL = 2000;   % in Hz
        SOUNDBEEPFREQUENCYAFTERFB = 1500;       % in Hz
        LOWPASSSMOOTH = 80                      % in Hz
        
        INPUTTYPES = {'Mouse' 'DAQ'};
        FBTYPES = {'KR' 'KP' 'Both'};
        MOUSEINPUT = 1;                         % Which input is the mouse
        DAQINPUT = 2;                           % Which input is DAQ
        NUMERICFB = [1,3];                      % Which FB contains numeric
        VISUALFB = [2,3];                       % Which FB contains visual
        
        LINECOLOR = 'blue';
        DIVISORYLINECOLOR = 'green';
        TARGETLINECOLOR = 'yellow';
        MAXACCELERATIONSUBJECTCOLOR = 'red';
        CLOCKTRIALCOLOR = 'green';
        CLOCKPAUSECOLOR = 'yellow';
        
        CONFIGFILE = 'config.mat';
        DEFAULTFBTEXT = '8888';
        INVALSTR = '---';
        
        % Fixed size of the supervisor's feedback size
        SUPERVISORFBSIZE = 35;
        % If blind is ticked, the feedback has to be full screen
        USEWHOLESCREENFBINBLIND = true;
        % If the whole screen FB has to be there all the time, not
        % following the same behaviour as the small feedback
        WHOLESCREENFBPERMANENT = true;
        % If the signal has to go from right to left instead of left to
        % right
        SIGNALMIRRORED = false;                                                     %% Not working yet
        % If the signal has to be smoothed during the trial
        ONLINESMOOTH = true;
        % Position of the cursor when the blind option is chosen
        CURSORSTARTLEVEL = 1;
        % Level that the input has to reach in order to start considering
        % it to calculate the first peak of acceleration
        MINIMUMPEAKDETECTIONLEVEL = 0.05; % in input device units (v or pixels)
        % Number of samples that the input acceleration signal has to be 0
        % or negative to stop considering it part of the first peak
        DECELERATIONDURATION = 2; % in samples
        
        %% CONSTANT VALUES FOR THE CLASS %%
        WHITECLR = [1 1 1];
        GREYCLR = [0.7020 0.7020 0.7020];
        
    end
        
    properties (SetAccess = private)
        %%% DEFAULT VALUES %%%
        
        soundEn = false;
        blind = false;
        feedBack = true;
        vertical = false;
        clockAppear = true;
        randFB = false;
        subjectRealFB = false;
        subjectCopyFB = false;
        minn = 0;
        maxx = 1;
        trials = 10;
        trialTime = 10;
        maxValue = 5;
        maskAppearTime = 0.75;
        
        preFBTime = 1;
        FBTime = 2;
        postFBTime = 1;
        FBSize = 35;
        
        backgrndClr = [1 1 1];
        FBClr = [0.7020 0.7020 0.7020];
        FBDigitClr = [0 0 0];
        FBMaskClr = [0 0 0];
        
        input = Ballistic.MOUSEINPUT;
        FBType = 1;
        
        %%%%%%%%%%%%%%%%%%%%%%
    end
    
    properties (Transient, SetAccess = private, GetAccess = private)
        mainGUI;
        mainGraph;
        mainLine;
        subjectGUI;
        subjectGraph;
        subjectLine;
        DAQin;
        clocks;
        FBBoxes;
        FBBlindBox;
        FBBlindBoxBack;
        
        mouseTimer;
        trialTimer;
        trialInitTimer;
        trialPreMaskTimer;
        trialPostMaskTimer;
        pauseTimer;
        pauseInitTimer;
        pausePreFBTimer;
        pauseFBTimer;
        pausePostFBTimer;
        trialTimerActive;
        pauseTimerActive;
        
        running = false;
        trialsToExecute;
        mouseTimeStamp;
        FBshown = false;
        FBhidden = false;
        FBdefault = false;
        
        maxAccelerationDotSubject;
        maxAccelerationDotMain;
        maxAccelerationPercentageMain;
        maxAccelerationPercentageSubject;
        maxAccelerationDotHandles;
        otherLineHandles;
        startTimestamp;
        stopTimestamp;
        
        %%% VALUES TO SAVE %%%
        
        subjectLineVisualTrace = {};
        subjectLineRealTrace = {};
        traceTimeStamps = {};
        realFeedbackShown = {};
        visualFeedbackShown = {};
        realFeedbackPercentageShown = {};
        visualFeedbackPercentageShown = {};
        
        totalDataStore = {};
        
        %%%%%%%%%%%%%%%%%%%%%%
    end
    
    methods
        
        function this = Ballistic(varargin)
            this.mainGUI = guihandles(ballistic_gui);
            set(this.mainGUI.graph, 'Visible', 'off');
            
            if ~isempty(dir(this.CONFIGFILE))
                t = load(this.CONFIGFILE, 'this');
                t = t.this;
                prop = properties(t);
                for p=prop'
                    this.(p{1}) = t.(p{1});
                end
            end
            
            this.setCallbacks();
            this.setInput();
            this.setTimers();
        end
        
    end
    
    methods (Access = private)
        
        function delete(this)
            if ~isempty(this.mainGUI)
                this.running = false;
                if ~isfloat(this.trialTimer) && isvalid(this.trialTimer)
                    stop(this.trialTimer);
                    delete(this.trialTimer);
                end
                if ~isfloat(this.trialPreMaskTimer) && isvalid(this.trialPreMaskTimer)
                    stop(this.trialPreMaskTimer);
                    delete(this.trialPreMaskTimer);
                end
                if ~isfloat(this.trialPostMaskTimer) && isvalid(this.trialPostMaskTimer)
                    stop(this.trialPostMaskTimer);
                    delete(this.trialPostMaskTimer);
                end
                if ~isfloat(this.pauseTimer) && isvalid(this.pauseTimer)
                    stop(this.pauseTimer);
                    delete(this.pauseTimer);
                end
                if ~isfloat(this.pausePreFBTimer) && isvalid(this.pausePreFBTimer)
                    stop(this.pausePreFBTimer);
                    delete(this.pausePreFBTimer);
                end
                if ~isfloat(this.pauseFBTimer) && isvalid(this.pauseFBTimer)
                    stop(this.pauseFBTimer);
                    delete(this.pauseFBTimer);
                end
                if ~isfloat(this.pausePostFBTimer) && isvalid(this.pausePostFBTimer)
                    stop(this.pausePostFBTimer);
                    delete(this.pausePostFBTimer);
                end
                if ~isfloat(this.mouseTimer) && isvalid(this.mouseTimer)
                    stop(this.mouseTimer);
                    delete(this.mouseTimer);
                end
                if ~isempty(this.DAQin)
                    this.DAQin.stop;
                    delete(this.DAQin);
                end
                this.collectAndResetData();
                this.saveFile();
                this.saveConfig();
                if ishandle(this.subjectGUI)
                    delete(this.subjectGUI);
                end
                delete(this.mainGUI.figure1);
            end
        end
        
        function draw(this, ~, ev, data)
            if this.isDAQInput
                data = ev.Data';
                time = ev.TimeStamps';
                
% Fixing error with timing from ni API
time = time - min(time) + mean(diff(time));
                
            else
                time = toc(this.mouseTimeStamp);
            end
            
            smoothFactor = this.SAMPLERATE / this.LOWPASSSMOOTH;
            yp = [get(this.subjectLine, 'UserData') data];
            set(this.subjectLine, 'UserData', yp);
            if this.ONLINESMOOTH
                y = smooth(yp, smoothFactor)';
                % Remove the first artifact in the subject trace
                if this.SIGNALMIRRORED
                    y = [y(smoothFactor+1:end) y(end)*ones(1,min(smoothFactor, length(y)))];
                else
                    y = [y(1)*ones(1,min(smoothFactor, length(y))) y(1:end-smoothFactor)];
                end
            else
                y = yp;
            end
            
            if this.vertical
                x = get(this.subjectLine, 'YData');
            else
                x = get(this.subjectLine, 'XData');
            end
            
% Fixing error with timing from ni API
if ~isempty(x) && this.isDAQInput
    v = x(end);
else
    v = 0;
end
time = time + v;

            % Changing the entry point of position signal (time)
            if this.SIGNALMIRRORED
                x = [time x];
            else
                x = [x time];
            end
            
            if this.blind
                m = repmat(this.CURSORSTARTLEVEL, 1, length(x));
            else
                m = y;
            end
            if this.vertical
                set(this.subjectLine, 'YData', x);
                set(this.subjectLine, 'XData', m);
            else
                set(this.subjectLine, 'XData', x);
                set(this.subjectLine, 'YData', m);
            end
            set(this.mainLine, 'XData', x);
            set(this.mainLine, 'YData', yp);
        end
        
        function endOfTrial(this, ~, ~)
            % If stop hasn't been clicked
            if (this.running)
                this.deactivateInput();
                
                if this.vertical
                    xdata = get(this.subjectLine, 'YData');
                    ydata = get(this.subjectLine, 'XData');
                else
                    xdata = get(this.subjectLine, 'XData');
                    ydata = get(this.subjectLine, 'YData');
                end
                % Calculating performance of subject with the real data
                if (this.blind)
                    ydata = get(this.subjectLine, 'UserData');
                end
                this.maxAccelerationDotSubject = this.CalculateAccelerationPeak(xdata, ydata);
                this.maxAccelerationDotMain = this.CalculateAccelerationPeak(xdata, get(this.subjectLine, 'UserData'));
                
                if (this.randFB)
                    this.maxAccelerationPercentageSubject = randi(99);
                elseif ~isempty(this.maxAccelerationDotSubject)
                    if ischar(this.maxAccelerationDotSubject)
                        this.maxAccelerationPercentageSubject = this.maxAccelerationDotSubject;
                    else
                        this.maxAccelerationPercentageSubject = round(this.maxAccelerationDotSubject(1) / this.maxValue * 100);
                    end
                end
                
                if this.subjectCopyFB
                    this.maxAccelerationPercentageMain = this.maxAccelerationPercentageSubject;
                elseif ~isempty(this.maxAccelerationDotMain)
                    if ischar(this.maxAccelerationDotMain)
                        this.maxAccelerationPercentageMain = this.maxAccelerationDotMain;
                    else
                        this.maxAccelerationPercentageMain = round(this.maxAccelerationDotMain(1) / this.maxValue * 100);
                    end
                end
                
                % Show FB right away in main window
                set(this.FBBoxes(1), 'Visible', 'on');
                set(this.FBBoxes(1), 'ForegroundColor', this.FBDigitClr);
                if ~isempty(this.maxAccelerationDotMain)
                    set(this.FBBoxes(1), 'String', this.maxAccelerationPercentageMain);
                end
                if ~isempty(this.maxAccelerationDotMain) && ~ischar(this.maxAccelerationDotMain)
                    this.maxAccelerationDotHandles = scatter(get(this.mainLine, 'Parent'), this.maxAccelerationDotMain(2), this.maxAccelerationDotMain(1), 'ro', 'MarkerFaceColor', this.MAXACCELERATIONSUBJECTCOLOR);
                end
                
                %%%% SAVING DATA %%%%
                
                this.subjectLineVisualTrace{end+1} = ydata;
                this.subjectLineRealTrace{end+1} = get(this.subjectLine, 'UserData');
                this.traceTimeStamps{end+1} = xdata;
                this.realFeedbackShown{end+1} = this.maxAccelerationDotMain;
                this.visualFeedbackShown{end+1} = this.maxAccelerationDotSubject;
                this.realFeedbackPercentageShown{end+1} = this.maxAccelerationPercentageMain;
                this.visualFeedbackPercentageShown{end+1} = this.maxAccelerationPercentageSubject;
                
                %%%%%%%%%%%%%%%%%%%%%
                
                if (this.pauseTimerActive)
                    if this.preFBTime == 0
                        this.showFB();
                    end
                    start(this.pauseInitTimer);
                    start(this.pauseTimer);
                    this.changeColorStopWatch('pause');
                else
                    this.endOfPause();
                end
            end
        end
        
        function endOfPause(this, ~, ~)
            this.trialsToExecute = this.trialsToExecute - 1;
            % If stop hasn't been clicked
            if (this.running)
                
                % Remove FB from main window
                if ~isempty(this.maxAccelerationDotHandles) && ishandle(this.maxAccelerationDotHandles(1))
                    delete(this.maxAccelerationDotHandles(1));
                end
                
                % Remove data from the lines
                set([this.subjectLine this.mainLine], 'XData', []);
                set([this.subjectLine this.mainLine], 'YData', []);
                set(this.subjectLine, 'UserData', []);
                
                % Removing feedback completely
                set([this.FBBoxes(2) this.FBBlindBox], 'String', '');
                set(this.FBBoxes(2), 'Visible', 'off');
                if (this.blind && this.USEWHOLESCREENFBINBLIND && ~this.WHOLESCREENFBPERMANENT)
                    set([this.FBBlindBox this.FBBlindBoxBack], 'Visible', 'off');
                end
                
                this.FBshown = false;
                this.FBhidden = false;
                this.FBdefault = false;
                
                % If there are more trials to run
                if (this.trialsToExecute ~= 0)
                    if (this.soundEn)
                        this.playSound();
                    end
                    if (this.trialTimerActive)
                        start(this.trialTimer);
                        start(this.trialInitTimer);
                        this.changeColorStopWatch('trial');
                    else
                        this.endOfTrial();
                    end
                    this.activateInput();
                % If this was the last trial
                else
                    this.stopExperiment();
                end
            end
        end
        
        function trialTimerFcn(this, ~, ~)
            set(this.FBBoxes(1), 'String', '');
            set([this.FBBoxes(2) this.FBBlindBox], 'String', this.DEFAULTFBTEXT);
            set([this.FBBoxes(2) this.FBBlindBox], 'ForegroundColor', this.FBMaskClr);
            set(this.FBBoxes(2), 'Visible', 'on');
            if (this.blind && this.USEWHOLESCREENFBINBLIND && ~this.WHOLESCREENFBPERMANENT)
                set([this.FBBlindBox this.FBBlindBoxBack], 'Visible', 'on');
            end
            this.FBdefault = true;
            
            % Starting next timer
            if this.maskAppearTime == 1
                this.EndOfTrial();
            else
                start(this.trialPostMaskTimer);
            end
        end
        
        function showFB(this, ~, ~)
            if this.feedBack && this.isNumericFB()
                set(this.FBBoxes(2), 'Visible', 'on');
                if ~isempty(this.maxAccelerationDotSubject) || this.randFB
                    if this.subjectRealFB
                        fb = this.maxAccelerationPercentageMain;
                    else
                        fb = this.maxAccelerationPercentageSubject;
                    end
                    set([this.FBBoxes(2) this.FBBlindBox], 'String', fb);
                    set([this.FBBoxes(2) this.FBBlindBox], 'ForegroundColor', this.FBDigitClr);
                end
                if (this.blind && this.USEWHOLESCREENFBINBLIND && ~this.WHOLESCREENFBPERMANENT)
                    set([this.FBBlindBox this.FBBlindBoxBack], 'Visible', 'on');
                end
            end
            
            % Plotting the maximum acceleration dots
            acc = [];
            if this.isVisualFB() && ~isempty(this.maxAccelerationDotSubject) && this.feedBack
                set(this.subjectLine, 'Visible', 'on');
                acc = scatter(get(this.subjectLine, 'Parent'), this.maxAccelerationDotSubject(2), this.maxAccelerationDotSubject(1), 'ro', 'MarkerFaceColor', this.MAXACCELERATIONSUBJECTCOLOR);
            end
            this.maxAccelerationDotHandles = [this.maxAccelerationDotHandles acc];
            
            % Starting next timer
            if this.FBTime == 0
                this.hideFB();
                if this.postFBTime == 0
                    start(this.trialInitTimer);
                    start(this.trialTimer);
                else
                    start(this.pausePostFBTimer);
                end
            else
                start(this.pauseFBTimer);
            end
        end
        
        function hideFB(this, ~, ~)
            % Setting feedback to default string
            if ~isempty(get(this.FBBoxes(2), 'String'))
                set([this.FBBoxes(2) this.FBBlindBox], 'String', this.DEFAULTFBTEXT);
                set([this.FBBoxes(2) this.FBBlindBox], 'ForegroundColor', this.FBMaskClr);
            end
            
            set(this.subjectLine, 'Visible', 'off');
            
            % Removing the maximum acceleration dots
            if length(this.maxAccelerationDotHandles) == 2 && ishandle(this.maxAccelerationDotHandles(2))
                delete(this.maxAccelerationDotHandles(2));
            end
            
            % Starting next timer
            if this.postFBTime == 0
                start(this.trialInitTimer);
                start(this.trialTimer);
            else
                start(this.pausePostFBTimer);
            end
        end
        
        function changeColorStopWatch(this, source)
            switch source
                case 'trial'
                    color = this.CLOCKTRIALCOLOR;
                case 'pause'
                    color = this.CLOCKPAUSECOLOR;
            end
            set(this.clocks, 'BackgroundColor', color);
        end
        
        function decreaseStopWatch(this, timer, ~)
            time = get(timer, 'TasksToExecute') - get(timer, 'TasksExecuted');
            trialNr = this.trials - this.trialsToExecute + 1;
            mins = fix(time/60);
            secs = mod(time,60);
            string = sprintf('%02d - %02d:%02d', trialNr, mins, secs);
            for i=1:length(this.clocks)
                set(this.clocks(i), 'String', string);
            end
        end
        
        function setTimers(this)
            this.pauseTimer = timer('TimerFcn', {@this.decreaseStopWatch}, 'StartFcn', {@this.decreaseStopWatch}, 'Name', 'pauseTimer');
            this.pausePreFBTimer = timer('TimerFcn', @this.showFB, 'Name', 'preFBTimer');
            this.pauseFBTimer = timer('TimerFcn', @this.hideFB, 'Name', 'FBTimer');
            this.pausePostFBTimer = timer('TimerFcn', @this.endOfPause, 'Name', 'postFBTimer');
            
            this.trialTimer = timer('TimerFcn', {@this.decreaseStopWatch}, 'StartFcn', {@this.decreaseStopWatch}, 'Name', 'trialTimer');
            this.trialPreMaskTimer = timer('TimerFcn', @this.trialTimerFcn, 'Name', 'preMaskTimer');
            this.trialPostMaskTimer = timer('TimerFcn', @this.endOfTrial, 'Name', 'postMaskTimer');
            
            timers = [  this.pauseTimer this.pausePreFBTimer ...
                        this.pauseFBTimer this.pausePostFBTimer ...
                        this.trialPreMaskTimer this.trialPostMaskTimer ...
                        this.trialTimer];
            set(timers, 'StartDelay', 1);
            set(timers, 'TasksToExecute', 1);
            set(timers, 'ExecutionMode', 'FixedRate');
        end
        
        function setInput(this)
            if (this.isMouseInput)
                this.mouseTimer = timer('Period', 1/this.MOUSESAMPLERATE);
                set(this.mouseTimer, 'TimerFcn', @this.mouseCapture);
                set(this.mouseTimer, 'ExecutionMode', 'FixedRate');
                set(this.mouseTimer, 'Name', 'MouseTimer');
            elseif (this.isDAQInput)
                this.InitDAQ();
            end
        end
        
        function result = InitDAQ(this)
            result = true;
            devs = daq.getDevices;
            if isempty(devs)
                ok = false;
                w = warndlg('No boards connected!', 'Error initializing', 'modal');
                uiwait(w);
            elseif length(devs) > 1
                [selection,ok] = listdlg(   'ListString', {devs.ID}, ...
                                            'PromptString','Select a file:',...
                                            'SelectionMode','single');
            else
                selection = 1;
                ok = true;
            end
            if ok
                selection = devs(selection);
            else
                result = false;
                return;
            end
            
            if this.SINGLEENDED
                Itype = 'SingleEnded';
            else
                Itype = 'Differential';
            end
            function inputtypeassgn(channel)
                set(channel ,'InputType', Itype);
            end
            
            try
                session = daq.createSession('ni');
                session.addAnalogInputChannel(selection.ID, this.CHANNELIN, 'Voltage');
                session.IsContinuous = true;
                session.Rate = this.SAMPLERATE;
                session.NotifyWhenDataAvailableExceeds = round(this.DAQREFRESHRATE * this.SAMPLERATE);
                session.addlistener('DataAvailable', @this.draw);
                arrayfun(@(c)inputtypeassgn(c), session.Channels, 'UniformOutput', false);
                session.prepare;
                this.DAQin = session;
            catch e
                result = false;
                w = warndlg(e.message, 'Error initializing', 'modal');
                uiwait(w);
            end
        end
        
        function adjustGraphSize(this)
            if (this.trialTime == 0)
                xax = [0 0.1];
            else
                xax = [0 this.trialTime];
            end
            yax = [this.minn this.maxx];
            if this.vertical
                set(this.mainGraph, 'XLim', yax);
                set(this.subjectGraph, 'XLim', yax);
                set(this.mainGraph, 'YLim', xax);
                set(this.subjectGraph, 'YLim', xax);
            else
                set(this.mainGraph, 'XLim', xax);
                set(this.subjectGraph, 'XLim', xax);
                set(this.mainGraph, 'YLim', yax);
                set(this.subjectGraph, 'YLim', yax);
            end
        end
        
        function activateInput(this)
            % Activating the input device
            if (this.isDAQInput)
                this.DAQin.startBackground();
            elseif (this.isMouseInput)
                this.mouseTimeStamp = tic;
                start(this.mouseTimer);
            end
            set(this.subjectLine, 'Visible', 'on');
        end
        
        function deactivateInput(this)
            % Deactivating the input device
            if (this.isDAQInput)
                if ~isempty(this.DAQin)
                    this.DAQin.stop;
                    this.DAQin.wait;
                end
            elseif (this.isMouseInput)
                if ~isfloat(this.mouseTimer) && isvalid(this.mouseTimer)
                    stop(this.mouseTimer);
                end
            end
            set(this.subjectLine, 'Visible', 'off');
        end
        
        function mouseCapture(this, ~, ~)
            p = get(0,'PointerLocation');
            this.draw([], [], p(~this.vertical+1));
        end
        
        function startExperiment(this)
            % Setting total time of pause state
            pauseTotalTime = this.preFBTime + this.FBTime + this.postFBTime;
            if (pauseTotalTime <= 0)
                this.pauseTimerActive = false;
            else
                this.pauseTimerActive = true;
                set(this.pauseTimer, 'TasksToExecute', max(1, floor(pauseTotalTime) - 1));
                set(this.pauseTimer, 'StartDelay', 1 + pauseTotalTime - floor(pauseTotalTime));
                if (this.preFBTime ~= 0)
                    set(this.pausePreFBTimer, 'StartDelay', this.preFBTime);
                end
                if (this.preFBTime ~= 0)
                    set(this.pauseFBTimer, 'StartDelay', this.FBTime);
                end
                if (this.postFBTime ~= 0)
                    set(this.pausePostFBTimer, 'StartDelay', this.postFBTime);
                end
                if (this.preFBTime ~= 0)
                    this.pauseInitTimer = this.pausePreFBTimer;
                elseif (this.FBTime ~= 0)
                    this.pauseInitTimer = this.pauseFBTimer;
                elseif (this.postFBTime ~= 0)
                    this.pauseInitTimer = this.pausePostFBTimer;
                end
            end
            % Setting total time of trial state
            if (this.trialTime <= 0)
                this.trialTimerActive = false;
            else
                this.trialTimerActive = true;
                set(this.trialTimer, 'TasksToExecute', floor(this.trialTime));
                set(this.trialTimer, 'StartDelay', 1 + this.trialTime - floor(this.trialTime));
                timeToMask = this.trialTime * this.maskAppearTime;
                if (this.maskAppearTime ~= 0)
                    set(this.trialPreMaskTimer, 'StartDelay', timeToMask);
                end
                if (this.maskAppearTime ~= 1)
                    set(this.trialPostMaskTimer, 'StartDelay', this.trialTime - timeToMask);
                end
                if (timeToMask ~= 0)
                    this.trialInitTimer = this.trialPreMaskTimer;
                else
                    this.trialInitTimer = this.trialPostMaskTimer;
                end
            end
            
            % Hiding configuration panel
            set(this.mainGUI.configurationPanel, 'Visible', 'off');
            % Showing supervisor graph
            set(this.mainGUI.graph, 'Visible', 'on');
            
            % Getting subject window
            this.subjectGUI = guihandles(ballistic_subj_gui);
            this.subjectGraph = this.subjectGUI.graph;
            set(this.subjectGraph, 'NextPlot', 'add');
            if (this.clockAppear)
                this.clocks(2) = this.subjectGUI.clock;
            else
                set(this.subjectGUI.clock, 'Visible', 'off');
            end
            this.FBBoxes(2) = this.subjectGUI.FBBox;
            this.FBBlindBox = this.subjectGUI.FBBoxBlind;
            this.FBBlindBoxBack = this.subjectGUI.FBBoxBlindBack;
            this.subjectGUI = this.subjectGUI.figure1;
            set(this.subjectGUI, 'CloseRequestFcn', @(o,e)this.stopExperiment);
            
            % Changing the background color of the graphs
            set(this.mainGraph, 'Color', this.backgrndClr);
            set(this.subjectGraph, 'Color', this.backgrndClr);
            
            % Setting the size of the feedback
            set(this.FBBoxes(1), 'FontSize', this.SUPERVISORFBSIZE);
            set([this.FBBoxes(2) this.FBBlindBox], 'FontSize', this.FBSize);
            set([this.FBBoxes this.FBBlindBox this.FBBlindBoxBack], 'BackgroundColor', this.FBClr);
            
            %
            if (this.blind && this.USEWHOLESCREENFBINBLIND && this.WHOLESCREENFBPERMANENT)
                set([this.FBBlindBox this.FBBlindBoxBack], 'Visible', 'on');
            end
            
            % Disabling the checkboxes
            set(this.mainGUI.verticalChk, 'Enable', 'off');
            set(this.mainGUI.feebackChk, 'Enable', 'off');
            set(this.mainGUI.blindChk, 'Enable', 'off');
            set(this.mainGUI.soundChk, 'Enable', 'off');
            set(this.mainGUI.randFBChk, 'Enable', 'off');
            set(this.mainGUI.subjRealFB, 'Enable', 'off');
            set(this.mainGUI.copySubjFB, 'Enable', 'off');
            set(this.mainGUI.clockAppear, 'Enable', 'off');
            
            % Drawing the lines
            this.mainLine = line(0, 0, 'Color', this.LINECOLOR);
            set(this.mainLine, 'Parent', this.mainGraph);
            set(this.mainLine, 'XData', [], 'YData', []);
            this.subjectLine = line(0, 0, 'Color', this.LINECOLOR);
            set(this.subjectLine, 'Parent', this.subjectGraph);
            set(this.subjectLine, 'XData', [], 'YData', []);
            
            % Drawing the divisory line
            h(1) = line([this.trialTime/2 this.trialTime/2], [this.minn this.maxx], 'Color', this.DIVISORYLINECOLOR);
            set(h(1), 'Parent', this.mainGraph);
            h(2) = line([this.trialTime/2 this.trialTime/2], [this.minn this.maxx], 'Color', this.DIVISORYLINECOLOR);
            set(h(2), 'Parent', this.subjectGraph);
            
            % Drawing target line
            h(3) = line([0 this.trialTime], [this.maxValue this.maxValue], 'Color', this.TARGETLINECOLOR);
            set(h(3), 'Parent', this.mainGraph);
            h(4) = line([0 this.trialTime], [this.maxValue this.maxValue], 'Color', this.TARGETLINECOLOR);
            set(h(4), 'Parent', this.subjectGraph);
            this.otherLineHandles = h;
            
            this.adjustGraphSize();
            % Resetting the number of trials to do (+1 for the first pause)
            this.trialsToExecute = this.trials +1;
            % Start timestamp
            this.startTimestamp = datestr(now);
            % Starting pause state
            if (this.pauseTimerActive)
                start(this.pauseInitTimer);
                start(this.pauseTimer);
                this.changeColorStopWatch('pause');
            else
                this.endOfPause();
            end
        end
        
        function stopExperiment(this)
            this.stopTimestamp = datestr(now);
            this.running = false;
            this.deactivateInput();
            if ishandle(this.subjectLine)
                delete(this.subjectLine);
            end
            if ishandle(this.mainLine)
                delete(this.mainLine);
            end
            delete(this.otherLineHandles);
            if ~isempty(this.maxAccelerationDotHandles) && any(ishandle(this.maxAccelerationDotHandles))
                delete(this.maxAccelerationDotHandles(ishandle(this.maxAccelerationDotHandles)));
            end
            if ishandle(this.subjectGUI)
                delete(this.subjectGUI);
            end
            if ~isfloat(this.mouseTimer) && isvalid(this.mouseTimer)
                stop(this.mouseTimer);
            end
            if ~isfloat(this.pauseTimer) && isvalid(this.pauseTimer)
                stop(this.pauseTimer);
            end
            if ~isfloat(this.pausePreFBTimer) && isvalid(this.pausePreFBTimer)
                stop(this.pausePreFBTimer);
            end
            if ~isfloat(this.pauseFBTimer) && isvalid(this.pauseFBTimer)
                stop(this.pauseFBTimer);
            end
            if ~isfloat(this.pausePostFBTimer) && isvalid(this.pausePostFBTimer)
                stop(this.pausePostFBTimer);
            end
            if ~isfloat(this.trialTimer) && isvalid(this.trialTimer)
                stop(this.trialTimer);
            end
            if ~isfloat(this.trialPreMaskTimer) && isvalid(this.trialPreMaskTimer)
                stop(this.trialPreMaskTimer);
            end
            if ~isfloat(this.trialPostMaskTimer) && isvalid(this.trialPostMaskTimer)
                stop(this.trialPostMaskTimer);
            end
            if ishandle(this.mainLine)
                delete(this.mainLine);
            end
            if ishandle(this.mainLine)
                delete(this.subjectLine);
            end
            set(this.mainGUI.configurationPanel, 'Visible', 'on');
            set(this.mainGUI.graph, 'Visible', 'off');
            for i=1:length(this.clocks)
                if ishandle(this.clocks(i))
                    set(this.clocks(i), 'String', '00 - 00:00');
                    set(this.clocks(i), 'BackgroundColor', 'default');
                end
            end
            this.maxAccelerationDotSubject = [];
            this.maxAccelerationDotMain = [];
            this.FBshown = false;
            this.FBhidden = false;
            this.FBdefault = false;
            
            % Enabling the checkboxes
            set(this.mainGUI.verticalChk, 'Enable', 'on');
            set(this.mainGUI.feebackChk, 'Enable', 'on');
            set(this.mainGUI.blindChk, 'Enable', 'on');
            set(this.mainGUI.soundChk, 'Enable', 'on');
            set(this.mainGUI.randFBChk, 'Enable', 'on');
            set(this.mainGUI.subjRealFB, 'Enable', 'on');
            set(this.mainGUI.copySubjFB, 'Enable', 'on');
            set(this.mainGUI.clockAppear, 'Enable', 'on');
            
            % Collecting the data of this attempt
            this.collectAndResetData();
        end
        
        function collectAndResetData(this)
            if ~isempty(this.subjectLineVisualTrace)
                % Data of the attempt
                experimentData.subjectLineVisualTrace = this.subjectLineVisualTrace;
                experimentData.subjectLineRealTrace = this.subjectLineRealTrace;
                experimentData.traceTimeStamps = this.traceTimeStamps;
                experimentData.realFeedbackShown = this.realFeedbackShown;
                experimentData.visualFeedbackShown = this.visualFeedbackShown;
                experimentData.realFeedbackPercentageShown = this.realFeedbackPercentageShown;
                experimentData.visualFeedbackPercentageShown = this.visualFeedbackPercentageShown;
                
                % Configuration of the attempt
                prop = properties(this);
                for p=prop'
                    experimentConfiguration.(p{1}) = this.(p{1});
                end
                experimentConfiguration.startTimestamp = this.startTimestamp;
                experimentConfiguration.stopTimestamp = this.stopTimestamp;
                
                attempt.experimentConfiguration = experimentConfiguration;
                attempt.experimentData = experimentData;
                this.totalDataStore{end+1} = attempt;
                
                % Reset variables
                this.subjectLineVisualTrace = {};
                this.subjectLineRealTrace = {};
                this.traceTimeStamps = {};
                this.realFeedbackShown = {};
                this.visualFeedbackShown = {};
                this.realFeedbackPercentageShown = {};
                this.visualFeedbackPercentageShown = {};
            end
        end
        
        function playSound(this)
            sound(sin(linspace(0,this.SOUNDBEEPFREQUENCYBEFORETRIAL,5000)), 10000);
        end
        
        function playFBSound(this)
            sound(sin(linspace(0,this.SOUNDBEEPFREQUENCYAFTERFB,5000)), 10000);
        end
    
        function value = CalculateAccelerationPeak(this, xdata, ydata)
            % Calculating when the signal goes over a certain threshold.
            from = find(ydata > this.MINIMUMPEAKDETECTIONLEVEL, 1, 'first');
            % Calculating, from the previous value, when does the signal
            % shows deceleration and calculating an amount of samples after
            % that.
            difsd = diff(ydata(from:end)) < 0;
            cumdur = cumsum(difsd) >= this.DECELERATIONDURATION;
            to = find(cumdur, 1, 'first');
            
            % If the deceleration is not found, drop the calculation
            if isempty(to)
                to = 0;
            end
            
            % Calculating timestamp of the maximum acceleration
            [value,i] = max(ydata(from:from+to));
            if ~isempty(value)
                value = [value xdata(from+i)];
            else
                value = this.INVALSTR;
            end
        end
        
        function saveFile(this)
            if ~isempty(this.totalDataStore)
                % Searching for a default name
                d = 1;
                pref = 0;
                while ~isempty(d)
                    defaultName = datestr(now, 'dd-mm-yyyy');
                    if (pref == 0)
                        extName = [defaultName '.mat'];
                    else
                        extName = [defaultName '--' num2str(pref) '.mat'];
                    end
                    d = dir(extName);
                    pref = pref+1;
                end
                
                [name, path] = uiputfile( ...
                    {'*.mat','MAT-files (*.mat)'; ...
                     '*.m;*.fig;*.mat;*.slx;*.mdl', 'MATLAB Files (*.m,*.fig,*.mat,*.slx,*.mdl)'; ...
                     '*.*',  'All Files (*.*)'}, ...
                'Save experiment data as:',...
                extName);
            
                name = [path, name];
                data = this.totalDataStore;
                if all(name)
                    save(name, 'data');
                else
                    assignin('base', 'ExperimentData', data);
                end
            end
        end
        
        function saveConfig(this)
            saveConf = false;
            if ~isempty(dir(this.CONFIGFILE))
                t = load(this.CONFIGFILE, 'this');
                t = t.this;
                prop = properties(t);
                for p=prop'
                    if (this.(p{1}) ~= t.(p{1}))
                        saveConf = true;
                        break;
                    end
                end
            else
                saveConf = true;
            end
            
            if saveConf && strcmp(questdlg('Do you want to save config?','Save config in file','Yes', 'No', 'No'),'Yes')
                save(this.CONFIGFILE, 'this');
            end
        end
    end
    
    %%% OTHER FUNCTIONS %%%
    methods (Access = private)
        function ret = isMouseInput(this)
            ret = (this.input == this.MOUSEINPUT);
        end
        
        function ret = isDAQInput(this)
            ret = (this.input == this.DAQINPUT);
        end
        
        function ret = isVisualFB(this)
            ret = any(this.FBType == this.VISUALFB);
        end
        
        function ret = isNumericFB(this)
            ret = any(this.FBType == this.NUMERICFB);
        end
        
        function setCallbacks(this)
            set(this.mainGUI.figure1, 'CloseRequestFcn', @(gui, event) this.delete());
            this.clocks(1) = this.mainGUI.timeBox;
            this.FBBoxes(1) = this.mainGUI.FBBox;
            this.mainGraph = this.mainGUI.graph;
            set(this.mainGraph, 'NextPlot', 'add');
            
            set(this.mainGUI.startButton, 'Callback', @this.startButtonPressed);
            set(this.mainGUI.stopButton, 'Callback', @this.stopButtonPressed);
            set(this.mainGUI.FBTypePop, 'Callback', @this.feedBackPopUpChange);
            set(this.mainGUI.INTypeBox, 'Callback', @this.inputPopUpChange);
            set(this.mainGUI.verticalChk, 'Callback', @this.verticalCheckBoxChange);
            set(this.mainGUI.feebackChk, 'Callback', @this.feedBackCheckBoxChange);
            set(this.mainGUI.blindChk, 'Callback', @this.blindCheckBoxChange);
            set(this.mainGUI.soundChk, 'Callback', @this.soundCheckBoxChange);
            set(this.mainGUI.clockAppear, 'Callback', @this.clockCheckBoxChange);
            set(this.mainGUI.randFBChk, 'Callback', @this.randFBCheckBoxChange);
            set(this.mainGUI.subjRealFB, 'Callback', @this.subjRealFBCheckBoxChange);
            set(this.mainGUI.copySubjFB, 'Callback', @this.copySubjFBCheckBoxChange);
            set(this.mainGUI.minBox, 'Callback', @this.minBoxChange);
            set(this.mainGUI.maxBox, 'Callback', @this.maxBoxChange);
            set(this.mainGUI.FBSizeBox, 'Callback', @this.FBSizeBoxChange);
            set(this.mainGUI.FBBBox, 'Callback', @this.FBBBoxChange);
            set(this.mainGUI.FBGBox, 'Callback', @this.FBGBoxChange);
            set(this.mainGUI.FBRBox, 'Callback', @this.FBRBoxChange);
            set(this.mainGUI.bckgrndBBox, 'Callback', @this.bckgrndBBoxChange);
            set(this.mainGUI.bckgrndGBox, 'Callback', @this.bckgrndGBoxChange);
            set(this.mainGUI.bckgrndRBox, 'Callback', @this.bckgrndRBoxChange);
            set(this.mainGUI.maskClrB, 'Callback', @this.maskBBoxChange);
            set(this.mainGUI.maskClrG, 'Callback', @this.maskGBoxChange);
            set(this.mainGUI.maskClrR, 'Callback', @this.maskRBoxChange);
            set(this.mainGUI.digitClrB, 'Callback', @this.digitBBoxChange);
            set(this.mainGUI.digitClrG, 'Callback', @this.digitGBoxChange);
            set(this.mainGUI.digitClrR, 'Callback', @this.digitRBoxChange);
            set(this.mainGUI.trialsBox, 'Callback', @this.trialsBoxChange);
            set(this.mainGUI.trialTimeBox, 'Callback', @this.trialTimeBoxChange);
            set(this.mainGUI.preFBTimeBox, 'Callback', @this.preFBTimeBoxChange);
            set(this.mainGUI.FBTimeBox, 'Callback', @this.FBTimeBoxChange);
            set(this.mainGUI.postFBTimeBox, 'Callback', @this.postFBTimeBoxChange);
            set(this.mainGUI.maxValueBox, 'Callback', @this.maxValueBoxChange);
            set(this.mainGUI.maskTimeBox, 'Callback', @this.maskTimeBoxChange);
            
            set(this.mainGUI.FBTypePop, 'String', this.FBTYPES);
            set(this.mainGUI.INTypeBox, 'String', this.INPUTTYPES);
            set(this.mainGUI.FBTypePop, 'Value', this.FBType);
            set(this.mainGUI.INTypeBox, 'Value', this.input);
            set(this.mainGUI.feebackChk, 'Value', this.feedBack);
            set(this.mainGUI.blindChk, 'Value', this.blind);
            set(this.mainGUI.soundChk, 'Value', this.soundEn);
            set(this.mainGUI.verticalChk, 'Value', this.vertical);
            set(this.mainGUI.clockAppear, 'Value', this.clockAppear);
            set(this.mainGUI.randFBChk, 'Value', this.randFB);
            set(this.mainGUI.subjRealFB, 'Value', this.subjectRealFB);
            set(this.mainGUI.copySubjFB, 'Value', this.subjectCopyFB);
            set(this.mainGUI.minBox, 'String', this.minn);
            set(this.mainGUI.maxBox, 'String', this.maxx);
            set(this.mainGUI.FBSizeBox, 'String', this.FBSize);
            set(this.mainGUI.FBBBox, 'String', this.FBClr(3));
            set(this.mainGUI.FBGBox, 'String', this.FBClr(2));
            set(this.mainGUI.FBRBox, 'String', this.FBClr(1));
            set(this.mainGUI.bckgrndBBox, 'String', this.backgrndClr(3));
            set(this.mainGUI.bckgrndGBox, 'String', this.backgrndClr(2));
            set(this.mainGUI.bckgrndRBox, 'String', this.backgrndClr(1));
            set(this.mainGUI.digitClrB, 'String', this.FBDigitClr(3));
            set(this.mainGUI.digitClrG, 'String', this.FBDigitClr(2));
            set(this.mainGUI.digitClrR, 'String', this.FBDigitClr(1));
            set(this.mainGUI.maskClrB, 'String', this.FBMaskClr(3));
            set(this.mainGUI.maskClrG, 'String', this.FBMaskClr(2));
            set(this.mainGUI.maskClrR, 'String', this.FBMaskClr(1));
            set(this.mainGUI.trialsBox, 'String', this.trials);
            set(this.mainGUI.trialTimeBox, 'String', this.trialTime);
            set(this.mainGUI.preFBTimeBox, 'String', this.preFBTime);
            set(this.mainGUI.FBTimeBox, 'String', this.FBTime);
            set(this.mainGUI.postFBTimeBox, 'String', this.postFBTime);
            set(this.mainGUI.maxValueBox, 'String', this.maxValue);
            set(this.mainGUI.maskTimeBox, 'String', this.maskAppearTime);
            
            set(this.mainGUI.feebackChk, 'UserData', this.feedBack);
            set(this.mainGUI.blindChk, 'UserData', this.blind);
            set(this.mainGUI.soundChk, 'UserData', this.soundEn);
            set(this.mainGUI.clockAppear, 'UserData', this.clockAppear);
            set(this.mainGUI.randFBChk, 'UserData', this.randFB);
            set(this.mainGUI.subjRealFB, 'UserData', this.subjectRealFB);
            set(this.mainGUI.copySubjFB, 'UserData', this.subjectCopyFB);
            set(this.mainGUI.minBox, 'UserData', this.minn);
            set(this.mainGUI.maxBox, 'UserData', this.maxx);
            set(this.mainGUI.FBSizeBox, 'UserData', this.FBSize);
            set(this.mainGUI.FBBBox, 'UserData', this.FBClr(3));
            set(this.mainGUI.FBGBox, 'UserData', this.FBClr(2));
            set(this.mainGUI.FBRBox, 'UserData', this.FBClr(1));
            set(this.mainGUI.bckgrndBBox, 'UserData', this.backgrndClr(3));
            set(this.mainGUI.bckgrndGBox, 'UserData', this.backgrndClr(2));
            set(this.mainGUI.bckgrndRBox, 'UserData', this.backgrndClr(1));
            set(this.mainGUI.digitClrB, 'UserData', this.FBDigitClr(3));
            set(this.mainGUI.digitClrG, 'UserData', this.FBDigitClr(2));
            set(this.mainGUI.digitClrR, 'UserData', this.FBDigitClr(1));
            set(this.mainGUI.maskClrB, 'UserData', this.FBMaskClr(3));
            set(this.mainGUI.maskClrG, 'UserData', this.FBMaskClr(2));
            set(this.mainGUI.maskClrR, 'UserData', this.FBMaskClr(1));
            set(this.mainGUI.trialsBox, 'UserData', this.trials);
            set(this.mainGUI.trialTimeBox, 'UserData', this.trialTime);
            set(this.mainGUI.preFBTimeBox, 'UserData', this.preFBTime);
            set(this.mainGUI.FBTimeBox, 'UserData', this.FBTime);
            set(this.mainGUI.postFBTimeBox, 'UserData', this.postFBTime);
            set(this.mainGUI.maxValueBox, 'UserData', this.maxValue);
            set(this.mainGUI.maskTimeBox, 'UserData', this.maskAppearTime);
        end
        
        function startButtonPressed(this, ~, ~)
            if (~this.running)
                this.running = true;
                this.startExperiment();
            end
        end
        
        function stopButtonPressed(this, ~, ~)
            if (this.running)
                this.stopExperiment();
                this.running = false;
            end
        end
        
        function feedBackPopUpChange(this, popUp, ~)
            this.FBType = get(popUp, 'Value');
        end
        
        function inputPopUpChange(this, popUp, ~)
            this.input = get(popUp, 'Value');
            this.setInput();
        end
        
        function verticalCheckBoxChange(this, checkBox, ~)
            this.vertical = get(checkBox, 'Value');
        end
        
        function feedBackCheckBoxChange(this, checkBox, ~)
            this.feedBack = get(checkBox, 'Value');
        end
        
        function blindCheckBoxChange(this, checkBox, ~)
            this.blind = get(checkBox, 'Value');
        end
        
        function clockCheckBoxChange(this, checkBox, ~)
            this.clockAppear = get(checkBox, 'Value');
        end
        
        function soundCheckBoxChange(this, checkBox, ~)
            this.soundEn = get(checkBox, 'Value');
        end
        
        function randFBCheckBoxChange(this, checkBox, ~)
            this.randFB = get(checkBox, 'Value');
        end
        
        function subjRealFBCheckBoxChange(this, checkBox, ~)
            this.subjectRealFB = get(checkBox, 'Value');
        end
        
        function copySubjFBCheckBoxChange(this, checkBox, ~)
            this.subjectCopyFB = get(checkBox, 'Value');
        end
        
        function minBoxChange(this, box, ~)
            this.minn = Ballistic.checkNumberBox(box);
        end
        
        function maxBoxChange(this, box, ~)
            this.maxx = Ballistic.checkNumberBox(box);
        end
        
        function FBSizeBoxChange(this, box, ~)
            this.FBSize = Ballistic.checkNumberBox(box);
        end
        
        function FBBBoxChange(this, box, ~)
            this.FBClr(3) = Ballistic.checkNumberBox(box);
        end
        
        function FBGBoxChange(this, box, ~)
            this.FBClr(2) = Ballistic.checkNumberBox(box);
        end
        
        function FBRBoxChange(this, box, ~)
            this.FBClr(1) = Ballistic.checkNumberBox(box);
        end
        
        function bckgrndBBoxChange(this, box, ~)
            this.backgrndClr(3) = Ballistic.checkNumberBox(box);
        end
        
        function bckgrndGBoxChange(this, box, ~)
            this.backgrndClr(2) = Ballistic.checkNumberBox(box);
        end
        
        function bckgrndRBoxChange(this, box, ~)
            this.backgrndClr(1) = Ballistic.checkNumberBox(box);
        end
        
        function maskBBoxChange(this, box, ~)
            this.FBMaskClr(3) = Ballistic.checkNumberBox(box);
        end
        
        function maskGBoxChange(this, box, ~)
            this.FBMaskClr(2) = Ballistic.checkNumberBox(box);
        end
        
        function maskRBoxChange(this, box, ~)
            this.FBMaskClr(1) = Ballistic.checkNumberBox(box);
        end
        
        function digitBBoxChange(this, box, ~)
            this.FBDigitClr(3) = Ballistic.checkNumberBox(box);
        end
        
        function digitGBoxChange(this, box, ~)
            this.FBDigitClr(2) = Ballistic.checkNumberBox(box);
        end
        
        function digitRBoxChange(this, box, ~)
            this.FBDigitClr(1) = Ballistic.checkNumberBox(box);
        end
        
        function trialsBoxChange(this, box, ~)
            this.trials = Ballistic.checkNumberBox(box);
        end
        
        function trialTimeBoxChange(this, box, ~)
            this.trialTime = Ballistic.checkNumberBox(box);
        end
        
        function preFBTimeBoxChange(this, box, ~)
            this.preFBTime = Ballistic.checkNumberBox(box);
        end
        
        function FBTimeBoxChange(this, box, ~)
            this.FBTime = Ballistic.checkNumberBox(box);
        end
        
        function postFBTimeBoxChange(this, box, ~)
            this.postFBTime = Ballistic.checkNumberBox(box);
        end
        
        function maxValueBoxChange(this, box, ~)
            this.maxValue = Ballistic.checkNumberBox(box);
        end
        
        function maskTimeBoxChange(this, box, ~)
            this.maskAppearTime = Ballistic.checkNumberBox(box);
        end
    end
    
    methods (Static)
        function number = checkNumberBox(box)
            number = str2double(get(box, 'String'));
            if (isempty(number))
                number = get(box, 'UserData');
                set(box, 'String', number);
            end
        end
        function number = checkTimeBox(box, modulus)
            number = str2double(get(box, 'String'));
            if mod(number, modulus) ~= 0
                w = warndlg('The time cannot be accurately calculated with the current precision', 'Overflow of precision!', 'modal');
                uiwait(w);
                number = [];
            end
            if (isempty(number))
                number = get(box, 'UserData');
                set(box, 'String', number);
            end
        end
    end
end
