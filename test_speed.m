tic
[a,b,c,d,e,f,g,h,i,j,k,l,m,n]=ndgrid(1:4);
O=[a(:),b(:),c(:),d(:),e(:),f(:),g(:),h(:),i(:),j(:),k(:),l(:),m(:),n(:)];
toc

tic
z = [1 2 3 4];
[aa,bb,cc,dd,ee,ff,gg,hh,ii,jj,kk,ll] = ndgrid(z,z,z,z,z,z,z,z,z,z,z,z);
P = [aa(:),bb(:),cc(:),dd(:),ee(:),ff(:),gg(:),hh(:),ii(:),jj(:),kk(:),ll(:)];
toc

tic
[Y{12:-1:1}] = ndgrid(1:4) ;
R = reshape(cat(12+1,Y{:}),[],12) ;
toc