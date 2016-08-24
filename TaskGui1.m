function varargout = TaskGui1(varargin)
% TASKGUI1 MATLAB code for TaskGui1.fig
%      TASKGUI1, by itself, creates a new TASKGUI1 or raises the existing
%      singleton*.
%
%      H = TASKGUI1 returns the handle to a new TASKGUI1 or the handle to
%      the existing singleton*.
%
%      TASKGUI1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TASKGUI1.M with the given input arguments.
%
%      TASKGUI1('Property','Value',...) creates a new TASKGUI1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TaskGui1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TaskGui1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TaskGui1

% Last Modified by GUIDE v2.5 15-May-2013 13:21:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TaskGui1_OpeningFcn, ...
                   'gui_OutputFcn',  @TaskGui1_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT
end

% --- Executes just before TaskGui1 is made visible.
function TaskGui1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TaskGui1 (see VARARGIN)

% Choose default command line output for TaskGui1
handles.output = hObject;

%%%%%%%%%% IMPORTANT GROUNDWORK FOR THE GUI IS PLACED HERE %%%%%%%%%%%%%%%

% GET SOME CRUCIAL DIRECTORIES -- THESE DIRECTORIES MUST EXIST
% Present working directory, location of the GUI and protocol files
handles.taskPath = sprintf('%s/',pwd);
% Settings directory, settings file should be kept here
handles.settingsPath = sprintf('%s/Settings/',pwd);
% Output directory, all data will be saved here
%handles.outputPath1 = sprintf('%s/Output/',pwd);
handles.outputPath1 = '/home/nielsenlab/behavdata/';
handles.outputPath2 = '/media/ferretmac/data';

% CREATE THE STRUCTURES USED BY PROTOCOLS
handles.A = struct; % Auxilliary values that don't fit into S, P, or D
handles.S = struct; % Settings for the protocol, NOT changed while running
handles.P = struct; % Parameters for the protocol, changeable values
handles.D = struct; % Protocol data

% THESE VARIABLES CONTROL RUN LOOP
handles.runTask = false;
handles.stopTask = false;
handles.abortTask = false;

% SET ACCESS TO GUI CONTROLS
% Settings panel -- always visible
set(handles.SaveSettingsFile,'Enable','Off');
% Actions panel -- always visible
set(handles.InitButton,'Enable','Off');
set(handles.ClearButton,'Enable','Off');
set(handles.RunButton,'Enable','Off');
set(handles.PauseButton,'Enable','Off');
set(handles.AbortButton,'Enable','Off');
% Output panel -- only visible with a loaded protocol
set(handles.OutputPanel,'Visible','Off');
% Parameters panel -- only visible with a loaded protocol
set(handles.ParametersPanel,'Visible','Off');

% SET GUI STATUS
tstring = 'Please load a settings file...';
set(handles.StatusText,'String',tstring);
% The task light is a neutral gray when no protocol is loaded
ChangeLight(handles.TaskLight,[.5 .5 .5]);

% UPDATE HANDLES STRUCTURE
guidata(hObject,handles);

end

% --- Outputs from this function are returned to the command line.
function varargout = TaskGui1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end



%%%%%%%%%% SETTINGS PANEL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in BrowseSettingsFiles. SELECT SETTINGS ---
function BrowseSettingsFiles_Callback(hObject, eventdata, handles) %#ok<*DEFNU,*INUSL>
% hObject    handle to BrowseSettingsFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% SETTINGS FILE SELECTION
% Enter the settings directory
cd(handles.settingsPath);
% Prompt the user to select a settings file
[handles.tempFile handles.tempFilePath] = uigetfile('*.m',...
    'Choose a settings file');
% Return to the task directory, where the protocol will be run
cd(handles.taskPath);

