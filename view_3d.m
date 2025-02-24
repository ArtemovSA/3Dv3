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

% Last Modified by GUIDE v2.5 20-Jan-2016 16:47:37

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
    global part_line_style_l;
    global part_line_style_r;
    global values_width;
    global values_line_style;
    global values_markers;
    global Rotate_en;
    
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
    Rotate_en = 1;
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
    values_markers = {'n'; 'o'; '+'; '*'; '.'; 'x'; 's'; 'd'; '^'; 'v'; '>'; '<'; 'p'; 'h'};
    part_line_style_l.color = 'red';
    part_line_style_r.color = 'red';
    
    %init examples left
    part_line_style_l.style = char(values_line_style(get(hand_3d.popupmenu_style_l,'value')));
    part_line_style_l.width = str2double(char(values_width(get(hand_3d.popupmenu_width_l,'value'))));
    part_line_style_l.marker = char(values_markers(get(hand_3d.popupmenu_markers_l,'value')));
    plot_example(hand_3d.axes_example_part_l, part_line_style_l); %plot example
    set(hand_3d.axes_example_part_l,'ButtonDownFcn',@axes_example_l_ClickCallback);
    
    %init examples right
    part_line_style_r.style = char(values_line_style(get(hand_3d.popupmenu_style_r,'value')));
    part_line_style_r.width = str2double(char(values_width(get(hand_3d.popupmenu_width_r,'value'))));
    part_line_style_r.marker = char(values_markers(get(hand_3d.popupmenu_markers_r,'value'))); 
    plot_example(hand_3d.axes_example_part_r, part_line_style_r); %plot example
    set(hand_3d.axes_example_part_r,'ButtonDownFcn',@axes_example_r_ClickCallback);

%Click to example left
function axes_example_l_ClickCallback (hObject , eventData)
    global hand_3d;
    global part_line_style_l;
    
    part_line_style_l.color = uisetcolor(part_line_style_l.color); %Open color dialog wich preset color
    plot_example(hand_3d.axes_example_part_l , part_line_style_l); %Replot example_plot
    value = get(hand_3d.menu_left,'value');
    draw(value, 0); %plot part on loop
    
%Click to example right
function axes_example_r_ClickCallback (hObject , eventData)
    global hand_3d;
    global part_line_style_r;
    
    part_line_style_r.color = uisetcolor(part_line_style_r.color); %Open color dialog wich preset color
    plot_example(hand_3d.axes_example_part_r , part_line_style_r); %Replot example_plot
    value = get(hand_3d.menu_right,'value');
    draw(0, value);

    
%start from other program    
function external_init(main_val_in)
    global main_val;
    global hand_3d;
    main_val = main_val_in;
    
    draw(1,2);
    
    %load records
    load_records(1);
    
%Draw graphs
function draw (left_graph, right_graph)
    global part_line_style_l;
    global part_line_style_r;
