%This code calculates monthly average data from daily or n-day data. ds =["Rg_MOD","Rg_MYD","Rs_Daily","Ta_MOD","Ta_MYD","Td_MOD","Td_MYD"......]; opt =0/1/2/3
	%list = ["Rg_MOD","Rg_MYD","Rs_Daily","Ta_MOD","Ta_MYD","Td_MOD","Td_MYD","NDVI_MCD^","EMIS_MCD^","LAI_MCD_Filter^","FPAR_MCD_Filter^"];
	%list =["GPP_Daily^","ET_Daily^"];
	%list =["LAI_MCD_Filter^","FPAR_MCD_Filter^"];
	%list =["RSW_MCD^","RVIS_MCD^","RSW_MCD^"];
	%list =["EMIS_MCD^"]
	%list =["Rs_AM","Rs_PM"]
	%list =["UV_ERA_AM","UV_ERA_PM","PARDir_AM","PARDir_ERA_PM","PARDiff_AM","PARDiff_ERA_PM","NIRDir_AM","NIRDir_ERA_PM","NIRDiff_AM","NIRDiff_ERA_PM"]
	%list =["Rg_MOD","Rg_MYD","Rs_Daily","Ta_MOD","Ta_MYD","Td_MOD","Td_MYD"]
	%list =["Vcmax25"]
	%list =["Rs_AM","Rs_PM"]

function f_AverageMonthly(ds,year,month,opt)
	year= double(year);
	month= double(month) ;
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
		data = nanmean(series,2);        
	% 30 second
	elseif opt == 1
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
					sum = sum + raw;
				end
			end
		end
		data = sum ./ cnt;
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
		data = nanmean(series,2); 
	% 30 second with 8-day interval
	elseif opt == 3
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
				sum = sum + raw;
			end
		end
		data = sum ./ cnt;
		data(cnt==0) = nan;
	end

	% Write 

	if isempty(strfind(ds,'_Daily')) 
		mkdir(sprintf('/bess19/Yulin/BESSv2/%s_Monthly',ds));
		save(sprintf('/bess19/Yulin/BESSv2/%s_Monthly/%s_Monthly.%d.%02d.mat',ds,ds,year,month),'data'); 
	else
		mkdir(sprintf('/bess19/Yulin/BESSv2/%s_Monthly',extractBefore(ds,"_Daily")));
		save(sprintf('/bess19/Yulin/BESSv2/%s_Monthly/%s_Monthly.%d.%02d.mat',extractBefore(ds,"_Daily"),extractBefore(ds,"_Daily"),year,month),'data');

	end

