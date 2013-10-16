function varargout = puma(varargin)
% PUMA MATLAB code for puma.fig
%      PUMA, by itself, creates a new PUMA or raises the existing
%      singleton*.
%
%      H = PUMA returns the handle to a new PUMA or the handle to
%      the existing singleton*.
%
%      PUMA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PUMA.M with the given input arguments.
%
%      PUMA('Property','Value',...) creates a new PUMA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before puma_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to puma_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help puma

% Last Modified by GUIDE v2.5 10-Oct-2013 13:29:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @puma_OpeningFcn, ...
                   'gui_OutputFcn',  @puma_OutputFcn, ...
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

% --- Executes just before puma is made visible.
function puma_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to puma (see VARARGIN)


% Choose default command line output for puma
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using puma.
if strcmp(get(hObject,'Visible'),'off')
    hObject = visualize_puma(0,0,0,0,0,0);
end

% UIWAIT makes puma wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = puma_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)

% --- Executes on slider movement.
function theta1_slider_Callback(hObject, eventdata, handles)
% hObject    handle to theta1_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

theta1 = get(handles.theta1_slider,'Value');
theta2 = get(handles.theta2_slider,'Value');
theta3 = get(handles.theta3_slider,'Value');
theta4 = get(handles.theta4_slider,'Value');
theta5 = get(handles.theta5_slider,'Value');
theta6 = get(handles.theta6_slider,'Value');
set(handles.theta_1_text,'String',get(hObject,'Value')); % Update text box
handles.plot = visualize_puma(theta1,theta2,theta3,theta4,theta5,theta6); % Update plot

% --- Executes during object creation, after setting all properties.
function theta1_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to theta1_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function theta2_slider_Callback(hObject, eventdata, handles)
% hObject    handle to theta2_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
theta1 = (pi*get(handles.theta1_slider,'Value'))/180; % Convert degrees to radians
theta2 = (pi*get(handles.theta2_slider,'Value'))/180;
theta3 = (pi*get(handles.theta3_slider,'Value'))/180;
theta4 = (pi*get(handles.theta4_slider,'Value'))/180;
theta5 = (pi*get(handles.theta5_slider,'Value'))/180;
theta6 = (pi*get(handles.theta6_slider,'Value'))/180;
set(handles.theta_2_text,'String',get(hObject,'Value'));% Update text box
handles.plot = visualize_puma(theta1,theta2,theta3,theta4,theta5,theta6); % Update plot

% --- Executes during object creation, after setting all properties.
function theta2_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to theta2_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function theta3_slider_Callback(hObject, eventdata, handles)
% hObject    handle to theta3_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
theta1 = (pi*get(handles.theta1_slider,'Value'))/180; % Convert degrees to radians
theta2 = (pi*get(handles.theta2_slider,'Value'))/180;
theta3 = (pi*get(handles.theta3_slider,'Value'))/180;
theta4 = (pi*get(handles.theta4_slider,'Value'))/180;
theta5 = (pi*get(handles.theta5_slider,'Value'))/180;
theta6 = (pi*get(handles.theta6_slider,'Value'))/180;
set(handles.theta_3_text,'String',get(hObject,'Value'));% Update text box
handles.plot = visualize_puma(theta1,theta2,theta3,theta4,theta5,theta6); % Update plot

% --- Executes during object creation, after setting all properties.
function theta3_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to theta3_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function theta4_slider_Callback(hObject, eventdata, handles)
% hObject    handle to theta4_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
theta1 = (pi*get(handles.theta1_slider,'Value'))/180; % Convert degrees to radians
theta2 = (pi*get(handles.theta2_slider,'Value'))/180;
theta3 = (pi*get(handles.theta3_slider,'Value'))/180;
theta4 = (pi*get(handles.theta4_slider,'Value'))/180;
theta5 = (pi*get(handles.theta5_slider,'Value'))/180;
theta6 = (pi*get(handles.theta6_slider,'Value'))/180;
set(handles.theta_4_text,'String',get(hObject,'Value'));% Update text box
handles.plot = visualize_puma(theta1,theta2,theta3,theta4,theta5,theta6); % Update plot

