function varargout = view_main(varargin)
%VIEW_MAIN M-file for view_main.fig
%      VIEW_MAIN, by itself, creates a new VIEW_MAIN or raises the existing
%      singleton*.
%
%      H = VIEW_MAIN returns the handle to a new VIEW_MAIN or the handle to
%      the existing singleton*.
%
%      VIEW_MAIN('Property','Value',...) creates a new VIEW_MAIN using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to view_main_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      VIEW_MAIN('CALLBACK') and VIEW_MAIN('CALLBACK',hObject,...) call the
%      local function named CALLBACK in VIEW_MAIN.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help view_main

% Last Modified by GUIDE v2.5 19-Dec-2015 17:16:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @view_main_OpeningFcn, ...
                   'gui_OutputFcn',  @view_main_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before view_main is made visible.
function view_main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for view_main
handles.output = hObject;
global hand;
hand = handles;

%Set parameters
set_params;
    
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes test1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = test1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%Set start params
function set_params
    global hand;
    global move_val;
    
    set(hand.edit1,'String','600');
    set(hand.edit2,'String','1200');
    %set(gcf, 'WindowButtonMotionFcn', @mouseMove);
    global pos_axes_main;
    pos_axes_main = get(hand.axes_main, 'Position');
    set(hand.axes_main,'ButtonDownFcn',@axes_mainClickCallback);
    global sel_row;
    sel_row = 1;
    move_val = 1;

    xlabel(hand.axes_preview,'X');
    ylabel(hand.axes_preview,'Y');
    zlabel(hand.axes_preview,'Z');

    view(hand.axes_preview,-60,60);
    
%function mouseMove (object, eventdata)
%    global hand;
%    global pos_axes_main;
%    C = get (hand.axes_main, 'CurrentPoint');
%    title(hand.axes_main, ['(X,Y) = (', num2str(C(1,1)), ', ',num2str(C(1,2)), ')']);

%Replot all
function replot

    global hand;
    global left_pos;
    global right_pos;
    global XYZ_win;
    global data_table;
    global Count_beats;
    global beat_color;
    global move_val;
    
    if ((get(hand.checkbox1,'value') == 1) && (get(hand.checkbox2,'value') == 1))
        
        cla(hand.axes_preview);
        hold(hand.axes_preview,'on');

        plot_axes_part (hand.axes_part);
        
        for i = 1:Count_beats
            if (data_table(i) == 1)
              switch (get(get(hand.uipanel_preview,'SelectedObject'),'Tag'))
                case 'Part_chbox' %Part plot
                    plot3(hand.axes_preview,XYZ_win(i,left_pos:left_pos+move_val,1),XYZ_win(i,left_pos:left_pos+move_val,2),XYZ_win(i,left_pos:left_pos+move_val,3),'color',beat_color(i,:),'Linewidth',2);
                case 'All_chbox'
                    plot3(hand.axes_preview,XYZ_win(i,:,1),XYZ_win(i,:,2),XYZ_win(i,:,3),'color',beat_color(i,:),'Linewidth',2);
              end
            end
        end

        hold(hand.axes_preview,'off');
        view(hand.axes_preview,-60,60);
    end
    
    plot_axes_main(hand.axes_main, get(hand.popupmenu1,'value'), 1);

function plot_axes_part (handle_in)
    global left_pos;
    global right_pos;
    global XYZ_win;
    global move_val;
    
    cla(handle_in);
    hold(handle_in,'on');
    set(handle_in,'Xlim',[1,right_pos-left_pos]);
    plot(handle_in,XYZ_win(1,left_pos:right_pos,1),'color','red','LineWidth',2);
    plot(handle_in,XYZ_win(1,left_pos:right_pos,2),'color','green','LineWidth',2);
    plot(handle_in,XYZ_win(1,left_pos:right_pos,3),'color','blue','LineWidth',2);
    plot_YLim = get(handle_in,'YLim');
    plot(handle_in,[move_val move_val],plot_YLim, 'color','red','LineWidth',1,'LineStyle','--');
    hold(handle_in,'off');


function axes_mainClickCallback (hObject , eventData)
    axesHandle  = get(hObject,'Parent');
    coordinates = get(axesHandle,'CurrentPoint'); 
    coordinates = coordinates(1,1:2);
    mouse_x = coordinates(1);
    mouse_y = coordinates(2);
    plot_window_ax1(mouse_x, mouse_y);
    
