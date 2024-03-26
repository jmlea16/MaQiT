function cmap=custom_colormap()

RGBneg=[95,0,0];
RGBcentre=[250,250,210];
RGBpos=[0,0,95];

cmap(1:128,1)=linspace(RGBneg(1),RGBcentre(1),128);
cmap(1:63,2)=0;
cmap(64:128,2)=linspace(RGBneg(2),RGBcentre(2),65);
cmap(1:63,3)=0;
cmap(64:128,3)=linspace(RGBneg(3),RGBcentre(3),65);

cmap(129:129+63,1)=linspace(RGBcentre(1),RGBpos(1),64);
cmap(129+64:256,1)=0;
cmap(129:129+63,2)=linspace(RGBcentre(2),RGBpos(2),64);
cmap(129+64:256,2)=0;
cmap(129:256,3)=linspace(RGBcentre(3),RGBpos(3),128);

cmap=cmap./numel(cmap(:,1));

end