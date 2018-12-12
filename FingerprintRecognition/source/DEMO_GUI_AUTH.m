function varargout = DEMO_GUI_AUTH(varargin)
% DEMO_GUI_AUTH M-file for DEMO_GUI_AUTH.fig
%      DEMO_GUI_AUTH, by itself, creates a new DEMO_GUI_AUTH or raises the existing
%      singleton*.
%
%      H = DEMO_GUI_AUTH returns the handle to a new DEMO_GUI_AUTH or the handle to
%      the existing singleton*.
%
%      DEMO_GUI_AUTH('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DEMO_GUI_AUTH.M with the given input arguments.
%
%      DEMO_GUI_AUTH('Property','Value',...) creates a new DEMO_GUI_AUTH or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DEMO_GUI_AUTH_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DEMO_GUI_AUTH_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DEMO_GUI_AUTH

% Last Modified by GUIDE v2.5 28-Jun-2009 01:51:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DEMO_GUI_AUTH_OpeningFcn, ...
                   'gui_OutputFcn',  @DEMO_GUI_AUTH_OutputFcn, ...
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


% --- Executes just before DEMO_GUI_AUTH is made visible.
function DEMO_GUI_AUTH_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DEMO_GUI_AUTH (see VARARGIN)

% Choose default command line output for DEMO_GUI_AUTH
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DEMO_GUI_AUTH wait for user response (see UIRESUME)
% uiwait(handles.figure1);
t2 = 0;
% set hinh nen cho gui
axes(handles.axes_bgau);
im2 = imread('bg_au.jpg');
image(im2);
colormap(gray);
set(gca, 'visible', 'off'); % an khung cua axes hien hanh

% kiem tra da thuc hien rut trich dac trung va luu bien
if(exist('var_input.mat')~=0)
    
    %load bien tu form giao dich
    load('var_input.mat');
    delete('var_input.mat');
    set(handles.text_id,'String',id);
    
    % kiem tra tai khoan co bi khoa hay khong
    load('locked_list.mat');
    if(find(locked_list == str2num(id)) ~= 0)
        res = 2; % tai khoan da bi khoa
    else
        % kiem tra file anh van tay/id co ton tai          
        dir_id = strcat('database_en_mat\',id,'\');
        if(exist(dir_id) == 0)
            res = -1;% tai khoan khong ton tai
        else

            % show dong thong bao
            set(handles.edit_wait,'visible','on');    

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % CHUNG THUC VAN TAY
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            tic
            res = authen_fingerprint(dir_id,enfn);
            t2 = toc
            % tat dong thong bao
            set(handles.edit_wait,'visible','off');

            %show ket qua
            axes(handles.axes_bgau);
            if(res == 1)
                im = imread('bg_au_true.jpg');
                flat = 0;
            elseif(res == 0)
                im = imread('bg_au_false.jpg');
                
                % dem so lan sai
                load('tmp_auth.mat');
                if(str2num(id) == last_signin)
                    flat = flat + 1;
                else 
                    flat = 1;
                end
                
                % luu tai khoan bi khoa do dang nhap sai 3 lan lien tuc
                if(flat == 3)
                    locked_list = [locked_list;str2num(id)];
                    save('locked_list.mat','locked_list');
                end                
            end
            image(im);
            colormap(gray);
            set(gca, 'visible', 'off'); % an khung cua axes hien hanh
            last_signin = str2num(id);
            save('tmp_auth.mat','flat','last_signin')
        end
    end    
    save('re_var.mat','res','t2');
end

% --- Outputs from this function are returned to the command line.
function varargout = DEMO_GUI_AUTH_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;    


% --- Executes during object creation, after setting all properties.
function axes_bgau_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_bgau (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes_bgau
% imshow('bg_au.jpg');



function edit_wait_Callback(hObject, eventdata, handles)
% hObject    handle to edit_wait (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_wait as text
%        str2double(get(hObject,'String')) returns contents of edit_wait as a double


% --- Executes during object creation, after setting all properties.
function edit_wait_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_wait (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


