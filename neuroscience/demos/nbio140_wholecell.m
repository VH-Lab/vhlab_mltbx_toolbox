function varargout = nbio140_wholecell(varargin)
% NBIO140_WHOLECELL - A gui to simulate a Hodgkin-Huxley recording in voltage clamp/current clamp
%
%   NBIO140_WHOLECELL()
%
%   Brings up a graphical user interface to allow the user to explore a
%   current clamp/voltage clamp environment with Hodgkin-Huxley channels.
%


 % TO DO:
 %   ADD CHANNEL-OPEN GRAPH
 %   V_Initial value
 %   VOLTAGE_CLAMP MODE
 %   SMALLER SIMULATION STEPS (or decide to forget this)

  % add number of spikes to cluster info, compute mean waveforms
   
 % internal variables, for the function only

command = 'Main';    % internal variable, the command
fig = '';                 % the figure
success = 0;
windowheight =      450;
windowwidth =       800;
windowrowheight =    35;
HH = HHclass();

 % user-specified variables
windowlabel = 'NBIO 140 WHOLE CELL SETUP';

varlist = {'windowheight','windowwidth','windowrowheight','windowlabel','HH'};

assign(varargin{:});

if isempty(fig),
	z = findobj(allchild(0),'flat','tag','nbio140_wholecell');
	if isempty(z),
		fig = figure('name',windowlabel,'NumberTitle','off','Color',[0.8 0.8 0.8]); % we need to make a new figure
	else,
		fig = z;
		figure(fig);
	end;
end;

 % initialize userdata field
if strcmp(command,'Main'),
	for i=1:length(varlist),
		eval(['ud.' varlist{i} '=' varlist{i} ';']);
	end;
else,
	ud = get(fig,'userdata');
end;

command,

