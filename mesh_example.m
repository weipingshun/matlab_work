a = -30:1:30;
[X,Y] = meshgrid(a);
Z=X.^2 - Y.^2;
mesh(X,Y,Z);
xlabel('x\in[-30,30]','fontweight','bold');
ylabel('y\in[-30,30]','fontweight','bold');
zlabel('Z=X^2 - Y^2','fontweight','bold');