% FOR A VALID SELECTION, READY GUI TO INITIALIZE A PROTOCOL
if handles.tempFile
    % Place the settings file and path into handles
    handles.settingsFile = handles.tempFile;
    handles.settingsFilePath = handles.tempFilePath;
    % Display the chosen settings file in the settings panel
    set(handles.SettingsFileText,'String',handles.settingsFile);
    % Allow access to protocol initialization
    set(handles.InitButton,'Enable','On');
    % Update GUI status
    tstring = 'Ready to initialize protocol...';
    set(handles.StatusText,'String',tstring);
end

% UPDATE HANDLES STRUCTURE
guidata(hObject,handles);

end

% --- Executes on button press in SaveSettingsFile. SAVE SETTINGS --------
function SaveSettingsFile_Callback(hObject, eventdata, handles)
% hObject    handle to SaveSettingsFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Change into the directory of the chosen settings file -- this may not be
% settings if the user picked a settings file elsewhere
cd(handles.settingsFilePath);

% Prompt user to select a new settings file name
[handles.newSettingsFile handles.newSettingsFilePath] = uiputfile('',...
    'save settings file as');
% Return to the task directory
cd(handles.taskPath);

% If a a valid file name was chosen for the new settings
if ischar(handles.newSettingsFile)
    % Check the file termination -- IT MUST BE A '.m' FILE, default if left
    % unspecified is a '.slx' file. The following lines will change that to
    % a '.m'
    termInd = strfind(handles.newSettingsFile,'.');
    if isempty(termInd)
        handles.newSettingsFile = strcat(handles.newSettingsFile,'.m');
    elseif ~strcmp('.m',handles.newSettingsFile(termInd(1):end))
        handles.newSettingsFile = strcat(handles.newSettingsFile(1:termInd(1)),'m');
    end
    % Create the new file
    CreateNewSettingsFile(handles.settingsFile,handles.settingsFilePath,...
        handles.newSettingsFile,handles.newSettingsFilePath,handles.P);
    % Update settings file and path
    handles.settingsFile = handles.newSettingsFile;
    handles.settingsFilePath = handles.newSettingsFilePath;
    % Update settings file text
    set(handles.SettingsFileText,'String',handles.settingsFile);
end

% Update handles structure
guidata(hObject,handles);

end



%%%%%%%%%% ACTIONS PANEL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in InitButton. INITIALIZE -----------------
function InitButton_Callback(hObject, eventdata, handles)
% hObject    handle to InitButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% PREPARE THE GUI FOR INITIALIZING THE PROTOCOL
% Update GUI status
tstring = 'Initializing...';
set(handles.StatusText,'String',tstring);
% The task light is blue only during protocol initialization
ChangeLight(handles.TaskLight,[.2 .2 1]);
% Temporarily turn off the only two enabled buttons during initialization
set(handles.BrowseSettingsFiles,'Enable','Off');
set(handles.InitButton,'Enable','Off');
% Effect these changes on the GUI immediately
guidata(hObject, handles); drawnow;

% GET PROTOCOL SETTINGS
cd(handles.settingsFilePath);
cmd = sprintf('[handles.A handles.S handles.P] = %s;',handles.settingsFile(1:end-2));
eval(cmd);
cd(handles.taskPath);

% INITIALIZE THE PROTOCOL
cmd = sprintf('handles.A = %s(handles.S,handles.A);',handles.S.initFunc);
eval(cmd);

% CREATE COMMANDS FOR THE TRIAL LOOP
handles.nextCmd = sprintf('[A P] = %s(S,P,A);',handles.S.nextFunc);
handles.runCmd = sprintf('[A handles] = %s(S,P,A,hObject);',handles.S.runFunc);
handles.endCmd = sprintf('D = %s(D,A);',handles.S.endFunc);

