function varargout = DEMO_GUI_AFS(varargin)
% DEMO_GUI_AFS M-file for DEMO_GUI_AFS.fig
%      DEMO_GUI_AFS, by itself, creates a new DEMO_GUI_AFS or raises the existing
%      singleton*.
%
%      H = DEMO_GUI_AFS returns the handle to a new DEMO_GUI_AFS or the handle to
%      the existing singleton*.
%
%      DEMO_GUI_AFS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DEMO_GUI_AFS.M with the given input arguments.
%
%      DEMO_GUI_AFS('Property','Value',...) creates a new DEMO_GUI_AFS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DEMO_GUI_AFS_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DEMO_GUI_AFS_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DEMO_GUI_AFS

% Last Modified by GUIDE v2.5 27-Jun-2009 14:10:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DEMO_GUI_AFS_OpeningFcn, ...
                   'gui_OutputFcn',  @DEMO_GUI_AFS_OutputFcn, ...
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


% --- Executes just before DEMO_GUI_AFS is made visible.
function DEMO_GUI_AFS_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DEMO_GUI_AFS (see VARARGIN)

% Choose default command line output for DEMO_GUI_AFS
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DEMO_GUI_AFS wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% set background for gui
axes(handles.axes_gd);
im = imread('bg_gd.jpg');
image(im);
colormap(gray);
set(gca,'visible','off');% an khung cua axes hien hanh

% set background for button
im = importdata('button.jpg'); 
set(handles.pushbutton_load,'CDATA',im);

% goi gui chung thuc tai ngan hang
DEMO_GUI_AUTH;

% --- Outputs from this function are returned to the command line.
function varargout = DEMO_GUI_AFS_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
% bien toan cuc
handles.id = '';
handles.im = 0;
guidata(hObject, handles);

function edit_idkh_Callback(hObject, eventdata, handles)
% hObject    handle to edit_idkh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_idkh as text
%        str2double(get(hObject,'String')) returns contents of edit_idkh as a double
set(handles.text_time,'visible','off');
handles.id = get(hObject,'String');
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_idkh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_idkh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_load.
function pushbutton_enter_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_load.
function pushbutton_load_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% an dong thong bao thoi gian thuc thi
set(handles.text_time,'visible','off');
% khoi tao bien thoi gian
t1 = 0;
t2 = 0;

% set background o trang thai binh thuong
im = imread('bg_gd.jpg');
image(im);
colormap(gray);
set(gca, 'visible', 'off'); % an khung cua axes hien hanh

% kiem tra id da nhap hay chua
if(size(handles.id,2) == 0)
        msgbox('Vui long nhap id khach hang.');
else
        
    % load anh van tay
    [fileName,pathName] = uigetfile('*.tif','Select the Image-file','input\');  
    fullName = strcat(pathName,fileName);

    % kiem tra file da duoc chon hay chua
    if(pathName ~= 0)

        % show dong thong bao
        set(handles.text_wait,'visible','on');

%             % show anh van tay            
%             handles.im = imread(fullName);   
%             axes(handles.axes_im);
%             imagesc(handles.im);
%             set(gca,'visible','off');

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % BAT DAU QUA TRINH CHUNG THUC        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % RUT TRICH DAC TRUNG VA MA HOA VECTO DAC TRUNG CUA VAN TAY
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        tic
        [enfn] = run_getFeature(fileName,pathName);
        t1 = toc;
        id = handles.id;

        % save du lieu gom id va vecto dac trung ma hoa de truyen di.
        save('var_input.mat','id','enfn');

        % tat dong thong bao
        set(handles.text_wait,'visible','off');

        % goi gui chung thuc
        tic
        DEMO_GUI_AUTH;
        t2 = toc;

        % load bien ket qua tra ve 
        load('re_var.mat');
        delete('re_var.mat');

        % show ket qua
        axes(handles.axes_gd);
        if(res == -1)
            msgbox('ID khach hang khong ton tai. Vui long nhap lai.');
        else
            if(res == 2)
                msgbox('Tai khoan cua quy khach da bi khoa. Vui long lien he voi ngan hang.');
            else
                if(res == 0)
                    im = imread('bg_gd_false.jpg');
                else
                    im = imread('bg_gd_true.jpg');
                    handles.flat_false = 0;
                end
                image(im);
                colormap(gray);
                set(gca, 'visible', 'off'); % an khung cua axes hien hanh

                % show thoi gian thuc thi
                s = sprintf('\n\t                     THOI GIAN THUC THI \n\n   - Cai thien chat luong anh va rut trich dac trung: \t %0.3f \n   - Chung thuc van tay:                                           \t %0.3f',t1,t2);
                set(handles.text_time,'string',s);
                set(handles.text_time,'visible','on');
            end
        end   
    end
end
