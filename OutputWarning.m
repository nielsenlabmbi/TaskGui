function varargout = OutputWarning(varargin)
% OUTPUTWARNING MATLAB code for OutputWarning.fig
%      OUTPUTWARNING by itself, creates a new OUTPUTWARNING or raises the
%      existing singleton*.
%
%      H = OUTPUTWARNING returns the handle to a new OUTPUTWARNING or the handle to
%      the existing singleton*.
%
%      OUTPUTWARNING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OUTPUTWARNING.M with the given input arguments.
%
%      OUTPUTWARNING('Property','Value',...) creates a new OUTPUTWARNING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before OutputWarning_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to OutputWarning_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help OutputWarning

% Last Modified by GUIDE v2.5 03-May-2013 13:10:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @OutputWarning_OpeningFcn, ...
                   'gui_OutputFcn',  @OutputWarning_OutputFcn, ...
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

% --- Executes just before OutputWarning is made visible.
function OutputWarning_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to OutputWarning (see VARARGIN)

% Choose default command line output for OutputWarning
handles.output = 'Yes';

% Update handles structure
guidata(hObject, handles);

% Insert custom Title and Text if specified by the user
if(nargin > 3)                          % USER SPECIFIED TEXT IF BOTH A TITLE AND STRING ARE PROVIDED
    for index = 1:2:(nargin-3),
        if nargin-3==index, break, end
        switch lower(varargin{index})
         case 'title' % TAKE THE STRING AFTER TITLE DESIGNATION
          set(hObject, 'Name', varargin{index+1}); % NAME THE FIGURE
         case 'string' % TAKE THE STRING AFTER STRING DESIGNATION
          set(handles.warningText, 'String', varargin{index+1}); % SET THIS AS WARNING TEXT
        end
    end
end

% Determine the position of the dialog - centered on the callback figure
% if available, else, centered on the screen
FigPos=get(0,'DefaultFigurePosition');
OldUnits = get(hObject, 'Units');
set(hObject, 'Units', 'pixels');
OldPos = get(hObject,'Position');
FigWidth = OldPos(3);
FigHeight = OldPos(4);
if isempty(gcbf)
    ScreenUnits=get(0,'Units');
    set(0,'Units','pixels');
    ScreenSize=get(0,'ScreenSize');
    set(0,'Units',ScreenUnits);

    FigPos(1)=1/2*(ScreenSize(3)-FigWidth);
    FigPos(2)=2/3*(ScreenSize(4)-FigHeight);
else
    GCBFOldUnits = get(gcbf,'Units');
    set(gcbf,'Units','pixels');
    GCBFPos = get(gcbf,'Position');
    set(gcbf,'Units',GCBFOldUnits);
    FigPos(1:2) = [(GCBFPos(1) + GCBFPos(3) / 2) - FigWidth / 2, ...
                   (GCBFPos(2) + GCBFPos(4) / 2) - FigHeight / 2];
end
FigPos(3:4)=[FigWidth FigHeight];
set(hObject, 'Position', FigPos);
set(hObject, 'Units', OldUnits);

% Show a warning icon from dialogicons.mat
load dialogicons.mat

IconData=warnIconData;
warnIconMap(256,:) = get(handles.figure1, 'Color');
IconCMap=warnIconMap;

Img=image(IconData, 'Parent', handles.warningSign);
set(handles.figure1, 'Colormap', IconCMap);

set(handles.warningSign, ...
    'Visible', 'off', ...
    'YDir'   , 'reverse'       , ...
    'XLim'   , get(Img,'XData'), ...
    'YLim'   , get(Img,'YData')  ...
    );

% Make the GUI modal
set(handles.figure1,'WindowStyle','modal')

% UIWAIT makes OutputWarning wait for user response (see UIRESUME)
uiwait(handles.figure1);

end

% --- Outputs from this function are returned to the command line.
function varargout = OutputWarning_OutputFcn(~, ~, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% The figure can be deleted now
delete(handles.figure1);

end

% --- Executes on button press in ackButton.
function ackButton_Callback(hObject, ~, handles) %#ok<*DEFNU>
% hObject    handle to ackButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = get(hObject,'String');

% Update handles structure
guidata(hObject, handles);

% Use UIRESUME instead of delete because the OutputFcn needs
% to get the updated handles structure.
uiresume(handles.figure1);

end