% SET UP THE OUTPUT PANEL
% Get the output file name components
pre = handles.A.outputPrefix;           % PREFIX
set(handles.EditPrefix,'String',pre);
dmy = datestr(now,'ddmmyy');            % DATE
set(handles.EditDate,'String',dmy);
sub = handles.A.subject;                % SUBJECT
set(handles.EditSubject,'String',sub);
i = 0; suf = '0';                       % SUFFIX
% Generate the file name
handles.A.outputFile = strcat(pre,'_',dmy,'_',sub,'_',suf);
% If the file name already exists, iterate the suffix to a nonexistant file
while exist(strcat(handles.outputPath1,handles.A.outputFile,'.mat'),'file')
    i = i+1; suf = num2str(i);
    handles.A.outputFile = strcat(pre,'_',dmy,'_',sub,'_',suf);
end
% Show the file name on the GUI
set(handles.EditSuffix,'String',suf);
set(handles.OutputFileText,'String',handles.A.outputFile);
% Note that a new output file is being used
handles.A.newOutput = 1;

% SET UP THE PARAMETERS PANEL
% Get strings for the parameters list
handles.pNames = fieldnames(handles.P);         % pNames are the actual parameter names
handles.pList = cell(size(handles.pNames,1),1); % pList is the list of parameter names with values
for i = 1:size(handles.pNames,1);
    pName = handles.pNames{i};
    tName = sprintf('%s = %2g',pName,handles.P.(pName));
    handles.pList{i,1} = tName;
end
set(handles.ParametersList,'String',handles.pList);
% For the highlighted parameter, provide a description and editable value
set(handles.ParametersList,'Value',1);
set(handles.ParameterText,'String',handles.S.(handles.pNames{1}));
set(handles.ParameterEdit,'String',num2str(handles.P.(handles.pNames{1})));

% TRIALS SECTION OF THE PARAMETERS PANEL
handles.A.j = 1; handles.A.finish = handles.S.finish;
set(handles.TrialCountText,'String',num2str(handles.A.j-1));
set(handles.TrialFinishText,'String',num2str(handles.A.finish));

% UPDATE ACCESS TO CONTROLS
% Settings panel -- always visible
set(handles.BrowseSettingsFiles,'Enable','Off');
set(handles.SaveSettingsFile,'Enable','On');
% Actions panel -- always visible
set(handles.ClearButton,'Enable','On');
set(handles.RunButton,'Enable','On');
% Output panel -- only visible with a loaded protocol
set(handles.OutputPanel,'Visible','On');
% Parameters panel -- only visible with a loaded protocol
set(handles.ParametersPanel,'Visible','On');

% UPDATE GUI STATUS
tstring = sprintf('%s initialized.',handles.S.protocolTitle);
set(handles.StatusText,'String',tstring);
% Now that a protocol is loaded (but not running), task light is red
ChangeLight(handles.TaskLight,[1 0 0]);

% UPDATE HANDLES STRUCTURE
guidata(hObject,handles);

end

% --- Executes on button press in ClearButton. CLEAR ---------------------
function ClearButton_Callback(hObject, eventdata, handles)
% hObject    handle to ClearButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% CLEAR THE SETTINGS FILE AND OUTPUT FILE
set(handles.SettingsFileText,'String','');
set(handles.OutputFileText,'String','');

% CLEAR THE TASK STRUCTURES
handles.A = struct;
handles.S = struct;
handles.P = struct;
handles.D = struct;

% UPDATE ACCESS TO CONTROLS
set(handles.BrowseSettingsFiles,'Enable','On');
set(handles.SaveSettingsFile,'Enable','Off');
set(handles.InitButton,'Enable','Off');
set(handles.RunButton,'Enable','Off');
set(handles.PauseButton,'Enable','Off');
set(handles.ClearButton,'Enable','Off');
set(handles.OutputPanel,'Visible','Off');
set(handles.ParametersPanel,'Visible','Off');

% UPDATE GUI STATUS
tstring = 'Load a settings file to proceed...';
set(handles.StatusText,'String',tstring);
% BLANK TASK LIGHT
ChangeLight(handles.TaskLight,[.5 .5 .5]);

% UPDATE HANDLES STRUCTURE
guidata(hObject,handles);

end

