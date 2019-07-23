function moody
%MOODY Plots the Moody chart
%
%   Syntax:
%      MOODY
%
%   Author:
%      Ildeberto de los Santos Ruiz
%      idelossantos@ittg.edu.mx
%
%   References:
%      [1] Moody, L. F. (1944), "Friction factors for pipe flow",
%          Transactions of the ASME, 66 (8): 671–684

Re = logspace(2,8,1000);
for epsilon = [1e-5,3e-5,1e-4,3e-4,1e-3,3e-3,1e-2,3e-2]
    loglog(Re,friction(Re,epsilon*ones(size(Re))),...
        'LineWidth',1); hold on
    text(1.75e7,friction(Re(end),epsilon),...
        ['$\varepsilon=',sprintf('%7.5f',epsilon),'$'],...
        'VerticalAlignment','bottom','Interpreter','LaTeX',...
        'FontSize',8)
end
hold off
grid on
xlabel('Reynolds number, $\mathrm{Re}$','Interpreter','LaTeX','FontSize',10)
ylabel('Friction factor, $f$','Interpreter','LaTeX','FontSize',10)
ylim([0.007,0.2])
xlim([600,1e8])
set(gca,'TickLabelInterpreter','LaTeX','FontSize',10,...
    'YTick',[0.007,0.01,0.02,0.03,0.05,0.07,0.1,0.2])
hold on
rectangle('Position',[2000,0.023,2000,0.05],'Curvature',0.5,...
    'LineStyle','--','EdgeColor',[0.75,0.75,0.75],'FaceColor',[0.9,0.9,0.9,0.5])
text(3000,0.08,'Critical zone','Interpreter','LaTeX',...
    'HorizontalAlignment','center','FontSize',10)
    function f = friction(Re,epsilon)
        shape = size(Re);
        Re = Re(:);
        epsilon = epsilon(:);
        f = zeros(size(Re));
        for k = 1:numel(Re)
            if Re(k) >= 3500
                f(k) = fzero(@(f) 1/sqrt(f)+2*log10(epsilon(k)/3.7+2.51/(Re(k)*sqrt(f))),[eps,1]);
            elseif Re(k) <= 2500
                f(k) = 64/Re(k);
            else
                f(k) = NaN;
            end
        end
        f = reshape(f,shape);
    end
end