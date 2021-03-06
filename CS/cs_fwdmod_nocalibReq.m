%% This is using forward model for maxent by 17th Feb 2017
% Signal is generated based on Rician Fading model, point scatterers.
% Removed SNR and calibration concept - Infinite SNR, Only signal from tag-obj-Rx.
% Last edit: March 07, 2017
% Pragya Sharma
function cs_fwdmod_nocalibReq()
    c = physconst('LightSpeed');
    f = 'f8';
    Ntag = 16; 
    Nrecv = 4;
    RCS = 0.1;
    object = 'var'; % Should be sparse object
    m = 1;
    shift_x = 0.0; 
    shift_y = 0.0;

    switch(f) 
        case 'f1'
            Freq = linspace(1.7,4.2,21)*1e9;
        case 'f3'
            Freq =(1.7:0.05:2.2)*1e9;               
        case 'f5'
            Freq = [1.79 2.03 2.2]*1e9; 
        case 'f6'
            Freq = 2e9;
        case 'f7'
            Freq = [1.8 2]*1e9;
        case 'f8'
            Freq = linspace(1.5,2.4,6)*1e9;
        otherwise
            display('Error in frequency');
    end
    Nfreq = length(Freq);
    Pos_tag = zeros(Ntag,2);
    switch(Ntag)
        case 32
            for i=1:Ntag/4
                Pos_tag(i, :)=[-0.35+(i-1)*0.1 -0.5] ;
            end
            for i=1:Ntag/4
                Pos_tag(i+(Ntag/4),:)=[0.5 -0.35+(i-1)*0.1] ;
            end
            for i=1:Ntag/4
                Pos_tag(i+(2*Ntag/4), :)=[-0.35+(i-1)*0.1 0.5] ;
            end
            for i=1:Ntag/4
                Pos_tag(i+(3*Ntag/4), :)=[-0.5 -0.35+(i-1)*0.1] ;
            end
        case 16     
            for i=1:Ntag/4
                Pos_tag(i, :)=[-0.3+(i-1)*0.2 -0.5] ;
            end
            for i=1:Ntag/4
                Pos_tag(i+(Ntag/4),:)=[0.5 -0.3+(i-1)*0.2] ;
            end
            for i=1:Ntag/4
                Pos_tag(i+(2*Ntag/4), :)=[-0.3+(i-1)*0.2 0.5] ;
            end
            for i=1:Ntag/4
                Pos_tag(i+(3*Ntag/4), :)=[-0.5 -0.3+(i-1)*0.2] ;
            end
        case 4
            Pos_tag = [-0.5,0.5;-0.1667,0.5;0.1667,0.5;0.5,0.5];
        otherwise
            disp('Error in Pos_tag');
    end
    Pos_recv = zeros(Nrecv,2);
    switch(Nrecv)
        case 1
            Pos_recv = [-0.5,-0.5];
        case 2
            Pos_recv = [-0.5,-0.5;0.5,-0.5];   
        case 4
            Pos_recv = [-0.5,-0.5;0.5,-0.5;0.5,0.5;-0.5,0.5];
        case 6
            Pos_recv(:,1) = linspace(-0.5,0.5,6);
            Pos_recv(:,2) = ones(Nrecv,1).*-0.5;
        case 16
            for i=1:Nrecv/4
                Pos_recv(i, :)=[-0.3+(i-1)*0.2 -0.5] ;
            end
            for i=1:Nrecv/4
                Pos_recv(i+(Nrecv/4),:)=[0.5 -0.3+(i-1)*0.2] ;
            end
            for i=1:Nrecv/4
                Pos_recv(i+(2*Nrecv/4), :)=[-0.3+(i-1)*0.2 0.5] ;
            end
            for i=1:Nrecv/4
                Pos_recv(i+(3*Nrecv/4), :)=[-0.5 -0.3+(i-1)*0.2] ;
            end

        otherwise
            disp('Error in Pos_recv');
    end
    figure;
    plot(Pos_tag(:,1),Pos_tag(:,2),'ro');
    hold on;
    plot(Pos_recv(:,1),Pos_recv(:,2),'bo','MarkerFaceColor','b','MarkerSize',8);
    hold on
    switch(object)
    case 'var'        
        Pos_s = [0.0, 0; 
                0.02, 0.25;
                -0.1, 0.06;
                0.18,0.12;
                -0.28,-0.25;
                0.3,-0.1;
                -0.08,-0.3;
                ]; 
    case 'var1'
        Pos_s = [-0.3494,-0.1063; -0.3392,-0.1063; -0.3392,-0.1165; -0.3494,-0.1165;
                0.0658,-0.0658; 0.0759,-0.0658; 0.0759,-0.0557; 0.0658,-0.0557;                
                0.1772,0.1063; 0.1873,0.1063; 0.1873,0.1165; 0.1772,0.1165;
                0.3089,-0.2684; 0.3190,-0.2684; 0.3190,-0.2582; 0.3089,-0.2582;
                0.2684,0.3190; 0.2582,0.3190; 0.2582,0.3089; 0.2684,0.3089;
                ]; 
    case 'var2'
        Pos_s = [-0.3443,-0.1114; 0.0708,-0.0607; 0.1823,0.1114; 0.3140,-0.2633; 0.2633, 0.3140];
    case 'box1'
        
        % Ns = 4
        Pos_s = [-0.05,-0.05;
                 0.05,-0.05;
                 0.05,0.05;
                 -0.05,0.05];
    otherwise 
        disp('Error in Pos_s');
    end
    Pos_s = m * Pos_s;
    [m1,~]=size(Pos_s);
    % Shifting Pos_s by k
    Pos_s = Pos_s - shift_x* [zeros(m1,1), ones(m1,1)];
    Pos_s = Pos_s - shift_y* [ones(m1,1), zeros(m1,1)];
    % Plotting object
    plot(Pos_s(:,1),Pos_s(:,2),'k*');
    axis 'square'
    axis 'tight'
    legend('Pos tag','Pos recv','Pos Scatterer');
    
    % Generate Rician Fading Factors
    Rician_Factor=zeros(Ntag,Nrecv,Nfreq);
    Rician_Factor(:,:,:) = 1;
    G_w_s=generation_signal_w_scatter(Freq,Pos_tag,Pos_recv,Pos_s,RCS,Rician_Factor);
    % generate signal after calibration 
    G_calib=G_w_s;
    assignin('base','G_calib',G_calib);

    %% Generate e == A matrix, G == y (y = Ax)
    Ngrid = 80;
    x_v = linspace(-0.4,0.4,Ngrid);
    y_v = x_v;
    lx = length(x_v);
    [X, Y] = meshgrid(x_v,y_v);
    P = combvec(x_v,y_v)';

    R1 = repmat(sqrt(sum(abs( repmat(permute(P, [1 3 2]), [1 Ntag 1]) ...
    - repmat(permute(Pos_tag, [3 1 2]), [lx*lx 1 1]) ).^2, 3)),1,Nrecv);
    dummy1 = ones(1,Ntag);
    R2 = kron(sqrt(sum(abs( repmat(permute(P, [1 3 2]), [1 Nrecv 1]) ...
    - repmat(permute(Pos_recv, [3 1 2]), [lx*lx 1 1]) ).^2, 3)), dummy1);
    R1 = repmat(R1,1,Nfreq); % All tag, recv, freq
    R2 = repmat(R2,1,Nfreq); % All tag, recv, freq
    dummy3 = ones(1,Ntag*Nrecv);
    Freq0 = repmat(kron(Freq,dummy3),[lx*lx 1]);
    e1 = exp(-1j*(2*pi/c)*(Freq0.*(R1+R2)));
    e_const = sqrt(RCS/(4*pi))*(1/(4*pi))*(c./(Freq0.*R1.*R2));
    e_fwd = e_const.*e1; 
    e_fwd = transpose(e_fwd); % == A matrix
    e = e_fwd;
    minfreq = min(Freq);
    e_bwd = transpose(((Freq0/minfreq).^2) .* e1); 
    V = reshape(G_calib,[],1); 
    B = e_bwd'*V; B = abs(B).^2;
    assignin('base','B',B);
    B = reshape(B, [lx lx]);
    figure;
    mesh(X,Y,B')
    axis ([-0.5 0.5 -0.5 0.5])
    axis 'square'
    xlabel('x-axis','FontSize',14)
    ylabel('y-axis','FontSize',14)
    view(0,90)
    assignin('base','e',e);
    assignin('base','V',V);
    assignin('base','e_bwd',e_bwd);
end

%% generating signal with scatterer 
function [G] = generation_signal_w_scatter(Freq_v,Pos_tag,Pos_recv,Pos_s,RCS,~)
c = physconst('LightSpeed');
[k1, ~] = size(Pos_tag);
[k2, ~] = size(Pos_recv);
[k3, ~] = size(Pos_s);
G = zeros(k1,k2,length(Freq_v));
for i = 1:length(Freq_v)
    for m = 1:k1
        for n = 1:k2
            freq = Freq_v(i);
            lamda = c/freq;
            p_tag = Pos_tag(m,:);
            p_recv = Pos_recv(n,:);
            for u = 1:k3
                p_s = Pos_s(u,:);
                r1 = norm(p_tag - p_s);
                r2 = norm(p_s - p_recv);
                G(m,n,i) = G(m,n,i) + sqrt(RCS/4/pi/r1^2)*lamda/(4*pi*r2)*exp(-1j*2*pi/lamda*(r1+r2));
            end
        end
    end
end
end


