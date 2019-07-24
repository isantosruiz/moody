function moody(my_epsilon,my_Re,epsilon_list)
%MOODY Plots the Moody chart
%
%   Syntax:
%      MOODY
%      MOODY(my_epsilon)
%      MOODY(my_epsilon,my_Re)
%      MOODY(my_epsilon,my_Re,epsilon_list)
%
%   Author:
%      Ildeberto de los Santos Ruiz
%      idelossantos@ittg.edu.mx
%
%   References:
%      [1] Moody, L. F. (1944), "Friction factors for pipe flow",
%          Transactions of the ASME, 66 (8): 671–684

clf
Re = logspace(2,8,1000);
if nargin > 0
    loglog(Re,friction(Re,my_epsilon*ones(size(Re))),...
        'LineWidth',1,'Color',[1,0.25,0]); hold on
    s = sprintf('$\\varepsilon=%8.6f$',my_epsilon);
    text(1.125e7,friction(Re(end),my_epsilon),strfix(s),...
        'VerticalAlignment','bottom','Interpreter','LaTeX',...
        'FontSize',8,'Color',[1,0.25,0])
end
if nargin < 3
    epsilon_list = [0,3e-6,1e-5,3e-5,1e-4,3e-4,1e-3,3e-3,1e-2,3e-2,1e-1];
end
for epsilon = epsilon_list
    loglog(Re,friction(Re,epsilon*ones(size(Re))),...
        'LineWidth',1,'Color',[0,0,0.5]); hold on
end
min_Re = 1e2;
max_Re = 1e8;
min_f = 0.005;
max_f = 0.2;
if nargin > 1
    my_f = friction(my_Re,my_epsilon);
    plot([min_Re,my_Re],[my_f,my_f],'LineStyle','--','Color',[1,0.5,0])
    plot([my_Re,my_Re],[min_f,my_f],'LineStyle','--','Color',[1,0.5,0])
    plot(my_Re,my_f,'Marker','.','MarkerSize',18,'Color','red')
end
grid on
xlabel('Reynolds number, $\mathrm{Re}$','Interpreter','LaTeX','FontSize',10)
ylabel('Friction factor, $f$','Interpreter','LaTeX','FontSize',10)
ylim([min_f,max_f])
xlim([min_Re,max_Re])
set(gca,'TickLabelInterpreter','LaTeX','FontSize',10,...
    'YTick',[0.005,0.01,0.02,0.05,0.1,0.2])
hold on
rectangle('Position',[2000,min_f,2000,max_f],...
    'LineStyle','--','EdgeColor',[0,0,0],'FaceColor',[0.75,0.75,0.75,0.5])
text(3000,0.011,'Critical zone','Interpreter','LaTeX',...
    'Rotation',90,'VerticalAlignment','middle','HorizontalAlignment','center','FontSize',10)
text(4000,0.011,'~Turbulent flow','Interpreter','LaTeX',...
    'VerticalAlignment','middle','HorizontalAlignment','left','FontSize',10)
text(2000,0.011,'Laminar flow~','Interpreter','LaTeX',...
    'VerticalAlignment','middle','HorizontalAlignment','right','FontSize',10)
yyaxis right
h = gca;
h.YTickMode = 'manual';
h.YLim = [min_f,max_f];
h.YScale = 'log';
h.YTick = friction(max_Re*ones(size(epsilon_list)),epsilon_list);
s = compose('$\\varepsilon=%8.6f$',epsilon_list);
for k = 1:length(s)
    s{k} = strfix(s{k});
end
h.YTickLabel = s;
h.TickLabelInterpreter = 'LaTeX';
h.YColor = [0,0,0.5];
h.FontSize = 8;
h.Position(3) = 0.75;
yyaxis left
hold off
    function f = friction(Re,epsilon)
        shape = size(Re);
        Re = Re(:);
        epsilon = epsilon(:);
        f = zeros(size(Re));
        for k = 1:numel(Re)
            if Re(k) > 3500
                f(k) = fzero(@(f) 1/sqrt(f)+2*log10(epsilon(k)/3.7+2.51/(Re(k)*sqrt(f))),[eps,1]);
            elseif Re(k) < 2500
                f(k) = 64/Re(k);
            else
                f(k) = NaN;
            end
        end
        f = reshape(f,shape);
    end
    function s = strfix(s)
        while contains(s,'0$')
            s = strrep(s,'0$','$');
        end
        s = strrep(s,'0.$','0$');
    end
end