%{
Numbers:
0 - none draw
1 - loop
2 - part
3 - normal vector
4 - plane
5 - plane weidth
6 - peaks
7 - Fit 3D
8 - Sphere N_Vector
9 - DTW
%}
    global hand_3d;
    global main_val;
    global Rotate_en;

    Rotate_en = 1;
    axis(hand_3d.axes_left, 'auto');
    
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
                    draw_loop_part(hand_3d.axes_left,i,part_line_style_l);
                end
            end
        case 2
            for i = 1:main_val.Count_beats
                if (main_val.data_table(i) == 1)
                    draw_part(hand_3d.axes_left,i,part_line_style_l);
                end
            end
        case 3 %normal vector
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
            start_point = round(main_val.left_pos);
            end_point = round(main_val.right_pos); 
            peaks_count = str2num(get(hand_3d.edit_peaks_count,'string'));
            peaks_dist = str2num(get(hand_3d.edit_peaks_dist,'string'));
            switch (get(hand_3d.popupmenu_vector,'value'))
                case 1
                    axes = 'X';
                case 2 
                    axes = 'Y';
                case 3
                    axes = 'Z';
                case 4
                    axes = 'M';
            end
            for i = 1:main_val.Count_beats
                if (main_val.data_table(i) == 1)
                    draw_part(hand_3d.axes_left,i,part_line_style_l);
                    [pks,locs] = func_find_extremum (main_val.XYZ_win, i, start_point, end_point, axes, peaks_count, peaks_dist);
                    hold(hand_3d.axes_left,'on');
                    plot3(hand_3d.axes_left,main_val.XYZ_win(i,start_point+locs,1),main_val.XYZ_win(i,start_point+locs,2),main_val.XYZ_win(i,start_point+locs,3),'or','Linewidth',2);
                    hold(hand_3d.axes_left,'off');
                end
            end   
        case 7 %Fit 3D
            beat_n = str2num(get(hand_3d.edit_beat_n_fit,'string'));
            start_point = main_val.left_pos;
            end_point = main_val.right_pos;
            switch (get(hand_3d.popupmenu_approx_type,'value'))
                case 1
                    approx_type = 'plane';
                case 2
                    approx_type = 'line'; 
            end
            [Err,N,P] = func_fit_3D_data(hand_3d.axes_left, main_val.XYZ_win(beat_n,start_point:end_point,1), main_val.XYZ_win(beat_n,start_point:end_point,2), main_val.XYZ_win(beat_n,start_point:end_point,3), approx_type, 'on', 'on');
            set(hand_3d.edit_error,'String',num2str(Err));
        case 8 %Sphere n_vector
            Rotate_en = 0;
            step = str2num(get(hand_3d.edit_step,'string'));
            beat_n = str2num(get(hand_3d.edit_beat_n,'string'));
            win_size = str2num(get(hand_3d.edit_window,'string'));
            start_point = main_val.left_pos;
            end_point = main_val.right_pos;
            [normal,Err] = func_sphere_normal_vector(hand_3d.axes_left, hand_3d.axes_right ,main_val.XYZ_win, beat_n, step, win_size, start_point, end_point, 'off','on');
            %[pind,xs,ys] = selectdata('sel','br');
            %display(xs);
        case 9 %DTW
            beat_n_1 = str2num(get(hand_3d.edit_beat_1,'string'));
            beat_n_2 = str2num(get(hand_3d.edit_beat_2,'string'));
            start_point = main_val.left_pos;
            end_point = main_val.right_pos;
            switch (get(hand_3d.popupmenu_dtw_ax,'value'))
                case 1
                    axes_dtw = 'X';
                case 2 
                    axes_dtw = 'Y';
                case 3
                    axes_dtw = 'Z';
                case 4
                    axes_dtw = 'M';
                case 5
                    axes_dtw = '3D';
            end
            show_dtw_path = get(hand_3d.checkbox_path,'value');
            func_DTW(hand_3d.axes_left, hand_3d.axes_right, main_val.XYZ_win, beat_n_1, beat_n_2, start_point, end_point, axes_dtw, show_dtw_path);
    end
            
    %Right draw
    switch (right_graph)
        case 1
            for i = 1:main_val.Count_beats
                if (main_val.data_table(i) == 1)
                    draw_loop_part(hand_3d.axes_right,i, part_line_style_r);
                end
            end
        case 2
            for i = 1:main_val.Count_beats
                if (main_val.data_table(i) == 1)
                    draw_part(hand_3d.axes_right,i, part_line_style_r);
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
        case 6 %Peaks
            start_point = round(main_val.left_pos);
            end_point = round(main_val.right_pos); 
            peaks_count = str2double(get(hand_3d.edit_peaks_count,'string'));
            peaks_dist = str2double(get(hand_3d.edit_peaks_dist,'string'));
            switch (get(hand_3d.popupmenu_vector,'value'))
                case 1
                    axes = 'X';
                case 2 
                    axes = 'Y';
                case 3
                    axes = 'Z';
                case 4
                    axes = 'M';
            end
            for i = 1:main_val.Count_beats
                if (main_val.data_table(i) == 1)
                    draw_part(hand_3d.axes_right,i,part_line_style_r);
                    [pks,locs] = func_find_extremum (main_val.XYZ_win, i, start_point, end_point, axes, peaks_count, peaks_dist);
                    hold(hand_3d.axes_right,'on');
                    plot3(hand_3d.axes_right,main_val.XYZ_win(i,start_point+locs,1),main_val.XYZ_win(i,start_point+locs,2),main_val.XYZ_win(i,start_point+locs,3),'or','Linewidth',2);
                    hold(hand_3d.axes_right,'off');
                end
            end  
        case 7 %Fit 3D
            beat_n = str2num(get(hand_3d.edit_beat_n_fit,'string'));
            start_point = main_val.left_pos;
            end_point = main_val.right_pos;
            switch (get(hand_3d.popupmenu_approx_type,'value'))
                case 1
                    approx_type = 'plane';
                case 2
                    approx_type = 'line'; 
            end
            [Err,N,P] = func_fit_3D_data(hand_3d.axes_right, main_val.XYZ_win(beat_n,start_point:end_point,1), main_val.XYZ_win(beat_n,start_point:end_point,2), main_val.XYZ_win(beat_n,start_point:end_point,3), approx_type, 'on', 'on');
            set(hand_3d.edit_error,'String',num2str(Err));
        case 8 %DTW
            beat_n_1 = str2num(get(hand_3d.edit_beat_1,'string'));
            beat_n_2 = str2num(get(hand_3d.edit_beat_2,'string'));
            start_point = main_val.left_pos;
            end_point = main_val.right_pos;
            switch (get(hand_3d.popupmenu_dtw_ax,'value'))
                case 1
                    axes_dtw = 'X';
                case 2 
                    axes_dtw = 'Y';
                case 3
                    axes_dtw = 'Z';
                case 4
                    axes_dtw = 'M';
            end
            show_dtw_path = get(hand_3d.checkbox_path,'value');
            func_DTW_3D(hand_3d.axes_right, main_val.XYZ_win, beat_n_1, beat_n_2, start_point, end_point, axes_dtw, show_dtw_path);   
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
    