%Replot ax1
function plot_window_ax1(mouse_x, mouse_y)
    global hand;
    global left_pos;
    global right_pos;
    global move_val;
    
    XLim = get(hand.axes_main, 'XLim');
    Posit = get(hand.axes_main, 'position');
    width = Posit(3);
    plot_window = XLim(2)-XLim(1);
    
    if (get(hand.checkbox2,'value') == 0)
        left_pos =  round((plot_window/width) * (mouse_x-Posit(1))+XLim(1));
        if (left_pos >= right_pos) 
                msgbox('Left pos >= right_pos','Error','error');
        else
            set(hand.checkbox2,'value',1);
            set(hand.edit4,'String',int2str(left_pos));
            set(hand.slider6,'max',(right_pos - left_pos));
            move_val = right_pos - left_pos;
            set(hand.slider6,'value', move_val);
            set(hand.slider6,'min',1);
            set(hand.slider6,'SliderStep',[1 1]);
            set(hand.edit8,'String',num2str(move_val));
            replot;
        end
    else
        if (get(hand.checkbox1,'value') == 0)
            right_pos =  round((plot_window/width) * (mouse_x-Posit(1))+XLim(1));
            if (left_pos >= right_pos)
                msgbox('Left pos >= right_pos','Error','error');
            else
                set(hand.checkbox1,'value',1);
                set(hand.edit3,'String',int2str(right_pos));
                set(hand.slider6,'max',(right_pos - left_pos));
                move_val = right_pos - left_pos;
                set(hand.slider6,'value', move_val);
                set(hand.slider6,'min',1);
                set(hand.slider6,'SliderStep',[1 1]);
                set(hand.edit8,'String',num2str(move_val));
                replot;
            end
        end
    end
    
    set_move_slider;
    
%Calculate magnitude
function mag = magnitude_calc(XYZ, beat_n)
    mag = ((XYZ(beat_n,:,1)).^2 + (XYZ(beat_n,:,2)).^2 + (XYZ(beat_n,:,3)).^2).^(0.5);
    
%Plot graphs
function plot_axes_main(handle_in, signal, beat_n)
    global hand;
    global win_left;
    global win_right;
    global XYZ_in;
    global left_pos;
    global right_pos;
    
    cla(handle_in); %clear plot
    hold(handle_in,'on');
    set(handle_in,'Xlim',[0,win_right-win_left]);
            
    switch (signal)
        case 1 %XYZ_in plot
            plot(handle_in, XYZ_in(beat_n,:,1),'Color','red','LineWidth',2);
            plot(handle_in, XYZ_in(beat_n,:,2),'Color','green','LineWidth',2);
            plot(handle_in, XYZ_in(beat_n,:,3),'Color','blue','LineWidth',2);
        case 2 %X lead
            plot(handle_in, XYZ_in(beat_n,:,1),'Color','red','LineWidth',2);
        case 3 %Y lead
            plot(handle_in, XYZ_in(beat_n,:,2),'Color','red','LineWidth',2);
        case 4 %Z lead
            plot(handle_in, XYZ_in(beat_n,:,3),'Color','red','LineWidth',2);
        case 5 %Magnitude
            mag = magnitude_calc(XYZ_in, beat_n);
            plot(handle_in,mag,'Color','red','LineWidth',2); 
    end
    
    plot_window(handle_in, left_pos, right_pos);          
    legend(handle_in,{'X lead','Y lead','Z lead'},'FontSize',7,'FontWeight','bold');
    hold(handle_in,'off');
    
function set_move_slider
    global hand;
    global left_pos;
    global right_pos;
    global win_left;
    global win_right;
    
    if (get(hand.checkbox1,'value') == 1) && (get(hand.checkbox2,'value') == 1)
        set(hand.slider_wind_shift,'max', win_right - win_left - (right_pos - left_pos));
        set(hand.slider_wind_shift,'min', 0);
        set(hand.slider_wind_shift,'value', left_pos - win_left);
    end
   
    
function plot_window(handle_in, left_pos, right_pos)   
    hold(handle_in,'on');
    plot_YLim = get(handle_in,'YLim');
    plot(handle_in,[left_pos left_pos],plot_YLim, 'color','red','LineWidth',1.5,'LineStyle','--');
    plot(handle_in,[right_pos right_pos] ,plot_YLim, 'color','red','LineWidth',1.5,'LineStyle','--');
    hold(handle_in,'off');

    
function load_table
    global hand;
    global XYZ_in;
    global Count_beats;
    global data_table;
    global beat_color;
    global first_beat;
    global last_beat;
    
    first_beat = str2num(get(hand.edit7,'string'));
    last_beat = str2num(get(hand.edit6,'string'));
    
    data_table = false(Count_beats,1);
    data_table(first_beat:last_beat) = 1;
    set(hand.uitable1,'data',data_table);
    set(hand.uitable1, 'CellEditCallback', @check_checked);

