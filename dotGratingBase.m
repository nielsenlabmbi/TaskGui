screenSize=[1920 1080];
diskSize=20; %in pixel

%get base coordinates for disk center
xvec=[1:diskSize:screenSize(1)-diskSize]+diskSize/2;
yvec=[1:diskSize:screenSize(2)-diskSize]+diskSize/2;

%now get entire grid
[xloc,yloc]=meshgrid(xvec,yvec);

%color
cbase=[0 0 1 1]; %2 rows or columns have the same color

ctempV=repmat(cbase,1,ceil(length(xvec)/length(cbase)));
ctempV=ctempV(1:length(xvec));
colorV=repmat(ctempV,length(yvec),1);

ctempH=repmat(cbase',ceil(length(yvec)/length(cbase)),1);
ctempH=ctempH(1:length(yvec));
colorH=repmat(ctempH,1,length(xvec));