%Draw part
function draw_part (handle_in,num, part_line_style_in)
    global main_val;
  
    hold(handle_in,'on');
    plot3(handle_in,main_val.XYZ_win(num,main_val.left_pos:main_val.left_pos+main_val.move_val,1),main_val.XYZ_win(num,main_val.left_pos:main_val.left_pos+main_val.move_val,2),main_val.XYZ_win(num,main_val.left_pos:main_val.left_pos+main_val.move_val,3),'color',main_val.beat_color(num,:),'LineWidth',part_line_style_in.width,'LineStyle',part_line_style_in.style,'Marker',part_line_style_in.marker);
    hold(handle_in,'off');
    
%Draw loop and part
function draw_loop_part (handle_in,num, part_line_style_in)
    global main_val;

    hold(handle_in,'on');
    %Draw loop
    plot3(handle_in,main_val.XYZ_win(num,main_val.win_left:main_val.left_pos,1),main_val.XYZ_win(num,main_val.win_left:main_val.left_pos,2),main_val.XYZ_win(num,main_val.win_left:main_val.left_pos,3),'color',main_val.beat_color(num,:),'LineWidth',2);          
    %plot3(handle_in,main_val.XYZ_win(num,main_val.right_pos:main_val.win_right,1),main_val.XYZ_win(num,main_val.right_pos:main_val.win_right,2),main_val.XYZ_win(num,main_val.right_pos:main_val.win_right,3),'color',main_val.beat_color(num,:),'LineWidth',2);          
    %Draw part on left graph
    plot3(handle_in,main_val.XYZ_win(num,main_val.left_pos:main_val.left_pos+main_val.move_val,1),main_val.XYZ_win(num,main_val.left_pos:main_val.left_pos+main_val.move_val,2),main_val.XYZ_win(num,main_val.left_pos:main_val.left_pos+main_val.move_val,3),'color',part_line_style_in.color,'LineWidth',part_line_style_in.width,'LineStyle',part_line_style_in.style,'Marker',part_line_style_in.marker);            
    hold(handle_in,'off');
             
function sync_rotate_right(obj,evd)
    global hand_3d;
    global Rotate_en;
    
    if (Rotate_en == 1)
        newView = get(hand_3d.axes_left,'View'); % Get view property of the plot that changed
        set(hand_3d.axes_right, 'View', newView); % Synchronize View property of both plots  
    end;
    
% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)


%Slider for resize of main axes
function slider1_Callback(hObject, eventdata, handles)
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

% --------------------------------------------------------------------
%X_Y tool bar
function uipushtool2_ClickedCallback(hObject, eventdata, handles)
    global hand_3d
    view(hand_3d.axes_right,0,90);
    view(hand_3d.axes_left,0,90);
    
% --------------------------------------------------------------------
%X_Z tool bar
function uipushtool3_ClickedCallback(hObject, eventdata, handles)
    global hand_3d
    view(hand_3d.axes_right,0,0);
    view(hand_3d.axes_left,0,0);

%Y_Z tool bar
% --------------------------------------------------------------------
function uipushtool5_ClickedCallback(hObject, eventdata, handles)
    global hand_3d
    view(hand_3d.axes_right,90,0);
    view(hand_3d.axes_left,90,0);

