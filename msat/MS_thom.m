%   CIJ_THOM - generate elastic constants from Thomsen parameters
%
%   [C]=CIJ_thom(vp,vs,rh,eps,gam,del)
%
%   Inputs: 
%       rh  : Density (kg/m2 or g/cm3) (automatic conversion < 50) 
%       vp  : m/s or km/s (input is automatically to m/s converted if < 50)
%       vs  : m/s or km/s (input is automatically to m/s converted if < 50)
%       eps, gam, del : Dimensionless

function [C]=CIJ_thom(vp,vs,rh,eps,gam,del)

%  convert to assumed units
   if rh<50, rh=rh*1e3;, end
   if vp<50, vp=vp*1e3;, end
   if vs<50, vs=vs*1e3;, end
         
   C=zeros(6,6) ;
   C(3,3) = vp*vp ;
   C(4,4) = vs*vs ;
   C(6,6) = C(4,4)*(2.0*gam +1.0) ;
   C(1,1) = C(3,3)*(2.0*eps +1.0) ;
   
   btm = 2.0*C(4,4) ;
   term = C(3,3) - C(4,4) ;
   ctm = C(4,4)*C(4,4) - (2.0*del*C(3,3)*term + term*term) ;
   dsrmt = (btm*btm - 4.0*ctm) ;
   
	if dsrmt < 0
		error(['WARNING: S-velocity too high or delta ' ...
	          'too negative for Thomsen routine Re-input parameters']) ;
	end
   
   C(1,3) = -btm/2.0 + sqrt(dsrmt)/2.0 ;
   
   C(1,2) = C(1,1) - 2.0*C(6,6) ; 
   C(2,3) = C(1,3) ;
   C(5,5) = C(4,4) ;
   C(2,2) = C(1,1) ;

   % make symmetrical
   for i=1:6
      for j=i:6
         C(j,i) = C(i,j) ;
      end
   end

return