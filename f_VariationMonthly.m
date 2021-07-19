function f_VariationMonthly(ds,year,month,opt)
	%list =["RSW_MCD^"];
	%list =["RVIS_MCD^","RNIR_MCD^","RSW_MCD^","NDVI_MCD^","EMIS_MCD^","LAI_MCD_Filter^","FPAR_MCD_Filter^"];
	%list =["LAI_MCD_Filter^","FPAR_MCD_Filter^"];
	%list =["EMIS_MCD^"];
	
	year= double(year);
	month= double(month) ;
	% 0.05 degree
	if opt == 0
		series = nan(8774037,31,'single');
		for day = 1:31
			vec = datevec(datenum(year,month,day));
			if vec(2) == month
				doy = datenum(year,month,day) - datenum(year,1,1) + 1;
				try
					series(:,day) = importdata(sprintf('/bess19/Yulin/BESSv2/%s/%s.%d.%03d.mat',ds,ds,year,doy));
				end
			end
		end
		data = nanstd(series,1,2);        
	% 30 second
	elseif opt == 1
		avg = importdata(sprintf('/bess19/Yulin/BESSv2/%s_Monthly/%s_Monthly.%d.%02d.mat',ds,ds,year,month));
		sum = zeros(311724940,1,'single');
		cnt = zeros(311724940,1,'single');
		for day = 1:31
			vec = datevec(datenum(year,month,day));
			if vec(2) == month
				doy = datenum(year,month,day) - datenum(year,1,1) + 1;
				try
					raw = importdata(sprintf('/bess19/Yulin/BESSv2/%s/%s.%d.%03d.mat',ds,ds,year,doy));
					msk = isfinite(raw);
					cnt = cnt + single(msk);
					raw(~msk) = 0;
					sum = sum + (avg-raw).^2;
				end
			end
		end
		data = sqrt(sum./cnt); 
		data(cnt==0) = nan;
	% 0.05 degree with 8-day interval
	elseif opt == 2
		series = nan(8774037,4,'single');
		list = [1,9,17,25;
				33,41,49,57;
				65,73,81,89;
				97,105,113,121;
				121,129,137,145;
				153,161,169,177;
				185,193,201,209;
				217,225,233,241;
				241,249,257,265;
				273,281,289,297;
				305,313,321,329;
				337,345,353,361];
		for i = 1:4 
			doy = list(month,i);
			try
				series(:,i) = importdata(sprintf('/bess19/Yulin/BESSv2/%s/%s.%d.%03d.mat',ds,ds,year,doy));
			end
		end
		data = nanstd(series,1,2); 
	% 30 second with 8-day interval
	elseif opt == 3
		avg = importdata(sprintf('/bess19/Yulin/BESSv2/%s_Monthly/%s_Monthly.%d.%02d.mat',ds,ds,year,month));
		sum = zeros(311724940,1,'single');
		cnt = zeros(311724940,1,'single');
		list = [1,9,17,25;
				33,41,49,57;
				65,73,81,89;
				97,105,113,121;
				121,129,137,145;
				153,161,169,177;
				185,193,201,209;
				217,225,233,241;
				241,249,257,265;
				273,281,289,297;
				305,313,321,329;
				337,345,353,361];
		for i = 1:4
			doy = list(month,i);
			try
				raw = importdata(sprintf('/bess19/Yulin/BESSv2/%s/%s.%d.%03d.mat',ds,ds,year,doy));
				msk = isfinite(raw);
				cnt = cnt + single(msk);
				raw(~msk) = 0;
				sum = sum + (avg-raw).^2;
			end
		end
		data = sqrt(sum./cnt); 
		data(cnt==0) = nan;
	end

	% Write 
	mkdir(sprintf('/bess19/Yulin/BESSv2/%s_Monthly0/',ds))
	if isempty(strfind(ds,'_Daily'))
		save(sprintf('/bess19/Yulin/BESSv2/%s_Monthly0/%s_Monthly0.%d.%02d.mat',ds,ds,year,month),'data'); 
	else
		save(sprintf('/bess19/Yulin/BESSv2/%s_Monthly0/%s_Monthly0.%d.%02d.mat',ds(1:end-6),ds(1:end-6),year,month),'data'); 
	end