%3D tool bar
% --------------------------------------------------------------------
function uipushtool6_ClickedCallback(hObject, eventdata, handles)
    global hand_3d
    view(hand_3d.axes_right,-60,60);
    view(hand_3d.axes_left,-60,60);

% --- Executes on selection change in popupmenu_style_l.
function popupmenu_style_l_Callback(hObject, eventdata, handles)
    global hand_3d;
    global part_line_style_l;
    global values_line_style;
    
    part_line_style_l.style = char(values_line_style(get(hand_3d.popupmenu_style_l,'value')));
    plot_example(hand_3d.axes_example_part_l , part_line_style_l); %plot example
    value = get(hand_3d.menu_left,'value');
    draw(value, 0);

%Plot example
function plot_example (handle_in, part_line_style_in)
    cla(handle_in);
    plot(handle_in,[1 2 3 4 5],[1 1 1 1 1],'color',part_line_style_in.color,'LineWidth',part_line_style_in.width,'LineStyle',part_line_style_in.style,'Marker',part_line_style_in.marker);
    set(handle_in,'Xticklabel',[],'Yticklabel',[]); %Del symbols on axes
    
%Change line width
function popupmenu_width_l_Callback(hObject, eventdata, handles)
    global hand_3d;
    global part_line_style_l;
    global values_width;
    
    part_line_style_l.width = str2double(char(values_width(get(hand_3d.popupmenu_width_l,'value'))));
    plot_example(hand_3d.axes_example_part_l , part_line_style_l); %plot example
    value = get(hand_3d.menu_left,'value');
    draw(value, 0); %plot part on loop

% --- Executes on button press in pushbutton_record.
function pushbutton_record_Callback(hObject, eventdata, handles)
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
    
    set(hand_3d.edit_save,'BackgroundColor',[1 0 0]);

% --- Executes on button press in pushbutton_update_fit3D.
function pushbutton_update_fit3D_Callback(hObject, eventdata, handles)
    global hand_3d;
    
    value_left = get(hand_3d.menu_left,'value');
    value_right = get(hand_3d.menu_right,'value');
    if (value_left == 7)
        draw(value_left, 0);
    end
    if (value_right == 7)
        draw(0, value_right);
    end
    
% --- Executes on button press in pushbutton_play.
function pushbutton_play_Callback(hObject, eventdata, handles)
    global hand_3d;
    global record;
   
    movie(hand_3d.axes_right,record,2);

% --- Executes on selection change in menu_left.
function menu_left_Callback(hObject, eventdata, handles)
    global hand_3d;
    
    value = get(hand_3d.menu_left,'value');
    draw(value, 0);

% --- Executes on selection change in menu_right.
function menu_right_Callback(hObject, eventdata, handles)
    global hand_3d;
    
    value = get(hand_3d.menu_right,'value');
    draw(0, value);

% --- Executes on selection change in listbox_rec.
function listbox_rec_Callback(hObject, eventdata, handles)
    global record;
    global hand_3d;
    global rec_var;
    
    r = cell2struct(rec_var.rec(get(hand_3d.listbox_rec,'Value')), {'record'}, 1);
    record = r.record;

% --- Executes on button press in pushbutton_update_vector.
function pushbutton_update_vector_Callback(hObject, eventdata, handles)
    global hand_3d;
    
    value_left = get(hand_3d.menu_left,'value');
    value_right = get(hand_3d.menu_right,'value');
    if (value_left == 3)
        draw(value_left, 0);
    end
    if (value_right == 3)
        draw(0, value_right);
    end
    if (value_left == 8)
        draw(value_left, 0);
    end

function edit_save_Callback(hObject, eventdata, handles)

% --- Executes on button press in pushbutton_save.
function pushbutton_save_Callback(hObject, eventdata, handles)
    global record;
    global hand_3d;
    name_file = 'movies.mat';
    
    if exist(name_file, 'file')
        % File exists.
        load(name_file);
        count = count + 1;
        rec_name(count) = {get(hand_3d.edit_save,'string')};
        rec(count) = {record};
    else
        % File does not exist.
        count = 1;
        rec_name = {get(hand_3d.edit_save,'string')};
        rec = {record};
    end
    
    save('movies.mat','rec','rec_name','count');
    set(hand_3d.edit_save,'BackgroundColor',[0 1 0]);
    load_records(count);
  
