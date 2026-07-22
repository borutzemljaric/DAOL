function Qeg_0=load_scenario_1(t, time, Qe, Qe_g, Qe_breme, Qe_gg)

    % """
    % Calculate load over integration time
    % 
    % Parameters:
    % t: current time
    % time: object with s and d attributes (or dict with 's' and 'd' keys)
    % Qe: full weight  - additional load + conductor self-weight at start (t=0)
    % Qe_db: additional load at the end of simulation (remaining part of load after shedding -if exist!))
    % Qe_g: pure conductor and insulator
    % Qe_breme: additional load component (Qe-Qe_g) at the start of simulation which shed from conductor
    % Qe_gg: final load (conductor self-weight + final additional load that stays on conductor (if there is any!)
    % 
    % Returns:
    % Qeg_0: calculated load at time t
    % """


% določim breme v ?asu integracije
    if t<time.s  % before dynanamic start, for better graph readability
 Qeg_0=Qe;  % transient
     elseif t>=time.s && t<=time.d+time.s
Qeg_0=Qe_g+Qe_breme*(time.d+time.s-t)/time.d;
    else % remaining time after shedding 
Qeg_0=Qe_gg;  % v
    end