% --- Executes on button press in RunButton. RUN -------------------------
function RunButton_Callback(hObject, eventdata, handles)
% hObject    handle to RunButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% SET THE TASK TO RUN
handles.runTask = true;

% SET TASK LIGHT TO GREEN
ChangeLight(handles.TaskLight,[0 1 0]);

% UPDATE ACCESS TO CONTROLS
set(handles.RunButton,'Enable','Off');
set(handles.ClearButton,'Enable','Off');
set(handles.PauseButton,'Enable','On');
set(handles.AbortButton,'Enable','On');
set(handles.EditPrefix,'Enable','Off');
set(handles.EditDate,'Enable','Off');
set(handles.EditSubject,'Enable','Off');
set(handles.EditSuffix,'Enable','Off');
set(handles.SaveSettingsFile,'Enable','Off');

% UPDATE GUI STATUS
tstring = sprintf('%s running...',handles.S.protocolTitle);
set(handles.StatusText,'String',tstring);
guidata(hObject,handles); drawnow;

% MOVE TASK RELATED STRUCTURES OUT OF HANDLES FOR THE RUN LOOP -- this way
% if a callback interrupts the run task function, we can update any changes
% the interrupting callback makes to handles without affecting those task
% related structures.
A = handles.A;
S = handles.S;
P = handles.P;
D = handles.D;

% RUN TRIALS
while handles.runTask && A.j <= A.finish
    
    % 'pause', 'drawnow', 'figure', 'getframe', or 'waitfor' will allow
    % other callbacks to interrupt this run task callback
    
    % EXECUTE THE NEXT TRIAL COMMAND, IF THE TRIAL WAS NOT ABORTED
    if ~handles.abortTask
        eval(handles.nextCmd);
        % UPDATE P AFTER NEXT TRIAL AGAIN IN CASE TRIALS LIST CHANGE IT
        handles.P = P;
        for i = 1:size(handles.pNames,1);
            pName = handles.pNames{i};
            tName = sprintf('%s = %2g',pName,handles.P.(pName));
            handles.pList{i,1} = tName;
        end
        set(handles.ParametersList,'String',handles.pList);
        % UPDATE HANDLES FROM ANY CHANGES DURING NEXT TRIAL
        guidata(hObject,handles);
        % ALLOW OTHER CALLBACKS INTO THE QUEUE AND UPDATE HANDLES
        pause(.001); handles = guidata(hObject);
    end
    
    % EXECUTE THE RUN TRIAL COMMAND, IF THE TRIAL WAS NOT ABORTED
    if ~handles.abortTask
        eval(handles.runCmd);
        % UPDATE HANDLES FROM ANY CHANGES DURING RUN TRIAL
        guidata(hObject,handles);
        % ALLOW OTHER CALLBACKS INTO THE QUEUE AND UPDATE HANDLES
        pause(.001); handles = guidata(hObject);
    end
    
    % EXECUTE THE FINISH TRIAL COMMAND, IF THE TRIAL WAS NOT ABORTED
    if ~handles.abortTask
        eval(handles.endCmd);
        % UPDATE HANDLES FROM ANY CHANGES DURING FINISH TRIAL
        guidata(hObject,handles);
        % ALLOW OTHER CALLBACKS INTO THE QUEUE AND UPDATE HANDLES
        pause(.001); handles = guidata(hObject);
    end
    
    % SAVE DATA AND UPDATE TRIAL COUNT, IF THE TRIAL WAS NOT ABORTED
    if ~handles.abortTask
        % SAVE DATA - first locally, then on network for backup
        cd(handles.outputPath1);             % goto output directory
        D.P(A.j) = P;                       % save parameters for the trial
        save(handles.A.outputFile,'S','D'); % save data and settings structures
        cd(handles.outputPath2);             % goto output directory
        save(handles.A.outputFile,'S','D'); % save data and settings structures
        cd(handles.taskPath);               % return to task directory
        % ALLOW OTHER CALLBACKS INTO THE QUEUE AND UPDATE HANDLES
        pause(.001); handles = guidata(hObject);
        
        % UPDATE TRIAL COUNT
        A.j = A.j+1;
        set(handles.TrialCountText,'String',num2str(A.j-1));
        guidata(hObject,handles);
    end
    
    % UPDATE THE PARAMETERS
    P = handles.P;
    for i = 1:size(handles.pNames,1);
        pName = handles.pNames{i};
        tName = sprintf('%s = %2g',pName,handles.P.(pName));
        handles.pList{i,1} = tName;
    end
    set(handles.ParametersList,'String',handles.pList);
    A.finish = handles.A.finish; % Finish too
    
    % STOP RUN TASK IF SET TO STOP OR ABORT
    if handles.stopTask || handles.abortTask;
        handles.runTask = false;
    end