function load_records(value)
    global hand_3d;
    global rec_var;
    name_file = 'movies.mat';
    
    if exist(name_file, 'file')
        % File exists.
        load(name_file);
        set(hand_3d.listbox_rec,'String',rec_name);
        set(hand_3d.edit_save,'String',['REC' num2str(count+1)]);
        set(hand_3d.listbox_rec,'Enable','on');
        set(hand_3d.listbox_rec,'value',value);
        rec_var.rec_name = rec_name;
        rec_var.rec = rec;
        rec_var.count = count;
    else
        set(hand_3d.listbox_rec,'String','File non exist');
        set(hand_3d.listbox_rec,'Enable','off');
    end

% --- Executes on button press in pushbutton_main_window.
function pushbutton_main_window_Callback(hObject, eventdata, handles)
    global hand_3d;
    
    set(hand.view_3d_fig,'Visible','on');

% --- Executes on selection change in popupmenu_markers_r.
function popupmenu_markers_r_Callback(hObject, eventdata, handles)
    global hand_3d;
    global part_line_style_r;
    global values_markers;
    
    part_line_style_r.marker = char(values_markers(get(hand_3d.popupmenu_markers_r,'value'))); 
    plot_example(hand_3d.axes_example_part_r , part_line_style_r); %plot example
    value = get(hand_3d.menu_right,'value');
    draw(0, value);

% --- Executes on selection change in popupmenu_style_r.
function popupmenu_style_r_Callback(hObject, eventdata, handles)
    global hand_3d;
    global part_line_style_r;
    global values_line_style;
    
    part_line_style_r.style = char(values_line_style(get(hand_3d.popupmenu_style_r,'value')));
    plot_example(hand_3d.axes_example_part_r , part_line_style_r); %plot example
    value = get(hand_3d.menu_right,'value');
    draw(0, value);

% --- Executes on selection change in popupmenu_width_r.
function popupmenu_width_r_Callback(hObject, eventdata, handles)
    global hand_3d;
    global part_line_style_r;
    global values_width;
    
    part_line_style_r.width = str2double(char(values_width(get(hand_3d.popupmenu_width_r,'value'))));
    plot_example(hand_3d.axes_example_part_r , part_line_style_r); %plot example
    value = get(hand_3d.menu_right,'value');
    draw(0, value); %plot part on loop

% --- Executes on selection change in popupmenu_markers_l.
function popupmenu_markers_l_Callback(hObject, eventdata, handles)
    global hand_3d;
    global part_line_style_l;
    global values_markers;
    
    part_line_style_l.marker = char(values_markers(get(hand_3d.popupmenu_markers_l,'value'))); 
    plot_example(hand_3d.axes_example_part_l , part_line_style_l); %plot example
    value_left = get(hand_3d.menu_left,'value');
    draw(value_left, 0); %plot part on loop

% --- Executes on button press in pushbutton_update_peaks.
function pushbutton_update_peaks_Callback(hObject, eventdata, handles)
    global hand_3d;
    
    value_left = get(hand_3d.menu_left,'value');
    value_right = get(hand_3d.menu_right,'value');
    if (value_left == 6)
        draw(value_left, 0);
    end
    if (value_right == 6)
        draw(0, value_right);
    end

% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)

% --- Executes on button press in pushbutton18.
function pushbutton18_Callback(hObject, eventdata, handles)

% --- Executes on button press in pushbutton_shift_left.
function pushbutton_shift_left_Callback(hObject, eventdata, handles)

% --- Executes on button press in pushbutton_shift_right.
function pushbutton_shift_right_Callback(hObject, eventdata, handles)

% --- Executes on selection change in listbox_movies.
function listbox_movies_Callback(hObject, eventdata, handles)

% --- Executes on selection change in listbox_movies.
function listbox2_Callback(hObject, eventdata, handles)

% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)

function edit_name_Callback(hObject, eventdata, handles)

function button_color_ButtonDownFcn(hObject, eventdata, handles)

% --- Executes on button press in pushbutton21.
function pushbutton21_Callback(hObject, eventdata, handles)
  
function edit_beat_n_Callback(hObject, eventdata, handles)

function edit_step_Callback(hObject, eventdata, handles)

function edit_window_Callback(hObject, eventdata, handles)
   