% --- Executes during object creation, after setting all properties.
function theta4_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to theta4_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function theta5_slider_Callback(hObject, eventdata, handles)
% hObject    handle to theta5_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
theta1 = (pi*get(handles.theta1_slider,'Value'))/180; % Convert degrees to radians
theta2 = (pi*get(handles.theta2_slider,'Value'))/180;
theta3 = (pi*get(handles.theta3_slider,'Value'))/180;
theta4 = (pi*get(handles.theta4_slider,'Value'))/180;
theta5 = (pi*get(handles.theta5_slider,'Value'))/180;
theta6 = (pi*get(handles.theta6_slider,'Value'))/180;
set(handles.theta_5_text,'String',get(hObject,'Value'));% Update text box
handles.plot = visualize_puma(theta1,theta2,theta3,theta4,theta5,theta6); % Update plot

% --- Executes during object creation, after setting all properties.
function theta5_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to theta5_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function theta6_slider_Callback(hObject, eventdata, handles)
% hObject    handle to theta6_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
theta1 = (pi*get(handles.theta1_slider,'Value'))/180; % Convert degrees to radians
theta2 = (pi*get(handles.theta2_slider,'Value'))/180;
theta3 = (pi*get(handles.theta3_slider,'Value'))/180;
theta4 = (pi*get(handles.theta4_slider,'Value'))/180;
theta5 = (pi*get(handles.theta5_slider,'Value'))/180;
theta6 = (pi*get(handles.theta6_slider,'Value'))/180;
set(handles.theta_6_text,'String',get(hObject,'Value'));% Update text box
handles.plot = visualize_puma(theta1,theta2,theta3,theta4,theta5,theta6); % Update plot

% --- Executes during object creation, after setting all properties.
function theta6_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to theta6_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function theta_1_text_Callback(hObject, eventdata, handles)
% hObject    handle to theta_1_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Check bounds of value entered
if str2double(get(hObject,'String')) < -360
    set(handles.theta_1_text,'String',-360);
elseif str2double(get(hObject,'String')) > 360
    set(handles.theta_1_text,'String',360);
end
set(handles.theta1_slider,'Value',str2double(get(hObject,'String')));% Update slider
theta1 = (pi*get(handles.theta1_slider,'Value'))/180; % Convert degrees to radians
theta2 = (pi*get(handles.theta2_slider,'Value'))/180;
theta3 = (pi*get(handles.theta3_slider,'Value'))/180;
theta4 = (pi*get(handles.theta4_slider,'Value'))/180;
theta5 = (pi*get(handles.theta5_slider,'Value'))/180;
theta6 = (pi*get(handles.theta6_slider,'Value'))/180;
handles.plot = visualize_puma(theta1,theta2,theta3,theta4,theta5,theta6); % Update plot

% --- Executes during object creation, after setting all properties.
function theta_1_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to theta_1_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function theta_2_text_Callback(hObject, eventdata, handles)
% hObject    handle to theta_2_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if str2double(get(hObject,'String')) < -360
    set(handles.theta_2_text,'String',-360);
elseif str2double(get(hObject,'String')) > 360
    set(handles.theta_2_text,'String',360);
end
set(handles.theta2_slider,'Value',str2double(get(hObject,'String')));% Update slider
theta1 = (pi*get(handles.theta1_slider,'Value'))/180; % Convert degrees to radians
theta2 = (pi*get(handles.theta2_slider,'Value'))/180;
theta3 = (pi*get(handles.theta3_slider,'Value'))/180;
theta4 = (pi*get(handles.theta4_slider,'Value'))/180;
theta5 = (pi*get(handles.theta5_slider,'Value'))/180;
theta6 = (pi*get(handles.theta6_slider,'Value'))/180;
handles.plot = visualize_puma(theta1,theta2,theta3,theta4,theta5,theta6); % Update plot

% --- Executes during object creation, after setting all properties.
function theta_2_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to theta_2_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function theta_3_text_Callback(hObject, eventdata, handles)
% hObject    handle to theta_3_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if str2double(get(hObject,'String')) < -360
    set(handles.theta_3_text,'String',-360);
elseif str2double(get(hObject,'String')) > 360
    set(handles.theta_3_text,'String',360);
end
set(handles.theta3_slider,'Value',str2double(get(hObject,'String')));% Update slider
theta1 = (pi*get(handles.theta1_slider,'Value'))/180; % Convert degrees to radians
theta2 = (pi*get(handles.theta2_slider,'Value'))/180;
theta3 = (pi*get(handles.theta3_slider,'Value'))/180;
theta4 = (pi*get(handles.theta4_slider,'Value'))/180;
theta5 = (pi*get(handles.theta5_slider,'Value'))/180;
theta6 = (pi*get(handles.theta6_slider,'Value'))/180;
handles.plot = visualize_puma(theta1,theta2,theta3,theta4,theta5,theta6); % Update plot