end

% NO TASK RUNNING FLAGS SHOULD BE ON ANYMORE
handles.runTask = false;
handles.stopTask = false;
handles.abortTask = false;

% UPDATE THE TASK RELATED STRUCTURES IN HANDLES WHEN EXITING THE RUN LOOP
handles.A = A;
handles.S = S;
handles.P = P;
handles.D = D;

% UPDATE ACCESS TO CONTROLS
set(handles.RunButton,'Enable','On');
set(handles.ClearButton,'Enable','On');
set(handles.PauseButton,'Enable','Off');
set(handles.AbortButton,'Enable','Off');
set(handles.EditPrefix,'Enable','On');
set(handles.EditDate,'Enable','On');
set(handles.EditSubject,'Enable','On');
set(handles.EditSuffix,'Enable','On');
set(handles.SaveSettingsFile,'Enable','On');

% UPDATE GUI STATUS
tstring = sprintf('%s ready.',handles.S.protocolTitle);
set(handles.StatusText,'String',tstring);
% SET TASK LIGHT TO RED
ChangeLight(handles.TaskLight,[1 0 0]);

% UPDATE HANDLES STRUCTURE
guidata(hObject,handles);

end

% --- Executes on button press in PauseButton. PAUSE ---------------------
function PauseButton_Callback(hObject, eventdata, handles)
% hObject    handle to PauseButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Pause button can also act as an unpause button
switch handles.stopTask
    case 0
        handles.stopTask = true;
        % SET TASK LIGHT TO ORANGE
        ChangeLight(handles.TaskLight,[.9 .7 .2]);
    case 1
        handles.stopTask = false;
        % SET TASK LIGHT BACK TO GREEN
        ChangeLight(handles.TaskLight,[0 1 0]);
end

% UPDATE HANDLES STRUCTURE
guidata(hObject,handles);

end

% --- Executes on button press in AbortButton.
function AbortButton_Callback(hObject, eventdata, handles)
% hObject    handle to AbortButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% SET THE TASK TO ABORT
handles.abortTask = 1;

% SET TASK LIGHT TO ORANGE
ChangeLight(handles.TaskLight,[.9 .7 .2]);

% UPDATE HANDLES STRUCTURE
guidata(hObject,handles);

end



%%%%%%%%%% OUTPUT PANEL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function EditPrefix_Callback(hObject, eventdata, handles)
% hObject    handle to EditPrefix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% GET NEW PREFIX
pre = get(hObject,'String');
% GET OTHER OUTPUT FILE NAME COMPONENTS
dmy = get(handles.EditDate,'String');
sub = get(handles.EditSubject,'String');
suf = get(handles.EditSuffix,'String');

% UPDATE OUTPUT FILE NAME
handles = UpdateOutputFile(pre,dmy,sub,suf,handles);

% UPDATE HANDLES STRUCTURE
guidata(hObject,handles);

end
% --- Executes during object creation, after setting all properties.
function EditPrefix_CreateFcn(hObject, eventdata, handles) %#ok<*INUSD>
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function EditDate_Callback(hObject, eventdata, handles)
% hObject    handle to EditDate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% GET NEW DATE
dmy = get(hObject,'String');
% GET OTHER OUTPUT FILE NAME COMPONENTS
pre = get(handles.EditPrefix,'String');
sub = get(handles.EditSubject,'String');
suf = get(handles.EditSuffix,'String');

