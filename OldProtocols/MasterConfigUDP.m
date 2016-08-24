function MasterConfigUDP

% This function configures the master for udp connection to a slave

% Make DcomState a global variable
global DcomState

% FerretNotes (slave) IP address
rip = '172.30.11.111';

% close all open udp port objects on the same port and remove
% the relevant object form the workspace
port = instrfindall('RemoteHost',rip);
if ~isempty(port)
    fclose(port);
    delete(port);
    clear port;
end

% Create the UDP object
DcomState.serialPortHandle = udp(rip,'RemotePort',8866,'LocalPort',8844);
set(DcomState.serialPortHandle,'OutputBufferSize',1024)
set(DcomState.serialPortHandle,'InputBufferSize',1024)
set(DcomState.serialPortHandle,'Datagramterminatemode','off')

% Open and check status
fopen(DcomState.serialPortHandle);
stat = get(DcomState.serialPortHandle,'Status');
if ~strcmp(stat,'open')
    disp('Error: UDP port not open');
    DcomState.serialPortHandle=[];
end