function check_checked(src, eventdata)
    global hand;
    global data_table;

    row_changed = eventdata.Indices(1);
    if (data_table(row_changed) == true)
        data_table(row_changed) = false;
    else
        data_table(row_changed) = true;
        
    end
    set(hand.uitable1,'data',data_table);  
 
%Open click
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global defaul_patient_dir;
    global patient_file;
    global hand;
    global XYZ_in;
    global Count_beats;
    
    [patient_file, defaul_patient_dir] = uigetfile({'*.mat','*.mat';...
              '*.*','All Files' },'Open .mat file');
    load(strcat(defaul_patient_dir, patient_file));
    
    XYZ_in = XYZ;
    Count_beats = length(XYZ(:,1,1));
    length_wave = length(XYZ(1,:,1));
    set(hand.text4,'String',num2str(Count_beats));
    set(hand.text6,'String',description);
    
    global win_left;
    global win_right;

    global left_pos;
    global right_pos;

    global XYZ_win;
    global data_table;
    global beat_color;
    
    set(hand.edit1,'string', 1);
    win_left = str2num(get(hand.edit1,'String'));
    set(hand.edit2,'string', length_wave);
    win_right = str2num(get(hand.edit2,'String'));

    right_pos = win_right;
    left_pos = win_right;
    
    for (i = 1:10)
     beat_color= [beat_color; colormap(lines)]; %make color map
    end
    
    load_table; %load table values
    
    plot_axes_main(hand.axes_main, get(hand.popupmenu1,'value'), 1);
    
    cla(hand.axes_preview);
    hold(hand.axes_preview,'on');
    
    for i=1:Count_beats
        if (data_table(i) == 1)
            plot3(hand.axes_preview,XYZ_in(i,win_left:win_right,1), XYZ_in(i,win_left:win_right,2), XYZ_in(i,win_left:win_right,3),'color',beat_color(i,:),'LineWidth',1);
       end
    end

    hold(hand.axes_preview,'off');
    
    XYZ_win = XYZ_in(1:Count_beats,win_left:win_right,1:3);

% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    %filterbuilder;
    fdatool;


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global hand;
    global XYZ_in;
    global win_left;
    global win_right;
    global left_pos;
    global right_pos;
    
    cla(hand.axes_part);
    h = out; % Use external function
    filter_x = filter(h, XYZ_in(1,left_pos:right_pos,1));
    filter_y = filter(h, XYZ_in(1,left_pos:right_pos,2));
    filter_z = filter(h, XYZ_in(1,left_pos:right_pos,3));
        
    hold(hand.axes_part,'on');
    plot(hand.axes_part, filter_x,'Color','red','LineWidth',1);
    plot(hand.axes_part, filter_y,'Color','green','LineWidth',1);
    plot(hand.axes_part, filter_z,'Color','blue','LineWidth',1);
    hold(hand.axes_part,'off');

    cla(hand.axes_preview); 
    
    hold(hand.axes_preview,'on');
    
    for (i = 1:10)
        filter_x = filter(h, XYZ_in(1,left_pos:right_pos,1));
        filter_y = filter(h, XYZ_in(1,left_pos:right_pos,2));
        filter_z = filter(h, XYZ_in(1,left_pos:right_pos,3));
        plot3(hand.axes_preview,filter_x, filter_y, filter_z,'color',rand(1,3),'LineWidth',1);
    end
       
    hold(hand.axes_preview,'off');


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    h = out; % Use external function
    fvtool(h); 


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1

    global hand;
    
    signal = get(hand.popupmenu1,'Value');
    plot_axes_main(hand.axes_main, signal, 1);


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global hand;
    
    left_pos_def = get(hand.edit4,'String');
    right_pos_def = get(hand.edit3,'String');
    left_window_def = get(hand.edit1,'String');
    right_window_def = get(hand.edit2,'String');
    choose_signal_def = get(hand.popupmenu1,'Value');
    
    save('default.mat');
    

% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    load('default.mat');

    global hand;
    global left_pos;
    global right_pos;
    global win_left;
    global win_right;
    
    win_left = str2num(left_window_def);
    win_right = str2num(right_window_def);
    left_pos = str2num(left_pos_def);
    right_pos = str2num(right_pos_def);
    set(hand.edit4,'String',left_pos_def);
    set(hand.edit3,'String',right_pos_def);
    set(hand.edit1,'String',left_window_def);
    set(hand.edit2,'String',right_window_def);
    set(hand.popupmenu1,'Value',str2num(choose_signal_def));
    
    