% --- Executes during object creation, after setting all properties.
function theta_3_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to theta_3_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function theta_4_text_Callback(hObject, eventdata, handles)
% hObject    handle to theta_4_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if str2double(get(hObject,'String')) < -580
    set(handles.theta_4_text,'String',-580);
elseif str2double(get(hObject,'String')) > 360
    set(handles.theta_4_text,'String',360);
end
set(handles.theta4_slider,'Value',str2double(get(hObject,'String')));% Update slider
theta1 = (pi*get(handles.theta1_slider,'Value'))/180; % Convert degrees to radians
theta2 = (pi*get(handles.theta2_slider,'Value'))/180;
theta3 = (pi*get(handles.theta3_slider,'Value'))/180;
theta4 = (pi*get(handles.theta4_slider,'Value'))/180;
theta5 = (pi*get(handles.theta5_slider,'Value'))/180;
theta6 = (pi*get(handles.theta6_slider,'Value'))/180;
handles.plot = visualize_puma(theta1,theta2,theta3,theta4,theta5,theta6); % Update plot

% --- Executes during object creation, after setting all properties.
function theta_4_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to theta_4_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function theta_5_text_Callback(hObject, eventdata, handles)
% hObject    handle to theta_5_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if str2double(get(hObject,'String')) < -360
    set(handles.theta_5_text,'String',-360);
elseif str2double(get(hObject,'String')) > 360
    set(handles.theta_5_text,'String',360);
end
set(handles.theta5_slider,'Value',str2double(get(hObject,'String')));% Update slider
theta1 = (pi*get(handles.theta1_slider,'Value'))/180; % Convert degrees to radians
theta2 = (pi*get(handles.theta2_slider,'Value'))/180;
theta3 = (pi*get(handles.theta3_slider,'Value'))/180;
theta4 = (pi*get(handles.theta4_slider,'Value'))/180;
theta5 = (pi*get(handles.theta5_slider,'Value'))/180;
theta6 = (pi*get(handles.theta6_slider,'Value'))/180;
handles.plot = visualize_puma(theta1,theta2,theta3,theta4,theta5,theta6); % Update plot

% --- Executes during object creation, after setting all properties.
function theta_5_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to theta_5_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function theta_6_text_Callback(hObject, eventdata, handles)
% hObject    handle to theta_6_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if str2double(get(hObject,'String')) < -360
    set(handles.theta_6_text,'String',-360);
elseif str2double(get(hObject,'String')) > 360
    set(handles.theta_6_text,'String',360);
end
set(handles.theta6_slider,'Value',str2double(get(hObject,'String')));% Update slider
theta1 = (pi*get(handles.theta1_slider,'Value'))/180; % Convert degrees to radians
theta2 = (pi*get(handles.theta2_slider,'Value'))/180;
theta3 = (pi*get(handles.theta3_slider,'Value'))/180;
theta4 = (pi*get(handles.theta4_slider,'Value'))/180;
theta5 = (pi*get(handles.theta5_slider,'Value'))/180;
theta6 = (pi*get(handles.theta6_slider,'Value'))/180;
handles.plot = visualize_puma(theta1,theta2,theta3,theta4,theta5,theta6); % Update plot

% --- Executes during object creation, after setting all properties.
function theta_6_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to theta_6_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function plot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate plot


% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Reset to 0 configuration
% Update sliders and text box
set(handles.theta_1_text,'String',0);% Update text box
set(handles.theta_2_text,'String',0);% Update text box
set(handles.theta_3_text,'String',0);% Update text box
set(handles.theta_4_text,'String',0);% Update text box
set(handles.theta_5_text,'String',0);% Update text box
set(handles.theta_6_text,'String',0);% Update text box
set(handles.theta1_slider,'Value',0);% Update slider
set(handles.theta2_slider,'Value',0);% Update slider
set(handles.theta3_slider,'Value',0);% Update slider
set(handles.theta4_slider,'Value',0);% Update slider
set(handles.theta5_slider,'Value',0);% Update slider
set(handles.theta6_slider,'Value',0);% Update slider
handles.plot = visualize_puma(0,0,0,0,0,0); % Update plot
