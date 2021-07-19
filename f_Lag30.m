%list =["PAR_Daily","Ta_Daily","Td_Daily"];   

function f_Lag30(ds,year,month)
	year= double(year);
	month= double(month) ;

%     year = 2020;
%     month = 8;
%     ds = 'PAR_Daily'

    series = nan(8774037,30,'single');
		
	ds0 = strrep(ds,'Daily','Lag30'); 
	% for month = 1:12
	for month = month
		
		for day = 1:31
			vec = datevec(datenum(year,month,day));
			if vec(2) == month
				doy = datenum(vec) - datenum(year,1,1) + 1;
				series(:) = nan;
				sprintf('/bess19/Yulin/BESSv2/%s/%s.%d.%03d.mat',ds,ds,vec(1),doy)
				series(:,day) = importdata(sprintf('/bess19/Yulin/BESSv2/%s/%s.%d.%03d.mat',ds,ds,vec(1),doy));
				
				%for i = 1:30
					%vec_ = datevec(datetime(vec)-days(i));
					%doy_ = datenum(vec_) - datenum(vec_(1),1,1) + 1;
					%series(:,i) = importdata(sprintf('../%s/%s.%d.%03d.mat',ds,ds,vec_(1),doy_));
				%end
				
				data = nanmean(series,2);
				mkdir(sprintf('/bess19/Yulin/BESSv2/%s/',ds0));
				save(sprintf('/bess19/Yulin/BESSv2/%s/%s.%d.%03d.mat',ds0,ds0,year,doy),'data');
			end
		end
	end	