function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Select cell
function uitable1_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
% Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
    global hand;
    global data_table;
    global sel_row;
    
    event = eventdata.Indices;
    sel_row = event(1);
    
    if (event(2) == 2)
        signal = get(hand.popupmenu1,'value');
        plot_axes_main (hand.axes_main, signal, sel_row);
    end


function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%Set beats
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global first_beat;
    global last_beat;
    global hand;
    global Count_beats;
    global data_table;
    
    first_beat = str2num(get(hand.edit7,'string'));
    last_beat = str2num(get(hand.edit6,'string'));
    
    data_table = false(Count_beats,1);
    data_table(first_beat:last_beat) = 1;
    replot;
    set(hand.uitable1,'data',data_table);
    


% --- Executes when selected object is changed in uipanel_preview.
function uipanel_preview_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel_preview 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
    global hand;
    global XYZ_win;
    global Count_beats;
    global data_table;
    global left_pos;
    global right_pos;
        
    cla(hand.axes_preview);
    
    hold(hand.axes_preview,'on');
    for i = 1:Count_beats
        if (data_table(i) == 1)
            switch (get(get(handles.uipanel_preview,'SelectedObject'),'Tag'))
            case 'Part_chbox' %Part plot
                plot3(hand.axes_preview,XYZ_win(i,left_pos:right_pos,1),XYZ_win(i,left_pos:right_pos,2),XYZ_win(i,left_pos:right_pos,3),'color',rand(1,3));
            case 'All_chbox'
                plot3(hand.axes_preview,XYZ_win(i,:,1),XYZ_win(i,:,2),XYZ_win(i,:,3),'color',rand(1,3));
            end
        end
    end
    
    hold(hand.axes_preview,'off');


% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global hand;
    global data_table;
    global beat_color;
    
    data_table = get(hand.uitable1,'data');
    replot;


% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global hand;
    
    view(hand.axes_preview,-60,40);

% --- Executes on slider movement.
function slider6_Callback(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
    global hand;
    global move_val;

    move_val = round(get(hand.slider6,'value'));
    set(hand.edit8,'String',num2str(move_val));
    replot;
        

% --- Executes during object creation, after setting all properties.
function slider6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global hand;
    global move_val;
    global left_pos;
    global right_pos;
    
    if ((move_val - 1) >= 1)
        move_val = move_val - 1;
        set(hand.edit8,'String',num2str(move_val));
        set(hand.slider6,'value', move_val);
    end
    
    replot;


% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global hand;
    global move_val;
    global left_pos;
    global right_pos;
    
    if ((move_val + 1) <= right_pos-left_pos)
        move_val = move_val + 1;
        set(hand.edit8,'String',num2str(move_val));
        set(hand.slider6,'value', move_val);
    end
    
    replot;


% --- Executes on button press in pushbutton18.
function pushbutton18_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get the GUI 1 obj
    global XYZ_win;
    global left_pos;
    global right_pos;
    global beat_color;
    global move_val;
    global data_table;
    global Count_beats;
    global win_left;
    global win_right;
    global hand;
    
    %Open figure if not open
    if (isempty(findobj('tag','view_3d_fig')))
        view_3d; %Open gui
    end
    hand_3d = guidata(findobj('tag','view_3d_fig')); %Make handle for
    
    main_values.XYZ_win = XYZ_win;
    main_values.left_pos = left_pos;
    main_values.beat_color = beat_color;
    main_values.move_val = move_val;
    main_values.data_table = data_table;
    main_values.Count_beats = Count_beats;    
    main_values.win_left = win_left;
    main_values.win_right = win_right; 
    main_values.right_pos = right_pos;
    
    %plot graphs single bet
    plot_axes_main(hand_3d.axes_main, get(hand.popupmenu1,'value'), 1);
    plot_axes_part(hand_3d.axes_part);
    
    %Send global data to 3D window and Draw values and send global variables to 3D window
    view_3d('external_init',main_values);

    
% --- Outputs from this function are returned to the command line.
function varargout = view_main_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on mouse press over axes background.
function axes_main_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes_main (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


%Window shifting slider
function slider_wind_shift_Callback(hObject, eventdata, handles)
% hObject    handle to slider_wind_shift (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
    global hand;
    global win_left;
    global left_pos;
    global right_pos;
    
    win_size = right_pos - left_pos;
    slider_value = get(hand.slider_wind_shift,'value');
    left_pos = win_left + slider_value;
    right_pos = left_pos + win_size;
    plot_axes_main(hand.axes_main, get(hand.popupmenu1,'value'), 1);
    replot;

% --- Executes during object creation, after setting all properties.
function slider_wind_shift_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_wind_shift (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function pushbutton8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes when selected object is changed in uipanel_preview.
function uipanel_preview_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel_preview 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