% --- Executes on button press in pushbutton_del.
function pushbutton_del_Callback(hObject, eventdata, handles)
    global hand_3d;
    name_file = 'movies.mat';
    
    if exist(name_file, 'file')
        % File exists.
        load(name_file);
        pos = get(hand_3d.listbox_rec,'Value');
        rec_name_out(1:pos-1) = rec_name(1:pos-1);
        rec_name_out(pos:count-1) = rec_name(pos+1:count);
        rec_out(1:pos-1) = rec(1:pos-1);
        rec_out(pos:count-1) = rec(pos+1:count);
        count_out = count - 1;  
    end
    
    rec_name = rec_name_out;
    rec = rec_out;
    count = count_out;
    save(name_file,'rec','rec_name','count');
    load_records(count);

% --- Executes on button press in pushbutton_stop.
function pushbutton_stop_Callback(hObject, eventdata, handles)
    
function edit_peaks_count_Callback(hObject, eventdata, handles)

% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)

% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)

% --- Executes on button press in checkbox_color.
function checkbox_color_Callback(hObject, eventdata, handles)

% --- Executes on button press in checkbox_point.
function checkbox_point_Callback(hObject, eventdata, handles)

function edit_peaks_dist_Callback(hObject, eventdata, handles)

function edit10_Callback(hObject, eventdata, handles)

% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)

% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)

% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)

% --- Executes on button press in radiobutton5.
function radiobutton5_Callback(hObject, eventdata, handles)

% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
    
% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, ~)

% --- Executes on selection change in popupmenu_vector.
function popupmenu_vector_Callback(hObject, eventdata, handles)

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)

function edit_left_Callback(hObject, eventdata, handles)

function edit_right_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function popupmenu_style_r_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function popupmenu_markers_l_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function popupmenu_markers_r_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function popupmenu_vector_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function popupmenu_width_r_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit_peaks_dist_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit_peaks_count_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit_save_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function listbox_rec_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit_window_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit_step_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit_beat_n_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function menu_right_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function menu_left_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit_name_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit_right_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit_left_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function listbox_movies_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function popupmenu_width_l_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function popupmenu_style_l_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit_beat_n_fit_Callback(hObject, eventdata, handles)
% hObject    handle to edit_beat_n_fit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_beat_n_fit as text
%        str2double(get(hObject,'String')) returns contents of edit_beat_n_fit as a double


% --- Executes during object creation, after setting all properties.
function edit_beat_n_fit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_beat_n_fit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_error_Callback(hObject, eventdata, handles)
% hObject    handle to edit_error (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_error as text
%        str2double(get(hObject,'String')) returns contents of edit_error as a double


% --- Executes during object creation, after setting all properties.
function edit_error_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_error (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_approx_type.
function popupmenu_approx_type_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_approx_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_approx_type contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_approx_type


% --- Executes during object creation, after setting all properties.
function popupmenu_approx_type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_approx_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_update_fit_3D.
function pushbutton_update_fit_3D_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_update_fit_3D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit_beat_1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_beat_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_beat_1 as text
%        str2double(get(hObject,'String')) returns contents of edit_beat_1 as a double


% --- Executes during object creation, after setting all properties.
function edit_beat_1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_beat_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton36.
function pushbutton36_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_dtw_update.
function pushbutton_dtw_update_Callback(hObject, eventdata, handles)
    global hand_3d;
    
    value_left = get(hand_3d.menu_left,'value');
    value_right = get(hand_3d.menu_right,'value');
    if (value_left == 9)
        draw(value_left, 0);
    end
    if (value_right == 9)
        draw(0, value_right);
    end



function edit_beat_2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_beat_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_beat_2 as text
%        str2double(get(hObject,'String')) returns contents of edit_beat_2 as a double


% --- Executes during object creation, after setting all properties.
function edit_beat_2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_beat_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton38.
function pushbutton38_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton38 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu_dtw_ax.
function popupmenu_dtw_ax_Callback(hObject, eventdata, handles)
    global hand_3d;
    
    value_left = get(hand_3d.menu_left,'value');
    value_right = get(hand_3d.menu_right,'value');
    if (value_left == 9)
        draw(value_left, 0);
    end
    if (value_right == 9)
        draw(0, value_right);
    end

% --- Executes during object creation, after setting all properties.
function popupmenu_dtw_ax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_dtw_ax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_path.
function checkbox_path_Callback(hObject, eventdata, handles)
    global hand_3d;
    
    value_left = get(hand_3d.menu_left,'value');
    value_right = get(hand_3d.menu_right,'value');
    if (value_left == 9)
        draw(value_left, 0);
    end
    if (value_right == 9)
        draw(0, value_right);
    end


% --- Executes on mouse press over axes background.
function axes_right_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes_right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