switch command,
	case 'Main',
		set(fig,'userdata',ud);
		nbio140_wholecell('command','NewWindow','fig',fig);
	case 'NewWindow',
		% control object defaults

		% this callback was a nasty puzzle in quotations:
		callbackstr = [  'eval([get(gcbf,''Tag'') ''(''''command'''','''''' get(gcbo,''Tag'') '''''' ,''''fig'''',gcbf);'']);']; 

		button.Units = 'pixels';
                button.BackgroundColor = [0.8 0.8 0.8];
                button.HorizontalAlignment = 'center';
                button.Callback = callbackstr;
                txt.Units = 'pixels';
		txt.BackgroundColor = [0.8 0.8 0.8];
                txt.fontsize = 12;
		txt.fontweight = 'normal';
                txt.HorizontalAlignment = 'left';
		txt.Style='text';
                edit = txt;
		edit.BackgroundColor = [ 1 1 1];
		edit.Style = 'Edit';
                popup = txt;
		popup.style = 'popupmenu';
                popup.Callback = callbackstr;
		list = txt;
		list.style = 'list';
		list.Callback = callbackstr;
                cb = txt;
		cb.Style = 'Checkbox';
                cb.Callback = callbackstr;
                cb.fontsize = 12;

		right = ud.windowwidth;
		top = ud.windowheight;
		row = ud.windowrowheight;

		set(fig,'position',[50 50 right top],'tag','nbio140_wholecell');

		% TOP

		uicontrol(txt,'position',[5 top-row*1 600 30],'string',ud.windowlabel,'horizontalalignment','left','fontweight','bold', ...
			'fontsize',16);

		% upper-right pop-up menu
		uicontrol(txt,'position',[right-200 top-row*1 100 30],'string','Exercise:','horizontalalignment','left','fontweight','bold');
		uicontrol(popup,'position',[right-100 top-row*1 100 30],'string',{'Lab 1','Lab 2','Lab 3'},'value',1);

		% LEFT: CELL AND SYNAPSE PARAMETERS

		paramwidth = 130;

		% cell parameter group, upper left
		uicontrol(txt,'position',[5 top-row*2 200 30],'string','Cell properties','horizontalalignment','left','fontweight','bold');
		uicontrol(txt,'position',[5 top-row*3 100 30],'string','[Rl Cm]','horizontalalignment','left');
		uicontrol(edit,'position',[5+100 top-row*3 paramwidth 30],'string','[33.3e6 100e-12]','tag','RlCmEdit');
		uicontrol(txt,'position',[5 top-row*4 100 30],'string','[E_l E_Na E_k]','horizontalalignment','left');
		uicontrol(edit,'position',[5+100 top-row*4 paramwidth 30],'string','[-0.070 0.045 -0.082]','tag','RevEdit');
		uicontrol(txt,'position',[5 top-row*5 100 30],'string','[GNa Gk]','horizontalalignment','left');
		uicontrol(edit,'position',[5+100 top-row*5 paramwidth 30],'string','[12e-6 3.6e-6]','tag','ChannelConductancesEdit');

		% synapse parameter group, lower left
		uicontrol(txt,'position',[5 top-row*6 200 30],'string','Synapse properties','horizontalalignment','left','fontweight','bold');
		uicontrol(txt,'position',[5 top-row*7 100 30],'string','[E_E E_I]','horizontalalignment','left');
		uicontrol(edit,'position',[5+100 top-row*7 paramwidth 30],'string','[0 -0.090]','tag','SynRevEdit');
		uicontrol(txt,'position',[5 top-row*8 100 30],'string','AMPA: [P N Q]','horizontalalignment','left');
		uicontrol(edit,'position',[5+100 top-row*8 paramwidth 30],'string','[1 1 1]','tag','AMPA_Syn_Edit');
		uicontrol(txt,'position',[5 top-row*9 100 30],'string','NMDA: [P N Q]','horizontalalignment','left');
		uicontrol(edit,'position',[5+100 top-row*9 paramwidth 30],'string','[1 1 1]','tag','NMDA_Syn_Edit');
		uicontrol(txt,'position',[5 top-row*9 100 30],'string','GABA: [P N Q]','horizontalalignment','left');
		uicontrol(edit,'position',[5+100 top-row*9 paramwidth 30],'string','[1 1 1]','tag','GABA_Syn_Edit');
		uicontrol(txt,'position',[5 top-row*10 100 30],'string','SynTime: [1 2]','horizontalalignment','left');
		uicontrol(edit,'position',[5+100 top-row*10 paramwidth 30],'string','[0 0.25]','tag','SynTimesEdit');
			
		% AXES, IN CENTER COLUMN

		ax_left = 210+75;
		ax_right = right - 210;
		ax_width = ax_right - ax_left + 1;

		ax_v = axes('units','pixels','position',[ax_left top-row*6 ax_width row*4],'tag','VoltageAxes');
		axis([0 0.5 -0.120 0.05]);
		title('Voltage');
		ylabel('Vm (V)');
		ax_i = axes('units','pixels','position',[ax_left top-row*11 ax_width row*4],'tag','CurrentAxes');
		axis([0 0.5 -5e-9 5e9]);
		title('Current');
		ylabel('Im (A)');
		linkaxes([ax_v ax_i],'x');
		xlabel('Time (s)');

		% RIGHT COLUMN
		rightcol_left = right - 200;
		skip = 5;
		middle = 100;
		
		% operation
		uicontrol(txt,'position',  [skip+rightcol_left top-row*2 200 30],'string','Operation',...
			'horizontalalignment','left','fontweight','bold');
		uicontrol(txt,'position',  [skip+rightcol_left top-row*3 100 30],'string','Mode:','horizontalalignment','left');
		uicontrol(popup,'position',[skip+rightcol_left+middle-30 top-row*3 100+30 30],'string',{'Current Clamp', 'Voltage Clamp'},...
			'value',1,'tag','ClampPopup');
		uicontrol(txt,'position',  [skip+rightcol_left top-row*4 100 30],'string','Step [1 2]','horizontalalignment','left');
		uicontrol(edit,'position', [skip+rightcol_left+middle top-row*4 100 30],'string','[1e-9 0]', 'tag','StepValuesEdit');
		uicontrol(txt,'position',  [skip+rightcol_left top-row*5 100 30],'string','Step Time [1 2]','horizontalalignment','left');
		uicontrol(edit,'position', [skip+rightcol_left+middle top-row*5 100 30],'string','[0 0.5]', 'tag','StepTimesEdit');
		uicontrol(txt,'position',  [skip+rightcol_left top-row*6 100 30],'string','Sin [Amp F]','horizontalalignment','left');
		uicontrol(edit,'position', [skip+rightcol_left+middle top-row*6 100 30],'string','[0 4]', 'tag','SinAmpFEdit');
		uicontrol(cb,'position',   [skip+rightcol_left top-row*7 100 30],'string','TEA','value',0,'tag','TEACB');
		uicontrol(cb,'position',   [skip+rightcol_left+middle top-row*7 100 30],'string','TTX','value',0,'tag','TTXCB');
		uicontrol(cb,'position',   [skip+rightcol_left top-row*8 100 30],'string','AMPA','value',0,'tag','AMPACB');
		uicontrol(cb,'position',   [skip+rightcol_left+middle top-row*8 100 30],'string','NMDA','value',0,'tag','NMDACB');
		uicontrol(cb,'position',   [skip+rightcol_left top-row*9 100 30],'string','GABA','value',0,'tag','GABACB');
		uicontrol(cb,'position',   [skip+rightcol_left+middle top-row*9 100 30],'string','Sr2+','value',0,'tag','SRCB');
		uicontrol(cb,'position',   [skip+rightcol_left top-row*10 200 30],'string','Na Inactivation','value',1,'tag','NAINACTCB');

		uicontrol(button,'position',[skip+rightcol_left top-row*11 100-skip 30],'string','Run','tag','RunBt','userdata',0);
		uicontrol(button,'position',[skip+rightcol_left+middle+skip top-row*11 100-3*skip 30],'string','Pause','tag','PauseBt');

		set(fig,'userdata',ud);

	case 'GetParameters',
		p_struct.label = 'Parameters for HH model';
		tags = {...
			'RlCmEdit','RevEdit','ChannelConductancesEdit',... % cell parameters group
			'SynRevEdit','AMPA_Syn_Edit','NMDA_Syn_Edit','GABA_Syn_Edit', ... % synapse parameters group
			'StepValuesEdit','StepTimesEdit','SinAmpFEdit' ... % clamp parameters group
			};
		numels = [2 3 2 ...  % number of elements required
				2 3 3 3 ...
				2 2 2];

		for i=1:numel(tags),
			s = get(findobj(fig,'tag',tags{i}),'string');
			try,
				v = eval(s);
			catch,
				errordlg(['Syntax error in ' tags{i} ': cannot evaluate ' s '.']);
			end;
			if numel(v)~=numels(i),
				errordlg(['Value in ' tags{i} ' did not have expected number of elements (' int2str(numels(i)) ').']);
			end;
			p_struct = setfield(p_struct,tags{i},v);
		end;

		value_tags = { 'ClampPopup', 'TEACB', 'TTXCB', 'AMPACB', 'NMDACB', 'GABACB', 'SRCB', 'NAINACTCB' };
		for i=1:numel(value_tags),
			v = get(findobj(fig,'tag',value_tags{i}),'value');
			p_struct = setfield(p_struct,value_tags{i},v);
		end;

		varargout{1} = p_struct;
	case 'RunBt',
		if ud.HH.samplenumber_current <= 1 | ud.HH.samplenumber_current >= size(ud.HH.S,2) -1,
			p_struct = nbio140_wholecell('command','GetParameters','fig',fig);
			ud.HH.step1_time = p_struct.StepTimesEdit(1);
			ud.HH.step2_time = p_struct.StepTimesEdit(2);
			ud.HH.step1_value = p_struct.StepValuesEdit(1);
			ud.HH.step2_value = p_struct.StepValuesEdit(2);
			ud.HH = ud.HH.setup_current('A',p_struct.SinAmpFEdit(1),'f',p_struct.SinAmpFEdit(2));
			set(fig,'userdata',ud); % update userdata
		end;
		set(findobj(fig,'tag','RunBt'),'userdata',1);
		nbio140_wholecell('command','Step','fig',fig);
	case 'Step', % make a step in the simulation
		if get(findobj(fig,'tag','RunBt'),'userdata'),

			% Step 1: set parameters
				p_struct = nbio140_wholecell('command','GetParameters','fig',fig);
				ud.HH.G_L = 1/p_struct.RlCmEdit(1);
				ud.HH.G_Na = p_struct.ChannelConductancesEdit(1)*(1-p_struct.TTXCB);
				ud.HH.G_K = p_struct.ChannelConductancesEdit(2)*(1-p_struct.TEACB);
				ud.HH.E_leak = p_struct.RevEdit(1);
				ud.HH.E_K = p_struct.RevEdit(3);
				ud.HH.E_Na = p_struct.RevEdit(2);
				ud.HH.Na_Inactivation_Enable = p_struct.NAINACTCB;
				ud.HH.TTX = p_struct.TTX;
				ud.HH.TEA = p_struct.TEA;

			% Step 2: run 0.05 seconds

				ud.HH = ud.HH.simulate();

				set(fig,'userdata',ud);

				% in this preliminary mode, cancel the Run
				set(findobj(fig,'tag','RunBt'),'userdata',0);

			% Step 3: update the plot and axes

				ax_v = findobj(fig,'tag','VoltageAxes');
				axes(ax_v);
				myline = findobj(ax_v,'tag','VoltagePlot');
				if ~isempty(myline),
					set(myline,'xdata',ud.HH.t,'ydata',ud.HH.S(1,:));
				else,
					cla;
					h=plot(ud.HH.t, ud.HH.S(1,:),'k');
					box off;
					set(h,'tag','VoltagePlot');
				end;
				axis([ud.HH.t(1) ud.HH.t(end) -0.125 0.3]);
				set(ax_v,'tag','VoltageAxes');

				ax_i = findobj(fig,'tag','CurrentAxes');
				axes(ax_i);
				myline = findobj(ax_i,'tag','CurrentPlot');
				if ~isempty(myline),
					set(myline,'xdata',ud.HH.t,'ydata',ud.HH.I);
				else,
					cla;
					h=plot(ud.HH.t, ud.HH.I,'k');
					box off;
					set(h,'tag','CurrentPlot');
				end;
				axis([ud.HH.t(1) ud.HH.t(end) -1e-9 3e-9]);
				set(ax_i,'tag','CurrentAxes');
		end;
		% if we are still running, call Step again
		if get(findobj(fig,'tag','RunBt'),'userdata'),
			nbio140_wholecell('command','Step','fig',fig);
		end;
	case 'PauseBt',
		set(findobj(fig,'RunBt','userdata',0));
end;