% UPDATE OUTPUT FILE NAME
handles = UpdateOutputFile(pre,dmy,sub,suf,handles);

% UPDATE HANDLES STRUCTURE
guidata(hObject,handles);

end
% --- Executes during object creation, after setting all properties.
function EditDate_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function EditSubject_Callback(hObject, eventdata, handles)
% hObject    handle to EditSubject (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% GET NEW DATE
sub = get(hObject,'String');
% GET OTHER OUTPUT FILE NAME COMPONENTS
pre = get(handles.EditPrefix,'String');
dmy = get(handles.EditDate,'String');
suf = get(handles.EditSuffix,'String');

% UPDATE OUTPUT FILE NAME
handles = UpdateOutputFile(pre,dmy,sub,suf,handles);

% UPDATE HANDLES STRUCTURE
guidata(hObject,handles);

end
% --- Executes during object creation, after setting all properties.
function EditSubject_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function EditSuffix_Callback(hObject, eventdata, handles)
% hObject    handle to EditSuffix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% GET NEW DATE
suf = get(hObject,'String');
% GET OTHER OUTPUT FILE NAME COMPONENTS
pre = get(handles.EditPrefix,'String');
dmy = get(handles.EditDate,'String');
sub = get(handles.EditSubject,'String');

% UPDATE OUTPUT FILE NAME
handles = UpdateOutputFile(pre,dmy,sub,suf,handles);

% UPDATE HANDLES STRUCTURE
guidata(hObject,handles);

end
% --- Executes during object creation, after setting all properties.
function EditSuffix_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end



%%%%%%%%%% PARAMETERS PANEL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function EditTrialFinish_Callback(hObject, eventdata, handles)
% hObject    handle to EditTrialFinish (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get the new count
newFinal = round(str2double(get(hObject,'String')));
% Make sure the new final trial is a positive integer
if newFinal > 0
    % Update the final trial
    handles.A.finish = newFinal;
    % Set the count
    set(handles.TrialFinishText,'String',get(hObject,'String'));
end
% Clear the edit string
set(hObject,'String','');

% Update handles structure
guidata(hObject,handles);
end
% --- Executes during object creation, after setting all properties.
function EditTrialFinish_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in ParametersList.
function ParametersList_Callback(hObject, eventdata, handles)
% hObject    handle to ParametersList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get the index of the selected field
i = get(hObject,'Value');
% Set the parameter text to a description of the parameter
set(handles.ParameterText,'String',handles.S.(handles.pNames{i}));
% Set the parameter edit to the current value of that parameter
set(handles.ParameterEdit,'String',num2str(handles.P.(handles.pNames{i})));

% Update handles structure
guidata(hObject,handles);
end
% --- Executes during object creation, after setting all properties.
function ParametersList_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function ParameterEdit_Callback(hObject, eventdata, handles)
% hObject    handle to ParameterEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get the new parameter value
pValue = str2double(get(hObject,'String'));
% Get the parameter name
pName = handles.pNames{get(handles.ParametersList,'Value')};
% If the parameter value is a number
if ~isnan(pValue)
    % Change the parameter value
    handles.P.(pName) = pValue;
    % Update the parameter list immediately if not in the run loop
    if ~handles.runTask
        tName = sprintf('%s = %2g',pName,handles.P.(pName));
        handles.pList{get(handles.ParametersList,'Value')} = tName;
        set(handles.ParametersList,'String',handles.pList);
    end
else
    % Revert the parameter text to the previous value
    set(hObject,'String',num2str(handles.P.(pName)));
end

% Update handles structure
guidata(hObject,handles);
end
% --- Executes during object creation, after setting all properties.
function ParameterEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

%%%%%%%%%% SUPPORT FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- UPDATES THE OUTPUT FILE NAME ---------------------------------------
function handles = UpdateOutputFile(pre,dmy,sub,suf,handles)

% CREATE NEW OUTPUT FILE
handles.A.outputFile = strcat(pre,'_',dmy,'_',sub,'_',suf);

% NOW CHECK IF FILE EXISTS
i = 0; existFlag = 0;
while exist(strcat(handles.outputPath1,handles.A.outputFile,'.mat'),'file')
    existFlag = 1;
    i = i+1; suf = num2str(i);
    handles.A.outputFile = strcat(pre,'_',dmy,'_',sub,'_',suf);
end
% UPON REACHING A NONEXISTING OUTPUT, SET THE FILE NAME
set(handles.EditSuffix,'String',suf);
set(handles.OutputFileText,'String',handles.A.outputFile);
% NOTE THAT A NEW OUTPUT FILE IS BEING USED
handles.A.newOutput = 1;
% RESET DATA STRUCTURE AND SETTINGS
handles.D = struct;
cd(handles.settingsFilePath);
cmd = sprintf('[A handles.S] = %s;',handles.settingsFile(1:end-2));
eval(cmd);
cd(handles.taskPath);
% RESET ITERATOR AND STOP POINT FOR TRIALS
handles.A.j = 1; handles.A.finish = handles.S.finish;
set(handles.TrialCountText,'String','0');
set(handles.TrialFinishText,'String',num2str(handles.A.finish));
% WARN ABOUT HAVING HAD TO START A SEARCH FOR AN UNUSED FILE
if existFlag
    OutputWarning('title','Output Exists!','string',...
        sprintf('File Name Already Exists!\nChanged File Suffix to %s.',suf));
end
end

% --- CHANGES THE RUN TASK LIGHT -----------------------------------------
function ChangeLight(h,col)
% THIS FUNCTION CHANGES THE TASK LIGHT
scatter(h,.5,.5,600,'o','MarkerEdgeColor','k','MarkerFaceColor',col);
axis(h,[0 1 0 1]); bkgd = [.931 .931 .931];
set(h,'XColor',bkgd,'YColor',bkgd,'Color',bkgd);
end

% --- CREATES NEW SETTINGS FILE ------------------------------------------
function CreateNewSettingsFile(oldFile,oldFilePath,newFile,newFilePath,P)

% Open the old settings file
fid = fopen(strcat(oldFilePath,oldFile));

% Get the lines of text in the file
fLines = textscan(fid,'%s','delimiter','\n');
fLines = fLines{1};
fclose(fid);

% Update function call
fLines{1} = horzcat('function [A S P] = ',newFile(1:end-2));

% Get parameter names
pNames = fieldnames(P);

% Update fLines with the new parameter values
for i = 1:length(pNames)
    % For current parameter name and string
    pName = pNames{i};
    pString = strcat('P.',pName);
    % Find the file line currently assigning the parameter value, if
    % multiple exist, this will only find the last instance
    pIndex = find(strncmp(pString,fLines,length(pString)),1,'last');
    % Create a new line assigning the current parameter value
    fLine = horzcat(pString,' = ',num2str(P.(pName)),';');
    % Add on any comments in the file line
    cPos = strfind(fLines{pIndex},'%');
    % If a comment exists, add it to the new line
    if ~isempty(cPos)
        cString = fLines{pIndex}(cPos(1):end);
        if length(fLine) < cPos(1)
            nSpaces = cPos(1)-length(fLine);
            fLine = horzcat(fLine,repmat(' ',1,nSpaces),cString); %#ok<AGROW>
        else
            fLine = strcat(fLine,cString);
        end
    end
    % Place the new line in fLines
    fLines{pIndex} = fLine;
end

% Open new settings file
newSettings = strcat(newFilePath,newFile);
fid = fopen(newSettings,'w');
% Write the the file lines to the new settings file
for i = 1:length(fLines);
    fwrite(fid,sprintf('%s\n',fLines{i}));
end
fclose(fid);

end
