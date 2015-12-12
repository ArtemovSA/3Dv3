function varargout = view_3d(varargin)
% VIEW_3D MATLAB code for view_3d.fig
%      VIEW_3D, by itself, creates a new VIEW_3D or raises the existing
%      singleton*.
%
%      H = VIEW_3D returns the handle to a new VIEW_3D or the handle to
%      the existing singleton*.
%
%      VIEW_3D('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VIEW_3D.M with the given input arguments.
%
%      VIEW_3D('Property','Value',...) creates a new VIEW_3D or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before view_3d_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to view_3d_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help view_3d

% Last Modified by GUIDE v2.5 11-Dec-2015 13:56:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @view_3d_OpeningFcn, ...
                   'gui_OutputFcn',  @view_3d_OutputFcn, ...
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


% --- Executes just before view_3d is made visible.
function view_3d_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to view_3d (see VARARGIN)

% Choose default command line output for view_3d
handles.output = hObject;
global hand_3d;
hand_3d = handles;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes view_3d wait for user response (see UIRESUME)
% uiwait(handles.view_3d_fig);

% --- Outputs from this function are returned to the command line.
function varargout = view_3d_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
init;

function plot_3d
    global hand_3d;
    global XYZ_win;
    global left_pos;
    global beat_color;
    global move_val;
    global data_table;
    
    for i = 1:Count_beats
        if (data_table(i) == 1)
            plot3(hand_3d.axes_right,XYZ_shared(i,left_pos:left_pos+move_val,1),XYZ_win(i,left_pos:left_pos+move_val,2),XYZ_win(i,left_pos:left_pos+move_val,3),'color',beat_color(i,:));
        end
    end

%Full screen    
function full_screen
    global hand_3d;
    set(hand_3d.view_3d_fig,'Units','Normalized','outerposition',[0 0 1 1]);
    
%Init window    
function init
    global hand_3d;
    global pos_axes_left;
    global pos_axes_right;
    global part_line_style;
    global values_width;
    global values_line_style;
    global values_markers;
    
    %Set window in full screen
    full_screen;
    
    %St labels on axes
    xlabel(hand_3d.axes_right,'X');
    ylabel(hand_3d.axes_right,'Y');
    zlabel(hand_3d.axes_right,'Z');
    xlabel(hand_3d.axes_left,'X');
    ylabel(hand_3d.axes_left,'Y');
    zlabel(hand_3d.axes_left,'Z');
    
    %Set default 3D position
    view(hand_3d.axes_right,-60,60);
    view(hand_3d.axes_left,-60,60);
    
    % Register Callbacks
    axes_right_rotate = rotate3d(hand_3d.axes_left);
    set(axes_right_rotate,'ActionPostCallback',@sync_rotate_right);
    set(axes_right_rotate,'ActionPreCallback',@sync_rotate_right);
    
    %Set parameters for size slider
    set(hand_3d.slider1,'value',50);
    pos_axes_right = get(hand_3d.axes_right,'Position');
    pos_axes_left = get(hand_3d.axes_left,'Position');
    
    %Create tab group
    hand_3d.tgroup = uitabgroup('Parent', hand_3d.P0,'TabLocation', 'top');
    hand_3d.tab1 = uitab('Parent', hand_3d.tgroup, 'Title', 'Control');
    hand_3d.tab2 = uitab('Parent', hand_3d.tgroup, 'Title', '2D graphs');
    hand_3d.tab3 = uitab('Parent', hand_3d.tgroup, 'Title', 'Others');
    
    %Place panels into each tab
    set(hand_3d.P1,'Parent',hand_3d.tab1);
    set(hand_3d.P2,'Parent',hand_3d.tab2);
    set(hand_3d.P3,'Parent',hand_3d.tab3);
    
    %Reposition each panel to same location as panel 1
    set(hand_3d.P2,'position',get(hand_3d.P1,'position'));
    set(hand_3d.P3,'position',get(hand_3d.P1,'position'));
        
    %init default values style
    values_width = {'1'; '1.5'; '2'; '2.5'; '3'};
    values_line_style =  {'-'; '--'; ':'; '-.'};
    values_markers = {'none'; 'o'; '+'; '*'; '.'; 'x'; 's'; 'd'; '^'; 'v'; '>'; '<'; 'p'; 'h'};
    part_line_style.color = 'red';
    
    %init examples
    part_line_style.style = char(values_line_style(get(hand_3d.popupmenu_style,'value')));
    part_line_style.width = str2double(char(values_width(get(hand_3d.popupmenu_width,'value'))));
    part_line_style.marker = char(values_markers(get(hand_3d.popupmenu_markers,'value'))); 
    plot_example(hand_3d.axes_example_part , part_line_style); %plot example
    set(hand_3d.pushbutton_color,'BackgroundColor',part_line_style.color);
    
    set(hand_3d.edit_left,'string',num2str(1));
    set(hand_3d.edit_right,'string',num2str(10));
    
    set(hand_3d.uitable_beats, 'CellEditCallback', @table_beats_checked);

%start from other program    
function external_init(main_val_in)
    global main_val;
    global hand_3d;
    main_val = main_val_in;
    
    set(hand_3d.uitable_beats,'data',main_val.data_table);
    draw(1,2);
    
%Draw graphs
function draw (left_graph, right_graph)
%{
Numbers:
0 - none draw
1 - loop
2 - part
3 - normal vector
4 - plane
%}
    global hand_3d;
    global main_val;
    
    if (left_graph ~= 0)
        cla(hand_3d.axes_left); 
    end
    
    if (right_graph ~= 0)
        cla(hand_3d.axes_right); 
    end
    
    %Left draw
    switch (left_graph)
        case 1
            for i = 1:main_val.Count_beats
                if (main_val.data_table(i) == 1)
                    draw_loop_part(hand_3d.axes_left,i);
                end
            end
        case 2
            for i = 1:main_val.Count_beats
                if (main_val.data_table(i) == 1)
                    draw_part(hand_3d.axes_left,i);
                end
            end
        case 3
            step = str2num(get(hand_3d.edit_step,'string'));
            beat_n = str2num(get(hand_3d.edit_beat_n,'string'));
            win_size = str2num(get(hand_3d.edit_window,'string'));
            start_point = main_val.left_pos;
            end_point = main_val.right_pos;
            [normal,Err] = func_normal_vector(hand_3d.axes_left ,main_val.XYZ_win, beat_n, step, win_size, start_point, end_point);
        case 4
            beat_n = str2num(get(hand_3d.edit_beat_n,'string'));
            start_point = main_val.left_pos;
            end_point = main_val.right_pos;
            [b] = func_non_leniar_plane(hand_3d.axes_left ,main_val.XYZ_win, beat_n, start_point, end_point);
        case 5
            beat_n = str2num(get(hand_3d.edit_beat_n,'string'));
            start_point = main_val.left_pos;
            end_point = main_val.right_pos;            
            [mdl] = func_non_leniar_plane_weidth(hand_3d.axes_left ,main_val.XYZ_win, beat_n, start_point, end_point);
        case 6 %Peaks
            start_point = main_val.left_pos;
            end_point = main_val.right_pos; 
            peaks_count = 2;
            peaks_dist = 100;
            axes = 'M';
            for i = 1:main_val.Count_beats
                if (main_val.data_table(i) == 1)
                    draw_part(hand_3d.axes_left,i);
                    [pks,locs] = func_find_extremum (main_val.XYZ_win, i, start_point, end_point, axes, peaks_count, peaks_dist);
                    hold(hand_3d.axes_left,'on');
                    plot3(hand_3d.axes_left,main_val.XYZ_win(i,locs,1),main_val.XYZ_win(i,locs,2),main_val.XYZ_win(i,locs,3),'or','Linewidth',2);
                    hold(hand_3d.axes_left,'off');
                end
            end
 
            
            
            
            
    end
            
    %Right draw
    switch (right_graph)
        case 1
            for i = 1:main_val.Count_beats
                if (main_val.data_table(i) == 1)
                    draw_loop_part(hand_3d.axes_right,i);
                end
            end
        case 2
            for i = 1:main_val.Count_beats
                if (main_val.data_table(i) == 1)
                    draw_part(hand_3d.axes_right,i);
                end
            end
        case 3
            step = str2num(get(hand_3d.edit_step,'string'));
            beat_n = str2num(get(hand_3d.edit_beat_n,'string'));
            win_size = str2num(get(hand_3d.edit_window,'string'));
            start_point = main_val.left_pos;
            end_point = main_val.right_pos;
            [normal,Err] = func_normal_vector(hand_3d.axes_right ,main_val.XYZ_win, beat_n, step, win_size, start_point, end_point);
        case 4
             beat_n = str2num(get(hand_3d.edit_beat_n,'string'));
             start_point = main_val.left_pos;
             end_point = main_val.right_pos;
             [b] = func_non_leniar_plane(hand_3d.axes_right ,main_val.XYZ_win, beat_n, start_point, end_point);  
        case 5
             beat_n = str2num(get(hand_3d.edit_beat_n,'string'));
             start_point = main_val.left_pos;
             end_point = main_val.right_pos;            
             [mdl] = func_non_leniar_plane_weidth(hand_3d.axes_right ,main_val.XYZ_win, beat_n, start_point, end_point);
    end    
    
function table_beats_checked(src, eventdata)
    global hand_3d;
    global main_val;

    row_changed = eventdata.Indices(1);
    if (main_val.data_table(row_changed) == true)
        main_val.data_table(row_changed) = false;
    else
        main_val.data_table(row_changed) = true;
        
    end
    set(hand_3d.uitable_beats,'data',main_val.data_table);  
    
%Draw part
function draw_part (handle_in,num)
    global main_val;

    hold(handle_in,'on');
    plot3(handle_in,main_val.XYZ_win(num,main_val.left_pos:main_val.left_pos+main_val.move_val,1),main_val.XYZ_win(num,main_val.left_pos:main_val.left_pos+main_val.move_val,2),main_val.XYZ_win(num,main_val.left_pos:main_val.left_pos+main_val.move_val,3),'color',main_val.beat_color(num,:),'LineWidth',2);
    hold(handle_in,'off');
    
%Draw loop and part
function draw_loop_part (handle_in,num)
    global main_val;
    global part_line_style;

    hold(handle_in,'on');
    %Draw loop
    plot3(handle_in,main_val.XYZ_win(num,main_val.win_left:main_val.left_pos,1),main_val.XYZ_win(num,main_val.win_left:main_val.left_pos,2),main_val.XYZ_win(num,main_val.win_left:main_val.left_pos,3),'color',main_val.beat_color(num,:),'LineWidth',2);          
    %plot3(handle_in,main_val.XYZ_win(num,main_val.right_pos:main_val.win_right,1),main_val.XYZ_win(num,main_val.right_pos:main_val.win_right,2),main_val.XYZ_win(num,main_val.right_pos:main_val.win_right,3),'color',main_val.beat_color(num,:),'LineWidth',2);          
    %Draw part on left graph
    plot3(handle_in,main_val.XYZ_win(num,main_val.left_pos:main_val.left_pos+main_val.move_val,1),main_val.XYZ_win(num,main_val.left_pos:main_val.left_pos+main_val.move_val,2),main_val.XYZ_win(num,main_val.left_pos:main_val.left_pos+main_val.move_val,3),'color',part_line_style.color,'LineWidth',part_line_style.width,'LineStyle',part_line_style.style,'Marker',part_line_style.marker);            
    hold(handle_in,'off');
            
% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    
function sync_rotate_right(obj,evd)
    global hand_3d;
    
    newView = get(hand_3d.axes_left,'View'); % Get view property of the plot that changed
    set(hand_3d.axes_right, 'View', newView); % Synchronize View property of both plots   
    
% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%Slider for resize of main axes
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
   
    global hand_3d;
    global pos_axes_left;
    global pos_axes_right;
    
    slider_value = get(hand_3d.slider1,'Value'); %get value
    
    if (slider_value >0)&&(slider_value<100)
        %Resize left graph
        pos_left = pos_axes_left;
        pos_left(3) = pos_axes_left(3)*slider_value/50;  
        if (slider_value <= 50)
            pos_left(4) = pos_axes_left(4)*(slider_value/50);
        end
        set(hand_3d.axes_left,'Position',pos_left);

        %Resize right graph
        pos_right = pos_axes_right;
        pos_right(3) = pos_axes_right(3) + pos_axes_right(3)*(1 - slider_value/50);
        pos_right(1) = pos_axes_right(1) + (pos_axes_right(3) - pos_right(3));
        if (slider_value >=50)
            pos_right(4) = pos_axes_left(4) + pos_axes_right(4)*(1 - slider_value/50);
        end
        set(hand_3d.axes_right,'Position',pos_right);
    end

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on button press in radiobutton5.
function radiobutton5_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton5


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
%X_Y tool bar
function uipushtool2_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global hand_3d
    view(hand_3d.axes_right,0,90);
    view(hand_3d.axes_left,0,90);
    
% --------------------------------------------------------------------
%X_Z tool bar
function uipushtool3_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global hand_3d
    view(hand_3d.axes_right,0,0);
    view(hand_3d.axes_left,0,0);

%Y_Z tool bar
% --------------------------------------------------------------------
function uipushtool5_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global hand_3d
    view(hand_3d.axes_right,90,0);
    view(hand_3d.axes_left,90,0);

%3D tool bar
% --------------------------------------------------------------------
function uipushtool6_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global hand_3d
    view(hand_3d.axes_right,-60,60);
    view(hand_3d.axes_left,-60,60);


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in checkbox_color.
function checkbox_color_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_color


% --- Executes on button press in checkbox_point.
function checkbox_point_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_point (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of checkbox_point

%Set marker
function popupmenu_markers_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_markers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_markers contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_markers
    global hand_3d;
    global part_line_style;
    global values_markers;
    
    part_line_style.marker = char(values_markers(get(hand_3d.popupmenu_markers,'value'))); 
    plot_example(hand_3d.axes_example_part , part_line_style); %plot example
    value_left = get(hand_3d.menu_left,'value');
    value_right = get(hand_3d.menu_right,'value');
    if (value_left == 1)
        draw(1, 0); %plot part on loop
    end
    if (value_right == 1)
        draw(0, 1); %plot part on loop
    end    

% --- Executes during object creation, after setting all properties.
function popupmenu_markers_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_markers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_style.
function popupmenu_style_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_style (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_style contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_style
    global hand_3d;
    global part_line_style;
    global values_line_style;
    
    part_line_style.style = char(values_line_style(get(hand_3d.popupmenu_style,'value')));
    plot_example(hand_3d.axes_example_part , part_line_style); %plot example
    value_left = get(hand_3d.menu_left,'value');
    value_right = get(hand_3d.menu_right,'value');
    if (value_left == 1)
        draw(1, 0); %plot part on loop
    end
    if (value_right == 1)
        draw(0, 1); %plot part on loop
    end  

% --- Executes during object creation, after setting all properties.
function popupmenu_style_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_style (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over button_color.
function button_color_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to button_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Plot example
function plot_example (handle_in, part_line_style_in)
    cla(handle_in);
    plot(handle_in,[1 2 3 4 5],[1 1 1 1 1],'color',part_line_style_in.color,'LineWidth',part_line_style_in.width,'LineStyle',part_line_style_in.style,'Marker',part_line_style_in.marker);
    set(handle_in,'Xticklabel',[],'Yticklabel',[]); %Del symbols on axes
    
%Change line width
function popupmenu_width_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_width contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_width
    global hand_3d;
    global part_line_style;
    global values_width;
    
    part_line_style.width = str2double(char(values_width(get(hand_3d.popupmenu_width,'value'))));
    plot_example(hand_3d.axes_example_part , part_line_style); %plot example
    value_left = get(hand_3d.menu_left,'value');
    value_right = get(hand_3d.menu_right,'value');
    if (value_left == 1)
        draw(1, 0); %plot part on loop
    end
    if (value_right == 1)
        draw(0, 1); %plot part on loop
    end  

% --- Executes during object creation, after setting all properties.
function popupmenu_width_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_color.
function pushbutton_color_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global hand_3d;
    global part_line_style;
    
    part_line_style.color = uisetcolor(part_line_style.color); %Open color dialog wich preset color
    plot_example(hand_3d.axes_example_part , part_line_style); %Replot example_plot
    set(hand_3d.pushbutton_color,'BackgroundColor',part_line_style.color);
    value_left = get(hand_3d.menu_left,'value');
    value_right = get(hand_3d.menu_right,'value');
    if (value_left == 1)
        draw(1, 0); %plot part on loop
    end
    if (value_right == 1)
        draw(0, 1); %plot part on loop
    end  


% --- Executes on selection change in listbox_movies.
function listbox_movies_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_movies (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_movies contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_movies


% --- Executes during object creation, after setting all properties.
function listbox_movies_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_movies (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_refrash.
function pushbutton_refrash_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_refrash (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global main_val;
    global hand_3d;
    
    main_val.data_table = get(hand_3d.uitable_beats,'data');
    value_left = get(hand_3d.menu_left,'value');
    value_right = get(hand_3d.menu_right,'value');
    draw(value_left, value_right); %plot part on loop
    

% --- Executes on button press in pushbutton_set.
function pushbutton_set_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_set (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global main_val;
    global hand_3d;
    
    first_beat = str2num(get(hand_3d.edit_left,'string'));
    last_beat = str2num(get(hand_3d.edit_right,'string'));
    
    main_val.data_table = false(main_val.Count_beats,1);
    main_val.data_table(first_beat:last_beat) = 1;
    set(hand_3d.uitable_beats,'data',main_val.data_table);
    value_left = get(hand_3d.menu_left,'value');
    value_right = get(hand_3d.menu_right,'value');
    draw(value_left, value_right); %plot part on loop


function edit_left_Callback(hObject, eventdata, handles)
% hObject    handle to edit_left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_left as text
%        str2double(get(hObject,'String')) returns contents of edit_left as a double


% --- Executes during object creation, after setting all properties.
function edit_left_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_right_Callback(hObject, eventdata, handles)
% hObject    handle to edit_right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_right as text
%        str2double(get(hObject,'String')) returns contents of edit_right as a double


% --- Executes during object creation, after setting all properties.
function edit_right_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_record.
function pushbutton_record_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_record (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global hand_3d;
    global main_val;
    global record;
    
    win_len = (main_val.right_pos-main_val.left_pos);

    % Initialize matrix using 'moviein'
    record = moviein(win_len); 

    move_val = 1;
    
    XLim = get(hand_3d.axes_right,'XLim');
    YLim = get(hand_3d.axes_right,'YLim');
    ZLim = get(hand_3d.axes_right,'ZLim');
    cla(hand_3d.axes_right);
    set(hand_3d.axes_right,'XLim',XLim);
    set(hand_3d.axes_right,'YLim',YLim);
    set(hand_3d.axes_right,'ZLim',ZLim);
    hold(hand_3d.axes_right,'on');
    for k = 1:win_len
        for i = 1:main_val.Count_beats
            if (main_val.data_table(i) == 1)
                plot3(hand_3d.axes_right,main_val.XYZ_win(i,main_val.left_pos:main_val.left_pos+move_val,1),main_val.XYZ_win(i,main_val.left_pos:main_val.left_pos+move_val,2),main_val.XYZ_win(i,main_val.left_pos:main_val.left_pos+move_val,3),'color',main_val.beat_color(i,:),'LineWidth',2);
            end
        end
        record(:,k) = getframe(hand_3d.axes_right);
        move_val = move_val + 1;
    end
    hold(hand_3d.axes_right,'off');
   
% --- Executes on button press in pushbutton_play.
function pushbutton_play_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global hand_3d;
    global record;
    
    movie(hand_3d.axes_right,record,2);

% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton18.
function pushbutton18_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_shift_left.
function pushbutton_shift_left_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_shift_left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_shift_right.
function pushbutton_shift_right_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_shift_right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in listbox_movies.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_movies (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_movies contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_movies


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_movies (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_name_Callback(hObject, eventdata, handles)
% hObject    handle to edit_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_name as text
%        str2double(get(hObject,'String')) returns contents of edit_name as a double


% --- Executes during object creation, after setting all properties.
function edit_name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton21.
function pushbutton21_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    


% --- Executes on selection change in menu_left.
function menu_left_Callback(hObject, eventdata, handles)
% hObject    handle to menu_left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menu_left contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menu_left
    global hand_3d;
    
    value = get(hand_3d.menu_left,'value');
    draw(value, 0);


% --- Executes during object creation, after setting all properties.
function menu_left_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menu_left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in menu_right.
function menu_right_Callback(hObject, eventdata, handles)
% hObject    handle to menu_right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menu_right contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menu_right
    global hand_3d;
    
    value = get(hand_3d.menu_right,'value');
    draw(0, value);

% --- Executes during object creation, after setting all properties.
function menu_right_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menu_right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_beat_n_Callback(hObject, eventdata, handles)
% hObject    handle to edit_beat_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_beat_n as text
%        str2double(get(hObject,'String')) returns contents of edit_beat_n as a double


% --- Executes during object creation, after setting all properties.
function edit_beat_n_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_beat_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_step_Callback(hObject, eventdata, handles)
% hObject    handle to edit_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_step as text
%        str2double(get(hObject,'String')) returns contents of edit_step as a double


% --- Executes during object creation, after setting all properties.
function edit_step_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_window_Callback(hObject, eventdata, handles)
% hObject    handle to edit_window (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_window as text
%        str2double(get(hObject,'String')) returns contents of edit_window as a double


% --- Executes during object creation, after setting all properties.
function edit_window_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_window (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox3.
function listbox3_Callback(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox3


% --- Executes during object creation, after setting all properties.
function listbox3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_update_vector.
function pushbutton_update_vector_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_update_vector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit_save_Callback(hObject, eventdata, handles)
% hObject    handle to edit_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_save as text
%        str2double(get(hObject,'String')) returns contents of edit_save as a double


% --- Executes during object creation, after setting all properties.
function edit_save_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_save.
function pushbutton_save_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_main_window.
function pushbutton_main_window_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_main_window (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global hand_3d;
    
    set(hand.view_3d_fig,'Visible','on');
