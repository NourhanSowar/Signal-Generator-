%  ------------------------Inputs----------------------------------  
Sample_Freq=input('enter the sampling frequency of signal\n');
Start=input('enter the start time of the signal\n');
End=input('enter the end time of the signal\n');
Break_No=input('enter number of break points in the signal\n');

% ----------------Show the number of Regions needed to speicify---------
fprintf('your Number of regions is: %d \n' ,Break_No+1)

% -------------To scan pos of break points from user---------------------
if Break_No~=0
    for i=1:Break_No
       fprintf('enter the position of break points number (%d)\n',i)
        Entered_pos(i)=input('');
    end
elseif Break_No==0
end


%-----loop for break points and specific each region using Switch_Case----    
if Break_No~=0
       t=linspace(Start,End,(End-Start)*Sample_Freq);
       Signal=[];
       
 for i=1:Break_No+1
     
    Time=[Start Entered_pos End]  
    fprintf('Choose the region number on the left of the %dth  break point\n[1-DC ,2-Ramp,3-Poly,4-Exp ,5-Sin]\n',i)
    spec_No = input('1 2 3 4 5\n');              
    T=linspace(Time(i),Time(i+1),(Time(i+1)-Time(i))*Sample_Freq);              
    
    switch spec_No
        
        case 1  % DC Signal
            DC_Amplitude = input('Enter Amplitude of DC signal:  ');
            Spec_Signal=DC_Amplitude*ones(1, (Time(i+1)-Time(i))*Sample_Freq  );
            
        case 2 % Ramp
            Slope = input('Enter Slope of Ramp signal:  ');
            Intercept = input('Enter Intercept of Ramp signal:  ');
            Spec_Signal=Slope.*T+Intercept;
            
        case 3 % poly
            coefficient=[];
            Poly_Power = input('Enter Power of Poly signal:  ');
            for i = 1 : Poly_Power   
                a = input('put the coeff') ; 
                coefficient=[coefficient,a];
            end 
            Ploy_intersect = input('put the intersect');
            coefficient=[coefficient,Ploy_intersect ];
            Spec_Signal =  polyval(coefficient,T)  ;
        
        case 4 % Exponential
            EXP_Amplitude = input('Enter Amplitude of EXP signal:  ');
            Exponent = input('Enter Exponent of EXP signal:  ');
            Spec_Signal=EXP_Amplitude*exp(Exponent.*T);
            
        case 5 % sinsoidal
            SIN_Amplitude = input('Enter Amplitude of SIN signal:  ');
            SIN_Freq = input('Enter Amplitude of Freq signal:  ');
            SIN_Phase = input('Enter Amplitude of Phase signal(in degree):  ');
            Spec_Signal=SIN_Amplitude*sin(2*pi*SIN_Freq.*T+SIN_Phase*pi/180);
            
    end
    
    %-------Concatenate regions to each other to make it one signal-------
    Signal=[Signal,Spec_Signal];  
     
 end
 
  end 
 
%-------In case having no break points (having only one region)---------
 if Break_No==0
    t=linspace(Start,End,(End-Start)*Sample_Freq);
    fprintf('Choose the reqion number on the left of the %dth  break point\n[1-DC ,2-Ramp,3-Poly,4-Exp ,5-Sin]\n',i)
    spec_No = input('1 2 3 4 5\n');
   
    switch spec_No
        
        case 1  % DC Signal
            DC_Amplitude = input('Enter Amplitude of DC signal:  ');
            Signal=DC_Amplitude*ones(1,(End-Start)*Sample_Freq);
            
        case 2 % Ramp
            Slope = input('Enter Slope of Ramp signal:  ');
            Intercept = input('Enter Intercept of Ramp signal:  ');
            Signal=Slope.*t+Intercept;
        
        case 3 % poly
            coefficient=[];
            Poly_Power = input('Enter Power of Poly signal:  ');
            for i = 1 : Poly_Power   
            a = input('put the coeff') ; 
            coefficient=[coefficient,a];
            end
            Ploy_intersect = input('put the intersect');
            coefficient=[coefficient,Ploy_intersect ];
            Signal =  polyval(coefficient,t)  ;
        
        case 4 % Exponential
            EXP_Amplitude = input('Enter Amplitude of EXP signal:  ');
            Exponent = input('Enter Exponent of EXP signal:  ');
            Signal=EXP_Amplitude*exp(Exponent.*t);
            
        case 5 % sinsoidal
            SIN_Amplitude = input('Enter Amplitude of SIN signal:  ');
            SIN_Freq = input('Enter Amplitude of Freq signal:  ');
            SIN_Phase = input('Enter Amplitude of Phase signal(in degree):  ');
            Signal=SIN_Amplitude*sin(2*pi*SIN_Freq.*t+SIN_Phase*pi/180);
            
    end
 end
 
 %-Visualization the Signal which is vector contains all concatenated singals
 
 plot(t,Signal)

 
%--------------------Operations on Signal Vector------------------------

fprintf('Enter your operation\n [1-Amplitude Scaling 2-Time reversal 3-Time Shift 4-Expanding the signal 5-Compressing the signal 6-None]\n');

OP_NO=input('1 2 3 4 5 6\n');

if OP_NO==1 %%%%Amplitude Scaling
    Amp=input('enter the scale value:  ')
    Signal=Amp*Signal;

elseif OP_NO==2  %%%%Time  reversal
    t=linspace(-1*Start,-1*End,(End-Start)*Sample_Freq);
    
elseif OP_NO==3 %%%%Time  shift
    LR=input('Do yo want shift left or right (L=1/R=2)\n')
    
    if LR==2
        Shift=input('enter shift value : ');
        s=zeros(1,(End-Start)*Sample_Freq);
        s((Shift*Sample_Freq)+1:end) = Signal(1:end-(Shift*Sample_Freq));
        Signal=s;
    
    elseif LR==1
        Shift=input('enter shift value : ');
        s=zeros(1,(End-Start)*Sample_Freq);
        s(1:end-(Shift*Sample_Freq)) = Signal((Shift*Sample_Freq)+1:end);
        Signal=s;

    end    
    
elseif OP_NO==4 %%%%Expanding the signal
    Expand_Value=input('enter the expanding value(the value must be less than 1)\n ');
    t=linspace(Start/Expand_Value , End/Expand_Value ,(End-Start)*Sample_Freq);
    
elseif OP_NO==5 %%%%Compressing the signal
    Comp_Value=input('enter the compressing value (the value must be greater than 1)\n ');
    t=linspace(Start/Comp_Value ,End/Comp_Value ,(End-Start)*Sample_Freq);
else 
    %%%none
    
end

%--------Visualization  the signal after operation------------------------
figure;
plot(t,Signal)
